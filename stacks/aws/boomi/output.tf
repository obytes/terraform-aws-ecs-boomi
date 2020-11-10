output "boomi_alb" {
  value = module.molecule.alb
}

output "security_group_id" {
  value = module.molecule.security_group_id
}

output "queue_url" {
  value = module.events.queue_url
}


output "credentials" {
  value = {
    id     = aws_iam_access_key.this.id
    secret = aws_iam_access_key.this.secret
  }
}

output "topic_arn" {
  value = module.events.topic_arn
}

output "efs_filesystem_id" {
  value = module.molecule.file_system_id
}

output "efs_access_point_id" {
  value = module.molecule.aws_efs_access_point
}

output "boomi_cloudwatch_sns_arn" {
  value = module.molecule.boomi_cloudwatch_sns_arn
}

