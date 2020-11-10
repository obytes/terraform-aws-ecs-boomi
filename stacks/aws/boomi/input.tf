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
variable "fargate_cpu" {
  default = 256
}

variable "fargate_memory" {
  default = 512
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

# Github
variable "gh_repo" {
}

variable "gh_org" {
}

variable "gh_token" {
}

variable "gh_secret" {
  type = string
}

# S3
variable "s3_logging" {
  type = map(string)
}

variable "s3_artifacts" {
  type = map(string)
}

variable "kms_arn" {}

variable "connections" {
  type = list(object({
    host      = string
    port      = number
    protocol  = string
    priority  = number
    qualifier = string
  }))
}

## Accounts to be subscribed to SNS Topic
variable "account" {
  type = map(string)
}
