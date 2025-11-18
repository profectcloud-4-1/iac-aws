
### HTTP API + Stage ###

resource "aws_apigatewayv2_api" "user" {
  name          = "user-api"
  protocol_type = "HTTP"
}
resource "aws_apigatewayv2_stage" "user_default" {
  api_id      = aws_apigatewayv2_api.user.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_api" "product" {
  name          = "product-api"
  protocol_type = "HTTP"
}
resource "aws_apigatewayv2_stage" "product_default" {
  api_id      = aws_apigatewayv2_api.product.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_api" "order" {
  name          = "order-api"
  protocol_type = "HTTP"
}
resource "aws_apigatewayv2_stage" "order_default" {
  api_id      = aws_apigatewayv2_api.order.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_api" "payment" {
  name          = "payment-api"
  protocol_type = "HTTP"
}
resource "aws_apigatewayv2_stage" "payment_default" {
  api_id      = aws_apigatewayv2_api.payment.id
  name        = "$default"
  auto_deploy = true
}

### Lambda Authorizer (각 API 공통 설정) ###
resource "aws_apigatewayv2_authorizer" "common_lambda" {
  for_each = toset([
    aws_apigatewayv2_api.user.id,
    aws_apigatewayv2_api.product.id,
    aws_apigatewayv2_api.order.id,
    aws_apigatewayv2_api.payment.id
  ])

  api_id                            = each.key
  name                              = "common-lambda-authorizer"
  authorizer_type                   = "REQUEST"
  authorizer_uri                    = var.authorizer_uri
  authorizer_payload_format_version = "2.0"
  enable_simple_response            = true
  identity_sources = [
    "$request.header.Authorization",
    "$request.header.X-Forwarded-For"
  ]
}