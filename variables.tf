variable "eks_version" {
  description = "EKS version used in your Infrastructure"
  type        = string
  validation {
    condition     = contains(["1.23", "1.24", "1.25", "1.26", "1.27"], var.eks_version)
    error_message = "Your EKS version is depreciated."
  }
}

variable "cidr_block" {
  default = "10.51.0.0/16"
  description = "CIDR block used on new VPC"
  type = string
}

variable "cluster_name" {
  description = "EKS Cluster name"
}

variable "eks_node_groups" {
    default = [
        {
            desired_size = 1
            max_size     = 3
            min_size     = 1
            name         = "general-purpose"
            instance_types = ["t3.large", "t3.xlarge"]
        },
        # {
        #     desired_size = 1
        #     max_size     = 3
        #     min_size     = 1
        #     name         = "arm-based"
        #     instance_types = ["t4g.large", "t4g.xlarge"]
        # },
        {
            desired_size = 1
            max_size     = 3
            min_size     = 1
            name         = "latest-gen-general-purpose"
            instance_types = ["m5.xlarge"]
        }
    ]
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