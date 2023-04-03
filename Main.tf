
resource "aws_vpc" "Tenacity-VPC" {
  cidr_block = var.cidr_block

  tags = {
    Name = "Tenacity VPC"
  }
}


# Creation of Public Subnets

resource "aws_subnet" "Prod-pub-sub1" {
  vpc_id            = aws_vpc.Tenacity-VPC.id
  cidr_block        = var.pub-sub1-cidr_block
  availability_zone = "eu-west-2a"

  tags = {
    Name = "Public Subnet1"
  }
}

resource "aws_subnet" "Prod-pub-sub2" {
  vpc_id            = aws_vpc.Tenacity-VPC.id
  cidr_block        = var.pub-sub2-cidr_block
  availability_zone = "eu-west-2b"

  tags = {
    Name = "Public Subnet2"
  }
}


# Creation of Private Subnets

resource "aws_subnet" "Prod-priv-sub1" {
  vpc_id            = aws_vpc.Tenacity-VPC.id
  cidr_block        = var.prod-priv-sub1-cidr_block
  availability_zone = "eu-west-2a"

  tags = {
    Name = "Private Subnet1"
  }
}

resource "aws_subnet" "Prod-priv-sub2" {
  vpc_id            = aws_vpc.Tenacity-VPC.id
  cidr_block        = var.prod-priv-sub2-cidr_block
  availability_zone = "eu-west-2b"

  tags = {
    Name = "Private Subnet2"
  }
}


# Creation of Internet Gateway 

resource "aws_internet_gateway" "Tenacity-IG" {
  vpc_id = aws_vpc.Tenacity-VPC.id

  tags = {
    Name = " Internet Gateway"
  }
}

# Creating Private Route Table

resource "aws_route_table" "Prod-private-RT" {
  vpc_id = aws_vpc.Tenacity-VPC.id

  tags = {
    Name = "Prod-priv-route-table"
  }
}

# Creating Public Route Table

resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.Tenacity-VPC.id

  route {
    cidr_block = var.IG-cidr_block
    gateway_id = aws_internet_gateway.Tenacity-IG.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.Tenacity-IG.id
  }

  tags = {
    Name = "Public Route Table"
  }
}


# Subnets and Route table associations

resource "aws_route_table_association" "public-route-association" {
  subnet_id      = aws_subnet.Prod-pub-sub1.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "public-route-association1" {
  subnet_id      = aws_subnet.Prod-pub-sub2.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "private-route-association" {
  subnet_id      = aws_subnet.Prod-priv-sub1.id
  route_table_id = aws_route_table.Prod-private-RT.id
}

resource "aws_route_table_association" "private-route-association1" {
  subnet_id      = aws_subnet.Prod-priv-sub2.id
  route_table_id = aws_route_table.Prod-private-RT.id
}


# Creation of EIP for NAT Gateway

resource "aws_eip" "EIP_Tenacity" {
    vpc = true
    associate_with_private_ip = "var.eip_association_address"  
}


# Creation of NAT Gateway

resource "aws_nat_gateway" "Prod-Nat-gateway" {
    allocation_id = aws_eip.EIP_Tenacity.id 
    subnet_id = aws_subnet.Prod-priv-sub1.id
}


# Private Route Table and NAT Gateway Association

resource "aws_route_table_association" "b" {
  gateway_id     = aws_internet_gateway.Tenacity-IG.id
  route_table_id = aws_route_table.Prod-private-RT.id
}


resource "aws_security_group" "Tenacity-SG" {
  name   = "Tenacity-SG"
  description = "HTTP and SSH"
  vpc_id = aws_vpc.Tenacity-VPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Rock-server-1" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id            = aws_subnet.Prod-pub-sub1.id
  security_groups      = [aws_security_group.Tenacity-SG.id]
  associate_public_ip_address = true
  
  tags = {
    "Name" : "Public Security Group"
  }
}

resource "aws_instance" "Rock-server-2" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id            = aws_subnet.Prod-priv-sub1.id
  security_groups      = [aws_security_group.Tenacity-SG.id]
  
  
  tags = {
    "Name" : " private security group"
  }
}