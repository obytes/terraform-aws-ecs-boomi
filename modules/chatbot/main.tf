# ----------------------------------------------------------------------------------------------------------------------
# Locals and Data Sources
# ----------------------------------------------------------------------------------------------------------------------
locals {
  templates = join("/", [path.module, "templates"])
}

data "aws_region" "current" {

}

data "aws_caller_identity" "current" {

}
# ----------------------------------------------------------------------------------------------------------------------
# AWS IAM Roles and Polices
# ----------------------------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "chatbot_policy_doc" {
  version = "2012-10-17"
  statement {
    sid    = "AllowCloudWatchActions"
    effect = "Allow"
    actions = [
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "cloudwatch:Describe*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "chatbot_policy" {
  policy = data.aws_iam_policy_document.chatbot_policy_doc.json
  name   = join("-", [var.prefix, "policy"])
}

data "aws_iam_policy_document" "chatbot_assume_doc" {
  version = "2012-10-17"
  statement {
    sid = "AWSChatbotAssumeRole"
    principals {
      identifiers = ["chatbot.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "chatbot_role" {
  assume_role_policy = data.aws_iam_policy_document.chatbot_assume_doc.json
  name               = join("-", [var.prefix, "role"])
}

resource "aws_iam_role_policy_attachment" "role_policy_attach" {
  policy_arn = aws_iam_policy.chatbot_policy.arn
  role       = aws_iam_role.chatbot_role.name
}
# ----------------------------------------------------------------------------------------------------------------------
# Chatbot AWS Cloudformation
# ----------------------------------------------------------------------------------------------------------------------

data "local_file" "template_file" {
  filename = join("/", [local.templates, "cloudformation_chatbot.yml"])
}

resource "aws_cloudformation_stack" "chatbot_cloudformation" {
  name = join("-", [var.prefix, "cloudform"])
  parameters = {
    SNSTopicArns      = join(",", var.sns_topic_arns)
    SlackChannelID    = var.slack_channel_id
    SlackWorkspaceID  = var.slack_workspace_id
    IAMPolicyArn      = aws_iam_role.chatbot_role.arn
    ConfigurationName = join("-", [var.prefix, "config"])
    LoggingLevel      = "ERROR"
  }
  template_body = data.local_file.template_file.content
  tags          = merge(var.common_tags, map("Resource", "Cloud Formation", "Type", "Configuration Template"))
}
