resource "aws_ecs_service" "this" {
  name             = local.prefix
  cluster          = var.ecs_cluster_name

  task_definition = "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:task-definition/${aws_ecs_task_definition.this.family}:${max(
    aws_ecs_task_definition.this.revision,
    data.aws_ecs_task_definition.this.revision,
  )}"

  launch_type                       = "EC2"
  desired_count                     = var.desired_count
//  health_check_grace_period_seconds = 90

  network_configuration {
    security_groups = [
      aws_security_group.svc.id,
    ]
    subnets = var.private_subnet_ids
  }

//  load_balancer {
//    container_name   = var.container_name
//    container_port   = var.port
//    target_group_arn = aws_alb_target_group.this.id
//  }
//
//  depends_on = [aws_alb_listener.https]
}
