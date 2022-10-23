variable "project_id" {
  type        = string
  description = "Your project ID."
}

variable "access_key" {
  type        = string
  description = "Access Key for project."
}

variable "secret_key" {
  type        = string
  description = "Secret Key for project."
}

variable "ssh_key" {
  type        = string
  description = "SSH key for connecting hosts with ssh key"
}

resource "scaleway_account_ssh_key" "main" {

  name       = "main"
  public_key = var.ssh_key
}

terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  project_id = var.project_id
  access_key = var.access_key
  secret_key = var.secret_key
  zone       = "fr-par-2"
  region     = "fr-par"
}

resource "scaleway_instance_ip" "consul_public_ip" {
  count = scaleway_instance_server.consul.count
}

resource "scaleway_instance_security_group" "pgcluster" {
  inbound_default_policy  = "accept"
  outbound_default_policy = "accept"

  inbound_rule {
    action = "accept"
    port   = "22"
  }
}

resource "scaleway_instance_server" "consul" {
  type  = "PLAY2-PICO"
  image = "rockylinux_9"
  tags  = ["consul-server"]
  count = 3

  ip_id = scaleway_instance_ip.consul_public_ip[count.index].id
  security_group_id = scaleway_instance_security_group.pgcluster.id
}


resource "scaleway_instance_server" "patroni" {
  type  = "PLAY2-PICO"
  image = "rockylinux_9"
  tags  = ["consul-agent", "patroni", "postgres"]
  count = 3

  ip_id = scaleway_instance_ip.patroni_public_ip[count.index].id
  security_group_id = scaleway_instance_security_group.pgcluster.id
}


resource "local_file" "hosts_config" {
    content = templatefile("${path.module}/templates/hosts.tftpl", {
        consulservers = [for i in scaleway_instance_server.consul : {
            hostname = i.name,
            publicip = i.public_ip,
            privateip = i.private_ip,
            zone = i.zone
        }]
    })
    filename = "hosts.ini"
    file_permission = 0644
}
