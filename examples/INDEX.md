# Índice da Estrutura de Exemplos

## 📁 Estrutura de Pastas

```
examples/
├── 📋 INDEX.md                    # Este arquivo
├── 📖 README.md                   # Documentação completa
├── 🚀 demo-script.sh              # Script de demonstração
├── 🏢 Orgs/                       # Definições de organizações
├── 📱 Apps/                       # Definições de aplicações
├── 🔌 APIs/                       # Definições de APIs
└── 📄 OAS/                        # Arquivos Swagger/OpenAPI
```

## 🏢 Organizações (Orgs/)

| Arquivo | Nome | Descrição | Email |
|---------|------|-----------|-------|
| `api-development-org.json` | API Development | Organização para desenvolvimento e testes | admin@apidev.com |
| `external-partners-org.json` | External Partners | Organização para parceiros externos | partners@company.com |
| `production-org.json` | Production | Organização para APIs de produção | prod@company.com |

## 📱 Aplicações (Apps/)

| Arquivo | Nome | Organização | Descrição |
|---------|------|-------------|-----------|
| `test-application-app.json` | Test Application | API Development | Aplicação para desenvolvimento e testes |
| `partner-app.json` | Partner App | External Partners | Aplicação para integrações de parceiros |
| `production-app.json` | Production App | Production | Aplicação para serviços de produção |

## 🔌 APIs (APIs/)

| Arquivo | Nome | Organização | Aplicação | Tipo de Segurança |
|---------|------|-------------|-----------|-------------------|
| `api-with-apikey-config.json` | API with API Key Security | API Development | Test Application | API Key |
| `api-with-oauth-config.json` | API with OAuth Security | API Development | Test Application | OAuth |
| `api-with-custom-properties-config.json` | API with Custom Properties | API Development | Test Application | API Key |
| `api-complete-config.yaml` | Petstore API | orga | Test App 2008 | API Key |
| `partner-api-config.json` | Partner Integration API | External Partners | Partner App | Partner Token |
| `production-api-config.json` | Production API | Production | Production App | OAuth2 |

## 📄 Arquivos OpenAPI (OAS/)

| Arquivo | API Correspondente | Descrição |
|---------|-------------------|-----------|
| `api-with-apikey-openapi.json` | API with API Key Security | Endpoints com autenticação API Key |
| `api-with-oauth-openapi.json` | API with OAuth Security | Endpoints com autenticação OAuth |
| `api-with-custom-props-openapi.json` | API with Custom Properties | Endpoints com propriedades customizadas |
| `petstore-openapi30.json` | Petstore API | API Petstore completa |
| `partner-api-openapi.json` | Partner Integration API | Endpoints para integrações de parceiros |
| `production-api-openapi.json` | Production API | Endpoints para serviços de produção |

## 🔗 Correlações por Ambiente

### 🧪 Ambiente de Desenvolvimento
```
Orgs/api-development-org.json
    ↓
Apps/test-application-app.json
    ↓
APIs/api-with-apikey-config.json
APIs/api-with-oauth-config.json
APIs/api-with-custom-properties-config.json
    ↓
OAS/api-with-apikey-openapi.json
OAS/api-with-oauth-openapi.json
OAS/api-with-custom-props-openapi.json
```

### 🤝 Ambiente de Parceiros
```
Orgs/external-partners-org.json
    ↓
Apps/partner-app.json
    ↓
APIs/partner-api-config.json
    ↓
OAS/partner-api-openapi.json
```

### 🚀 Ambiente de Produção
```
Orgs/production-org.json
    ↓
Apps/production-app.json
    ↓
APIs/production-api-config.json
    ↓
OAS/production-api-openapi.json
```

## 🚀 Comandos de Setup por Ambiente

### Desenvolvimento
```bash
# Usando parâmetros manuais
gh workflow run setup-environment.yaml \
  -f org-name="API Development" \
  -f app-name="Test Application" \
  -f config-file="examples/APIs/api-with-apikey-config.json"

# Usando arquivos de configuração
gh workflow run setup-from-files.yaml \
  -f org-file="examples/Orgs/api-development-org.json" \
  -f app-file="examples/Apps/test-application-app.json" \
  -f api-file="examples/APIs/api-with-apikey-config.json"
```

### Parceiros
```bash
# Usando parâmetros manuais
gh workflow run setup-environment.yaml \
  -f org-name="External Partners" \
  -f app-name="Partner App" \
  -f config-file="examples/APIs/partner-api-config.json"

# Usando arquivos de configuração
gh workflow run setup-from-files.yaml \
  -f org-file="examples/Orgs/external-partners-org.json" \
  -f app-file="examples/Apps/partner-app.json" \
  -f api-file="examples/APIs/partner-api-config.json"
```

### Produção
```bash
# Usando parâmetros manuais
gh workflow run setup-environment.yaml \
  -f org-name="Production" \
  -f app-name="Production App" \
  -f config-file="examples/APIs/production-api-config.json"

# Usando arquivos de configuração
gh workflow run setup-from-files.yaml \
  -f org-file="examples/Orgs/production-org.json" \
  -f app-file="examples/Apps/production-app.json" \
  -f api-file="examples/APIs/production-api-config.json"
```

## 📚 Documentação

- **README.md**: Documentação completa com exemplos de uso
- **demo-script.sh**: Script de demonstração dos workflows
- **Workflows**: Localizados em `.github/workflows/`

## 🔄 Fluxo de Trabalho

1. **Criar Organização** → `Orgs/*.json`
2. **Criar Aplicação** → `Apps/*.json`
3. **Deploy API** → `APIs/*.json` + `OAS/*.json`

Use o workflow `setup-environment.yaml` para executar automaticamente nesta ordem. 