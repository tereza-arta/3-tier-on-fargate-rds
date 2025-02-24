#LB sg section
resource "aws_security_group" "for_lb" {
  count = var.lb_sg_cnt
  name = "${var.lb_sg_name}-${count.index}"
  vpc_id = aws_vpc.vpc.id
  description =var.lb_sg_desc
  tags = {
    Name = var.lb_sg_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "for_lb" {
  count = length(var.lb_sg_ing)
  security_group_id = aws_security_group.for_lb[count.index].id
  tags = {
    Name = var.lb_sg_ing_tag
  }

  from_port = var.lb_sg_ing[count.index].from
  to_port = var.lb_sg_ing[count.index].to
  ip_protocol = var.lb_sg_ing[count.index].proto
  cidr_ipv4 = var.lb_sg_ing[count.index].cidr
  description = var.lb_sg_ing[count.index].desc
}

resource "aws_vpc_security_group_egress_rule" "for_lb" {
  count = length(var.lb_sg_eg)
  security_group_id = aws_security_group.for_lb[count.index].id
  tags = {
    Name = var.lb_sg_eg_tag
  }

  ip_protocol = var.lb_sg_eg[count.index].proto
  cidr_ipv4 = var.lb_sg_eg[count.index].cidr
  description = var.lb_sg_eg[count.index].desc
}

# ECS sg section
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

resource "aws_security_group" "for_ecs" {
  count = var.ecs_sg_cnt
  name = "${var.ecs_sg_name}-${count.index}"
  vpc_id = aws_vpc.vpc.id
  description = var.ecs_sg_desc
  tags = {
    Name = "${var.ecs_sg_tag}-${count.index}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "without_ref" {
  count = length(var.ecs_sg_ing_without_ref)
  security_group_id = aws_security_group.for_ecs[var.db_ecs_ind].id

  from_port = var.ecs_sg_ing_without_ref[count.index].from
  to_port = var.ecs_sg_ing_without_ref[count.index].to
  ip_protocol = var.ecs_sg_ing_without_ref[count.index].proto
  cidr_ipv4 = var.ecs_sg_ing_without_ref[count.index].cidr
  description = var.ecs_sg_ing_without_ref[count.index].desc

  tags = {
    Name = "${var.without_ref_ing_tag}-${count.index}"
  }
}

resource "aws_vpc_security_group_egress_rule" "without_ref" {
  security_group_id = aws_security_group.for_ecs[var.db_ecs_ind].id

  ip_protocol = var.sg_egress[0].proto
  cidr_ipv4 = var.sg_egress[0].cidr
  description = var.sg_egress[0].desc

  tags = {
    Name = var.without_ref_eg_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "with_ref" {
  count = var.with_ref_sg_ing_cnt
  security_group_id = aws_security_group.for_ecs[count.index + var.iter].id

  from_port = var.with_ref_sg_ing[count.index].from
  to_port = var.with_ref_sg_ing[count.index].to
  ip_protocol = var.with_ref_sg_ing[count.index].proto
  description = var.with_ref_sg_ing[count.index].desc
  referenced_security_group_id = aws_security_group.for_lb[count.index].id

  tags = {
    Name = "${var.with_ref_ing_tag}-${count.index}"
  }
}

resource "aws_vpc_security_group_egress_rule" "with_ref" {
  count = var.with_ref_sg_eg_cnt
  security_group_id = aws_security_group.for_ecs[count.index + var.iter].id

  ip_protocol = var.sg_egress[0].proto
  description = var.sg_egress[0].desc
  referenced_security_group_id = aws_security_group.for_lb[1].id

  tags = {
    Name = var.with_ref_eg_tag
  }
}

#RDS sg section
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

resource "aws_security_group" "for_rds" {
  count = var.rds_sg_cnt
  name = "${var.rds_sg_name}-${count.index}"
  vpc_id = aws_vpc.vpc.id
  description =var.rds_sg_desc
  tags = {
    Name = var.rds_sg_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "for_rds" {
  count = var.rds_sg_ing_cnt
  security_group_id = aws_security_group.for_rds[count.index].id
  tags = {
    Name = var.rds_sg_ing_tag
  }

  from_port = var.rds_ing_port
  to_port = var.rds_ing_port
  ip_protocol = var.rds_ing_proto
  cidr_ipv4 = var.default_gateway
  description = var.rds_sg_ing_desc
}

resource "aws_vpc_security_group_egress_rule" "for_rds" {
  count = var.rds_sg_eg_cnt
  security_group_id = aws_security_group.for_rds[count.index].id
  tags = {
    Name = var.rds_sg_eg_tag
  }

  #from_port
  #to_port
  ip_protocol = var.rds_eg_proto
  cidr_ipv4 = var.default_gateway
  description = var.rds_eg_desc
}
