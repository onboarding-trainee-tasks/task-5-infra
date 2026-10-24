# Onboarding Task 5 - Lambda Monitoring Infrastructure

This repository provisions the infrastructure for a scheduled website availability checker. The Lambda code and packaging script are stored in the separate `task-5-lambda` repository.

## Implementation Features

- AWS Lambda with a Python runtime and a `requests` Lambda Layer
- Amazon EventBridge Scheduler invoking Lambda every 5 minutes by default
- Custom CloudWatch availability metrics per website (`SiteName` dimension)
- CloudWatch alarms for initial unavailability, longer unavailability, and Lambda execution errors
- Amazon SNS notifications through an existing SNS topic
- GitHub Actions for Terraform plan on pull requests and deployment on pushes to `main` or manual dispatch
- GitHub OIDC authentication to AWS (no static AWS access keys required for the Terraform workflow)

## External Dependencies

1. **AWS access and Terraform backend**

   Configure AWS credentials for local Terraform use. The existing S3 backend is:

   ```text
   Bucket: tf-backend-task-4
   Region: eu-central-1
   State key: infra/state
   ```

2. **Existing SNS topic**

   Set `sns_topic_arn` to the topic used for CloudWatch notifications. Configure and confirm an SNS subscription if email alerts are required.

3. **Lambda ZIP packages**

   Clone `task-5-lambda` alongside this repository and run its `build.sh`. Terraform expects:

   ```text
   ../task-5-lambda/dist/lambda-function.zip
   ../task-5-lambda/dist/requests-layer.zip
   ```

4. **Website configuration**

   The monitored websites are specified in `sites.auto.tfvars` and automatically loaded by Terraform. Change this file to update the site list.

5. **GitHub Actions configuration**

   Infrastructure repository variables: `AWS_ROLE_ARN`, `AWS_REGION`, `AWS_ACCOUNT_ID`, `LAMBDA_REPOSITORY`.

   Configure a GitHub OIDC-trusted AWS role and the `T5-deploy` GitHub Environment according to your deployment approval policy.

   The Lambda repository additionally requires `INFRA_REPOSITORY` and `INFRA_WORKFLOW_TOKEN` to dispatch the infrastructure workflow.

## How to run locally

Keep the repositories in sibling directories:

```bash
cd ../task-5-lambda
bash build.sh

cd ../task-5-infra
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
```

Review the plan before applying changes:

```bash
terraform apply
```

The ZIP files must exist before `terraform plan`; `filebase64sha256` reads them from disk.

## Monitoring and notifications

- Metric namespace: `Task5/WebAvailability`
- Metric name: `Availability` (1 = HTTP 2xx, 0 = failure)
- Default schedule: every 5 minutes
- Initial availability alarm: 3 consecutive breaching evaluation periods
- Longer-unavailability alarm: 5 consecutive breaching evaluation periods
- Lambda error alarm: a failed Lambda execution in a monitoring period

CloudWatch alarm actions are sent on state changes. The longer-unavailability alarm provides a later notification, not repeating reminders while the alarm remains active.

## GitHub Actions

- Pull request to `main`: build Lambda ZIP packages, validate Terraform, run `terraform plan`
- Push to `main`: create a plan and apply it
- `workflow_dispatch`: deploy with a selected Lambda branch, tag, or commit SHA (`lambda_ref`)

A successful dispatch in the Lambda repository does not by itself confirm a successful Terraform apply. Check the infrastructure workflow execution and the AWS resources after deployment.
