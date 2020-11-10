resource "aws_iam_policy" "policy" {
  name        = "${local.prefix}-policy"
  policy      = data.aws_iam_policy_document.policy.json
  description = "${local.prefix} ECS EC2 Policy"
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
  name               = local.prefix
  assume_role_policy = data.aws_iam_policy_document.assume.json
  description        = "${local.prefix} ECS EC2 Role"
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
  name = "${local.prefix}-profile"
  role = aws_iam_role.role.name
}
