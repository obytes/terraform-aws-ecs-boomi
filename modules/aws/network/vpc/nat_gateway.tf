// Public elastic load balancer
resource "aws_eip" "eip" {
  // for nat gateway use
  vpc = true

  tags = merge(
    local.common_tags,
    map(
      "Name", "${local.prefix}-iwg-eip"
    )
  )
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0)

  tags = merge(
    local.common_tags,
    map(
      "Name", "${local.prefix}-nat"
    )
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.common_tags,
    map(
      "Name", "${local.prefix}-igw"
    )
  )
}
