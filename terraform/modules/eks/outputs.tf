output "cluster_endpoint"         { value = aws_eks_cluster.main.endpoint }
output "cluster_ca"               { value = aws_eks_cluster.main.certificate_authority[0].data }
output "node_security_group_id"   { value = data.aws_security_group.node.id }
output "node_role_arn"            { value = aws_iam_role.node.arn }
output "cluster_oidc_issuer_url"  { value = aws_eks_cluster.main.identity[0].oidc[0].issuer }