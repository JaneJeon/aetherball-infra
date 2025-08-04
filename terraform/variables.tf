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

variable "github_repo" {
  type        = string
  description = "GitHub repository in format owner/repo"
}
