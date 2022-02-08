output "server_instance_id" {
  value = aws_instance.my_carbyne_server.id
}
output "server_instance_public_ip" {
  value = aws_instance.my_carbyne_server.public_ip
}
