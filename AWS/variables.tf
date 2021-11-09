variable "api_gateway_name" {
  description = "Name of AWS API Gateway"
  type        = string
}

variable "api_description" {
  description = "AWS API Gateway REST API description"
  type        = string
}

variable "apigw_path" {
  description = "Specify API Gateway Resource Name"
  type        = string
}

variable "apigw_method" {
  description = "AWS API Gateway Methods for Resource Customer"
  type        = list(any)
}

variable "api_auth" {
  description = "API authentication, default is NONE"
  type        = string
}

variable "api_gw_integration" {
  description = "API Gateway integration type, default is AWS (Lambda)"
  type        = string
}

variable "api_deploy_stage_name" {
  description = "API Deployment Stage Name, default is workspace name"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "lambda_funtion_name" {
  description = "AWS Lambda Function Names"
  type        = list(any)
}

variable "runtime_type" {
  description = "runtime type"
  type        = string
}

variable "s3_prefix_name" {
  description = "Prefix Name for S3 Bucket"
  type        = string
}


variable "archive_source_file" {
  description = "archive_source_file"
  type        = string
}

