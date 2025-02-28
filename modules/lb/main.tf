data "aws_subnets" "pub" {
  filter {
  name = "vpc-id"
  values = [var.vpc_id]
  }
}

resource "aws_lb" "some" {
  count = var.lb_cnt
  name = "${var.lb_name}-${count.index}"
  internal = var.internal
  load_balancer_type = var.lb_type
  security_groups = [element(var.lb_sg, count.index)]
  subnets = [for i in data.aws_subnets.pub.ids : i]
  enable_deletion_protection = var.del_protect

  tags = {
    Name = "${var.lb_tag}-${count.index}"
  }
}

resource "aws_lb_target_group" "some" {
  count = var.tg_cnt
  name = "${var.tg_name}-${count.index}"
  port = var.tg_port
  protocol = var.proto
  target_type = var.target_type
  vpc_id = var.vpc_id
  load_balancing_algorithm_type = var.lb_algorithm

  health_check {
    enabled = var.health_check
    healthy_threshold = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    path = var.checking_path
    #port = (def_value is traffic-port, i.e 5000 or 3000)
    protocol = var.checking_proto
  }

  tags = {
    Name = "${var.tg_tag}-${count.index}"
  }
}

resource "aws_lb_listener" "some" {
  count = var.lb_listener_cnt
  load_balancer_arn = aws_lb.some[count.index].arn
  port = var.listener_port[count.index]
  protocol = var.listener_proto
  #certificate_arn = var.ssl ? var.cert_arn : null

  default_action {
    type = var.listener_action_type
    target_group_arn = aws_lb_target_group.some[count.index].arn
  }
  tags = {
    Name = "${var.listener_tag}-${count.index}"
  }
}

