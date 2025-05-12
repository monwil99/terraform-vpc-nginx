// Use S3 for backend to store state
terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.91.0"
        }
    }

    required_version = ">= 1.11.3"

    backend "s3" {
        region         = "us-east-1"
        use_lockfile   = true
        key            = "hnc-practicals.tfstate"
    }
}

provider "aws" {
    region  = var.region

    default_tags {
        tags = {
            Environment = var.stage
            Application = var.application
        }
    }
}