variable "credentials_file" {
  description = "Path to the Google Cloud credentials file"
}

variable "project" {
  description = "Google Cloud project ID"
}

variable "region" {
  description = "Google Cloud region"
  default     = "us-central1"
}

variable "zone" {
  description = "Google Cloud zone"
  default     = "us-central1-c"
}

variable "vpc_name" {
  description = "Name of the VPC network"
  default     = "terraform-network"
}
variable "vpc_auto_create_subnetworks_false" {
  description = "assigns false value to the auto_create_subnetworks for vpc"
  default     = false
}

variable "vpc_routing_mode_regional" {
  description = "assigns regional to the vpc_routing_mode"
  default     = "REGIONAL"
}

variable "vpc_delete_default_routes_on_create_true" {
  description = "assigns true value to the vpc_delete_default_routes"
  default     = true
}
variable "public_subnet_name" {
  description = "name of the subnet of the web app"
  default     = "webapp"
}

variable "webapp_subnet_cidr" {
  description = "CIDR range for the webapp subnet"
  default     = "10.0.2.0/24"
}
variable "private_subnet_name" {
  description = "name of the subnet of the db"
  default     = "db"
}
variable "db_subnet_cidr" {
  description = "CIDR range for the db subnet"
  default     = "10.0.1.0/24"
}

variable "route_name" {
  description = "Name of the route for the webapp subnet"
  default     = "webapp-internet-gateway-route"
}




variable "webbapp_internet_gateway_route_dest" {
  description = "destination for the route webapp-internet-gateway-route"
  default     = "0.0.0.0/0"

}
variable "webbapp_internet_gateway_route_next_hop_gateway" {
  description = "next hop gateway for the route webapp-internet-gateway-route"
  default     = "default-internet-gateway"

}