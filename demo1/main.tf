terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.6.3"
}

provider "aws" {
  region                   = var.aws_region
  shared_config_files      = [var.config_location]
  shared_credentials_files = [var.creds_location]
  profile                  = var.profile
}
