provider "aws" {
  profile = var.profile-name
  region  = var.region
}

# create vpc module
module "vpc" {
  source               = "./module/vpc"
  vpc_name             = "${var.project-name}-vpc"
  pub_sn1_name         = "${var.project-name}-pub-sn1"
  pub_sn2_name         = "${var.project-name}-pub-sn2"
  pub_sn3_name         = "${var.project-name}-pub-sn3"
  prt_sn1_name         = "${var.project-name}-prt-sn1"
  prt_sn2_name         = "${var.project-name}-prt-sn2"
  prt_sn3_name         = "${var.project-name}-prt-sn3"
  igw_name             = "${var.project-name}-igw"
  nat-gateway_name     = "${var.project-name}-ngw"
  prt_RT_name          = "${var.project-name}-prt-rt"
  pub_RT_name          = "${var.project-name}-pub-rt"
  vpc_instance_tenancy = var.vpc_instance_tenancy
  cidr_block_vpc       = var.cidr_block_vpc
  pub_sn1_cidr_block   = var.pub_sn1_cidr_block
  pub_sn2_cidr_block   = var.pub_sn2_cidr_block
  pub_sn3_cidr_block   = var.pub_sn3_cidr_block
  priv_sn1_cidr_block  = var.priv_sn1_cidr_block
  priv_sn2_cidr_block  = var.priv_sn2_cidr_block
  priv_sn3_cidr_block  = var.priv_sn3_cidr_block
  az1                  = var.az1
  az2                  = var.az2
  az3                  = var.az3

  # key name
  key_name = "${var.project-name}-keypair"

  # security Group
  ansible_sg_name = "${var.project-name}-ansible-sg"
  jenkins_sg_name = "${var.project-name}-jenkins-sg"
  master_sg_name  = "${var.project-name}-master-sg"
  worker_sg_name  = "${var.project-name}-worker-sg"
  all-cidr        = var.all-cidr
}

# create jenkins module
module "jenkins" {
  source           = "./module/jenkins"
  ami-redhat       = var.ami-redhat
  instance_type_t2 = var.instance_type2
  keypair_name     = module.vpc.keypair
  prt_sn1          = module.vpc.prtsub1_id
  jenkins_sg       = module.vpc.jenkins_sg_id
  jenkins_name     = "${var.project-name}-jenkins"
  elb_name         = "${var.project-name}-elb"
  subnet_id2       = [module.vpc.pubsub1_id, module.vpc.pubsub2_id, module.vpc.pubsub3_id]
}

# create bastion host module
module "bastion" {
  source              = "./module/bastion-host"
  bastion-name        = "${var.project-name}-bastion-host"
  ubuntu_ami          = var.ubuntu-ami
  instance_type_micro = var.instance_type
  subnet_id           = module.vpc.pubsub1_id
  security_group      = module.vpc.ansible_sg_id
  keypair_name        = module.vpc.keypair
  private_key         = module.vpc.private-key
}

# create ansible server module
module "ansible" {
  source         = "./module/ansible"
  ami            = var.ubuntu-ami
  instance_type  = var.instance_type
  subnet_id      = module.vpc.prtsub1_id
  ansible-sg-id  = module.vpc.ansible_sg_id
  keys           = module.vpc.keypair
  prv_key        = module.vpc.private-key
  HAproxy1_IP    = module.haproxy_servers.HAProxy_IP
  HAproxy2_IP    = module.haproxy_servers.HAProxy-backup_IP
  master1_IP     = module.master_node.master_ip[0]
  master2_IP     = module.master_node.master_ip[1]
  master3_IP     = module.master_node.master_ip[2]
  worker1_IP     = module.worker_node.worker_ip[0]
  worker2_IP     = module.worker_node.worker_ip[1]
  worker3_IP     = module.worker_node.worker_ip[2]
  bastion-host   = module.bastion.bastion-ip
  ansible_server = "${var.project-name}-ansible-server"
}

# create master node module
module "master_node" {
  source         = "./module/master-node"
  instance_count = var.instance-count
  ubuntu_ami     = var.ubuntu-ami
  instance_type  = var.instance_type2
  instance_name  = "${var.project-name}-master-node"
  master-node-sg = module.vpc.master_sg_id
  subnet_id      = [module.vpc.prtsub1_id, module.vpc.prtsub2_id, module.vpc.prtsub3_id]
  keypair_name   = module.vpc.keypair
}

# create worker node module
module "worker_node" {
  source         = "./module/worker-node"
  instance_count = var.instance-count
  ubuntu_ami     = var.ubuntu-ami
  instance_type  = var.instance_type2
  instance_name  = "${var.project-name}-worker-node"
  worker-node-sg = module.vpc.master_sg_id
  keypair_name   = module.vpc.keypair
  subnet_id      = [module.vpc.prtsub1_id, module.vpc.prtsub2_id, module.vpc.prtsub3_id]
}

# create haproxy module 
module "haproxy_servers" {
  source        = "./module/haproxy"
  keypair       = module.vpc.keypair
  ami           = var.ubuntu-ami
  instance_type = var.instance_type2
  prtsub1_id    = module.vpc.prtsub1_id
  prtsub2_id    = module.vpc.prtsub3_id
  HAproxy_sg    = module.vpc.master_sg_id
  master1       = module.master_node.master_ip[0]
  master2       = module.master_node.master_ip[1]
  master3       = module.master_node.master_ip[2]
  master4       = module.master_node.master_ip[0]
  master5       = module.master_node.master_ip[1]
  master6       = module.master_node.master_ip[2]
  name-tags     = "${var.project-name}-haproxy1"
  name-tags2    = "${var.project-name}-haproxy-backup"
}

# create route53 module 
module "route53" {
  source                        = "./module/route_53"
  domain_name                   = var.domain_name
  domain_name2                  = var.domain_name2
  grafana_domain_hosted_zone    = var.grafana_domain_hosted_zone
  prometheus_domain_hosted_zone = var.prometheus_domain_hosted_zone
  stage_domain_hosted_zone      = var.stage_domain_hosted_zone
  prod_domain_name              = var.prod_domain_name
  prometheus-lb-dns-name        = module.prometheus_lb.prometheus-lb
  prometheus-lb-zone-id         = module.prometheus_lb.prometheus-zone_id
  grafana-lb-dns-name           = module.grafana_lb.grafana-lb
  grafana-lb-zone-id            = module.grafana_lb.grafana-zone_id
  prod-lb-dns-name              = module.prod_lb.prod-dns-name
  prod-lb-zone-id               = module.prod_lb.prod-zone-id
  stage-lb-dns-name             = module.stage_lb.stage-dns-name
  stage-lb-zone-id              = module.stage_lb.stage-zone-id
}

# create production load balancer
module "prod_lb" {
  source          = "./module/prod-lb"
  sg              = module.vpc.master_sg_id
  vpc_id          = module.vpc.vpc_id
  vpc             = module.vpc.keypair
  certificate_arn = module.route53.k8s-cert
  name            = "${var.project-name}-prod-lb"
  name2           = "${var.project-name}-prod-tg"
  instance1       = module.worker_node.worker_id[0]
  instance2       = module.worker_node.worker_id[1]
  instance3       = module.worker_node.worker_id[2]
  subnets         = [module.vpc.pubsub1_id, module.vpc.pubsub2_id, module.vpc.pubsub3_id]
}

# create stage load balancer
module "stage_lb" {
  source          = "./module/stage-lb"
  sg              = module.vpc.master_sg_id
  vpc_id          = module.vpc.vpc_id
  vpc             = module.vpc.keypair
  certificate_arn = module.route53.k8s-cert
  name            = "${var.project-name}-stage-lb"
  name2           = "${var.project-name}-stage-tg"
  instance1       = module.worker_node.worker_id[0]
  instance2       = module.worker_node.worker_id[1]
  instance3       = module.worker_node.worker_id[2]
  subnets         = [module.vpc.pubsub1_id, module.vpc.pubsub2_id, module.vpc.pubsub3_id]
}

# create prometheus load balancer
module "prometheus_lb" {
  source             = "./module/prometheus"
  prometheus_sg_name = module.vpc.master_sg_id
  instance           = module.worker_node.worker_id
  vpc_id             = module.vpc.vpc_id
  acm_certificate    = module.route53.k8s-cert
  name            = "${var.project-name}-prometheus-lb"
  name2           = "${var.project-name}-promethues-tg"
  subnets            = [module.vpc.pubsub1_id, module.vpc.pubsub2_id, module.vpc.pubsub3_id]
}

# create grafana load balancer
module "grafana_lb" {
  source          = "./module/grafana"
  grafana_sg_name = module.vpc.master_sg_id
  instance        = module.worker_node.worker_id
  vpc_id          = module.vpc.vpc_id
  acm_certificate = module.route53.k8s-cert
  name            = "${var.project-name}-grafana-lb"
  name2           = "${var.project-name}-grafana-tg"
  subnets         = [module.vpc.pubsub1_id, module.vpc.pubsub2_id, module.vpc.pubsub3_id]
}