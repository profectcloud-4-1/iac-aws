terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_msk_configuration" "this" {
  name           = "${var.cluster_name}-config"
  kafka_versions = [var.kafka_version]

  server_properties = <<PROPS
allow.everyone.if.no.acl.found=${var.allow_everyone_if_no_acl_found}
PROPS
}

resource "aws_msk_cluster" "this" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.broker_count
  enhanced_monitoring    = var.enhanced_monitoring

  configuration_info {
    arn      = aws_msk_configuration.this.arn
    revision = aws_msk_configuration.this.latest_revision
  }

  broker_node_group_info {
    instance_type   = var.instance_type
    client_subnets  = var.subnet_ids
    security_groups = var.security_group_ids

    storage_info {
      ebs_storage_info {
        volume_size = var.ebs_volume_size
      }
    }
  }

  client_authentication {
    sasl {
      iam   = true
      scram = true
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS" # 클라이언트-브로커 간 TLS만 허용
      in_cluster    = true
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.enable_broker_logs_cloudwatch
        log_group = var.enable_broker_logs_cloudwatch ? var.broker_logs_cloudwatch_log_group : null
      }
    }
  }
}

resource "aws_msk_scram_secret_association" "this" {
  count           = length(var.scram_secret_arns) > 0 ? 1 : 0
  cluster_arn     = aws_msk_cluster.this.arn
  secret_arn_list = var.scram_secret_arns
}
