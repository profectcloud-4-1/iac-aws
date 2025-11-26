### Routes

## User API
resource "aws_apigatewayv2_route" "user" {
  api_id             = aws_apigatewayv2_api.user.id
  route_key          = "ANY /api/v1/users"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.user.id}"
}
resource "aws_apigatewayv2_route" "user_proxy" {
  api_id             = aws_apigatewayv2_api.user.id
  route_key          = "ANY /api/v1/users/{proxy+}"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.user.id}"
}

## Product API
resource "aws_apigatewayv2_route" "product" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/product"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.product.id}"
}
resource "aws_apigatewayv2_route" "product_proxy" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/product/{proxy+}"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.product.id}"
}
resource "aws_apigatewayv2_route" "product_category" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/category"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.product.id}"
}
resource "aws_apigatewayv2_route" "product_category_proxy" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/category/{proxy+}"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.product.id}"
}
resource "aws_apigatewayv2_route" "product_review" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/reviews"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.product.id}"
}
resource "aws_apigatewayv2_route" "product_review_proxy" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/reviews/{proxy+}"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.product.id}"
}
resource "aws_apigatewayv2_route" "product_stock" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/stock"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.product.id}"
}
resource "aws_apigatewayv2_route" "product_stock_proxy" {
  api_id             = aws_apigatewayv2_api.product.id
  route_key          = "ANY /api/v1/stock/{proxy+}"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.product.id}"
}

## Order API
resource "aws_apigatewayv2_route" "order" {
  api_id             = aws_apigatewayv2_api.order.id
  route_key          = "ANY /api/v1/orders"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.order.id}"
}
resource "aws_apigatewayv2_route" "order_proxy" {
  api_id             = aws_apigatewayv2_api.order.id
  route_key          = "ANY /api/v1/orders/{proxy+}"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.order.id}"
}
resource "aws_apigatewayv2_route" "order_delivery" {
  api_id             = aws_apigatewayv2_api.order.id
  route_key          = "ANY /api/v1/delivery"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.order.id}"
}
resource "aws_apigatewayv2_route" "order_delivery_proxy" {
  api_id             = aws_apigatewayv2_api.order.id
  route_key          = "ANY /api/v1/delivery/{proxy+}"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.order.id}"
}
resource "aws_apigatewayv2_route" "order_cart" {
  api_id             = aws_apigatewayv2_api.order.id
  route_key          = "ANY /api/v1/carts"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.order.id}"
}
resource "aws_apigatewayv2_route" "order_cart_proxy" {
  api_id             = aws_apigatewayv2_api.order.id
  route_key          = "ANY /api/v1/carts/{proxy+}"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.order.id}"
}

## Payment API
resource "aws_apigatewayv2_route" "payment" {
  api_id             = aws_apigatewayv2_api.payment.id
  route_key          = "ANY /api/v1/payment"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.payment.id}"
}
resource "aws_apigatewayv2_route" "payment_proxy" {
  api_id             = aws_apigatewayv2_api.payment.id
  route_key          = "ANY /api/v1/payment/{proxy+}"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.payment.id}"
}