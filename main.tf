terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.82.2"
    }
  }
}

provider "aws" {
  region = var.aws_region

  access_key = var.aws_api_key.access_key
  secret_key = var.aws_api_key.secret_key
}

resource "aws_security_group" "allow_ports_to_vps" {
  name        = "allow_ports"
  description = "Allow necessary ports to instance"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ports" {
  for_each = var.sg_ingress_rules

  cidr_ipv4   = each.value.cidr_ipv4
  ip_protocol = each.value.ip_protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port

  security_group_id = aws_security_group.allow_ports_to_vps.id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ports_to_vps.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_key_pair" "ec2_keys" {
  public_key = file(var.ssh_public_key)
  key_name   = "OpenTofu key"
}

resource "aws_instance" "vps" {
  ami           = var.vm_instance.ami
  instance_type = var.vm_instance.instance_type

  vpc_security_group_ids = [aws_security_group.allow_ports_to_vps.id]

  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2_keys.key_name

  tags = {
    Name = var.hostname
  }
  root_block_device {
    volume_size           = var.vm_instance.volume_size
    volume_type           = "gp3"
    delete_on_termination = true
  }

  user_data = <<-EOF
              #!/bin/bash
              # Commands to run after the instance starts
              apt-get update
              apt-get upgrade -y
              apt-get install -y htop git python3-venv
              echo "${var.hostname}" > /etc/hostname
              reboot
              EOF
}

# Display ec2 IP address
output "instance_ip" {
  sensitive = false
  value     = aws_instance.vps.public_ip
}
