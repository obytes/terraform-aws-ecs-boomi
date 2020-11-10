resource "aws_autoscaling_group" "asg" {
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.lc.id
  max_size             = var.max_size
  min_size             = var.min_size
  name                 = "${local.prefix}-asg"

  vpc_zone_identifier = var.private_subnet_ids

  tag {
    key                 = "Name"
    value               = "${local.prefix}-asg"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.common_tags

    content {
      key    =  tag.key
      value   =  tag.value
      propagate_at_launch =  true
    }
  }

}
