terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "default vpc"
  }
}

data "aws_availability_zones" "availability_zones" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.availability_zones.names[0]
}


resource "aws_vpc_endpoint" "sceret_endpoint" {
  service_name = var.service_name
  vpc_id = aws_default_vpc.default_vpc.id
  subnet_ids = [aws_default_subnet.default_az1.id]
  vpc_endpoint_type = "Interface"
  tags = {Name = "secret_manager"}
  private_dns_enabled = true
}