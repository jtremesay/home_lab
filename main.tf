module "home" {
  source        = "./modules/home"
  main_domain   = "home.jtremesay.org"
  others_domain = ["home.slaanesh.org"]
  providers = {
    kubernetes = kubernetes.home
  }
}