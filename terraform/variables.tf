
variable "aws_region" {
  description = "The AWS region to deploy all resources."
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "A unique name prefix for all project resources (e.g., tags, cluster name)."
  type        = string
  default     = "eks-pipeline"
}

# --- Networking Variables ---
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

# --- EKS & Node Variables ---
variable "instance_type" {
  description = "Instance type for the EKS worker nodes."
  type        = string
  default     = "t3.micro"
}

variable "desired_nodes" {
  description = "Desired number of worker nodes in the EKS Managed Node Group."
  type        = number
  default     = 2
}

# --- GitHub OIDC Variables ---
variable "github_repository" {
  description = "The GitHub repository (Owner/RepoName) that will assume the IAM role."
  type        = string
  # IMPORTANT: REPLACE with your actual GitHub username/repository-name
  default     = "abhisheksingh22se/eks-pipeline" 
}