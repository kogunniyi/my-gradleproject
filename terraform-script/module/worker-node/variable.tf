variable "ubuntu_ami" {}
variable "instance_type" {}
variable "worker-node-sg" {}
variable "subnet_id" { type = list(string) }
variable "keypair_name" {}
variable "instance_count" {}
variable "instance_name" {}