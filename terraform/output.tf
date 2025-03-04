# Output the VPC ID
output "vpc_id" {
  value = aws_vpc.packer.id
}

# Output the Subnet ID
output "subnet_id" {
  value = aws_subnet.packer.id
}

output "security_group_id" {
  value = aws_security_group.packer.id
}