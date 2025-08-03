# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#example-usage---subnetwork-ipv6
resource "google_compute_network" "vpc" {
  name = "${var.project_id}-network"

  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name    = "${var.project_id}-subnetwork"
  region  = var.region
  network = google_compute_network.vpc.name

  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"
}
