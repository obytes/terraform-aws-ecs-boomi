// VPC

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.common_tags,
    map(
      "Name", "${local.prefix}-vpc"
    ),
    var.vpc_tags
  )

  lifecycle {
    prevent_destroy = false
  }
}
