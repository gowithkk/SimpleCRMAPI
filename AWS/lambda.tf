resource "aws_lambda_function" "lambda_function" {
  count            = length(var.lambda_funtion_name)
  function_name    = var.lambda_funtion_name[count.index]
  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_bucket_object.lambda_object[count.index].key
  runtime          = var.runtime_type
  handler          = "${var.lambda_funtion_name[count.index]}.lambda_handler"
  source_code_hash = data.archive_file.zip_lambda[count.index].output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
}


resource "aws_lambda_permission" "api_gw" {
  count         = length(var.lambda_funtion_name)
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function[count.index].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_gateway_rest.execution_arn}/*/*"
}
