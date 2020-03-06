resource "nsxt_logical_tier1_router" "t1" {
  description                 = "RTR1 provisioned by Terraform"
  display_name                = var.spec.t1_display_name
  failover_mode               = "PREEMPTIVE"
  edge_cluster_id             = var.edge_cluster_id
  enable_router_advertisement = true
  advertise_connected_routes  = true
  advertise_static_routes     = true
  advertise_nat_routes        = true

  tag {
    scope = var.spec.provisioned_by_scope
    tag   = var.spec.provisioned_by
  }
}

resource "nsxt_logical_switch" "ls" {
  admin_state       = "UP"
  description       = "LS1 provisioned by Terraform"
  display_name      = var.spec.ls_display_name
  transport_zone_id = var.tz_id
  replication_mode  = "MTEP"

  tag {
    scope = var.spec.provisioned_by_scope
    tag = var.spec.provisioned_by
  }
}

resource "nsxt_logical_port" "ls_port" {
    admin_state = "UP"
    logical_switch_id = nsxt_logical_switch.ls.id

  tag {
    scope = var.spec.provisioned_by_scope
    tag   = var.spec.provisioned_by
  }
}

resource "nsxt_logical_router_link_port_on_tier0" "link_port_tier0" {
  description       = "TIER0_PORT1 provisioned by Terraform"
  logical_router_id = var.t0_id

  tag {
    scope = var.spec.provisioned_by_scope
    tag   = var.spec.provisioned_by
  }
}

resource "nsxt_logical_router_link_port_on_tier1" "link_port_tier1" {
  description                   = "TIER1_PORT1 provisioned by Terraform"
  logical_router_id             = nsxt_logical_tier1_router.t1.id
  linked_logical_router_port_id = nsxt_logical_router_link_port_on_tier0.link_port_tier0.id

  tag {
    scope = var.spec.provisioned_by_scope
    tag   = var.spec.provisioned_by
  }
}

resource "nsxt_logical_router_downlink_port" "downlink_port" {
  description                   = "TIER1_PORT1 provisioned by Terraform"
  logical_router_id             = nsxt_logical_tier1_router.t1.id
  linked_logical_switch_port_id = nsxt_logical_port.ls_port.id
  ip_address = var.spec.t1_downlink_ip_address

  tag {
    scope = var.spec.provisioned_by_scope
    tag   = var.spec.provisioned_by
  }
}
