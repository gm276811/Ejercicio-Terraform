provider "aws" {
  region = "us-east-1"
}

# 1. Crear el VPC
resource "aws_vpc" "test-terraform-vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "test-terraform-vpc"
  }
}

# 2. Crear la Subnet
resource "aws_subnet" "test-terraform-subnet" {
  vpc_id                  = aws_vpc.test-terraform-vpc.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true # Para que la instancia tenga IP pública

  tags = {
    Name = "test-terraform-subnet"
  }
}

# 3. Crear el Internet Gateway (La puerta a Internet)
resource "aws_internet_gateway" "test-terraform-ig" {
  vpc_id = aws_vpc.test-terraform-vpc.id

  tags = {
    Name = "test-terraform-ig"
  }
}

# 4. Crear la Route Table y la Ruta a Internet
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

# 5. Asociar la Route Table a la Subnet
resource "aws_route_table_association" "test-terraform-rta" {
  subnet_id      = aws_subnet.test-terraform-subnet.id
  route_table_id = aws_route_table.test-terraform-rt.id
}

# 6. Security Group (AHORA ASOCIADO AL NUEVO VPC)
resource "aws_security_group" "test-terraform-sg" {
  name        = "test-terraform-sg"
  vpc_id      = aws_vpc.test-terraform-vpc.id # ¡CLAVE!

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

# 7. Instancia EC2 (AHORA EN LA NUEVA SUBNET)
resource "aws_instance" "test-terraform-ec2" {
  ami                    = "ami-0ea87431b78a82070"
  instance_type          = "t2.micro"
  key_name               = "vockey"
  
  subnet_id              = aws_subnet.test-terraform-subnet.id # ¡CLAVE!
  vpc_security_group_ids = [aws_security_group.test-terraform-sg.id]

  tags = {
    Name = "test-terraform-ec2"
  }
}
