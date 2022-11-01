output "instance_info" {
    value = [for i in scaleway_instance_server.patroni : {
      hostname  = i.name,
      publicip  = i.public_ip
      privateip = i.private_ip,
      zone      = i.zone
    }]
}
