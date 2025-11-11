resource "aws_ecs_service" "user" {
  name            = "user"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.user.arn
  desired_count   = 0
  launch_type     = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets          = var.service_subnet_ids
    security_groups  = [var.service_security_group_id]
    assign_public_ip = false
  }

  # BLUE 타깃그룹만 서비스에 연결, GREEN은 CodeDeploy가 관리
  load_balancer {
    target_group_arn = var.user_target_group_arn_blue
    container_name   = "user"
    container_port   = var.service_task_configs.user.container_port
  }

  service_connect_configuration {
    enabled = true
    service {
      port_name      = "user-8080-tcp"
      discovery_name = "user"
      client_alias {
        port = 8080
      }
    }
  }

  lifecycle {
    ignore_changes = all
  }
}

