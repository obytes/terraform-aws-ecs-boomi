# ecs
output "ecs" {
  value = {
    name = aws_ecs_cluster.default.name
    arn  = aws_ecs_cluster.default.arn
  }
}

output "repository_url" {
  value = aws_ecr_repository.this.repository_url
}

output "secrets_secret_manager" {
  value = {
    name = aws_secretsmanager_secret.secrets.name
    id = aws_secretsmanager_secret.secrets.id
    arn = aws_secretsmanager_secret.secrets.arn
  }
}

output "parameters_secret_manager" {
  value = {
    name  = aws_secretsmanager_secret.parameters.name
    id = aws_secretsmanager_secret.parameters.id
    arn = aws_secretsmanager_secret.parameters.arn
  }
}
output "kms_id" {
  value = aws_kms_key.default.id
}

output "s3_logging" {
  value = {
    id = module.s3_logging.id
    arn = module.s3_logging.arn
    bucket = module.s3_logging.bucket
  }
}
