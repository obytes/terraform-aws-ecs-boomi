#==========================#
#   Common details         #
#==========================#
variable "env" {
  default = "prd"
}

variable "project_name" {
  default = "boomi"
}

variable "region" {
  default = "us-east-1"
}

variable "aws_profile" {
}

#===================#
#   Network         #
#===================#
variable "cidr_block" {
}

variable "public_ranges" {
  type = list(string)
}

variable "private_ranges" {
  type = list(string)
}

#==============#
#  COMMON #
#==============#
variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "allowed_cidr_blocks" {
  type = list(string)
}

variable "default_sg_id" {
  type = string
}

variable "ssh_ec2_key_name" {
  type = string
}

variable "instance_type" {
  type = string
}