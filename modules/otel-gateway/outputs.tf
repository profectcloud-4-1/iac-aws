output "gateway_collector_logs_name" {
  description = "Gateway Collector Logs 이름"
  value       = "otel-gateway-logs"
}

output "gateway_collector_traces_name" {
  description = "Gateway Collector Traces 이름"
  value       = "otel-gateway-traces"
}

output "gateway_collector_metrics_name" {
  description = "Gateway Collector Metrics 이름"
  value       = "otel-gateway-metrics"
}

output "gateway_collector_namespace" {
  description = "Gateway Collector 네임스페이스"
  value       = var.namespace
}

