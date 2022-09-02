#security group for the load balancer
resource "aws_security_group" "aws-lb-security-group" {
  vpc_id = aws_vpc.aws-vpc.id
  #only allow tcp traffic on port 80
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "${var.app_environment}-${var.app_name}-${var.service_name}-lb-sg"
    Environment = var.app_environment
  }
}


#to avoid external connections to the containers.
resource "aws_security_group" "aws-service-security-group" {
  vpc_id = aws_vpc.aws-vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.aws-lb-security-group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.app_environment}-${var.app_name}-${var.service_name}-sg"
    Environment = var.app_environment
  }
}