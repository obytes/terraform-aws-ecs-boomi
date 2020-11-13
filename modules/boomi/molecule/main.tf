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
}
