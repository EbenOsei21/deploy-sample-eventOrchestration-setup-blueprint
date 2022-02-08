terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" #TODO Make sure you document this value in the index.md because a customer downloading this might be in another AWS region and having this undocumented would be bad.
}
