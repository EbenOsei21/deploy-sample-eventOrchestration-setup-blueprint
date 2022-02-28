variable "organizationId" {
  type        = string
  description = "Genesys Cloud Organization Id"
}

variable "aws_region" {
  type        = string
  description = "Aws region where the resources to be provisioned."
}

variable "environment" {
  type        = string
  description = "Name of the environment, e.g., dev, test, stable, staging, uat, prod etc."
}

variable "saveData_prefix" {
  type        = string
  description = "A name that is to be used as the lambda's(and related resources) name prefix. Helps with identificaiton of resources"
}

variable "generatePaymentId_prefix" {
  type        = string
  description = "A name that is to be used as the lambda's(and related resources) name prefix. Helps with identificaiton of resources"
}

variable "bucket_name"{
  type = string
  description = "Name of the s3 bucket"
}

variable "bucket_tag" {
  type = string
  description = "Tag to assign to s3 bucket"
}

variable "IVR_start_number"{
  type = string
  description = "Starting phone number of the DID Pool range"
}

variable "IVR_end_number"{
  type = string
  description = "Ending phone number of the DID Pool range"
}
