terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "eks-pipeline-abhi22"   
    key            = "eks-pipeline/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"                   
    encrypt        = true
  }
}
