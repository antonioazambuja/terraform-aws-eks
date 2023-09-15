resource "kubernetes_namespace" "demo" {
    metadata {
        annotations = {
            name = "demo"
        }

        labels = {
            istio-injection = "enabled"
        }

        name = "demo"
    }
}