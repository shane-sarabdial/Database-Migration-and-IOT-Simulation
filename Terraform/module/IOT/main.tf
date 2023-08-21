terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_iot_topic_rule" "TopicRule" {
  enabled = true
  name = var.rule_name
  sql = var.SQL_statement
  sql_version = "2016-03-23"

  firehose {
    role_arn = var.role_arn
    delivery_stream_name = var.kinesis_stream_name
    separator = var.seperator
  }
}
