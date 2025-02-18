#Load balancer
variable "lb_cnt" {
  type = number
  default = 2
}

variable "lb_name" {
  default = "Custom-lb"
}

variable "internal" {
  type = bool
  default = false
}

variable "lb_type" {
  default = "application"
}

variable "lb_sg" {}

variable "subnets" {}

variable "del_protect" {
  type = bool
  default = false
}

variable "lb_tag" {
  default = "some-lb-tag"
}

#Target group
variable "tg_cnt" {
  type = number
  default = 2
}

variable "tg_name" {
  default = "Custom-target-group"
}

variable "tg_port" {
  type = list(number)
  default = [5000, 3000]
}

variable "proto" {
  default = "HTTP"
}

variable "target_type" {
  default = "ip"
}

variable "vpc_id" {}

variable "lb_algorithm" {
  default = "round_robin"
}

variable "health_check" {
  type = bool
  default = true
  description = "Enable health-checking or not"
}

variable "healthy_threshold" {
  type = number
  default = 2
}

variable "unhealthy_threshold" {
  type = number
  default = 2
}

variable "checking_path" {
  default = "/"
}

variable "checking_port" {
  type = number
  default = "80"
}

variable "checking_proto" {
  default = "HTTP"
}

variable "tg_tag" {
  default = "tg-tag"
}

#Listener
variable "lb_listener_cnt" {
  type = number
  default = 2
}

#variable "lb_index" {
#  type = number
#  default =
#}

variable "listener_port" {
  type = list(string)
  default = ["5000", "3000"]
}

#variable "listener_proto" {
#  default = "#{protocol}"
#}

variable "listener_proto" {
  default = "HTTP"
}

variable "ssl" {
  type = bool
  default = false
  description = "Attach certificate or not"
}

#variable "cert_arn" {}

variable "listener_action_type" {
  default = "forward"
}

variable "listener_tag" {
  default = "listener-tag"
}

