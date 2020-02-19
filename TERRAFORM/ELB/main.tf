
resource "aws_elb" "main" {
  name               = "rabbit-terraform-elb"
  #availability_zones = ["${var.availability_zone_1}"]
  subnets = ["${var.subnet_private}"]
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

  instances                   = ["${var.ec2_private_id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
  "Environment" = "${var.environment_tag}"
 }
}



