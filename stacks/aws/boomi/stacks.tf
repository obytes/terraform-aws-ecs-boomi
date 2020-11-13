module "molecule" {
  source      = "../../../modules/boomi/molecule"
  prefix      = local.prefix
  common_tags = local.common_tags

  ecs_cluster_name = var.ecs_cluster_name
  container_name   = var.container_name
  desired_count    = var.desired_count
  port             = var.port

  vpc_id                     = var.vpc_id
  private_subnet_ids         = var.private_subnet_ids
  allowed_cidr_blocks        = var.allowed_cidr_blocks
  allowed_security_group_ids = var.allowed_security_group_ids

  s3_logging = var.s3_logging
  kms_id = var.kms_id
  params = var.params
  repository_url = var.repository_url
  secrets = var.secrets
}


