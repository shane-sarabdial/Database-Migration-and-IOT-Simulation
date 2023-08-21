terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


resource "aws_s3_bucket" "IOT_Bucket" {
  bucket = var.bucket_name
  versioning {
    enabled = true
  }
}

