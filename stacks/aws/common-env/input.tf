variable "prefix" {
}

variable "common_tags" {
  type = map(string)
}

variable "kms_arn" {
}

variable "s3_logging" {
  type = map(string)
}

# network
variable "vpc_id" {
}

variable "cidr_block" {
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "route_table_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = map(string)
}

# peering with adm vpc
variable "adm_vpc_id" {
}

variable "adm_vpc_route_table_ids" {
  type = list(string)
}

variable "adm_cidr_block" {
}

