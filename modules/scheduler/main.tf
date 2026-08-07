resource "aws_scheduler_schedule" "checker" {
  name        = var.schedule_name
  description = "Runs website availability checks"
  group_name  = "default"
  state       = "ENABLED"

  schedule_expression          = var.schedule_expression
  schedule_expression_timezone = "UTC"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = var.lambda_function_arn
    role_arn = var.scheduler_role_arn

    input = jsonencode({
      sites = var.sites
    })
  }
}