
### SG - RDS ###
resource "aws_security_group" "rds_user" {
  name        = "${var.name_prefix}-rds-user-sg"
  description = "RDS SG for user service database"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-rds-user-sg"
  }
}

resource "aws_security_group" "rds_product" {
  name        = "${var.name_prefix}-rds-product-sg"
  description = "RDS SG for product service database"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-rds-product-sg"
  }
}

resource "aws_security_group" "rds_order" {
  name        = "${var.name_prefix}-rds-order-sg"
  description = "RDS SG for order service database"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-rds-order-sg"
  }
}

resource "aws_security_group" "rds_payment" {
  name        = "${var.name_prefix}-rds-payment-sg"
  description = "RDS SG for payment service database"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-rds-payment-sg"
  }
}


### SG - NLB, VPC Link ###
resource "aws_security_group" "vpc_link" {
  name        = "${var.name_prefix}-vpc-link-sg"
  description = "VPC Link SG"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  tags = {
    Name = "${var.name_prefix}-vpc-link-sg"
  }
}

locals {
  ingress_ports = [80, 180, 81, 181, 82, 182, 83, 183]
}
resource "aws_security_group" "nlb" {
  name        = "${var.name_prefix}-nlb-sg"
  description = "NLB SG"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.ingress_ports
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.vpc_link.id]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-nlb-sg"
  }
}
