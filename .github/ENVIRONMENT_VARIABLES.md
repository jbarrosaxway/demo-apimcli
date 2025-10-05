# Variáveis de Ambiente do GitHub Actions

Este projeto usa variáveis de ambiente do GitHub Actions para configurar a conexão com a instância do APIM.

## Variáveis Necessárias

### Variáveis de Repositório (Repository Variables)
Configure estas variáveis nas configurações do repositório GitHub:

- `APIM_INSTANCE_IP`: IP ou hostname da instância do APIM
- `APIM_INSTANCE_USER`: Usuário para autenticação no APIM
- `APIM_INSTANCE_PORT`: Porta da instância do APIM (padrão: 8075)

### Secrets do Repositório (Repository Secrets)
Configure estes secrets nas configurações do repositório GitHub:

- `APIM_INSTANCE_PASSWORD`: Senha do usuário do APIM

## Como Configurar

1. Acesse as configurações do repositório no GitHub
2. Vá para "Secrets and variables" > "Actions"
3. Na aba "Variables", adicione:
   - `APIM_INSTANCE_IP`: Seu IP do APIM
   - `APIM_INSTANCE_USER`: Seu usuário do APIM
   - `APIM_INSTANCE_PORT`: Sua porta do APIM (opcional, padrão: 8075)
4. Na aba "Secrets", adicione:
   - `APIM_INSTANCE_PASSWORD`: Sua senha do APIM

## Valores Padrão

Se a variável `APIM_INSTANCE_PORT` não for definida, o sistema usará a porta padrão `8075`.

## Exemplo de Configuração

```
APIM_INSTANCE_IP: 192.168.1.100
APIM_INSTANCE_USER: apiadmin
APIM_INSTANCE_PORT: 8075
APIM_INSTANCE_PASSWORD: [sua_senha]
```

## Ambientes

As variáveis são usadas no ambiente `DEMO`. Certifique-se de que o ambiente está configurado corretamente nas configurações do repositório.
