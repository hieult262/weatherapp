# AWS /general
variable "aws_region" {
    description = "AWS region"
    type = string
    default = "ap-southeast-1"
}

variable "aws_profile" {
    description = "AWS CLI Profile name (optinal)"
    type = string
    default = ""
}

variable "cluster_name" {
    description = "EKS cluster name"
    type =  string
    default = "demo-eks"
}

#VPC
variable "vpc_cidr" {
    description = "VPC CIDR block"
    type = string
    default = "172.0.0.0/23"
}

variable "azs" {
    description = "AZs to use"
    type = list(string)
    default = []
}

variable "public_subnets" {
    description = "Public subnet CIDRs"
    type = list(string)
    default = []
}

variable "private_subnets" {
    description = "Private subnet CIRDs"
    type = list(string)
    default = []
}

variable "enable_nat_gateway" {
    description = "Enable NAT Gateway"
    type = bool
    default = true 
}

variable "single_nat_gateway" {
    description = "In 1 AZ"
    type = bool
    default = true
}

variable "enable_s3_gateway" {
    description = "Enable S3 Gateway"
    type = bool
    default = false
}

variable "enable_dns_hostnames" {
    description = "Enable DNS hostnames"
    type = bool
    default = true
}

variable "enable_dns_resolution" {
    description = "Enable DNS resolution"
    type = bool
    default = true
}

# Node group
variable "node_instance_type" {
    description = "EC2 instance type for node"
    type = string
    default = "t2.micro"
}

variable "node_desired_capacity" {
    description = "Desired number of worker nodes"
    type = number
    default = 2
}

variable "node_min_capacity" {
    description = "Min number of worker nodes"
    type = number
    default = 1
}

variable "node_max_capacity" {
    description = "Max number of worker nodes"
    type = number
    default = 3
}

# Tags 
variable "environment" {
    description = "Environment tag"
    type = string
    default = "dev"
}

#ALB
variable "vpc_id"{
    description = "ID VPC"
    type = string
    default = ""
}