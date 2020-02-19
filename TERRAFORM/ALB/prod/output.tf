output "instance_ip_addr" {
  value = "aws_instance.ec2.private_ip"
}


output "instance_ip_addr" {
  value = "aws_instance.mongoec2.private_ip"
}

output "instance_ip_addr" {
  value = "aws_instance.rabbitm0ec2.private_ip"
}


output "instance_ip_addr" {
  value = "aws_instance.rabbitm1ec2.private_ip"
}

output "instance_ip_addr" {
  value = "aws_instance.redisappec2.private_ip"
}

output "instance_ip_addr" {
  value = "aws_instance.redisapp3ec2.private_ip"
}

output "instance_ip_addr" {
  value = "aws_instance.eslbm0.private_ip"
}

output "instance_ip_addr" {
  value = "aws_instance.eslbm1.private_ip"
}

output "instance_ip_addr" {
  value = "aws_instance.eslbm2.private_ip"
}


output "instance_ip_addr" {
  value = "aws_instance.eselkm0.private_ip"
}

output "instance_ip_addr" {
  value = "aws_instance.eselkm1.private_ip"
}


output "instance_ip_addr" {
  value = "aws_instance.eselkm2.private_ip"
}

output "zone_id" {
  value       = "aws_route53_zone.private.zone_id"
  description = "Route53 DNS Zone ID"
}