#################
# COMMON MODULE #
#################

output "s3_logging" {
  value = {
    id      = module.common.s3_logging.id
    bucket  = module.common.s3_logging.bucket
    arn     = module.common.s3_logging.arn
  }
}

output "repository_url" {
  value = module.common.repository_url
}

output "secrets_secret_manager" {
  value = module.common.secrets_secret_manager
}

output "parameters_secret_manager" {
  value = module.common.parameters_secret_manager
}

output "ecs" {
  value = module.common.ecs
}

output "kms_id" {
  value = module.common.kms_id
}

################
# BOOMI MODULE #
################

output "security_group_id" {
  value = module.boomi.security_group_id
}

output "service_name" {
  value = module.boomi.service_name
}

output "file_system_id" {
  value = module.boomi.file_system_id
}

output "aws_efs_access_point" {
  value = module.boomi.aws_efs_access_point
}
