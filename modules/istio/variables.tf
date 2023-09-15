variable "istio_chart_version" {
  default = "1.18.1"
  type    = string
}

variable "istio_chart_url" {
  default = "https://istio-release.storage.googleapis.com/charts"
  type    = string
}

variable "kiali_chart_url" {
  default = "https://kiali.org/helm-charts"
  type    = string
}

variable "prometheus_chart_url" {
  default = "https://prometheus-community.github.io/helm-charts"
  type    = string
}