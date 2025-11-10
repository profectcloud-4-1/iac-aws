resource "aws_apigatewayv2_vpc_link" "this" {
  name               = var.vpc_link_name
  security_group_ids = [var.vpc_link_security_group_id]
  subnet_ids         = var.subnet_ids
}

locals {
  request_headers = {
    "overwrite:header.user-id"    = "$context.authorizer.claims.sub"
    "overwrite:header.user-roles" = "$context.authorizer.claims.role"
  }
}

resource "aws_apigatewayv2_integration" "user_1" {
  api_id                 = aws_apigatewayv2_api.user.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.this.id
  integration_uri        = var.listener_arns["user_1"]
  payload_format_version = var.payload_format_version
  timeout_milliseconds   = var.integration_timeout_ms
  description            = "Integration for user_1"

  request_parameters = local.request_headers
}

resource "aws_apigatewayv2_integration" "user_2" {
  api_id                 = aws_apigatewayv2_api.user.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.this.id
  integration_uri        = var.listener_arns["user_2"]
  payload_format_version = var.payload_format_version
  timeout_milliseconds   = var.integration_timeout_ms
  description            = "Integration for user_2"

  request_parameters = local.request_headers
}

resource "aws_apigatewayv2_integration" "product_1" {
  api_id                 = aws_apigatewayv2_api.product.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.this.id
  integration_uri        = var.listener_arns["product_1"]
  payload_format_version = var.payload_format_version
  timeout_milliseconds   = var.integration_timeout_ms
  description            = "Integration for product_1"

  request_parameters = local.request_headers
}

resource "aws_apigatewayv2_integration" "product_2" {
  api_id                 = aws_apigatewayv2_api.product.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.this.id
  integration_uri        = var.listener_arns["product_2"]
  payload_format_version = var.payload_format_version
  timeout_milliseconds   = var.integration_timeout_ms
  description            = "Integration for product_2"

  request_parameters = local.request_headers
}

resource "aws_apigatewayv2_integration" "order_1" {
  api_id                 = aws_apigatewayv2_api.order.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.this.id
  integration_uri        = var.listener_arns["order_1"]
  payload_format_version = var.payload_format_version
  timeout_milliseconds   = var.integration_timeout_ms
  description            = "Integration for order_1"

  request_parameters = local.request_headers
}

resource "aws_apigatewayv2_integration" "order_2" {
  api_id                 = aws_apigatewayv2_api.order.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.this.id
  integration_uri        = var.listener_arns["order_2"]
  payload_format_version = var.payload_format_version
  timeout_milliseconds   = var.integration_timeout_ms
  description            = "Integration for order_2"

  request_parameters = local.request_headers
}

resource "aws_apigatewayv2_integration" "payment_1" {
  api_id                 = aws_apigatewayv2_api.payment.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.this.id
  integration_uri        = var.listener_arns["payment_1"]
  payload_format_version = var.payload_format_version
  timeout_milliseconds   = var.integration_timeout_ms
  description            = "Integration for payment_1"

  request_parameters = local.request_headers
}

resource "aws_apigatewayv2_integration" "payment_2" {
  api_id                 = aws_apigatewayv2_api.payment.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.this.id
  integration_uri        = var.listener_arns["payment_2"]
  payload_format_version = var.payload_format_version
  timeout_milliseconds   = var.integration_timeout_ms
  description            = "Integration for payment_2"

  request_parameters = local.request_headers
}