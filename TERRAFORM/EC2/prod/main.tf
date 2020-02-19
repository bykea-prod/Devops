module "infra-ec2" {
source = "../"

environment_tag = "development-env"
subnet_private = "subnet-03130eea5de81bb2b"
private_sg = "sg-070041c87fda25a86"
instance_ami = "ami-0dd83708552425e34"
instance_type = "t2.micro"
instance_name = "testing_server-1"
ec2_key = "available_key"
}
