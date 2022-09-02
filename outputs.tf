output "aws_ecr_repository_name" {
  description = "AWS ECR Repository Name"
  value = aws_ecr_repository.aws-ecr-repository.name
}

output "aws_ecs_cluster_name" {
  description = "AWS ECS Cluster Name"
  value = aws_ecs_cluster.aws-ecs-cluster.name
}

output "ecr_url" {
  value       = aws_ecr_repository.aws-ecr-repository.repository_url
  description = "The ECR repository URL"
}

output "ecs_service_name" {
  value = aws_ecs_service.aws-ecs-service.name
  description = "ECS Service Name"
}

output "container_name" {
  value = aws_ecs_task_definition.aws-ecs-task.container_definitions
  description = "Container Name"
}

output "ecs-task-family" {
  value = aws_ecs_task_definition.aws-ecs-task.family
  description = "ECS Task Family"
}