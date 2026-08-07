variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "layer_name" {
  description = "Lambda Layer name"
  type        = string
}

variable "role_arn" {
  description = "Lambda execution role ARN"
  type        = string
}

variable "lambda_zip_path" {
  description = "Path to Lambda ZIP"
  type        = string
}

variable "layer_zip_path" {
  description = "Path to Layer ZIP"
  type        = string
}

variable "runtime" {
  description = "Lambda Python runtime"
  type        = string
}

variable "metric_namespace" {
  description = "CloudWatch metric namespace"
  type        = string
}

variable "metric_name" {
  description = "CloudWatch metric name"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention"
  type        = number
}