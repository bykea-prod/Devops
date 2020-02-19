resource "aws_instance" "ec2" 
{ 
  ami           = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_private}"
  vpc_security_group_ids = ["${var.private_sg}"]
  key_name = "${var.ec2_key}" 


  tags {
  "Environment" = "${var.environment_tag}"
 }
   tags {
    Name          = "${var.instance_name}"
  }
  connection {
    user        = "bykea"
    password = "${var.user_password}"
    port =  9221
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
        file_path = "${path.module}/provision/playbook.yml"
        #roles_path = ["/path1", "/path2"]
        force_handlers = false
        #ssh_opts= "-o StrictHostKeyChecking=no"
        #skip_tags = ["list", "of", "tags", "to", "skip"]
        #start_at_task = "task-name"
        #tags = ["list", "of", "tags"]
      }
      #hosts = ["aws_instance.ec2.*.private_ip"]
      #groups = ["deployment"]
      ansible_ssh_settings {
       connect_timeout_seconds = 10
       connection_attempts = 10
       ssh_keyscan_timeout = 60
       insecure_no_strict_host_key_checking = false
       #insecure_bastion_no_strict_host_key_checking = false
       #user_known_hosts_file = ""
       #bastion_user_known_hosts_file = ""
    }
    }
  }
}

