resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.APP_NAME}-${var.Environment}-cluster"

  tags = {
    Name        = "${var.APP_NAME}-ecs"
    Environment = var.Environment
  }
}


resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "${var.APP_NAME}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"

  execution_role_arn = aws_iam_role.execution_role.arn
  task_role_arn      = aws_iam_role.execution_role.arn

  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.APP_NAME}-${var.Environment}-container",
      "image": "${aws_ecr_repository.repository.repository_url}:latest",
      "entryPoint": [],
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "cpu": 256,
      "memory": 512,
      "networkMode": "awsvpc"
    }
  ]
DEFINITION

  tags = {
    Name        = "${var.APP_NAME}-ecs-td"
    Environment = var.Environment
  }
}

data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.ecs_task_definition.family
}


resource "aws_ecs_service" "dealver" {
  name                = "${var.APP_NAME}-${var.Environment}-service"
  cluster             = aws_ecs_cluster.ecs-cluster.id
  task_definition     = "${aws_ecs_task_definition.ecs_task_definition.family}:${max(aws_ecs_task_definition.ecs_task_definition.revision, data.aws_ecs_task_definition.main.revision)}"
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  desired_count       = 0


  network_configuration {
    subnets = [
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id
    ]
    security_groups = [
      aws_security_group.ecs.id,
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.id
    container_name   = "${var.APP_NAME}-${var.Environment}-container"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.alb_listener]
}
