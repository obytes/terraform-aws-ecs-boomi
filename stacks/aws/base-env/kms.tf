resource "aws_kms_key" "default" {
  description             = "For use on ${local.prefix}-kms"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "default" {
  name          = "alias/${local.prefix}-kms"
  target_key_id = aws_kms_key.default.key_id
}

