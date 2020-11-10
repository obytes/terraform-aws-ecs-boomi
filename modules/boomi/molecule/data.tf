data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_kms_alias" "secrets_manager" {
  name = "alias/aws/secretsmanager"
}

data "aws_acm_certificate" "acm" {
  domain = "*.obytes.com"

  types = [
    "AMAZON_ISSUED",
  ]

  most_recent = true
}

data "aws_ecs_task_definition" "this" {
  task_definition = aws_ecs_task_definition.this.family
}

