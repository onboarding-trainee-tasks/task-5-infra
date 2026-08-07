output "unavailable_alarm_names" {
  value = {
    for site_name, alarm in aws_cloudwatch_metric_alarm.site_unavailable :
    site_name => alarm.alarm_name
  }
}

output "reminder_alarm_names" {
  value = {
    for site_name, alarm in aws_cloudwatch_metric_alarm.site_still_unavailable :
    site_name => alarm.alarm_name
  }
}

output "lambda_errors_alarm_name" {
  value = aws_cloudwatch_metric_alarm.lambda_errors.alarm_name
}