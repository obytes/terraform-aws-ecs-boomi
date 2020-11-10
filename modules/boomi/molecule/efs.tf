resource "aws_efs_file_system" "this" {
  creation_token = "molecule-fs"

  encrypted        = false
  throughput_mode  = "bursting"
  performance_mode = "maxIO"

  tags = {
    Name = "MoleculeFileSystem"
  }
}

resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id
}

resource "aws_efs_mount_target" "this" {
  count = length(var.private_subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = element(var.private_subnet_ids, count.index)
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_file_system_policy" "this" {
  file_system_id = aws_efs_file_system.this.id
  policy         = data.aws_iam_policy_document.efs.json
}

data "aws_iam_policy_document" "efs" {
  statement {

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
      "elasticfilesystem:ClientRootAccess",
    ]

    resources = [
      aws_efs_file_system.this.arn
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = [
        "true"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "elasticfilesystem:AccessPointArn"
      values   = [
        aws_efs_access_point.this.arn
      ]
    }
  }
}
