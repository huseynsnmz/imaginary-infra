resource "scaleway_instance_ip" "patroni_public_ip" {
  count = 3
}

resource "scaleway_instance_server" "patroni" {
  type  = "PLAY2-PICO"
  image = "rockylinux_9"
  tags  = ["consul-agent", "patroni", "postgres"]
  count = 3

  ip_id             = scaleway_instance_ip.patroni_public_ip[count.index].id
  security_group_id = var.sec_grp_id
}
