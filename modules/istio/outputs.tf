output "istio_base" {
  value = helm_release.istio_base
}

output "istiod" {
  value = helm_release.istiod
}

output "kiali" {
  value = helm_release.kiali
}

output "prometheus" {
  value = helm_release.prometheus
}