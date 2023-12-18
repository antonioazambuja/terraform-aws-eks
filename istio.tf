resource "helm_release" "istio_base" {
  repository = var.istio_chart_url
  chart      = "base"
  name       = "istio-base"
  namespace  = "istio-system"
  version    = var.istio_chart_version
  wait       = true

  create_namespace = true

  depends_on = [
    aws_eks_node_group.eks_node_group
  ]
}

resource "helm_release" "istiod" {
  repository = var.istio_chart_url
  chart      = "istiod"
  name       = "istiod"
  namespace  = helm_release.istio_base.metadata[0].namespace
  version    = var.istio_chart_version
  wait       = true

  depends_on = [
    aws_eks_node_group.eks_node_group
  ]

  set {
    name  = "meshConfig.accessLogFile"
    value = "/dev/stdout"
  }
}

# resource "helm_release" "istio_ingress" {
#   repository = var.istio_chart_url
#   chart      = "gateway"
#   name       = "istio-ingress"
#   namespace  = "istio-ingress" # per https://github.com/istio/istio/blob/master/manifests/charts/gateways/istio-ingress/values.yaml#L2
#   version    = var.istio_chart_version
#   wait       = true

#   create_namespace = true

#   values = [
#     yamlencode(
#       {
#         labels = {
#           istio = "ingressgateway"
#         }
#         service = {
#           annotations = {
#             "service.beta.kubernetes.io/aws-load-balancer-type"       = "nlb"
#             "service.beta.kubernetes.io/aws-load-balancer-scheme"     = "internet-facing"
#             "service.beta.kubernetes.io/aws-load-balancer-attributes" = "load_balancing.cross_zone.enabled=true"
#           }
#         }
#       }
#     )
#   ]
#   depends_on = [helm_release.istiod]
# }