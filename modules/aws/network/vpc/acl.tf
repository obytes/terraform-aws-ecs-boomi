resource "aws_default_network_acl" "acl" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  subnet_ids = concat([ for subnet in aws_subnet.private : subnet.id ], [ for subnet in aws_subnet.public : subnet.id ],
  var.vpn_ep_subnet_ids)


  # Network ACL
  # allow all ports communications internally
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", "${local.prefix}-acl"
    )
  )
}
