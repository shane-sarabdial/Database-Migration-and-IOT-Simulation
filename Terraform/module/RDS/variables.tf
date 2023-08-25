variable "mode" {
  type = string
  default = "provisioned"
  description = "instance class type"
}

variable "engine_version" {
  type = string
  description = "version of db engine"
}

variable "engine" {
  type = string
  description = "db engine"
}

variable "username" {
  type = string
  default = "postgres"
  description = "username for db"
}

variable "password" {
  type = string
  description = "db password"
}

variable "db_name" {
  type = string
}

variable "az" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "min_cap" {
  type = number
  description = "minimum acus"
}

variable "max_cap" {
  type = number
  description = "minimum acus"
}

variable "identifier" {
  type = string
}

variable "final_snapshot" {
  type = bool
  default = false
}