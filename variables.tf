variable "nsx_manager" {}
variable "nsx_username" {}
variable "nsx_password" {}

locals {
    provisioned_by_scope = "provisioned_by"
    provisioned_by = "terraform-yanjun"
}
