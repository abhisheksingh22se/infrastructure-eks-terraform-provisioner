variable "aws_region" {
  description = "AWS Region to deploy to"
  type = string
  default = "us-east-2"
}

variable "project_name" {
  description = "Project Name"
  type = string
  default = "eks-infra"
}