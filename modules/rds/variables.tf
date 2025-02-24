variable "param_group_cnt" {
  type = number
  default = 1
}

variable "param_group_name" {
  default = "custom-param-group"
}

variable "param_group_desc" {
  default = "For updating ssl option"
}

variable "param_group_family" {
  default = "postgres15"
}

variable "param_1_name" {
  default = "rds.force_ssl"
}

variable "param_1_value" {
  default = "0"
}

variable "param_group_tag" {
  default = "Parameter-group-tag-val"
}

variable  "vpc" {
}

variable "sub_group_cnt" {
  type = number
  default = 1
}

variable "sub_group_name" {
  default = "custom-subnet-group"
}

variable "sub_group_desc" {
  default = "Non-default subnet-group"
}

#variable "subnet_ids" {}

variable "sub_group_tag" {
  default = "Subnet-group-tag-val"
}

variable "sg_filter_name" {
  default = "group-name"
}

variable "sg_filter_value" {
  default = "*RDS*"
}

variable "db_cnt" {
  type = number
  default = 1
}

variable "db_engine" {
  default = "postgres"
}

variable "engine_version" {
  default = "15.12"
}

variable "multi_az" {
  type = bool
  default = false
}

variable "identifier" {
  default = "rds-db"
}

variable "username" {
  default = "someuname"
}

variable "password" {
  default = "somePassword"
}

variable "instance_class" {
  default = "db.t3.micro"
}

variable "storage_type" {
  default = "gp3"
}

variable "alloc_storage" {
  type = number
  default = 50
}

variable "max_alloc_storage" {
  type = number
  default = 100
}

variable "pub_accessible" {
  type = bool
  default = false
  description = "Make db instance publicly accessable or not"
}

variable "db_init_name" {
  default = "pgdb"
}

variable "skip_snapshot" {
  type = bool
  default = true
}
