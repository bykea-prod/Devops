module "infra-ec2-r53" {
source = "../"

zone_id = ""
record_set_name = "test"
ec2_private_ip = "10.2.2.214"
}
