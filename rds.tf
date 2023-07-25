resource "aws_db_instance" "mysql" {
  engine            = "mysql"
  engine_version    = "8.0.28"
  allocated_storage = 20
  storage_type      = "gp2"
  instance_class    = "db.t2.micro"
  identifier        = "mydb"
  username          = var.DB_USER
  password          = var.DB_PASSWORD
  name              = var.APP_NAME

  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  parameter_group_name   = aws_db_parameter_group.default.name
  publicly_accessible    = true


  tags = {
    NAME = "${var.APP_NAME}-${var.Environment}-db"
  }
}

// public에 한 이유는 개발환경을 구축하기 위함으로 실제 운영환경에서는 private로 구축해야함
// bastion도 사치!
resource "aws_db_subnet_group" "default" {
  name        = "db-subnet-group"
  description = "Terraform example RDS subnet group"
  subnet_ids  = [aws_subnet.db_subnet_1.id, aws_subnet.db_sunbet_2.id]
}

resource "aws_db_parameter_group" "default" {
  name   = "mysql-parameters"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }
}
