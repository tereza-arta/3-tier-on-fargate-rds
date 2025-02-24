resource "aws_db_parameter_group" "this" {
  count = var.param_group_cnt
  name = var.param_group_name
  description = var.param_group_desc
  family = var.param_group_family

  parameter {
    name = var.param_1_name
    value = var.param_1_value
  }

  tags = {
    Name = var.param_group_tag
  }
}

data "aws_subnets" "pub" {
  filter {
  name = "vpc-id"
  values = [var.vpc]
  }
}

resource "aws_db_subnet_group" "this" {
  count = var.sub_group_cnt
  name = var.sub_group_name
  description = var.sub_group_desc
  subnet_ids = [for i in data.aws_subnets.pub.ids : i]

  tags = {
    Name = var.sub_group_tag
  }
}

data "aws_security_groups" "for_rds" {
  filter {
    name = "vpc-id"
    values = [var.vpc]
  }
  filter {
    name = var.sg_filter_name
    values = [var.sg_filter_value]
  }
}

resource "aws_db_instance" "this" {
  count = var.db_cnt
  engine = var.db_engine
  engine_version = var.engine_version
  multi_az = var.multi_az
  identifier = var.identifier
  username = var.username
  password = var.password
  #manage_master_user_password = var.aws_sm_pass
  instance_class = var.instance_class
  storage_type = var.storage_type
  allocated_storage = var.alloc_storage
  max_allocated_storage = var.max_alloc_storage
  db_subnet_group_name = aws_db_subnet_group.this[0].name
  publicly_accessible = var.pub_accessible
  vpc_security_group_ids = [for i in data.aws_security_groups.for_rds.ids : i]
  db_name = var.db_init_name
  parameter_group_name = aws_db_parameter_group.this[0].name
  skip_final_snapshot = var.skip_snapshot
}
