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
resource "aws_apigatewayv2_route" "user" {
  api_id             = aws_apigatewayv2_api.user.id
  route_key          = "ANY /api/v1/users"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.user_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.user_1.id}"
}
resource "aws_apigatewayv2_route" "user_proxy" {
  api_id             = aws_apigatewayv2_api.user.id
  route_key          = "ANY /api/v1/users/{proxy+}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.user_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.user_1.id}"
}

## Product API (JWT)
resource "aws_apigatewayv2_route" "product" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/product"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.product_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.product_1.id}"
}
resource "aws_apigatewayv2_route" "product_proxy" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/product/{proxy+}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.product_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.product_1.id}"
}
resource "aws_apigatewayv2_route" "product_category" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/category"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.product_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.product_1.id}"
}
resource "aws_apigatewayv2_route" "product_category_proxy" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/category/{proxy+}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.product_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.product_1.id}"
}
resource "aws_apigatewayv2_route" "product_review" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/reviews"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.product_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.product_1.id}"
}
resource "aws_apigatewayv2_route" "product_review_proxy" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/reviews/{proxy+}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.product_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.product_1.id}"
}
resource "aws_apigatewayv2_route" "product_stock" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/stock"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.product_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.product_1.id}"
}
resource "aws_apigatewayv2_route" "product_stock_proxy" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/stock/{proxy+}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.product_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.product_1.id}"
}

## Order API (JWT)
resource "aws_apigatewayv2_route" "order" {
  api_id             = aws_apigatewayv2_api.order.id
  route_key          = "ANY /api/v1/orders"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.order_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.order_1.id}"
}
resource "aws_apigatewayv2_route" "order_proxy" {
  api_id             = aws_apigatewayv2_api.order.id
  route_key          = "ANY /api/v1/orders/{proxy+}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.order_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.order_1.id}"
}
resource "aws_apigatewayv2_route" "order_delivery" {
  api_id             = aws_apigatewayv2_api.order.id
  route_key          = "ANY /api/v1/delivery"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.order_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.order_1.id}"
}
resource "aws_apigatewayv2_route" "order_delivery_proxy" {
  api_id             = aws_apigatewayv2_api.order.id
  route_key          = "ANY /api/v1/delivery/{proxy+}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.order_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.order_1.id}"
}
resource "aws_apigatewayv2_route" "order_cart" {
  api_id             = aws_apigatewayv2_api.order.id
  route_key          = "ANY /api/v1/carts"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.order_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.order_1.id}"
}
resource "aws_apigatewayv2_route" "order_cart_proxy" {
  api_id             = aws_apigatewayv2_api.order.id
  route_key          = "ANY /api/v1/carts/{proxy+}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.order_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.order_1.id}"
}

## Payment API (JWT)
resource "aws_apigatewayv2_route" "payment" {
  api_id             = aws_apigatewayv2_api.payment.id
  route_key          = "ANY /api/v1/payment"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.payment_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.payment_1.id}"
}
resource "aws_apigatewayv2_route" "payment_proxy" {
  api_id             = aws_apigatewayv2_api.payment.id
  route_key          = "ANY /api/v1/payment/{proxy+}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.payment_lambda.id
  target             = "integrations/${aws_apigatewayv2_integration.payment_1.id}"
}