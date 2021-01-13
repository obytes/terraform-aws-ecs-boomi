# ----------------------------------------------------------------------------------------------------------------------
# Locals and Data Sources
# ----------------------------------------------------------------------------------------------------------------------

data "aws_elb_service_account" "current" {
}

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
    aws_ecs_cluster_name    = aws_ecs_cluster.default.name
    aws_ecs_default_region = data.aws_region.current.name
  }
}

locals {
  # This should be the same for all containers in other for clustering to work
  parameters = {
    URL                     = "https://platform.boomi.com"
    BOOMI_ENVIRONMENT_NAME  = "PROD"
    BOOMI_ENVIRONMENT_CLASS = "PRODUCTION"
    BOOMI_CONTAINERNAME     = "ecs-mol"
    BOOMI_ATOMNAME          = "ecs-atom"
    INSTALLATION_DIRECTORY  = "/var/boomi"
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# WS Resources
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_ecr_repository" "this" {
  name = join("-", [var.prefix, "ecr"])
}

resource "aws_ecs_cluster" "default" {
  name = join("-", [var.prefix, "cls"])
}

resource "aws_kms_key" "default" {
  description             = "For use on ${var.prefix}-kms"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "default" {
  name          = "alias/${var.prefix}-kms"
  target_key_id = aws_kms_key.default.key_id
}
# ----------------------------------------------------------------------------------------------------------------------
# S3 Logging Bucket
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket_object" "alb_folder" {
  bucket = var.s3_logging["bucket_name"]
  key = "/alb/"
}

resource "aws_s3_bucket_policy" "alb_policy" {
  bucket = var.s3_logging["bucket_name"]
  policy = data.aws_iam_policy_document.b.json
}

data "aws_iam_policy_document" "b" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${var.s3_logging["bucket_arn"]}/alb/*"]

    principals {
      identifiers = [data.aws_elb_service_account.current.arn]
      type        = "AWS"
    }
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# AWS Secrets [Secrets and Parameters]
# ----------------------------------------------------------------------------------------------------------------------
# SECRETS: Should be edited manually from AWS console
# The required secrets to be added via the console are BOOMI_ACCOUNTID and INSTALL_TOKEN
resource "aws_secretsmanager_secret" "secrets" {
  name = "${var.prefix}-secretsc"
}

# PARAMETERS
resource "aws_secretsmanager_secret" "parameters" {
  name = "${var.prefix}-parameters"
}

resource "aws_secretsmanager_secret_version" "parameters" {
  secret_id     = aws_secretsmanager_secret.parameters.id
  secret_string = jsonencode(local.parameters)
}

resource "aws_launch_configuration" "lc" {
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.profile.name
  image_id                    = data.aws_ami.ecs.id
  instance_type               = var.instance_type
  name_prefix                 = "${var.prefix}-lc"
  key_name                    = var.ssh_ec2_key_name
  security_groups = [
    var.default_sg_id,
  ]
  user_data_base64 = base64encode(data.template_file.user_data.rendered)
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "asg" {
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.lc.id
  max_size             = var.max_size
  min_size             = var.min_size
  name                 = "${var.prefix}-asg"

  vpc_zone_identifier = var.private_subnet_ids

  tag {
    key                 = "Name"
    value               = "${var.prefix}-asg"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.common_tags

    content {
      key    =  tag.key
      value   =  tag.value
      propagate_at_launch =  true
    }
  }
}
resource "aws_iam_policy" "policy" {
  name        = join("-", [var.prefix, "policy"])
  policy      = data.aws_iam_policy_document.policy.json
  description = "${var.prefix} ECS EC2 Policy"
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:Register*",
      "elasticloadbalancing:Deregister*",
      "ec2:Describe*",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:StartTask",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:Submit*",
      "application-autoscaling:Describe*",
      "application-autoscaling:Register*",
      "application-autoscaling:Deregister*",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:PutMetricData",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role" "role" {
  name               = join("-", [var.prefix, "role"])
  assume_role_policy = data.aws_iam_policy_document.assume.json
  description        = "${var.prefix} ECS EC2 Role"
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.role.name
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.prefix}-profile"
  role = aws_iam_role.role.name
}


