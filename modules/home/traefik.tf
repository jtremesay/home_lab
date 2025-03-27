resource "kubernetes_manifest" "traefik" {
  manifest = {
    apiVersion = "helm.cattle.io/v1"
    kind : "HelmChartConfig"
    metadata = {
      name      = "traefik"
      namespace = "kube-system"
    }
    spec = {
      valuesContent = <<EOF
ingressRoute:
  dashboard:
    enabled: true
    matchRule: ${join(" || ", formatlist("Host(`traefik.%s`)", local.domains))}
    entryPoints:
      - websecure
    tls:
      certResolver: "letsencrypt"

ports:
  metrics:

  web:
    redirectTo:
      port: "websecure"

  websecure:
    http3:
      enabled: true

persistence:
  enabled: true

certResolvers:
  letsencrypt:
    email: "jonathan.tremesaygues@slaanesh.org"
    caServer: https://acme-v02.api.letsencrypt.org/directory
    httpChallenge:
        entryPoint: "web"
    storage: "/data/acme.json"

metrics:
  prometheus: null
EOF
    }
  }

}