provider "aws" {
  region = var.region
}

# 1. VPC usando variable
resource "aws_vpc" "test-terraform-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "test-terraform-vpc"
  }
}

# 2. Subnet usando variables
resource "aws_subnet" "test-terraform-subnet" {
  vpc_id                  = aws_vpc.test-terraform-vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = {
    Name = "test-terraform-subnet"
  }
}

# 3. Internet Gateway
resource "aws_internet_gateway" "test-terraform-ig" {
  vpc_id = aws_vpc.test-terraform-vpc.id

  tags = {
    Name = "test-terraform-ig"
  }
}

# 4. Route Table
resource "aws_route_table" "test-terraform-rt" {
  vpc_id = aws_vpc.test-terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-terraform-ig.id
  }

  tags = {
    Name = "test-terraform-rt"
  }
}

resource "aws_route_table_association" "test-terraform-rta" {
  subnet_id      = aws_subnet.test-terraform-subnet.id
  route_table_id = aws_route_table.test-terraform-rt.id
}

# 5. Security Group
resource "aws_security_group" "test-terraform-sg" {
  name   = "test-terraform-sg"
  vpc_id = aws_vpc.test-terraform-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 6. EC2 usando variables
resource "aws_instance" "test-terraform-ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.test-terraform-subnet.id
  vpc_security_group_ids = [aws_security_group.test-terraform-sg.id]

  tags = {
    Name = "test-terraform-ec2"
  }
}
