output "cidr_block" {
  value = module.network.vpc["cidr_block"]
}

output "vpc_id" {
  value = module.network.vpc["vpc_id"]
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "default_sg_id" {
  value = module.network.default_sg_id
}

output "private_route_table_ids" {
  value = module.network.private_route_table_ids
}

output "public_route_table_ids" {
  value = module.network.public_route_table_ids
}

