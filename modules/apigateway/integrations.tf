data "aws_lb" "ngf" {
  tags = {
    "kubernetes.io/service-name" = "nginx-gateway/ngf-nginx-gateway-fabric"
  }
}

data "aws_lb_listener" "ngf_http" {
  load_balancer_arn = data.aws_lb.ngf.arn

  # listener port 80
  port = 80
}

locals {
  listener_nlb = data.aws_lb_listener.ngf_http.arn
}

resource "aws_apigatewayv2_vpc_link" "this" {
  name               = var.vpc_link_name
  security_group_ids = [var.vpc_link_security_group_id]
  subnet_ids         = var.vpi_link_subnet_ids
}

resource "aws_apigatewayv2_integration" "user" {
  count                  = var.enable_integrations && local.listener_nlb != null ? 1 : 0

  api_id                 = aws_apigatewayv2_api.user.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.this.id
  integration_uri        = local.listener_nlb
  payload_format_version = var.payload_format_version
  timeout_milliseconds   = var.integration_timeout_ms
  description            = "Integration for user"
}

resource "aws_apigatewayv2_integration" "product" {
  count                  = var.enable_integrations && local.listener_nlb != null ? 1 : 0

  api_id                 = aws_apigatewayv2_api.product.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.this.id
  integration_uri        = local.listener_nlb
  payload_format_version = var.payload_format_version
  timeout_milliseconds   = var.integration_timeout_ms
  description            = "Integration for product"
}

resource "aws_apigatewayv2_integration" "order" {
  count                  = var.enable_integrations && local.listener_nlb != null ? 1 : 0

  api_id                 = aws_apigatewayv2_api.order.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.this.id
  integration_uri        = local.listener_nlb
  payload_format_version = var.payload_format_version
  timeout_milliseconds   = var.integration_timeout_ms
  description            = "Integration for order"
}

resource "aws_apigatewayv2_integration" "payment" {
  count                  = var.enable_integrations && local.listener_nlb != null ? 1 : 0

  api_id                 = aws_apigatewayv2_api.payment.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.this.id
  integration_uri        = local.listener_nlb
  payload_format_version = var.payload_format_version
  timeout_milliseconds   = var.integration_timeout_ms
  description            = "Integration for payment"
}
