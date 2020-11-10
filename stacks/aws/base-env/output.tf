output "kms_arn" {
  value = aws_kms_key.default.arn
}

output "kms_id" {
  value = aws_kms_alias.default.id
}

output "kms_alias_name" {
  value = aws_kms_alias.default.name
}

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

# s3 buckets
output "s3_logging" {
  value = {
    id      = module.s3_logging.id
    bucket  = module.s3_logging.bucket
    arn     = module.s3_logging.arn
    address = module.s3_logging.aws_address
  }
}

