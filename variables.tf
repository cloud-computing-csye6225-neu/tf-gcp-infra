variable "credentials_file" {
  description = "Path to the Google Cloud credentials file"
  type        = string
}

variable "project" {
  description = "Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Google Cloud zone"
  type        = string
  default     = "us-central1-c"
}

variable "num_vpcs" {
  description = "The number of VPCs need to be created"
  type        = number
  default     = 1
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "terraform-network"
}

variable "vpc_auto_create_subnetworks_false" {
  description = "Assigns false value to the auto_create_subnetworks for VPC"
  type        = bool
  default     = false
}

variable "vpc_routing_mode_regional" {
  description = "Assigns regional to the VPC routing_mode"
  type        = string
  default     = "REGIONAL"
}

variable "vpc_delete_default_routes_on_create_true" {
  description = "Assigns true value to the VPC delete_default_routes"
  type        = bool
  default     = true
}

variable "vpc_cidr_range" {
  description = "CIDR range for the network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "webapp_cidr_range" {
  description = "CIDR range for the network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_cidr_range" {
  description = "CIDR range for the network"
  type        = string
  default     = "10.0.0.0/16"
}


variable "public_subnet_name" {
  description = "Name of the subnet of the web app"
  type        = string
  default     = "webapp"
}

variable "private_subnet_name" {
  description = "Name of the subnet of the DB"
  type        = string
  default     = "db"
}

variable "route_name" {
  description = "Name of the route for the webapp subnet"
  type        = string
  default     = "internet-gateway-route"
}

variable "webapp_internet_gateway_route_dest" {
  description = "Destination for the route webapp-internet-gateway-route"
  type        = string
  default     = "0.0.0.0/0"
}

variable "webapp_internet_gateway_route_next_hop_gateway" {
  description = "Next hop gateway for the route webapp-internet-gateway-route"
  type        = string
  default     = "default-internet-gateway"
}

variable "internet_gateway_route_priority" {
  type = number
}

variable "allow_firewall_name" {
  type = string
}

variable "allowed_port_list" {
  type = list(number)
}

variable "allow_protocol" {
  type = string
}

variable "firewall_src_range" {
  type = list(string)
}

variable "deny_firewall_name" {
  type = string
}
variable "deny_protocol" {
  type = string
}
variable "deny_ports" {
  type = list(number)
}

variable "vm_instance_name" {
  type = string
}

variable "vm_instance_zone" {
  type = string
}

variable "vm_instance_machine_type" {
  type = string
}

variable "vm_instance_image" {
  type = string
}

variable "vm_instance_disk_type" {
  type = string
}

variable "vm_instance_disk_size_gb" {
  type = number
}