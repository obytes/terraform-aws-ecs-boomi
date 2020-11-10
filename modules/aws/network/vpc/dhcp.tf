// VPC DNS

resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name_servers = var.domain_name_servers

  tags = merge(
    local.common_tags,
    map(
      "Name", "${local.prefix}-dhcp"
    )
  )
}

resource "aws_vpc_dhcp_options_association" "dhcp-assoc" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id
}
