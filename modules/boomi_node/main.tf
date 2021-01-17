# ----------------------------------------------------------------------------------------------------------------------
# Locals and Data Sources
# ----------------------------------------------------------------------------------------------------------------------
locals {
  volume_name = "molecule-storage"
  templates = join("/", [path.module, "templates"])
  cw_agent_config = {
    LOG_GROUP_NAME = aws_cloudwatch_log_group.boomi_log_files.name
    CW_REGION_NAME = data.aws_region.current.name
    LOG_STREAM_NAME = var.prefix
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# ----------------------------------------------------------------------------------------------------------------------
# AWS SecretsManager
# ----------------------------------------------------------------------------------------------------------------------
# AWS Agent Config File
resource "aws_secretsmanager_secret" "cloudwatch-config-file" {
  name = "${var.prefix}-cwa-cfg-file"
}

resource "aws_secretsmanager_secret_version" "config-file" {
  secret_id = aws_secretsmanager_secret.cloudwatch-config-file.id
  secret_string = templatefile(join("/", [local.templates, "cwa_config.json"]), { for key, value in local.cw_agent_config : key => value })
}
# ----------------------------------------------------------------------------------------------------------------------
# AWS Security Group and rules
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "svc" {
  name        = "${var.prefix}-svc-sg"
  description = "${var.prefix} ECS service"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      "Name" = "${var.prefix}-svc-sg"
    },
  )
}

# https://help.boomi.com/bundle/integration/page/c-atm-Cluster_monitoring_for_Molecules_and_Atom_Clouds.html
# https://community.boomi.com/s/article/moleculesetupformulticastbydefaultisnotclusteringcommunicatingwithothermoleculenodesproblemmultipleheadnodes
resource "aws_security_group_rule" "allow_multicast_between_nodes" {
  self              = true
  description       = "Allow MULTICAST clustering between nodes"
  security_group_id = aws_security_group.svc.id
  type              = "ingress"
  protocol          = "UDP"
  from_port         = 45588
  to_port           = 45588
}

# https://help.boomi.com/bundle/integration/page/t-atm-Setting_up_unicast_support.html
resource "aws_security_group_rule" "allow_unicast_between_nodes" {
  self              = true
  description       = "Allow UNICAST clustering between nodes"
  security_group_id = aws_security_group.svc.id
  type              = "ingress"
  protocol          = "TCP"
  from_port         = 7800
  to_port           = 7800
}

resource "aws_security_group_rule" "allow_alb" {
  description              = "Allow Traffic from ALB"
  security_group_id        = aws_security_group.svc.id
  source_security_group_id = aws_security_group.alb.id
  type                     = "ingress"
  protocol                 = "TCP"
  from_port                = var.atom_port
  to_port                  = var.atom_port
}


resource "aws_security_group" "alb" {
  name        = "${var.prefix}-alb-sg"
  description = "${var.prefix} Load balancer security group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      "Name" = "${var.prefix}-alb-sg"
    },
  )
}

resource "aws_security_group_rule" "allow_security_groups" {
  count                    = length(var.allowed_security_group_ids)
  from_port                = 443
  to_port                  = 443
  protocol                 = "TCP"
  type                     = "ingress"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = var.allowed_security_group_ids[count.index]
}

resource "aws_security_group_rule" "allow_cidr_blocks" {
  count                    = length(var.allowed_cidr_blocks) == 0 ? 0:1
  from_port                = 443
  to_port                  = 443
  protocol                 = "TCP"
  type                     = "ingress"
  security_group_id        = aws_security_group.alb.id
  cidr_blocks              = var.allowed_cidr_blocks
}

resource "aws_security_group" "efs" {
  name        = "${var.prefix}-efs-sg"
  description = "${var.prefix} EFS service"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      "Name" = "${var.prefix}-efs-sg"
    },
  )
}

resource "aws_security_group_rule" "allow_svc_to_efs" {
  description              = "Allow Traffic from Service nodes to EFS"
  security_group_id        = aws_security_group.efs.id
  source_security_group_id = aws_security_group.svc.id
  type                     = "ingress"
  protocol                 = "TCP"
  from_port                = 2049
  to_port                  = 2049
}

resource "aws_security_group_rule" "allow_sgs_to_efs" {
  count             = length(var.allowed_cidr_blocks) == 0 ? 0:1
  description       = "Allow cidr blocks to EFS"
  security_group_id = aws_security_group.efs.id
  cidr_blocks       = var.allowed_cidr_blocks
  type              = "ingress"
  protocol          = "TCP"
  from_port         = 2049
  to_port           = 2049
}
# ----------------------------------------------------------------------------------------------------------------------
# AWS SNS
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_sns_topic" "cloudwatch_alarms" {
  name = "${var.prefix}-cw-alarms"
  tags = var.common_tags
}

resource "aws_sns_topic_policy" "this" {
  arn = aws_sns_topic.cloudwatch_alarms.arn
  policy = data.aws_iam_policy_document.this.json
}
data "aws_iam_policy_document" "this" {
  statement {
    sid = "AllowCloudWatchAlarms"
    principals {
      identifiers = ["cloudwatch.amazonaws.com"]
      type = "Service"
    }
    effect = "Allow"
    actions = [
      "sns:Publish"
    ]
    resources = [
      aws_sns_topic.cloudwatch_alarms.arn
    ]
  }
}
# ----------------------------------------------------------------------------------------------------------------------
# AWS Cloudwatch
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${var.prefix}"
  retention_in_days = 30

  tags = var.common_tags
}

## Log Group for CW Agent sidecar container
resource "aws_cloudwatch_log_group" "cwa" {
  name              = "/aws/ecs/${var.prefix}-cw-logs"
  retention_in_days = 7

  tags = var.common_tags
}

resource "aws_cloudwatch_log_group" "boomi_log_files" {
  name              = "${var.prefix}-log-files"
  retention_in_days = 30

  tags = var.common_tags
}

resource "aws_cloudwatch_log_metric_filter" "boomi_metric_filter_error_401" {
  log_group_name = aws_cloudwatch_log_group.boomi_log_files.name
  name = "${aws_cloudwatch_log_group.boomi_log_files.name}-filter"
  pattern = "{$.Code >= 400}"
  metric_transformation {
    name = "ErrorGreaterThan400"
    namespace = "BOOMI_METRIC"
    value = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "boomi_metric_alarm_http_401" {
  alarm_name = "${var.prefix}-boomi-http-400"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 1
  metric_name = aws_cloudwatch_log_metric_filter.boomi_metric_filter_error_401.metric_transformation[0].name
  namespace = "BOOMI_METRIC"
  period = 60
  statistic = "Average"
  threshold = 0
  datapoints_to_alarm = 1
  alarm_description = "Alarm to be triggered if the number of HTTP_401 is greater than 0 for the last minute"
  treat_missing_data = "missing"
  alarm_actions = [aws_sns_topic.cloudwatch_alarms.arn]
  tags = var.common_tags
}
# ----------------------------------------------------------------------------------------------------------------------
# AWS EFS, AccessPoint and EFS IAM Roles
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_efs_file_system" "this" {
  creation_token = "molecule-fs"

  encrypted        = false
  throughput_mode  = "bursting"
  performance_mode = "maxIO"

  tags = {
    Name = "MoleculeFileSystem"
  }
}

resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id
}

resource "aws_efs_mount_target" "this" {
  count = length(var.private_subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = element(var.private_subnet_ids, count.index)
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_file_system_policy" "this" {
  file_system_id = aws_efs_file_system.this.id
  policy         = data.aws_iam_policy_document.efs.json
}

data "aws_iam_policy_document" "efs" {
  statement {

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
      "elasticfilesystem:ClientRootAccess",
    ]

    resources = [
      aws_efs_file_system.this.arn
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = [
        "true"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "elasticfilesystem:AccessPointArn"
      values   = [
        aws_efs_access_point.this.arn
      ]
    }
  }
}
# ----------------------------------------------------------------------------------------------------------------------
# AWS ECS Service, task Definition, IAM AssumeRoles & Policies
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_ecs_service" "this" {
  name             = var.prefix
  cluster          = var.ecs_cluster_name["name"]
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

resource "aws_ecs_task_definition" "this" {
  family                   = var.prefix
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = var.task_definition_cpu
  memory                   = var.task_definition_memory
  task_role_arn            = aws_iam_role.role.arn
  execution_role_arn       = aws_iam_role.role.arn

  volume {
    name      = "cgroup"
    host_path = "/sys/fs/cgroup"
  }

  container_definitions = <<DEFINITION
[
  {
    "image": "${var.repository_url}:${var.image_tag}",
    "name": "${var.container_name}",
    "networkMode": "awsvpc",
    "entryPoint": [
      "sh", "/home/boomi/entrypoint.sh"
    ],
    "command": [
      "/sbin/init"
    ],
    "privileged": false,
    "pseudoTerminal": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.this.name}",
        "awslogs-region": "${data.aws_region.current.name}",
        "awslogs-stream-prefix": "${var.prefix}"
      }
    },
    "environment": [
      {
        "name": "SECRETS_ID",
        "value": "${var.secrets["id"]}"
      },
      {
        "name": "PARAMETERS_ID",
        "value": "${var.parameters["id"]}"
      },
      {
        "name": "AWS_DEFAULT_REGION",
        "value": "${data.aws_region.current.name}"
      }
    ],
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": ${var.atom_port},
        "hostPort": ${var.atom_port}
      },
      {
        "protocol": "udp",
        "containerPort": 45588,
        "hostPort": 45588
      },
      {
        "protocol": "tcp",
        "containerPort": 7800,
        "hostPort": 7800
      }
    ],
    "linuxParameters": {
      "tmpfs": [
        {
          "containerPath": "/tmp",
          "size": 128
        },
        {
          "containerPath": "/run",
          "size": 128
        }
      ]
    },
    "mountPoints": [
        {
            "containerPath": "/var/boomi",
            "sourceVolume": "${local.volume_name}"
        },
        {
          "containerPath": "/sys/fs/cgroup",
          "sourceVolume": "cgroup",
          "readOnly": true
        }
    ],
    "dockerLabels":
      {
        "ContainerName":"${var.container_name}"
      }
  },
  {
    "name": "${var.cloudwatch_container_name}",
    "image": "${var.repository_url}:${var.cwa_tag}",
    "entryPoint": [
      "sh", "CWA_entrypoint.sh"
    ],
    "command": [
      "/opt/aws/amazon-cloudwatch-agent/bin/start-amazon-cloudwatch-agent"
      ],
    "environment": [
      {
        "name": "CONFIG_FILE_SECRET_ID",
        "value": "${aws_secretsmanager_secret.cloudwatch-config-file.name}"
      },
      {
        "name": "AWS_DEFAULT_REGION",
        "value": "${data.aws_region.current.name}"
      }
    ],
    "mountPoints": [
        {
            "containerPath": "/var/boomi",
            "sourceVolume": "${local.volume_name}"
        },
        {
          "containerPath": "/sys/fs/cgroup",
          "sourceVolume": "cgroup",
          "readOnly": true
        }
    ],
    "essential": true,
    "privileged": false,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.cwa.name}",
        "awslogs-region": "${data.aws_region.current.name}",
        "awslogs-stream-prefix": "${var.prefix}-log"
      }
    },
    "dockerLabels":
      {
        "name":"${var.cloudwatch_container_name}"
      }
  }
]
DEFINITION


  volume {
    name = local.volume_name

    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.this.id
      root_directory          = "/"

      transit_encryption      = "ENABLED"
      transit_encryption_port = 2999

      authorization_config {
        access_point_id = aws_efs_access_point.this.id
        iam             = "ENABLED"
      }
    }
  }
}

resource "aws_iam_role" "role" {
  name               = var.prefix
  description        = "${var.prefix} Role"
  assume_role_policy = data.aws_iam_policy_document.assume.json

  force_detach_policies = true
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.amazonaws.com",
        "ec2.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_policy" "policy" {
  path        = "/"
  description = "${var.prefix} Policy"
  policy      = data.aws_iam_policy_document.policy.json
  name        = var.prefix
}

data "aws_iam_policy_document" "policy" {
 statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "cloudwatch:PutMetricData",
      "ec2:DescribeVolumes",
      "ec2:DescribeTags",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    resources = [
      var.kms["arn"],
    ]
  }

  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]

    resources = [
      var.secrets["arn"],
      var.parameters["arn"],
      aws_secretsmanager_secret.cloudwatch-config-file.arn
    ]
  }
}

resource "aws_iam_role_policy_attachment" "attach_custom_policy" {
  role       = aws_iam_role.role.id
  policy_arn = aws_iam_policy.policy.arn
}

