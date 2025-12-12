variable "vpc_cidr"{
    description = "VPC CIDR Range"
    type = string
}

variable "subnets"{
    description = "Subnet CIDR"
    type = list(string)
}