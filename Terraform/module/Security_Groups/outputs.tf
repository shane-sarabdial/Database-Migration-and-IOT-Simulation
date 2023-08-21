output "security_group_name" {
  value = aws_security_group.ec2_iot_security_group.id
}

output "security_group_id" {
  value = aws_security_group.ec2_iot_security_group.id
}

output "vpc" {
  value = aws_security_group.ec2_iot_security_group.vpc_id
}

