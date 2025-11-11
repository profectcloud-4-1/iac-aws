### Task Definitions

data "aws_region" "current" {}

locals {
  log_group_user    = "${var.log_prefix}/user"
  log_group_product = "${var.log_prefix}/product"
  log_group_order   = "${var.log_prefix}/order"
  log_group_payment = "${var.log_prefix}/payment"
}

resource "aws_cloudwatch_log_group" "user" {
  name              = local.log_group_user
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "product" {
  name              = local.log_group_product
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "order" {
  name              = local.log_group_order
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "payment" {
  name              = local.log_group_payment
  retention_in_days = 30
}

resource "aws_ecs_task_definition" "user" {
  family                   = "user-task-family"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.service_task_configs.user.cpu
  memory                   = var.service_task_configs.user.memory
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name      = "user"
      image     = var.service_task_configs.user.image
      essential = true
      portMappings = [
        {
          name          = "user-8080-tcp"
          containerPort = var.service_task_configs.user.container_port
          hostPort      = var.service_task_configs.user.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.user.name
          awslogs-region        = data.aws_region.current.id
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "product" {
  family                   = "product-task-family"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.service_task_configs.product.cpu
  memory                   = var.service_task_configs.product.memory
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name      = "product"
      image     = var.service_task_configs.product.image
      essential = true
      portMappings = [
        {
          containerPort = var.service_task_configs.product.container_port
          hostPort      = var.service_task_configs.product.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.product.name
          awslogs-region        = data.aws_region.current.id
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "order" {
  family                   = "order-task-family"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.service_task_configs.order.cpu
  memory                   = var.service_task_configs.order.memory
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name      = "order"
      image     = var.service_task_configs.order.image
      essential = true
      portMappings = [
        {
          containerPort = var.service_task_configs.order.container_port
          hostPort      = var.service_task_configs.order.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.order.name
          awslogs-region        = data.aws_region.current.id
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "payment" {
  family                   = "payment-task-family"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.service_task_configs.payment.cpu
  memory                   = var.service_task_configs.payment.memory
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name      = "payment"
      image     = var.service_task_configs.payment.image
      essential = true
      portMappings = [
        {
          containerPort = var.service_task_configs.payment.container_port
          hostPort      = var.service_task_configs.payment.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.payment.name
          awslogs-region        = data.aws_region.current.id
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

