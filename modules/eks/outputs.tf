output "cluster_name" {
  description = "EKS 클러스터 이름"
  value       = aws_eks_cluster.this.name
}


