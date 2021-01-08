resource "aws_key_pair" "ad_test" {
  key_name   = "${var.pj-prefix}-ad-test"
  public_key = file(var.public_key_path)
}

### Windowsインスタンスを指定
data "aws_ami" "windows_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-2020.09.09"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "controller" {
  ami                         = data.aws_ami.windows_ami.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ad_test.id
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ad_profile.name

  vpc_security_group_ids = [
    aws_security_group.ssh_rdp.id
  ]

  tags = {
    Name = "${var.pj-prefix}-controller"
  }
}

resource "aws_eip" "controller" {
  instance = aws_instance.controller.id
  vpc      = true
}

