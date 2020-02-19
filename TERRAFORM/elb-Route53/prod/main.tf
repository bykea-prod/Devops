module "infra-elb-r53" {
source = "../"

dns_name = "internal-rabbit-terraform-elb-928698080.eu-west-1.elb.amazonaws.com"
zone_id = "Z0053149L87OPWUTN518"
record_set_name = "elb"
dns_zone_id = "Z32O12XQLNTSW2"

}
