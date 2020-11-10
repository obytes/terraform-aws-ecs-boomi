resource "aws_s3_bucket" "bucket" {
  bucket = var.name
  acl    = var.acl

  tags = local.common_tags

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "cleanup"
    enabled = true

    expiration {
      days = var.retention_days
    }
  }
}

resource "aws_s3_bucket_policy" "alb_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.b.json
}

data "aws_iam_policy_document" "b" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/alb/*"]

    principals {
      identifiers = [data.aws_elb_service_account.current.arn]
      type        = "AWS"
    }
  }
}

