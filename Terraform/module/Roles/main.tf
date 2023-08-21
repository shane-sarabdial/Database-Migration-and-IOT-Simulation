terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


//resource "aws_iam_role_policy" "iam-role-bastion-host-ssm_policy" {
//  role = "${aws_iam_role.iam-role-bastion-host-ssm.id}"
//  policy = jsonencode({
//    Version = "2012-10-17",
//    Statement = [
//      {
//        Effect   = "Allow",
//        Action   = [
//          "cloudwatch:PutMetricData",
//          "ds:CreateComputer",
//          "ds:DescribeDirectories",
//          "ec2:DescribeInstanceStatus",
//          "logs:*",
//          "ssm:*",
//          "ec2messages:*",
//        ],
//        Resource = "*",
//      },
//      {
//        Effect = "Allow",
//        Action = "iam:CreateServiceLinkedRole",
//        Resource = "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*",
//        Condition = {
//          StringLike = {
//            "iam:AWSServiceName" = "ssm.amazonaws.com",
//          },
//        },
//      },
//      {
//        Effect   = "Allow",
//        Action   = [
//          "iam:DeleteServiceLinkedRole",
//          "iam:GetServiceLinkedRoleDeletionStatus",
//        ],
//        Resource = "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*",
//      },
//      {
//        Effect   = "Allow",
//        Action   = [
//          "ssmmessages:CreateControlChannel",
//          "ssmmessages:CreateDataChannel",
//          "ssmmessages:OpenControlChannel",
//          "ssmmessages:OpenDataChannel",
//        ],
//        Resource = "*",
//      },
//      {
//        Effect = "Allow",
//        Action = ['*'],
//        Resource = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
//      }
//    ],
//  })
//}


resource "aws_iam_role" "iam-role-bastion-host-ssm" {
  name = var.host_name
 assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
      },
    ],
  })
}
data "aws_iam_policy" "AmazonSSMFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "AmazonSSMManagedEC2InstanceDefaultPolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}

data "aws_iam_policy" "CloudWatchFullAccess" {
  arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

data "aws_iam_policy" "CloudWatchLogsFullAccess" {
  arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "attach_ssm_full" {
  policy_arn = data.aws_iam_policy.AmazonSSMFullAccess.arn
  role       = aws_iam_role.iam-role-bastion-host-ssm.name
}

resource "aws_iam_role_policy_attachment" "attach_ssm_core" {
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
  role       = aws_iam_role.iam-role-bastion-host-ssm.name
}

resource "aws_iam_role_policy_attachment" "attach_ssm_default" {
  policy_arn = data.aws_iam_policy.AmazonSSMManagedEC2InstanceDefaultPolicy.arn
  role       = aws_iam_role.iam-role-bastion-host-ssm.name
}

resource "aws_iam_role_policy_attachment" "example_role_policy_attach_cloudwatch_logs" {
  policy_arn = data.aws_iam_policy.CloudWatchLogsFullAccess.arn
  role       = aws_iam_role.iam-role-bastion-host-ssm.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  policy_arn = data.aws_iam_policy.CloudWatchLogsFullAccess.arn
  role       = aws_iam_role.iam-role-bastion-host-ssm.name
}



resource "aws_iam_instance_profile" "bastion_host_ssm_profile" {
  name = var.instance_profile_name
  role = "${aws_iam_role.iam-role-bastion-host-ssm.name}"
}


provider "aws" {
  region = "us-east-1"  # Set your desired region
}

resource "aws_iam_role" "firehose_role" {
  name = var.firehose_lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "firehose_policy" {
  name        = var.firehose_lambda_policy_name
  description = "Policy for Kinesis Firehose role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "lambda:*"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "logs:*"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "s3:*"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "secretsmanager:*"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "firehose_attachment" {
  name       = "FirehoseAttachment"
  roles      = [aws_iam_role.firehose_role.name]
  policy_arn = aws_iam_policy.firehose_policy.arn
}

data "aws_iam_policy" "lambda_basic_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy" "lambda_vpc_access_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

data "aws_iam_policy_document" "secrets_manager_policy" {
  statement {
    actions   = ["secretsmanager:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "secrets-manager-policy"
  description = "Policy for full access to Secrets Manager"
  policy      = data.aws_iam_policy_document.secrets_manager_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_attachment" {
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
  role       = aws_iam_role.lambda_role.name
}


resource "aws_iam_role_policy_attachment" "lambda_basic_attachment" {
  policy_arn = data.aws_iam_policy.lambda_basic_execution.arn
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_attachment" {
  policy_arn = data.aws_iam_policy.lambda_vpc_access_execution.arn
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role" "o2-arena-lambda-firehose-iot" {
  name = var.iot_firehose_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "iot.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "firehose_iot_policy" {
  name        = "FirehosePolicy"
  description = "Policy for Firehose access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "firehose:PutRecord",
          "firehose:PutRecordBatch"
        ],
        Resource = var.kinesis_arn
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "firehose_policy_attachment" {
  name       = "FirehosePolicyAttachment"
  roles      = [aws_iam_role.o2-arena-lambda-firehose-iot.name]
  policy_arn = aws_iam_policy.firehose_iot_policy.arn
  depends_on = [aws_iam_role.o2-arena-lambda-firehose-iot]
}



