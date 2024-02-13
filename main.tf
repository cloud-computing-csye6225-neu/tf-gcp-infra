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

resource "google_compute_network" "vpc_network" {
  name                            = var.vpc_name
  auto_create_subnetworks         = var.vpc_auto_create_subnetworks_false
  routing_mode                    = var.vpc_routing_mode_regional
  delete_default_routes_on_create = var.vpc_delete_default_routes_on_create_true
}

resource "google_compute_subnetwork" "webapp" {
  name          = var.public_subnet_name
  ip_cidr_range = var.webapp_subnet_cidr
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_subnetwork" "db" {
  name          = var.private_subnet_name
  ip_cidr_range = var.db_subnet_cidr
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_route" "webapp" {
  name             = var.route_name
  dest_range       = var.webbapp_internet_gateway_route_dest
  network          = google_compute_network.vpc_network.name
  next_hop_gateway = var.webbapp_internet_gateway_route_next_hop_gateway
}
