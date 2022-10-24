# imaginary-infra

This project is for fun so do not use it on productions directly. The goal is this project is to create almost fully automated imaginary production grade environment in the cloud. Main focus is to create mostly self-hosted high-available clusters. Currently I am using Scaleway services for it but I will use other cloud providers too.

### TODO
- pyinfra vs ansible
- add pgbouncer to patroni server (maybe)
- ssh bastion
- aws, gcp, do
- pgwatch2
- earthly
- patroni certificate
- postgres certificate
- redis sentinel
- redpanda etl
- hashicorp vault
- hasicorp boundary
- seperate container env for all infra (hashicorp nomad, kubnernetes)
- seperate cloud-native for all infra with managed services
- golang/rust application for high-availability tests

### Some design choices:

* Normally I would choose instance types (cpu, memory etc.) according to the workload but I am trying to keep the cost as minimum it could be. Most likely resources (cpu, memory etc.) are not in production grade.
* Some configurations cannot be set without estimating the workload and without having reasonable resource so some performans tweaks will not be considered in this.
* I will add some configurations for easy tweaking. It may seem meaningless to set but it should gain a meaning in highloads or different systems.

### Create the infrastructure
```
terraform init
terraform apply -var-file="x.tfvars"
ansible-run -i hosts.ini pgcluster/run.yml
```

### Some problems:
1. https://github.com/hashicorp/consul/issues/10603
```
[WARN]  agent: [core]grpc: addrConn.createTransport failed to connect to {ip-addr:8300 hostname.scw-par2 <nil> 0 <nil>}. Err: connection error: desc = "transport: Error while dialing dial tcp ip-addr:0->ip-addr:8300: operation was canceled". Reconnecting..
```
