##########################create_vpc##########################

resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_vpc}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags {
    "Environment" = "${var.environment_tag}"
  }

  tags = {
    Name = "${var.vpc_name}"
  }
  
}




#######################create_publicsubnet#############################

resource "aws_subnet" "subnet_public" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.public_cidr_subnet}"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.availability_zone}"
  tags {
    "Environment" = "${var.environment_tag}"
  }

  tags = {
    Name = "${var.subnet_name}"
  }


}


##################################create_publicsubnet###########################

resource "aws_subnet" "subnet_public_3" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.public_cidr_subnet_3}"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.availability_zone_3}"
  tags {
    "Environment" = "${var.environment_tag}"
  }
}

#########################create_internet_gateway####################

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    "Environment" = "${var.environment_tag}"
  }
}
#################create_public_subnet_route_table#######################

resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    "Environment" = "${var.environment_tag}"
  }
}

#####################Associate_route_table_with_subnet_to_make_public_subnet#################

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = "${aws_subnet.subnet_public.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

############################create_privatesubnet########################

resource "aws_subnet" "subnet_private" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.private_cidr_subnet}"
  map_public_ip_on_launch = "false"
  availability_zone = "${var.availability_zone_1}"
  tags {
    "Environment" = "${var.environment_tag}"
  }
}

##############################create_privatesubnet##################################

resource "aws_subnet" "subnet_private_1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.private_cidr_subnet_1}"
  map_public_ip_on_launch = "false"
  availability_zone = "${var.availability_zone}"
  tags {
    "Environment" = "${var.environment_tag}"
  }
}

##########################create_EIP_for_private_NAT_instance######################

resource "aws_eip" "nat" {
vpc      = true
}

######################Create Nat gateway#############################

resource "aws_nat_gateway" "nat-gw" {
allocation_id = "${aws_eip.nat.id}"
subnet_id = "${aws_subnet.subnet_private.id}"
}

############################create_private_route_table####################

resource "aws_route_table" "rtb_private" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_nat_gateway.nat-gw.id}"
  }

  tags {
    "Environment" = "${var.environment_tag}"
  }
}

####################Associate_route_table_with_subnet_to_make_private_subnet######################

resource "aws_route_table_association" "rta_subnet_private" {
  subnet_id      = "${aws_subnet.subnet_private.id}"
  route_table_id = "${aws_route_table.rtb_private.id}"
}


##################################AWS_MAIN_ROUTETABLE_ASSOCIATION##################################

resource "aws_main_route_table_association" "vpc_route" {
  vpc_id         = "${aws_vpc.vpc.id}"
  route_table_id = "${aws_route_table.rtb_private.id}"
}

######################Private Security Group####################

resource "aws_security_group" "private_sg" 
{
  name = "private-sg"
  vpc_id = "${aws_vpc.vpc.id}"  


  ingress {
      from_port   = "${var.webserver_port}"
      to_port     = "${var.webserver_port}"
      protocol    = "-1"
      cidr_blocks = ["${var.cidr_vpc}"]
  } 


  egress {
    from_port   = "${var.webserver_port}"
    to_port     = "${var.webserver_port}"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  tags {
    "Environment" = "${var.environment_tag}"
  }
}

#######################Public_Security_Group######################

resource "aws_security_group" "public_sg" {
  name = "public-sg"
  vpc_id = "${aws_vpc.vpc.id}"  


  ingress {
      from_port   = "${var.webserver_port_1}"
      to_port     = "${var.webserver_port_1}"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress {
      from_port   = "${var.webserver_port_2}"
      to_port     = "${var.webserver_port_2}"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress {
      from_port   = "${var.webserver_port_3}"
      to_port     = "${var.webserver_port_3}"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 


  egress {
    from_port   = "${var.webserver_port}"
    to_port     = "${var.webserver_port}"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  tags {
    "Environment" = "${var.environment_tag}"
  }
}

###########################CREATE_MONGODB_MASTER###########


resource "aws_instance" "mongoec2" 
{ 
  ami           = "${var.instance_ami_mongo}"  
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.subnet_private.id}"
  vpc_security_group_ids = ["${aws_security_group.private_sg.id}"]
  key_name = "${var.ec2_key}" 


  tags {
  "Environment" = "${var.environment_tag}"
 }
   tags {
    Name          = "${var.ec2_mongo_name}"
  }
}


############CREATE_REDIS_app###########


resource "aws_instance" "redisappec2" 
{ 
  ami           = "${var.instance_ami_redis}"  
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.subnet_private.id}"
  vpc_security_group_ids = ["${aws_security_group.private_sg.id}"]
  key_name = "${var.ec2_key}" 


  tags {
  "Environment" = "${var.environment_tag}"
 }
   tags {
    Name          = "${var.ec2_redis_name_app}"
  }
}


########################CREATE_REDIS_app3##############################


resource "aws_instance" "redisapp3ec2" 
{ 
  ami           = "${var.instance_ami_redis}"  
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.subnet_private.id}"
  vpc_security_group_ids = ["${aws_security_group.private_sg.id}"]
  key_name = "${var.ec2_key}" 


  tags {
  "Environment" = "${var.environment_tag}"
 }
   tags {
    Name          = "${var.ec2_redis_name_app3}"
  }
}



##############################CREATE_PRIVATE_HOSTED_ZONE#########################

resource "aws_route53_zone" "private" {
  name = "example.com"


  vpc {
     vpc_id = "${aws_vpc.vpc.id}"
  }
}




######################Route53_Mapping_On_app_Redis#############################

resource "aws_route53_record" "appredis" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "${aws_route53_zone.private.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.redisappec2.private_ip}"]
}


########################################Route53_Mapping_On_app3_Redis####################################

resource "aws_route53_record" "appredis" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "${aws_route53_zone.private.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.redisapp3ec2.private_ip}"]
}


##############################Route53_Mapping_On_app_MongoMaster#######################################

resource "aws_route53_record" "appmongo" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "${aws_route53_zone.private.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.mongoec2.private_ip}"]
}


#resource "aws_route53_record" "test-lb" {
#  zone_id = "${aws_route53_zone.private.zone_id}"
#  name    = "www.${aws_route53_zone.private.name}"
 # type = "A"
  
#  alias {
#    name                   = "${aws_elb.main.dns_name}"
#    zone_id                = "${aws_elb.main.zone_id}"
#    evaluate_target_health = true
 # }
#}

########################ROUTE53_MAPPING_ELB_RABBITMQ############################################


resource "aws_route53_record" "rabbitmq-lb" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "rabbit.${aws_route53_zone.private.name}"
  type = "A"
  
  alias {
    name                   = "${aws_elb.rabbitmqelb.dns_name}"
    zone_id                = "${aws_elb.rabbitmqelb.zone_id}"
    evaluate_target_health = true
  }
}




########################ROUTE53_MAPPING_ELB_LOADBOAR_ES############################################


resource "aws_route53_record" "eslb" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "rabbit.${aws_route53_zone.private.name}"
  type = "A"
  
  alias {
    name                   = "${aws_elb.lbelasticsearchelb.dns_name}"
    zone_id                = "${aws_elb.lbelasticsearchelb.zone_id}"
    evaluate_target_health = true
  }
}



########################ROUTE53_MAPPING_ELB_LOADBOAR_ES############################################


resource "aws_route53_record" "eselk" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "rabbit.${aws_route53_zone.private.name}"
  type = "A"
  
  alias {
    name                   = "${aws_elb.elkelasticsearchelb.dns_name}"
    zone_id                = "${aws_elb.elkelasticsearchelb.zone_id}"
    evaluate_target_health = true
  }
}



###################AUTOSCALING_GROUP_app########################



resource "aws_autoscaling_group" "appasg" {
  launch_configuration = "${aws_launch_configuration.appasg.id}"
  vpc_zone_identifier = ["${aws_subnet.subnet_private.id}" , "${aws_subnet.subnet_private_1.id}"]
  name        = "${var.asg_name}"
  min_size = "${var.min_size_app}"
  max_size = "${var.max_size_app}"

}


###################LAUNCH_CONFIGURATION_app########################


resource "aws_launch_configuration" "appasg" {
  image_id     = "${var.instance_ami_app}"
  security_groups = ["${aws_security_group.private_sg.id}"]
  iam_instance_profile  = "${var.iam_role}"
  key_name = "${var.ec2_key}"
  instance_type   = "${var.instance_type_app}"

  ebs_block_device {
    device_name           = "${lookup(var.block_device, "device_name", "/dev/xvdf")}"
    volume_type           = "${lookup(var.block_device, "volume_type", "gp2")}"
    volume_size           = "${lookup(var.block_device, "volume_size", 150)}"
    delete_on_termination = "${lookup(var.block_device, "delete_on_termination", true)}"
  }

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size = "150"
    volume_type = "gp2"
  }
}



###################AUTOSCALING_GROUP_app3########################



resource "aws_autoscaling_group" "app3asg" {
  launch_configuration = "${aws_launch_configuration.app3asg.id}"
  vpc_zone_identifier = ["${aws_subnet.subnet_private.id}" , "${aws_subnet.subnet_private_1.id}"]
  name        = "${var.asg_name}"
  min_size = "${var.min_size_app3}"
  max_size = "${var.max_size_app3}"

}


###################LAUNCH_CONFIGURATION_app3########################


resource "aws_launch_configuration" "app3asg" {
  image_id     = "${var.instance_ami_app3}"
  security_groups = ["${aws_security_group.private_sg.id}"]
  iam_instance_profile  = "${var.iam_role}"
  key_name = "${var.ec2_key}"
  instance_type   = "${var.instance_type_app3}"

  ebs_block_device {
    device_name           = "${lookup(var.block_device, "device_name", "/dev/xvdf")}"
    volume_type           = "${lookup(var.block_device, "volume_type", "gp2")}"
    volume_size           = "${lookup(var.block_device, "volume_size", 150)}"
    delete_on_termination = "${lookup(var.block_device, "delete_on_termination", true)}"
  }

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size = "150"
    volume_type = "gp2"
  }
}

###################AUTOSCALING_GROUP_app2########################



resource "aws_autoscaling_group" "app2asg" {
  launch_configuration = "${aws_launch_configuration.app2asg.id}"
  vpc_zone_identifier = ["${aws_subnet.subnet_private.id}" , "${aws_subnet.subnet_private_1.id}"]
  name        = "${var.asg_name}"
  min_size = "${var.min_size_app2}"
  max_size = "${var.max_size_app2}"

}


###################LAUNCH_CONFIGURATION_app2########################


resource "aws_launch_configuration" "app2asg" {
  image_id     = "${var.instance_ami_app2}"
  security_groups = ["${aws_security_group.private_sg.id}"]
  iam_instance_profile  = "${var.iam_role}"
  key_name = "${var.ec2_key}"
  instance_type   = "${var.instance_type_app2}"

  ebs_block_device {
    device_name           = "${lookup(var.block_device, "device_name", "/dev/xvdf")}"
    volume_type           = "${lookup(var.block_device, "volume_type", "gp2")}"
    volume_size           = "${lookup(var.block_device, "volume_size", 150)}"
    delete_on_termination = "${lookup(var.block_device, "delete_on_termination", true)}"
  }

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size = "150"
    volume_type = "gp2"
  }
}


###################APPLICATION_LOADBALANCER_app########################

resource "aws_alb" "appalb" {  
  name            = "${var.app_alb_name}"  
  subnets         = ["${aws_subnet.subnet_public.id}" , "${aws_subnet.subnet_public_3.id}"]
  security_groups = ["${aws_security_group.public_sg.id}"] 
  idle_timeout    = "100"   
  tags {    
    Name    = "${var.app_alb_name}"    
  }   
  access_logs {    
    bucket = "${var.s3_bucket}"    
    prefix = "ELB-logs"  
  }
}



resource "aws_alb_target_group" "alb_target_group_app" {  
  name     = "${var.target_group_name_app}"  
  port     = "${var.app_port}"  
  protocol = "HTTP"  
  vpc_id   = "${aws_vpc.vpc.id}"   
  tags {    
    name = "${var.target_group_name_app}"    
  }   
  stickiness {    
    type            = "lb_cookie"    
    cookie_duration = 86400    
    enabled         = "${var.target_group_sticky}"  
  }   
  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    path                = "${var.target_group_path}"    
    port                = "${var.target_group_port}"  
  }
}



resource "aws_lb_listener" "front_end_1_app" {
  load_balancer_arn = "${aws_alb.appalb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "3000"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      
    }
  }
}


resource "aws_lb_listener" "front_end_app" {
  load_balancer_arn = "${aws_alb.appalb.arn}"
  port              = "3000"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-west-1:539015419573:certificate/eec3a38e-3f39-423f-a8e6-4fbef1940d56"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_target_group_app.arn}"
  }
}


###################APPLICATION_LOADBALANCER_app_TO_ASG_app########################

resource "aws_autoscaling_attachment" "asg_attachment_app" {
  autoscaling_group_name = "${aws_autoscaling_group.appasg.id}"
  alb_target_group_arn   = "${aws_alb_target_group.alb_target_group_app.arn}"
}



###################APPLICATION_LOADBALANCER_app3########################

resource "aws_alb" "app3alb" {  
  name            = "${var.app3_alb_name}"  
  subnets         = ["${aws_subnet.subnet_public.id}" , "${aws_subnet.subnet_public_3.id}"]
  security_groups = ["${aws_security_group.public_sg.id}"] 
  idle_timeout    = "100"   
  tags {    
    Name    = "${var.app3_alb_name}"    
  }   
  access_logs {    
    bucket = "${var.s3_bucket}"    
    prefix = "ELB-logs"  
  }
}



resource "aws_alb_target_group" "alb_target_group_app3" {  
  name     = "${var.target_group_name_app3}"  
  port     = "${var.app3_port}"  
  protocol = "HTTP"  
  vpc_id   = "${aws_vpc.vpc.id}"   
  tags {    
    name = "${var.target_group_name_app3}"    
  }   
  stickiness {    
    type            = "lb_cookie"    
    cookie_duration = 86400    
    enabled         = "${var.target_group_sticky}"  
  }   
  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    path                = "${var.target_group_path}"    
    port                = "${var.target_group_port}"  
  }
}



resource "aws_lb_listener" "front_end_1_app3" {
  load_balancer_arn = "${aws_alb.app3alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "3000"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      
    }
  }
}


resource "aws_lb_listener" "front_end_app3" {
  load_balancer_arn = "${aws_alb.app3alb.arn}"
  port              = "3000"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-west-1:539015419573:certificate/eec3a38e-3f39-423f-a8e6-4fbef1940d56"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_target_group_app3.arn}"
  }
}


###################APPLICATION_LOADBALANCER_app3_TO_ASG_app3########################

resource "aws_autoscaling_attachment" "asg_attachment_app3" {
  autoscaling_group_name = "${aws_autoscaling_group.app3asg.id}"
  alb_target_group_arn   = "${aws_alb_target_group.alb_target_group_app3.arn}"
}

###################APPLICATION_LOADBALANCER_app2########################

resource "aws_alb" "app2alb" {  
  name            = "${var.app2_alb_name}"  
  subnets         = ["${aws_subnet.subnet_public.id}" , "${aws_subnet.subnet_public_3.id}"]
  security_groups = ["${aws_security_group.public_sg.id}"] 
  idle_timeout    = "100"   
  tags {    
    Name    = "${var.app2_alb_name}"    
  }   
  access_logs {    
    bucket = "${var.s3_bucket}"    
    prefix = "ELB-logs"  
  }
}



resource "aws_alb_target_group" "alb_target_group_app2" {  
  name     = "${var.target_group_name_app2}"  
  port     = "${var.app2_port}"  
  protocol = "HTTP"  
  vpc_id   = "${aws_vpc.vpc.id}"   
  tags {    
    name = "${var.target_group_name_app2}"    
  }   
  stickiness {    
    type            = "lb_cookie"    
    cookie_duration = 86400    
    enabled         = "${var.target_group_sticky}"  
  }   
  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    path                = "${var.target_group_path}"    
    port                = "${var.target_group_port}"  
  }
}



resource "aws_lb_listener" "front_end_1_app2" {
  load_balancer_arn = "${aws_alb.app2alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "3000"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      
    }
  }
}


resource "aws_lb_listener" "front_end_app2" {
  load_balancer_arn = "${aws_alb.app2alb.arn}"
  port              = "3000"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-west-1:539015419573:certificate/eec3a38e-3f39-423f-a8e6-4fbef1940d56"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_target_group_app2.arn}"
  }
}


###################APPLICATION_LOADBALANCER_app2_TO_ASG_app2########################

resource "aws_autoscaling_attachment" "asg_attachment_app2" {
  autoscaling_group_name = "${aws_autoscaling_group.app2asg.id}"
  alb_target_group_arn   = "${aws_alb_target_group.alb_target_group_app2.arn}"
}



