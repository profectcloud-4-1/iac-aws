terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    kubectl = {
      source = "alekc/kubectl"
    }
  }
}



# ---------------------------------------
# ServiceAccount for AWS Load Balancer Controller (IRSA)
# ---------------------------------------
resource "kubernetes_service_account" "alb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.alb_controller_role_arn
    }
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
  }
}

# ---------------------------------------
# AWS Load Balancer Controller (Helm) - use precreated SA
# ---------------------------------------
resource "helm_release" "aws_load_balancer_controller" {
  name              = "aws-load-balancer-controller"
  repository        = "https://aws.github.io/eks-charts"
  chart             = "aws-load-balancer-controller"
  namespace         = "kube-system"
  create_namespace  = false
  dependency_update = true
  wait              = true
  timeout           = 120
  atomic            = true

  values = [
    yamlencode({
      clusterName = var.cluster_name
      region      = "ap-northeast-2"
      vpcId       = var.vpc_id
      serviceAccount = {
        create = false
        name   = kubernetes_service_account.alb_controller.metadata[0].name
      }
    })
  ]

  depends_on = [kubernetes_service_account.alb_controller]
}

# Ingress
resource "kubectl_manifest" "ingress" {
  yaml_body = <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: goorm-ingress
  namespace: goormdotcom-prod
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}]'
    alb.ingress.kubernetes.io/group.name: external-main

    alb.ingress.kubernetes.io/healthcheck-path: /actuator/health
    alb.ingress.kubernetes.io/healthcheck-port: "8080"
    alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
spec:
  ingressClassName: alb
  rules:
    - http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: auth-gateway
                port:
                  number: 8080

}
EOF
}


# ---------------------------------------
# Ingress (ALB)
# ---------------------------------------
resource "kubernetes_ingress_v1" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "observability"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"       = "internet-facing",
      "alb.ingress.kubernetes.io/target-type"  = "ip",
      "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\":80}]",
      "alb.ingress.kubernetes.io/group.name"   = "external-main",
      "alb.ingress.kubernetes.io/group.order"  = "10"

      "alb.ingress.kubernetes.io/healthcheck-path"     = "/login"
      "alb.ingress.kubernetes.io/healthcheck-port"     = "80"
      "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP"
    }
  }
  spec {
    ingress_class_name = "alb"
    rule {
      http {
        path {
          path      = "/grafana"
          path_type = "Prefix"
          backend {
            service {
              name = "grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_service_account.alb_controller]
}

