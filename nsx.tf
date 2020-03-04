# update on Mac, 2020.3.3

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

data "nsxt_logical_tier0_router" "tier0" {
  display_name = "Tier-0-gateway-01"
}

data "nsxt_edge_cluster" "edge_cluster" {
    display_name = "edge-cluster-02"
}

data "nsxt_transport_zone" "tz" {
    display_name = "TZ-Overlay"
}

resource "nsxt_logical_tier1_router" "tier1" {
  description                 = "RTR1 provisioned by Terraform"
  display_name                = "tf-t1-01"
  failover_mode               = "PREEMPTIVE"
  edge_cluster_id             = data.nsxt_edge_cluster.edge_cluster.id
  enable_router_advertisement = true
  advertise_connected_routes  = true
  advertise_static_routes     = true
  advertise_nat_routes        = true

  tag {
    scope = "provisioned_by"
    tag   = "terraform"
  }
}

resource "nsxt_logical_switch" "ls" {
  admin_state       = "UP"
  description       = "LS1 provisioned by Terraform"
  display_name      = "tf-ls-01"
  transport_zone_id = data.nsxt_transport_zone.tz.id
  replication_mode  = "MTEP"

  tag {
    scope = "provisioned_by"
    tag   = "terraform"
  }
}

resource "nsxt_logical_port" "ls_port" {
    admin_state = "UP"
    logical_switch_id = nsxt_logical_switch.ls.id

  tag {
    scope = "provisioned_by"
    tag   = "terraform"
  }
}

resource "nsxt_logical_router_link_port_on_tier0" "link_port_tier0" {
  description       = "TIER0_PORT1 provisioned by Terraform"
  logical_router_id = data.nsxt_logical_tier0_router.tier0.id

  tag {
    scope = "provisioned_by"
    tag   = "terraform"
  }
}

resource "nsxt_logical_router_link_port_on_tier1" "link_port_tier1" {
  description                   = "TIER1_PORT1 provisioned by Terraform"
  logical_router_id             = nsxt_logical_tier1_router.tier1.id
  linked_logical_router_port_id = nsxt_logical_router_link_port_on_tier0.link_port_tier0.id

  tag {
    scope = "provisioned_by"
    tag   = "terraform"
  }
}

resource "nsxt_logical_router_downlink_port" "downlink_port" {
  description                   = "TIER1_PORT1 provisioned by Terraform"
  logical_router_id             = nsxt_logical_tier1_router.tier1.id
  linked_logical_switch_port_id = nsxt_logical_port.ls_port.id
  ip_address = "192.168.205.1/24"

  tag {
    scope = "provisioned_by"
    tag   = "terraform"
  }
}
