variable "app_name" {
  description = "Nome da aplicação"
  type        = string
  default     = "todo-app-03"
}

variable "app_image" {
  description = "Imagem Docker da aplicação"
  type        = string
}

variable "app_port" {
  description = "Porta da aplicação"
  type        = number
}

variable "app_replicas" {
  description = "Número de réplicas"
  type        = number
  default     = 2
}

variable "resource_limits_cpu" {
  description = "Limite de CPU"
  type        = string
  default     = "0.5"
}

variable "resource_limits_memory" {
  description = "Limite de memória"
  type        = string
  default     = "512Mi"
}

variable "resource_requests_cpu" {
  description = "Requisição de CPU"
  type        = string
  default     = "0.2"
}

variable "resource_requests_memory" {
  description = "Requisição de memória"
  type        = string
  default     = "256Mi"
}

variable "service_type" {
  description = "Tipo do serviço Kubernetes"
  type        = string
  default     = "LoadBalancer"
}

variable "service_port" {
  description = "Porta do serviço"
  type        = number
  default     = 80
}