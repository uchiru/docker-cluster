variable "node02-ip"                { default = "192.168.99.6" }

resource "openstack_blockstorage_volume_v2" "disk-for-node02" {
  name              = "disk-for-node02"
  region            = "ru-1"
  availability_zone = "ru-1b"
  size              = 30
  volume_type       = "basic.ru-1b"
  image_id          = "${var.ubuntu_1604_v1}"
}

resource "openstack_compute_instance_v2" "node02" {
  name              = "node02"
  flavor_name       = "BL1.2-8192"
  region            = "ru-1"
  availability_zone = "ru-1b"
  key_pair          = "${var.KEY_PAIR}"

  network {
    uuid        = "${openstack_networking_network_v2.terraform.id}"
    fixed_ip_v4 = "${var.node02-ip}"
  }

  block_device {
    uuid             = "${openstack_blockstorage_volume_v2.disk-for-node02.id}"
    source_type      = "volume"
    boot_index       = 0
    destination_type = "volume"
  }
}
