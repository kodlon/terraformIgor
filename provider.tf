terraform {
  backend "s3" {
    dynamodb_table = "terraform-tfstate-lock"
    bucket         = "413022807861-terraform-tfstate"
    key            = "dev/terraform.tfstate"
    region         = "eu-central-1"
  }
  required_version = "~> 0.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.29.1"
    }
  }
}



provider "aws" {
  region = "eu-central-1"
}
