resource "aws_eks_node_group" "eks_node_group" {
    for_each        = { for node_group in var.eks_node_groups: node_group.name => node_group }
    cluster_name    = var.cluster_name
    node_group_name = format("%s-node-group", each.value.name)
    node_role_arn   = aws_iam_role.eks_node_role.arn

    subnet_ids     = module.vpc.private_subnets_id
    instance_types = each.value.instance_types

    scaling_config {
        desired_size = each.value.desired_size
        max_size     = each.value.max_size
        min_size     = each.value.min_size
    }

    depends_on = [
        aws_iam_role_policy_attachment.eks_AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.eks_AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.eks_AmazonEC2ContainerRegistryReadOnly
    ]

}