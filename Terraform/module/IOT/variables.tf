variable "rule_name" {
  type = string
}

variable "SQL_statement" {
  type = string
  description = "SQL Query statement"
}

variable "kinesis_stream_name" {
  type = string
  description = "Name of kinesis stream"
}

variable "seperator" {
  type = string
  default = "\n"
}

variable "role_arn" {
  type = string
  description = "default role arn"
}