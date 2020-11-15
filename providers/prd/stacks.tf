module "common" {
  source             = "../../stacks/aws/common-env"
  prefix             = local.prefix
  common_tags        = local.common_tags
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  # You can pass here any SG ID which you would like to grant access to the EC2 instance
  security_group_ids = {
    default_vpc    = var.default_sg_id
  }
  ssh_key_name = var.ssh_ec2_key_name
  instance_type = var.instance_type
}


module "boomi" {
  depends_on = [module.common]

  source             = "../../stacks/aws/boomi"
  prefix             = local.prefix
  common_tags        = local.common_tags

  vpc_id                     = var.vpc_id
  private_subnet_ids         = var.private_subnet_ids
  public_subnet_ids          = var.public_subnet_ids
  allowed_cidr_blocks        = var.allowed_cidr_blocks
  allowed_security_group_ids = []

  ecs_cluster_name = module.common.ecs["name"]
  desired_count    = 1

  s3_logging   = module.common.s3_logging
  repository_url = module.common.repository_url
  kms_id = module.common.kms_id
  secrets = module.common.secrets_secret_manager
  params = module.common.parameters_secret_manager
}

