output "lambda_role_arn" {
  description = "Lambda execution role ARN"
  value       = aws_iam_role.lambda.arn

  # depends_on = [
  #   aws_iam_role_policy_attachment.lambda_basic_execution,
  #   aws_iam_role_policy.lambda_cloudwatch_metrics,
  # ]
}


output "scheduler_role_arn" {
  description = "EventBridge Scheduler execution role ARN"
  value       = aws_iam_role.scheduler.arn

  # depends_on = [
  #   aws_iam_role_policy.scheduler_invoke_lambda
  # ]
}