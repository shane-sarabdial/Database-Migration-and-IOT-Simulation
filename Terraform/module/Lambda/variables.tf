variable "role_arn" {
  type = string
  description = "role arn form lambda function"
}

variable "function_name" {
  type = string
  description = "Name of lambda function"
}

variable "runtime" {
  type = string
  description = "language and version"
  default = "python3.9"
}

variable "timeout" {
  type = number
  description = "timeout for lambda function"
}

variable "security_group_id" {
  type = string
  description = "security group"
}

variable "secrets_dir" {
  type = string
  description = "aws secrets directory"
}

variable "region_name" {
  type = string
  description = "region name"
  default = "us-east-1"
}

variable "subnet_id" {
  type = string
  description = "subnet"
}