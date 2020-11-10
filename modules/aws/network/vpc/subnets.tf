// Subnet ranges

resource "aws_subnet" "private" {
  count = length(var.private_ranges)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_ranges, count.index)
  availability_zone = element(var.zones[data.aws_region.current.name], count.index)

  tags = merge(
    local.common_tags,
    map(
      "Name", "${local.prefix}-private-${element(var.zones[data.aws_region.current.name], count.index)}",
      "description", "private route used for workers/services: private instances without public interfaces"
    ),
    var.private_subnet_tags
  )

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_ranges)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_ranges, count.index)
  availability_zone       = element(var.zones[data.aws_region.current.name], count.index)
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    map(
      "Name", "${local.prefix}-public-${element(var.zones[data.aws_region.current.name], count.index)}",
      "description", "pubblic route used for api/web: public instances require public accessibility"
    ),
    var.public_subnet_tags
  )

  lifecycle {
    prevent_destroy = false
  }
}
