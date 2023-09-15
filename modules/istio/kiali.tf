resource "helm_release" "kiali" {
  repository = var.kiali_chart_url
  chart      = "kiali-operator"
  name       = "kiali-operator"
  namespace  = "kiali-operator"
  wait       = true

  create_namespace = true

  set {
    name  = "cr.create"
    value = "true"
  }

  set {
    name  = "cr.namespace"
    value = "istio-system"
  }

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]
}

resource "kubernetes_manifest" "kiali" {
  manifest = {
    apiVersion = "kiali.io/v1alpha1"
    kind = "Kiali"
    metadata = {
      name = "kiali"
      namespace = "istio-system"
    }
    spec = {
      auth = {
        strategy = "anonymous"
      }
      external_services = {
        prometheus = {
          url = "http://prometheus-server.istio-system/"
        }
        tracing = {
          enabled = false
        }
      }
    }
  }
}