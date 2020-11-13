variable "prefix" {
}

variable "common_tags" {
  type = map(string)
}

# network
variable "vpc_id" {
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = map(string)
}

variable "ssh_key_name" {
  type = string
}

variable "instance_type" {
  type = string
}

