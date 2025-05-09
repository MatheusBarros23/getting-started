provider "aws" {
  region = var.region
}

# Obtenha informações sobre o cluster EKS existente
data "aws_eks_cluster" "existing" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "existing" {
  name = var.cluster_name
}

# Configuração do provider Kubernetes para interagir com o cluster
provider "kubernetes" {
  host                   = data.aws_eks_cluster.existing.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.existing.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.existing.token
}

locals {
  cluster_subnet_ids = data.aws_eks_cluster.existing.vpc_config[0].subnet_ids
}

# Obtenha as subnets privadas da VPC do cluster
data "aws_vpc" "eks_vpc" {
  id = data.aws_eks_cluster.existing.vpc_config[0].vpc_id
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

# Criar um IAM role para o node group (opcional, pode usar um existente)
resource "aws_iam_role" "node_group_role" {
  count = var.create_node_role ? 1 : 0
  name  = "${var.cluster_name}-${var.node_group_name}-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = var.tags
}

# Anexar políticas ao IAM role
resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  count      = var.create_node_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group_role[0].name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  count      = var.create_node_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group_role[0].name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  count      = var.create_node_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group_role[0].name
}

# Criar o node group no cluster existente
resource "aws_eks_node_group" "application" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.create_node_role ? aws_iam_role.node_group_role[0].arn : var.node_role_arn
  subnet_ids      = local.cluster_subnet_ids

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  instance_types = var.node_instance_types
  capacity_type  = var.node_capacity_type
  disk_size      = var.node_disk_size
  ami_type       = var.node_ami_type

  # Taints opcionais
  dynamic "taint" {
    for_each = var.node_taints
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  # Configurações do ciclo de vida
  update_config {
    max_unavailable_percentage = var.max_unavailable_percentage
  }

  tags = merge(
    var.tags,
    {
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  )

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}

module "ecr_repository" {
  source = "../modules/ecr"

  repository_name = var.ecr_repository_name
  tags            = var.tags
}

module "kubernetes_app" {
  source = "../modules/kubernetes-app"

  app_name    = "todo-app-03"
  app_image   = var.app_image
  app_port    = var.app_port
  app_replicas = var.app_replicas
  
  depends_on = [aws_eks_node_group.application]
}