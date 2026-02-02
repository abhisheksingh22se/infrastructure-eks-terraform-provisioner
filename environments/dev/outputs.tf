output "configure_kubectl" {
  description = "Command to update your local kubeconfig"
  value = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

output "test_irsa_arn" {
  description = "ARN of the S3 Reader Role"
  value = module.s3_read_role.role_arn
}