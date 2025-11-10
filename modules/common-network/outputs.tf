output "vpc_id" {
  value = aws_vpc.goorm.id
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