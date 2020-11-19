#==========================#
#   Common details         #
#==========================#
variable "prefix" {
  type = string
  description = "Prefix used for naming convention"
}
variable "common_tags" {
  type = map(string)
  description = "a map of shared tags to be used by the modules' resources"
}
variable "env" {
  default = "prd"
  description = "Environment Name such as qa,prd,adm. Its recommended to keep it 3 chars long max as this will be used to structure the ID/Name of resources"
}

variable "project_name" {
  default = "boomi"
  description = "Project Name . Its recommended to keep it 3 chars long max as this will be used to structure the ID/Name of resources"
}

variable "region" {
  default = "us-east-1"
  description = "The Region name, This will be edited to removed the hyphens such as useast1 and used by the ID/Name of resources"
}

variable "aws_profile" {
  type = string
  description = "The AWS Profile name with the required permissions stored in ~/.aws/credentials used by Terraform to create the resources"
}

#==============#
#  COMMON #
#==============#
variable "vpc_id" {
  type = string
  description = "VPC ID, example vpc-1122334455"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "A list of strings contains the IDs of the private subnets in the vpc"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "A list of strings contains the IDs of the public subnets in the vpc"
}

variable "allowed_cidr_blocks" {
  type = list(string)
  description = "A list of strings contains the CIDR blocks e.g. 10.10.10.0/26 which allowed to ssh to EC2 node"
}

variable "default_sg_id" {
  type = string
  description = "Default SG ID for the VPC"
}

variable "ssh_ec2_key_name" {
  type = string
  description = "the name of the pair key to access the ec2"
}

variable "instance_type" {
  type = string
  description = "Instance Type, e.g. t2.micro"
}

variable "min_size" {
  type = number
  description = "The minimum size of the auto scale group"
}

variable "max_size" {
  type = number
  description = "The maximum size of the auto scale group"
}

variable "desired_capacity" {
  type = number
  description = "The number of Amazon EC2 instances that should be running in the group"
}