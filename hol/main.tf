provider "nsxt" {
  host                  = var.nsx_manager
  username              = var.nsx_username
  password              = var.nsx_password
  allow_unverified_ssl  = true
  max_retries           = 10
  retry_min_delay       = 500
  retry_max_delay       = 5000
  retry_on_status_codes = [429]
}

data "nsxt_logical_tier0_router" "t0" {
  display_name = "Tier-0-gateway-01"
}

data "nsxt_edge_cluster" "edge_cluster" {
    display_name = "edge-cluster-02"
}

data "nsxt_transport_zone" "tz" {
    display_name = "TZ-Overlay"
}

module "t1" {
    source = "../modules/t1"

    t0_id = data.nsxt_logical_tier0_router.t0.id
    edge_cluster_id = data.nsxt_edge_cluster.edge_cluster.id
    tz_id = data.nsxt_transport_zone.tz.id
    spec = var.t1_spec
}
