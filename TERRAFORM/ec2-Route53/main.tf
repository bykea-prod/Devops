resource "aws_route53_record" "test" {
  zone_id = "${var.zone_id}"
  name    = "${var.record_set_name}"
  type    = "A"
  ttl     = "300"
  records = ["${var.ec2_private_ip}"]
}




