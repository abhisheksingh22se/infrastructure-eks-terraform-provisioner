output "configure_kubectl" {
  description = "Command to update your local kubeconfig"
  value = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

output "test_irsa_arn" {
  description = "ARN of the S3 Reader Role"
  value = module.s3_read_role.role_arn
}

output "cluster_name" {
  description = "The name of the EKS cluster (Use this for Project B)"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API"
  value       = module.eks.cluster_endpoint
}