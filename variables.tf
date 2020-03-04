variable "nsx_manager" {}
variable "nsx_username" {}
variable "nsx_password" {}


locals {
    provisioned_by_scope = "provisioned_by"
    provisioned_by = "terraform-yanjun"
    t1_display_name = "tf-t1-01"
    ls_display_name = "tf-ls-01"
    t1_downlink_ip_address = "192.168.206.1/24"
}
