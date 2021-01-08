# AD Controller サーバーのグローバルIP
output "controller_public-dns" {
  value = aws_eip.controller.public_dns
}

# WorkSpaces Directory
output "workspaces_directory" {
    value = aws_directory_service_directory.test.id
}