resource "aws_alb" "aws-public-alb" {
  name               = "${var.app_environment}-${var.app_name}-${var.service_short_name}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.aws-public-subnets.*.id
  security_groups    = [aws_security_group.aws-lb-security-group.id]

  tags = {
    Name        = "${var.app_environment}-${var.app_name}-${var.service_name}-public-alb"
    Environment = var.app_environment
  }
}

# create a Load Balancer Target Group, it will relate the Load Balancer with the Containers.
resource "aws_lb_target_group" "aws-lb-target-group" {
  name        = "${var.app_environment}-${var.app_name}-${var.service_short_name}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.aws-vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.app_environment}-${var.app_name}-${var.service_name}-lb-tg"
    Environment = var.app_environment
  }
}

#HTTP listener for out Load Balancer
# listens to HTTP traffic on port 80 and forward it to the target group
resource "aws_lb_listener" "aws-lb-listener" {
  #associate the listener with the load balancer
  load_balancer_arn = aws_alb.aws-public-alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws-lb-target-group.id
  }
}