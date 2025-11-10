
output "common_network" {
  value = module.common_network.vpc_id
}

output "common_network_public_subnet_id" {
  value = module.common_network.public_subnet_id
}

output "common_network_private_subnet_app_id" {
  value = module.common_network.private_subnet_app_id
}

output "common_network_private_subnet_db_id" {
  value = module.common_network.private_subnet_db_id
}

output "rds_user_endpoint" {
  value = module.rds_user.endpoint
}

output "rds_product_endpoint" {
  value = module.rds_product.endpoint
}

output "rds_order_endpoint" {
  value = module.rds_order.endpoint
}

output "rds_payment_endpoint" {
  value = module.rds_payment.endpoint
}