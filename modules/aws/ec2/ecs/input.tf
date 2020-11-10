variable "prefix" {}

variable "common_tags" {
  type = map(string)
}

variable "ecs_cluster" {
  type = map(string)
}

variable "security_group_ids" {
  type = map(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

# ecs
variable "desired_capacity" {}

variable "max_size" {}
variable "min_size" {}

variable "instance_type" {
  default = "t3.medium"
}
