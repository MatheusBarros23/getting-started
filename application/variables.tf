variable "region" {
  description = "AWS region onde os recursos serão criados"
  type        = string
  default     = "eu-central-1"
}

variable "cluster_name" {
  description = "Nome do cluster EKS existente"
  type        = string
  default     = "eksDeepDiveFrankfurt"
}

# Variáveis para o node group
variable "node_group_name" {
  description = "Nome do node group"
  type        = string
  default     = "node-groups-03"
}

variable "create_node_role" {
  description = "Se deve criar um novo IAM role para o node group"
  type        = bool
  default     = true
}

variable "node_role_arn" {
  description = "ARN de um IAM role existente para o node group (usado se create_node_role = false)"
  type        = string
  default     = ""
}

variable "node_desired_size" {
  description = "Quantidade desejada de nós no node group"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Quantidade máxima de nós no node group"
  type        = number
  default     = 4
}

variable "node_min_size" {
  description = "Quantidade mínima de nós no node group"
  type        = number
  default     = 1
}

variable "node_instance_types" {
  description = "Lista de tipos de instância para o node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_capacity_type" {
  description = "Tipo de capacidade para o node group (ON_DEMAND ou SPOT)"
  type        = string
  default     = "ON_DEMAND"
}

variable "node_disk_size" {
  description = "Tamanho do disco em GB para os nós"
  type        = number
  default     = 20
}

variable "node_ami_type" {
  description = "Tipo de AMI para os nós"
  type        = string
  default     = "AL2_x86_64"
}

variable "node_taints" {
  description = "Lista de taints a serem aplicados aos nós"
  type        = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default     = []
}

variable "node_labels" {
  description = "Mapa de labels Kubernetes a serem aplicados aos nós"
  type        = map(string)
  default     = {}
}

variable "max_unavailable_percentage" {
  description = "Porcentagem máxima de nós indisponíveis durante atualizações"
  type        = number
  default     = 25
}

variable "tags" {
  description = "Tags a serem aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}

# Variáveis para ECR
variable "ecr_repository_name" {
  description = "Nome do repositório ECR"
  type        = string
  default     = "todo-app-03-ecr"
}

# Variáveis para a aplicação
variable "app_image" {
  description = "Imagem Docker da aplicação"
  type        = string
  default     = "matheusprb/getting-started:latest"
}

variable "app_image_tag" {
  description = "Tag da imagem Docker da aplicação no ECR"
  type        = string
  default     = "latest"
}

variable "use_ecr_image" {
  description = "Se deve usar a imagem do ECR"
  type        = bool
  default     = true
}

variable "app_port" {
  description = "Porta da aplicação"
  type        = number
  default     = 3000
}

variable "app_replicas" {
  description = "Número de réplicas da aplicação"
  type        = number
  default     = 2
}

variable "cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  type        = string
  default     = ""
}

variable "cluster_certificate_authority_data" {
  description = "Certificado de autoridade do cluster EKS"
  type        = string
  default     = ""
  sensitive   = true
}
