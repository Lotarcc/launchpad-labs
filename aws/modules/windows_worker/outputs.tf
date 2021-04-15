output "private_ips" {
    value = aws_instance.mke_worker.*.private_ip
}
output "machines" {
  value = aws_instance.mke_worker.*
}
