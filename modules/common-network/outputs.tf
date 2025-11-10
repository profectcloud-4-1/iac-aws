output "vpc_id" {
  value = aws_vpc.goorm.id
}

output "vpc_cidr_block" {
  value = aws_vpc.goorm.cidr_block
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_app_id" {
  value = aws_subnet.private-app.id
}

output "private_subnet_db_id" {
  value = aws_subnet.private-db.id
}

output "private_subnet_db_2_id" {
  value = aws_subnet.private-db-2.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}

output "nat_eip_id" {
  value = aws_eip.nat.id
}

output "nat_eip_public_ip" {
  value = aws_eip.nat.public_ip
}
