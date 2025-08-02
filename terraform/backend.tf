terraform {
  backend "gcs" {
    bucket = "aetherball-tfstate-prod"
  }
}
