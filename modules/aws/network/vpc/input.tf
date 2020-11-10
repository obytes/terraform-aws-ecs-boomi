variable "prefix" {}

variable "common_tags" {
  default = {}
  type    = map(string)
}

variable "cidr_block" {
  description = "VPC CIDR Range"
}

variable "public_ranges" {
  description = "Public subnet IP ranges (comma separated)"
  type        = list(string)
}

variable "private_ranges" {
  description = "Private subnet IP ranges (comma separated)"
  type        = list(string)
}

variable "vpn_ep_subnet_ids" {
  type        = list(string)
  description = "subnet ids used for the vpn_endpoint_client module"
  default     = []
}

variable "zones" {
  description = "AZs for subnets"
  type        = map(list(string))

  default = {
    "us-east-1" = ["us-east-1a", "us-east-1c", "us-east-1d"]
  }
}

variable "domain_name_servers" {
  default = [
    "AmazonProvidedDNS",
    "8.8.8.8",
  ]

  type = list(string)
}

variable "vpc_peers" {
  type = map(string)

  default = {
    gw_id = ""
    cidr  = ""
  }

  description = "AWS VPN Peering (Peering VPC with other cloud providers or other VPCs *Support one gateway for now*)"
}

variable "vpc_tags" {
  default     = {}
  type        = map(string)
  description = "Required to specify EKS tags for vpc for discovery services to work"
}

variable "private_subnet_tags" {
  default     = {}
  type        = map(string)
  description = "Required to specify EKS tags for subnets for discovery services to work"
}

variable "public_subnet_tags" {
  default     = {}
  type        = map(string)
  description = "Required to specify EKS tags for subnets for discovery services to work"
}
