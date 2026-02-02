variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    type = string
}

variable "project_name" {
    description = "Name of the Project"
    type = string
}

variable "environment" {
    description = "Environment name (dev, prod)"
    type = string
}

variable "public_subnet_cidr" {
    description = "List of public subnet CIDRs"
    type = list(string)
}

variable "private_subnet_cidr" {
    description = "List of private subnet CIDRs"
    type = list(string)
}

variable "availability_zones" {
    description = "List of availability zones"
    type = list(string)
}