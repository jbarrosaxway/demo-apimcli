# Exportação de APIs do Axway API Manager

Este projeto inclui ferramentas para exportar APIs do Axway API Manager para arquivos locais.

## Métodos de Exportação

### 1. Workflow GitHub Actions (Recomendado)

O workflow `.github/workflows/export-apis.yaml` executa automaticamente:

- **Manual**: Via GitHub Actions → Workflows → export-apis → Run workflow
- **Automático**: Diariamente às 2h da manhã
- **Artifacts**: Os arquivos exportados ficam disponíveis como artifacts por 30 dias

#### Como usar:
1. Vá para a aba "Actions" no GitHub
2. Selecione "export-apis"
3. Clique em "Run workflow"
4. Após a execução, baixe os artifacts "exported-apis" e "export-summary"

### 2. Script Local

Use o script `scripts/export-apis.sh` para exportação local:

#### Pré-requisitos:
- Docker instalado e rodando
- Acesso ao Axway API Manager

#### Como usar:

```bash
# Com variáveis de ambiente
export APIM_INSTANCE_IP="44.195.43.239"
export APIM_INSTANCE_USER="apiadmin"
export APIM_INSTANCE_PASSWORD="changeme"
./scripts/export-apis.sh

# Ou com valores padrão (substitua pelos seus)
./scripts/export-apis.sh
```

#### Comando Docker direto:

```bash
# Criar diretório para exportação
mkdir -p exported-apis

# Executar exportação
docker run --rm \
  -v "$(pwd)/exported-apis:/opt/apim-cli" \
  bvieira123/apim-cli:1.14.4 \
  apim api get \
  -h "44.195.43.239" \
  -u "apiadmin" \
  -port 8075 \
  -p "changeme" \
  -o yaml
```

## Estrutura dos Arquivos Exportados

Cada API exportada cria uma pasta com:

```
exported-apis/
├── api-name-1/
│   ├── api-config.yaml          # Configuração da API
│   ├── api-specification.yaml   # Especificação OpenAPI/Swagger
│   └── ...
├── api-name-2/
│   ├── api-config.yaml
│   ├── api-specification.yaml
│   └── ...
└── ...
```

## Formato de Exportação

- **Formato**: YAML (mais legível que JSON)
- **Conteúdo**: 
  - Configuração completa da API
  - Especificação OpenAPI/Swagger
  - Políticas de segurança
  - Configurações de proxy
  - Aplicações e organizações

## Configurações

### Variáveis de Ambiente

```bash
APIM_INSTANCE_IP=44.195.43.239
APIM_INSTANCE_USER=apiadmin
APIM_INSTANCE_PASSWORD=changeme
```

### Parâmetros do Comando

- `-h`: Host/IP do API Manager
- `-u`: Usuário
- `-port`: Porta (padrão: 8075)
- `-p`: Senha
- `-o`: Formato de saída (yaml/json)

## Troubleshooting

### Docker não está rodando
```bash
# Iniciar Docker
sudo systemctl start docker
# ou
sudo service docker start
```

### Erro de conexão
- Verificar se o IP e credenciais estão corretos
- Verificar se a porta 8075 está acessível
- Verificar firewall/segurança de rede

### Erro de permissão
```bash
# Dar permissão de execução ao script
chmod +x scripts/export-apis.sh
```

## Exemplo de Uso

```bash
# 1. Clone o repositório
git clone <repo-url>
cd github-actions-poc

# 2. Configure as variáveis (opcional)
export APIM_INSTANCE_IP="seu-ip"
export APIM_INSTANCE_USER="seu-usuario"
export APIM_INSTANCE_PASSWORD="sua-senha"

# 3. Execute a exportação
./scripts/export-apis.sh

# 4. Verifique os arquivos exportados
ls -la exported-apis/
```

## Integração com CI/CD

O workflow GitHub Actions pode ser integrado com:

- **Backup automático**: Exportação diária das APIs
- **Versionamento**: Commit automático dos arquivos exportados
- **Notificações**: Slack/Email quando novas APIs são detectadas
- **Análise**: Comparação entre versões para detectar mudanças 