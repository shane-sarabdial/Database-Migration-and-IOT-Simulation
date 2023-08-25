variable "host_name" {
  type = string
  description = "Name of bastion host"
}

variable "instance_profile_name" {
  type = string
  description = "Name of instance profile"
}


variable "firehose_lambda_role_name" {
  type = string
  default = "firehose_lambda_role"
}

variable "firehose_lambda_policy_name" {
  type = string
  default = "firehose_lambda_policy"
  description = "Policy for Kinesis Firehose, Lambda, CloudWatch Logs, and S3"
}

variable "lambda_role_name" {
  type = string
  default = "lambda_role"
  description = "Name of lambda role"
}

variable "iot_firehose_name" {
  type = string
}

variable "kinesis_arn" {
  type = string
  description = "kinesis firehose arn"
}

variable "dms_name" {
  type = string
}