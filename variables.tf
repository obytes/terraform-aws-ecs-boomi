#==========================#
#   Common details         #
#==========================#
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
#    COMMON    #
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
  description = "A list of strings contains the CIDR blocks e.g. 10.10.10.0/26 which allowed to access the ALB"
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

#==============#
#  Boomi Node  #
#==============#

variable "desired_count" {
  type = number
  description = "The number of instances of the task definition to place and keep running. "
}

variable "container_name" {
  type = string
  description = "The Container Name"
  default = "atom_node"
}

variable "allowed_security_group_ids" {
  type = list(string)
  default = []
  description = "A list of security group IDs to have access to the container"
}

variable "atom_port" {
  type = number
  description = "The port number for the Atom which is defaulted to 9090"
  default = 9090
}

variable "task_definition_cpu" {
  type = number
  description = "CPU for the task definition"
  default = 256
}

variable "task_definition_memory" {
  type = number
  description = "Memory for the task definition"
  default = 512
}