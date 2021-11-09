output "s3_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value       = aws_s3_bucket.lambda_bucket.id
}

output "api_deployment_url" {
  description = "Deployment API URL"
  value       = aws_api_gateway_stage.api_stage.invoke_url
}