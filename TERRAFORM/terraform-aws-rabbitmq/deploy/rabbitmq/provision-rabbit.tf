# Define variables

variable "region" {}
variable "private_key_file" {}
variable "key_name" {}
variable "image_id" {}
variable "availability_zone" {}
variable "instance_types" {
  type = "map"
}

variable "num_instances" {
  type = "map"
}

# Configure the aws Provider
provider "aws" {
  region     = "${var.region}"
}

# Create rabbitmq
resource "aws_instance" "rabbitmq" {
  provider          = "aws"
  image_id          = "${var.image_id}"

  internet_charge_type  = "PayByBandwidth"

  instance_type        = "${var.instance_types["rabbitmq"]}"
  security_groups      = ["${aws_security_group.default.id}"]
  instance_name        = "rabbitmq"
  internet_max_bandwidth_out = "1"
  system_disk_category = "cloud_ssd"
  system_disk_size = "100"
  description          = "developer_native_compare=message"
  count = "${var.num_instances["rabbitmq"]}"
  key_name = "${aws_key_pair.key_pair.id}"
  tags {
    Name = "rabbitmq-${count.index}"
  }
}


# Create security group
resource "aws_security_group" "default" {
  name        = "default"
  provider    = "aws"
  description = "default"
}

resource "aws_security_group_rule" "allow_all_tcp" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "internet"
  policy            = "accept"
  port_range        = "1/65535"
  priority          = 1
  security_group_id = "${aws_security_group.default.id}"
  cidr_ip           = "0.0.0.0/0"
}

resource "aws_key_pair" "key_pair" {
  key_name = "${var.key_name}"
  key_file = "${var.private_key_file}"
}

output "client_ssh_host" {
  value = "${aws_instance.client.0.public_ip}"
}
