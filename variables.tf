variable "eks_version" {
  description = "EKS version used in your Infrastructure"
  type        = string
  validation {
    condition     = contains(["1.23", "1.24", "1.25", "1.26", "1.27"], var.eks_version)
    error_message = "Your EKS version is depreciated."
  }
}

variable "cidr_block" {
  description = "CIDR block used on new VPC"
  type        = string
}

variable "cluster_name" {
  description = "EKS Cluster name"
}

variable "node_sg_rules" {
  description = "Rules of Node Security Group"
  type = list(object({
    cidr_blocks              = list(string)
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    # source_security_group_id = string
    # self                     = bool
    type                     = string
  }))
  validation {
    condition     = anytrue([for cidr_blocks in var.node_sg_rules[*].cidr_blocks : false if contains(cidr_blocks, "0.0.0.0")])
    error_message = "Not recommended use CIDR block 0.0.0.0/0 on your Security Group Rules as Ingress."
  }
  validation {
    condition     = anytrue([for description in var.node_sg_rules[*].description : description == ""])
    error_message = "Description field not must be empty."
  }
  validation {
    condition     = anytrue([for from_port in var.node_sg_rules[*].from_port : from_port == 0])
    error_message = "Value from_port not must be 0."
  }
  validation {
    condition     = anytrue([for to_port in var.node_sg_rules[*].to_port : to_port == 0])
    error_message = "Value to_port not must be 0."
  }
  validation {
    condition     = anytrue([for protocol in var.node_sg_rules[*].protocol : protocol == "-1"])
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
  validation {
    condition = anytrue([for min_size in var.eks_node_groups[*].min_size : true if min_size > 3])
    error_message = "EKS Node Groups need setting with minimum 3 instances."
  }
  validation {
    condition = alltrue(
      [
        for instance_types in var.eks_node_groups[*].instance_types : [
          for instance_type in instance_types : false if startswith("t2", instance_type)
        ]
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
    default = [
        {
            availability_zone = "us-east-1a"
            newbits = 8
        },
        {
            availability_zone = "us-east-1b"
            newbits = 8
        },
        {
            availability_zone = "us-east-1c"
            newbits = 8
        }
    ]
}

variable "private_subnets" {
    default = [
        {
            availability_zone = "us-east-1a"
            newbits = 5
        },
        {
            availability_zone = "us-east-1b"
            newbits = 5
        },
        {
            availability_zone = "us-east-1c"
            newbits = 5
        }
    ]
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

variable "vpc_tags" {
    default = {
        Name = "MainVPC"
    }
}

variable "public_subnet_tags" {
    default = {
        AccessMode = "PUBLIC"
    }
}

variable "igw_tags" {
    default = {
        Name = "MainIGW"
    }
}

variable "rt_igw_tags" {
    default = {
        Name = "MainIGW"
    }
}

variable "private_subnet_tags" {
    default = {
        AccessMode = "PRIVATE"
    }
}

variable "eip_nat_tags" {
    default = {
        Name = "EIPVpc"
    }
}

variable "nat_gateway_tags" {
    default = {
        Name = "MainNATGateway"
    }
}

variable "rt_nat_tags" {
    default = {
        Name = "MainNATGateway"
    }
}