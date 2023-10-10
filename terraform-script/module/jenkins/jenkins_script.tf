locals {
  jenkins-userdata = <<-EOF
#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum install wget -y
sudo yum install git -y
sudo yum install java-11-openjdk -y
sudo wget https://get.jenkins.io/redhat/jenkins-2.411-1.1.noarch.rpm
sudo rpm -ivh jenkins-2.411-1.1.noarch.rpm
sudo yum update -y
sudo yum install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
#install docker
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins
sudo chmod 777 /var/run/docker.sock
sudo service sshd restart
sudo hostnamectl set-hostname Jenkins
EOF
}