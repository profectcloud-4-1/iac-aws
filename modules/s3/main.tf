resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name        = var.bucket_name
    Environment = "prod"
  }
}



resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id


  versioning_configuration {
    status = var.versioning ? "Enabled" : "Suspended"
  }
}

# Public Access Block 설정 (프라이빗 버킷)
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

