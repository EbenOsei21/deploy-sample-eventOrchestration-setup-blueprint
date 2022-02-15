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
  description = "save user data lambda prefix"
}

variable "generatePaymentId_prefix" {
  type        = string
  description = "Payment Id generator lambda prefix"
}

variable "bucket_name"{
  type = string
  description = "Name of the s3 bucket"
}

variable "bucket_tag" {
  type = string
  description = "S3 bucket tag"
}