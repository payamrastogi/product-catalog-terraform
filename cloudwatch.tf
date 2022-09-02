# to get container logs
resource "aws_cloudwatch_log_group" "aws-cw-log-group" {
  name = "${var.app_environment}-${var.app_name}-${var.service_name}-logs"

  tags = {
    Name = "${var.app_environment}-${var.app_name}-${var.service_name}-logs"
    Environment = var.app_environment
  }
}