variable "prefix" {
  type = string
  description = "A prefix string used to name the resources"
}

variable "common_tags" {
  type = map(string)
  description = "A map of tags to tag the resources"
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

variable "desired_count" {
  type = number
  description = "The number of instances of the task definition to place and keep running. "
}

variable "container_name" {
  type = string
  description = "The Container Name"
}

variable "allowed_security_group_ids" {
  type = list(string)
  default = []
  description = "A list of security group IDs to have access to the container"
}

variable "allowed_cidr_blocks" {
  type = list(string)
  description = "A list of strings contains the CIDR blocks e.g. 10.10.10.0/26 which allowed to access the ALB"
}

variable "atom_port" {
  type = number
  description = "The port number for the Atom which is defaulted to 9090"
}

variable "secrets" {
  type = map(string)
  description = "A map of AWS Secret Manager secrets, valid values are name, id and ARN"
}

variable "parameters" {
  type = map(string)
  description = "A map of AWS Secret Manager parameters, valid values are name, id and ARN"
}

variable "repository_url" {
  type = string
  description = "ECR repository URL"
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

variable "ecs_cluster_name" {
  type = map(string)
  description = "A map of strings for the ECS cluster, valid keys are name and ARN"
}

variable "kms" {
  type = map(string)
  description = "A map of string for the KMS, valid keys are id and ARN"
}