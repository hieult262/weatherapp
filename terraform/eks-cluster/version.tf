terraform {
    required_version = ">= 1.13.1"

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = ">= 4.60.0"
        }

        kubernetes = {
            source = "hashicorp/kubernetes"
            version = ">=2.10"
        }
    }
}