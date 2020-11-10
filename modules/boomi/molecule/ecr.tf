resource "aws_ecr_repository" "this" {
  name = local.prefix
}
