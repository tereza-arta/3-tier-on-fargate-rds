variable "cluster_name" {
  default = "mc"
  description = "Name of ecs cluster"
}

variable "role_cnt" {
  type = number
  default = 1
}

variable "role_name" {
  default = "ecsTaskExecutionRole"
  description = "Name of ecs task exec-role"
}

variable "cluster_cnt" {
  type = number
  default = 1
}

variable "cluster_tag" {
  default = "Cluster-tag-value"
}

variable "task_def_cnt" {
  type = number
  default = 1
}

variable "task_def_name" {}

#variable "task_def_name" {
#  type = list(string)
#  default = ["srv-task-def", "fnt-task-def"]
#  description = "List of task definitions name for app"
#}

variable "index" {
  type = number
  default = 0
}

variable "launch_type" {
  default = "FARGATE"
  description = "Ecs launch-type(default)"
}

variable "net_mode" {
  default = "awsvpc"
  description = "Ecs network-mode type"
}

variable "task_cpu" {
  type = number
  default = 1024
  description = "Number of CPU used by the task"
}

variable "task_memory" {
  type = number
  default = 2048
  description = "Amount of memory used by the task"
}

variable "cnt_name" {}

variable "repo_url"{}

#This must be same in ecr module variables
variable "image_tag" {
  default = "latest"
  description = "Default image tag for all ecr repos"
}

variable "cnt_cpu" {
  type = number
  default = 1024
  description = "Number of CPU used by the container"
}

variable "cnt_memory" {
  type = number
  default = 2048
  description = "Amount of memory used by the container"
}

variable "essential" {
  type = bool
  default = true
  description = "Mark specified container ass essential or not(def - true)"
}

variable "app_port" {
  type = number
}

variable "env_1" {
  default = "PGUSER"
}

variable "env_2" {
  default = "PGPASSWORD"
}

variable "env_3" {
  default = "PGDATABASE"
}

variable "env_4" {
  default = "PGHOST"
}

variable "env_5" {
  default = "PGPORT"
}

variable "db_username" {}
variable "db_password" {}
variable "db_name" {}
variable "db_host" {}

variable "db_port" {
  default = "5432"
}

variable "vpc_id" {}

variable "sg_filter_name" {
  default = "group-name"
}

variable "sg_filter_value" {
  default = "*ecs-sg-1*"
}

#variable "task_def_dependency" {}

variable "svc_cnt" {
  type = number
  default = 1
}

variable "svc_name" {}

variable "cluster_id_from_var" {
  type = bool
  default = false
  description = "Get cluster-id from custom variable or not"
}

variable "cluster_id" {}

variable "platform_version" {
  default = "LATEST"
  description = "Version of platform on which run task(s)"
}

variable "scheduling" {
  default = "REPLICA"
  description = "Specify type of scheduling stratagy"
}

variable "desired_count" {
  type = number
  default = 1
  description = "Number of instances of the task-definition"
}

variable "min_healthy_perc" {
  type = number
  default = 100
  description = "Minimum healthy tasks percentage of the deployment"
}

variable "max_perc" {
  type = number
  default = 200
  description = "Maximum current tasks percentage of the deployment "
}

variable "pub_ip" {
  type = bool
  default = true
  description = "Assign public-ip to ENI or not"
}

#variable "tg_arn" {}
