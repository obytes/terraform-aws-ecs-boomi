# s3 buckets
output "s3_artifacts" {
  value = {
    id     = aws_s3_bucket.artifacts.id
    arn    = aws_s3_bucket.artifacts.arn
    bucket = aws_s3_bucket.artifacts.bucket
  }
}

output "s3_settings" {
  value = {
    id     = aws_s3_bucket.settings.id
    arn    = aws_s3_bucket.settings.arn
    bucket = aws_s3_bucket.settings.bucket
  }
}

# ecs
output "ecs" {
  value = {
    name = aws_ecs_cluster.default.name
    arn  = aws_ecs_cluster.default.arn
  }
}

# security groups
output "security_group_ids" {
  value = {
    access_adm_http  = aws_security_group.adm_http.id
    access_adm_https = aws_security_group.adm_https.id
    access_adm_ssh   = aws_security_group.adm_ssh.id
  }
}

