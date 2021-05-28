terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.42.0"
    }
    github = {
      source = "integrations/github"
      version = "~> 4.10.1"
    }
  }
}
provider "aws" {
  region = var.region_name
  # Update this to point to your own AWS credentials as need be.
  shared_credentials_file = "~/.aws/credentials"
}

provider "github" {
  token = var.GitHub_Token
}
