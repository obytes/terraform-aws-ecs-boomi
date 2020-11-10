variable "prefix" {
}

variable "common_tags" {
  type = map(string)
}

# network
variable "net_cidr_block" {
}

variable "net_public_ranges" {
  type = list(string)
}

variable "net_private_ranges" {
  type = list(string)
}

variable "net_vpc_tags" {
  type    = map(string)
  default = {}
}

variable "net_private_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "net_public_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "vpn_ep_subnet_ids" {
  type        = list(string)
  default     = []
  description = "subnet ids used for the vpn_endpoint_client module"
}

