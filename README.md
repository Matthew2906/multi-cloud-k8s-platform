# multi-cloud-k8s-platform
A production-grade Self-service Kubernetes platform deployed across azure (AKS) and AWS (EKS) using terraform, with GitOps-driven application delivery via ArgoCD and full observability through Prometheus and Grafana.

---

## Architecture overview

![Architecture Diagram](docs/architecture.png)

---

## tech Stack 

| Tool | Purpose |
|------|---------|
| Terraform | Infrastructure as Code for AKS and EKS provisioning |
| Azure Kubernetes Service (AKS) | Managed Kubernetes on Azure |
| AWS Elastic Kubernetes Service (EKS) | Managed Kubernetes on AWS |
| ArgoCD | GitOps continuous deployment |
| Prometheus | Metrics collection and monitoring |
| Grafana | Observability dashboards |
| Helm | Kubernetes package management |
| kubectl | Kubernetes CLI |

---

## Project Structure
```
multi-cloud-k8s-platform/
├── terraform/
│   ├── azure/          # AKS cluster configuration
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── aws/            # EKS cluster configuration
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── kubernetes/
│   ├── apps/           # Application manifests
│   └── argocd/         # ArgoCD configuration
├── pipeline/           # CI/CD pipeline definitions
└── docs/               # Architecture diagrams
```

## Prerequisites

- Terraform >= 1.0
- Azure CLI
- AWS CLI
- kubectl
- Helm >= 3.0
- Azure subscription with Contributor access
- AWS account with AdministratorAccess

---

## Getting Started

### Azure (AKS)

**1. Set environment variables:**
```bash
$env:ARM_CLIENT_ID="your-client-id"
$env:ARM_CLIENT_SECRET="your-client-secret"
$env:ARM_SUBSCRIPTION_ID="your-subscription-id"
$env:ARM_TENANT_ID="your-tenant-id"
```

**2. Deploy the AKS cluster:**
```bash
cd terraform/azure
terraform init
terraform apply
```

**3. Connect to the cluster:**
```bash
az aks get-credentials --resource-group k8s-platform-rg --name multi-cloud-k8s
kubectl get nodes
```

**4. Install ArgoCD:**
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

**5. Install Prometheus and Grafana:**
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring
```
____________________________________________________________________________________________________________________________

### AWS (EKS)

**1. Set environment variables:**
```bash
$env:AWS_ACCESS_KEY_ID="your-access-key"
$env:AWS_SECRET_ACCESS_KEY="your-secret-key"
$env:AWS_DEFAULT_REGION="us-east-1"
```

**2. Deploy the EKS cluster:**
```bash
cd terraform/aws
terraform init
terraform apply
```

**3. Connect to the cluster:**
```bash
aws eks update-kubeconfig --region us-east-1 --name multi-cloud-k8s-eks
kubectl get nodes
```

---

## GitOps Workflow

This platform uses ArgoCD for GitOps-based continuous deployment:

1. Push Kubernetes manifests to `kubernetes/apps/`
2. ArgoCD detects changes automatically
3. ArgoCD syncs the cluster to match the desired state in Git
4. No manual `kubectl apply` commands needed

---

## Observability

Prometheus and Grafana provide full cluster observability:

- **CPU and memory utilisation** across all nodes
- **Pod health and restart counts**
- **Network traffic** and request rates
- **Pre-built Kubernetes dashboards** via kube-prometheus-stack

Access Grafana dashboard:
```bash
kubectl --namespace monitoring port-forward svc/prometheus-grafana 3000:80
```
Navigate to `http://localhost:3000` (default credentials: admin/prom-operator)

---

## Security Considerations

- Service principals used for Terraform authentication
- Kubernetes RBAC enabled on all clusters
- Private node pools with NAT gateway on EKS
- Sensitive outputs marked with `sensitive = true` in Terraform
- In production: secrets managed via Azure Key Vault

---

## Cost Management

This platform is designed for cost efficiency:

- AKS control plane is free on Azure
- Minimal node sizes used (Standard_D2s_v3 / t3.medium)
- Infrastructure destroyed when not in use via `terraform destroy`
- Estimated cost for a demo session: < $0.50

---

## Author

**Matthew** | Cloud/DevOps Engineer
- GitHub: [@Matthew2906](https://github.com/Matthew2906)
- Email: rmatthew457@gmail.com
- Certifications: AZ-900, Terraform Associate