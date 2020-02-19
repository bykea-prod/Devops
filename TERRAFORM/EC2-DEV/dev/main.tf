module "infra-ec2" {
source = "../"

environment_tag = "development-env"
subnet_private = "subnet-2cf65976"
private_sg = "sg-0343e218cf43fb4f6"
instance_ami = "ami-0f16c5177bb6528a1"
instance_type = "t2.micro"
instance_name = "sandbox-1.1"
ec2_key = "available_key"
user_password = "Dev@Bykea"
}

