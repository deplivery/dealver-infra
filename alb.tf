resource "aws_lb" "alb" {
  name               = "${var.APP_NAME}-${var.Environment}-alb"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subent_2.id
  ]
  security_groups = [aws_security_group.lb.id]


  tags = {
    Name        = "${var.APP_NAME}-alb"
    Environment = var.Environment
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}

resource "aws_lb_target_group" "ecs_target_group" {
  name        = "${var.APP_NAME}-${var.Environment}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.APP_NAME}-lb-tg"
    Environment = var.Environment
  }

}
