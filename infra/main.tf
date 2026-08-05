terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/generated-key.pem"
  file_permission = "0400"
}

resource "aws_key_pair" "generated" {
  key_name   = "terraform-generated-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_security_group" "ssh" {
  name        = "allow-ssh"
  description = "Allow SSH inbound"

  ingress {
    description = "SSH"
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

resource "aws_instance" "vm" {
  count                  = 3
  ami                    = "ami-02cada047ebd954cf"
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.generated.key_name
  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "vm-${count.index + 1}"
  }
}

output "private_key_path" {
  value = local_file.private_key.filename
}

output "public_ips" {
  value = aws_instance.vm[*].public_ip
}

output "ssh_login_commands" {
  value = [
    for ip in aws_instance.vm[*].public_ip : "ssh -i ${local_file.private_key.filename} ec2-user@${ip}"
  ]
}

