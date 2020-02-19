module "infra-vpc" {
source = "../"

environment_tag = "development-env"

vpc_name = "staging-vpc"

cidr_vpc    = "10.2.0.0/16"

public_cidr_subnet = "10.2.0.0/24"

public_subnet_name = "staging-public-subnet-1"

public_subnet_name_1 = "staging-public-subnet-2"

internet_gw_name = "igw-staging"

publicsubnet_rt__name = "staging-publicsubnet-rt"

private_subnet_name = "staging-private-subnet"

privatesubnet_rt__name = "staging-privatesubnet-rt"

availability_zone = "eu-west-1a"

private_cidr_subnet = "10.2.2.0/24"

public_cidr_subnet_3 = "10.2.3.0/24"

availability_zone_3 = "eu-west-1c"

availability_zone_1 = "eu-west-1b"

availability_zone_2 = ["eu-west-1a" , "eu-west-1c"]


webserver_port = "0"

webserver_port_1 = "443"

webserver_port_2 = "80"

webserver_port_3 = "3000" 

}
