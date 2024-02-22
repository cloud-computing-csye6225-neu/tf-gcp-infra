resource "google_compute_network" "vpc_network" {
  # count                           = var.num_vpcs
  name                            = "${var.vpc_name}-${uuid()}"
  auto_create_subnetworks         = var.vpc_auto_create_subnetworks_false
  routing_mode                    = var.vpc_routing_mode_regional
  delete_default_routes_on_create = var.vpc_delete_default_routes_on_create_true
}

resource "google_compute_subnetwork" "webapp" {
  # count         = var.num_vpcs
  # name          = count.index == 0 ? var.public_subnet_name : "${var.public_subnet_name}-${uuid()}"
  name          = var.public_subnet_name
  ip_cidr_range = var.webapp_cidr_range
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_subnetwork" "db" {
  # count         = var.num_vpcs
  # name          = count.index == 0 ? var.private_subnet_name : "${var.private_subnet_name}-${uuid()}"
  name          = var.private_subnet_name
  ip_cidr_range = var.db_cidr_range
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_route" "internet_gateway_route" {
  # count            = var.num_vpcs
  name             = "${var.route_name}-${uuid()}"
  depends_on       = [google_compute_subnetwork.webapp]
  dest_range       = var.webapp_internet_gateway_route_dest
  network          = google_compute_network.vpc_network.name
  next_hop_gateway = var.webapp_internet_gateway_route_next_hop_gateway
  priority         = var.internet_gateway_route_priority
}

resource "google_compute_firewall" "allow_rule" {
  name    = var.allow_firewall_name
  network = google_compute_network.vpc_network

  allow {
    protocol = var.allow_protocol
    ports    = var.allowed_port_list
  }

  source_ranges = var.firewall_src_range
}

resource "google_compute_firewall" "deny_rule" {
  name    = var.deny_firewall_name
  network = google_compute_network.vpc_network

  deny {
    protocol = var.deny_protocol
    ports    = var.deny_ports
  }

  source_ranges = var.firewall_src_range
}

resource "google_compute_instance" "custom_vm_instance" {
  name         = var.vm_instance_name
  zone         = var.vm_instance_zone
  machine_type = var.vm_instance_machine_type

  boot_disk {
    initialize_params {
      image = var.vm_instance_image
      type  = var.vm_instance_disk_type
      size  = var.vm_instance_disk_size_gb
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network
    subnetwork = google_compute_subnetwork.webapp.self_link

    access_config {
      // Assigns a public IP address
    }
  }
}