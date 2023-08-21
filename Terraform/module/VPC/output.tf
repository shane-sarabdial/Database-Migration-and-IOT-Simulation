output "subnet_ids" {
  value = aws_subnet.private_subnet.id
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

