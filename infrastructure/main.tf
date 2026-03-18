data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "network" {
  source = "./modules/network"

  name_prefix          = local.name_prefix
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = data.aws_availability_zones.available.names
}

module "security" {
  source = "./modules/security"

  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id
  app_port    = var.app_port
  db_port     = var.db_port
}

module "rds" {
  source = "./modules/rds"

  name_prefix           = local.name_prefix
  private_subnet_ids    = module.network.private_subnet_ids
  rds_security_group_id = module.security.rds_security_group_id

  db_name           = var.db_name
  db_username       = var.db_username
  db_port           = var.db_port
  db_instance_class = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  engine_version    = var.db_engine_version
}

module "alb" {
  source = "./modules/alb"

  name_prefix           = local.name_prefix
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  app_port              = var.app_port
  health_check_path     = var.health_check_path
}

resource "random_password" "zenml_admin" {
  length           = 20
  special          = false
}

resource "aws_secretsmanager_secret" "zenml_admin" {
  name = "${local.name_prefix}-zenml-admins-password"
}

resource "aws_secretsmanager_secret_version" "zenml_admin" {
  secret_id = aws_secretsmanager_secret.zenml_admin.id
  secret_string = jsonencode({
    password = random_password.zenml_admin.result
  })
}
module "ecs" {
  source = "./modules/ecs"

  name_prefix           = local.name_prefix
  aws_region            = var.aws_region
  private_subnet_ids    = module.network.private_subnet_ids
  ecs_security_group_id = module.security.ecs_security_group_id
  target_group_arn      = module.alb.target_group_arn

  app_port         = var.app_port
  container_image  = var.container_image
  container_cpu    = var.container_cpu
  container_memory = var.container_memory
  desired_count    = var.desired_count

  db_host       = module.rds.db_instance_endpoint
  db_port       = module.rds.db_instance_port
  db_name       = module.rds.db_name
  db_username   = module.rds.db_username
  db_secret_arn = module.rds.db_secret_arn

  zenml_auto_activate    = var.zenml_auto_activate
  zenml_admin_username   = var.zenml_admin_username
  zenml_admin_secret_arn = aws_secretsmanager_secret.zenml_admin.arn
}