# terraform-aws-eks

## Creating or updating a kubeconfig file for an Amazon EKS cluster

https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html

```
aws eks update-kubeconfig --region your-region --name your-cluster
```

## Deploy microservices-demo

https://github.com/GoogleCloudPlatform/microservices-demo

## Use module

For use this module in your terraform project see example on `examples/main.tf`. This example is structed way to able deploy EKS and Istio separately because to depĺoy kubernetes_manifest Kiali actually Terraform Provider for Kubernetes need Kubernetes API, i.e, your EKS cluster need already running. So, for deploy resources use these commands below:

1. Create two modules for AWS EKS and Istio the same as the example;

2. Deploy AWS EKS cluster:
```
terraform pĺan -target=module.eks_cluster
terraform apply -target=module.eks_cluster
```
3. Deploy Istio on AWS EKS cluster:
```
terraform pĺan -target=module.istio
terraform apply -target=module.istio
```