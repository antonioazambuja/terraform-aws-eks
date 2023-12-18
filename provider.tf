terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "=> 2.0.4"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.17.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11.0"
    }
  }
}