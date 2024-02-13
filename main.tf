terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
  zone        = var.zone
}
