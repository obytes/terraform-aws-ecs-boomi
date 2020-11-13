#!/bin/sh
set -e

# Load secrets from secret manager
# ================================
if [ -n "$SECRETS_ID" ]
then
    echo Exporting secrets
    aws secretsmanager get-secret-value --secret-id ${SECRETS_ID} --query SecretString \
    --output text | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' > /tmp/secrets.env
    eval $(cat /tmp/secrets.env | sed 's/^/export /')

    echo Exporting parameters
    aws secretsmanager get-secret-value --secret-id ${PARAMETERS_ID} --query SecretString \
    --output text | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' > /tmp/parameters.env
    eval $(cat /tmp/parameters.env | sed 's/^/export /')
fi

# Boomi atom molecule clustering
# ================================
if [ "${BOOMI_ENVIRONMENT_CLASS}" == "TEST" ]; then
  NODE_IP=$(awk 'END{print $1}' /etc/hosts)
else
  NODE_IP=$(curl -s http://169.254.170.2/v2/metadata | jq -r .Containers[0].Networks[0].IPv4Addresses[0])
fi
export ATOM_LOCALHOSTID=${NODE_IP}

echo ${ATOM_LOCALHOSTID}

exec "$@"