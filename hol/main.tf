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

module "t1" {
    source = "modules/t1"
    
    spec.provisioned_by_scope = "provisioned_by"
    spec.provisioned_by = "terraform-yanjun"
    spec.t1_display_name = "tf-t1-01"
    spec.ls_display_name = "tf-ls-01"
    spec.t1_downlink_ip_address = "192.168.206.1/24"
}
