## AD管理インスタンス用
resource "aws_iam_instance_profile" "ad_profile" {
  name = "ad_role"
  role = aws_iam_role.ad_role.name
}

resource "aws_iam_role" "ad_role" {
  name = "ad_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy" "amazon_ssm_managed_instance_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "amazon_ssm_directory_service_access" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core_to_ad_role" {
  role       = aws_iam_role.ad_role.name
  policy_arn = data.aws_iam_policy.amazon_ssm_managed_instance_core.arn
}

resource "aws_iam_role_policy_attachment" "ssm_directory_service_access_to_ad_role" {
  role       = aws_iam_role.ad_role.name
  policy_arn = data.aws_iam_policy.amazon_ssm_directory_service_access.arn
}


### WorkSpacesのデフォルトロール作成
### https://docs.aws.amazon.com/ja_jp/workspaces/latest/adminguide/workspaces-access-control.html#create-default-role
data "aws_iam_policy_document" "workspaces" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["workspaces.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "workspaces_default" {
  name               = "workspaces_DefaultRole"
  assume_role_policy = data.aws_iam_policy_document.workspaces.json
}

resource "aws_iam_role_policy_attachment" "workspaces_default_service_access" {
  role       = aws_iam_role.workspaces_default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesServiceAccess"
}

resource "aws_iam_role_policy_attachment" "workspaces_default_self_service_access" {
  role       = aws_iam_role.workspaces_default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesSelfServiceAccess"
}