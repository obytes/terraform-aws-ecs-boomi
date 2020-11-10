data "aws_elb_service_account" "current" {
}

locals {
  common_tags = merge(
    var.common_tags,
    {
      "acl" = "log-delivery-write"
    },
  )
}

