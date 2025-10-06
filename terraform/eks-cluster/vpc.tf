module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.8.1"

    name = "${var.cluster_name}-vpc"
    cidr = var.vpc_cidr

    azs = length(var.azs) > 0 ? var.azs : null
    public_subnets = length(var.public_subnets) > 0 ? var.public_subnets : null
    private_subnets = length(var.private_subnets) > 0 ? var.private_subnets : null

    enable_nat_gateway = var.enable_nat_gateway
    single_nat_gateway = var.single_nat_gateway

    tags = {
        Name =  "${var.cluster_name}-vpc"
        Environment = var.environment
        Terraform = "true"
    }
}