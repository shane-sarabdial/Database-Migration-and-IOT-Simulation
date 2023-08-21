output "instance_profile_name" {
  value = aws_iam_instance_profile.bastion_host_ssm_profile.name
}


output "lambda_role" {
  value = aws_iam_role.lambda_role.arn
}

output "firehose_role" {
  value = aws_iam_role.firehose_role.arn
}

output "iot-kinesis_arn" {
  value = aws_iam_role.o2-arena-lambda-firehose-iot.arn
}