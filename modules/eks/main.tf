#1 IAM Role for EKS Control Plane
resource "aws_iam_role" "cluster_role" {
    name = "${var.project_name}-eks-cluster-role" 

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "eks.amazonaws.com"
            }
        }]
    })
}

# Attaching required policies to the Control Plane
resource "aws_iam_role_policy_attachment" "cluster_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.cluster_role.name
}

#2 EKS Cluster (Control Plane)
resource "aws_eks_cluster" "main" {
    name = "${var.project_name}-cluster"
    role_arn = aws_iam_role.cluster_role.arn
    version = var.k8s_version

    vpc_config {
        subnet_ids = concat(var.public_subnet_ids,  var.private_subnet_ids)
        endpoint_private_access = true
        endpoint_public_access = true
    }

    depends_on = [
        aws_iam_role_policy_attachment.cluster_policy
    ]
}

#3 OIDC Provider
data "tls_certificate" "eks" {
    url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
    client_id_list = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
    url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

#4 IAM Role for worker nodes
resource "aws_iam_role" "node_role" {
    name = "${var.project_name}-eks-node-role"

    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
    })
}

# Attaching required policies for worker nodes
resource "aws_iam_role_policy_attachment" "worker_node_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "registry_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.node_role.name
}

#5 Managed Node Group (Worker Nodes)
resource "aws_eks_ndoe_group" "main" {
    cluster_name = aws_eks_cluster.main.name
    node_group_name = "${var.project_name}-node-group"
    node_role_arn = aws_iam_role.node_role.arn

    subnet_ids = var.private_subnet_ids

    scaling_config {
        desired_size = var.node_desired_size
        max_size = var.node_max_size
        min_size = var.node_min_size
    }

    instance_types = var.node_instance_types 

    depends_on = [
        aws_iam_role_policy_attachment.worker_node_policy,
        aws_iam_role_policy_attachment.cni_policy,
        aws_iam_role_policy_attachment.registry_policy
    ]
}