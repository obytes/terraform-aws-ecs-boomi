resource "aws_ecs_task_definition" "this" {
  family                   = local.prefix
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  task_role_arn            = aws_iam_role.role.arn
  execution_role_arn       = aws_iam_role.role.arn

  volume {
    name      = "cgroup"
    host_path = "/sys/fs/cgroup"
  }

  container_definitions = <<DEFINITION
[
  {
    "image": "${var.repository_url}:${var.common_tags["env"]}",
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
        "value": "${var.params["id"]}"
      },
      {
        "name": "AWS_DEFAULT_REGION",
        "value": "${data.aws_region.current.name}"
      }
    ],
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": ${var.port},
        "hostPort": ${var.port}
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
        "env":"${local.common_tags["env"]}"
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
