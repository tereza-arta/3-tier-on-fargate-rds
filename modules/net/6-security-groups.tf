#LB sg section
resource "aws_security_group" "for_lb" {
  count       = var.lb_sg_cnt
  name        = "${var.lb_sg_name}-${count.index}"
  vpc_id      = aws_vpc.vpc.id
  description = var.lb_sg_desc
  tags = {
    Name = var.lb_sg_tag
  }
}

resource "aws_security_group_rule" "lb_ing" {
  count             = length(var.lb_sg_ing)
  type              = "ingress"
  from_port         = var.lb_sg_ing[count.index].from
  to_port           = var.lb_sg_ing[count.index].to
  protocol          = var.lb_sg_ing[count.index].proto
  cidr_blocks       = [var.lb_sg_ing[count.index].cidr]
  description       = var.lb_sg_ing[count.index].desc
  security_group_id = aws_security_group.for_lb[count.index].id
}

resource "aws_security_group_rule" "lb_eg" {
  count             = var.lb_sg_eg_cnt
  type              = "egress"
  from_port         = var.lb_sg_single_eg ? var.lb_sg_eg[0].from : null
  to_port           = var.lb_sg_single_eg ? var.lb_sg_eg[0].to : null
  protocol          = var.lb_sg_single_eg ? var.lb_sg_eg[0].proto : null
  cidr_blocks       = var.lb_sg_single_eg ? var.lb_sg_eg[0].cidr : null
  description       = var.lb_sg_single_eg ? var.lb_sg_eg[0].desc : null
  security_group_id = aws_security_group.for_lb[count.index].id
}

#ECS sg section
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

resource "aws_security_group" "for_ecs" {
  count       = var.ecs_sg_cnt
  name        = "${var.ecs_sg_name}-${count.index}"
  vpc_id      = aws_vpc.vpc.id
  description = var.ecs_sg_desc
  tags = {
    Name = "${var.ecs_sg_tag}-${count.index}"
  }
}

resource "aws_security_group_rule" "ecs_ing" {
  count                    = length(var.with_ref_sg_ing)
  type                     = "ingress"
  from_port                = var.with_ref_sg_ing[count.index].from
  to_port                  = var.with_ref_sg_ing[count.index].to
  protocol                 = var.with_ref_sg_ing[count.index].proto
  description              = var.with_ref_sg_ing[count.index].desc
  security_group_id        = aws_security_group.for_ecs[count.index].id
  source_security_group_id = aws_security_group.for_lb[count.index].id
}

resource "aws_security_group_rule" "ecs_eg" {
  count             = var.with_ref_sg_eg_cnt
  type              = "egress"
  from_port         = var.lb_sg_single_eg ? var.sg_egress[0].from : null
  to_port           = var.lb_sg_single_eg ? var.sg_egress[0].to : null
  protocol          = var.lb_sg_single_eg ? var.sg_egress[0].proto : null
  cidr_blocks       = var.lb_sg_single_eg ? var.sg_egress[0].cidr : null
  description       = var.lb_sg_single_eg ? var.sg_egress[0].desc : null
  security_group_id = aws_security_group.for_ecs[count.index].id
}

#RDS sg section
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

resource "aws_security_group" "for_rds" {
  count       = var.rds_sg_cnt
  name        = "${var.rds_sg_name}-${count.index}"
  vpc_id      = aws_vpc.vpc.id
  description = var.rds_sg_desc
  tags = {
    Name = var.rds_sg_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "for_rds" {
  count             = var.rds_sg_ing_cnt
  security_group_id = aws_security_group.for_rds[count.index].id
  tags = {
    Name = var.rds_sg_ing_tag
  }

  from_port   = var.rds_ing_port
  to_port     = var.rds_ing_port
  ip_protocol = var.rds_ing_proto
  cidr_ipv4   = var.default_gateway
  description = var.rds_sg_ing_desc
}

resource "aws_vpc_security_group_egress_rule" "for_rds" {
  count             = var.rds_sg_eg_cnt
  security_group_id = aws_security_group.for_rds[count.index].id
  tags = {
    Name = var.rds_sg_eg_tag
  }

  #from_port
  #to_port
  ip_protocol = var.rds_eg_proto
  cidr_ipv4   = var.default_gateway
  description = var.rds_eg_desc
}
