variable "eks_version" {
  description = "EKS version used in your Infrastructure"
  type        = string
  default     = ""
  validation {
    condition     = contains(["1.23", "1.24", "1.25", "1.26", "1.27"], var.eks_version)
    error_message = "Your EKS version is depreciated."
  }
}

variable "cidr_block" {
  description = "CIDR block used on new VPC"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "EKS Cluster name"
  default     = ""
}

variable "node_sg_rules" {
  description = "Rules of Node Security Group"
  type = list(object({
    name                     = optional(string, "")
    cidr_blocks              = list(string)
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    # source_security_group_id = string
    # self                     = bool
    type                     = string
  }))
  default = []
  validation {
    condition     = anytrue([for rule in var.node_sg_rules : !contains(rule.cidr_blocks, "0.0.0.0")])
    error_message = "Not recommended use CIDR block 0.0.0.0/0 on your Security Group Rules as Ingress."
  }
  validation {
    condition     = anytrue([for rule in var.node_sg_rules : rule.description != ""])
    error_message = "Description field not must be empty."
  }
  validation {
    condition     = anytrue([for rule in var.node_sg_rules : rule.from_port == 0])
    error_message = "Value from_port not must be 0."
  }
  validation {
    condition     = anytrue([for rule in var.node_sg_rules : rule.to_port == 0])
    error_message = "Value to_port not must be 0."
  }
  validation {
    condition     = anytrue([for rule in var.node_sg_rules : rule.protocol == "-1"])
    error_message = "Value protocol not must be '-1'."
  }
}

variable "eks_node_groups" {
  description = "EKS Node Groups"
  type = list(object({
    desired_size = number
    name = string
    min_size = number
    max_size = number
    instance_types = list(string)
  }))
  default = [
        {
            desired_size = 1
            max_size     = 3
            min_size     = 3
            name         = "general-purpose"
            instance_types = ["t3.large", "t3.xlarge"]
        },
        {
            desired_size = 1
            max_size     = 3
            min_size     = 3
            name         = "latest-gen-general-purpose"
            instance_types = ["m5.xlarge"]
        }
    ]
  validation {
    condition = anytrue([for node_group in var.eks_node_groups : node_group.min_size >= 3])
    error_message = "EKS Node Groups need setting with minimum 3 instances."
  }
  validation {
    condition = anytrue(
      [
        for node_group in var.eks_node_groups : anytrue([
          for instance_type in node_group.instance_types : !startswith("t2", instance_type)
        ])
      ]
    )
    error_message = "Your EKS cluster is using T2 class of EC2."
  }
}

variable "key_pair_name" {
  description = "Key pair name used on EKS workers"
  type = string
}

variable "public_subnets" {
  description = "Public Subnets"
  type = list(object({
    availability_zone = string
    newbits           = number
  }))
  default = []
  validation {
    condition = length(var.public_subnets) > 2
    error_message = "Your EKS cluster not is Multi AZ. Use 3 avaibility zones at least."
  }
}

variable "private_subnets" {
  description = "Public Subnets"
  type = list(object({
    availability_zone = string
    newbits           = number
  }))
  default = []
  validation {
    condition = length(var.private_subnets) > 2
    error_message = "Your EKS cluster not is Multi AZ. Use 3 avaibility zones at least."
  }
}

variable "tags" {
  description = "A map of tags to assign to the EKS Cluster."
  type        = map
  default     = {}
  validation {
    condition     = length(var.tags) > 0
    error_message = "Tags from EKS Cluster is empty."
  }
}

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

variable "grafana_chart_url" {
  default = "https://prometheus-community.github.io/helm-charts"
  type    = string
}