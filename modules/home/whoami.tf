data "docker_registry_image" "whoami" {
  name = "traefik/whoami"
}

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
          image = "traefik/whoami@${data.docker_registry_image.whoami.sha256_digest}"
          port {
            container_port = 80
            name = "http"
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
      name = "http"
      target_port = "http"
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
          match = join(" || ", formatlist("Host(`whoami.%s`)", local.domains))
          services = [
            {
              kind = "Service"
              name = "whoami"
              port = "http"
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

