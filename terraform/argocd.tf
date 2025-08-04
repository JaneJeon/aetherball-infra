# First installation for ArgoCD chart;
# This is a 'bootstrap' step to ensure ArgoCD is installed in the cluster,
# but afterwards, ArgoCD will manage its own applications separately from Terraform.
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.6.12"

  depends_on = [google_container_node_pool.primary_nodes]

  values = [
    <<EOF
server:
  service:
    type: LoadBalancer
configs:
  params:
    server.insecure: true
EOF
  ]
}

# ArgoCD Application will be created manually after first deployment
# See manifests/argocd-app.yaml for the Application definition
