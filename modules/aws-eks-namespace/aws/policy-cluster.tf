data "aws_iam_policy_document" "cluster_policy" {
  statement {
    sid    = "ClusterInfo"
    effect = "Allow"
    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cluster_policy" {
  name   = "${var.namespace_name}-cluster-policy"
  policy = data.aws_iam_policy_document.cluster_policy.json
}
