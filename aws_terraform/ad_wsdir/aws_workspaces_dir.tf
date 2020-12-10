resource "aws_workspaces_directory" "test" {
  directory_id = aws_directory_service_directory.test.id
  subnet_ids = [
    aws_subnet.public-a.id,
    aws_subnet.public-c.id
  ]

  depends_on = [
    aws_iam_role_policy_attachment.workspaces_default_service_access,
    aws_iam_role_policy_attachment.workspaces_default_self_service_access
  ]
}