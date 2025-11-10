output "nlb_arn" {
  value = aws_lb.this.arn
}

output "listener_arns" {
  value = {
    user_1    = aws_lb_listener.user_1.arn
    user_2    = aws_lb_listener.user_2.arn
    product_1 = aws_lb_listener.product_1.arn
    product_2 = aws_lb_listener.product_2.arn
    order_1   = aws_lb_listener.order_1.arn
    order_2   = aws_lb_listener.order_2.arn
    payment_1 = aws_lb_listener.payment_1.arn
    payment_2 = aws_lb_listener.payment_2.arn
  }
}

