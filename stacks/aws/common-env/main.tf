locals {
  prefix = var.prefix

  common_tags = merge(
    var.common_tags,
    {
      "stack" = "${var.common_tags["project_name"]}-common-env"
    },
  )
}

