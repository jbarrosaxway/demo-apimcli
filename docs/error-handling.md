# Sistema de Tratamento Inteligente de Códigos de Erro

Este documento descreve o sistema de tratamento inteligente de códigos de erro do Axway API Management CLI implementado neste projeto.

## 📋 Visão Geral

O sistema categoriza os códigos de erro em duas classes principais:

### ✅ **Códigos BYPASS** (Não falham o pipeline)
- **Código 0**: Sucesso
- **Código 10**: Nenhuma mudança detectada
- **Código 12**: Pasta de exportação já existe
- **Código 101**: Certificados expiram em breve (aviso)

### ❌ **Códigos FALHA** (Falham o pipeline)
- **Códigos 1-99, 102-104**: Erros reais que precisam ser corrigidos

## 🎯 Lógica de Decisão

### **BYPASS - Quando o código NÃO deve falhar o pipeline:**

1. **Sucesso (0)**: Operação concluída com êxito
2. **Sem mudanças (10)**: API já está atualizada - comportamento normal
3. **Avisos (12, 101)**: Informações importantes, mas não impedem a operação
4. **Situações esperadas**: Comportamentos normais do sistema

### **FALHA - Quando o código DEVE falhar o pipeline:**

1. **Erros de configuração**: Parâmetros inválidos, arquivos ausentes
2. **Erros de comunicação**: Problemas de rede, conectividade
3. **Erros de permissão**: Credenciais inválidas, falta de acesso
4. **Erros de validação**: Dados inválidos, formatos incorretos
5. **Erros de sistema**: Problemas internos do API Manager

## 📁 Arquivos do Sistema

### **Scripts Principais**
- `scripts/error-handler.sh` - Script principal de tratamento de erros
- `scripts/test-error-handler.sh` - Script de teste e demonstração

### **Workflows Atualizados**
- `.github/workflows/import-api-intelligent.yaml` - Workflow com tratamento inteligente
- `.github/workflows/import-api.yaml` - Workflow original (mantido para compatibilidade)
- `.github/workflows/update-api.yaml` - Workflow de atualização
- `.github/workflows/manual-api-deploy.yaml` - Workflow de deploy manual

## 🔧 Como Usar

### **1. Em Workflows GitHub Actions**

```yaml
- name: import api with intelligent error handling
  run: |
    # Executar comando do Axway CLI
    docker run --rm -v "${{ github.workspace }}:/workspace" \
      bvieira123/apim-cli:1.14.4 \
      apim api import -h "${{ vars.APIM_INSTANCE_IP }}" \
      -u "${{ vars.APIM_INSTANCE_USER }}" -port 8075 \
      -p "${{ secrets.APIM_INSTANCE_PASSWORD }}" \
      -c "/workspace/${{ inputs.config-file }}"
    
    # Capturar código de saída
    EXIT_CODE=$?
    
    # Usar tratamento inteligente
    source scripts/error-handler.sh
    handle_exit_code $EXIT_CODE "import"
    
    # Sair com o resultado do tratamento
    exit $?
```

### **2. Em Scripts Locais**

```bash
#!/bin/bash

# Importar o script de tratamento
source scripts/error-handler.sh

# Executar comando
docker run --rm -v "$(pwd):/workspace" \
  bvieira123/apim-cli:1.14.4 \
  apim api import -h "localhost" -u "admin" \
  -port 8075 -p "password" -c "/workspace/config.yaml"

# Tratar resultado
handle_exit_code $? "import"
```

### **3. Função de Execução com Tratamento**

```bash
# Usar função helper
execute_with_error_handling \
  "docker run --rm bvieira123/apim-cli:1.14.4 apim api import ..." \
  "import"
```

## 📊 Categorias de Erros

### **🟢 BYPASS - Informações/Avisos**
| Código | Descrição | Ação |
|--------|-----------|------|
| 0 | Sucesso | ✅ Continua |
| 10 | Nenhuma mudança detectada | ✅ Continua |
| 12 | Pasta de exportação já existe | ✅ Continua |
| 101 | Certificados expiram em breve | ✅ Continua |

### **🔴 FALHA - Erros Reais**
| Código | Descrição | Ação |
|--------|-----------|------|
| 1-99 | Erros de configuração, comunicação, etc. | ❌ Para |
| 102-104 | Erros de validação e permissão | ❌ Para |

## 🧪 Testando o Sistema

### **Executar Testes**
```bash
./scripts/test-error-handler.sh
```

### **Testar Código Específico**
```bash
source scripts/error-handler.sh
handle_exit_code 10 "test"
```

## 📈 Benefícios

### **Para Desenvolvedores**
- ✅ **Feedback claro** sobre o que aconteceu
- ✅ **Logs informativos** com sugestões de correção
- ✅ **Menos falhas desnecessárias** no CI/CD
- ✅ **Melhor experiência** de desenvolvimento

### **Para Operações**
- ✅ **Pipeline mais robusto** e confiável
- ✅ **Alertas precisos** para problemas reais
- ✅ **Redução de falsos positivos**
- ✅ **Melhor visibilidade** do status das operações

### **Para Negócio**
- ✅ **Menos interrupções** no pipeline
- ✅ **Deploy mais confiável**
- ✅ **Redução de tempo** de resolução de problemas
- ✅ **Melhor qualidade** do processo de entrega

## 🔍 Exemplos de Cenários

### **Cenário 1: API Já Atualizada**
```
Código: 10
Mensagem: ✅ Sucesso! Nenhuma mudança detectada entre a API desejada e a atual.
Resultado: Pipeline continua ✅
```

### **Cenário 2: Erro de Login**
```
Código: 67
Mensagem: ❌ Erro: Login no API-Manager falhou.
Sugestão: 💡 Verifique usuário, senha e permissões.
Resultado: Pipeline para ❌
```

### **Cenário 3: Certificados Expirando**
```
Código: 101
Mensagem: ⚠️ Aviso: Certificados encontrados que expiram em breve.
Sugestão: 💡 Considere renovar os certificados em breve.
Resultado: Pipeline continua ✅
```

## 📚 Referências

- **Documentação Oficial**: [Axway API Management CLI Error Codes](https://github.com/Axway-API-Management-Plus/apim-cli/wiki/9.6-Error-Codes)
- **Script de Tratamento**: `scripts/error-handler.sh`
- **Script de Teste**: `scripts/test-error-handler.sh`
- **Workflow Inteligente**: `.github/workflows/import-api-intelligent.yaml`

## 🔄 Migração

### **De Workflows Antigos para Inteligentes**

1. **Substituir tratamento manual**:
```bash
# Antes
if [ $EXIT_CODE -eq 0 ] || [ $EXIT_CODE -eq 10 ]; then
  echo "Success"
else
  echo "Error"
fi

# Depois
source scripts/error-handler.sh
handle_exit_code $EXIT_CODE "operation"
```

2. **Usar workflow inteligente**:
```yaml
# Antes
uses: ./.github/workflows/import-api.yaml

# Depois
uses: ./.github/workflows/import-api-intelligent.yaml
```

## 🚀 Próximos Passos

1. **Migrar workflows existentes** para usar tratamento inteligente
2. **Adicionar mais códigos** conforme necessário
3. **Criar métricas** de uso dos códigos de erro
4. **Implementar alertas** para códigos críticos
5. **Documentar casos específicos** da organização 