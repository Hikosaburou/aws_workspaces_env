resource "aws_directory_service_directory" "test" {
  name     = var.ad_domain_name
  password = var.ad_admin_password
  size     = "Small"
  type     = "SimpleAD"

  vpc_settings {
    vpc_id     = module.vpc.vpc_id
    # ADに指定できるサブネットは2つまで。
    subnet_ids = slice(module.vpc.public_subnets, 0, 2)
  }

  tags = {
    Project = var.pj-prefix
  }
}
