terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# PostgreSQL 16용 파라미터 그룹: 서울 타임존 및 UTF-8
resource "aws_db_parameter_group" "this" {
  name        = "${var.name}-pg-16"
  family      = "postgres16"
  description = "Parameter group for ${var.name} (Asia/Seoul, UTF-8)"

  parameter {
    name  = "timezone"
    value = "Asia/Seoul"
  }
}

# DB Subnet Group (서브넷 2개 이상 권장 - 단일 AZ 배포여도 요구됨)
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "${var.name}-db-subnet-group"
  }
}

# RDS 전용 SG (외부에서 전달받지 않을 때에만 생성)
resource "aws_security_group" "this" {
  count       = var.create_security_group && length(var.security_group_ids) == 0 ? 1 : 0
  name        = "${var.name}-rds-sg"
  description = "Security group for ${var.name} RDS"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-rds-sg"
  }
}

resource "aws_db_instance" "this" {
  identifier                  = "${var.name}"
  engine                      = "postgres"
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  db_name                     = var.db_name
  username                    = var.username
  password                    = var.password

  # 네트워크
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = length(var.security_group_ids) > 0 ? var.security_group_ids : [aws_security_group.this[0].id]
  publicly_accessible    = false
  availability_zone      = var.availability_zone

  # 스토리지/백업
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type

  # 가용성/적용
  multi_az          = var.multi_az
  apply_immediately = var.apply_immediately

  # 종료 보호/스냅샷
  deletion_protection  = false
  skip_final_snapshot  = true

  # 파라미터 그룹
  parameter_group_name = aws_db_parameter_group.this.name

  tags = {
    Name = "${var.name}-rds"
  }
}

