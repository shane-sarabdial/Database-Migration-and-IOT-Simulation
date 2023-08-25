variable "server_name" {
  type = string
  description = "Name of Server"
}

variable "ami" {
  type = string
  description = "AMI to use on server"
}

variable "instance_type" {
  type = string
  description = "Instance type"
}

variable "instance_profile_name" {
  type = string
  description = "Name of instance profile used for role"
}

variable "sg_id" {
  type = string
  description = "Security group for ec2"
}

variable "volume_size" {
  type = string
  description = "size of ebs volume"
  default = "8"
}

variable "volume_type" {
  type = string
  description = "ebs type"
  default = "gp3"
  }

variable "key_name" {
  type = string
  default = ""
}

variable "subnet_id" {
  type = string
  description = "subnet ids of VPC"
}

variable "user_data" {
  default = ""
}