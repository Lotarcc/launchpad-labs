output "lb_dns_name" {
    value = aws_lb.mke_master.dns_name
}

output "public_ips" {
    value = aws_instance.mke_master.*.public_ip
}

output "private_ips" {
    value = aws_instance.mke_master.*.private_ip
}

output "machines" {
  value = aws_instance.mke_master
}
