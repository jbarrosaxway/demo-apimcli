#!/bin/bash

# Script para importar API no Axway API Manager
# Uso: ./scripts/import-api.sh <config-file>

set -e

# Verificar se o arquivo de configuração foi fornecido
if [ $# -eq 0 ]; then
    echo "❌ Erro: Arquivo de configuração não fornecido"
    echo "Uso: ./scripts/import-api.sh <config-file>"
    echo "Exemplo: ./scripts/import-api.sh examples/APIs/api-location-config.yaml"
    exit 1
fi

CONFIG_FILE="$1"
DOCKER_IMAGE="bvieira123/apim-cli:1.14.4"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Iniciando importação de API no Axway API Manager...${NC}"

# Verificar se o arquivo existe
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}❌ Arquivo de configuração não encontrado: $CONFIG_FILE${NC}"
    exit 1
fi

# Verificar se o Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker não está rodando. Inicie o Docker e tente novamente.${NC}"
    exit 1
fi

# Verificar se as variáveis de ambiente estão definidas
if [ -z "$APIM_INSTANCE_IP" ] || [ -z "$APIM_INSTANCE_USER" ] || [ -z "$APIM_INSTANCE_PASSWORD" ]; then
    echo -e "${YELLOW}⚠️  Variáveis de ambiente não encontradas. Usando valores padrão.${NC}"
    echo -e "${YELLOW}   Defina APIM_INSTANCE_IP, APIM_INSTANCE_USER e APIM_INSTANCE_PASSWORD se necessário.${NC}"
    
    # Valores padrão (substitua pelos seus)
    APIM_INSTANCE_IP=${APIM_INSTANCE_IP:-"44.195.43.239"}
    APIM_INSTANCE_USER=${APIM_INSTANCE_USER:-"apiadmin"}
    APIM_INSTANCE_PASSWORD=${APIM_INSTANCE_PASSWORD:-"changeme"}
fi

echo -e "${YELLOW}📁 Arquivo de configuração: $CONFIG_FILE${NC}"
echo -e "${YELLOW}🔗 Conectando ao Axway API Manager: $APIM_INSTANCE_IP${NC}"

# Extrair informações do arquivo de configuração
if [[ "$CONFIG_FILE" == *.yaml ]] || [[ "$CONFIG_FILE" == *.yml ]]; then
    # Use yq for YAML files
    API_NAME=$(yq -r '.name' "$CONFIG_FILE")
    API_PATH=$(yq -r '.path' "$CONFIG_FILE")
    API_VERSION=$(yq -r '.version' "$CONFIG_FILE")
else
    # Use jq for JSON files
    API_NAME=$(jq -r '.name' "$CONFIG_FILE")
    API_PATH=$(jq -r '.path' "$CONFIG_FILE")
    API_VERSION=$(jq -r '.version' "$CONFIG_FILE")
fi

echo -e "${YELLOW}📋 API: $API_NAME (v$API_VERSION)${NC}"
echo -e "${YELLOW}🛣️  Path: $API_PATH${NC}"

# Executar importação
echo -e "${YELLOW}📤 Importando API...${NC}"
docker run --rm \
  -e LOG_LEVEL=DEBUG \
  -v "$(pwd):/workspace" \
  "$DOCKER_IMAGE" \
  apim api import \
  -h "$APIM_INSTANCE_IP" \
  -u "$APIM_INSTANCE_USER" \
  -port 8075 \
  -p "$APIM_INSTANCE_PASSWORD" \
  -c "/workspace/$CONFIG_FILE"

# Capture the exit code
EXIT_CODE=$?

# Handle exit codes: 0 = success, 10 = no changes (also success)
if [ $EXIT_CODE -eq 0 ] || [ $EXIT_CODE -eq 10 ]; then
    if [ $EXIT_CODE -eq 10 ]; then
        echo -e "${GREEN}✅ API importada com sucesso - Nenhuma mudança detectada (código 10)${NC}"
        echo -e "${BLUE}ℹ️  A API já estava atualizada no API Manager${NC}"
    else
        echo -e "${GREEN}✅ API importada com sucesso!${NC}"
    fi
    
    echo -e "\n${BLUE}📊 Resumo da importação:${NC}"
    echo -e "  Nome: $API_NAME"
    echo -e "  Versão: $API_VERSION"
    echo -e "  Path: $API_PATH"
    echo -e "  Status: ✅ Ativa no API Manager"
    
else
    echo -e "${RED}❌ Erro na importação da API (código: $EXIT_CODE)${NC}"
    echo -e "${YELLOW}💡 Verifique:${NC}"
    echo -e "  - Credenciais do API Manager"
    echo -e "  - Conectividade de rede"
    echo -e "  - Configuração da API"
    echo -e "  - Logs do container Docker"
    exit $EXIT_CODE
fi

echo -e "\n${GREEN}🎉 Processo concluído!${NC}" 