#!/bin/sh
set -e

if [ -n "$CONFIG_FILE_SECRET_ID" ]
then
    echo Downloading CWA config
    aws secretsmanager get-secret-value --secret-id ${CONFIG_FILE_SECRET_ID} --query SecretString \
    --output text > /opt/aws/amazon-cloudwatch-agent/bin/default_linux_config.json
    echo CWA Config downloaded
fi

exec "$@"