# Guia de Implementação do Pipeline CI/CD com ECR

Este guia explica as modificações necessárias para implementar o pipeline CI/CD com o repositório ECR, como solicitado na atividade.

## 1. Estrutura de Arquivos

Sua estrutura final deve ser algo assim:

```
├── .github/
│   └── workflows/
│       └── ci-cd.yml
│       └── destroy.yml
├── app/
│   ├── Dockerfile
│   ├── package.json
│   └── ... (arquivos da aplicação)
├── application/
│   ├── main.tf         (Atualizado para usar o ECR)
│   ├── outputs.tf      (Atualizado com outputs do ECR)
│   ├── provider.tf     (Sem alterações)
│   └── variables.tf    (Atualizado com variáveis para ECR)
└── modules/
    ├── ecr/
    │   ├── main.tf     (Novo módulo para criar o ECR)
    │   ├── outputs.tf  (Saídas do módulo ECR)
    │   └── variables.tf (Variáveis do módulo ECR)
    └── kubernetes-app/ (Sem alterações)
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

## 2. Principais Alterações

1. **Criação do Módulo ECR**: Um novo módulo para criar e gerenciar o repositório ECR.

2. **Atualização do Terraform**: 
   - Adicionado o módulo ECR ao main.tf
   - Adicionadas novas variáveis para controlar o uso da imagem do ECR
   - Adicionados outputs relacionados ao ECR

3. **Ajustes no workflow CI/CD**:
   - O workflow agora constrói a imagem a partir do diretório app/
   - Utiliza o nome do repositório ECR criado pelo Terraform
   - Passa as variáveis corretas para o Terraform

4. **Verificação do Dockerfile**:
   - Garantimos que o Dockerfile está correto e usa o comando adequado

## 3. Passos para Configuração

1. **Configurar Secrets do GitHub**:
   - Adicione os secrets `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY` no seu repositório GitHub

2. **Commit e Push**:
   - Faça commit e push das alterações para o repositório
   - O workflow será acionado automaticamente na branch master

3. **Verificar a execução**:
   - Acesse a aba "Actions" no GitHub para monitorar a execução do workflow
   - Verifique no console AWS se o repositório ECR foi criado corretamente
   - Verifique se a aplicação foi implantada no cluster EKS

## 4. Como Funciona o Pipeline

1. **Fase de Build**:
   - O código é clonado do repositório
   - A imagem Docker é construída
   - A imagem é enviada para o repositório ECR

2. **Fase de Deploy**:
   - O Terraform é inicializado
   - O Terraform aplica as configurações, criando o repositório ECR se necessário
   - O Terraform atualiza o deployment Kubernetes para usar a nova imagem

3. **Fase de Verificação**:
   - kubectl é usado para verificar o status do deployment
   - A URL da aplicação é extraída e exibida

## 5. Solução de Problemas

Se encontrar problemas durante a execução:

1. **Erro no ECR**: Verifique as permissões do usuário IAM
2. **Erro no Terraform**: Verifique os logs para identificar o problema específico
3. **Erro no Kubernetes**: Use kubectl para investigar o status dos pods
