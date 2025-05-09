output "repository_url" {
  description = "URL do repositório ECR"
  value       = aws_ecr_repository.app_repository.repository_url
}

output "repository_arn" {
  description = "ARN do repositório ECR"
  value       = aws_ecr_repository.app_repository.arn
}

output "repository_name" {
  description = "Nome do repositório ECR"
  value       = aws_ecr_repository.app_repository.name
}

output "repository_registry_id" {
  description = "ID do registro do repositório ECR"
  value       = aws_ecr_repository.app_repository.registry_id
}