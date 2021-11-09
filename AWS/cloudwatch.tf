resource "aws_cloudwatch_metric_alarm" "consumed_read_units" {
  alarm_name                = "dynamodb_${var.dynamodb_table_name}_consumed_read_units"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "5"
  metric_name               = "ConsumedReadCapacityUnits"
  namespace                 = "AWS/DynamoDB"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "1000"
  alarm_description         = "This metric monitors DynamoDB ConsumedReadCapacityUnits for ${var.dynamodb_table_name}."
  insufficient_data_actions = []

  dimensions = {
    TableName = "${var.dynamodb_table_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_all_function_errors" {
  alarm_name                = "lambda_all_function_errors"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "Errors"
  namespace                 = "AWS/Lambda"
  period                    = "60"
  statistic                 = "Maximum"
  unit                      = "Count"
  threshold                 = "0"
  alarm_description         = "This metric monitors all Lambda errors."
  insufficient_data_actions = []
}