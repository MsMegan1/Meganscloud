terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

# Asks AWS "who am I?" (equivalent to 'aws sts get-caller-identity')
data "aws_caller_identity" "me" {}

variable "your_name" {
  type        = string
  description = "Your name or identifier to ensure the bucket name is unique"
}

resource "aws_s3_bucket" "first" {
  # Bucket names must be globally unique across all of AWS
  bucket = "thrive-${var.your_name}-${data.aws_caller_identity.me.account_id}"
}

output "bucket_name" {
  value = aws_s3_bucket.first.bucket
}
resource "aws_s3_bucket_versioning" "first" {
  bucket = aws_s3_bucket.first.id

  versioning_configuration {
    status = "Enabled"
  }
}