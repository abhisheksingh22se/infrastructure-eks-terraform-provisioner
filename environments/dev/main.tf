provider "aws" {
  region = var.aws_region
}

#1 Calling the VPC module
module "vpc" {
    source = "../../modules/vpc"

    project_name = var.project_name
    environment = "dev"
    vpc_cidr = "10.0.0.0/16"
    public_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
    availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
}

#2 Calling the EKS module
module "eks" {
  source = "../../modules/eks"

  project_name = var.project_name
  k8s_version = "1.30"

  #Chaining VPC module outputs to EKS module inputs
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  node_desired_size = 2
  node_max_size = 3
  node_min_size = 1
  node_instance_types = ["t3.medium"]
}

#3 IRSA Implementatiion (Example) 
module "s3_read_role" {
  source = "../../modules/iam"

  role_name = "${var.project_name}-s3-reader-role"
  environment = "dev"

  #Chaining OIDC provider from EKS module
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url

  #This ties the role to a specific K8s Service Account
  namespace = "default"
  service_account_name = "s3-reader-sa"

  #Granting Read-Only S3 access
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
}