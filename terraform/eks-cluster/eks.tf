# EKS cluster (control plane)
resource "aws_eks_cluster" "this" {
    name = var.cluster_name
    role_arn = aws_iam_role.eks_cluster_role.arn
    version = "1.33"

    vpc_config {
        subnet_ids = module.vpc.private_subnets
    }

    # OIDC provider for IRSA (service-account IAM)
    depends_on = [
        aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
        aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController,
    ]
}

# Create an OIDC provider to allow IRSA
data "aws_eks_cluster" "this" { 
    name = aws_eks_cluster.this.name
    depends_on = [aws_eks_cluster.this]
}

data "aws_eks_cluster_auth" "this"{
    name = aws_eks_cluster.this.name
}

resource "aws_iam_openid_connect_provider" "oidc" {
    url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
    client_id_list = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.oidc_cert.certificates[0].sha1_fingerprint]
    depends_on = [aws_eks_cluster.this]
}

# tls_certificate to compute thumbprint
data "tls_certificate" "oidc_cert" {
    url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# EKS Managed Node Group
resource "aws_eks_node_group" "node_group" {
    cluster_name = aws_eks_cluster.this.name
    node_group_name = "${var.cluster_name}-ng"
    node_role_arn = aws_iam_role.eks_node_role.arn
    subnet_ids = module.vpc.private_subnets

    scaling_config {
        desired_size = var.node_desired_capacity
        max_size = var.node_max_capacity
        min_size = var.node_min_capacity
    }

    instance_types = [var.node_instance_type]

    depends_on = [
        aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
        aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    ]
}