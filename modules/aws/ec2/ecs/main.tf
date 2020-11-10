data "aws_region" "current" {}

data "aws_ami" "ecs" {

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0*-x86_64-ebs"]
  }

  most_recent = true
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.sh")

  vars = {
    aws_ecs_cluster_name    = var.ecs_cluster["name"]
    aws_ecs_default_region = data.aws_region.current.name
  }
}

locals {
  prefix      = "${var.prefix}-ecs"
  common_tags = var.common_tags
}
