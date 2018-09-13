variable "ACCOUNT_ID"             { default = "TODO: set selectel account id, for example 84123" }
variable "PROJ_ID"                { default = "TODO: set selectel project id, for example b02fbdf3d93b43f59ff8aace029f7480" }
variable "USER"                   { default = "TODO: set selectel user" }
variable "PASSWORD"               { default = "TODO: set selectel password" }
variable "SUBNET_CIDR"            { default = "192.168.99.0/24" }

variable "network01-id"           { default = "TODO: set ID of public network" }
variable "main01-public-ip"       { default = "TODO: assign IP from public network" }

provider "openstack" {
  domain_name = "${var.ACCOUNT_ID}"
  auth_url    = "https://api.selvpc.ru/identity/v3"
  tenant_name = "${var.PROJ_ID}"
  tenant_id   = "${var.PROJ_ID}"
  user_name   = "${var.USER}"
  password    = "${var.PASSWORD}"
}

resource "openstack_networking_network_v2" "terraform" {
  name           = "nat"
  admin_state_up = "true"
  region         = "ru-1"
}

resource "openstack_networking_subnet_v2" "terraform" {
  name            = "nat"
  network_id      = "${openstack_networking_network_v2.terraform.id}"
  cidr            = "${var.SUBNET_CIDR}"
  ip_version      = 4
  region          = "ru-1"
  enable_dhcp     = false
  dns_nameservers = ["188.93.16.19", "188.93.17.19", "109.234.159.91"]
}

resource "openstack_networking_router_v2" "terraform" {
  name             = "nat-router"
  admin_state_up   = "true"
  region           = "ru-1"
  external_gateway = "ab2264dd-bde8-4a97-b0da-5fea63191019"
}

resource "openstack_networking_router_interface_v2" "terraform" {
  router_id = "${openstack_networking_router_v2.terraform.id}"
  subnet_id = "${openstack_networking_subnet_v2.terraform.id}"
  region    = "ru-1"
}
