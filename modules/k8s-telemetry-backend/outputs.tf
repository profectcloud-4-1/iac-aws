output "namespace" {
  description = "배포된 네임스페이스"
  value       = var.namespace
}

output "s3_buckets" {
  description = "텔레메트리 S3 버킷들"
  value = {
    loki  = var.s3_bucket_loki
    tempo = var.s3_bucket_tempo
    mimir = var.s3_bucket_mimir
  }
}

output "service_accounts" {
  description = "각 컴포넌트의 ServiceAccount 이름"
  value = {
    loki  = "loki"
    tempo = "tempo"
    mimir = "mimir"
  }
}

output "helm_release_names" {
  description = "설치된 Helm 릴리스 이름"
  value = {
    loki  = helm_release.loki.name
    tempo = helm_release.tempo.name
    # mimir = helm_release.mimir.name
  }
}

output "loki_host" {
  description = "Loki in-cluster DNS 호스트 (포트 제외)"
  value       = "loki.${var.namespace}.svc.cluster.local"
}

output "tempo_host" {
  description = "Tempo in-cluster DNS 호스트 (포트 제외, distributor)"
  value       = "tempo-distributor.${var.namespace}.svc.cluster.local"
}

output "mimir_host" {
  description = "Mimir in-cluster DNS 호스트 (포트 제외, nginx/gateway)"
  value       = "mimir-nginx.${var.namespace}.svc.cluster.local"
}
