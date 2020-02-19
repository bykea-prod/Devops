#create_vpc
resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_vpc}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags {
    "Environment" = "${var.environment_tag}"
  }
}
#create_publicsubnet
resource "aws_subnet" "subnet_public" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.public_cidr_subnet}"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.availability_zone}"
  tags {
    "Environment" = "${var.environment_tag}"
  }
}


#create_publicsubnet
resource "aws_subnet" "subnet_public_3" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.public_cidr_subnet_3}"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.availability_zone_3}"
  tags {
    "Environment" = "${var.environment_tag}"
  }
}
#create_internet_gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    "Environment" = "${var.environment_tag}"
  }
}
#create_public_subnet_route_table
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
#Associate_route_table_with_subnet_to_make_public_subnet
resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = "${aws_subnet.subnet_public.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

#create_privatesubnet
resource "aws_subnet" "subnet_private" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.private_cidr_subnet}"
  map_public_ip_on_launch = "false"
  availability_zone = "${var.availability_zone_1}"
  tags {
    "Environment" = "${var.environment_tag}"
  }
}

#create_EIP_for_private_NAT_instance

resource "aws_eip" "nat" {
vpc      = true
}

#Create Nat gateway
resource "aws_nat_gateway" "nat-gw" {
allocation_id = "${aws_eip.nat.id}"
subnet_id = "${aws_subnet.subnet_private.id}"
}

#create_private_route_table
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

#Associate_route_table_with_subnet_to_make_private_subnet

resource "aws_route_table_association" "rta_subnet_private" {
  subnet_id      = "${aws_subnet.subnet_private.id}"
  route_table_id = "${aws_route_table.rtb_private.id}"
}


#Private Security Group

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

#Public_Security_Group

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


#create_ec2_instance


resource "aws_instance" "ec2" 
{ 
  ami           = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.subnet_private.id}"
  vpc_security_group_ids = ["${aws_security_group.private_sg.id}"]
  key_name = "${var.ec2_key}" 


  tags {
  "Environment" = "${var.environment_tag}"
 }
   tags {
    key                 = "name"
    value               = "${var.name}"
    propagate_at_launch = true
  }
}


data "aws_route53_zone" "private" {
  private_zone = true
  vpc_id = "${aws_vpc.vpc.id}"
  #name = "example.dev"
  zone_id = "${aws_route53_zone.private.zone_id}"
}


resource "aws_route53_zone" "private" {
  name = "set.dev"
}


resource "aws_route53_record" "test" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "${aws_route53_zone.private.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ec2.private_ip}"]
}

resource "aws_route53_record" "test-lb" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "www.${aws_route53_zone.private.name}"
  type = "A"
  
  alias {
    name                   = "${aws_elb.main.dns_name}"
    zone_id                = "${aws_elb.main.zone_id}"
    evaluate_target_health = true
  }
}


resource "aws_elb" "main" {
  name               = "rabbit-terraform-elb"
  #availability_zones = ["${var.availability_zone_1}"]
  subnets = ["${aws_subnet.subnet_private.id}"]
  internal = true



  listener {
    instance_port     = "${var.instance_port}"
    instance_protocol = "${var.instance_protocol}"
    lb_port           = "${var.lb_port}"
    lb_protocol       = "${var.lb_protocol}"
  }

  listener {
    instance_port      = "${var.instance_port}"
    instance_protocol  = "${var.instance_protocol}"
    lb_port            = "${var.lb_port}"
    lb_protocol        = "${var.lb_protocol}"
    #ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = ["${aws_instance.ec2.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
  "Environment" = "${var.environment_tag}"
 }
}



resource "aws_autoscaling_group" "asg" {
  launch_configuration = "${aws_launch_configuration.asg.id}"
  vpc_zone_identifier = ["${aws_subnet.subnet_public.id}" , "${aws_subnet.subnet_public_3.id}"]
  name        = "${var.asg_name}"
  min_size = "${var.min_size}"
  max_size = "${var.max_size}"

}

resource "aws_launch_configuration" "asg" {
  image_id     = "${var.instance_ami}"
  security_groups = ["${aws_security_group.public_sg.id}"]
  iam_instance_profile  = "${var.iam_role}"
  key_name = "${var.ec2_key}"
  instance_type   = "${var.instance_type_1}"

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



#APPLICATION_LOADBALANCER

resource "aws_alb" "alb" {  
  name            = "${var.alb_name}"  
  subnets         = ["${aws_subnet.subnet_public.id}" , "${aws_subnet.subnet_public_3.id}"]
  security_groups = ["${aws_security_group.public_sg.id}"] 
  idle_timeout    = "100"   
  tags {    
    Name    = "${var.alb_name}"    
  }   
  access_logs {    
    bucket = "${var.s3_bucket}"    
    prefix = "ELB-logs"  
  }
}


resource "aws_alb_target_group" "alb_target_group" {  
  name     = "${var.target_group_name}"  
  port     = "${var.svc_port}"  
  protocol = "HTTP"  
  vpc_id   = "${aws_vpc.vpc.id}"   
  tags {    
    name = "${var.target_group_name}"    
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



resource "aws_lb_listener" "front_end_1" {
  load_balancer_arn = "${aws_alb.alb.arn}"
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


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "3000"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-west-1:539015419573:certificate/eec3a38e-3f39-423f-a8e6-4fbef1940d56"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = "${aws_autoscaling_group.asg.id}"
  alb_target_group_arn   = "${aws_alb_target_group.alb_target_group.arn}"
}