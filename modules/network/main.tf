resource "scaleway_instance_security_group" "pgcluster" {
  inbound_default_policy  = "accept"
  outbound_default_policy = "accept"

  inbound_rule {
    action = "accept"
    port   = "22"
  }
}

# add load balancer with acl frontend
# add private network
# add public gateway
