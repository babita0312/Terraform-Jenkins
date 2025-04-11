output "ips" {
  value = aws_instance.web1[0].private_ip
  sensitive = true
}

