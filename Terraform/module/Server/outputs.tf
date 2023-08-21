output "subnet_id" {
  value = aws_instance.server.subnet_id
}

output "vpc_id" {
  value = aws_instance.server.vpc_security_group_ids
}