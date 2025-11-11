
locals {
  # 예: ["tg-user-1", "tg-user-2", "tg-product-1", ...]
  target_group_names = flatten([
    for s in var.services : [
      for i in range(var.replicas_per_service) : "${var.name_prefix}-${s}-${i + 1}"
    ]
  ])
}

resource "aws_lb_target_group" "this" {
  for_each = toset(local.target_group_names)

  name        = each.key
  port        = var.port
  protocol    = var.protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id

  # NLB의 TCP 트래픽이라도 HTTP 헬스체크를 사용할 수 있음
  health_check {
    protocol            = var.health_check_protocol
    path                = var.health_check_path
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 5
  }
}

