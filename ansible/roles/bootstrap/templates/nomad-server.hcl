server {
  enabled          = true
  bootstrap_expect = 1
}

consul {
  address = "{{ ansible_eth0.ipv4.address }}:8500"
}
