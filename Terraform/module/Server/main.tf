terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}




resource "aws_instance" "server" {
  ami = var.ami
  instance_type = var.instance_type
  iam_instance_profile = var.instance_profile_name
  user_data = <<-EOF
              #!/bin/bash
              #install MySQL
              sudo yum update -y
              sudo yum install -y mariadb105-server

              # start the engine
              sudo systemctl start mariadb

              # enable auto-start with system
              sudo systemctl enable mariadb
              EOF
  vpc_security_group_ids = [var.sg_id]
  subnet_id = var.subnet_id
  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted = true
    delete_on_termination = false
  }
  key_name = var.key_name
  tags = {
    Name = "${var.server_name}"
  }
}


