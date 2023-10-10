variable "vpc_name" {}
variable "prt_sn1_name" {}
variable "prt_sn2_name" {}
variable "prt_sn3_name" {}
variable "pub_sn1_name" {}
variable "pub_sn2_name" {}
variable "pub_sn3_name" {}
variable "vpc_instance_tenancy" {}
variable "cidr_block_vpc" {}
variable "pub_sn1_cidr_block" {}
variable "pub_sn2_cidr_block" {}
variable "pub_sn3_cidr_block" {}
variable "priv_sn1_cidr_block" {}
variable "priv_sn2_cidr_block" {}
variable "priv_sn3_cidr_block" {}
variable "az1" {}
variable "az2" {}
variable "az3" {}
variable "igw_name" {}
variable "nat-gateway_name" {}
variable "prt_RT_name" {}
variable "pub_RT_name" {}

#Keypair
variable "key_name" {}

#security group
variable "all-cidr" {}
variable "ansible_sg_name" {}
variable "jenkins_sg_name" {}
variable "master_sg_name" {}
variable "worker_sg_name" {}