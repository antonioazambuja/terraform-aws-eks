resource "helm_release" "prometheus" {
  repository = var.prometheus_chart_url
  chart      = "prometheus"
  name       = "prometheus"
  namespace  = "istio-system"
  wait       = true

  set {
    name  = "server.persistentVolume.enabled"
    value = "false"
  }

  set {
    name = "alertmanager.enabled"
    value = "false"
  }
}