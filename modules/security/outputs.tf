output "rds_user_sg_id" {
  value = aws_security_group.rds_user.id
}

output "rds_product_sg_id" {
  value = aws_security_group.rds_product.id
}

output "rds_order_sg_id" {
  value = aws_security_group.rds_order.id
}

output "rds_payment_sg_id" {
  value = aws_security_group.rds_payment.id
}
output "vpce_sg_id" {
  value = aws_security_group.vpce.id
}

output "vpc_link_sg_id" {
  value = aws_security_group.vpc_link.id
}

