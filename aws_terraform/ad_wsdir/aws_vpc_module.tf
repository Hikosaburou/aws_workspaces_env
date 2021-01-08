module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.pj-prefix
  cidr = "10.1.0.0/16"

  azs             = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  public_subnets  = ["10.1.8.0/24", "10.1.9.0/24", "10.1.10.0/24"]

  vpc_tags = {
    Name = "${var.pj-prefix}-vpc"
  }

  enable_nat_gateway  = false
  single_nat_gateway  = false
}