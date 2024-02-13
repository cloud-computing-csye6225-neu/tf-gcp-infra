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

variable "webapp_subnet_cidr" {
  description = "CIDR range for the webapp subnet"
  default     = "10.0.2.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR range for the db subnet"
  default     = "10.0.1.0/24"
}

variable "route_name" {
  description = "Name of the route for the webapp subnet"
  default     = "webapp-internet-gateway-route"
}
