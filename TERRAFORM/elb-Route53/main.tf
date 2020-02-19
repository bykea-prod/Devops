resource "aws_route53_record" "test-lb" {
  zone_id = "${var.zone_id}"
  name    = "${var.record_set_name}"
  type    = "A"
  
  alias {
    name    = "${var.dns_name}"
    zone_id = "${var.dns_zone_id}"
    evaluate_target_health = true
  }
}


