module "infra-elb" {
source = "../"


instance_port = "8080"
instance_protocol = "tcp"
lb_port = "8080"
lb_protocol = "tcp"
ec2_private_id = "i-09dfb2b191a6f8c91"
subnet_private = "subnet-03130eea5de81bb2b"
environment_tag = "dev"

}
