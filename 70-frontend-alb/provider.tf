terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }

  backend "s3" {
    bucket       = "roboshop-cart-remote-state"
    key          = "roboshop-vpc-dev-frontend-alb"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}


provider "aws" {
  # Configuration options
  region = "us-east-1"
}

