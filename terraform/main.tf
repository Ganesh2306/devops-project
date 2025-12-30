# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 6.0"
#     }
#   }
# }

# provider "aws" {
#   region = "ap-south-1"
# }

# resource "aws_instance" "app_server" {
#   ami           = "ami-0f5ee92e2d63afc18"
#   instance_type = "t2.micro"
#   key_name      = "devops-key"

#   tags = {
#     Name = "Prod-App-Server"
#   }
# }

# output "instance_public_ip" {
#   description = "Public IP of the EC2 instance"
#   value       = aws_instance.app_server.public_ip
# }

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# -------------------------------
# Security Group
# -------------------------------
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH, HTTP, HTTPS, All TCP (learning)"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "All TCP (learning only)"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-SG"
  }
}

# -------------------------------
# EC2 Instance
# -------------------------------
resource "aws_instance" "app_server" {
  ami                    = "ami-0f5ee92e2d63afc18"
  instance_type          = "t2.micro"
  key_name               = "devops-key"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Prod-App-Server"
  }
}

# -------------------------------
# Output
# -------------------------------
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}
