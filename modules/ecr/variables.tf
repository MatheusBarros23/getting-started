variable "repository_name" {
  description = "Nome do repositório ECR"
  type        = string
}

variable "image_tag_mutability" {
  description = "Mutabilidade das tags de imagem (MUTABLE ou IMMUTABLE)"
  type        = string
  default     = "MUTABLE"
}
variable "force_delete" {
  description = "Whether to force delete the repository even if it contains images"
  type        = bool
  default     = true
}
variable "scan_on_push" {
  description = "Habilitar/desabilitar escaneamento de imagem ao fazer push"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Tipo de criptografia do repositório (AES256 ou KMS)"
  type        = string
  default     = "AES256"
}

variable "image_count_to_keep" {
  description = "Número de imagens a manter no repositório"
  type        = number
  default     = 5
}

variable "tags" {
  description = "Tags para o repositório ECR"
  type        = map(string)
  default     = {}
}
