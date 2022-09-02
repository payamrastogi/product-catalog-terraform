variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "app_name" {
  type        = string
  description = "Application Name"
}

variable "service_name" {
  type = string
  description = "Service Name"
}

variable "service_short_name" {
  type = string
  description = "Service Short Name"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "availability_zones" {
  description = "List of availability zones"
}