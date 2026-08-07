resource "aws_cloudwatch_metric_alarm" "site_unavailable" {
  for_each = toset(var.site_names)

  alarm_name = (
    "${each.value}-unavailable"
  )

  alarm_description = (
    "${each.value} failed three consecutive checks"
  )

  namespace   = var.metric_namespace
  metric_name = var.metric_name

  dimensions = {
    SiteName = each.value
  }

  statistic = "Minimum"
  period    = var.period_seconds

  evaluation_periods  = var.initial_failure_periods
  datapoints_to_alarm = var.initial_failure_periods

  threshold           = 1
  comparison_operator = "LessThanThreshold"

  treat_missing_data = "missing"

  alarm_actions = [
    var.sns_topic_arn
  ]

  ok_actions = [
    var.sns_topic_arn
  ]
}


resource "aws_cloudwatch_metric_alarm" "site_still_unavailable" {
  for_each = toset(var.site_names)

  alarm_name = (
    "${each.value}-still-unavailable"
  )

  alarm_description = (
    "${each.value} is still unavailable"
  )

  namespace   = var.metric_namespace
  metric_name = var.metric_name

  dimensions = {
    SiteName = each.value
  }

  statistic = "Minimum"
  period    = var.period_seconds

  evaluation_periods  = var.reminder_failure_periods
  datapoints_to_alarm = var.reminder_failure_periods

  threshold           = 1
  comparison_operator = "LessThanThreshold"

  treat_missing_data = "missing"

  alarm_actions = [
    var.sns_topic_arn
  ]
}


resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name = "lambda-errors"

  alarm_description = (
    "Website checker Lambda execution failed"
  )

  namespace   = "AWS/Lambda"
  metric_name = "Errors"

  dimensions = {
    FunctionName = var.lambda_function_name
  }

  statistic = "Sum"
  period    = var.period_seconds

  evaluation_periods  = 1
  datapoints_to_alarm = 1

  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"

  treat_missing_data = "notBreaching"

  alarm_actions = [
    var.sns_topic_arn
  ]
}