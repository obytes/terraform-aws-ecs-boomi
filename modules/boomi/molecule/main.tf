locals {
  prefix = "${var.prefix}-mol"
  common_tags = merge(
    var.common_tags,
    {
      "Description" = "Boomi molecule cluster nodes"
    },
  )
  volume_name = "molecule-storage"
  templates = join("/", [path.module, "templates"])
  cw_agent_config = {
    LOG_GROUP_NAME = aws_cloudwatch_log_group.boomi_log_files.name
    CW_REGION_NAME = data.aws_region.current.name
  }
}
