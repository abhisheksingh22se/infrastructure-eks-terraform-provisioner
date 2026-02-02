# AWS IAM IRSA Module

This module abstracts the complexity of creating **IAM Roles for Service Accounts (IRSA)**. It allows you to create fine-grained IAM roles that trust specific Kubernetes Service Accounts via OIDC.

## Features

* **Dynamic Trust Policy:** Automatically generates the AssumeRole policy based on the OIDC provider, Namespace, and Service Account name.
* **Flexible Permissions:** Supports attaching both AWS Managed Policies (e.g., `AmazonS3ReadOnlyAccess`) and custom Inline Policies.
* **Least Privilege:** Ensures that only the specific pod associated with the Service Account can assume the role.

## Usage

```hcl
module "s3_read_role" {
  source = "../../modules/iam"

  role_name            = "s3-reader-role"
  environment          = "dev"
  
  # OIDC info from EKS module
  oidc_provider_arn    = module.eks.oidc_provider_arn
  oidc_provider_url    = module.eks.oidc_provider_url
  
  # Kubernetes binding
  namespace            = "default"
  service_account_name = "s3-reader-sa"
  
  # Permissions
  managed_policy_arns  = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| `role_name` | Name of the IAM role | `string` | yes |
| `oidc_provider_arn` | ARN of the OIDC Provider | `string` | yes |
| `oidc_provider_url` | URL of the OIDC Provider | `string` | yes |
| `namespace` | K8s namespace for the Service Account | `string` | yes |
| `service_account_name` | K8s Service Account name | `string` | yes |
| `managed_policy_arns` | List of AWS Managed Policy ARNs | `list(string)` | no |
| `policy_json` | Custom JSON policy | `string` | no |

## Outputs

| Name | Description |
|------|-------------|
| `role_arn` | The ARN of the created IAM role (Use in K8s SA annotation) |