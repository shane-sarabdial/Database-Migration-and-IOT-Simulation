terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_timestreamwrite_database" "timestream_db" {
  database_name = var.database_name
}

resource "aws_timestreamwrite_table" "timestream_table" {
  database_name = aws_timestreamwrite_database.timestream_db.database_name
  table_name = var.table_name
}