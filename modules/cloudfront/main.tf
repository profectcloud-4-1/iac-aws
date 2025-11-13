
locals {
  user_origin    = replace(var.user_api_endpoint, "https://", "")
  product_origin = replace(var.product_api_endpoint, "https://", "")
  order_origin   = replace(var.order_api_endpoint, "https://", "")
  payment_origin = replace(var.payment_api_endpoint, "https://", "")
  user_service_paths = [
    "/api/v1/users*",
  ]
  product_service_paths = [
    "/api/v1/product*",
    "/api/v1/category*",
    "/api/v1/reviews*",
    "/api/v1/stock*",
  ]
  order_service_paths = [
    "/api/v1/orders*",
    "/api/v1/delivery*",
    "/api/v1/carts*",
  ]
  payment_service_paths = [
    "/api/v1/payment*",
  ]
}

data "aws_cloudfront_cache_policy" "disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "all_viewer_except_host" {
  name = "Managed-AllViewerExceptHostHeader"
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_origin_access_control" "s3" {
  name                              = "oac-s3-origin"
  description                       = "OAC for S3 static origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  enabled = true
  aliases = [var.domain_name]

  origin {
    domain_name = local.user_origin
    origin_id   = "user-api-origin"
    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  origin {
    domain_name = local.product_origin
    origin_id   = "product-api-origin"
    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  origin {
    domain_name = local.order_origin
    origin_id   = "order-api-origin"
    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  origin {
    domain_name = local.payment_origin
    origin_id   = "payment-api-origin"
    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id         = "user-api-origin"
    viewer_protocol_policy   = "redirect-to-https"
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "PATCH", "POST", "DELETE"]
    cached_methods           = ["GET", "HEAD"]
    cache_policy_id          = data.aws_cloudfront_cache_policy.disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
  }

  ### User Service ###
  dynamic "ordered_cache_behavior" {
    for_each = toset(local.user_service_paths)
    content {
      path_pattern             = ordered_cache_behavior.value
      target_origin_id         = "user-api-origin"
      viewer_protocol_policy   = "redirect-to-https"
      allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "PATCH", "POST", "DELETE"]
      cached_methods           = ["GET", "HEAD"]
      cache_policy_id          = data.aws_cloudfront_cache_policy.disabled.id
      origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
    }
  }

  ### Product Service ###
  dynamic "ordered_cache_behavior" {
    for_each = toset(local.product_service_paths)
    content {
      path_pattern             = ordered_cache_behavior.value
      target_origin_id         = "product-api-origin"
      viewer_protocol_policy   = "redirect-to-https"
      allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "PATCH", "POST", "DELETE"]
      cached_methods           = ["GET", "HEAD"]
      cache_policy_id          = data.aws_cloudfront_cache_policy.disabled.id
      origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
    }
  }

  ### Order Service ###
  dynamic "ordered_cache_behavior" {
    for_each = toset(local.order_service_paths)
    content {
      path_pattern             = ordered_cache_behavior.value
      target_origin_id         = "order-api-origin"
      viewer_protocol_policy   = "redirect-to-https"
      allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "PATCH", "POST", "DELETE"]
      cached_methods           = ["GET", "HEAD"]
      cache_policy_id          = data.aws_cloudfront_cache_policy.disabled.id
      origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
    }
  }

  ### Payment Service ###
  dynamic "ordered_cache_behavior" {
    for_each = toset(local.payment_service_paths)
    content {
      path_pattern             = ordered_cache_behavior.value
      target_origin_id         = "payment-api-origin"
      viewer_protocol_policy   = "redirect-to-https"
      allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "PATCH", "POST", "DELETE"]
      cached_methods           = ["GET", "HEAD"]
      cache_policy_id          = data.aws_cloudfront_cache_policy.disabled.id
      origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
    }
  }

  # TODO: s3 origin 추가
  origin {
    domain_name              = "${var.s3_bucket_name}.s3.amazonaws.com"
    origin_id                = "s3-origin"
    origin_path              = "/main"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3.id
    s3_origin_config {
      origin_access_identity = ""
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/img/*"
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cf.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

resource "aws_route53_record" "alias_cf" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}

