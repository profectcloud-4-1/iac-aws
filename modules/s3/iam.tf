# 1. IAM 사용자 생성
/*resource "aws_iam_user" "presigned_user" {
  name = "presigned-user"
}

# 2. IAM Access Key 생성
resource "aws_iam_access_key" "presigned_key" {
  user = aws_iam_user.presigned_user.name
}

# 3. IAM 정책 생성 (S3 특정 버킷에만 접근)
data "aws_iam_policy_document" "s3_presigned_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_presigned_policy" {
  name   = "s3-presigned-policy"
  policy = data.aws_iam_policy_document.s3_presigned_policy.json
}

# 4. 사용자에 정책 붙이기
resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.presigned_user.name
  policy_arn = aws_iam_policy.s3_presigned_policy.arn
}*/