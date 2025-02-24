module "net" {
  source = "./modules/net"
  count = var.enable_net ? 1 : 0
  
}

#module "lb" {
#  source = "./modules/lb"
#  count = var.enable_lb ? 1 : 0
#
#  vpc_id = module.net[0].vpc_id
#  lb_sg = module.net[0].lb_sg_id
#  subnets = module.net[0].pub_sub_id
#}

module "rds" {
  source = "./modules/rds"
  count = var.enable_rds ? 1 : 0

  vpc = module.net[0].vpc_id
}

module "ecr" {
  source = "./modules/ecr"
  count = var.enable_ecr ? 1 : 0

  #fnt_lb_dns_name = module.lb[0].dns_name
  #depends_on = [module.lb[0]]
}


module "ecs" {
  source = "./modules/ecs"
  count = var.enable_ecs ? 1 : 0

  repo_url = module.ecr[0].repo_url
  db_username = module.rds[0].username
  db_password = module.rds[0].password
  db_name = module.rds[0].db_name
  db_host = module.rds[0].rds_0_endpoint
  vpc_id = modules.net[0].vpc_id

  #tg_arn = module.lb[0].tg_arn
}
