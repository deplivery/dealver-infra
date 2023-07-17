resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.APP_NAME}-log-group"
  retention_in_days = null # 만기 없음
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "${var.APP_NAME}-log-stream"  # 로그 스트림 이름을 원하는 대로 변경하세요.
  log_group_name = aws_cloudwatch_log_group.log_group.name
}
