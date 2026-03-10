# -----------------------------------------------------------------------------
# ZENML PLATFORM ENGINEER CHALLENGE - INFRASTRUCTURE
# -----------------------------------------------------------------------------
#
# Your goal: Deploy a production-ready ZenML OSS server on your preferred cloud.
#
# AWS is strongly preferred as it aligns with most customer deployments.
# GCP or Azure are acceptable if you have significantly more experience there.
#
# Organize your Terraform code into modules as you see fit
# (e.g., networking/, compute/, database/).
#
# -----------------------------------------------------------------------------
# RECOMMENDED ARCHITECTURE (Managed K8s + Managed MySQL)
# -----------------------------------------------------------------------------
#
# ┌─────────────────────────────────────────────────────────────────────────┐
# │                         Virtual Network (VPC/VNet)                       │
# │  ┌────────────────────────┐    ┌────────────────────────┐               │
# │  │    Public Subnets      │    │    Private Subnets     │               │
# │  │  ┌──────────────────┐  │    │  ┌──────────────────┐  │               │
# │  │  │  Load Balancer   │──┼────┼─▶│   K8s Cluster    │  │               │
# │  │  │  (ALB/GLB/AppGW) │  │    │  │ (EKS/GKE/AKS)   │  │               │
# │  │  └──────────────────┘  │    │  │   ZenML Helm     │  │               │
# │  └────────────────────────┘    │  └────────┬─────────┘  │               │
# │                                │           │            │               │
# │                                │  ┌────────▼─────────┐  │               │
# │                                │  │  Managed MySQL   │  │               │
# │                                │  │(RDS/CloudSQL/Az) │  │               │
# │                                │  └──────────────────┘  │               │
# │                                └────────────────────────┘               │
# └─────────────────────────────────────────────────────────────────────────┘
#
# -----------------------------------------------------------------------------
# ALTERNATIVE: K8s + IN-CLUSTER MySQL
# -----------------------------------------------------------------------------
#
# You may deploy MySQL as a Kubernetes service instead of managed DB.
# This demonstrates K8s stateful workload skills (PVCs, StatefulSets).
#
# NOTE: ZenML OSS only supports MySQL (not PostgreSQL).
#
# -----------------------------------------------------------------------------
# RESOURCES
# -----------------------------------------------------------------------------
#
# - ZenML Helm Chart: https://artifacthub.io/packages/helm/zenml/zenml
# - ZenML Self-Hosting Docs: https://docs.zenml.io/getting-started/deploying-zenml
# - Cloud Best Practices:
#   - AWS EKS: https://aws.github.io/aws-eks-best-practices/
#   - GCP GKE: https://cloud.google.com/kubernetes-engine/docs/best-practices
#   - Azure AKS: https://learn.microsoft.com/en-us/azure/aks/best-practices
#
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0"

  required_providers {
    # ===================
    # AWS (strongly preferred)
    # ===================
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    # ===================
    # GCP (alternative)
    # ===================
    # google = {
    #   source  = "hashicorp/google"
    #   version = "~> 6.0"
    # }

    # ===================
    # Azure (alternative)
    # ===================
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = "~> 4.0"
    # }

    # Uncomment if using Kubernetes with Helm
    # kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = "~> 2.0"
    # }
    # helm = {
    #   source  = "hashicorp/helm"
    #   version = "~> 2.0"
    # }

    # For stretch goal: Cloud Stack provisioning
    # zenml = {
    #   source = "zenml-io/zenml"
    # }
  }

  # Stretch Goal D: Remote state
  #
  # AWS:
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "zenml/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
  #
  # GCP:
  # backend "gcs" {
  #   bucket = "your-terraform-state-bucket"
  #   prefix = "zenml"
  # }
  #
  # Azure:
  # backend "azurerm" {
  #   resource_group_name  = "terraform-state-rg"
  #   storage_account_name = "yourstorageaccount"
  #   container_name       = "tfstate"
  #   key                  = "zenml.tfstate"
  # }
}

# =============================================================================
# PROVIDER CONFIGURATION
# =============================================================================
# Uncomment and configure the provider for your chosen cloud.

# -----------------------------------------------------------------------------
# AWS Provider
# -----------------------------------------------------------------------------
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "zenml-platform-challenge"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

# -----------------------------------------------------------------------------
# GCP Provider (alternative)
# -----------------------------------------------------------------------------
# provider "google" {
#   project = var.gcp_project_id
#   region  = var.region
# }

# -----------------------------------------------------------------------------
# Azure Provider (alternative)
# -----------------------------------------------------------------------------
# provider "azurerm" {
#   features {}
#   subscription_id = var.azure_subscription_id
# }

# =============================================================================
# VARIABLES
# =============================================================================

variable "region" {
  description = "Cloud region for all resources"
  type        = string
  default     = "us-east-1"  # Change for GCP/Azure (e.g., "us-central1", "eastus")
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "zenml"
}

# Uncomment for GCP
# variable "gcp_project_id" {
#   description = "GCP project ID"
#   type        = string
# }

# Uncomment for Azure
# variable "azure_subscription_id" {
#   description = "Azure subscription ID"
#   type        = string
# }

# =============================================================================
# TODO: YOUR INFRASTRUCTURE CODE GOES HERE
# =============================================================================
#
# Suggested order:
# 1. Virtual Network (VPC/VNet with subnets, security groups/firewall rules)
# 2. MySQL Database — choose one:
#    a) Managed MySQL (RDS, Cloud SQL, Azure Database for MySQL)
#    b) MySQL as K8s StatefulSet with PVC (in-cluster)
# 3. Kubernetes Cluster (EKS, GKE, AKS) or alternative container platform
# 4. ZenML Deployment (Helm release or container service)
# 5. Load Balancer with TLS
# 6. Observability (CloudWatch, Cloud Monitoring, Azure Monitor)
#
# Tips:
# - ZenML OSS only supports MySQL (not PostgreSQL)
# - Use data sources to reference existing resources (e.g., TLS certificates)
# - Use locals for computed values and naming conventions
# - Consider using community modules:
#   - AWS: terraform-aws-modules/vpc/aws, terraform-aws-modules/eks/aws
#   - GCP: terraform-google-modules/network/google
#   - Azure: Azure/network/azurerm
# - For in-cluster MySQL: consider Bitnami Helm chart or a simple StatefulSet
#

# =============================================================================
# OUTPUTS
# =============================================================================

# output "zenml_server_url" {
#   description = "URL to access the ZenML server"
#   value       = "https://your-zenml-domain"
# }

# output "database_endpoint" {
#   description = "Database endpoint (managed or K8s service)"
#   value       = "your-database-endpoint"
#   sensitive   = true
# }
