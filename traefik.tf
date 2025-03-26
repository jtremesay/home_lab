resource "kubernetes_manifest" "traefik" {
    manifest = {
        apiVersion = "helm.cattle.io/v1"
        kind: "HelmChartConfig"
        metadata = {
            name = "traefik"
            namespace = "kube-system"
        }
        spec = {
            valuesContent = <<EOF
ingressRoute:
  dashboard:
    enabled: true
    matchRule: Host("traefik.home.jtremesay.org")
    entryPoints:
      - websecure
    tls:
      certResolver: "letsencrypt"

ports:
  web:
    redirections:
      entryPoint:
        to: "websecure"
        scheme: "https"
        permanent: true

persistance:
  enabled: true

certResolvers:
  letsencrypt:
    email: "jonathan.tremesaygues@slaanesh.org"
    caServer: https://acme-v02.api.letsencrypt.org/directory
    httpChallenge:
        entryPoint: "web"
    storage: "/data/acme.json"
EOF
        }
    }
  
}