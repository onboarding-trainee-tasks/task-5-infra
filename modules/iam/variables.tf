variable "lambda_role_name" {
  description = "IAM role name for Lambda"
  type        = string
}

variable "scheduler_role_name" {
  description = "IAM role name for EventBridge Scheduler"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
}