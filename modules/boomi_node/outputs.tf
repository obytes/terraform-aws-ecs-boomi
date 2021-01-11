output "service_name" {
  value = aws_ecs_service.this.name
}

output "security_group_id" {
  value = aws_security_group.svc.id
}

output "file_system_id" {
  value = aws_efs_file_system.this.id
}

output "aws_efs_access_point" {
  value = aws_efs_access_point.this.id
}