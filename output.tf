output "My_Public_IP_is" {
    value = aws_instance.os1.public_ip
}

output "My_private_ip_is" {
    value = aws_instance.os1.private_ip
}

#output "Subnet_1_is" {
#    value = aws_subnet.subnets.id
#}