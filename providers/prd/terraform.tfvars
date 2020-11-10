cidr_block = "10.241.0.0/16"
private_ranges = [
  "10.241.110.0/24",
  "10.241.111.0/24",
]
public_ranges = [
  "10.241.100.0/24",
  "10.241.101.0/24",
]
region = "us-east-1"
#====================#
#    Databases       #
#====================#
rds_config_core = {
  db_name = "odoo"
  db_username = "odoo_role"
  db_password = "OnN1q1dzkVruzPMZrczw"
}

#=========================#
#    Give-Core Apps       #
#=========================#
odoo_secrets = {}
pg_admin_secrets = {
  PGADMIN_PASSWORD = "oFVYrBJz0pYejQxRcV7I"
}

obybot_apps_secrets = {
  secret_key = "aen+(odye2+nq5(fz5!2y#*(zurq$p28xn+-$4mjh_^@@p^-2)"
  slack_client_id = "505902901543.505904234407"
  slack_client_secret = "4d343c85bf275d6c3c6382755f99ef15"
  slack_signing_secret = "f399d2c790ac71c6ae70b39a4a5655c6"
  slack_verification_token = "kvtfNojsSUU1FHCzSu1pEwAt"
  slack_bot_user_token = "xoxb-505902901543-506255910838-mJFH82zmOor9bZODXlc8BbSw"
}
#====================#
#    RabbitMQ        #
#====================#
obybot_rabbitmq_config = {
  sync_node_count = 1
  secret_cookie = "Rqd2sfbjCultCsmwc5Qs"
  admin_password = "HWzLaan9YJrWicJQgBP2"
  rabbit_password = "21DdwfvsQWZzOMASMSpH"
  monitoring_password = "gxBDdTlmkNbGx4Hz0CUS"
  mq_user = "admin"
}

obybot_rds_config = {
  db_name = "core"
  identifier = "core"
  db_username = "app_user"
  db_password = "OnN1q1dzkVruzPMZrczw"
}

cf_account_id = "3ac09f1a017bab708037c9573c283cd2"
cf_token = "e10c37af05265158560ea85b6ce8ddcaa4edd"


#==============#
# AWS CHATBOT  #
#==============#
chatbot_workspace_id = "T0ARWANES"
chatbot_channel_id = "G01BLBNQLH4"