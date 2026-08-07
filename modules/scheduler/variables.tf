variable "schedule_name" {
  description = "EventBridge Scheduler name"
  type        = string
}

variable "schedule_expression" {
  description = "EventBridge Scheduler expression"
  type        = string
}

variable "lambda_function_arn" {
  description = "Target Lambda ARN"
  type        = string
}

variable "scheduler_role_arn" {
  description = "IAM role ARN used by EventBridge Scheduler"
  type        = string
}

variable "sites" {
  description = "Sites passed to Lambda"

  type = list(object({
    name = string
    url  = string
  }))
}