resource "aws_security_group" "ecr_security_group" {
  vpc_id      = aws_vpc.ecr_vpc.id
  name        = "ecr-security-group"
  description = "ECR Security Group"
}
