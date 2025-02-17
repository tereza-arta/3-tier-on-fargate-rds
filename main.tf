module "net" {
  source = "./modules/net"
  count = var.enable_net ? 1 : 0
  
}
