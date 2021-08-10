data "aws_ami" "eks-worker" {
  most_recent      = true
  owners           = ["602401143452"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.version}-v*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
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