resource "aws_api_gateway_rest_api" "api_gateway_rest" {
  name        = var.api_gateway_name
  description = var.api_description

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest.id
  parent_id   = aws_api_gateway_rest_api.api_gateway_rest.root_resource_id
  path_part   = var.apigw_path
}

resource "aws_api_gateway_method" "api_operation" {
  count         = length(var.apigw_method)
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_rest.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = var.apigw_method[count.index]
  authorization = var.api_auth
}
resource "aws_api_gateway_integration" "api_gateway_integration" {
  count                   = length(var.apigw_method)
  rest_api_id             = aws_api_gateway_rest_api.api_gateway_rest.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.api_operation[count.index].http_method
  type                    = var.api_gw_integration
  integration_http_method = "POST"
  uri                     = aws_lambda_function.lambda_function[count.index].invoke_arn
}

resource "aws_api_gateway_method_response" "response_200" {
  count       = length(var.apigw_method)
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_operation[count.index].http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "response_500" {
  count       = length(var.apigw_method)
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_operation[count.index].http_method
  status_code = "500"

  response_models = {
    "application/json" = "Error"
  }
}


resource "aws_api_gateway_integration_response" "integration_response_200" {
  count       = length(var.apigw_method)
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_operation[count.index].http_method
  status_code = aws_api_gateway_method_response.response_200[count.index].status_code

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_integration.api_gateway_integration
  ]
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest.id
  depends_on = [
    aws_api_gateway_method.api_operation,
    aws_api_gateway_integration.api_gateway_integration
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_account" "cloudwatch" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_rest.id
  stage_name    = var.api_deploy_stage_name
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest.id
  stage_name  = aws_api_gateway_stage.api_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = true
  }
}