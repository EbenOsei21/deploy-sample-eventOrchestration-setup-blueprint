terraform {
  required_version = "~> 1.1.1" //TODO I would put this at version 1.0.0 or higher.  Is there a specific reason why this is set to the latest and greated.
  required_providers {
    archive = {
      version = ">= 2.0"
      source  = "hashicorp/archive"
    }
  }
}
