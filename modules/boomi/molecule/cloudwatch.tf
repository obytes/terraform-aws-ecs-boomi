resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${local.prefix}"
  retention_in_days = 30

  tags = local.common_tags
}

## Log Group for CW Agent sidecar container
resource "aws_cloudwatch_log_group" "cwa" {
  name              = "/aws/ecs/${local.prefix}-cw-logs"
  retention_in_days = 7

  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "boomi_log_files" {
  name              = "${local.prefix}-log-files"
  retention_in_days = 30

  tags = local.common_tags
}

resource "aws_cloudwatch_log_metric_filter" "boomi_metric_filter_error_401" {
  log_group_name = aws_cloudwatch_log_group.boomi_log_files.name
  name = "${aws_cloudwatch_log_group.boomi_log_files.name}-filter"
  pattern = "{$.Error = 401}"
  metric_transformation {
    name = "Error401"
    namespace = "BOOMI_METRIC"
    value = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "boomi_metric_alarm_http_401" {
  alarm_name = "${local.prefix}-boomi-http-401"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 1
  metric_name = aws_cloudwatch_log_metric_filter.boomi_metric_filter_error_401.metric_transformation[0].name
  namespace = "BOOMI_METRIC"
  period = 60
  statistic = "Average"
  threshold = 0
  datapoints_to_alarm = 1
  alarm_description = "Alarm to be triggered if the number of HTTP_401 is greater than 0 for the last minute"
  treat_missing_data = "missing"
  alarm_actions = [aws_sns_topic.cloudwatch_alarms.arn]
  tags = local.common_tags
}