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

resource "helm_release" "metrics_server" {
  repository = var.metrics_server_chart_url
  chart      = "metrics-server"
  name       = "metrics-server"
  namespace  = "kube-system"
  version    = var.metrics_server_chart_version
  wait       = true

  depends_on = [
    aws_eks_node_group.eks_node_group
  ]
}