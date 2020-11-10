resource "aws_iam_user" "this" {
  name = local.prefix
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "sqs:DeleteMessage",
      "sqs:ChangeMessageVisibility",
      "sqs:SendMessageBatch",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
      "sqs:ListQueueTags",
      "sqs:ListDeadLetterSourceQueues",
      "sqs:DeleteMessageBatch",
      "sqs:ChangeMessageVisibilityBatch",
    ]

    resources = [
      module.events.queue_arn
    ]
  }

  statement {
    actions = [
      "sns:Publish",
    ]

    resources = [
      module.events.topic_arn
    ]
  }
}

resource "aws_iam_policy" "this" {
  name        = local.prefix
  path        = "/"
  policy      = data.aws_iam_policy_document.this.json
  description = "Boomi user policy"
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.this.arn
}
