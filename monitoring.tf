resource "helm_release" "prometheus" {
  repository = var.prometheus_chart_url
  chart      = "prometheus"
  name       = "prometheus"
  namespace  = helm_release.istio_base.metadata[0].namespace
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

resource "helm_release" "grafana" {
  repository = var.grafana_chart_url
  chart      = "grafana"
  name       = "grafana"
  namespace  = helm_release.istio_base.metadata[0].namespace
  wait       = true
}