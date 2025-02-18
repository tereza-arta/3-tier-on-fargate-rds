module "net" {
  source = "./modules/net"
  count = var.enable_net ? 1 : 0
  
}

module "lb" {
  source = "./modules/lb"
  count = var.enable_lb ? 1 : 0

  vpc_id = module.net[0].vpc_id
  lb_sg = module.net[0].lb_sg_id
  subnets = module.net[0].pub_sub_id
}

module "ecr" {
  source = "./modules/ecr"
  count = var.enable_ecr ? 1 : 0

  fnt_lb_dns_name = module.lb[0].dns_name
  depends_on = [module.lb[0]]
}

module "ecs" {
  source = "./modules/ecs"
  count = var.enable_ecs ? 1 : 0

  repo_url = module.ecr[0].repo_url
  db_td_dependency = module.ecr[0].thingy
  fnt_td_dependency = module.ecs[0].thingy
  sec_group_0 = module.net[0].ecs_sg_0_id
  sec_group_1 = module.net[0].ecs_sg_1_id
  sec_group_2 = module.net[0].ecs_sg_2_id
  subnets = module.net[0].pub_sub_id
  tg_arn = module.lb[0].tg_arn
 
}
