resource "helm_release" "tailscale_operator" {
  depends_on = [google_container_node_pool.primary_nodes]

  name        = "tailscale-operator"
  description = "Tailscale Operator that allows us to create subnets and handle ingress/egress"

  repository = "https://pkgs.tailscale.com/helmcharts"
  chart      = "tailscale-operator"
  version    = "1.82.0"

  namespace        = "tailscale"
  create_namespace = true

  atomic            = true
  cleanup_on_fail   = true
  dependency_update = true
  wait              = true
  timeout           = 600

  set {
    name  = "oauth.clientId"
    value = var.tailscale_client_id
  }

  set_sensitive {
    name  = "oauth.clientSecret"
    value = var.tailscale_client_secret
  }
}
