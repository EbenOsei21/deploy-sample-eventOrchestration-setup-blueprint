data "archive_file" "saveUserData_lambda_zip" {
  type        = "zip"
  source_file = "${local.saveUserData_lambda_zip_dir}/main"
  output_path = "${local.saveUserData_lambda_zip_dir}/function.zip"
}

data "archive_file" "paymentId_lambda_zip" {
  type        = "zip"
  source_file = "${local.paymentId_lambda_zip_dir}/main"
  output_path = "${local.paymentId_lambda_zip_dir}/function.zip"
}