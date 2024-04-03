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
variable "vm_tag" {
  type = list(string)
}

variable "allow_firewall_rule_priority" {
  type = number
}
variable "sql_instance_name" {
  type    = string
  default = "main-instance"
}

variable "database_version" {
  type    = string
  default = "MYSQL_5_7"
}

variable "database_instance_tier" {
  type    = string
  default = "db-f1-micro"
}

variable "database_instance_availability_type" {
  type    = string
  default = "REGIONAL"
}

variable "database_instance_disk_size" {
  type    = number
  default = 40
}

variable "database_instance_disk_type" {
  type    = string
  default = "pd-ssd"
}

variable "database_instance_IPV4_enabled" {
  type    = bool
  default = false
}

variable "database_instance_deletion_protection" {
  type    = bool
  default = false
}
variable "backup_configuration_enabled" {
  type    = bool
  default = true
}
variable "private_vpc_connection_service" {
  type    = string
  default = "servicenetworking.googleapis.com"
}

variable "backup_configuration_binary_log_enabled" {
  type    = bool
  default = true
}

variable "google_sql_database_webapp_name" {
  type    = string
  default = "webapp"
}

variable "google_sql_user_webapp_name" {
  type    = string
  default = "webapp"
}

variable "password_restriction_length" {
  type    = number
  default = 16
}

variable "password_restriction_special_characters_allowed" {
  type    = bool
  default = true
}

variable "password_restriction_override_special" {
  type    = string
  default = "!#%*()-_+[]{}<>:?"
}

variable "private_ip_block_name" {
  type    = string
  default = "private-ip-block"
}

variable "private_ip_block_purpose" {
  type    = string
  default = "VPC_PEERING"
}

variable "private_ip_block_address_type" {
  type    = string
  default = "INTERNAL"
}
variable "private_ip_block_ip_version" {
  type    = string
  default = "IPV4"
}

variable "private_ip_block_prefix_length" {
  type    = number
  default = 20
}
variable "properties_location" {
  type    = string
  default = "/home/csye6225/"
}

variable "subnet_webapp_private_ip_google_access" {
  type    = bool
  default = true
}

variable "serviceAccountId" {
  type    = string
  default = "dev-444"
}

variable "ServiceAccountName" {
  type    = string
  default = "customserviceaccountname"
}

variable "projectId" {
  type    = string
  default = "csye6225-414819"
}

variable "mailgun_domain_name" {
  type    = string
  default = "srivijaykalki.me"
}

variable "mailgun_api_key" {
  type = string
}

variable "serverless_vpc_connector_name" {
  type    = string
  default = "serverless-vpc-connector"
}

variable "serverless_vpc_connector_ip_cidr_range" {
  type    = string
  default = "10.8.0.0/28"
}

variable "env_dns_zone_name" {
  type    = string
  default = "srivijaykalki"
}

variable "email_verification_topic_name" {
  type    = string
  default = "verify_email"
}

variable "email_verification_topic_ttl" {
  type    = string
  default = "604800s"
}

variable "google_storage_bucket_name" {
  type    = string
  default = "bucket_code_vijaycl"
}

variable "google_storage_bucket_object_name" {
  type    = string
  default = "serverlessCode"
}
variable "google_storage_bucket_object_source_path" {
  type    = string
  default = "function-source.zip"
}

variable "email_verification_function" {
  type    = string
  default = "emailVerification"
}

variable "email_verification_function_run_time" {
  type    = string
  default = "java17"
}

variable "email_verification_function_entry_point" {
  type    = string
  default = "gcfv2pubsub.PubSubFunction"
}

variable "email_verification_function_available_memory" {
  type    = number
  default = 256
}

variable "domain_name" {
  type    = string
  default = "srivijaykalki.me"
}

variable "server_port" {
  type    = number
  default = 8080
}
variable "cloudfunction_ingress_settings" {
  description = "Cloud Function Ingress settings"
  type        = string
}

variable "cloudfunction_all_traffic_on_latest_revision" {
  description = "Cloud Function All traffic"
  type        = bool
}

variable "eventtrigger_retry_policy" {
  description = "Event trigger retry policy"
  type        = string
}

variable "max_instance_count" {
  description = "Max instance count"
  type        = number
}
variable "min_instance_count" {
  description = "Min instance count"
  type        = number
}
variable "available_memory" {
  description = "Cloud Function Available memory"
  type        = string
}
variable "timeout_seconds" {
  description = "Cloud Function timeout_seconds"
  type        = number
}
variable "vpc_connector_egress_settings" {
  description = "VPC connector egress settings"
  type        = string
}
variable "cloudfunction_account_id" {
  description = "The account id of Cloud Function"
  type        = string
}
variable "cloudfunction_display_name" {
  description = "The display Name of Cloud Function"
  type        = string
}
variable "pubsub_subscription_name" {
  description = "Pub/Sub Subscription Name"
  type        = string
}
variable "ack_deadline_seconds" {
  description = "Ack Deadline Seconds"
  type        = number
}
variable "ttl" {
  description = "Pub/Sub TTL"
  type        = string
}

variable "template_name" {
  type    = string
  default = "appserver-template"
}

variable "instance_grp_name" {
  type    = string
  default = "my-instance-group-manager"
}
variable "check_interval_sec" {
  type = number
}
variable "health_check_timeout_seconds" {
  type = number
}
variable "healthy_threshold" {
  type = number
}
variable "unhealthy_threshold" {
  type = number
}
variable "health_check_port" {
  type = number
}
variable "backendtimeout_sec" {
  type = number
}

variable "connection_draining_timeout_sec" {
  type = number
}