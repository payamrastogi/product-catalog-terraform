resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "${var.app_environment}-${var.app_name}-${var.service_name}-task"

  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.app_environment}-${var.app_name}-${var.service_name}-container",
      "image": "${aws_ecr_repository.aws-ecr-repository.repository_url}:latest",
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.aws-cw-log-group.id}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${var.app_environment}-${var.app_name}-${var.service_name}"
        }
      },
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "cpu": 256,
      "memory": 512,
      "networkMode": "awsvpc"
    }
  ]
  DEFINITION

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn

  tags = {
    Name        = "${var.app_environment}-${var.app_name}-${var.service_name}-ecs-td"
    Environment = var.app_environment
  }
}