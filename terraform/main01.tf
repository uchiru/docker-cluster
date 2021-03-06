variable "main01-ip"                { default = "192.168.99.4" }

resource "openstack_blockstorage_volume_v2" "disk-for-main01" {
  name              = "disk-for-main01"
  region            = "ru-1"
  availability_zone = "ru-1b"
  size              = 30
  volume_type       = "basic.ru-1b"
  image_id          = "${var.ubuntu_1604_v1}"
}

resource "openstack_compute_instance_v2" "main01" {
  name              = "main01"
  flavor_name       = "BL1.1-1024"
  region            = "ru-1"
  availability_zone = "ru-1b"
  key_pair          = "${var.KEY_PAIR}"

  network {
    uuid        = "${openstack_networking_network_v2.terraform.id}"
    fixed_ip_v4 = "${var.main01-ip}"
  }

  network {
    uuid        = "${var.network01_id}"
    fixed_ip_v4 = "${var.main01_public_ip}"
  }

  metadata {
    "x_sel_server_default_addr" = "{\"ipv4\":\"${var.main01_public_ip}\"}"
  }

  block_device {
    uuid             = "${openstack_blockstorage_volume_v2.disk-for-main01.id}"
    source_type      = "volume"
    boot_index       = 0
    destination_type = "volume"
  }
}
