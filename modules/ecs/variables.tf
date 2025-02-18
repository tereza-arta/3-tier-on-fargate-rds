variable "cluster_name" {
  default = "app-cluster"
  description = "Name of ecs cluster"
}

variable "role_name" {
  default = "ecsTaskExecutionRoleSome"
  description = "Name of ecs task exec-role"
}

variable "task_def_cnt" {
  type = number
  default = 2
}

variable "task_def_name" {
  type = list(string)
  default = ["db-task-def", "srv-task-def", "fnt-task-def"]
  description = "List of task definitions name for app"
}

variable "launch_type" {
  default = "FARGATE"
  description = "Ecs launch-type"
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

variable "cnt_name" {
  type = list(string)
  default = ["db-cnt", "srv-cnt", "fnt-cnt"]
}

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
  type = list(number)
  default = [5432, 5000, 3000]
}

variable "db_td_dependency" {}

variable "fnt_td_dependency" {}

variable "svc_name" {
  type = list(string)
  default = ["db-svc", "srv-svc", "fnt-svc"]
  description = "Ecs service name for all app components"
}

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

variable "sec_group_0" {}
variable "sec_group_1" {}
variable "sec_group_2" {}

variable "subnets" {}

variable "db_ip_file" {
  default = "out.txt"
}

variable "tg_arn" {}
