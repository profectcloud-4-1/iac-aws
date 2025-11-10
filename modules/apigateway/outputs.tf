output "vpc_link_id" {
  description = "생성된 VPC Link ID"
  value       = aws_apigatewayv2_vpc_link.this.id
}

output "api_ids" {
  description = "각 서비스별 HTTP API ID"
  value = {
    user    = aws_apigatewayv2_api.user.id
    product = aws_apigatewayv2_api.product.id
    order   = aws_apigatewayv2_api.order.id
    payment = aws_apigatewayv2_api.payment.id
  }
}

output "api_endpoints" {
  description = "각 서비스별 HTTP API 엔드포인트(URL)"
  value = {
    user    = aws_apigatewayv2_api.user.api_endpoint
    product = aws_apigatewayv2_api.product.api_endpoint
    order   = aws_apigatewayv2_api.order.api_endpoint
    payment = aws_apigatewayv2_api.payment.api_endpoint
  }
}
