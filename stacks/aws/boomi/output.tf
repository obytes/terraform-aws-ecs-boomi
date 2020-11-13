output "security_group_id" {
  value = module.molecule.security_group_id
}

output "credentials" {
  value = {
    id     = aws_iam_access_key.this.id
    secret = aws_iam_access_key.this.secret
  }
}

output "service_name" {
  value = module.molecule.service_name
}

output "file_system_id" {
  value = module.molecule.file_system_id
}

output "aws_efs_access_point" {
  value = module.molecule.aws_efs_access_point
}


