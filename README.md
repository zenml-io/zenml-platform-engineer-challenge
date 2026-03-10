# ZenML Platform Engineer Challenge — Self-Hosted Deployment (4-5h)

## Overview

At ZenML, we help enterprise customers deploy and operate ZenML in their own infrastructure. As a Senior Platform Engineer, you'll be the expert who guides customers through production deployments, debugs issues, and ensures their MLOps platform is resilient and secure.

For this challenge, you will deploy a production-ready ZenML OSS server on a major cloud provider (AWS preferred), demonstrating the infrastructure and operational skills we need.

## The Scenario

**Acme Corp** is a mid-sized company that wants to self-host ZenML for data governance reasons. They have:

- A cloud account with full admin access (AWS - preferred, GCP, or Azure)
- A team of Data Scientists who will use ZenML (they are not infrastructure experts)
- Requirements for: TLS encryption, external database, proper authentication

**Your Job**: Deploy ZenML OSS on your preferred cloud provider and create documentation that their platform team can use to maintain it.

**Cloud Provider**: We **strongly prefer AWS** (EKS, RDS, ALB) as it aligns with most of our customer deployments. However, if you have significantly more experience with **GCP** (GKE, Cloud SQL) or **Azure** (AKS, Azure Database for MySQL), those are acceptable alternatives.

---

## Your Task

### 1. Infrastructure (Terraform)

**Requirement**: Use Terraform to provision the cloud infrastructure for ZenML.

At minimum, your infrastructure should include:

- **Compute**: A containerized deployment of the ZenML server
  - **Recommended**: Managed Kubernetes (EKS/GKE/AKS) with the official ZenML Helm chart
  - **Alternatives welcome**: Other containerized solutions (ECS, Cloud Run, App Runner, Azure Container Apps) — if you choose an alternative, document why
- **Database**: MySQL for ZenML metadata
  - **Option A**: Managed MySQL (RDS, Cloud SQL, Azure Database for MySQL) — production-ready
  - **Option B**: MySQL as a Kubernetes service — demonstrates K8s stateful workload skills
- **Networking**: Virtual network with appropriate subnets and security groups/firewall rules
- **Load Balancing**: Load balancer with TLS termination
- **IAM**: Proper roles and policies (least privilege)

**Evaluation note**: We care more about your infrastructure decisions and documentation than which specific cloud or compute platform you choose.

### 2. ZenML Server Configuration

**Requirement**: Deploy and configure ZenML OSS server.

Your deployment should include:

- External MySQL database connection (not SQLite)
- TLS/HTTPS access
- Authentication enabled (OAuth2 or HTTP Basic — your choice)
- Health checks configured
- Appropriate resource allocation

**Validation**: You should be able to run `zenml login <your-server-url>` successfully.

### 3. Observability

**Requirement**: Implement basic observability for the deployment.

Include at least:

- **Logging**: Where do ZenML server logs go? How would you debug an issue?
- **Monitoring**: At least 2 health/performance metrics tracked
- **Alerting**: At least 1 meaningful alert (e.g., server unhealthy, high error rate)

You may use CloudWatch, Prometheus/Grafana, or any other observability stack.

### 4. Documentation

**Requirement**: Create customer-facing documentation that includes:

1. **Architecture Diagram**: Show the components, network boundaries, and data flow
2. **Deployment Guide**: How to deploy from scratch (Terraform commands)
3. **Operations Runbook**:
   - How to check if ZenML is healthy
   - How to view logs
   - How to restart the service
   - How to update ZenML version
4. **Security Considerations**: Trust boundaries, where secrets are stored, network access
5. **Cost Estimate**: Expected monthly cost with one optimization recommendation

### 5. Demo Video

**Requirement**: Record a **5-7 minute Loom video** acting as if you are walking through the deployment with a customer's platform team.

In your video:

- Show the Terraform code and explain key decisions (1-2 min)
- Demonstrate the running ZenML server (1-2 min)
- Show the observability setup and how to debug issues (1-2 min)
- Discuss security and operational considerations (1-2 min)

---

## Stretch Goals (Optional)

Complete any of these for bonus points:

### A. Cloud Stack with Terraform

Use the [ZenML Terraform Provider](https://registry.terraform.io/providers/zenml-io/zenml/latest/docs) and/or the ZenML Stack Module for your cloud ([AWS](https://registry.terraform.io/modules/zenml-io/zenml-stack/aws/latest), [GCP](https://registry.terraform.io/modules/zenml-io/zenml-stack/gcp/latest), [Azure](https://registry.terraform.io/modules/zenml-io/zenml-stack/azure/latest)) to provision a complete ZenML stack:

- Cloud Artifact Store (S3, GCS, or Azure Blob)
- Container Registry (ECR, GCR/Artifact Registry, or ACR)
- Kubernetes Orchestrator (if using managed K8s)

**Deliverable**: Run a sample pipeline that uses your provisioned stack.

### B. High Availability

Configure your deployment for high availability:

- Multi-AZ database
- Multiple server replicas (if using EKS/ECS)
- Document RTO/RPO expectations

### C. GitOps

Implement GitOps for the deployment:

- Remote Terraform state with locking
- GitHub Actions for plan/apply
- ArgoCD or Flux for Helm releases (if using K8s)

### D. Remote Terraform State

Store Terraform state remotely with proper locking (S3 + DynamoDB, GCS, or Azure Blob).

---

## Tech Stack

- **Infrastructure**: Terraform + your preferred cloud (AWS, GCP, or Azure)
- **Container Orchestration**: Managed Kubernetes (EKS/GKE/AKS) with Helm, or alternative container platforms
- **MLOps**: ZenML OSS
- **Observability**: Cloud-native monitoring or Prometheus/Grafana

---

## Deliverables

Submit a private GitHub repo (fork this repo and push your changes to a new private one). Add collaborators: `htahir1`, `safoinme`, `Json-Andriopoulos`, and `stefannica`.

Your repository should contain:

1. **Terraform Code**: All infrastructure as code in `infrastructure/`, organized in modules
2. **Configuration**: Helm values, ECS task definitions, or equivalent
3. **Documentation**: As specified in Task 4 (you can overwrite this README or create a `SOLUTION.md`)
4. **Demo Video**: Link in your documentation
5. **Stretch Goals** (if attempted): Clearly marked in your repo

---

## Evaluation Criteria

We are looking for:

1. **Infrastructure Design**: Are the AWS services configured correctly and securely?
2. **Operational Readiness**: Could a platform team actually maintain this deployment?
3. **Decision Documentation**: Did you explain *why* you made certain choices?
4. **Security Awareness**: Are secrets handled properly? Is network access restricted appropriately?
5. **Customer Empathy**: Is your documentation clear for a platform team that doesn't know ZenML?
6. **"It Works"**: Can we `zenml login` to your server?

**Bonus points for**:

- Completing stretch goals
- Creative solutions (e.g., using App Runner with clear trade-off analysis)
- Thoughtful cost optimization

---

## AI Policy

AI use **is allowed**. If you use it, add a short **AI Diary** to your documentation:

- What you asked
- What you copied
- What you changed

If you didn't use AI, just write: **"No AI used."**

---

## Time Management

**Target time**: ~4-5 hours. If you get stuck:

- Stop coding
- Document what the issue is, why you think it's happening, and how you would solve it

We value the detective work and clear thinking as much as the working solution.

---

## Resources

- [ZenML Self-Hosting Documentation](https://docs.zenml.io/getting-started/deploying-zenml)
- [ZenML Helm Chart](https://artifacthub.io/packages/helm/zenml/zenml)
- [ZenML Terraform Provider](https://registry.terraform.io/providers/zenml-io/zenml/latest/docs)
- ZenML Stack Modules: [AWS](https://registry.terraform.io/modules/zenml-io/zenml-stack/aws/latest) | [GCP](https://registry.terraform.io/modules/zenml-io/zenml-stack/gcp/latest) | [Azure](https://registry.terraform.io/modules/zenml-io/zenml-stack/azure/latest)
- Cloud Best Practices: [EKS](https://aws.github.io/aws-eks-best-practices/) | [GKE](https://cloud.google.com/kubernetes-engine/docs/best-practices) | [AKS](https://learn.microsoft.com/en-us/azure/aks/best-practices)

---

**Good luck! We're excited to see how you architect infrastructure for our customers.**
