terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_rds_cluster" "pg_db" {
  cluster_identifier = var.identifier
  engine_mode = var.mode
  engine_version = var.engine_version
  engine = var.engine
  master_username = var.username
  master_password = var.password
  database_name = var.db_name
  availability_zones = var.az
  vpc_security_group_ids = [var.security_group_id]
  skip_final_snapshot = var.final_snapshot
  serverlessv2_scaling_configuration {
    max_capacity = var.max_cap
    min_capacity = var.min_cap
  }

}

resource "aws_rds_cluster_instance" "pg_instance" {
  cluster_identifier = aws_rds_cluster.pg_db.id
  instance_class = "db.serverless"
  engine = aws_rds_cluster.pg_db.engine
  engine_version = aws_rds_cluster.pg_db.engine_version
}
