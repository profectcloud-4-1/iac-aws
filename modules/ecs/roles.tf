### IAM Roles for ECS and CodeDeploy

data "aws_iam_policy_document" "ecs_tasks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution" {
  name               = "ecsTaskExecutionRole-goorm"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
}

resource "aws_iam_role" "task" {
  name               = "ecsTaskRole-goorm"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json
}

data "aws_iam_policy_document" "codedeploy_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codedeploy_ecs" {
  name               = "CodeDeployRoleForECS-goorm"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS",
  ]
}


