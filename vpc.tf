module "vpc" {
    source              = "github.com/antonioazambuja/terraform-aws-vpc"
    cidr_block          = var.cidr_block
    public_subnets      = var.public_subnets
    private_subnets     = var.private_subnets
    vpc_tags            = merge(
        var.vpc_tags,
        { "kubernetes.io/cluster/${var.cluster_name}" = "owned" }
    )
    public_subnet_tags  = merge(
        var.public_subnet_tags,
        { "kubernetes.io/cluster/${var.cluster_name}" = "owned" }
    )
    igw_tags            = var.igw_tags
    rt_igw_tags         = var.rt_igw_tags
    private_subnet_tags = merge(
        var.private_subnet_tags,
        { "kubernetes.io/cluster/${var.cluster_name}" = "owned" }
    )
    eip_nat_tags        = var.eip_nat_tags
    nat_gateway_tags    = var.nat_gateway_tags
    rt_nat_tags         = var.rt_nat_tags
}