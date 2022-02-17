resource "aws_lambda_function" "lambda_function" {
  function_name    = "${local.resource_name_prefix}-lambda"
  description      = "Lambda to save payment information in a s3 bucket"
  filename         = var.lambda_zip_file
  handler          = "main"
  source_code_hash = var.lambda_source_code_hash
  role             = aws_iam_role.lambda_execution_role.arn
  runtime          = local.go_runtime
  timeout          = local.lambda_timeout
  depends_on       = [aws_s3_bucket.paymentdata_bucket]

  environment {
    variables = {
      REGION = var.aws_region               
	    BUCKET_NAME = var.bucket_name
    }
  }
}

resource "aws_s3_bucket" "paymentdata_bucket" {
  bucket = var.bucket_name
  acl    = "private"     

  tags = {
    Name        = var.bucket_tag
    Environment = var.environment
  }
  force_destroy = true
}


