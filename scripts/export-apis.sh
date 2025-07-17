#!/bin/bash

# Script para exportar APIs do Axway API Manager
# Uso: ./scripts/export-apis.sh

set -e

# Configurações
EXPORT_DIR="exported-apis"
DOCKER_IMAGE="bvieira123/apim-cli:1.14.4"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Iniciando exportação de APIs do Axway API Manager...${NC}"

# Verificar se o Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker não está rodando. Inicie o Docker e tente novamente.${NC}"
    exit 1
fi

# Criar diretório de exportação
echo -e "${YELLOW}📁 Criando diretório de exportação...${NC}"
mkdir -p "$EXPORT_DIR"

# Verificar se as variáveis de ambiente estão definidas
if [ -z "$APIM_INSTANCE_IP" ] || [ -z "$APIM_INSTANCE_USER" ] || [ -z "$APIM_INSTANCE_PASSWORD" ]; then
    echo -e "${YELLOW}⚠️  Variáveis de ambiente não encontradas. Usando valores padrão.${NC}"
    echo -e "${YELLOW}   Defina APIM_INSTANCE_IP, APIM_INSTANCE_USER e APIM_INSTANCE_PASSWORD se necessário.${NC}"
    
    # Valores padrão (substitua pelos seus)
    APIM_INSTANCE_IP=${APIM_INSTANCE_IP:-"44.195.43.239"}
    APIM_INSTANCE_USER=${APIM_INSTANCE_USER:-"apiadmin"}
    APIM_INSTANCE_PASSWORD=${APIM_INSTANCE_PASSWORD:-"changeme"}
fi

echo -e "${YELLOW}🔗 Conectando ao Axway API Manager: $APIM_INSTANCE_IP${NC}"

# Executar exportação
echo -e "${YELLOW}📤 Exportando APIs...${NC}"
docker run --rm \
  -v "$(pwd)/$EXPORT_DIR:/opt/apim-cli" \
  "$DOCKER_IMAGE" \
  apim api get \
  -h "$APIM_INSTANCE_IP" \
  -u "$APIM_INSTANCE_USER" \
  -port 8075 \
  -p "$APIM_INSTANCE_PASSWORD" \
  -o yaml

# Verificar se a exportação foi bem-sucedida
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Exportação concluída com sucesso!${NC}"
    
    # Listar APIs exportadas
    echo -e "${YELLOW}📋 APIs exportadas:${NC}"
    if [ -d "$EXPORT_DIR" ] && [ "$(ls -A $EXPORT_DIR)" ]; then
        for dir in "$EXPORT_DIR"/*/; do
            if [ -d "$dir" ]; then
                echo -e "  📁 $(basename "$dir")"
            fi
        done
        
        echo -e "\n${YELLOW}📊 Resumo:${NC}"
        echo -e "  Total de APIs: $(find $EXPORT_DIR -maxdepth 1 -type d | wc -l)"
        echo -e "  Localização: $(pwd)/$EXPORT_DIR"
        
        # Mostrar estrutura de uma API como exemplo
        echo -e "\n${YELLOW}📄 Estrutura de exemplo (primeira API):${NC}"
        first_api=$(find "$EXPORT_DIR" -maxdepth 1 -type d | head -2 | tail -1)
        if [ -n "$first_api" ]; then
            echo -e "  $(basename "$first_api"):"
            find "$first_api" -type f | head -5 | sed 's/^/    /'
        fi
    else
        echo -e "${YELLOW}⚠️  Nenhuma API foi exportada.${NC}"
    fi
else
    echo -e "${RED}❌ Erro na exportação das APIs.${NC}"
    exit 1
fi

echo -e "\n${GREEN}🎉 Processo concluído!${NC}" 