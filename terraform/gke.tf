# Minimal setup
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.zone

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  # IPv6 support
  ip_allocation_policy {
    stack_type = "IPV4_IPV6"
  }
  datapath_provider = "ADVANCED_DATAPATH"

  monitoring_config {
    # Enable managed Prometheus for metrics collection
    managed_prometheus {
      enabled = true
    }

    # Enable advanced datapath observability
    advanced_datapath_observability_config {
      enable_metrics = true
      enable_relay   = true
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.project_id}-gke-nodes"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = 2

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    # https://cloud.google.com/compute/all-pricing?hl=en#section-18
    machine_type = "e2-small"

    # TODO: provision a service account with the minimum required permissions
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = var.project_id
    }
    tags = [
      "gke-${var.project_id}",
      "gke-node"
    ]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
