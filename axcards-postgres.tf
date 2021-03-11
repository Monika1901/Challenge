
resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta

  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.network.network_self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = module.network.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

module "postgresql-db" {
  depends_on           = [google_service_networking_connection.private_vpc_connection]
  source               = "./modules/gcp/terraform-postgresql"
  name                 = var.pg_ha_name
  random_instance_name = true
  database_version     = var.postgres-settings["database_version"]
  create_timeout       = var.postgres-settings["create_timeout"]
  update_timeout       = var.postgres-settings["update_timeout"]
  delete_timeout       = var.postgres-settings["delete_timeout"]


  project_id = var.project
  zone       = var.database_zone
  region     = var.region
  tier       = var.postgres-settings["tier"]

  user_name     = var.db_user
  user_password = var.db_password

  //In case you need to create a db uncomment below.
  db_name = var.db_name
  database_flags = [{
    name  = "max_connections"
    value = "500"
  }]
  ip_configuration = {
    ipv4_enabled    = false
    private_network = module.network.network_self_link
    require_ssl     = var.require_ssl
    authorized_networks = [
      {
        name  = "cloudsql"
        value = "0.0.0.0/0"
      },
    ]
  }
  availability_type = var.postgres-settings["availability_type"]
  //read_replica_name_suffix = var.postgres-settings["read_replica_name_suffix"]
  read_replicas = [
    {
      name            = var.pg_ha_name
      tier            = var.postgres-settings["tier"]
      zone            = "us-central1-b"
      disk_type       = var.postgres-settings["disk_type"]
      disk_autoresize = true
      disk_size       = 10
      user_labels     = {}
      database_flags = [{
        name  = "max_connections"
        value = "500"
      }]
      ip_configuration = {
        ipv4_enabled    = false
        private_network = module.network.network_self_link
        require_ssl     = var.require_ssl
        authorized_networks = [
          {
            name  = "cloudsql"
            value = "0.0.0.0/0"
          },
        ]
      }

    }

  ]

}



