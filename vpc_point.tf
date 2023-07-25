resource "aws_vpc_endpoint" "ecr-dkr" {
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${var.AWS_REGION}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  subnet_ids          = [aws_subnet.egress_subnet_1.id, aws_subnet.egress_sunbet_2.id]

  tags = {
    Name        = "${var.APP_NAME}-ecr-dkr-endpoint"
    Environment = var.Environment
  }
}


resource "aws_vpc_endpoint" "ecr-api" {
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${var.AWS_REGION}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  subnet_ids          = [aws_subnet.egress_subnet_1.id, aws_subnet.egress_sunbet_2.id]

  tags = {
    Name        = "${var.APP_NAME}-ecr-api-endpoint"
    Environment = var.Environment
  }
}


resource "aws_vpc_endpoint" "s3" {
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${var.AWS_REGION}.s3"
  vpc_endpoint_type   = "Gateway"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  subnet_ids          = [aws_subnet.egress_subnet_1.id, aws_subnet.egress_sunbet_2.id]

  tags = {
    Name        = "${var.APP_NAME}-s3-endpoint"
    Environment = var.Environment
  }

}

resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${var.AWS_REGION}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  subnet_ids          = [aws_subnet.egress_subnet_1.id, aws_subnet.egress_sunbet_2.id]

  tags = {
    Name        = "${var.APP_NAME}-cloudwatch-endpoint"
    Environment = var.Environment
  }
}
