#VPC(unnecessary)
variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "Cidr_block value of Vpc"
}

variable "tenancy" {
  default     = "default"
  description = "Specify tenancy type"
}

variable "dns_support" {
  type        = bool
  default     = true
  description = "Enable dns support or not"
}

variable "dns_hostname" {
  type        = bool
  default     = false
  description = "Enable dns hostname or not"
}

variable "addr_usage_metrics" {
  type        = bool
  default     = false
  description = "Enable net-addr usage metrics or not"
}

variable "vpc_tag" {
  default = "Custom VPC"
}

variable "vpc_additional_tag" {
  default = "VPC from tf"
}

#For multi-example Vpc
variable "vpc_cnt" {
  type    = number
  default = 0
}

variable "vpc_cidr_list" {
  default     = []
  description = "Cidr_block list for Vpc"
}

#Internet Gateway
variable "igw_tag" {
  default = "Custom Internet Gateway"
}

#Subnet section
variable "pub_sub_cnt" {
  type        = number
  default     = 2
  description = "The number of needed Public Subnets"
}

variable "priv_sub_cnt" {
  type        = number
  default     = 0
  description = "The number of needed Private Subnets"
}

variable "av_zones" {
  type    = list(string)
  default = ["eu-north-1a", "eu-north-1b"]
}

variable "map_public_ip" {
  type        = bool
  default     = true
  description = "Map pub-ip for public subnet"
}

variable "only_ipv6" {
  type        = bool
  default     = false
  description = "Create ipv6-only subnet or not"
}

variable "pub_sub_tag" {
  default = "Custom Public Subnet"
}

variable "priv_sub_tag" {
  default = "Custom Private Subnet"
}

variable "subnets_data_cnt" {
  type    = number
  default = 1
}

#Eip/NAT
variable "eip_cnt" {
  type    = number
  default = 0
}

variable "eip_domain" {
  default = "vpc"
}

variable "eip_tag" {
  default = "Elastic IP"
}

variable "nat_cnt" {
  type    = number
  default = 0
}

variable "nat_tag" {
  default = "NAT Gateway"
}

#Route Table
variable "default_gateway" {
  default = "0.0.0.0/0"
}

variable "rt_pub_tag" {
  default     = "Custom Route table for pub-sub"
  description = "Tag for second RT"
}

variable "rt_priv_tag" {
  default     = "Custom Route table for priv-sub"
  description = "Tag for second RT"
}

variable "priv_rt_cnt" {
  type    = number
  default = 0
}

#Security Group
variable "lb_sg_cnt" {
  type    = number
  default = 2
}

variable "lb_sg_name" {
  default = "Sg-for-LB"
}

variable "lb_sg_desc" {
  default = "Some-lb-sg-desc"
}

variable "lb_sg_tag" {
  default = "lb-sg-tag-value"
}

variable "lb_sg_ing" {
  type = list(object({
    from  = number
    to    = number
    proto = string
    cidr  = string
    desc  = string
  }))
  default = [
    {
      from  = 80
      to    = 80
      proto = "tcp"
      cidr  = "0.0.0.0/0"
      desc  = "Allow incoming back traffic"
    },
    {
      from  = 80
      to    = 80
      proto = "tcp"
      cidr  = "0.0.0.0/0"
      desc  = "Allow incoming front traffic"
    },
  ]
}

variable "lb_sg_eg_cnt" {
  type    = number
  default = 2
}

variable "lb_sg_single_eg" {
  type        = bool
  default     = true
  description = "Lb sec-group with single or multiple egress rules"
}

variable "lb_sg_eg" {
  type = list(object({
    from  = number
    to    = number
    proto = string
    cidr  = list(string)
    desc  = string
  }))
  default = [
    {
      from  = 0
      to    = 0
      proto = "-1"
      cidr  = ["0.0.0.0/0"]
      desc  = "Allow all outgoing traffic"
    },
  ]
}

variable "lb_sg_ing_tag" {
  default = "LB-sg-ingress-tag-value"
}

variable "lb_sg_eg_tag" {
  default = "LB-sg-egress-tag-value"
}

variable "ecs_sg_cnt" {
  type        = number
  default     = 2
  description = "Count of SG for ECS components"
}

variable "ecs_sg_name" {
  default = "Custom-ECS-sg"
}

variable "ecs_sg_desc" {
  default = "Some ecs-sg desc"
}

variable "ecs_sg_tag" {
  default = "ecs-sg-tag-value"
}

#variable "with_ref_sg_ing_cnt" {
#  type = number
#  default = 2
#}

variable "with_ref_sg_eg_cnt" {
  type    = number
  default = 2
}

variable "with_ref_sg_ing" {
  type = list(object({
    from  = number
    to    = number
    proto = string
    cidr  = string
    desc  = string
  }))
  default = [
    {
      from  = 5000
      to    = 5000
      proto = "tcp"
      cidr  = "0.0.0.0/0"
      desc  = "Allow incoming back traffic"
    },
    {
      from  = 3000
      to    = 3000
      proto = "tcp"
      cidr  = "0.0.0.0/0"
      desc  = "Allow incoming front traffic"
    },
  ]
}

variable "with_ref_ing_tag" {
  default = "with-ref-sg-ingress-tag"
}

variable "with_ref_eg_tag" {
  default = "with-ref-sg-ingress-tag"
}

variable "sg_egress" {
  type = list(object({
    from  = number
    to    = number
    proto = string
    cidr  = list(string)
    desc  = string
  }))
  default = [
    {
      from  = 0
      to    = 0
      proto = "-1"
      cidr  = ["0.0.0.0/0"]
      desc  = "Allow all outgoing traffic"
    },
  ]
}

variable "lb_sg_ind" {
  type    = number
  default = 1
}

variable "rds_sg_cnt" {
  type    = number
  default = 1
}

variable "rds_sg_name" {
  default = "Sg-for-RDS"
}

variable "rds_sg_desc" {
  default = "Allow pg-db incoming traffic from backend"
}

variable "rds_sg_tag" {
  default = "RDS-sg-tag-value"
}

variable "rds_sg_ing_cnt" {
  type    = number
  default = 1
}

variable "rds_sg_ing_tag" {
  default = "RDS-sg-ing-tag-value"
}

variable "rds_ing_port" {
  type    = number
  default = 5432
}

variable "rds_ing_proto" {
  default = "tcp"
}

variable "rds_sg_ing_desc" {
  default = "Allow incoming traffic dirrected to 5432 port-number"
}

variable "rds_sg_eg_cnt" {
  type    = number
  default = 1
}

variable "rds_sg_eg_tag" {
  default = "RDS-sg-eg-tag-value"
}

variable "rds_eg_proto" {
  default = "-1"
}

variable "rds_eg_desc" {
  default = "Allow all outgoing traffic"
}
