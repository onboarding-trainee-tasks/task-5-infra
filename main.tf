locals {
  metric_namespace = "Task5/WebAvailability"
  metric_name      = "Availability"

  lambda_function_name = "website-checker"

  lambda_zip_path = abspath(
    "${path.root}/${var.lambda_zip_path}"
  )

  layer_zip_path = abspath(
    "${path.root}/${var.layer_zip_path}"
  )

  site_names = [
    for site in var.sites :
    site.name
  ]
}


module "iam" {
  source = "./modules/iam"

  lambda_role_name    = "lambda-role"
  scheduler_role_name = "scheduler-role"

  lambda_function_name = local.lambda_function_name
}


module "lambda" {
  source = "./modules/lambda"

  function_name = local.lambda_function_name
  layer_name    = "requests"

  role_arn = module.iam.lambda_role_arn

  lambda_zip_path = local.lambda_zip_path
  layer_zip_path  = local.layer_zip_path

  runtime = var.lambda_runtime

  metric_namespace = local.metric_namespace
  metric_name      = local.metric_name

  log_retention_days = var.log_retention_days
}


module "scheduler" {
  source = "./modules/scheduler"

  schedule_name = "website-check"

  schedule_expression = var.schedule_expression

  lambda_function_arn = module.lambda.function_arn
  scheduler_role_arn  = module.iam.scheduler_role_arn

  sites = var.sites
}


module "monitoring" {
  source = "./modules/monitoring"

  site_names = local.site_names

  metric_namespace = local.metric_namespace
  metric_name      = local.metric_name

  lambda_function_name = module.lambda.function_name

  sns_topic_arn = var.sns_topic_arn

  period_seconds = var.alarm_period_seconds

  initial_failure_periods = var.initial_failure_periods

  reminder_failure_periods = var.reminder_failure_periods
}