# AWS VPC Module

This module provisions a network topology optimized for Amazon EKS. It implements a strict public/private subnet isolation strategy required for secure Kubernetes clusters.

## Features

* **Network Isolation:** Creates a VPC with distinct Public and Private subnets.
* **NAT Gateway:** Configures a single NAT Gateway (for cost efficiency) to allow private subnets outbound internet access.
* **EKS Tagging:** Automatically applies `kubernetes.io/role/elb` and `kubernetes.io/role/internal-elb` tags required by the AWS Load Balancer Controller.
* **Route Tables:** Automatically associates subnets with the correct routing logic (IGW vs NAT).

## Usage

```hcl
module "vpc" {
  source = "../../modules/vpc"

  project_name         = "my-project"
  environment          = "dev"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| `project_name` | Name used for resource tagging | `string` | yes |
| `environment` | Environment name (e.g., dev, prod) | `string` | yes |
| `vpc_cidr` | The CIDR block for the VPC | `string` | yes |
| `public_subnet_cidrs` | List of CIDRs for public subnets | `list(string)` | yes |
| `private_subnet_cidrs` | List of CIDRs for private subnets | `list(string)` | yes |
| `availability_zones` | List of AZs to deploy into | `list(string)` | yes |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | The ID of the created VPC |
| `private_subnet_ids` | List of private subnet IDs (for Worker Nodes) |
| `public_subnet_ids` | List of public subnet IDs (for Load Balancers) |