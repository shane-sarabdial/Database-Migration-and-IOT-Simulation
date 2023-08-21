terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_lambda_function" "lambda" {
  role = var.role_arn
  function_name = var.function_name
  runtime = var.runtime
  filename = "C:/Users/shane/Desktop/Python Projects/Database-Migration-and-IOT-Simulation/Terraform/module/Lambda/lambda_function/my-package.zip"
  handler = "lambda_function.lambda_handler"
  timeout = var.timeout
  vpc_config {
    security_group_ids = [var.security_group_id]
    subnet_ids = [var.subnet_id]
  }
  environment {
    variables = {
      db_secret_name = var.secrets_dir,
      region_name = var.region_name
    }
  }
}