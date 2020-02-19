#create_vpc
resource "aws_vpc" "vpc" {

  cidr_block = "${var.cidr_vpc}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags {
    "Environment" = "${var.environment_tag}"
  }

  tags = {
    Name = "${var.vpc_name}"
  }
}
#create_publicsubnet
resource "aws_subnet" "subnet_public" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.public_cidr_subnet}"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.availability_zone}"
  tags {
    "Environment" = "${var.environment_tag}"
  }
  tags {
     Name = "${var.public_subnet_name}"

  }
}


#create_publicsubnet
resource "aws_subnet" "subnet_public_3" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.public_cidr_subnet_3}"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.availability_zone_3}"
  tags {
    "Environment" = "${var.environment_tag}"
  }
  tags {
    Name = "${var.public_subnet_name_1}"
  }
}



#create_internet_gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    "Environment" = "${var.environment_tag}"
  }

  tags {

    Name = "${var.internet_gw_name}"
  }
}


#create_public_subnet_route_table
resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    "Environment" = "${var.environment_tag}"
  }

  tags {
    Name = "${var.publicsubnet_rt__name}"

  }
}
#Associate_route_table_with_subnet_to_make_public_subnet
resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = "${aws_subnet.subnet_public.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

#create_privatesubnet
resource "aws_subnet" "subnet_private" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.private_cidr_subnet}"
  map_public_ip_on_launch = "false"
  availability_zone = "${var.availability_zone_1}"
  tags {
    "Environment" = "${var.environment_tag}"
  }
  tags {
     Name = "${var.private_subnet_name}"

  }
}

#create_EIP_for_private_NAT_instance

resource "aws_eip" "nat" {
vpc      = true
}

#Create Nat gateway
resource "aws_nat_gateway" "nat-gw" {
allocation_id = "${aws_eip.nat.id}"
subnet_id = "${aws_subnet.subnet_private.id}"
}

#create_private_route_table
resource "aws_route_table" "rtb_private" {

  
  vpc_id = "${aws_vpc.vpc.id}"

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_nat_gateway.nat-gw.id}"
  }

  tags {
    "Environment" = "${var.environment_tag}"
  }
  tags {
    Name = "${var.privatesubnet_rt__name}"

  }
}

#Associate_route_table_with_subnet_to_make_private_subnet

resource "aws_route_table_association" "rta_subnet_private" {
  subnet_id      = "${aws_subnet.subnet_private.id}"
  route_table_id = "${aws_route_table.rtb_private.id}"
}


#Private Security Group

resource "aws_security_group" "private_sg" 
{
  name = "private-sg"
  vpc_id = "${aws_vpc.vpc.id}"  


  ingress {
      from_port   = "${var.webserver_port}"
      to_port     = "${var.webserver_port}"
      protocol    = "-1"
      cidr_blocks = ["${var.cidr_vpc}"]
  } 


  egress {
    from_port   = "${var.webserver_port}"
    to_port     = "${var.webserver_port}"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  tags {
    "Environment" = "${var.environment_tag}"
  }
}

#Public_Security_Group

resource "aws_security_group" "public_sg" {
  name = "public-sg"
  vpc_id = "${aws_vpc.vpc.id}"  


  ingress {
      from_port   = "${var.webserver_port_1}"
      to_port     = "${var.webserver_port_1}"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress {
      from_port   = "${var.webserver_port_2}"
      to_port     = "${var.webserver_port_2}"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress {
      from_port   = "${var.webserver_port_3}"
      to_port     = "${var.webserver_port_3}"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 


  egress {
    from_port   = "${var.webserver_port}"
    to_port     = "${var.webserver_port}"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  tags {
    "Environment" = "${var.environment_tag}"
  }
}


