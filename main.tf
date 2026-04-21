provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test-terraform-ec2" {
  ami           = "ami-0ea87431b78a82070" # Amazon Linux 2023
  instance_type = "t2.micro"

  tags = {
    Name = "test-terraform-ec2"
  }
}

