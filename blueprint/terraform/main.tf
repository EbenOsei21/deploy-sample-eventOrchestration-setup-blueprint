
/*
Responsible for deploying the lambda, creating its IAM Role and IAM Policy. This module also creates the trusted role and policy that
is used by Genesys Cloud to invoke the lambda in
*/
module "lambda_saveUserData" {
  source                  = "./modules/saveUserData_lambda"
  environment             = "dev"
  prefix                  = "saveUserData"
  organizationId          = "8d6f6281-c096-4dab-b194-a6f1667d7dd4"
  aws_region              = "us-east-1"
  lambda_zip_file         = data.archive_file.saveUserData_lambda_zip.output_path
  lambda_source_code_hash = data.archive_file.saveUserData_lambda_zip.output_base64sha256
}

/*
Responsible for deploying the lambda, creating its IAM Role and IAM Policy. This module also creates the trusted role and policy that
is used by Genesys Cloud to invoke the lambda in
*/
module "lambda_generate_paymentId" {
  source                  = "./modules/paymentIdGenerator_lambda"
  environment             = "dev"
  prefix                  = "generate_paymentId"
  organizationId          = "8d6f6281-c096-4dab-b194-a6f1667d7dd4"
  aws_region              = "us-east-1"
  lambda_zip_file         = data.archive_file.paymentId_lambda_zip.output_path
  lambda_source_code_hash = data.archive_file.paymentId_lambda_zip.output_base64sha256
}


/*
   This module creates a data integration for the lambda.  The module will create the credentials and in the integration.
*/
module "saveUserData_lambda_data_integration" {
  source                            = "git::https://github.com/GenesysCloudDevOps/integration-lambda-module.git?ref=main"
  environment                       = "dev"
  prefix                            = "saveUserData"
  data_integration_trusted_role_arn = module.lambda_saveUserData.data_integration_trusted_role_arn
}

module "paymentId_generator_lambda_data_integration" {
  source                            = "git::https://github.com/GenesysCloudDevOps/integration-lambda-module.git?ref=main"
  environment                       = "dev"
  prefix                            = "generate_paymentId"
  data_integration_trusted_role_arn = module.lambda_generate_paymentId.data_integration_trusted_role_arn
}

/*
   Setups a data action that will invoke a lambda
*/
module "saveUserData_lambda_data_action" {
  source                 = "git::https://github.com/GenesysCloudDevOps/data-action-lambda-module.git?ref=main"
  environment            = "dev"
  prefix                 = "save_user_data"
  secure_data_action     = false
  genesys_integration_id = module.saveUserData_lambda_data_integration.genesys_integration_id
  lambda_arn             = module.lambda_saveUserData.lambda_arn
  data_action_input      = file("${path.module}/contracts/save_user_data_action_contracts/data-action-input.json")
  data_action_output     = file("${path.module}/contracts/save_user_data_action_contracts/data-action-output.json")
}


module "paymentID_lambda_data_action" {
  source                 = "git::https://github.com/GenesysCloudDevOps/data-action-lambda-module.git?ref=main"
  environment            = "dev"
  prefix                 = "generate_paymentId"
  secure_data_action     = false
  genesys_integration_id = module.paymentId_generator_lambda_data_integration.genesys_integration_id
  lambda_arn             = module.lambda_generate_paymentId.lambda_arn
  data_action_input      = file("${path.module}/contracts/paymentId_generator_dataaction_contracts/data-action-input.json")
  data_action_output     = file("${path.module}/contracts/paymentId_generator_dataaction_contracts/data-action-output.json")
}