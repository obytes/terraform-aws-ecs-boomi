# GENERAL
variable "prefix" {}
variable "common_tags" {}

# ECS BOOMI NODES
variable "ecs_cluster_name" {}
variable "container_name" {
  default = "node"
}
variable "port" {
  default = 9090
}
variable "desired_count" {
  default = 1
}

# NETWORK
variable "vpc_id" {}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "List of scurity group IDs allowed to access boomi molecule"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access boomi molecule"
}

variable "alb_deregistration_delay" {
  default = 10
}

# S3
variable "s3_logging" {
  type = map(string)
}

variable "repository_url" {
  type = string
}

variable "kms_id" {
  type = string
}

variable "secrets" {
  type = map(string)
  description = "Options are id and arn"
}

variable "params" {
  type = map(string)
  description = "Available Keys are id and arn"
}

