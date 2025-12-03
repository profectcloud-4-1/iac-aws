terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    kubectl = {
      source = "alekc/kubectl"
    }
  }
}


# ---------------------------------------
# Otel Gateway Collector
# ---------------------------------------

# Gateway Collector - Logs
resource "kubectl_manifest" "otel_gateway_collector_logs" {
  yaml_body = templatefile("${path.module}/gateway-collector-logs.yaml", {
    namespace          = var.namespace
    image              = var.image
    replicas_logs      = var.replicas_logs
    kafka_brokers      = var.kafka_brokers
    kafka_topic_logs   = var.kafka_topic_logs
    loki_host          = var.loki_host
    cpu_limit_logs     = var.cpu_limit_logs
    memory_limit_logs  = var.memory_limit_logs
    cpu_request_logs   = var.cpu_request_logs
    memory_request_logs = var.memory_request_logs
  })
}

# Gateway Collector - Traces
resource "kubectl_manifest" "otel_gateway_collector_traces" {
  yaml_body = templatefile("${path.module}/gateway-collector-traces.yaml", {
    namespace          = var.namespace
    image              = var.image
    replicas_traces    = var.replicas_traces
    kafka_brokers      = var.kafka_brokers
    kafka_topic_traces = var.kafka_topic_traces
    tempo_host         = var.tempo_host
    deployment_env     = var.deployment_env
    cpu_limit_traces   = var.cpu_limit_traces
    memory_limit_traces = var.memory_limit_traces
    cpu_request_traces = var.cpu_request_traces
    memory_request_traces = var.memory_request_traces
  })
}

# Gateway Collector - Metrics
resource "kubectl_manifest" "otel_gateway_collector_metrics" {
  yaml_body = templatefile("${path.module}/gateway-collector-metrics.yaml", {
    namespace          = var.namespace
    image              = var.image
    replicas_metrics   = var.replicas_metrics
    kafka_brokers      = var.kafka_brokers
    kafka_topic_metrics = var.kafka_topic_metrics
    mimir_host         = var.mimir_host
    cpu_limit_metrics  = var.cpu_limit_metrics
    memory_limit_metrics = var.memory_limit_metrics
    cpu_request_metrics = var.cpu_request_metrics
    memory_request_metrics = var.memory_request_metrics
  })
}

