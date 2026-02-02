variable "project_name" {
    description = "Project name for tagging"
    type = string
}

variable "k8s_version" {
    description = "Kubernetes version for the EKS cluster"
    type = string
    default = "1.30"
}

variable "public_subnet_ids" {
    description = "List of public subnet ids (for Load Balancers)"
    type = list(string)
}

variable "private_subnet_ids" {
    description = "List of private subnet ids (for Worker Nodes)"
    type = list(string)
}

variable "node_desired_size" {
    description = "Desired number of worker nodes"
    type = number
    default = 2
}

variable "node_max_size" {
    description = "Max number of worker nodes"
    type = number
    default = 3
}

variable "node_min_size" {
    description = "Min number of worker nodes"
    type = number
    default = 1
}

variable "node_instance_types" {
    description = "Instance types for worker nodes"
    type = list(string)
    default = ["t3.medium"]
}