module "base" {
  source             = "../../../../stacks/aws/oby-base-env"
  prefix             = local.prefix
  common_tags        = local.common_tags
  net_cidr_block     = var.cidr_block
  net_private_ranges = var.private_ranges
  net_public_ranges  = var.public_ranges
}

module "common" {
  source             = "../../../../stacks/aws/oby-common-env"
  prefix             = local.prefix
  common_tags        = local.common_tags
  s3_logging         = module.base.s3_logging
  kms_arn            = module.base.kms_arn
  vpc_id             = module.base.vpc_id
  cidr_block         = module.base.cidr_block
  private_subnet_ids = module.base.private_subnet_ids

  security_group_ids = {
    access_core_db = module.odoo_database.security_group_ids["access"]
    default_vpc    = module.base.default_sg_id
  }

//  route_table_ids = [
//    module.base.private_route_table_ids,
//    module.base.public_route_table_ids,
//  ]
  route_table_ids = concat(module.base.private_route_table_ids, module.base.public_route_table_ids)

  # peering with adm vpc
  adm_vpc_id = data.terraform_remote_state.aws_us_east1_adm.outputs.vpc_id

  adm_vpc_route_table_ids = concat(
    data.terraform_remote_state.aws_us_east1_adm.outputs.public_route_table_ids,
    data.terraform_remote_state.aws_us_east1_adm.outputs.private_route_table_ids,
  )

  adm_cidr_block = data.terraform_remote_state.aws_us_east1_adm.outputs.cidr_block
}

module "odoo_database" {
  source          = "../../../../stacks/aws/oby-database"
  prefix          = local.prefix
  common_tags     = local.common_tags
  replica_enabled = "false"

  monitoring_interval        = var.database_monitoring_interval
  db_type                    = var.database_db_type
  auto_minor_version_upgrade = var.database_auto_minor_version_upgrade

  db_name        = var.rds_config_core["db_name"]
  identifier     = var.rds_config_core["db_name"]
  db_username    = var.rds_config_core["db_username"]
  db_password    = var.rds_config_core["db_password"]
  engine_version = "10.6"
  family         = "postgres10"

  allocated_storage = var.database_allocated_storage

  # network
  private_subnet_ids  = module.base.private_subnet_ids
  vpc_id              = module.base.vpc_id
  allowed_cidr_blocks = [ data.terraform_remote_state.aws_us_east1_adm.outputs.cidr_block ]

  kms_arn = module.base.kms_arn
}

module "odoo_ec2" {
  source             = "../../../../modules/aws/ec2/odoo"
  prefix             = local.prefix
  common_tags        = local.common_tags
  vpc_id             = module.base.vpc_id
  public_subnet_ids  = module.base.public_subnet_ids
  private_subnet_ids = module.base.private_subnet_ids
  s3_logging         = module.base.s3_logging

  security_group_ids = {
    access_odoo_db = module.odoo_database.security_group_ids["access"]
  }
}

module "boomi" {
  source             = "../../../../stacks/aws/oby-boomi"
  prefix             = local.prefix
  common_tags        = local.common_tags

  vpc_id                     = module.base.vpc_id
  private_subnet_ids         = module.base.private_subnet_ids
  public_subnet_ids          = module.base.public_subnet_ids
  allowed_cidr_blocks        = [ data.terraform_remote_state.aws_us_east1_adm.outputs.cidr_block ]
  allowed_security_group_ids = []

  ecs_cluster_name = module.common.ecs["name"]
  fargate_cpu      = 512
  fargate_memory   = 1024
  desired_count    = 1

  gh_org    = data.terraform_remote_state.github.outputs.organization
  gh_repo   = "boomi-node"
  gh_token  = data.terraform_remote_state.github.outputs.token
  gh_secret = var.webhook_secret

  ## Accounts to be subscribed to Topic SNS
  account = var.kpr

  kms_arn      = module.base.kms_arn
  s3_logging   = module.base.s3_logging
  s3_artifacts = module.common.s3_artifacts

  connections = [
    {
      host      = "dev-obytes.us.auth0.com"
      port      = 443
      protocol  = "HTTPS"
      priority  = 1
      qualifier = "auth0"
    },
    {
      host      = "www.obytes.com"
      port      = 443
      protocol  = "HTTPS"
      priority  = 2
      qualifier = "obytes"
    }
  ]
}

//module "authorize_cross_account" {
//  source = "../../../../modules/aws/iam/authorize"
//  prefix = local.prefix
//  common_tags = local.common_tags
//  account = var.kpr
//  resource_arn  = module.boomi.topic_arn
//}

module "oby_chatbot" {
  source = "../../../../modules/aws/chatbot"
  prefix = local.prefix
  common_tags = local.common_tags
  sns_topic_arns = concat(
    [module.boomi.boomi_cloudwatch_sns_arn],
  #FIXEME: you can add mode sns_topic below
    [],
  )
  slack_channel_id = var.chatbot_channel_id
  slack_workspace_id = var.chatbot_workspace_id
}