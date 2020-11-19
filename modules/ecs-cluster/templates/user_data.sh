#!/bin/bash

yum update -y
cat > /etc/ecs/ecs.config << EOL
ECS_CLUSTER=${aws_ecs_cluster_name}
ECS_AVAILABLE_LOGGING_DRIVERS=["awslogs","fluentd"]
AWS_DEFAULT_REGION=${aws_ecs_default_region}
EOL

cat > /etc/logrotate.d/docker-container << EOL
/var/lib/docker/containers/*/*.log {
  rotate 7
  daily
  compress
  size=1M
  missingok
  delaycompress
  copytruncate
}
EOL

yum install -y awslogs aws-cli jq curl wget unzip telnet perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https perl-Digest-SHA.x86_64 amazon-efs-utils binutils

instance_arn=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .ContainerInstanceArn')
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}')

sudo echo "0 0 * * * root yum -y update --security >> /var/log/update.log 2>&1" >> /etc/crontab