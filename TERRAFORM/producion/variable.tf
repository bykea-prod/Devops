# Variables
variable "cidr_vpc" {}

variable "environment_tag" {}

variable "vpc_name" {}

variable "public_cidr_subnet" {}

variable "availability_zone" {}

variable "subnet_name" {}

variable "public_cidr_subnet_3" {}

variable "availability_zone_3" {}

variable "subnet_name_1" {}

variable "igw_name" {}

variable "pubsubnet_rt_name" {}

variable "private_cidr_subnet" {}

variable "availability_zone_1" {}

variable "prisubnet_name" {}

variable "private_cidr_subnet_1" {}


variable "prisubnet_name_1" {}



variable "private_rt_name_1" {}

variable "webserver_port" {}

#variable "cidr_vpc" {}

variable "webserver_port_1" {}

variable "webserver_port_2" {}

variable "webserver_port_3" {}

variable "instance_ami_mongo" {}

variable "instance_type" {}

variable "ec2_key" {}

variable "ec2_mongo_name" {}


variable "instance_ami_mongo_sec" {}

variable "ec2_mongo_name_sec" {}

variable "instance_ami_redis" {}

variable "instance_type_redis" {}


variable "ec2_redis_name_app" {}

variable "ec2_redis_name_app2" {}

variable "instance_ami_rabbit" {}

variable "instance_type_rabbit" {}

variable "ec2_rabbit_name" {}

variable "instance_ami_eslb" {}

variable "instance_type_eslb" {}

variable "ec2_eslb_name" {}


#variable "asg_name" {}

variable "min_size_app" {}

variable "max_size_app" {}

variable "instance_ami_app" {}

variable "iam_role" {}

variable "instance_type_app" {}

variable "block_device" {
  type = "map"

  default = {
    type                  = "EC2"
    delete_on_termination = true
  }
}


variable "min_size_app2" {}

variable "max_size_app2" {}

variable "instance_ami_app2" {}

variable "instance_type_app2" {}

variable "asg_name_app" {}

variable "asg_name_app2" {}

variable "asg_name_app3" {}

variable "min_size_app3" {}

variable "max_size_app3" {}

variable "instance_ami_app3" {}

variable "instance_type_app3" {}

variable "app_alb_name" {}

variable "s3_bucket" {} 

variable "target_group_name_app" {}

variable "app_port" {}

variable "target_group_sticky" {}

variable "target_group_path" {}

variable "target_group_port" {}

variable "app2_alb_name" {}

variable "target_group_name_app2" {}

variable "app2_port" {}

variable "target_group_path_1" {}

variable "target_group_port_1" {}

variable "app3_alb_name" {}

variable "target_group_name_app3" {}

variable "app3_port" {}

variable "target_group_path_2" {}

variable "target_group_port_2" {}

variable "record_set_name_app_redis" {}

variable "record_set_name_app2_redis" {}

variable "record_set_name_app_mongomaster" {}

variable "record_set_name_app_mongosecondary" {}

variable "record_set_name_app_rabbit" {}

variable "record_set_name_app3_es" {}





