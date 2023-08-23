output "vpc_id" {
  value = aws_default_vpc.default_vpc.id
}

output "subnet_id" {
  value = aws_default_subnet.default_az1.id
}