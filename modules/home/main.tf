locals {
  domains = concat([var.main_domain], var.others_domain)
}