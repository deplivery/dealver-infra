resource "aws_lb" "ecr_alb" {
  name               = "ecr-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.ecr_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ecr_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "ecr_target_group" {
  name     = "ecr-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ecr_vpc.id
}
