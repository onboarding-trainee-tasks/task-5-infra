variable "sites" {
  description = "List of websites checked by Lambda"

  type = list(object({
    name = string
    url  = string
  }))

  default = [
    {
      name = "google"
      url  = "https://google.com"
    },
    {
      name = "github"
      url  = "https://github.com"
    },
    {
      name = "coinops"
      url  = "https://coinops-d.pp.ua"
    }
  ]

  validation {
    condition     = length(var.sites) > 0
    error_message = "At least one site must be configured."
  }
}

variable "sns_topic_arn" {
  description = "ARN of the existing SNS Topic"
  type        = string
  default     = "arn:aws:sns:eu-central-1:583955898731:task-2-alerts"
}

variable "lambda_zip_path" {
  description = "Path to lambda-function.zip"
  type        = string
  default     = "../task-5-lambda/dist/lambda-function.zip"
}

variable "layer_zip_path" {
  description = "Path to requests-layer.zip"
  type        = string
  default     = "../task-5-lambda/dist/requests-layer.zip"
}

variable "lambda_runtime" {
  description = "Lambda Python runtime"
  type        = string
  default     = "python3.14"
}

variable "schedule_expression" {
  description = "EventBridge Scheduler expression"
  type        = string
  default     = "cron(0/5 * * * ? *)"
}

variable "alarm_period_seconds" {
  description = "CloudWatch alarm period"
  type        = number
  default     = 300
}

variable "initial_failure_periods" {
  description = "Failures required for initial notification"
  type        = number
  default     = 3
}

variable "reminder_failure_periods" {
  description = "Failures required for reminder notification"
  type        = number
  default     = 5
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention"
  type        = number
  default     = 14
}