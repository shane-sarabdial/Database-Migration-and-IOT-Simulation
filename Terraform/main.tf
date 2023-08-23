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
}

module "vpc" {
  source = "./module/Default_VPC"
}

module "sg" {
  source = "./module/Security_Groups"
  ec2_iot_security_group_name = "mysql_sg_3306_443"
  vpc_id = module.vpc.vpc_id
}

module "servers" {
  source                = "./module/Server"
  server_name           = "IOT"
  ami                   = "ami-08a52ddb321b32a8c"
  instance_type         = "t2.micro"
  instance_profile_name = module.roles.instance_profile_name
  sg_id = module.sg.security_group_name
  subnet_id = module.vpc.subnet_id
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
  subnet_id = module.servers.subnet_id
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

//module "servers" {
//  source                = "./module/Server"
//  server_name           = "Windows_Bastion_Host"
//  ami                   = "ami-09301a37d119fe4c5"
//  instance_type         = "t2.medium"
//  instance_profile_name = module.roles.instance_profile_name
//  sg_id = module.sg.security_group_name
//  key_name = "bastion_host_key"
//  subnet_id = module.VPC.subnet_ids
}