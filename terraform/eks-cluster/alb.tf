resource "helm_release" "aws_load_balancer_controller" {
    name = "aws-load-balancer-controller"
    repository = "https://aws.github.io/eks-charts"
    chart = "aws-load-balancer-controller"
    namespace = "kube-system"
    version = "1.13.4"

    set = [
        {
            name = "clusterName"
            value = aws_eks_cluster.this.name
        },

        {
            name = "serviceAccount.create"
            value = "false"
        },

        {
            name = "serviceAccount.name"
            value = "aws-load-balancer-controller"
        },

        {
            name = "region"
            value = var.aws_region
        },

        { 
            name = "vpcId"
            value = module.vpc.vpc_id
        }
    ]
}

resource "kubernetes_service_account" "alb_controller" {
    metadata {
        name = "aws-load-balancer-controller"
        namespace = "kube-system"
        annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller.arn
        }
    }
}