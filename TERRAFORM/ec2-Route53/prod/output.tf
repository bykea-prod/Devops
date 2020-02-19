output "instance_ip_addr" {
  value = "aws_instance.ec2.private_ip"
}

output "zone_id" {
  value       = "aws_route53_zone.private.zone_id"
  description = "Route53 DNS Zone ID"
}