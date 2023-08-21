variable "kinesis_fh_name" {
  type = string
  description = "Name of kinesis firehose"
}

variable "s3_bucket_arn" {
  type = string
  description = "Arn forS# bucket"
}

variable "lambda_arn_name" {
  type = string
  default = "LambdaArn"
  description = "name for lambda arn"
}

variable "lambda_arn" {
  type = string
  description = "Lambda parameters"
}

variable "buffer_size" {
  type = number
  default = 1
  description = "Buffer size in MB"
}

variable "buffer_interval" {
  type = number
  default = 60
  description = "Buffer interval in seconds"
}

variable "prefix" {
  type = string
  description = "prefix of output"
}

variable "prefix_error" {
  type = string
  description = "prefix of error outputs"
}

variable "compression_format" {
  type = string
  default = "GZIP"
  description = "Compression format"
}

variable "firehose_role" {
  type = string
  description = "role for firehose"
}
