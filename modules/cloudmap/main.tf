resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = var.namespace_name
  description = var.description
  vpc         = var.vpc_id

  tags = merge(
    {
      Name = var.namespace_name
    },
    var.tags,
  )
  lifecycle {
    prevent_destroy = true
  }
}

