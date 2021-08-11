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

variable "node_sg_rules" {
  description = "Rules of Node Security Group"
  type = list(object({
    cidr_blocks = list(string)
    description = string
    from_port = number
    to_port = number
    protocol = string
    source_security_group_id = string
    self = string
    type = string
  }))
  default = [{
    cidr_blocks       = ["0.0.0.0/0"]
    description       = "Allow communicate to any IP."
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    source_security_group_id = null
    self = null
    type              = "ingress"
  }]
}

variable "cluster_sg_name" {
  description = "Cluster Security Group name"
  type = string
}

variable "cluster_sg_rules" {
  description = "Rules of Cluster Security Group"
  type = list(object({
    cidr_blocks = list(string)
    description = string
    from_port = number
    to_port = number
    protocol = string
    source_security_group_id = string
    self = string
    type = string
  }))
  default = [{
    cidr_blocks       = ["0.0.0.0/0"]
    description       = "Allow communicate to any IP."
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    source_security_group_id = null
    self = null
    type              = "ingress"
  }]
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

variable "eks_tags" {
  description = "A map of tags to assign to the EKS Cluster."
  type        = map
  default     = {}
  validation {
    condition     = length(var.eks_tags) > 0
    error_message = "Tags from EKS Cluster is empty."
  }
}

variable "load_balancer_tags" {
  description = "A map of tags to assign to the Load Balancer."
  type        = map
  default     = {}
  validation {
    condition     = length(var.load_balancer_tags) > 0
    error_message = "Tags from Load Balancer is empty."
  }
}

variable "associate_public_ip_address" {
  description = "A boolean value to define if will associated public ip address to instances on Launch Configuration."
  type        = bool
  default     = false
}