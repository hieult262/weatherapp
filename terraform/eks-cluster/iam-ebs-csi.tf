resource "aws_iam_policy" "ebs_csi_driver" {
    name = "AmazonEKS_EBS_CSI_Driver_Policy"
    description = "EBS CSI Driver Policy"
    policy = file("./ebs_csi_driver_policy.json")
}

data "aws_iam_policy_document" "ebs_csi_assume_role" {
        statement {
            actions = ["sts:AssumeRoleWithWebIdentity"]

        principals {
            type = "Federated"
            identifiers = [aws_iam_openid_connect_provider.oidc.arn]
        }

        condition {
            test = "StringEquals"
            variable = "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://","")}:sub"
            values = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
        }
    }
}

resource "aws_iam_role" "ebs_csi_driver" { 
    name = "AmazoneEKS_CSI_EBS_DriverRole"
    assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_attach" {
    role = aws_iam_role.ebs_csi_driver.name
    policy_arn = aws_iam_policy.ebs_csi_driver.arn
}