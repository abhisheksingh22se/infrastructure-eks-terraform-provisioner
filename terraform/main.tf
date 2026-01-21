provider "aws" {
    region = "us-east-2"
}

resource "aws_s3_bucket" "test_bucket" {
    bucket = "terraform-test-2209sep"
}