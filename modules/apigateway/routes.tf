### Routes ($default/green prefix 방식)

## User API - Public endpoints (no JWT)
resource "aws_apigatewayv2_route" "user_register" {
  api_id             = aws_apigatewayv2_api.user.id
  route_key          = "POST /api/v1/users/register"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.user_1.id}"
}

resource "aws_apigatewayv2_route" "user_login" {
  api_id             = aws_apigatewayv2_api.user.id
  route_key          = "POST /api/v1/users/login"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.user_1.id}"
}
## User API - Protected proxy (JWT)
resource "aws_apigatewayv2_route" "user_proxy" {
  api_id             = aws_apigatewayv2_api.user.id
  route_key          = "ANY /api/v1/users/{proxy+}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.user_jwt.id
  target             = "integrations/${aws_apigatewayv2_integration.user_1.id}"
}

## Product API (JWT)
resource "aws_apigatewayv2_route" "product_proxy" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/product/{proxy+}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.product_jwt.id
  target             = "integrations/${aws_apigatewayv2_integration.product_1.id}"
}
resource "aws_apigatewayv2_route" "product_category_proxy" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/category/{proxy+}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.product_jwt.id
  target             = "integrations/${aws_apigatewayv2_integration.product_1.id}"
}
resource "aws_apigatewayv2_route" "product_review_proxy" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/reviews/{proxy+}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.product_jwt.id
  target             = "integrations/${aws_apigatewayv2_integration.product_1.id}"
}
resource "aws_apigatewayv2_route" "product_stock_proxy" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/stock/{proxy+}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.product_jwt.id
  target             = "integrations/${aws_apigatewayv2_integration.product_1.id}"
}

## Order API (JWT)
resource "aws_apigatewayv2_route" "order_proxy" {
  api_id             = aws_apigatewayv2_api.order.id
  route_key          = "ANY /api/v1/orders/{proxy+}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.order_jwt.id
  target             = "integrations/${aws_apigatewayv2_integration.order_1.id}"
}
resource "aws_apigatewayv2_route" "order_delivery_proxy" {
  api_id             = aws_apigatewayv2_api.order.id
  route_key          = "ANY /api/v1/delivery/{proxy+}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.order_jwt.id
  target             = "integrations/${aws_apigatewayv2_integration.order_1.id}"
}
resource "aws_apigatewayv2_route" "order_cart_proxy" {
  api_id             = aws_apigatewayv2_api.order.id
  route_key          = "ANY /api/v1/carts/{proxy+}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.order_jwt.id
  target             = "integrations/${aws_apigatewayv2_integration.order_1.id}"
}

## Payment API (JWT)
resource "aws_apigatewayv2_route" "payment_proxy" {
  api_id             = aws_apigatewayv2_api.payment.id
  route_key          = "ANY /api/v1/payment/{proxy+}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.payment_jwt.id
  target             = "integrations/${aws_apigatewayv2_integration.payment_1.id}"
}

