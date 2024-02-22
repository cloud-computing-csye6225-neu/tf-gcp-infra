resource "google_compute_network" "vpc_network" {
  # count                           = var.num_vpcs
  name                            = "${var.vpc_name}-${uuid()}"
  auto_create_subnetworks         = var.vpc_auto_create_subnetworks_false
  routing_mode                    = var.vpc_routing_mode_regional
  delete_default_routes_on_create = var.vpc_delete_default_routes_on_create_true
}

resource "google_compute_subnetwork" "webapp" {
  # count         = var.num_vpcs
  name          = var.public_subnet_name 
  ip_cidr_range = webapp_cidr_range
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_subnetwork" "db" {
  # count         = var.num_vpcs
  name          = var.private_subnet_name
  ip_cidr_range = db_cidr_range
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_route" "internet_gateway_route" {
  # count            = var.num_vpcs
  name             = "${var.route_name}-${uuid()}"
  dest_range       = var.webapp_internet_gateway_route_dest
  network          = google_compute_network.vpc_network.name
  next_hop_gateway = var.webapp_internet_gateway_route_next_hop_gateway
}
