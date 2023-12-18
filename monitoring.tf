resource "helm_release" "kube_prometheus" {
  repository = var.kube_prometheus_chart_url
  chart      = "kube-prometheus-stack"
  name       = "kube-prometheus-stack"
  namespace  = helm_release.istio_base.metadata[0].namespace
  wait       = true

  set {
    name  = "grafana.sidecar.dashboardsConfigMaps.default"
    value = "istio-dashboards"
  }

  depends_on = [
    aws_eks_node_group.eks_node_group
  ]
}