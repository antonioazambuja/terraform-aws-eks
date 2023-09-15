resource "aws_eks_cluster" "eks_cluster" {

    name     = var.cluster_name
    role_arn = aws_iam_role.eks_master_role.arn
    version  = var.eks_version
    tags     = var.tags
    
  
    vpc_config {
        subnet_ids = module.vpc.private_subnets_id
    }

    depends_on = [
        aws_iam_role_policy_attachment.eks_cluster_cluster,
        aws_iam_role_policy_attachment.eks_cluster_service
    ]

}