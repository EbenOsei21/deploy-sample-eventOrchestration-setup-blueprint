resource "aws_lambda_function" "lambda_function" {
  function_name    = "${local.resource_name_prefix}-lambda"
  description      = "Lambda to generate a random number"
  filename         = var.lambda_zip_file
  handler          = "main"
  source_code_hash = var.lambda_zip_file
  role             = aws_iam_role.lambda_execution_role.arn
  runtime          = local.go_runtime
  timeout          = local.lambda_timeout
}
