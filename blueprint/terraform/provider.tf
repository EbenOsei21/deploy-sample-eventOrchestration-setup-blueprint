terraform {
  required_version = "~> 1.1.1"
  required_providers {
    archive = {
      version = ">= 2.0"
      source  = "hashicorp/archive"
    }
  }
}
