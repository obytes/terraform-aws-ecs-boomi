resource "aws_ecs_service" "this" {
  name             = local.prefix
  cluster          = var.ecs_cluster_name
  task_definition = aws_ecs_task_definition.this.arn
  launch_type                       = "EC2"
  desired_count                     = var.desired_count

  network_configuration {
    security_groups = [
      aws_security_group.svc.id,
    ]
    subnets = var.private_subnet_ids
  }

}
