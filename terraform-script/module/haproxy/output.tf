# HA Proxy Server
output "HAProxy_IP" {
  value = aws_instance.HAProxy1.private_ip
}
output "HAProxy-backup_IP" {
  value = aws_instance.HAProxy-backup.private_ip
}
