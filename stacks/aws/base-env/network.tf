module "network" {
  source = "../../../modules/aws/network/vpc"

  prefix              = var.prefix
  common_tags         = local.common_tags
  cidr_block          = var.net_cidr_block
  public_ranges       = var.net_public_ranges
  private_ranges      = var.net_private_ranges
  vpc_tags            = var.net_vpc_tags
  private_subnet_tags = var.net_private_subnet_tags
  public_subnet_tags  = var.net_public_subnet_tags
  vpn_ep_subnet_ids   = var.vpn_ep_subnet_ids
}

