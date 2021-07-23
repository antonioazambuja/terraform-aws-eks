variable "k8s_version" {
  description = "EKS K8s version used in your Infrastructure"
}

variable "cluster_name" {
  description = "EKS Cluster name"
}

variable "workers_instance_type" {
  description = "EC2 instance type of EKS workers"
}

variable "node_prefix_name" {
  description = "EKS workers node prefix name"
}

variable "key_pair_name" {
  description = "Key pair name used on EKS workers"
}

variable "asg_desired_capacity" {
  description = "Auto Scaling Group desired capacity"
}

variable "asg_max_size" {
  description = "Auto Scaling Group maximum size"
}

variable "asg_min_size" {
  description = "Auto Scaling Group minimum size"
}

variable "asg_name" {
  description = "Auto Scaling Group name"
}

variable "lb_network_name" {
  description = "EKS Network Load Balancer name"
}

variable "node_iam_role_name" {
  description = "Node IAM role name"
}

variable "node_sg_name" {
  description = "Node Security Group name"
}

variable "cluster_sg_name" {
  description = "Cluster Security Group name"
}

variable "autoscaler_iam_role_name" {
  description = "Autoscaler IAM role name"
}

variable "custom_autoscaler_iam_role_name" {
  description = "Custom Autoscaler IAM role name"
}

variable "cluster_iam_role_name" {
  description = "Cluster IAM role name"
}

variable "availability_zones" {
  description = "AWS Availability Zones deploy your EKS, using only private subnets"
}

variable "number_availability_zones" {
  description = "Number of AWS Availability Zones deploy your EKS, choosing randomly"
}