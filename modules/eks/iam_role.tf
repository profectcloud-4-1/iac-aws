############################
# EKS IAM Roles and Policies
############################

########################
# Cluster Role (Control Plane)
########################
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-cluster-role"
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_vpc_resource_controller" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role_policy" "eks_cluster_autonomous_instance_profile" {
  name = "${var.cluster_name}-autonomous-instance-profile"
  role = aws_iam_role.eks_cluster_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "iam:CreateInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile"
        ],
        Resource = "*"
      }
    ]
  })
}

########################
# Node Role (Managed Node Group / EC2)
########################
resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-node-role"
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_role_ecr_pullonly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

resource "aws_iam_role_policy_attachment" "eks_node_role_worker_node_minimal" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
}

########################
# VPC CNI Addon IRSA Role (aws-node)
########################
resource "aws_iam_role" "eks_cni_irsa_role" {
  count = var.enable_irsa_cni ? 1 : 0

  name = "${var.cluster_name}-cni-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "pods.eks.amazonaws.com"
      },
      Action = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }]
  })

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-cni-irsa-role"
  })
}

resource "aws_iam_role_policy_attachment" "eks_cni_irsa_policy" {
  count = var.enable_irsa_cni ? 1 : 0

  role       = aws_iam_role.eks_cni_irsa_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


