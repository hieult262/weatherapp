# IAM policy for AWS Load Balancer Controller
resource "aws_iam_policy" "alb_controller" { 
    name = "${var.cluster_name}-AWSLoadBalancerControllerIAMPolicy"
    description = "Policy for AWS Load Balancer Controller"
    policy = file("./iam_policy.json")
}

# IAM role for service account
data "aws_iam_policy_document" "alb_assume_role" {
    statement {
        actions = ["sts:AssumeRoleWithWebIdentity"]

        principals {
            type = "Federated"
            identifiers = [aws_iam_openid_connect_provider.oidc.arn]
        }

        condition {
            test = "StringEquals"
            variable = "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://","")}:sub"
            values = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
        }
    }
}

resource "aws_iam_role" "alb_controller" { 
    name = "${var.cluster_name}-alb-controller-role"
    assume_role_policy = data.aws_iam_policy_document.alb_assume_role.json
}

resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
    role = aws_iam_role.alb_controller.name
    policy_arn = aws_iam_policy.alb_controller.arn
}