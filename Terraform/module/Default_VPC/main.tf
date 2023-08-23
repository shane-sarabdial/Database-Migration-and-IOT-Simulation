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