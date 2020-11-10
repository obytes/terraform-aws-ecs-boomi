// Route tables

resource "aws_default_route_table" "public_rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  lifecycle {
    # When attaching VPN gateways it is common to define aws_vpn_gateway_route_propagation
    # resources that manipulate the attributes of the routing table (typically for the private subnets)
    ignore_changes = [propagating_vgws]
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", "${local.prefix}-public-route-table",
      "description", "pubblic route used for api/web: public instances require public accessibility"
    )
  )
}

resource "aws_route" "public_route_gateway" {
  route_table_id = aws_default_route_table.public_rt.id

  depends_on = [
    aws_default_route_table.public_rt,
  ]

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "public_route_peer" {
  count = var.vpc_peers["gw_id"] == "" ? 0 : 1

  depends_on = [
    aws_default_route_table.public_rt,
  ]

  route_table_id = aws_default_route_table.public_rt.id

  destination_cidr_block = var.vpc_peers["cidr"]
  gateway_id             = var.vpc_peers["gw_id"]
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  lifecycle {
    # When attaching VPN gateways it is common to define aws_vpn_gateway_route_propagation
    # resources that manipulate the attributes of the routing table (typically for the private subnets)
    ignore_changes = [propagating_vgws]
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", "${local.prefix}-private-route-table",
      "description", "private route used for workers/services: private instances without public interfaces"
    )
  )
}

resource "aws_route" "private_route_nat_gateway" {
  route_table_id = aws_route_table.private_rt.id

  depends_on = [
    aws_route_table.private_rt,
  ]

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw.id
}

resource "aws_route" "private_route_peer" {
  count = var.vpc_peers["gw_id"] == "" ? 0 : 1

  depends_on = [
    aws_route_table.private_rt,
  ]

  route_table_id = aws_route_table.private_rt.id

  destination_cidr_block = var.vpc_peers["cidr"]
  gateway_id             = var.vpc_peers["gw_id"]
}

resource "aws_route_table_association" "rt_associate_public" {
  count          = length(var.public_ranges)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_default_route_table.public_rt.id
}

resource "aws_route_table_association" "rt_associate_private" {
  count          = length(var.private_ranges)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}
