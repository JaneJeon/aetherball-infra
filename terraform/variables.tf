variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "GCP zone for the cluster"
  default     = "us-central1-a"
}

variable "tailscale_client_id" {
  type        = string
  description = "Tailscale OAuth client ID"
  sensitive   = true
}

variable "tailscale_client_secret" {
  type        = string
  description = "Tailscale OAuth client secret"
  sensitive   = true
}
