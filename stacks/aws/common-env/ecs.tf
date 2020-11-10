resource "aws_ecs_cluster" "default" {
  name = local.prefix
}

