resource "aws_iam_role" "cluster" {
  name = var.cluster_iam_role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_policy" "custom_autoscaler" {
  name        = var.custom_autoscaler_iam_role_name
  path        = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "autoscaling:DescribeTags",
          "autoscaling:DescribeLaunchConfigurations",
          "ec2:DescribeLaunchTemplateVersions"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "autoscaler" {
  name = var.autoscaler_iam_role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  policy_arn = aws_iam_policy.custom_autoscaler.arn
  role       = aws_iam_role.autoscaler.name
}

resource "aws_security_group" "cluster" {
  name   = var.cluster_sg_name
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.cluster_sg_name
  }
}

resource "aws_security_group_rule" "cluster_cidr_block_rules" {
  for_each          = { for rule in var.cluster_sg_rules: rule.description => rule if rule.source_security_group_id == "" || !rule.self && length(rule.cidr_blocks) > 0 }
  security_group_id = aws_security_group.cluster.id
  cidr_blocks       = each.value.cidr_blocks
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  type              = each.value.type
}

resource "aws_security_group_rule" "cluster_source_security_group_id_rules" {
  for_each                 = { for rule in var.cluster_sg_rules: rule => rule if length(rule.cidr_blocks) == 0 || !rule.self && rule.source_security_group_id != "" }
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = each.value.source_security_group_id
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  type                     = each.value.type
}

resource "aws_security_group_rule" "cluster_self_rules" {
  for_each          = { for rule in var.cluster_sg_rules: rule => rule if length(rule.cidr_blocks) == 0 || rule.source_security_group_id != "" && rule.self }
  security_group_id = aws_security_group.cluster.id
  self              = each.value.self
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  type              = each.value.type
}

resource "aws_security_group" "node" {
  name   = var.node_sg_name
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
     "Name" = var.node_sg_name,
     "kubernetes.io/cluster/${var.cluster_name}" =  "owned"
  }
}

resource "aws_security_group_rule" "node_cidr_block_rules" {
  for_each          = { for rule in var.node_sg_rules: rule.description => rule if rule.source_security_group_id == "" || !rule.self && length(rule.cidr_blocks) > 0 }
  security_group_id = aws_security_group.node.id
  cidr_blocks       = each.value.cidr_blocks
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  type              = each.value.type
}

resource "aws_security_group_rule" "node_source_security_group_id_rules" {
  for_each                 = { for rule in var.node_sg_rules: rule => rule if length(rule.cidr_blocks) == 0 || !rule.self && rule.source_security_group_id != "" }
  security_group_id        = aws_security_group.node.id
  source_security_group_id = each.value.source_security_group_id
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  type                     = each.value.type
}

resource "aws_security_group_rule" "node_self_rules" {
  for_each          = { for rule in var.node_sg_rules: rule => rule if length(rule.cidr_blocks) == 0 || rule.source_security_group_id == "" && rule.self }
  security_group_id = aws_security_group.node.id
  self              = each.value.self
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  type              = each.value.type
}

resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.cluster.id]
    subnet_ids         = var.subnets
  }

  tags = var.eks_tags

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
  ]
}

resource "aws_iam_role" "node" {
  name = var.node_iam_role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-prod-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

resource "aws_iam_instance_profile" "node" {
  name = "eks-node-${var.cluster_name}"
  role = aws_iam_role.node.name
}

locals {
  node_userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.cluster.certificate_authority.0.data}' '${var.cluster_name}'
USERDATA
}

resource "aws_lb" "subnets" {
  name               = var.lb_network_name
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = var.load_balancer_tags
}

resource "aws_launch_configuration" "eks_launch_config" {
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = aws_iam_instance_profile.node.name
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = var.workers_instance_type
  name_prefix                 = var.node_prefix_name
  security_groups             = [aws_security_group.node.id]
  user_data_base64            = base64encode(local.node_userdata)
  key_name                    = var.key_pair_name
  ebs_optimized               = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks_nodes" {
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.eks_launch_config.id
  max_size             = var.max_size
  min_size             = var.min_size
  name                 = var.asg_name
  vpc_zone_identifier  = var.subnets

  tag {
    key                 = "Name"
    value               = var.asg_name
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
    value               = "true"
    propagate_at_launch = true
  }
}