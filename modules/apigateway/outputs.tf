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

output "stage_arns" {
  description = "각 서비스별 blue/green 스테이지 ARN"
  value = {
    user = {
      blue  = aws_apigatewayv2_stage.user_blue.arn
      green = aws_apigatewayv2_stage.user_green.arn
    }
    product = {
      blue  = aws_apigatewayv2_stage.product_blue.arn
      green = aws_apigatewayv2_stage.product_green.arn
    }
    order = {
      blue  = aws_apigatewayv2_stage.order_blue.arn
      green = aws_apigatewayv2_stage.order_green.arn
    }
    payment = {
      blue  = aws_apigatewayv2_stage.payment_blue.arn
      green = aws_apigatewayv2_stage.payment_green.arn
    }
  }
}

