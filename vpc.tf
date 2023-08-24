module "vpc" {
    source              = "github.com/antonioazambuja/terraform-aws-vpc"
    cidr_block          = var.cidr_block
    public_subnets      = var.public_subnets
    private_subnets     = var.private_subnets
    vpc_tags            = merge(
        var.tags,
        { "kubernetes.io/cluster/${var.cluster_name}" = "owned" }
    )
    public_subnet_tags  = merge(
        var.tags,
        { "kubernetes.io/cluster/${var.cluster_name}" = "owned" }
    )
    igw_tags            = var.tags
    rt_igw_tags         = var.tags
    private_subnet_tags = merge(
        var.tags,
        { "kubernetes.io/cluster/${var.cluster_name}" = "owned" }
    )
    eip_nat_tags        = var.tags
    nat_gateway_tags    = var.tags
    rt_nat_tags         = var.tags
}