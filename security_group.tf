resource "aws_security_group_rule" "eks_sg_ingress_rule" {
    for_each = { for rule in var.node_sg_rules: rule.name => rule }
    cidr_blocks = each.value.cidr_blocks
    from_port   = each.value.from_port
    to_port     = each.value.to_port
    protocol    = each.value.protocol
    description = each.value.description
    type        = each.value.type

    security_group_id = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "istio_default_15017" {
    protocol    = "TCP"
    from_port   = 15017
    to_port     = 15017
    type        = "ingress"
    self        = true
    description = "Cluster API - Istio Webhook namespace.sidecar-injector.istio.io"

    security_group_id = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "istio_default_15012" {
    protocol    = "TCP"
    from_port   = 15012
    to_port     = 15012
    type        = "ingress"
    self        = true
    description = "Cluster API to nodes ports/protocols"

    security_group_id = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}