terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_security_group" "ec2_iot_security_group" {
  name        = var.ec2_iot_security_group_name
  description = "self referencing sg on port 3306 and 443"
//  vpc_id = var.vpc_id
  ingress {
    from_port = 3306
    protocol = "TCP"
    to_port = 3306
    self = true
  }
  ingress {
    from_port = 443
    protocol = "TCP"
    to_port = 443
    self = true
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}