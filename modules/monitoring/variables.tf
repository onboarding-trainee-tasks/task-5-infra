variable "site_names" {
  description = "Names of monitored websites"
  type        = list(string)
}

variable "metric_namespace" {
  description = "CloudWatch metric namespace"
  type        = string
}

variable "metric_name" {
  description = "CloudWatch metric name"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
}

variable "sns_topic_arn" {
  description = "Existing SNS Topic ARN"
  type        = string
}

variable "period_seconds" {
  description = "CloudWatch alarm period"
  type        = number
}

variable "initial_failure_periods" {
  description = "Periods before first notification"
  type        = number
}

variable "reminder_failure_periods" {
  description = "Periods before reminder notification"
  type        = number
}