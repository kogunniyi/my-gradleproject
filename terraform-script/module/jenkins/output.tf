output "jenkins-server" {
  value = aws_instance.jenkins-server.id
}

output "jenkins_ip" {
  value = aws_instance.jenkins-server.private_ip
}
output "jenkins-dns_name" {
  value = aws_elb.jenkins_lb.dns_name
}