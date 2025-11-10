# -------------------------------
# ECR API Endpoint
# -------------------------------
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.vpce_sg_id]
  private_dns_enabled = true

  tags = {
    Name = "${var.name_prefix}-ecr-api-endpoint"
  }
}

# -------------------------------
# ECR DKR Endpoint
# -------------------------------
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.vpce_sg_id]
  private_dns_enabled = true

  tags = {
    Name = "${var.name_prefix}-ecr-dkr-endpoint"
  }
}

# -------------------------------
# S3 Gateway Endpoint
# -------------------------------
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  tags = {
    Name = "${var.name_prefix}-s3-endpoint"
  }
}

# -------------------------------
# CloudWatch Endpoint
# -------------------------------
resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.vpce_sg_id]
  private_dns_enabled = true

  tags = {
    Name = "${var.name_prefix}-cloudwatch-endpoint"
  }
}

#route table for s3
# Private Route Table (S3 Gateway용)
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "goorm-private-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "private_app" {
  subnet_id      = var.private_subnet_ids[0]
  route_table_id = aws_route_table.private.id
}
