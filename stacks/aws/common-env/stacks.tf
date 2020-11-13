module "ecs_ec2" {
  source      = "../../../modules/aws/ec2/ecs"
  prefix      = local.prefix
  common_tags = local.common_tags

  ecs_cluster = {
    name = aws_ecs_cluster.default.name
  }

  max_size         = "2"
  min_size         = "1"
  desired_capacity = "1"

  security_group_ids = merge(
    var.security_group_ids,
  )

  private_subnet_ids = var.private_subnet_ids
  key_name = var.ssh_key_name
  instance_type = var.instance_type
}
