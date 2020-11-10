output "dns_names" {
  value = {
    boomi_molecule   = module.boomi.boomi_alb["dns_name"]
    boomi_events     = module.boomi.queue_url
  }
  //    pg_admin = "${module.pgAdmin.dns_name}"  //    odoo     = "${module.odoo_app.dns_names["odoo"]}"  //    nginx    = "${module.odoo_app.dns_names["nginx"]}"  // obybot = "${module.obybot_core_apps.dns_names["core"]}"
}

output "boomi_credentials" {
  value     = module.boomi.credentials
  sensitive = true
}
