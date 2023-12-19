resource "helm_release" "ingress_nginx" {
  repository = var.ingress_nginx_chart_url
  chart      = "ingress-nginx"
  name       = "ingress-nginx"
  namespace  = "ingress-nginx"
  version    = var.ingress_nginx_chart_version
  wait       = true

  create_namespace = true

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod,
    aws_eks_node_group.eks_node_group
  ]
}