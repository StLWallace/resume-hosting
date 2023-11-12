resource "aws_s3_bucket" "public_content" {
  bucket = "public-content-${var.environment}-${local.project_id}"

  tags = {
    Name        = "public-content-${var.environment}"
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "cloudfront_s3" {
  statement {
    sid = 1
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.public_content.arn}/**"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.public_s3_content.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "public_content" {
  bucket = aws_s3_bucket.public_content.id

  policy = data.aws_iam_policy_document.cloudfront_s3.json
}
