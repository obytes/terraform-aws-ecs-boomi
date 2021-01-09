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
output "kms" {
  value = {
    id = aws_kms_key.default.id
    arn = aws_kms_key.default.arn
  }
}

//output "s3_logging" {
//  value = {
//    id = aws_s3_bucket.bucket.id
//    arn = aws_s3_bucket.bucket.arn
//    bucket = aws_s3_bucket.bucket.bucket
//  }
//}