resource "aws_lb_listener" "user_1" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arns_map["tg-user-1"]
  }
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

resource "aws_lb_listener" "user_2" {
  load_balancer_arn = aws_lb.this.arn
  port              = 180
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arns_map["tg-user-2"]
  }
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

resource "aws_lb_listener" "product_1" {
  load_balancer_arn = aws_lb.this.arn
  port              = 81
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arns_map["tg-product-1"]
  }
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

resource "aws_lb_listener" "product_2" {
  load_balancer_arn = aws_lb.this.arn
  port              = 181
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arns_map["tg-product-2"]
  }
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

resource "aws_lb_listener" "order_1" {
  load_balancer_arn = aws_lb.this.arn
  port              = 82
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arns_map["tg-order-1"]
  }
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

resource "aws_lb_listener" "order_2" {
  load_balancer_arn = aws_lb.this.arn
  port              = 182
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arns_map["tg-order-2"]
  }
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

resource "aws_lb_listener" "payment_1" {
  load_balancer_arn = aws_lb.this.arn
  port              = 83
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arns_map["tg-payment-1"]
  }
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

resource "aws_lb_listener" "payment_2" {
  load_balancer_arn = aws_lb.this.arn
  port              = 183
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arns_map["tg-payment-2"]
  }
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

