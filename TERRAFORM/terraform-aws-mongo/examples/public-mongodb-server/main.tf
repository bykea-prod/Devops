provider "aws" {
  access_key = ""
  secret_key = ""
  region = "eu-west-1"
}

resource "aws_key_pair" "mongodb" {
  key_name   = "mongo-key"
  public_key = "${file("${path.module}/keys/mongodb.pub")}"
}

resource "aws_security_group" "mongodb" {
  name        = "mongodb"
  description = "Allow all inbound SSH and MongoDB traffic."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    description = "MongoDB access"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "MongoDB"
  }
}

module "mongodb" {
  source = "../../"

  #availability_zone = "eu-west-1a"
  instance_ami =    "ami-0bbc25e23a7640b9b"
  subnet_public     = "subnet-02df0c4e9ae71a189"
  instance_type     = "t2.micro"
  volume_size       = "10"
  key_name          = "${aws_key_pair.mongodb.key_name}"
  private_key       = "${file("${path.module}/keys/mongodb")}"
  security_groups   = "sg-06b837f241ea05881"
}