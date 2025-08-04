# The operator is installed via terraform - for now - because passing secrets via ArgoCD requires some setup...
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

resource "kubernetes_manifest" "tailscale_subnet_router" {
  depends_on = [helm_release.tailscale_operator]

  manifest = {
    apiVersion = "tailscale.com/v1alpha1"
    kind       = "Connector"
    metadata = {
      name = "ts-pod-cidrs"
    }
    spec = {
      hostname = "ts-pod-cidrs"
      subnetRouter = {
        advertiseRoutes = [
          google_compute_subnetwork.subnet.ip_cidr_range,
          google_container_cluster.primary.services_ipv4_cidr
        ]
      }
    }
  }
}
