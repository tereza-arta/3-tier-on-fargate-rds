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
  name = var.role_name
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_rp_attach" {
  role = "${aws_iam_role.ecs_task_exec_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "example" {
  name = var.cluster_name

  tags = {
    Name = "Cluster-for-app"
  }
}

#data "aws_ecs_task_definition" "td" {
#  task_definition = aws_ecs_task_definition.td.family
#}

resource "aws_ecs_task_definition" "srv" {
  family = var.task_def_name[1]
  requires_compatibilities = [var.launch_type]
  execution_role_arn = aws_iam_role.ecs_task_exec_role.arn
  network_mode = var.net_mode
  cpu = var.task_cpu
  memory = var.task_memory

  container_definitions = jsonencode ([
    {
      name = var.cnt_name[1]
      image = "${var.repo_url[1]}:${var.image_tag}"
      cpu = var.cnt_cpu
      memory = var.cnt_memory
      essential = var.essential
      portMappings = [
        {
          containerPort = var.app_port[1]
          hostPort = var.app_port[1]
        }
      ]
      environment = var.app_port[1] != 5000 ? [] : [
        {
          name = "PGUSER"
          value = "user"
        },
        {
          name = "PGPASSWORD"
          value = "password"
        },
        {
          name = "PGDATABASE"
          value = "db"
        },
        {
          name = "PGHOST"
          #value = file("${path.module}/${var.db_ip_file}")
        },
        {
          name = "PGPORT"
          value = "5432"
        }
      ]
    }

  ])
  depends_on = [terraform_data.get_db_pub_ip]
}

resource "aws_ecs_service" "srv_svc" {
  name = "Srv-svc"
  launch_type = var.launch_type
  platform_version = var.platform_version
  cluster = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.srv.arn
  scheduling_strategy = var.scheduling
  desired_count = var.desired_count
  deployment_minimum_healthy_percent = var.min_healthy_perc
  deployment_maximum_percent = var.max_perc
  #iam_role = aws_iam_role.ecs_task_exec_role.arn

  depends_on = [aws_ecs_task_definition.srv]

  network_configuration {
    assign_public_ip = var.pub_ip
    security_groups = [var.sec_group_1]
    subnets = var.subnets
  }
  load_balancer {
    target_group_arn = var.tg_arn[0]
    container_name   = "srv-cnt"
    container_port   = 5000
  }
}

resource "aws_ecs_task_definition" "fnt" {
  family = var.task_def_name[2]
  requires_compatibilities = [var.launch_type]
  execution_role_arn = aws_iam_role.ecs_task_exec_role.arn
  network_mode = var.net_mode
  cpu = var.task_cpu
  memory = var.task_memory

  container_definitions = jsonencode ([
    {
      name = var.cnt_name[2]
      image = "${var.repo_url[2]}:${var.image_tag}"
      cpu = var.cnt_cpu
      memory = var.cnt_memory
      essential = var.essential
      portMappings = [
        {
          containerPort = var.app_port[2]
          hostPort = var.app_port[2]
        }
      ]
    }

  ])
  depends_on = [var.fnt_td_dependency]
}

resource "aws_ecs_service" "fnt_svc" {
  name = var.svc_name[2]
  launch_type = var.launch_type
  platform_version = var.platform_version
  cluster = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.fnt.arn
  scheduling_strategy = var.scheduling
  desired_count = 1
  deployment_minimum_healthy_percent = var.min_healthy_perc
  deployment_maximum_percent = var.max_perc
  #iam_role = aws_iam_role.ecs_task_exec_role.arn

  depends_on = [aws_ecs_task_definition.fnt]

  network_configuration {
    assign_public_ip = var.pub_ip
    security_groups = [var.sec_group_2]
    subnets = var.subnets
  }
}


#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#data "aws_ecs_task_definition" "td" {
#  task_definition = aws_ecs_task_definition.td.family
#}

#resource "aws_ecs_task_definition" "db" {
#  family = var.task_def_name[0]
#  requires_compatibilities = [var.launch_type]
#  execution_role_arn = aws_iam_role.ecs_task_exec_role.arn
#  network_mode = var.net_mode
#  cpu = var.task_cpu
#  memory = var.task_memory
#
#  container_definitions = jsonencode ([
#    {
#      name = var.cnt_name[0]
#      image = "${var.repo_url[0]}:${var.image_tag}"
#      cpu = var.cnt_cpu
#      memory = var.cnt_memory
#      essential = var.essential
#      portMappings = [
#        {
#          containerPort = var.app_port[0]
#          hostPort = var.app_port[0]
#        }
#      ]
#    }
#
#  ])
#  depends_on = [var.db_td_dependency]
#}

#resource "aws_ecs_service" "db_svc" {
#  name = var.svc_name[0]
#  launch_type = var.launch_type
#  platform_version = var.platform_version
#  cluster = aws_ecs_cluster.example.id
#  task_definition = aws_ecs_task_definition.db.arn
#  scheduling_strategy = var.scheduling
#  desired_count = 1
#  deployment_minimum_healthy_percent = var.min_healthy_perc
#  deployment_maximum_percent = var.max_perc
#  #iam_role = aws_iam_role.ecs_task_exec_role.arn
#
#  #depends_on = [aws_iam_role.ecs_task_exec_role]
#
#  network_configuration {
#    assign_public_ip = var.pub_ip
#    security_groups = [var.sec_group_0]
#    subnets = var.subnets
#  }
#}

#resource "terraform_data" "get_db_pub_ip" {
#  provisioner "local-exec" {
#    command = <<EOF
#    apt install jq
##    aws ecs list-tasks --cluster var.cluster_name --service var.svc_name[0] > out.json
##    aws ecs descibe-tasks --cluster var.cluster_name --tasks $(jq '.taskArns[]' out.json | tr -d '"') > out.json
##    jq '.tasks[]' out.json | jq '.attachments[]' | jq '.details[] | select(.name=="networkInterfaceId")' | jq -r '.value' > out.txt
##    aws ec2 describe-network-interfaces --network-interface-ids $(cat out.txt) > out.json
##    jq '.NetworkInterfaces[] | .Association | .PublicIp' out.json | tr -d '"' > out.txt
#    EOF
#  }
#  triggers_replace = {
#    "run_at" = timestamp()
#  }
#  depends_on = [aws_ecs_service.db_svc, aws_ecs_cluster.example]
#}
