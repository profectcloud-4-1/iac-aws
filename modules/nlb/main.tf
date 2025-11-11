resource "aws_lb" "this" {
  name                             = var.name
  load_balancer_type               = "network"
  internal                         = var.internal
  subnets                          = var.subnet_ids
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
}

