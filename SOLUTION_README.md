# ZenML Platform Engineer Challenge

## Overview

This project deploys a **production-ready ZenML server on AWS** using a minimal, secure, and fully containerized architecture.

The infrastructure is implemented with **Terraform** and follows best practices for:
- networking
- security
- secrets management
- observability

---

## Architecture

### High-level design

```
Internet
   ↓
ALB (public subnets)
   ↓
ECS Fargate (private subnets)
   ↓
RDS MySQL (private subnets)
```

### Components

- **ECS Fargate** — runs the ZenML server container
- **Application Load Balancer (ALB)** — public entrypoint
- **RDS MySQL** — external metadata database
- **Secrets Manager** — secure credential storage
- **VPC (public/private subnets)** — network isolation
- **CloudWatch Logs** — application logging

---

## Key Design Decisions

### ECS Fargate instead of Kubernetes

- reduces operational complexity (no control plane)
- faster to implement within time constraints
- still meets all requirements (containerization, IAM, logging, networking)

**Trade-off:** less flexibility than EKS, but significantly simpler

---

### RDS MySQL

- ZenML requires a MySQL-compatible database
- managed service → backups, patching, reliability
- avoids running database in containers

---

### Application Load Balancer (ALB)

- integrates natively with ECS
- provides health checks and routing
- enables TLS termination via ACM

---

### Secrets Manager

- avoids hardcoding credentials
- securely injects secrets into ECS tasks
- supports least-privilege IAM access

---

### Networking

- **public subnets:** ALB, NAT Gateway  
- **private subnets:** ECS tasks, RDS  

This ensures:
- no direct public access to application or database
- controlled traffic flow through the load balancer

---

## Repository Structure

```
infrastructure/
  main.tf
  variables.tf
  outputs.tf
  versions.tf
  providers.tf

  modules/
    network/
    security/
    rds/
    alb/
    ecs/

```

---

## How to Deploy

### 1. Prerequisites

- Terraform ≥ 1.14.0
- AWS CLI configured
- AWS account with sufficient permissions

---

### 2. Configure variables

```bash
cp infrastructure/terraform.tfvars.example infrastructure/terraform.tfvars
```

Edit values if needed.

---

### 3. Deploy

```bash
cd infrastructure
terraform init
terraform apply
```

---

### 4. Access the application

```bash
terraform output alb_dns_name
```

Open in browser:

```
http://<alb-dns-name>
```

---

### 5. Retrieve admin password

Access secret manager from your console and retrieve the zenml-dev-zenml-admins-password secret value.

---

### 6. Cleanup - Destroy infrastructure

```bash
terraform destroy
```

---

## Observability

- **Logs:** CloudWatch Logs (ECS container logs)
- **Health checks:** ALB target group health checks
- **Debugging:** ECS service events + CloudWatch logs

---

## Security

- ECS and RDS run in **private subnets**
- only ALB is publicly accessible
- database access restricted to ECS only
- secrets stored in **AWS Secrets Manager**
- IAM roles follow least privilege

---

## Trade-offs

| Decision | Trade-off |
|--------|--------|
| ECS over EKS | simpler, less flexible |
| single NAT Gateway | cheaper, less resilient |
| single ECS task | minimal cost, no redundancy |
| no autoscaling | simpler, not production-scale |

---

## Improvements

- TLS with ACM + HTTPS listener
- autoscaling for ECS service
- multi-AZ RDS deployment
- monitoring dashboards
- CI/CD pipeline

---

## Demo 
Loom demo : https://www.loom.com/share/822bb59e20614813904d5e5ff7f077ce 
