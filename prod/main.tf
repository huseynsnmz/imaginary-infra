resource "scaleway_account_ssh_key" "main" {
  name       = "main"
  public_key = var.ssh_key
}

resource "local_file" "hosts_config" {
  for_each        = var.template_files
  filename        = each.value.dest
  file_permission = 0644

  content = templatefile(each.value.src, {
    consulservers = [for i in module.consul.instance_info : {
      hostname  = i.hostname,
      publicip  = i.publicip,
      privateip = i.privateip,
      zone      = i.zone
    }]
    patroniservers = [for i in module.patroni.instance_info : {
      hostname  = i.hostname,
      publicip  = i.publicip
      privateip = i.privateip,
      zone      = i.zone
    }]
    pgcluster_lb = "10.10.10.10"
  })
}

module "network" {
    source = "../modules/network"
}

module "consul" {
    source = "../modules/consul"

    sec_grp_id = module.network.pgcluster_sec_grp_id
}

module "patroni" {
    source = "../modules/patroni"

    sec_grp_id = module.network.pgcluster_sec_grp_id
}
