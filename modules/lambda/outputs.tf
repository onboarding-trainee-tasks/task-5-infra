output "function_name" {
  value = aws_lambda_function.checker.function_name
}

output "function_arn" {
  value = aws_lambda_function.checker.arn
}

output "layer_arn" {
  value = aws_lambda_layer_version.requests.arn
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.lambda.name
}