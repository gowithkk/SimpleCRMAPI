output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value       = module.AWS.s3_bucket_name
}

output "api_deployment_url" {
  description = "Deployment API URL"
  value       = "${module.AWS.api_deployment_url}/${var.apigw_path}"
}