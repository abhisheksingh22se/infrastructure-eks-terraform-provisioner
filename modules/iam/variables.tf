variable "role_name" {
    description = "Name of the IAM role to create"
    type = string
}

variable "environment" {
    description = "Environment (dev/prod)"
    type = string  
}

variable "oidc_provider_arn" {
    description = "ARN of the OIDC provider (from EKS module)"
    type = string
}

variable "oidc_provider_url" {
  description = "URL of the OIDC provider (from EKS module)"
  type = string
}

variable "namespace" {
  description = "Kubernetes namespace where the service account resides"
  type = string
}

variable "service_account_name" {
  description = "Name of the Kubernetes Service Account"
  type = string
}

variable "policy_json" {
  description = "JSON for a custom inline policy (optional)"
  type = string
  default = null
}

variable "managed_policy_arns" {
  description = "List of ARNs for AWS managed policies (optional)"
  type = list(string)
  default = []
}
