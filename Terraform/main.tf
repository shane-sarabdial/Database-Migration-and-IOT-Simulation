terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["/Users/shane/.aws/conf"]
  shared_credentials_files = ["/Users/shane/.aws/credentials"]
  profile                  = "default"
}

module "roles" {
  source                = "./module/Roles"
  host_name             = "iam-role-bastion-host-ssm"
  instance_profile_name = "bastion_host_ssm_profile"
  firehose_lambda_role_name = "o2-arena-lambda-firehouse"
  iot_firehose_name = "o2-arena-lambda-firehose-iot"
  kinesis_arn = module.kinesis_firehose.kinesis_arn
  dms_name = "DMS-S3"
}

module "vpc" {
  source = "./module/Default_VPC"
}

module "sg" {
  source = "./module/Security_Groups"
  ec2_iot_security_group_name = "mysql_sg_3306_443"
  vpc_id = module.vpc.vpc_id
}

module "IOT_Bucket" {
  source = "./module/S3"
  bucket_name = "iotbucketv45"
}

module "lambda" {
  source = "./module/Lambda"
  role_arn = module.roles.lambda_role
  runtime = "python3.9"
  timeout = 30
  security_group_id = module.sg.security_group_id
  function_name = "o2-arena-lambda-firehose"
  secrets_dir = "prod/db/mysql-onprem-o2arena-db-x"
  subnet_id = module.vpc.subnet_id
}

module "kinesis_firehose" {
  source = "./module/Kinesis_Firehose"
  kinesis_fh_name = "o2-arena-lambda-firehose-s3"
  s3_bucket_arn = module.IOT_Bucket.s3_arn
  lambda_arn = "${module.lambda.lambda_arn}:$LATEST"
  prefix = "02-arena-motion"
  prefix_error = "errors"
  firehose_role = module.roles.firehose_role
}

module "IOT" {
  source = "./module/IOT"
  SQL_statement = "SELECT * FROM '/iot-o2-arena-motion'"
  rule_name = "TopicRule"
  kinesis_stream_name = module.kinesis_firehose.kinesis_stream_name
  role_arn = module.roles.iot-kinesis_arn
}


data "template_file" "user_data" {
  template = file("${path.module}/user_data_script.sh")
}

module "servers" {
  source                = "./module/Server"
  for_each = local.server_instances
  server_name           = each.value["server_name"]
  ami                   = each.value["ami"]
  instance_type         = each.value["instance_type"]
  instance_profile_name = each.value["instance_profile_name"]
  user_data = each.value["user_data"]
  volume_size = each.value["volume_size"]
  sg_id = each.value["sg_id"]
  subnet_id = each.value["subnet_id"]
  key_name = each.value["key_name"]
}

module "RDS" {
  source = "./module/RDS"
  identifier = "o2-arena-pgsql-db"
  engine_version = "14.6"
  engine = "aurora-postgresql"
  db_name = "o2_arena_pgsql_db"
  final_snapshot = true
  az = ["us-east-1a"]
  security_group_id = module.sg.security_group_id
  password = "password123"
  min_cap = 2
  max_cap = 4
}

module "Timestream" {
  source = "./module/Timestream_DB"
  database_name = "o2-arena-timestream-db"
  table_name = "o2-arena-motion-events"
}

