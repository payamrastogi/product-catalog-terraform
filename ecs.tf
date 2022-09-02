resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = "${var.app_environment}-${var.app_name}-${var.service_name}-ecs-cluster"
  tags = {
    Name        = "${var.app_environment}-${var.app_name}-${var.service_name}-ecs-cluster"
    Environment = var.app_environment
  }
}
