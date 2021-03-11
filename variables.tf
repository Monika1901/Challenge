variable "network_name" {
  type = string
  default = "axcards-dev-vpc"
  description = "Network Name"
}

variable "project" {
  type = string
  default = "fin-authaxcards-cug01-dev"
  description = "Project Name"
}
variable "region" {
  type = string
  default = "us-central1"
  description = "Region"
}
variable "postgres-settings" {
  type = map
  default = {
    database_version = "POSTGRES_10"
    // availability_type = Zonal or region availability_type               = "REGIONAL"
    availability_type        = "REGIONAL"
    read_replica_name_suffix = "-replica"
    // Read this to understand tiers - https://cloud.google.com/sql/docs/postgres/create-instance 
    tier                     = "db-custom-8-24576"
    read_replica_name_suffix = "-replica"
    //The type of data disk: PD_SSD (default) or PD_HDD. 
    disk_type      = "PD_HDD"
    create_timeout = "60m"
    update_timeout = "30m"
    delete_timeout = "60m"
  }
}

variable "pg_ha_name"{
  description = "The name of the SQL Database instance"
  default     = "axcards-dev-db"
}
variable "database_zone"{
  description = "The zone in which db installed"
  default     = "a"
}

variable "db_name" {
  description = "The axcards db name"
  default     = "axcards-dev-db"
}
variable "db_user" {
  description = "The axcards db user"
  default     = "axcards-dbuser"
}
variable "db_password" {
  description = "The default passowrd of axcards"
  default     = "axcards@123"
}
variable require_ssl {
  description = " Should PGSQL need SSL connection"
  // This is set to false only for poc
  default = false
}

variable "cluster" {
  type = map
  default = {
    name                  = "axcards-gke"
    version               = "1.16.15-gke.7800"
    subnetwork_name       = "axcards-kube-subnet"
    subnetwork_range      = "10.147.196.0/24"    
    subnetwork_pods       = "10.148.192.0/24"
    subnetwork_services   = "10.149.192.0/24"
    subnetwork_node_range      = "10.150.192.0/28"
    //subnetwork_management = "10.22.0.0/16"
    // to make  sure that nodes can't have public IP.
    enable_private_nodes = true
    // This should be made true
    enable_private_endpoint     = false
    use-preempliable-node-pools = true
  }
}

variable "cluster-node-pool" {
  type = map
  default = {  
    use-preempliable-node-pools = true
    name                        = "axcards-gke-node-pool"
    machine_type                = "n1-standard-8"
    disk_size_in_gb             = "256"
    disk_type                   = "pd-standard"
    min_node_count              = "2"
    max_node_count              = "2"  
    auto_repair                 = true
    auto_upgrade                = true

  }
}