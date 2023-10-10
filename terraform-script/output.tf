output "ansible" {
  value = module.ansible.ansible-ip
}
output "master_node" {
  value = module.master_node.master_ip
}
output "worker_node" {
  value = module.worker_node.worker_ip
}
output "jenkins" {
  value = module.jenkins.jenkins_ip
}
output "bastions_host" {
  value = module.bastion.bastion-ip
}
output "haproxy1" {
  value = module.haproxy_servers.HAProxy_IP
}
output "haproxy2" {
  value = module.haproxy_servers.HAProxy-backup_IP
}

output "prometheus-lb" {
  value = module.prometheus_lb.prometheus-lb
}

output "grafana-lb" {
  value = module.grafana_lb.grafana-lb
}
output "prod-dns_name" {
  value = module.prod_lb.prod-dns-name
}
output "stage-dns_name" {
  value = module.stage_lb.stage-dns-name
}
output "jenkins-dns_name" {
  value = module.jenkins.jenkins-dns_name
}