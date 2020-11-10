module "molecule" {
  source      = "../../../modules/boomi/molecule"
  prefix      = local.prefix
  common_tags = local.common_tags

  ecs_cluster_name = var.ecs_cluster_name
  fargate_cpu      = var.fargate_cpu
  fargate_memory   = var.fargate_memory
  container_name   = var.container_name
  desired_count    = var.desired_count
  port             = var.port

  vpc_id                     = var.vpc_id
  private_subnet_ids         = var.private_subnet_ids
  allowed_cidr_blocks        = var.allowed_cidr_blocks
  allowed_security_group_ids = var.allowed_security_group_ids

  s3_logging = var.s3_logging
}

module "ci" {
  source      = "./ci"
  prefix      = local.prefix
  common_tags = local.common_tags

  # ECS
  ecs_cluster_name   = var.ecs_cluster_name
  ecs_service_name   = module.molecule.service_name
  ecr_repository_url = module.molecule.repository_url

  # GH
  gh_org    = var.gh_org
  gh_repo   = var.gh_repo
  gh_token  = var.gh_token
  gh_secret = var.gh_secret

  # Net
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids

  # Misc
  s3_artifacts = var.s3_artifacts
  kms_arn      = var.kms_arn
}

module "events" {
  source      = "../../../modules/boomi/events"
  prefix      = local.prefix
  common_tags = local.common_tags
  account = var.account
}
