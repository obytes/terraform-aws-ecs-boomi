variable "prefix" {
  type = string
  description = "A prefix string used to name the resources"
}

variable "common_tags" {
  type = map(string)
  description = "A map of tags to tag the resources"
}

variable "sns_topic_arns" {
  type = list(string)
  description = "A list of SNS topic which AWS Chatbot listens on"
}

variable "slack_channel_id" {
  type = string
  description = "The Slack channel ID where AWS Chatbot would post the messages"
}

variable "slack_workspace_id" {
  type = string
  description = "The Slack workspace/organization ID"
}

