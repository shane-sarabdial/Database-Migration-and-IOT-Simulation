terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


resource "aws_kinesis_firehose_delivery_stream" "Kinesis_firehose" {
  destination = "extended_s3"
  name = var.kinesis_fh_name

  extended_s3_configuration {
    bucket_arn = var.s3_bucket_arn
    role_arn = var.firehose_role

    buffer_size = var.buffer_size
    buffer_interval = var.buffer_interval

    prefix = var.prefix
    error_output_prefix = var.prefix_error
    compression_format = var.compression_format

    processing_configuration {
      enabled = true
      
      processors {
        type = "Lambda"

        parameters {
          parameter_name = var.lambda_arn_name
          parameter_value = var.lambda_arn
        }
      }
    }
  }

}