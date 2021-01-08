# セキュリティグループの書き方は2通り？
# 1. aws_security_groupの中に直接記述
# 2. aws_security_group_rule を作成して、その中でSGを指定 (推奨)
resource "aws_security_group" "ssh_rdp" {
  name        = "${var.pj-prefix}-ssh-rdp"
  description = "Allow SSH and RDP access"
  vpc_id      = module.vpc.vpc_id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # RDP
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.pj-prefix}-ssh-rdp"
  }
}
