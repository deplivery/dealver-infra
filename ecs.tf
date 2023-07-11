resource "aws_ecs_cluster" "ecs-cluster" {
  name = "ecs-cluster"
}


resource "aws_ecs_task_definition" "ecr_task_definition" {
  family                   = "ecr-task-definition-family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.execution_role.arn

  container_definitions = <<DEFINITION
[
  {
    "name": "ecr-container",
    "image": "${aws_ecr_repository.ecr-repository.repository_url}:latest",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ],
    "cpu": 256,
    "memory": 512
  }
]
DEFINITION
}


resource "aws_ecs_service" "dealver" {
  name            = "dealver"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.ecr_task_definition.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.private_subnet_1.id]
    security_groups = [aws_security_group.ecr_security_group.id]
  }
}
