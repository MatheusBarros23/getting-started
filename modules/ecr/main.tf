# Verifica se o repositório já existe
data "aws_ecr_repository" "existing" {
  count = var.create_if_not_exists ? 1 : 0
  name  = var.repository_name
  
  # Este bloco ignora o erro caso o repositório não exista
  depends_on = [
    # Sem dependências
  ]
}

locals {
  # Determina se é necessário criar o repositório com base no resultado da data source
  repository_exists = try(length(data.aws_ecr_repository.existing) > 0, false)
}

resource "aws_ecr_repository" "app_repository" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
  }

  tags = var.tags
}

# Usa um recurso que já existe ou o recém-criado
locals {
  repository_name = local.repository_exists ? data.aws_ecr_repository.existing[0].name : aws_ecr_repository.app_repository[0].name
  repository_url  = local.repository_exists ? data.aws_ecr_repository.existing[0].repository_url : aws_ecr_repository.app_repository[0].repository_url
}

resource "aws_ecr_lifecycle_policy" "app_lifecycle_policy" {
  repository = aws_ecr_repository.app_repository.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.image_count_to_keep} images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = var.image_count_to_keep
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
