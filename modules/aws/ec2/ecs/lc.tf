resource "aws_launch_configuration" "lc" {
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.profile.name
  image_id                    = data.aws_ami.ecs.id
  instance_type               = var.instance_type
  name_prefix                 = "${local.prefix}-lc"
  key_name                    = "${local.common_tags["env"]}-${local.common_tags["project_name"]}-key"

  security_groups = [
    var.security_group_ids["default_vpc"],
    var.security_group_ids["access_adm_ssh"]
  ]


  user_data_base64 = base64encode(data.template_file.user_data.rendered)

  lifecycle {
    create_before_destroy = true
  }
}
