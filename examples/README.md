# Exemplos de Configuração e Workflows APIM CLI

Este diretório contém exemplos de configuração de API e workflows do GitHub Actions baseados na documentação do [APIM CLI](https://github.com/Axway-API-Management-Plus/apim-cli/wiki/2.1.2-API-Configuration-file).

## Arquivos de Configuração e Swagger

### 1. API com API Key
- **Configuração:** `api-with-apikey-config.json`
- **Swagger:** `api-with-apikey-openapi.json`
- **Funcionalidades:**
  - Configura um perfil de segurança com API Key
  - Define o campo `X-API-Key` no header para autenticação
  - Inclui monitoramento e CORS padrão
  - Endpoints seguros e públicos

### 2. API com OAuth
- **Configuração:** `api-with-oauth-config.json`
- **Swagger:** `api-with-oauth-openapi.json`
- **Funcionalidades:**
  - Configura um perfil de segurança OAuth
  - Define o token Bearer no header Authorization
  - Usa TokenInfoPolicy para validação de token
  - Endpoints para perfil e configurações de usuário

### 3. API com Propriedades Customizadas
- **Configuração:** `api-with-custom-properties-config.json`
- **Swagger:** `api-with-custom-props-openapi.json`
- **Funcionalidades:**
  - Inclui propriedades customizadas para metadados
  - Configura organizações clientes
  - Define aplicações com permissões
  - Endpoints para dados e metadados

### 4. API Completa (Petstore)
- **Configuração:** `api-complete-config.yaml`
- **Swagger:** `petstore-openapi30.json`
- **Funcionalidades:**
  - Configuração completa com quotas, certificados e políticas
  - API Petstore com endpoints para pets e usuários
  - Configuração em formato YAML

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

### 5. Manual API Deploy (`manual-api-deploy.yaml`)
Workflow manual para deploy de API específica:
```yaml
# Via GitHub CLI
gh workflow run manual-api-deploy.yaml \
  -f config-file="examples/api-with-apikey-config.json" \
  -f force-update=false

# Via GitHub Web Interface
# Actions > Manual API Deploy > Run workflow
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

### 5. Deploy Manual de API
```bash
# Deploy normal (import se não existir, update se existir)
gh workflow run manual-api-deploy.yaml \
  -f config-file="examples/api-with-apikey-config.json"

# Forçar update (sempre atualizar)
gh workflow run manual-api-deploy.yaml \
  -f config-file="examples/api-with-apikey-config.json" \
  -f force-update=true
```

## Variáveis de Ambiente Necessárias

Certifique-se de que as seguintes variáveis estejam configuradas no seu repositório:

### Ambiente DEMO
Todos os workflows estão configurados para usar o ambiente `DEMO`. Configure as seguintes variáveis neste ambiente:

#### Secrets (Settings > Secrets and variables > Actions > Environments > DEMO > Secrets)
- `APIM_INSTANCE_PASSWORD`: Senha do usuário APIM

#### Variables (Settings > Secrets and variables > Actions > Environments > DEMO > Variables)
- `APIM_INSTANCE_IP`: IP da instância APIM
- `APIM_INSTANCE_USER`: Usuário APIM

### Como Configurar o Ambiente DEMO
1. Vá para **Settings > Secrets and variables > Actions**
2. Clique em **Environments**
3. Clique em **DEMO** (ou crie se não existir)
4. Configure as **Variables** e **Secrets** listadas acima

## Estrutura de Arquivos

```
.github/workflows/
├── import-api.yaml                    # Workflow original de importação
├── update-api.yaml                    # Workflow original de atualização
├── configure-api-security.yaml        # Configurar segurança
├── manage-organization-permissions.yaml # Gerenciar permissões de org
├── manage-application-subscriptions.yaml # Gerenciar assinaturas de app
├── manage-api-lifecycle.yaml          # Workflow principal integrado
└── manual-api-deploy.yaml             # Deploy manual de API específica

examples/
├── README.md                          # Esta documentação
├── demo-script.sh                     # Script de demonstração
├── api-complete-config.yaml           # Configuração completa (YAML)
├── petstore-openapi30.json            # Swagger Petstore
├── api-with-apikey-config.json        # Configuração com API Key
├── api-with-apikey-openapi.json       # Swagger com API Key
├── api-with-oauth-config.json         # Configuração com OAuth
├── api-with-oauth-openapi.json        # Swagger com OAuth
├── api-with-custom-properties-config.json # Configuração com props customizadas
└── api-with-custom-props-openapi.json # Swagger com props customizadas
```

## Funcionalidades Avançadas

### Detecção Automática de Mudanças
O workflow `update-api.yaml` agora detecta automaticamente:
- **Mudanças em arquivos de configuração** → Processa diretamente
- **Mudanças em arquivos Swagger** → Encontra configurações relacionadas e processa
- **Suporte a JSON e YAML** → Usa `jq` para JSON e `yq` para YAML

### Exemplo de Fluxo
1. Desenvolvedor modifica `api-with-apikey-openapi.json`
2. Workflow detecta a mudança no Swagger
3. Workflow encontra `api-with-apikey-config.json` que referencia este Swagger
4. Workflow verifica se a API existe e decide entre update ou import
5. API é atualizada/importada automaticamente 