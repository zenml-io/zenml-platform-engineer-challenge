variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "app_port" {
  description = "Port exposed by the application container"
  type        = number
  default     = 8080
}

variable "db_port" {
  description = "Port used by MySQL"
  type        = number
  default     = 3306
}