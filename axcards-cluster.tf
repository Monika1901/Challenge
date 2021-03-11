// Kuberentes cluster details 
module "cluster" {
  source                           = "./modules/gcp/terraform-gke/vpc-native"
  region                           = var.region
  name                             = var.cluster["name"]
  project                          = var.project
  network_name                     = var.network_name
  nodes_subnetwork_name            = module.network.subnetwork
  kubernetes_version               = var.cluster["version"]
  pods_secondary_ip_range_name     = module.network.gke_pods_1
  services_secondary_ip_range_name = module.network.gke_services_1
  // to make  sure that nodes can't have public IP.
  enable_private_nodes = var.cluster["enable_private_nodes"]
  master_ipv4_cidr_block = var.cluster["subnetwork_node_range"]
  // This is publically accessible for now
  enable_private_endpoint = var.cluster["enable_private_endpoint"]
 // master_authorized_network_cidrs = [
  //  {
  //    cidr_block = var.cluster["subnetwork_node_range"]
  //    display_name = "node_range"
  //  },
  //  {
  //    cidr_block = var.cluster["subnetwork_range"]
  //    display_name = "subnet_range"
  //  }
    
  //]
}
// Node pool
module "node_pool" {
  source             = "./modules/gcp/terraform-gke/node_pool"
  name               = var.cluster-node-pool["name"]
  region             = module.cluster.region
  gke_cluster_name   = module.cluster.name
  machine_type       = var.cluster-node-pool["machine_type"]
  min_node_count     = var.cluster-node-pool["min_node_count"]
  max_node_count     = var.cluster-node-pool["max_node_count"]  
  kubernetes_version = module.cluster.kubernetes_version
  auto_repair        = var.cluster-node-pool["auto_repair"]
  auto_upgrade       = var.cluster-node-pool["auto_upgrade"]
  disk_size_in_gb    = var.cluster-node-pool["disk_size_in_gb"]
  disk_type          = var.cluster-node-pool["disk_type"]
  preemptible_nodes  = var.cluster-node-pool["use-preempliable-node-pools"]
}

