data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

locals {
  prefix      = "${var.prefix}"
  common_tags = "${merge(var.common_tags, {})}"
}
