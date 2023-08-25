terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private_subnet" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.my_vpc.id
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
}


resource "aws_vpc_endpoint" "sceret_endpoint" {
  service_name = var.service_name
  vpc_id = aws_vpc.my_vpc.id
  subnet_ids = [aws_subnet.private_subnet.id]
  vpc_endpoint_type = "Interface"
  tags = {Name = "secret_manager"}
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id = aws_vpc.my_vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
  tags = {Name = "s3"}
}

resource "aws_vpc_endpoint" "ssm" {
  service_name = "com.amazonaws.us-east-1.ssm"
  vpc_id = aws_vpc.my_vpc.id
  subnet_ids = [aws_subnet.private_subnet.id]
  security_group_ids = [var.sg_id]
  tags = {Name ="ssm"}
  vpc_endpoint_type = "Interface"
   private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2_messages" {
  service_name = "com.amazonaws.us-east-1.ec2messages"
  vpc_id = aws_vpc.my_vpc.id
  subnet_ids = [aws_subnet.private_subnet.id]
  security_group_ids = [var.sg_id]
  tags = {Name = "ec2_messages"}
  vpc_endpoint_type = "Interface"
   private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssm_messages" {
  service_name = "com.amazonaws.us-east-1.ssmmessages"
  vpc_id = aws_vpc.my_vpc.id
  subnet_ids = [aws_subnet.private_subnet.id]
  security_group_ids = [var.sg_id]
  tags = {Name = "ssm_messages"}
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
}
