resource "kubernetes_deployment_v1" "whoami" {
  metadata {
    name = "whoami"
  }

  spec {
    selector {
      match_labels = {
        app = "whoami"
      }
    }
    replicas = 1
    template {
      metadata {
        labels = {
          app = "whoami"
        }
      }
      spec {
        container {
          name  = "whoami"
          image = "traefik/whoami"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "whoami" {
  metadata {
    name = "whoami"
  }

  spec {
    type = "ClusterIP"
    port {
      port = 80
    }
    selector = {
      app = "whoami"
    }
  }
}

resource "kubernetes_manifest" "whoami" {
  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "whoami"
      namespace = "default"
    }
    spec = {
      entryPoints = ["websecure"]
      routes = [
        {
          kind  = "Rule"
          match = "Host(`whoami.home.jtremesay.org`)"
          services = [
            {
                kind  = "Service"
                name  = "whoami"
                port  = 80
            }
          ]
        }
      ]
      tls = {
        certResolver = "letsencrypt"
      }
    }
  }
}
