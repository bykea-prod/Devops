# Variables
variable "cidr_vpc" {}

variable "environment_tag" {}

variable "public_cidr_subnet" {}

variable "private_cidr_subnet" {}

variable "public_cidr_subnet_3" {}

variable "availability_zone_3" {}


variable "availability_zone_1" {}

variable "availability_zone" {}

variable "availability_zone_2" {
	
	type = "list"
}



variable "webserver_port" {}

variable "webserver_port_1" {}

variable "webserver_port_2" {}

variable "webserver_port_3" {}

variable "vpc_name" {}


variable "public_subnet_name" {}

variable "public_subnet_name_1" {}

variable "internet_gw_name" {}

variable "publicsubnet_rt__name" {}


variable "private_subnet_name" {}

variable "privatesubnet_rt__name" {}