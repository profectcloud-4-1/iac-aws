
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

### (intergrations.tf에 의해 통합 생성) ###

### JWT Authorizer (각 API 공통 설정) ###
resource "aws_apigatewayv2_authorizer" "user_jwt" {
  api_id           = aws_apigatewayv2_api.user.id
  name             = "common-jwt-authorizer"
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer   = "https://public.goorm.store"
    audience = ["goormdotcom-aud"]
  }
}

resource "aws_apigatewayv2_authorizer" "product_jwt" {
  api_id           = aws_apigatewayv2_api.product.id
  name             = "common-jwt-authorizer"
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer   = "https://public.goorm.store"
    audience = ["goormdotcom-aud"]
  }
}

resource "aws_apigatewayv2_authorizer" "order_jwt" {
  api_id           = aws_apigatewayv2_api.order.id
  name             = "common-jwt-authorizer"
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer   = "https://public.goorm.store"
    audience = ["goormdotcom-aud"]
  }
}

resource "aws_apigatewayv2_authorizer" "payment_jwt" {
  api_id           = aws_apigatewayv2_api.payment.id
  name             = "common-jwt-authorizer"
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer   = "https://public.goorm.store"
    audience = ["goormdotcom-aud"]
  }
}