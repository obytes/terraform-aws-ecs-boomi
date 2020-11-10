module "peer_vpc_to_adm" {
  source      = "../../../modules/aws/network/vpc-peering"
  prefix      = var.prefix
  common_tags = var.common_tags

  # adm vpc
  vpc_id              = var.adm_vpc_id
  vpc_route_table_ids = var.adm_vpc_route_table_ids
  cidr_block          = var.adm_cidr_block

  # current vpc
  peer_vpc_id              = var.vpc_id
  peer_vpc_cidr            = var.cidr_block
  peer_vpc_route_table_ids = var.route_table_ids
}

module "ecs_ec2" {
  source      = "../../../modules/aws/ec2/ecs"
  prefix      = local.prefix
  common_tags = local.common_tags

  ecs_cluster = {
    name = aws_ecs_cluster.default.name
  }

  max_size         = "5"
  min_size         = "1"
  desired_capacity = "2"

  security_group_ids = merge(
    var.security_group_ids,
    {
      access_adm_ssh = aws_security_group.adm_ssh.id,
    }
  )

  private_subnet_ids = var.private_subnet_ids
}
