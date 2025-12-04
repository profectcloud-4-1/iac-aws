output "vpc_id" {
  value = aws_vpc.goorm.id
}

output "vpc_cidr_block" {
  value = aws_vpc.goorm.cidr_block
}


output "private_subnet_app_a_id" {
  value = aws_subnet.private-app-a.id
}

output "private_subnet_app_b_id" {
  value = aws_subnet.private-app-b.id
}

output "private_subnet_db_a_id" {
  value = aws_subnet.private_db_a.id
}

output "private_subnet_db_b_id" {
  value = aws_subnet.private_db_b.id
}

output "private_rtb_app_a_id" {
  value = aws_route_table.private_app.id
}

output "private_rtb_app_b_id" {
  value = aws_route_table.private_app.id
}

output "private_subnet_msk_a_id" {
  value = aws_subnet.msk_a.id
}

output "private_subnet_msk_b_id" {
  value = aws_subnet.msk_b.id
}

output "private_subnet_msk_c_id" {
  value = aws_subnet.msk_c.id
}

