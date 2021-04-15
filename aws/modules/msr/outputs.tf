output "lb_dns_name" {
    value = aws_lb.msr.dns_name
}

output "public_ips" {
    value = aws_instance.msr.*.public_ip
}

output "private_ips" {
    value = aws_instance.msr.*.private_ip
}

output "machines" {
  value = aws_instance.msr
}
