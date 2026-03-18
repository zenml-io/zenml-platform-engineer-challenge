variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 8080
}

variable "container_image" {
  description = "Container image to deploy"
  type        = string
}

variable "container_cpu" {
  description = "Task CPU units"
  type        = number
  default     = 512
}

variable "container_memory" {
  description = "Task memory in MiB"
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "db_host" {
  description = "Database host"
  type        = string
}

variable "db_port" {
  description = "Database port"
  type        = number
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_secret_arn" {
  description = "Secrets Manager ARN containing DB credentials"
  type        = string
}

variable "zenml_auto_activate" {
  description = "Whether to auto-activate the ZenML server"
  type        = bool
  default     = true
}

variable "zenml_admin_username" {
  description = "Initial ZenML admin username"
  type        = string
  default     = "admin"
}


variable "zenml_admin_secret_arn" {
  description = "Secrets Manager ARN containing initial ZenML admin password"
  type        = string
}