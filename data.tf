data "aws_ami" "eks-worker" {
  most_recent      = true
  owners           = ["602401143452"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks_version}-v*"]
  }

  filter {
    name   = "root-device-type"
    values = var.root_device_type
  }

  filter {
    name   = "virtualization-type"
    values = var.virtualization_type
  }

  filter {
    name   = "architecture"
    values = var.architecture
  }
}