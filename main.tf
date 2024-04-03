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
  name                     = var.public_subnet_name
  ip_cidr_range            = var.webapp_cidr_range
  region                   = var.region
  network                  = google_compute_network.vpc_network.name
  private_ip_google_access = var.subnet_webapp_private_ip_google_access
}

resource "google_compute_subnetwork" "db" {
  # count         = var.num_vpcs
  # name          = count.index == 0 ? var.private_subnet_name : "${var.private_subnet_name}-${uuid()}"
  name          = var.private_subnet_name
  ip_cidr_range = var.db_cidr_range
  region        = var.region
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

# resource "google_compute_firewall" "allow_rule" {
#   name        = var.allow_firewall_name
#   network     = google_compute_network.vpc_network.name
#   source_tags = var.vm_tag
#   target_tags = var.vm_tag
#   allow {
#     protocol = var.allow_protocol
#     ports    = var.allowed_port_list
#   }

#   source_ranges = var.firewall_src_range
#   priority      = var.allow_firewall_rule_priority
# }

# resource "google_compute_firewall" "deny_rule" {
#   name    = var.deny_firewall_name
#   network = google_compute_network.vpc_network.name

#   deny {
#     protocol = var.deny_protocol
#   }

#   source_ranges = var.firewall_src_range
# }

data "template_file" "startup_script" {
  template = file("scripts/startup.sh")
  vars = {
    DB_INTERNAL_IP_ADDRESS = "${google_sql_database_instance.main_primary.private_ip_address}",
    DB_USERNAME            = var.google_sql_user_webapp_name,
    DB_PASSWORD            = "${random_password.password.result}",
    DB_NAME                = var.google_sql_database_webapp_name,
    location               = var.properties_location,
    PROJECT_ID             = var.projectId,
    TOPIC_ID               = google_pubsub_topic.verify_email.name
    DOMAIN_NAME            = var.domain_name
    SERVER_PORT            = var.server_port
  }
}
# resource "google_compute_instance" "custom_vm_instance" {
#   name         = var.vm_instance_name
#   zone         = var.vm_instance_zone
#   machine_type = var.vm_instance_machine_type
#   tags         = var.vm_tag
#   depends_on   = [google_service_account.vm_service_account, google_sql_database_instance.main_primary]
#   boot_disk {
#     initialize_params {
#       image = var.vm_instance_image
#       type  = var.vm_instance_disk_type
#       size  = var.vm_instance_disk_size_gb
#     }
#   }

#   network_interface {
#     network    = google_compute_network.vpc_network.name
#     subnetwork = google_compute_subnetwork.webapp.self_link

#     access_config {
#       // Assigns a public IP address
#     }
#   }
#   metadata_startup_script = data.template_file.startup_script.rendered
#   service_account {
#     email  = google_service_account.vm_service_account.email
#     scopes = ["cloud-platform"]
#   }
# }

resource "google_service_account" "vm_service_account" {
  account_id                   = "vm-instance-service-account"
  display_name                 = "VM Service Account"
  create_ignore_already_exists = true
}

resource "google_project_iam_binding" "logging_roles_binding" {
  project = var.projectId

  role = "roles/logging.admin"

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}",
  ]
  depends_on = [google_service_account.vm_service_account]
}

resource "google_project_iam_binding" "metric_roles_binding" {
  project = var.projectId

  role = "roles/monitoring.metricWriter"

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}",
  ]

  depends_on = [google_service_account.vm_service_account]
}
# Create a private address range for our network
resource "google_compute_global_address" "private_ip_block" {
  name          = var.private_ip_block_name
  purpose       = var.private_ip_block_purpose
  address_type  = var.private_ip_block_address_type
  ip_version    = var.private_ip_block_ip_version
  prefix_length = var.private_ip_block_prefix_length
  network       = google_compute_network.vpc_network.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc_network.self_link
  service                 = var.private_vpc_connection_service
  reserved_peering_ranges = [google_compute_global_address.private_ip_block.name]
}

resource "google_vpc_access_connector" "serverless_vpc_connector" {
  name          = var.serverless_vpc_connector_name
  network       = google_compute_network.vpc_network.self_link
  region        = var.region
  ip_cidr_range = var.serverless_vpc_connector_ip_cidr_range
}

resource "google_sql_database" "webapp" {
  name     = var.google_sql_database_webapp_name
  instance = google_sql_database_instance.main_primary.name
}
resource "google_sql_database_instance" "main_primary" {
  name             = var.sql_instance_name
  database_version = var.database_version
  region           = var.region
  depends_on       = [google_service_networking_connection.private_vpc_connection]
  settings {
    tier              = var.database_instance_tier
    availability_type = var.database_instance_availability_type
    disk_size         = var.database_instance_disk_size
    disk_type         = var.database_instance_disk_type
    ip_configuration {
      ipv4_enabled    = var.database_instance_IPV4_enabled
      private_network = google_compute_network.vpc_network.self_link
    }
    backup_configuration {
      enabled            = var.backup_configuration_enabled
      binary_log_enabled = var.backup_configuration_binary_log_enabled
    }
  }
  deletion_protection = var.database_instance_deletion_protection
}

resource "random_password" "password" {
  length           = var.password_restriction_length
  special          = var.password_restriction_special_characters_allowed
  override_special = var.password_restriction_override_special
}

resource "google_sql_user" "db_user" {
  name     = var.google_sql_user_webapp_name
  instance = google_sql_database_instance.main_primary.name
  password = random_password.password.result
}

data "google_dns_managed_zone" "env_dns_zone" {
  name = var.env_dns_zone_name

}

resource "google_dns_record_set" "a_dns_record" {
  name         = data.google_dns_managed_zone.env_dns_zone.dns_name
  managed_zone = data.google_dns_managed_zone.env_dns_zone.name
  type         = "A"
  ttl          = 60
  rrdatas      = [google_compute_global_address.load_balancer_address.address]
  depends_on   = [google_compute_global_forwarding_rule.https_forwarding_rule]
}
# A pub-sub topic for sending email verification
resource "google_pubsub_topic" "verify_email" {
  name                       = var.email_verification_topic_name
  message_retention_duration = var.email_verification_topic_ttl
}

resource "google_storage_bucket" "function_code_bucket" {
  name     = var.google_storage_bucket_name
  location = var.region
}

resource "google_storage_bucket_object" "function_code_objects" {
  name   = var.google_storage_bucket_object_name
  bucket = google_storage_bucket.function_code_bucket.name
  source = var.google_storage_bucket_object_source_path
}

resource "google_service_account" "function_service_account" {
  account_id   = var.cloudfunction_account_id
  display_name = var.cloudfunction_display_name
}
resource "google_project_iam_binding" "function_service_account_roles" {
  project = var.projectId
  role    = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:${google_service_account.function_service_account.email}"
  ]
}

resource "google_project_iam_binding" "invoker_binding" {
  members = ["serviceAccount:${google_service_account.function_service_account.email}"]
  project = var.projectId
  role    = "roles/run.invoker"
}

resource "google_cloudfunctions2_function" "email_verification_function" {
  name     = var.email_verification_function
  location = var.region

  build_config {
    runtime     = var.email_verification_function_run_time
    entry_point = var.email_verification_function_entry_point

    source {
      storage_source {
        bucket = google_storage_bucket.function_code_bucket.name
        object = google_storage_bucket_object.function_code_objects.name
      }
    }
  }

  service_config {
    max_instance_count            = var.max_instance_count
    min_instance_count            = var.min_instance_count
    available_memory              = var.available_memory
    timeout_seconds               = var.timeout_seconds
    vpc_connector                 = google_vpc_access_connector.serverless_vpc_connector.name
    vpc_connector_egress_settings = var.vpc_connector_egress_settings

    environment_variables = {
      SQL_HOST             = google_sql_database_instance.main_primary.private_ip_address
      SQL_USERNAME         = google_sql_user.db_user.name
      SQL_PASSWORD         = random_password.password.result
      SQL_DATABASE         = google_sql_database.webapp.name
      MAIL_GUN_DOMAIN_NAME = var.mailgun_domain_name
      MAIL_GUN_API_KEY     = var.mailgun_api_key
    }

    ingress_settings               = var.cloudfunction_ingress_settings
    all_traffic_on_latest_revision = var.cloudfunction_all_traffic_on_latest_revision
    service_account_email          = google_service_account.function_service_account.email


  }
  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.verify_email.id
    retry_policy   = var.eventtrigger_retry_policy
  }
}

resource "google_project_iam_binding" "pubsub_publisher" {
  project = var.projectId
  role    = "roles/pubsub.publisher"

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}"
  ]
}

resource "google_project_iam_binding" "pubsub_service_account_roles" {
  project = var.projectId
  role    = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}"
  ]
}
resource "google_pubsub_subscription" "pub_sub_subscription" {
  name                 = var.pubsub_subscription_name
  topic                = google_pubsub_topic.verify_email.name
  ack_deadline_seconds = var.ack_deadline_seconds
  expiration_policy {
    ttl = var.ttl
  }
}
resource "google_compute_region_instance_template" "appserver_template" {
  name         = var.template_name
  machine_type = var.vm_instance_machine_type


  disk {
    source_image = var.vm_instance_image
    auto_delete  = true
    boot         = true
    disk_type    = var.vm_instance_disk_type
    disk_size_gb = var.vm_instance_disk_size_gb

  }

  metadata_startup_script = data.template_file.startup_script.rendered

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.webapp.self_link

    access_config {
      // Assigns a public IP address
    }
  }

  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = ["cloud-platform"]
  }
  tags = ["load-balanced-backend"]

  depends_on = [google_service_account.vm_service_account, google_sql_database_instance.main_primary]
}

resource "google_compute_region_instance_group_manager" "webapp_instance_grp" {
  name = var.instance_grp_name
  named_port {
    name = "http"
    port = 8080
  }
  version {
    name              = "primary"
    instance_template = google_compute_region_instance_template.appserver_template.id
  }

  base_instance_name = "my-custom-vm"
  target_size        = 2

  auto_healing_policies {
    health_check      = google_compute_http_health_check.webapp_http_health_check.id
    initial_delay_sec = 300
  }
}

resource "google_compute_region_autoscaler" "wepapp_auto_scaler" {
  name   = "my-auto-scaler"
  region = var.region
  target = google_compute_region_instance_group_manager.webapp_instance_grp.id

  autoscaling_policy {
    max_replicas    = 6
    min_replicas    = 3
    cooldown_period = 60

    cpu_utilization {
      target = 0.05 # 5% CPU utilization
    }
  }

  depends_on = [google_compute_region_instance_group_manager.webapp_instance_grp]
}

resource "google_compute_global_address" "load_balancer_address" {

  name = "load-balancer-ipv4-address"
}


resource "google_compute_http_health_check" "webapp_http_health_check" {
  name                = "http-health-check"
  check_interval_sec  = var.check_interval_sec
  timeout_sec         = var.health_check_timeout_seconds
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold
  port                = var.health_check_port
  request_path        = "/healthz"
}

resource "google_compute_backend_service" "loadbalancer_backend_service" {
  name                            = "load-balancer-backend-service"
  protocol                        = "HTTP"
  port_name                       = "http"
  health_checks                   = [google_compute_http_health_check.webapp_http_health_check.id]
  load_balancing_scheme           = "EXTERNAL"
  timeout_sec                     = var.backendtimeout_sec
  enable_cdn                      = true
  connection_draining_timeout_sec = var.connection_draining_timeout_sec
  backend {
    group           = google_compute_region_instance_group_manager.webapp_instance_grp.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_url_map" "compute_url_map" {
  name            = "my-url-map"
  provider        = google
  default_service = google_compute_backend_service.loadbalancer_backend_service.id
}

resource "google_compute_managed_ssl_certificate" "webapp_ssl_cert" {
  name = "webapp-ssl-cert"

  managed {
    domains = ["srivijaykalki.me"]
  }
}


resource "google_compute_target_https_proxy" "my_target_http_proxy" {
  name     = "load-balancer-proxy"
  provider = google
  url_map  = google_compute_url_map.compute_url_map.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.webapp_ssl_cert.name
  ]
  depends_on = [
    google_compute_managed_ssl_certificate.webapp_ssl_cert
  ]
}

resource "google_compute_global_forwarding_rule" "https_forwarding_rule" {
  name                  = "https-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.load_balancer_address.address
  port_range            = "443"
  target                = google_compute_target_https_proxy.my_target_http_proxy.id

  depends_on = [google_compute_target_https_proxy.my_target_http_proxy,
  google_compute_global_address.load_balancer_address, google_compute_network.vpc_network]

}

resource "google_project_iam_binding" "instance_admin_binding" {
  project = var.projectId
  role    = "roles/compute.instanceAdmin.v1"

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}",
  ]
}
resource "google_compute_firewall" "allow_rule" {
  name        = var.allow_firewall_name
  network     = google_compute_network.vpc_network.self_link
  source_tags = var.vm_tag

  allow {
    protocol = var.allow_protocol
    ports    = var.allowed_port_list
  }

  source_ranges = var.firewall_src_range
  priority      = var.allow_firewall_rule_priority
  target_tags   = ["load-balanced-backend"]
}

resource "google_compute_firewall" "allow_rule_health_check" {
  name = "fw-allow-health-check"
  allow {
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.self_link
  priority      = var.allow_firewall_rule_priority
  source_ranges = var.firewall_src_range
  target_tags   = ["load-balanced-backend"]
}


resource "google_compute_firewall" "deny_rule" {
  name    = var.deny_firewall_name
  network = google_compute_network.vpc_network.self_link

  deny {
    protocol = var.deny_protocol
  }

  source_ranges = var.firewall_src_range
}