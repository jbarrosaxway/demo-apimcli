#!/bin/bash

# Script de demonstração para usar os workflows do APIM CLI
# Baseado nos exemplos da documentação: https://github.com/Axway-API-Management-Plus/apim-cli/wiki/2.1.2-API-Configuration-file

set -e

echo "🚀 Demonstração dos Workflows APIM CLI"
echo "======================================"

# Configurações
CONFIG_FILE="examples/APIs/api-with-apikey-config.json"
ORGANIZATION="API Development"
APPLICATION="Test Application"

# Função para executar workflow
run_workflow() {
    local action=$1
    local extra_params=$2
    
    echo "📋 Executando workflow: $action"
    echo "Comando: gh workflow run manage-api-lifecycle.yaml -f config-file=\"$CONFIG_FILE\" -f action=\"$action\" $extra_params"
    
    # Descomente a linha abaixo para executar realmente
    # gh workflow run manage-api-lifecycle.yaml -f config-file="$CONFIG_FILE" -f action="$action" $extra_params
    
    echo "✅ Workflow $action executado com sucesso!"
    echo ""
}

# 1. Importar API
echo "1️⃣ Importando API..."
run_workflow "import"

# 2. Configurar Segurança com API Key
echo "2️⃣ Configurando segurança com API Key..."
run_workflow "security" "-f security-type=\"api-key\""

# 3. Conceder Permissão para Organização
echo "3️⃣ Concedendo permissão para organização..."
run_workflow "permissions" "-f organization=\"$ORGANIZATION\" -f permission-action=\"grant\""

# 4. Conceder Permissão para Aplicação
echo "4️⃣ Concedendo permissão para aplicação..."
run_workflow "subscriptions" "-f organization=\"$ORGANIZATION\" -f application=\"$APPLICATION\" -f permission-action=\"grant\""

# 5. Revogar Permissão (exemplo)
echo "5️⃣ Revogando permissão da aplicação (exemplo)..."
run_workflow "subscriptions" "-f organization=\"$ORGANIZATION\" -f application=\"$APPLICATION\" -f permission-action=\"revoke\""

echo "🎉 Demonstração concluída!"
echo ""
echo "📝 Para executar os comandos reais, descomente as linhas 'gh workflow run' no script."
echo "📚 Consulte o README.md para mais informações sobre os workflows." 