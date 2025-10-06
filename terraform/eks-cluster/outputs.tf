output "cluster_name" {
    description = "EKS Cluster name"
    value = aws_eks_cluster.this.name 
}

output "cluster_endpoint" {
    description = "EKS API endpoint"
    value = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
    description = "Base64 CA data"
    value = aws_eks_cluster.this.certificate_authority[0].data
}

output "vpc_id" {
    description = "VPC id"
    value = module.vpc.vpc_id
}

output "private_subnet" {
    description = "Private subnets"
    value = module.vpc.private_subnets
}

output "public_subnets" {
    description = "Public subnets"
    value = module.vpc.public_subnets
}

output "node_group_name" {
    description = "Managed node group name"
    value = aws_eks_node_group.node_group.node_group_name
}

output "node_role_arn" {
    description = "IAM role arn for nodes"
    value = aws_iam_role.eks_node_role.arn
}