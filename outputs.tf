## EKS

output "eks_cluster" {
  value = aws_eks_cluster.eks_cluster
}

## AMI

output "ami" {
  value = data.aws_ami.eks-worker
}

## Istio

output "istio_base" {
  value = helm_release.istio_base
}

output "istiod" {
  value = helm_release.istiod
}

## Kiali

output "kiali_operator" {
  value = helm_release.kiali
}

output "kiali" {
  value = kubectl_manifest.kiali
}

## Monitoring

output "kube_prometheus" {
  value = helm_release.kube_prometheus
}

## Security

output "eks_sg_ingress_rule" {
  value = aws_security_group_rule.eks_sg_ingress_rule
}

output "istio_default_15017" {
  value = aws_security_group_rule.istio_default_15017
}

output "istio_default_15012" {
  value = aws_security_group_rule.istio_default_15012
}

## VPC

output "vpc" {
  value = module.vpc
}

## IAM

output "eks_master_role" {
  value = aws_iam_role.eks_master_role
}

output "eks_node_role" {
  value = aws_iam_role.eks_node_role
}