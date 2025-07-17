#!/bin/bash

# Script de teste para demonstrar o tratamento inteligente de códigos de erro
# Simula diferentes cenários de códigos de saída do Axway CLI

# Cores para output
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Testando Tratamento Inteligente de Códigos de Erro${NC}"
echo -e "${CYAN}================================================${NC}"

# Importar o script de tratamento de erros
source scripts/error-handler.sh

# Array de códigos para testar
test_codes=(0 10 12 101 1 2 5 6 7 8 13 15 17 20 25 30 60 63 67 69 64 65 66 70 51 56 57 58 89 99)

echo -e "\n${BLUE}📋 Testando códigos de erro...${NC}"

for code in "${test_codes[@]}"; do
    echo -e "\n${CYAN}--- Testando código: $code ---${NC}"
    
    # Simular o código de saída
    handle_exit_code $code "test"
    
    # Verificar se o tratamento foi bem-sucedido
    if [ $? -eq 0 ]; then
        echo -e "${BLUE}✅ Código $code: BYPASS (não falha o pipeline)${NC}"
    else
        echo -e "${BLUE}❌ Código $code: FALHA (falha o pipeline)${NC}"
    fi
done

echo -e "\n${BLUE}📊 Resumo dos Testes${NC}"
echo -e "${CYAN}===================${NC}"
echo -e "✅ Códigos que NÃO falham o pipeline (BYPASS):"
echo -e "   • 0   - Sucesso"
echo -e "   • 10  - Nenhuma mudança detectada"
echo -e "   • 12  - Pasta de exportação já existe"
echo -e "   • 101 - Certificados expiram em breve (aviso)"
echo -e ""
echo -e "❌ Códigos que FALHAM o pipeline (ERRO REAL):"
echo -e "   • 1-99, 102-104 - Erros de configuração, comunicação, permissão, etc."

echo -e "\n${BLUE}🎯 Cenários de Uso Real${NC}"
echo -e "${CYAN}======================${NC}"

echo -e "\n${BLUE}1. Cenário: API já atualizada${NC}"
echo -e "   Código: 10"
echo -e "   Resultado: ✅ BYPASS - Pipeline continua"
echo -e "   Explicação: API já está atualizada, não há necessidade de mudanças"

echo -e "\n${BLUE}2. Cenário: Erro de conectividade${NC}"
echo -e "   Código: 67"
echo -e "   Resultado: ❌ FALHA - Pipeline para"
echo -e "   Explicação: Login falhou, problema real que precisa ser resolvido"

echo -e "\n${BLUE}3. Cenário: Certificados expiram em breve${NC}"
echo -e "   Código: 101"
echo -e "   Resultado: ✅ BYPASS - Pipeline continua"
echo -e "   Explicação: Aviso importante, mas não impede a operação"

echo -e "\n${BLUE}4. Cenário: Parâmetro obrigatório ausente${NC}"
echo -e "   Código: 5"
echo -e "   Resultado: ❌ FALHA - Pipeline para"
echo -e "   Explicação: Erro de configuração que precisa ser corrigido"

echo -e "\n${BLUE}📚 Para mais informações:${NC}"
echo -e "   Documentação oficial: https://github.com/Axway-API-Management-Plus/apim-cli/wiki/9.6-Error-Codes"
echo -e "   Script de tratamento: scripts/error-handler.sh" 