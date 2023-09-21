resource "helm_release" "kiali" {
  repository = var.kiali_chart_url
  chart      = "kiali-operator"
  name       = "kiali-operator"
  namespace  = "kiali-operator"
  wait       = true

  create_namespace = true

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]
}

resource "kubectl_manifest" "kiali" {
  yaml_body = <<YAML
apiVersion: kiali.io/v1alpha1
kind: Kiali
metadata:
  name: kiali
  namespace: istio-system
spec:
  auth:
    strategy: anonymous
  external_services:
    prometheus:
      url: http://prometheus-server.istio-system/
    grafana:
      enabled: true
      in_cluster_url: 'http://grafana.istio-system/'
      url: 'http://localhost:3000/'
      auth:
        type: "basic"
        password: "DoCZW86nmZW67JyDxGjNVFrUdJPRlVzpkKgPRQnx"
        username: "admin"
      dashboards:
      - name: "Istio Service Dashboard"
        variables:
          namespace: "var-namespace"
          service: "var-service"
      - name: "Istio Workload Dashboard"
        variables:
          namespace: "var-namespace"
          workload: "var-workload"
      - name: "Istio Mesh Dashboard"
      - name: "Istio Control Plane Dashboard"
      - name: "Istio Performance Dashboard"
      - name: "Istio Wasm Extension Dashboard"
    tracing:
      enabled: false
  YAML
}