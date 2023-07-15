resource "aws_ecr_repository" "repository" {
  name = "${var.APP_NAME}-${var.Environment}-ecr"

  tags = {
    Name        = "${var.APP_NAME}-ecr"
    Environment = var.Environment
  }
}
