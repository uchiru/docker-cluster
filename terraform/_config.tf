variable "ACCOUNT_ID"             { }
variable "PROJ_ID"                { }
variable "USER"                   { }
variable "PASSWORD"               { }
variable "KEY_PAIR"               { }
variable "SUBNET_CIDR"            { default = "192.168.99.0/24" }

variable "network01_id"           { }
variable "main01_public_ip"       { }
variable "ubuntu_1604_v1"         { }

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
  name                = "nat-router"
  admin_state_up      = "true"
  region              = "ru-1"
  external_network_id = "ab2264dd-bde8-4a97-b0da-5fea63191019"
}

resource "openstack_networking_router_interface_v2" "terraform" {
  router_id = "${openstack_networking_router_v2.terraform.id}"
  subnet_id = "${openstack_networking_subnet_v2.terraform.id}"
  region    = "ru-1"
}
