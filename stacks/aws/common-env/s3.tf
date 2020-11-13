#====================================#
#     S3 Logging:                    #
#       ALB, Trail, etc              #
#====================================#

module "s3_logging" {
  source = "../../../modules/aws/s3/logging"
  name   = "${local.prefix}-logs"

  common_tags = merge(
    local.common_tags,
    {
      "usage"      = "logging"
      "visibility" = "internal"
    },
  )
}