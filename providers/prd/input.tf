#==========================#
#   Common details         #
#==========================#
variable "env" {
  default = "prd"
}

variable "project_name" {
  default = "oby"
}

variable "region" {
  default = "us-east-1"
}

variable "aws_profile" {
  default = "obytes"
}

#===================#
#   Network         #
#===================#
variable "cidr_block" {
}

variable "public_ranges" {
  type = list(string)
}

variable "private_ranges" {
  type = list(string)
}

#===================#
#   Database        #
#===================#

variable "rds_config_core" {
  type = map(string)
}

variable "database_allocated_storage" {
  default = "5"
}

variable "database_monitoring_interval" {
  default = "15"
}

variable "database_db_type" {
  default = "db.t2.medium"
}

variable "database_auto_minor_version_upgrade" {
  default = true
}

#======================================#
#   Application vars & secrets         #
#======================================#
variable "odoo_secrets" {
  type = map(string)

  description = <<EOF

    odoo_secrets = {

    }

EOF

}

variable "ecs_instance_type" {
  default = "t2.medium"
}

variable "obybot_apps_secrets" {
  type = map(string)
}

variable "webhook_secret" {
  default = "whatever"
}

variable "obybot_rabbitmq_config" {
  type = map(string)
}

variable "obybot_rds_config" {
  type = map(string)
}

# Cloudflare
variable "cf_account_id" {}

variable "cf_token" {}


#=============================#
# Cross Account Authorization #
#=============================#
variable "kpr" {
  default = {
    account_id = "047147293236"
    account_name = "kpr"
    service_name = "SNS"
    service_action = "Publish"
    assumed_role_name = "qa-kpr-useast1-admin-role",
  }
}

#================#
#  AWS CHATBOT   #
#================#

variable "chatbot_workspace_id" {
  type = string
}

variable "chatbot_channel_id" {
  type = string
}