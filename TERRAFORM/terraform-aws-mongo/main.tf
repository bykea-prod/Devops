data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "mongodb" {
  #availability_zone = "${var.availability_zone}"
  subnet_id = "${var.subnet_public}"

  tags {
    Name = "mongodb"
  }

  ami           = "${var.instance_ami}"
  instance_type = "${var.instance_type}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.volume_size}"
  }

  key_name = "${var.key_name}"
  associate_public_ip_address = true
  security_groups = ["${var.security_groups}"]

  connection {
    user        = "ubuntu"
    private_key = "${var.private_key}"
  }

  provisioner "file" {
    source      = "${path.module}/provision/wait-for-cloud-init.sh"
    destination = "/tmp/wait-for-cloud-init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/wait-for-cloud-init.sh",
      "/tmp/wait-for-cloud-init.sh",
    ]
  }

  provisioner "ansible" {
    plays {
      playbook {
        file_path = "${path.module}/provision/playbook.yaml"
        #roles_path = ["/path1", "/path2"]
        force_handlers = false
        #skip_tags = ["list", "of", "tags", "to", "skip"]
        #start_at_task = "task-name"
        #tags = ["list", "of", "tags"]
      }
      #hosts = ["aws_instance.ec2.*.private_ip"]
      groups = ["db-mongodb"]
    }
  }
}