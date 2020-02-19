#providers
provider "aws" {
    access_key = "AKIAX276SS22QV7MFQ4B"
    secret_key = "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"
    region = "eu-west-1"
}


resource "aws_instance" "node1" {
    ami               = "${lookup(var.aws_amis, var.aws_region)}"
    instance_type     = "${var.instance_type}"
    key_name          = "${var.key_name}"
    # user_data         = "${file("${var.bootstrap_path}")}"
    associate_public_ip_address = true
    vpc_security_group_ids = ["${aws_security_group.rabbitsg.id}"]
    tags = {
        Name  = "rabbit-node1"
      }
}
resource "aws_instance" "node2" {
    ami               = "${lookup(var.aws_amis, var.aws_region)}"
    instance_type     = "${var.instance_type}"
    key_name          = "${var.key_name}"
    # user_data         = "${file("${var.bootstrap_path}")}"
    associate_public_ip_address = true
    vpc_security_group_ids = ["${aws_security_group.rabbitsg.id}"]
    tags = {
        Name  = "rabbit-node2"
      }
}
resource "aws_instance" "node3" {
    ami               = "${lookup(var.aws_amis, var.aws_region)}"
    instance_type     = "${var.instance_type}"
    key_name          = "${var.key_name}"
    # user_data         = "${file("${var.bootstrap_path}")}"
    associate_public_ip_address = true
    vpc_security_group_ids = ["${aws_security_group.rabbitsg.id}"]
    tags = {
        Name  = "rabbit-node3"
      }
}
