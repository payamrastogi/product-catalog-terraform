terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
        }
    }

    backend "s3" {
        bucket = "blocs-terraform-backend"
        key    = "state/terraform_state.tfstate"
        region = "us-east-1"
    }

    required_version = "~> 1.0"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  shared_credentials_files = ["$HOME/.aws/credentials"]
}