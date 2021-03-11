provider "google" {
  version = "~> 3.41"

  // Uncomment the below to run locally
  credentials = file("./creds/fin-authaxcards-cug01-dev-6a431b0e5969.json")
  project     = var.project
  region      = var.region
}

provider "google-beta" {

  // Uncomment the below to run locally
  credentials = file("./creds/fin-authaxcards-cug01-dev-6a431b0e5969.json")
  version     = "~> 3.41"
  project     = var.project
  region      = var.region
}

module "vpc_auto_subnets" {

  source = "git::https://github.com/ncr-swt-sre/sreg-gcp-modules.git"
  //git@github.com:ncr-swt-sre/sreg-gcp-modules.git//modules/gke-cluster/?ref=x.y.x
  // base network parameters
  network_name = var.network_name
  project_name = var.project
  //subnets = var.cluster["subnetwork_range"]
  auto_create_subnetworks = false

}


