### variable.tf
variable "aws_region" {
  description = "AWS region on which we will setup the rabbitmq cluster"
  default = "eu-west-1"
}
variable "aws_amis" {
  description = "Ubuntu 18.04 Base AMI to launch the instances"
  default = {
  eu-west-1 = "ami-0dd83708552425e34"
  }
}
variable "instance_type" {
  #description = "AWS region on which we will setup the rabbitmq cluster"
  default = "t2.micro"
}

variable "key_name" {
	default = "available_key"
}


#variable "aws_region" {}

variable "bootstrap_path" {
  description = "Script to install Docker Engine"
  default = "install_docker_machine_compose.sh"
}
