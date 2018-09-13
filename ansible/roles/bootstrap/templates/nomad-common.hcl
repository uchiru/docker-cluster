data_dir  = "/opt/nomad"

advertise {
  http = "{{ ansible_eth0.ipv4.address }}"
  rpc  = "{{ ansible_eth0.ipv4.address }}"
  serf = "{{ ansible_eth0.ipv4.address }}"
}
