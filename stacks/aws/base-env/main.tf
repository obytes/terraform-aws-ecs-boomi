locals {
  # ElasticCache
  common_tags = merge(
    var.common_tags,
    {
      "stack" = "${local.prefix}-env"
    },
  )
  prefix = "${var.prefix}-base"
}

