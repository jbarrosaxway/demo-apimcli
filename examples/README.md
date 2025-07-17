# Exemplos de Configuração e Workflows APIM CLI

Este diretório contém exemplos de configuração de API e workflows do GitHub Actions baseados na documentação do [APIM CLI](https://github.com/Axway-API-Management-Plus/apim-cli/wiki/2.1.2-API-Configuration-file).

## Arquivos de Configuração

### 1. API com API Key (`api-with-apikey-config.json`)
Exemplo de configuração de API com autenticação via API Key:
- Configura um perfil de segurança com API Key
- Define o campo `X-API-Key` no header para autenticação
- Inclui monitoramento e CORS padrão

### 2. API com OAuth (`api-with-oauth-config.json`)
Exemplo de configuração de API com autenticação OAuth:
- Configura um perfil de segurança OAuth
- Define o token Bearer no header Authorization
- Usa TokenInfoPolicy para validação de token

### 3. API com Propriedades Customizadas (`api-with-custom-properties-config.json`)
Exemplo de configuração de API com propriedades customizadas:
- Inclui propriedades customizadas para metadados
- Configura organizações clientes
- Define aplicações com permissões

## Workflows do GitHub Actions

### 1. Configure API Security (`configure-api-security.yaml`)
Workflow para configurar segurança de API:
```yaml
uses: ./.github/workflows/configure-api-security.yaml
with:
  config-file: "examples/api-with-apikey-config.json"
  security-type: "api-key"
```

### 2. Manage Organization Permissions (`manage-organization-permissions.yaml`)
Workflow para gerenciar permissões de organizações:
```yaml
uses: ./.github/workflows/manage-organization-permissions.yaml
with:
  config-file: "examples/api-with-apikey-config.json"
  action: "grant"  # ou "revoke"
  organization: "API Development"
```

### 3. Manage Application Subscriptions (`manage-application-subscriptions.yaml`)
Workflow para gerenciar assinaturas de aplicações:
```yaml
uses: ./.github/workflows/manage-application-subscriptions.yaml
with:
  config-file: "examples/api-with-apikey-config.json"
  action: "grant"  # ou "revoke"
  application: "Test Application"
  organization: "API Development"
```

### 4. Manage API Lifecycle (`manage-api-lifecycle.yaml`)
Workflow principal que integra todas as funcionalidades:
```yaml
uses: ./.github/workflows/manage-api-lifecycle.yaml
with:
  config-file: "examples/api-with-apikey-config.json"
  action: "import"  # import, security, permissions, subscriptions
  security-type: "api-key"
  organization: "API Development"
  application: "Test Application"
  permission-action: "grant"
```

## Como Usar

### 1. Importar uma API
```bash
# Via workflow dispatch
gh workflow run manage-api-lifecycle.yaml \
  -f config-file="examples/api-with-apikey-config.json" \
  -f action="import"
```

### 2. Configurar Segurança
```bash
# Configurar API Key
gh workflow run manage-api-lifecycle.yaml \
  -f config-file="examples/api-with-apikey-config.json" \
  -f action="security" \
  -f security-type="api-key"
```

### 3. Conceder Permissão para Organização
```bash
# Conceder permissão
gh workflow run manage-api-lifecycle.yaml \
  -f config-file="examples/api-with-apikey-config.json" \
  -f action="permissions" \
  -f organization="API Development" \
  -f permission-action="grant"
```

### 4. Conceder Permissão para Aplicação
```bash
# Conceder permissão para aplicação
gh workflow run manage-api-lifecycle.yaml \
  -f config-file="examples/api-with-apikey-config.json" \
  -f action="subscriptions" \
  -f organization="API Development" \
  -f application="Test Application" \
  -f permission-action="grant"
```

## Variáveis de Ambiente Necessárias

Certifique-se de que as seguintes variáveis estejam configuradas no seu repositório:

### Secrets
- `APIM_INSTANCE_PASSWORD`: Senha do usuário APIM

### Variables
- `APIM_INSTANCE_IP`: IP da instância APIM
- `APIM_INSTANCE_USER`: Usuário APIM

## Estrutura de Arquivos

```
.github/workflows/
├── import-api.yaml                    # Workflow original de importação
├── update-api.yaml                    # Workflow original de atualização
├── configure-api-security.yaml        # Configurar segurança
├── manage-organization-permissions.yaml # Gerenciar permissões de org
├── manage-application-subscriptions.yaml # Gerenciar assinaturas de app
└── manage-api-lifecycle.yaml          # Workflow principal integrado

examples/
├── README.md                          # Esta documentação
├── api-with-apikey-config.json        # Exemplo com API Key
├── api-with-oauth-config.json         # Exemplo com OAuth
└── api-with-custom-properties-config.json # Exemplo com props customizadas
``` 