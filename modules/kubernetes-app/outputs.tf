output "deployment_name" {
  description = "Nome do deployment criado"
  value       = kubernetes_deployment.app.metadata[0].name
}

output "service_name" {
  description = "Nome do serviço criado"
  value       = kubernetes_service.app.metadata[0].name
}

output "load_balancer_hostname" {
  description = "Hostname do Load Balancer (se aplicável)"
  value       = try(kubernetes_service.app.status.0.load_balancer.0.ingress.0.hostname, "N/A")
}