# AWS EKS Module

This module provisions the Control Plane and Data Plane (Worker Nodes) for an Amazon EKS cluster. It enforces security best practices by disabling public access to worker nodes.

## Features

* **Control Plane:** Provisions an EKS cluster with public endpoint access (for kubectl) and private endpoint access (for nodes).
* **Managed Node Groups:** Deploys worker nodes into **Private Subnets** only.
* **OIDC Integration:** Enables the OIDC Identity Provider to support IAM Roles for Service Accounts (IRSA).
* **IAM Roles:** Automatically creates the Cluster Role and Node Role with strict policies.

## Usage

```hcl
module "eks" {
  source = "../../modules/eks"

  project_name       = "my-project"
  k8s_version        = "1.30"
  public_subnet_ids  = ["subnet-abc", "subnet-def"]
  private_subnet_ids = ["subnet-123", "subnet-456"]
  
  node_desired_size   = 2
  node_max_size       = 3
  node_min_size       = 1
  node_instance_types = ["t3.medium"]
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|:-------:|
| `project_name` | Project name for tagging | `string` | - |
| `k8s_version` | Kubernetes version | `string` | `1.30` |
| `public_subnet_ids` | Subnets for Load Balancers | `list(string)` | - |
| `private_subnet_ids` | Subnets for Worker Nodes | `list(string)` | - |
| `node_desired_size` | Desired worker nodes | `number` | `2` |
| `node_instance_types` | EC2 instance types | `list(string)` | `["t3.medium"]` |

## Outputs

| Name | Description |
|------|-------------|
| `cluster_name` | Name of the EKS cluster |
| `cluster_endpoint` | Endpoint for the Kubernetes API server |
| `oidc_provider_arn` | ARN of the OIDC Provider (Required for IRSA) |
| `oidc_provider_url` | URL of the OIDC Provider |