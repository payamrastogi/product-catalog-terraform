data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.aws-ecs-task.family
}

resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "${var.app_environment}-${var.app_name}-${var.service_name}-ecs-service"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = "${aws_ecs_task_definition.aws-ecs-task.family}:${max(aws_ecs_task_definition.aws-ecs-task.revision, data.aws_ecs_task_definition.main.revision)}"
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 3
  force_new_deployment = true

  network_configuration {
    subnets          = aws_subnet.aws-private-subnets.*.id
    assign_public_ip = false
    security_groups = [
      aws_security_group.aws-service-security-group.id,
      aws_security_group.aws-lb-security-group.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.aws-lb-target-group.arn
    container_name   = "${var.app_environment}-${var.app_name}-${var.service_name}-container"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.aws-lb-listener]
}