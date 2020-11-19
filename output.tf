#################
# ecs-cluster MODULE #
#################

output "s3_logging" {
  value = {
    id      = module.ecs-cluster.s3_logging.id
    bucket  = module.ecs-cluster.s3_logging.bucket
    arn     = module.ecs-cluster.s3_logging.arn
  }
}

output "repository_url" {
  value = module.ecs-cluster.repository_url
}

output "secrets_secret_manager" {
  value = module.ecs-cluster.secrets_secret_manager
}

output "parameters_secret_manager" {
  value = module.ecs-cluster.parameters_secret_manager
}

output "ecs" {
  value = module.ecs-cluster.ecs
}

output "kms" {
  value = module.ecs-cluster.kms
}

################
# boomi_node MODULE #
################

output "security_group_id" {
  value = module.boomi_node.security_group_id
}

output "service_name" {
  value = module.boomi_node.service_name
}

output "file_system_id" {
  value = module.boomi_node.file_system_id
}

output "aws_efs_access_point" {
  value = module.boomi_node.aws_efs_access_point
}