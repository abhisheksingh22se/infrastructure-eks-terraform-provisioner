# terraform {
#   backend "s3" {
#     bucket = "abhishek-terraform-state"
#     key = eks-provisioner/dev/terraform.tfstate
#     region = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt = true
#   }
# }