provider "aws" {
  region = "us-east-1"
}

# 1. Crear el Security Group
resource "aws_security_group" "test-terraform-sg" {
  name        = "test-terraform-sg"
  description = "Security Group creado con Terraform para SSH"

  # Regla de entrada (Ingress): Permitir SSH (puerto 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permite desde cualquier IP
  }

  # Regla de salida (Egress): Permitir todo a cualquier destino
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"        # -1 significa "todos los protocolos"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Asociar el SG a la instancia
resource "aws_instance" "test-terraform-ec2" {
  ami                    = "ami-0ea87431b78a82070"
  instance_type          = "t2.micro"
  key_name               = "vockey"

  # Aquí asociamos el ID del Security Group creado arriba
  vpc_security_group_ids = [aws_security_group.test-terraform-sg.id]

  tags = {
    Name = "test-terraform-ec2"
  }
}

