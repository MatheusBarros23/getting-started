output "deployment_name" {
  description = "Nome do deployment criado"
  value       = module.kubernetes_app.deployment_name
}

output "service_name" {
  description = "Nome do serviço criado"
  value       = module.kubernetes_app.service_name
}

output "load_balancer_hostname" {
  description = "Hostname do Load Balancer (se aplicável)"
  value       = module.kubernetes_app.load_balancer_hostname
}

output "app_url" {
  description = "URL da aplicação"
  value       = "http://${module.kubernetes_app.load_balancer_hostname}"
}

output "node_group_arn" {
  description = "ARN do node group"
  value       = aws_eks_node_group.application.arn
}

output "node_group_id" {
  description = "ID do node group"
  value       = aws_eks_node_group.application.id
}

output "node_group_status" {
  description = "Status do node group"
  value       = aws_eks_node_group.application.status
}

output "node_group_resources" {
  description = "Lista de recursos autoscaling criados para o node group"
  value       = aws_eks_node_group.application.resources
}

output "node_role_arn" {
  description = "ARN do IAM role para os nós"
  value       = var.create_node_role ? aws_iam_role.node_group_role[0].arn : var.node_role_arn
}

output "node_role_name" {
  description = "Nome do IAM role para os nós"
  value       = var.create_node_role ? aws_iam_role.node_group_role[0].name : null
}

# Outputs ECR
output "ecr_repository_url" {
  description = "URL do repositório ECR"
  value       = module.ecr_repository.repository_url
}

output "ecr_repository_arn" {
  description = "ARN do repositório ECR"
  value       = module.ecr_repository.repository_arn
}

output "ecr_repository_name" {
  description = "Nome do repositório ECR"
  value       = module.ecr_repository.repository_name
}