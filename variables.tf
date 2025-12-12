variable "vpc_cidr"{
    type = string
    description = "VPC CIDR Range"
}

variable "subnets"{
    description = "Subnet CIDR"
    type = list(string)
}