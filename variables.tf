variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
}

variable "lambda_funtion_name" {
  description = "AWS Lambda Function Names"
  type        = list(any)
}

variable "apigw_method" {
  description = "AWS API Gateway Methods for Resource Customer"
  type        = list(any)
}

variable "api_description" {
  description = "AWS API Gateway REST API description"
  type        = string
}

variable "api_auth" {
  description = "API authentication, default is NONE"
  type        = string
}

variable "api_gw_integration" {
  description = "API Gateway integration type, default is AWS (Lambda)"
  type        = string
}

variable "apigw_path" {
  description = "Specify API Gateway Resource Name"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of DynamoDB table"
  type        = string
}

variable "s3_prefix_name" {
  description = "Prefix Name for S3 Bucket"
  type        = string
}

variable "api_gateway_name" {
  description = "Name of AWS API Gateway"
  type        = string
}
