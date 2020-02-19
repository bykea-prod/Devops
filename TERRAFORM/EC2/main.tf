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
}


