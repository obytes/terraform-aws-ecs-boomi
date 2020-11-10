output "alb" {
  value = {
    dns_name = aws_alb.this.dns_name
    zone_id  = aws_alb.this.zone_id
  }
}

output "service_name" {
  value = aws_ecs_service.this.name
}

output "security_group_id" {
  value = aws_security_group.svc.id
}

output "repository_url" {
  value = aws_ecr_repository.this.repository_url
}

output "file_system_id" {
  value = aws_efs_file_system.this.id
}

output "aws_efs_access_point" {
  value = aws_efs_access_point.this.id
}

output "secrets_arn" {
  value = [
    aws_secretsmanager_secret.secrets.arn,
    aws_secretsmanager_secret.parameters.arn
  ]
}

output "secrets_id" {
  value = {
    secs = aws_secretsmanager_secret.secrets.id
    params = aws_secretsmanager_secret.parameters.id
  }
}

output "boomi_cloudwatch_sns_arn" {
  value = aws_sns_topic.cloudwatch_alarms.arn
}