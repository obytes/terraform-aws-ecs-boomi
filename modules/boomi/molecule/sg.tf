resource "aws_security_group" "svc" {
  name        = "${local.prefix}-svc-sg"
  description = "${local.prefix} ECS service"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.prefix}-svc-sg"
    },
  )
}

# https://help.boomi.com/bundle/integration/page/c-atm-Cluster_monitoring_for_Molecules_and_Atom_Clouds.html
# https://community.boomi.com/s/article/moleculesetupformulticastbydefaultisnotclusteringcommunicatingwithothermoleculenodesproblemmultipleheadnodes
resource "aws_security_group_rule" "allow_multicast_between_nodes" {
  self              = true
  description       = "Allow MULTICAST clustering between nodes"
  security_group_id = aws_security_group.svc.id
  type              = "ingress"
  protocol          = "UDP"
  from_port         = 45588
  to_port           = 45588
}

# https://help.boomi.com/bundle/integration/page/t-atm-Setting_up_unicast_support.html
resource "aws_security_group_rule" "allow_unicast_between_nodes" {
  self              = true
  description       = "Allow UNICAST clustering between nodes"
  security_group_id = aws_security_group.svc.id
  type              = "ingress"
  protocol          = "TCP"
  from_port         = 7800
  to_port           = 7800
}

resource "aws_security_group_rule" "allow_alb" {
  description              = "Allow Traffic from ALB"
  security_group_id        = aws_security_group.svc.id
  source_security_group_id = aws_security_group.alb.id
  type                     = "ingress"
  protocol                 = "TCP"
  from_port                = var.port
  to_port                  = var.port
}


resource "aws_security_group" "alb" {
  name        = "${local.prefix}-alb-sg"
  description = "${local.prefix} Load balancer security group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.prefix}-alb-sg"
    },
  )
}

resource "aws_security_group_rule" "allow_security_groups" {
  count                    = length(var.allowed_security_group_ids)
  from_port                = 443
  to_port                  = 443
  protocol                 = "TCP"
  type                     = "ingress"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = var.allowed_security_group_ids[count.index]
}

resource "aws_security_group_rule" "allow_cidr_blocks" {
  count                    = length(var.allowed_cidr_blocks) == 0 ? 0:1
  from_port                = 443
  to_port                  = 443
  protocol                 = "TCP"
  type                     = "ingress"
  security_group_id        = aws_security_group.alb.id
  cidr_blocks              = var.allowed_cidr_blocks
}

resource "aws_security_group" "efs" {
  name        = "${local.prefix}-efs-sg"
  description = "${local.prefix} EFS service"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.prefix}-efs-sg"
    },
  )
}

resource "aws_security_group_rule" "allow_svc_to_efs" {
  description              = "Allow Traffic from Service nodes to EFS"
  security_group_id        = aws_security_group.efs.id
  source_security_group_id = aws_security_group.svc.id
  type                     = "ingress"
  protocol                 = "TCP"
  from_port                = 2049
  to_port                  = 2049
}

resource "aws_security_group_rule" "allow_sgs_to_efs" {
  count             = length(var.allowed_cidr_blocks) == 0 ? 0:1
  description       = "Allow cidr blocks to EFS"
  security_group_id = aws_security_group.efs.id
  cidr_blocks       = var.allowed_cidr_blocks
  type              = "ingress"
  protocol          = "TCP"
  from_port         = 2049
  to_port           = 2049
}
