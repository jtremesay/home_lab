terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
  }

  backend "kubernetes" {
    secret_suffix = "state"
    config_path    = "~/.kube/config"
    config_context = "home"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "home"
}


