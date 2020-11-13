# SECRETS: Should be edited manually from AWS console
resource "aws_secretsmanager_secret" "secrets" {
  name = "${local.prefix}-secs"
}

# PARAMETERS
resource "aws_secretsmanager_secret" "parameters" {
  name = "${local.prefix}-params"
}

resource "aws_secretsmanager_secret_version" "parameters" {
  secret_id     = aws_secretsmanager_secret.parameters.id
  secret_string = jsonencode(local.parameters)
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