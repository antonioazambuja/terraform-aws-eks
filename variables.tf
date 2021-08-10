variable "version" {
  description = "EKS version used in your Infrastructure"
  default = "1.19.8"
  type = string
  validation {
    condition     = contains(["1.19.8", "1.20.7", "1.21.2"])
    error_message = "Your EKS version is depreciated."
  }
}

variable "cluster_name" {
  description = "EKS Cluster name"
}

variable "workers_instance_type" {
  description = "EC2 instance type of EKS workers"
  default = "t2.micro"
  type = string
  validation {
    condition = var.workers_instance_type == "t2.micro"
    error_message = "Worker instance type not is 't2.micro'"
  }
}

variable "node_prefix_name" {
  description = "EKS workers node prefix name"
  default = "node-"
  type = string
}

variable "key_pair_name" {
  description = "Key pair name used on EKS workers"
  type = string
}

variable "desired_capacity" {
  description = "Auto Scaling Group desired capacity"
  default = 3
  type = number
}

variable "max_size" {
  description = "Auto Scaling Group maximum size"
  default = 3
  type = number
}

variable "min_size" {
  description = "Auto Scaling Group minimum size"
  default = 1
  type = number
}

variable "asg_name" {
  description = "Auto Scaling Group name"
  type = string
}

variable "lb_network_name" {
  description = "EKS Network Load Balancer name"
  type = string
}

variable "node_iam_role_name" {
  description = "Node IAM role name"
  type = string
}

variable "node_sg_name" {
  description = "Node Security Group name"
  type = string
}

variable "cluster_sg_name" {
  description = "Cluster Security Group name"
  type = string
}

variable "autoscaler_iam_role_name" {
  description = "Autoscaler IAM role name"
  type = string
}

variable "custom_autoscaler_iam_role_name" {
  description = "Custom Autoscaler IAM role name"
  type = string
}

variable "cluster_iam_role_name" {
  description = "Cluster IAM role name"
  type = string
}

variable "subnets" {
  description = "Subnets ie AWS Availability Zones to deploy your EKS"
  type = list
  validation {
    condition = length(var.subnets) >= 3
    error_message = "Use minimum 3 AWS Availability Zones in your EKS cluster!!!"
  }
}