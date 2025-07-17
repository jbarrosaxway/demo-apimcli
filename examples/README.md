# Exemplos de Configuração e Workflows APIM CLI

Este diretório contém exemplos de configuração organizados em uma estrutura clara e correlacionada, baseados na documentação do [APIM CLI](https://github.com/Axway-API-Management-Plus/apim-cli/wiki/2.1.2-API-Configuration-file).

## Estrutura de Pastas

```
examples/
├── Orgs/                    # Definições de organizações
│   ├── api-development-org.json
│   ├── external-partners-org.json
│   └── production-org.json
├── Apps/                    # Definições de aplicações
│   ├── test-application-app.json
│   ├── partner-app.json
│   └── production-app.json
├── APIs/                    # Definições de APIs
│   ├── api-with-apikey-config.json
│   ├── api-with-oauth-config.json
│   ├── api-with-custom-properties-config.json
│   ├── api-complete-config.yaml
│   ├── partner-api-config.json
│   └── production-api-config.json
├── OAS/                     # Arquivos Swagger/OpenAPI
│   ├── api-with-apikey-openapi.json
│   ├── api-with-oauth-openapi.json
│   ├── api-with-custom-props-openapi.json
│   ├── petstore-openapi30.json
│   ├── partner-api-openapi.json
│   └── production-api-openapi.json
├── README.md                # Esta documentação
└── demo-script.sh           # Script de demonstração
```

## Correlações entre Arquivos

### 1. Ambiente de Desenvolvimento
- **Organização:** `Orgs/api-development-org.json` → "API Development"
- **Aplicação:** `Apps/test-application-app.json` → "Test Application" (na org "API Development")
- **APIs:**
  - `APIs/api-with-apikey-config.json` → Usa "API Development" + "Test Application"
  - `APIs/api-with-oauth-config.json` → Usa "API Development" + "Test Application"
  - `APIs/api-with-custom-properties-config.json` → Usa "API Development" + "Test Application"

### 2. Ambiente de Parceiros
- **Organização:** `Orgs/external-partners-org.json` → "External Partners"
- **Aplicação:** `Apps/partner-app.json` → "Partner App" (na org "External Partners")
- **API:** `APIs/partner-api-config.json` → Usa "External Partners" + "Partner App"

### 3. Ambiente de Produção
- **Organização:** `Orgs/production-org.json` → "Production"
- **Aplicação:** `Apps/production-app.json` → "Production App" (na org "Production")
- **API:** `APIs/production-api-config.json` → Usa "Production" + "Production App"

## Arquivos de Configuração e Swagger

### APIs de Desenvolvimento

#### 1. API com API Key
- **Configuração:** `APIs/api-with-apikey-config.json`
- **Swagger:** `OAS/api-with-apikey-openapi.json`
- **Organização:** API Development
- **Aplicação:** Test Application
- **Funcionalidades:**
  - Configura um perfil de segurança com API Key
  - Define o campo `X-API-Key` no header para autenticação
  - Inclui monitoramento e CORS padrão
  - Endpoints seguros e públicos

#### 2. API com OAuth
- **Configuração:** `APIs/api-with-oauth-config.json`
- **Swagger:** `OAS/api-with-oauth-openapi.json`
- **Organização:** API Development
- **Aplicação:** Test Application
- **Funcionalidades:**
  - Configura um perfil de segurança OAuth
  - Define o token Bearer no header Authorization
  - Usa TokenInfoPolicy para validação de token
  - Endpoints para perfil e configurações de usuário

#### 3. API com Propriedades Customizadas
- **Configuração:** `APIs/api-with-custom-properties-config.json`
- **Swagger:** `OAS/api-with-custom-props-openapi.json`
- **Organização:** API Development
- **Aplicação:** Test Application
- **Funcionalidades:**
  - Inclui propriedades customizadas para metadados
  - Configura organizações clientes
  - Define aplicações com permissões
  - Endpoints para dados e metadados

#### 4. API Completa (Petstore)
- **Configuração:** `APIs/api-complete-config.yaml`
- **Swagger:** `OAS/petstore-openapi30.json`
- **Funcionalidades:**
  - Configuração completa com quotas, certificados e políticas
  - API Petstore com endpoints para pets e usuários
  - Configuração em formato YAML

### APIs de Parceiros

#### 5. Partner Integration API
- **Configuração:** `APIs/partner-api-config.json`
- **Swagger:** `OAS/partner-api-openapi.json`
- **Organização:** External Partners
- **Aplicação:** Partner App
- **Funcionalidades:**
  - Autenticação via Partner Token (X-Partner-Token)
  - Endpoints para integrações de parceiros
  - Gestão de status de integrações

### APIs de Produção

#### 6. Production API
- **Configuração:** `APIs/production-api-config.json`
- **Swagger:** `OAS/production-api-openapi.json`
- **Organização:** Production
- **Aplicação:** Production App
- **Funcionalidades:**
  - Autenticação OAuth2 para produção
  - Endpoints para serviços de produção
  - Health check para monitoramento
  - Gestão de status de serviços

## Workflows do GitHub Actions

### 1. Configure API Security (`configure-api-security.yaml`)
Workflow para configurar segurança de API:
```yaml
uses: ./.github/workflows/configure-api-security.yaml
with:
  config-file: "examples/APIs/api-with-apikey-config.json"
  security-type: "api-key"
```

### 2. Manage Organization Permissions (`manage-organization-permissions.yaml`)
Workflow para gerenciar permissões de organizações:
```yaml
uses: ./.github/workflows/manage-organization-permissions.yaml
with:
  config-file: "examples/APIs/api-with-apikey-config.json"
  action: "grant"  # ou "revoke"
  organization: "API Development"
```

### 3. Manage Application Subscriptions (`manage-application-subscriptions.yaml`)
Workflow para gerenciar assinaturas de aplicações:
```yaml
uses: ./.github/workflows/manage-application-subscriptions.yaml
with:
  config-file: "examples/APIs/api-with-apikey-config.json"
  action: "grant"  # ou "revoke"
  application: "Test Application"
  organization: "API Development"
```

### 4. Manage API Lifecycle (`manage-api-lifecycle.yaml`)
Workflow principal que integra todas as funcionalidades:
```yaml
uses: ./.github/workflows/manage-api-lifecycle.yaml
with:
  config-file: "examples/APIs/api-with-apikey-config.json"
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
  -f config-file="examples/APIs/api-with-apikey-config.json" \
  -f force-update=false

# Via GitHub Web Interface
# Actions > Manual API Deploy > Run workflow
```

### 6. Manage Organizations (`manage-organizations.yaml`)
Workflow para gerenciar organizações:
```yaml
# Via GitHub CLI
gh workflow run manage-organizations.yaml \
  -f action="create" \
  -f org-name="API Development" \
  -f org-description="Organization for API Development"

# Via GitHub Web Interface
# Actions > Manage Organizations > Run workflow
```

### 7. Manage Applications (`manage-applications.yaml`)
Workflow para gerenciar aplicações:
```yaml
# Via GitHub CLI
gh workflow run manage-applications.yaml \
  -f action="create" \
  -f app-name="Test Application" \
  -f org-name="API Development"

# Via GitHub Web Interface
# Actions > Manage Applications > Run workflow
```

### 8. Setup Environment (`setup-environment.yaml`)
Workflow principal que executa na ordem correta:
```yaml
# Via GitHub CLI
gh workflow run setup-environment.yaml \
  -f org-name="API Development" \
  -f app-name="Test Application" \
  -f config-file="examples/APIs/api-with-apikey-config.json"

# Via GitHub Web Interface
# Actions > Setup Environment > Run workflow
```

### 9. Setup Environment from Files (`setup-from-files.yaml`)
Workflow que lê configurações diretamente dos arquivos JSON:
```yaml
# Via GitHub CLI
gh workflow run setup-from-files.yaml \
  -f org-file="examples/Orgs/api-development-org.json" \
  -f app-file="examples/Apps/test-application-app.json" \
  -f api-file="examples/APIs/api-with-apikey-config.json"

# Via GitHub Web Interface
# Actions > Setup Environment from Files > Run workflow
```

## Como Usar

### 1. Setup Completo do Ambiente de Desenvolvimento
```bash
# Setup completo: Organization -> Application -> API
gh workflow run setup-environment.yaml \
  -f org-name="API Development" \
  -f app-name="Test Application" \
  -f config-file="examples/APIs/api-with-apikey-config.json"
```

### 2. Setup do Ambiente de Parceiros
```bash
# Criar organização e aplicação de parceiros
gh workflow run setup-environment.yaml \
  -f org-name="External Partners" \
  -f app-name="Partner App" \
  -f config-file="examples/APIs/partner-api-config.json"
```

### 3. Setup do Ambiente de Produção
```bash
# Criar organização e aplicação de produção
gh workflow run setup-environment.yaml \
  -f org-name="Production" \
  -f app-name="Production App" \
  -f config-file="examples/APIs/production-api-config.json"
```

### 4. Setup usando Arquivos de Configuração
```bash
# Setup usando arquivos JSON das organizações e aplicações
gh workflow run setup-from-files.yaml \
  -f org-file="examples/Orgs/api-development-org.json" \
  -f app-file="examples/Apps/test-application-app.json" \
  -f api-file="examples/APIs/api-with-apikey-config.json"

# Setup apenas organização e aplicação (sem API)
gh workflow run setup-from-files.yaml \
  -f org-file="examples/Orgs/external-partners-org.json" \
  -f app-file="examples/Apps/partner-app.json" \
  -f skip-api=true
```

### 5. Importar uma API
```bash
# Via workflow dispatch
gh workflow run manage-api-lifecycle.yaml \
  -f config-file="examples/APIs/api-with-apikey-config.json" \
  -f action="import"
```

### 6. Configurar Segurança
```bash
# Configurar API Key
gh workflow run manage-api-lifecycle.yaml \
  -f config-file="examples/APIs/api-with-apikey-config.json" \
  -f action="security" \
  -f security-type="api-key"
```

### 7. Conceder Permissão para Organização
```bash
# Conceder permissão
gh workflow run manage-api-lifecycle.yaml \
  -f config-file="examples/APIs/api-with-apikey-config.json" \
  -f action="permissions" \
  -f organization="API Development" \
  -f permission-action="grant"
```

### 8. Conceder Permissão para Aplicação
```bash
# Conceder permissão para aplicação
gh workflow run manage-api-lifecycle.yaml \
  -f config-file="examples/APIs/api-with-apikey-config.json" \
  -f action="subscriptions" \
  -f organization="API Development" \
  -f application="Test Application" \
  -f permission-action="grant"
```

### 9. Deploy Manual de API
```bash
# Deploy normal (import se não existir, update se existir)
gh workflow run manual-api-deploy.yaml \
  -f config-file="examples/APIs/api-with-apikey-config.json"

# Forçar update (sempre atualizar)
gh workflow run manual-api-deploy.yaml \
  -f config-file="examples/APIs/api-with-apikey-config.json" \
  -f force-update=true
```

### 10. Gerenciar Organizações
```bash
# Criar organização
gh workflow run manage-organizations.yaml \
  -f action="create" \
  -f org-name="API Development" \
  -f org-description="Organization for API Development"

# Atualizar organização
gh workflow run manage-organizations.yaml \
  -f action="update" \
  -f org-name="API Development" \
  -f org-description="Updated description"

# Deletar organização
gh workflow run manage-organizations.yaml \
  -f action="delete" \
  -f org-name="API Development"
```

### 11. Gerenciar Aplicações
```bash
# Criar aplicação
gh workflow run manage-applications.yaml \
  -f action="create" \
  -f app-name="Test Application" \
  -f org-name="API Development"

# Atualizar aplicação
gh workflow run manage-applications.yaml \
  -f action="update" \
  -f app-name="Test Application" \
  -f org-name="API Development" \
  -f app-state="approved"

# Deletar aplicação
gh workflow run manage-applications.yaml \
  -f action="delete" \
  -f app-name="Test Application" \
  -f org-name="API Development"
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
├── manual-api-deploy.yaml             # Deploy manual de API específica
├── manage-organizations.yaml          # Gerenciar organizações
├── manage-applications.yaml           # Gerenciar aplicações
├── setup-environment.yaml             # Setup completo do ambiente
└── setup-from-files.yaml              # Setup usando arquivos de configuração

examples/
├── README.md                          # Esta documentação
├── demo-script.sh                     # Script de demonstração
├── Orgs/                              # Definições de organizações
│   ├── api-development-org.json
│   ├── external-partners-org.json
│   └── production-org.json
├── Apps/                              # Definições de aplicações
│   ├── test-application-app.json
│   ├── partner-app.json
│   └── production-app.json
├── APIs/                              # Definições de APIs
│   ├── api-with-apikey-config.json
│   ├── api-with-oauth-config.json
│   ├── api-with-custom-properties-config.json
│   ├── api-complete-config.yaml
│   ├── partner-api-config.json
│   └── production-api-config.json
└── OAS/                               # Arquivos Swagger/OpenAPI
    ├── api-with-apikey-openapi.json
    ├── api-with-oauth-openapi.json
    ├── api-with-custom-props-openapi.json
    ├── petstore-openapi30.json
    ├── partner-api-openapi.json
    └── production-api-openapi.json
```

## Funcionalidades Avançadas

### Detecção Automática de Mudanças
O workflow `update-api.yaml` agora detecta automaticamente:
- **Mudanças em arquivos de configuração** → Processa diretamente
- **Mudanças em arquivos Swagger** → Encontra configurações relacionadas e processa
- **Suporte a JSON e YAML** → Usa `jq` para JSON e `yq` para YAML

### Exemplo de Fluxo
1. Desenvolvedor modifica `OAS/api-with-apikey-openapi.json`
2. Workflow detecta a mudança no Swagger
3. Workflow encontra `APIs/api-with-apikey-config.json` que referencia este Swagger
4. Workflow verifica se a API existe e decide entre update ou import
5. API é atualizada/importada automaticamente

### Ordem de Execução Recomendada
Para garantir que as dependências sejam criadas na ordem correta:

1. **Organization** → Criar organização primeiro
2. **Application** → Criar aplicação na organização
3. **API** → Deploy da API com referências corretas

Use o workflow `setup-environment.yaml` para executar automaticamente nesta ordem.

## Exemplos de Uso por Ambiente

### Desenvolvimento
```bash
# Setup completo do ambiente de desenvolvimento
gh workflow run setup-environment.yaml \
  -f org-name="API Development" \
  -f app-name="Test Application" \
  -f config-file="examples/APIs/api-with-apikey-config.json"
```

### Parceiros
```bash
# Setup do ambiente de parceiros
gh workflow run setup-environment.yaml \
  -f org-name="External Partners" \
  -f app-name="Partner App" \
  -f config-file="examples/APIs/partner-api-config.json"
```

### Produção
```bash
# Setup do ambiente de produção
gh workflow run setup-environment.yaml \
  -f org-name="Production" \
  -f app-name="Production App" \
  -f config-file="examples/APIs/production-api-config.json"
``` 