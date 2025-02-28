data "aws_iam_policy_document" "policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_exec_role" {
  count = var.role_cnt
  name = var.role_name
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_rp_attach" {
  role = "${aws_iam_role.ecs_task_exec_role[var.index].name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "example" {
  count = var.cluster_cnt
  name = var.cluster_name

  tags = {
    Name = var.cluster_tag
  }
}

#data "aws_ecs_task_definition" "td" {
#  task_definition = aws_ecs_task_definition.td.family
#}

resource "aws_ecs_task_definition" "this" {
  count = var.task_def_cnt
  family = var.task_def_name
  requires_compatibilities = [var.launch_type]
  #execution_role_arn = var.index == 0 ? aws_iam_role.ecs_task_exec_role.arn : ""
  execution_role_arn = aws_iam_role.ecs_task_exec_role[var.index].arn
  network_mode = var.net_mode
  cpu = var.task_cpu
  memory = var.task_memory

  container_definitions = jsonencode ([
    {
      name = var.cnt_name
      image = "${var.repo_url[var.index]}:${var.image_tag}"
      cpu = var.cnt_cpu
      memory = var.cnt_memory
      essential = var.essential
      portMappings = [
        {
          containerPort = var.app_port
          hostPort = var.app_port
        }
      ]
      environment = var.app_port != 5000 ? [] : [
        {
          name = var.env_1
          value = var.db_username
        },
        {
          name = var.env_2
          value = var.db_password
        },
        {
          name = var.env_3
          value = var.db_name
        },
        {
          name = var.env_4
          value = var.db_host
        },
        {
          name = var.env_5
          value = var.db_port
        }
      ]
    }

  ])
  #depends_on = [var.task_def_dependency]
}

data "aws_subnets" "pub" {
  filter {
  name = "vpc-id"
  values = [var.vpc_id]
  }
}

data "aws_security_groups" "for_rds" {
  filter {
    name = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name = var.sg_filter_name
    values = [var.sg_filter_value]
  }
}


resource "aws_ecs_service" "this" {
  count = var.svc_cnt
  name = "${var.svc_name}-${count.index}"
  launch_type = var.launch_type
  platform_version = var.platform_version
  cluster = var.cluster_id_from_var ? var.cluster_id : aws_ecs_cluster.example[0].id
  task_definition = aws_ecs_task_definition.this[var.index].arn
  scheduling_strategy = var.scheduling
  desired_count = var.desired_count
  deployment_minimum_healthy_percent = var.min_healthy_perc
  deployment_maximum_percent = var.max_perc
  #iam_role = aws_iam_role.ecs_task_exec_role.arn

  depends_on = [aws_ecs_task_definition.this]

  network_configuration {
    assign_public_ip = var.pub_ip
    security_groups = [for i in data.aws_security_groups.for_rds.ids : i]
    subnets = [for i in data.aws_subnets.pub.ids : i]
  }
  load_balancer {
    target_group_arn = var.tg_arn
    container_name   = var.cnt_name
    container_port   = var.app_port
  }
}

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#data "aws_ecs_task_definition" "td" {
#  task_definition = aws_ecs_task_definition.td.family
#}

