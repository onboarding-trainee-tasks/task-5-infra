data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  lambda_function_arn = "arn:aws:lambda:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:function:${var.lambda_function_name}"
}

# Lambda IAM role
resource "aws_iam_role" "lambda" {
  name        = var.lambda_role_name
  description = "Execution role for website checker Lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role_policy" "lambda_cloudwatch_metrics" {
  name = "${var.lambda_role_name}-cloudwatch-metrics"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "cloudwatch:PutMetricData"
        ]

        Resource = "*"
      }
    ]
  })
}

# EventBridge Scheduler IAM role
resource "aws_iam_role" "scheduler" {
  name        = var.scheduler_role_name
  description = "Allows EventBridge Scheduler to invoke Lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "scheduler.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy" "scheduler_invoke_lambda" {
  name = "${var.scheduler_role_name}-invoke-lambda"
  role = aws_iam_role.scheduler.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "lambda:InvokeFunction"
        ]

        Resource = local.lambda_function_arn
      }
    ]
  })
}