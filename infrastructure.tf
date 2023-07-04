terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "aws_region"
}

resource "aws_vpc" "my_vpc" { # aws_vpc를 만들건데 -> 이 테라폼 안에서 쓸 이름이 my_vpc
  cidr_block = "10.0.0.0/16"  # VPC의 IP 주소 범위를 정의합니다.
}

resource "aws_subnet" "private_subnet" { # aws_subnet -> 그 이름이 private_subent -> 이렇게 지은 이유가 private으로 쓸거라서
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"  # 프라이빗 서브넷의 IP 주소 범위를 정의합니다.
}

resource "aws_subnet" "public_subnet" { # aws_subent -> 그 이름이 public_subnet
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"  # 퍼블릭 서브넷의 IP 주소 범위를 정의합니다.
}

resource "aws_ecr_repository" "my_repository" { # ecr 레포 -> my_repository
  name = "my-repository"  # ECR 레포지토리의 이름을 정의합니다.
}

resource "aws_ecs_cluster" "my_cluster" { # ecs 만듦
  name = "my-cluster"  # ECS 클러스터의 이름을 정의합니다.
}

resource "aws_ecs_task_definition" "my_task_definition" { # 테스크 정의
  family                   = "my-task"  # 테스트 정의 이름
  execution_role_arn       = "execution_role_arn"  # 작업 실행 역할의 ARN(Amazon Resource Name)을 정의합니다. -> arn은 aws안에서 통용되는 유니크한 주소 같은 것
  task_role_arn            = "task_role_arn"  # 작업 역할의 ARN을 정의합니다. -> iam정의된 역할 -> task role
  network_mode             = "awsvpc"  # 네트워크 모드를 "awsvpc"로 설정하여 Fargate에 대한 VPC 네트워킹을 활성화합니다. -> network_mode에는 두가지 모드가 있는데 "awsvpc", "bridge"가 있다.
  requires_compatibilities = ["FARGATE"]  # Fargate 호환성을 설정합니다. -> requires_compatibilities에는 "EC2", "FARGATE"가 있다

  container_definitions = <<DEFINITION
  [
    {
      "name": "my-container",
      "image": "${aws_ecr_repository.my_repository.repository_url}:latest",  # ECR에 저장된 도커 이미지를 사용합니다.
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "ENV_VAR1",
          "value": "value1"
        },
        {
          "name": "ENV_VAR2",
          "value": "value2"
        }
      ],
      "cpu": 256,
      "memory": 512
    }
  ]
  DEFINITION
}

resource "aws_ecs_service" "my_service" {
  name            = "my-service"  # ECS 서비스의 이름을 정의합니다.
  cluster         = aws_ecs_cluster.my_cluster.id  # ECS 클러스터의 ID를 참조합니다.
  task_definition = aws_ecs_task_definition.my_task_definition.arn  # 작업(Task) 정의의 ARN을 참조합니다.
  desired_count   = 2  # 실행할 작업 인스턴스의 수를 정의합니다.
  launch_type     = "FARGATE"  # Fargate 실행 유형을 사용합니다.

  network_configuration {
    subnets         = [aws_subnet.private_subnet.id]  # 서비스가 배포될 서브넷을 정의합니다.
    security_groups = [aws_security_group.my_security_group.id]  # 서비스에 적용할 보안 그룹을 정의합니다.
  }
}

resource "aws_lb" "my_alb" {
  name               = "my-alb"  # Application Load Balancer(ALB)의 이름을 정의합니다.
  load_balancer_type = "application"  # Application Load Balancer(ALB)를 생성합니다.
  subnets            = [aws_subnet.public_subnet.id]  # ALB가 배포될 퍼블릭 서브넷을 정의합니다.
}

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_alb.arn  # 리스너가 연결될 ALB의 ARN을 참조합니다.
  port              = 80  # 리스너의 포트를 정의합니다.
  protocol          = "HTTP"  # HTTP 프로토콜을 사용합니다.

  default_action {
    target_group_arn = aws_lb_target_group.my_target_group.arn  # 리스너에 연결될 Target Group의 ARN을 참조합니다.
    type             = "forward"  # 전달(default) 동작을 설정합니다.
  }
}

resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"  # Target Group의 이름을 정의합니다.
  port     = 80  # Target Group에 대한 포트를 정의합니다.
  protocol = "HTTP"  # HTTP 프로토콜을 사용합니다.
  vpc_id   = aws_vpc.my_vpc.id  # Target Group이 속할 VPC의 ID를 정의합니다.
}

resource "aws_lb_target_group_attachment" "my_target_group_attachment" {
  target_group_arn = aws_lb_target_group.my_target_group.arn  # Target Group의 ARN을 참조합니다.
  target_id        = aws_ecs_service.my_service.id  # Target Group에 연결할 ECS 서비스의 ID를 참조합니다.
  target_type      = "ip"  # Target 유형을 IP로 설정합니다.
}
