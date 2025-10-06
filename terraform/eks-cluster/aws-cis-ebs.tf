resource "helm_release" "aws_ebs_csi_driver" {
    name = "aws-ebs-csi-driver"
    namespace = "kube-system"
    repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
    chart = "aws-ebs-csi-driver"
    version = "2.49.1"

    set = [
        {
            name = "controller.serviceAccount.create"
            value = "false"
        },
        {
            name = "controller.serviceAccount.name"
            value = kubernetes_service_account.ebs_csi.metadata[0].name
        }
    ]
}

resource "kubernetes_service_account" "ebs_csi" {
    metadata {
        name = "ebs-csi-controller-sa"
        namespace = "kube-system"
        annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.ebs_csi_driver.arn
        }
    }
}