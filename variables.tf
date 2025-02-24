variable "enable_net" {
  type = bool
  default = true
  description = "Enable specified module or not"
}

variable "enable_rds" {
  type = bool
  default = true
  description = "Enable specified module or not"
}

variable "enable_lb" {
  type = bool
  default = true
  description = "Enable specified module or not"
}

variable "enable_ecr" {
  type = bool
  default = true
  description = "Enable specified module or not"
}

variable "enable_ecs" {
  type = bool
  default = true
  description = "Enable specified module or not"
}
