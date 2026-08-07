resource "aws_lambda_layer_version" "requests" {
  layer_name = var.layer_name

  filename         = var.layer_zip_path
  source_code_hash = filebase64sha256(var.layer_zip_path)

  compatible_runtimes = [
    var.runtime
  ]

  compatible_architectures = [
    "x86_64"
  ]

  description = "Requests library for website checker"
}

resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${var.function_name}"

  retention_in_days = var.log_retention_days
}

resource "aws_lambda_function" "checker" {
  function_name = var.function_name

  description = (
    "Checks HTTP availability of multiple websites"
  )

  role    = var.role_arn
  handler = "lambda_function.lambda_handler"
  runtime = var.runtime

  architectures = [
    "x86_64"
  ]

  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  layers = [
    aws_lambda_layer_version.requests.arn
  ]

  memory_size = 128

  timeout = 60

  environment {
    variables = {
      METRIC_NAMESPACE = var.metric_namespace
      METRIC_NAME      = var.metric_name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda
  ]
}