#!/bin/bash

# Script para tratamento inteligente de códigos de erro do Axway API Management CLI
# Baseado na documentação oficial: https://github.com/Axway-API-Management-Plus/apim-cli/wiki/9.6-Error-Codes

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Função para tratar códigos de erro
handle_exit_code() {
    local exit_code=$1
    local operation=$2  # "import", "update", "export", etc.
    
    echo -e "\n${CYAN}🔍 Analisando código de saída: $exit_code${NC}"
    
    case $exit_code in
        0)
            echo -e "${GREEN}✅ Sucesso! Operação $operation concluída com êxito.${NC}"
            return 0
            ;;
        
        # === CÓDIGOS QUE NÃO SÃO ERROS (BYPASS) ===
        10)
            echo -e "${GREEN}✅ Sucesso! Nenhuma mudança detectada entre a API desejada e a atual.${NC}"
            echo -e "${BLUE}ℹ️  A API já está atualizada no API Manager.${NC}"
            echo -e "${BLUE}ℹ️  Isso é normal quando não há alterações na configuração.${NC}"
            return 0
            ;;
        
        12)
            echo -e "${YELLOW}⚠️  Aviso: Pasta de exportação já existe.${NC}"
            echo -e "${BLUE}ℹ️  A pasta de destino já contém arquivos exportados.${NC}"
            echo -e "${BLUE}ℹ️  Considere limpar a pasta antes da próxima exportação.${NC}"
            return 0
            ;;
        
        101)
            echo -e "${YELLOW}⚠️  Aviso: Certificados encontrados que expiram em breve.${NC}"
            echo -e "${BLUE}ℹ️  Verifique os certificados que estão próximos do vencimento.${NC}"
            echo -e "${BLUE}ℹ️  Considere renovar os certificados em breve.${NC}"
            return 0
            ;;
        
        # === ERROS DE CONFIGURAÇÃO (FALHA CONTROLADA) ===
        1)
            echo -e "${RED}❌ Erro: Especificação da API não é suportada pelo APIM-CLI.${NC}"
            echo -e "${PURPLE}💡 Verifique se o formato da especificação é compatível.${NC}"
            return 1
            ;;
        
        2)
            echo -e "${RED}❌ Erro: Erro na análise dos parâmetros de entrada.${NC}"
            echo -e "${PURPLE}💡 Verifique a sintaxe dos parâmetros fornecidos.${NC}"
            return 1
            ;;
        
        5)
            echo -e "${RED}❌ Erro: Parâmetro obrigatório ausente.${NC}"
            echo -e "${PURPLE}💡 Verifique se todos os parâmetros obrigatórios foram fornecidos.${NC}"
            return 1
            ;;
        
        6)
            echo -e "${RED}❌ Erro: Parâmetro inválido fornecido.${NC}"
            echo -e "${PURPLE}💡 Verifique o valor e formato dos parâmetros.${NC}"
            return 1
            ;;
        
        7)
            echo -e "${RED}❌ Erro: API já existe para outra organização.${NC}"
            echo -e "${PURPLE}💡 Verifique se a API não está sendo usada por outra organização.${NC}"
            return 1
            ;;
        
        8)
            echo -e "${RED}❌ Erro: Definição da API backend não está disponível.${NC}"
            echo -e "${PURPLE}💡 Verifique se o arquivo de especificação existe e é acessível.${NC}"
            return 1
            ;;
        
        13)
            echo -e "${RED}❌ Erro: Criação de nova API falhou quando flag updateOnly está definido.${NC}"
            echo -e "${PURPLE}💡 A API não existe e o modo updateOnly foi especificado.${NC}"
            return 1
            ;;
        
        15)
            echo -e "${RED}❌ Erro: Mudança breaking detectada, mas flag force não foi fornecida.${NC}"
            echo -e "${PURPLE}💡 Use a flag -force para aplicar mudanças breaking.${NC}"
            return 1
            ;;
        
        17)
            echo -e "${RED}❌ Erro: Ação falhou devido a conta de administrador ausente.${NC}"
            echo -e "${PURPLE}💡 Verifique as credenciais de administrador.${NC}"
            return 1
            ;;
        
        # === ERROS DE COMUNICAÇÃO (FALHA) ===
        20)
            echo -e "${RED}❌ Erro: Não foi possível analisar resposta HTTP para chamada REST-API.${NC}"
            echo -e "${PURPLE}💡 Verifique a conectividade com o API Manager.${NC}"
            return 1
            ;;
        
        25)
            echo -e "${RED}❌ Erro: Não foi possível enviar requisição HTTP.${NC}"
            echo -e "${PURPLE}💡 Verifique a conectividade de rede e firewall.${NC}"
            return 1
            ;;
        
        30)
            echo -e "${RED}❌ Erro: Não foi possível ler ou analisar payload JSON.${NC}"
            echo -e "${PURPLE}💡 Verifique o formato da resposta do API Manager.${NC}"
            return 1
            ;;
        
        60)
            echo -e "${RED}❌ Erro: Erro genérico de comunicação com API-Manager.${NC}"
            echo -e "${PURPLE}💡 Verifique a conectividade e configuração do API Manager.${NC}"
            return 1
            ;;
        
        63)
            echo -e "${RED}❌ Erro: Host remoto desconhecido fornecido.${NC}"
            echo -e "${PURPLE}💡 Verifique o endereço IP/hostname do API Manager.${NC}"
            return 1
            ;;
        
        67)
            echo -e "${RED}❌ Erro: Login no API-Manager falhou.${NC}"
            echo -e "${PURPLE}💡 Verifique usuário, senha e permissões.${NC}"
            return 1
            ;;
        
        69)
            echo -e "${RED}❌ Erro: Erro inesperado de comunicação com API-Manager.${NC}"
            echo -e "${PURPLE}💡 Verifique logs do API Manager para mais detalhes.${NC}"
            return 1
            ;;
        
        # === ERROS DE ARQUIVO/CONFIGURAÇÃO (FALHA) ===
        64)
            echo -e "${RED}❌ Erro: Nenhuma especificação de API configurada.${NC}"
            echo -e "${PURPLE}💡 Verifique se o arquivo de especificação está definido.${NC}"
            return 1
            ;;
        
        65)
            echo -e "${RED}❌ Erro: Não foi possível ler a definição da API fornecida.${NC}"
            echo -e "${PURPLE}💡 Verifique se o arquivo de especificação existe e é válido.${NC}"
            return 1
            ;;
        
        66)
            echo -e "${RED}❌ Erro: Não foi possível ler o arquivo WSDL fornecido.${NC}"
            echo -e "${PURPLE}💡 Verifique se o arquivo WSDL existe e é válido.${NC}"
            return 1
            ;;
        
        70)
            echo -e "${RED}❌ Erro: Não foi possível ler o arquivo de configuração da API.${NC}"
            echo -e "${PURPLE}💡 Verifique se o arquivo de configuração existe e é válido.${NC}"
            return 1
            ;;
        
        # === ERROS DE ENTIDADES (FALHA) ===
        51)
            echo -e "${RED}❌ Erro: Usuário desconhecido fornecido.${NC}"
            echo -e "${PURPLE}💡 Verifique se o usuário existe no API Manager.${NC}"
            return 1
            ;;
        
        56)
            echo -e "${RED}❌ Erro: API é desconhecida/não encontrada.${NC}"
            echo -e "${PURPLE}💡 Verifique se a API existe no API Manager.${NC}"
            return 1
            ;;
        
        57)
            echo -e "${RED}❌ Erro: Organização desconhecida fornecida.${NC}"
            echo -e "${PURPLE}💡 Verifique se a organização existe no API Manager.${NC}"
            return 1
            ;;
        
        58)
            echo -e "${RED}❌ Erro: Aplicação desconhecida fornecida.${NC}"
            echo -e "${PURPLE}💡 Verifique se a aplicação existe no API Manager.${NC}"
            return 1
            ;;
        
        89)
            echo -e "${RED}❌ Erro: O nome da aplicação fornecido não é único.${NC}"
            echo -e "${PURPLE}💡 Mais de uma aplicação foi encontrada com este nome.${NC}"
            return 1
            ;;
        
        # === ERROS DE OPERAÇÃO (FALHA) ===
        35)
            echo -e "${RED}❌ Erro: Não foi possível criar API-Proxy (FE-API).${NC}"
            echo -e "${PURPLE}💡 Verifique permissões e configuração do API Manager.${NC}"
            return 1
            ;;
        
        40)
            echo -e "${RED}❌ Erro: Não foi possível importar definição Swagger.${NC}"
            echo -e "${PURPLE}💡 Verifique se a definição Swagger é válida.${NC}"
            return 1
            ;;
        
        45)
            echo -e "${RED}❌ Erro: Não foi possível atualizar API-Proxy (FE-API).${NC}"
            echo -e "${PURPLE}💡 Verifique permissões e configuração do API Manager.${NC}"
            return 1
            ;;
        
        47)
            echo -e "${RED}❌ Erro: Não foi possível atualizar configuração de Quota.${NC}"
            echo -e "${PURPLE}💡 Verifique a configuração de quota fornecida.${NC}"
            return 1
            ;;
        
        50)
            echo -e "${RED}❌ Erro: Não foi possível atualizar o status da API.${NC}"
            echo -e "${PURPLE}💡 Verifique permissões e estado atual da API.${NC}"
            return 1
            ;;
        
        90)
            echo -e "${RED}❌ Erro: API não pôde ser aprovada.${NC}"
            echo -e "${PURPLE}💡 Verifique permissões e estado atual da API.${NC}"
            return 1
            ;;
        
        91)
            echo -e "${RED}❌ Erro: API não pôde ser deletada.${NC}"
            echo -e "${PURPLE}💡 Verifique permissões e dependências da API.${NC}"
            return 1
            ;;
        
        96)
            echo -e "${RED}❌ Erro: API não pôde ser alterada para estado publicado.${NC}"
            echo -e "${PURPLE}💡 Verifique permissões e configuração da API.${NC}"
            return 1
            ;;
        
        97)
            echo -e "${RED}❌ Erro: API não pôde ser alterada para estado não publicado.${NC}"
            echo -e "${PURPLE}💡 Verifique permissões e configuração da API.${NC}"
            return 1
            ;;
        
        # === ERROS DE SEGURANÇA/CONFIGURAÇÃO (FALHA) ===
        52)
            echo -e "${RED}❌ Erro: Erro ao alterar senha do usuário.${NC}"
            echo -e "${PURPLE}💡 Verifique permissões e política de senhas.${NC}"
            return 1
            ;;
        
        53)
            echo -e "${RED}❌ Erro: Opção de roteamento Query-String não está habilitada no API-Manager.${NC}"
            echo -e "${PURPLE}💡 Habilite a opção de roteamento Query-String no API Manager.${NC}"
            return 1
            ;;
        
        54)
            echo -e "${RED}❌ Erro: A configuração da API precisa de query string, mas API-Manager não tem habilitado.${NC}"
            echo -e "${PURPLE}💡 Configure query string na API ou habilite no API Manager.${NC}"
            return 1
            ;;
        
        73)
            echo -e "${RED}❌ Erro: Referência de perfil inválida usada.${NC}"
            echo -e "${PURPLE}💡 Verifique se os perfis referenciados existem e são compatíveis.${NC}"
            return 1
            ;;
        
        104)
            echo -e "${RED}❌ Erro: O perfil de segurança fornecido é inválido.${NC}"
            echo -e "${PURPLE}💡 Verifique a configuração do perfil de segurança.${NC}"
            return 1
            ;;
        
        # === ERROS DE PERMISSÃO/ACESSO (FALHA) ===
        55)
            echo -e "${RED}❌ Erro: Não foi possível atualizar acesso à API.${NC}"
            echo -e "${PURPLE}💡 Verifique permissões e configuração de acesso.${NC}"
            return 1
            ;;
        
        59)
            echo -e "${RED}❌ Erro: Erro ao gerenciar permissões da organização.${NC}"
            echo -e "${PURPLE}💡 Verifique permissões e configuração da organização.${NC}"
            return 1
            ;;
        
        93)
            echo -e "${RED}❌ Erro: Erro ao conceder acesso à API.${NC}"
            echo -e "${PURPLE}💡 Verifique permissões e configuração de acesso.${NC}"
            return 1
            ;;
        
        102)
            echo -e "${RED}❌ Erro: Erro ao conceder acesso da aplicação à API.${NC}"
            echo -e "${PURPLE}💡 Verifique permissões e configuração da aplicação.${NC}"
            return 1
            ;;
        
        103)
            echo -e "${RED}❌ Erro: Erro ao revogar acesso da aplicação à API.${NC}"
            echo -e "${PURPLE}💡 Verifique permissões e configuração da aplicação.${NC}"
            return 1
            ;;
        
        # === ERROS DE VALIDAÇÃO (FALHA) ===
        61)
            echo -e "${RED}❌ Erro: Pelo menos uma organização configurada é inválida.${NC}"
            echo -e "${PURPLE}💡 Verifique o arquivo de log para mais informações.${NC}"
            return 1
            ;;
        
        62)
            echo -e "${RED}❌ Erro: Pelo menos uma aplicação configurada é inválida.${NC}"
            echo -e "${PURPLE}💡 Verifique o arquivo de log para mais informações.${NC}"
            return 1
            ;;
        
        71)
            echo -e "${RED}❌ Erro: A configuração de Quota fornecida é inválida.${NC}"
            echo -e "${PURPLE}💡 Verifique a configuração de quota.${NC}"
            return 1
            ;;
        
        72)
            echo -e "${RED}❌ Erro: O operationId fornecido não pode ser encontrado.${NC}"
            echo -e "${PURPLE}💡 Verifique se o operationId existe na especificação da API.${NC}"
            return 1
            ;;
        
        75)
            echo -e "${RED}❌ Erro: Funcionalidade não suportada.${NC}"
            echo -e "${PURPLE}💡 Verifique se a funcionalidade é suportada nesta versão.${NC}"
            return 1
            ;;
        
        76)
            echo -e "${RED}❌ Erro: O backend basepath fornecido não é uma URL válida.${NC}"
            echo -e "${PURPLE}💡 Verifique o formato da URL do backend.${NC}"
            return 1
            ;;
        
        80)
            echo -e "${RED}❌ Erro: Não foi possível comparar as APIs Desejada e Atual.${NC}"
            echo -e "${PURPLE}💡 Verifique se ambas as APIs estão acessíveis.${NC}"
            return 1
            ;;
        
        81)
            echo -e "${RED}❌ Erro: A senha do keystore está incorreta.${NC}"
            echo -e "${PURPLE}💡 Verifique a senha do keystore.${NC}"
            return 1
            ;;
        
        85)
            echo -e "${RED}❌ Erro: Nome de política customizada é desconhecido.${NC}"
            echo -e "${PURPLE}💡 Verifique se a política existe no API Manager.${NC}"
            return 1
            ;;
        
        87)
            echo -e "${RED}❌ Erro: Não foi possível configurar o V-Host para a FE-API.${NC}"
            echo -e "${PURPLE}💡 Verifique a configuração do V-Host.${NC}"
            return 1
            ;;
        
        88)
            echo -e "${RED}❌ Erro: Não foi possível criar cliente HTTP.${NC}"
            echo -e "${PURPLE}💡 Verifique configuração de rede e proxy.${NC}"
            return 1
            ;;
        
        92)
            echo -e "${RED}❌ Erro: Organização não pôde ser deletada.${NC}"
            echo -e "${PURPLE}💡 Verifique dependências e permissões da organização.${NC}"
            return 1
            ;;
        
        94)
            echo -e "${RED}❌ Erro: Erro ao exportar arquivo de dados da API.${NC}"
            echo -e "${PURPLE}💡 Verifique permissões e espaço em disco.${NC}"
            return 1
            ;;
        
        95)
            echo -e "${RED}❌ Erro: Erro ao criar/atualizar aplicação.${NC}"
            echo -e "${PURPLE}💡 Verifique permissões e configuração da aplicação.${NC}"
            return 1
            ;;
        
        100)
            echo -e "${RED}❌ Erro: Erro inesperado ao verificar data de expiração de certificados.${NC}"
            echo -e "${PURPLE}💡 Verifique configuração de certificados.${NC}"
            return 1
            ;;
        
        68)
            echo -e "${RED}❌ Erro: Host remoto único baseado no filtro fornecido não pôde ser encontrado.${NC}"
            echo -e "${PURPLE}💡 Verifique o filtro de host remoto fornecido.${NC}"
            return 1
            ;;
        
        # === ERRO GENÉRICO (FALHA) ===
        99)
            echo -e "${RED}❌ Erro: Ocorreu um erro inesperado.${NC}"
            echo -e "${PURPLE}💡 Verifique logs detalhados para mais informações.${NC}"
            return 1
            ;;
        
        # === CÓDIGO DESCONHECIDO ===
        *)
            echo -e "${RED}❌ Erro: Código de saída desconhecido: $exit_code${NC}"
            echo -e "${PURPLE}💡 Este código não está documentado. Verifique logs para mais detalhes.${NC}"
            return 1
            ;;
    esac
}

# Função para executar comando e tratar erro
execute_with_error_handling() {
    local command="$1"
    local operation="$2"
    
    echo -e "${BLUE}🚀 Executando: $operation${NC}"
    echo -e "${CYAN}📋 Comando: $command${NC}"
    
    # Executar o comando
    eval "$command"
    
    # Capturar código de saída
    local exit_code=$?
    
    # Tratar o código de saída
    handle_exit_code $exit_code "$operation"
    
    return $?
}

# Função para mostrar resumo dos códigos de erro
show_error_codes_summary() {
    echo -e "\n${PURPLE}📚 Resumo dos Códigos de Erro do Axway API Management CLI${NC}"
    echo -e "${CYAN}=====================================================${NC}"
    echo -e "${GREEN}✅ Códigos que NÃO falham o pipeline (BYPASS):${NC}"
    echo -e "  • 0  - Sucesso"
    echo -e "  • 10 - Nenhuma mudança detectada"
    echo -e "  • 12 - Pasta de exportação já existe"
    echo -e "  • 101 - Certificados expiram em breve (aviso)"
    echo -e ""
    echo -e "${RED}❌ Códigos que FALHAM o pipeline (ERRO REAL):${NC}"
    echo -e "  • 1-99, 102-104 - Erros de configuração, comunicação, permissão, etc."
    echo -e ""
    echo -e "${YELLOW}📖 Documentação completa:${NC}"
    echo -e "  https://github.com/Axway-API-Management-Plus/apim-cli/wiki/9.6-Error-Codes"
}

# Se executado diretamente, mostrar resumo
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    show_error_codes_summary
fi 