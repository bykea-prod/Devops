# Variables
variable "cidr_vpc" {}
variable "environment_tag" {}
variable "public_cidr_subnet" {}
variable "private_cidr_subnet" {}
variable "availability_zone_1" {}
variable "availability_zone" {}
variable "availability_zone_2" {
	
	type = "list"
}
variable "instance_ami" {}
variable "instance_type" {}
variable "instance_name" {}
variable "webserver_port" {}
variable "webserver_port_1" {}
variable "webserver_port_2" {}
variable "webserver_port_3" {}
variable "region" {}
variable "name" {}
variable "instance_port" {}
variable "instance_protocol" {}
variable "lb_port" {}
variable "lb_protocol" {}
variable "asg_name" {}
variable "min_size" {}
variable "max_size" {}
variable "iam_role" {}
variable "instance_type_1" {}
variable "block_device" {
  type = "map"

  default = {
    type                  = "EC2"
    delete_on_termination = true
  }
}

variable "alb_name" {}
variable "s3_bucket" {}
variable "target_group_name" {}
variable "svc_port" {}
variable "target_group_sticky" {}
variable "target_group_path" {}
variable "target_group_port" {}

variable "public_cidr_subnet_3" {}

variable "availability_zone_3" {}

variable "ec2_key" {}
