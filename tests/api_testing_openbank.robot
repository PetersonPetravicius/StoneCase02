*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections
Resource    ../resources/api_testing.resource

*** Test Cases ***

Cenário 01: Realizar Transferencia com sucesso
    [Documentation]    Teste de sucesso no fluxo de transferencia de valores.
    ...                Este cenário não foi possivel de concluir, pois o usuário
    ...                fornecido pela Stone não possui Escopo para realizar esta ação.
    [Tags]             Transferencia     Conta Corrente    Sucesso
    DADO que estou utilizando a "api OpenBank/internal_transfers" 
    QUANDO informo os dados de transferencia "valida"
    E faço a requisição de transferencia
    ENTÃO devera ser retornado os dados da transferencia com sucesso

Cenário 02: Realizar Transferencia com operação sem escopo
    [Documentation]    Teste de falha no fluxo de transferencia de valores.
    ...                Este cenário simula o caso de um usuario valido mas sem
    ...                escopo para realizar a ação.
    [Tags]             Transferencia     Conta Corrente    Falha
    DADO que estou utilizando a "api OpenBank/internal_transfers" 
    QUANDO informo os dados de transferencia "valida mas sem escopo"
    E faço a requisição de transferencia
    ENTÃO devera ser retornado mensagem de erro transação "não autorizado"

Cenário 03: Realizar Transferencia sem autenticação
    [Documentation]    Teste de falha no fluxo de transferencia de valores.
    ...                Este cenário simula o caso de um usuario valido mas com
    ...                autenticação expirada/divergente no momento de realizar a ação.
    [Tags]             Transferencia     Conta Corrente    Falha
    DADO que estou utilizando a "api OpenBank/internal_transfers" 
    QUANDO informo os dados de transferencia "valida mas sem autenticacao"
    E faço a requisição de transferencia
    ENTÃO devera ser retornado mensagem de erro transação "não autenticado"

Cenário 04: Realizar Transferencia com conta invalida
    [Documentation]    Teste de falha no fluxo de transferencia de valores.
    ...                Este cenário simula o caso de um usuario autenticado
    ...                mas com dados incorretos de conta corrente no momento de realizar a ação.
    [Tags]             Transferencia     Conta Corrente    Falha
    DADO que estou utilizando a "api OpenBank/internal_transfers" 
    QUANDO informo os dados de transferencia "com conta invalida"
    E faço a requisição de transferencia
    ENTÃO devera ser retornado mensagem de erro transação "conta invalida"


Cenário 05: Realizar Consulta de Saldo com sucesso
    [Documentation]    Teste de sucesso no fluxo de consulta de saldo.
    ...                Este cenário não foi possivel de concluir, pois o usuário
    ...                fornecido pela Stone não possui Escopo para realizar esta ação.
    [Tags]             Saldo     Conta Corrente    Sucesso
    DADO que estou utilizando a "api OpenBank/balance" 
    QUANDO informo os dados de saldo "validos"
    E faço a requisição de buscar saldo
    ENTÃO devera ser retornado os dados do saldo com sucesso

Cenário 06: Realizar Consulta de Saldo com operação sem escopo
    [Documentation]    Teste de falha no fluxo de consulta de saldo.
    ...                Este cenário simula o caso de um usuario valido mas sem
    ...                escopo para realizar a ação.
    [Tags]             Saldo     Conta Corrente    Falha
    DADO que estou utilizando a "api OpenBank/balance" 
    QUANDO informo os dados de saldo "validos mas sem escopo"
    E faço a requisição de buscar saldo
    ENTÃO devera ser retornado mensagem de erro saldo "não autorizado"

Cenário 07: Realizar Consulta de Saldo sem autenticação
    [Documentation]    Teste de falha no fluxo de consulta de saldo.
    ...                Este cenário simula o caso de um usuario valido mas com
    ...                autenticação expirada/divergente no momento de realizar a ação.
    [Tags]             Saldo     Conta Corrente    Falha
    DADO que estou utilizando a "api OpenBank/balance"
    QUANDO informo os dados de saldo "validos mas sem autenticacao"
    E faço a requisição de buscar saldo
    ENTÃO devera ser retornado mensagem de erro saldo "não autenticado"

Cenário 08: Realizar Consulta de Extrato com conta invalida
    [Documentation]    Teste de falha no fluxo consulta de saldo.
    ...                Este cenário simula o caso de um usuario autenticado
    ...                mas com dados incorretos de conta corrente no momento de realizar a ação.
    [Tags]             Saldo     Conta Corrente    Falha
    DADO que estou utilizando a "api OpenBank/balance" 
    QUANDO informo os dados de saldo "com conta invalida"
    E faço a requisição de buscar saldo
    ENTÃO devera ser retornado mensagem de erro saldo "conta invalida"


Cenário 09: Realizar Consulta de Extrato com sucesso
    [Documentation]    Teste de sucesso no fluxo de consulta de Extrato.
    ...                Este cenário não foi possivel de concluir, pois o usuário
    ...                fornecido pela Stone não possui Escopo para realizar esta ação.
    [Tags]             Extrato     Conta Corrente    Sucesso
    DADO que estou utilizando a "api OpenBank/balance" 
    QUANDO informo os dados de extrato "validos"
    E faço a requisição de buscar extrato
    ENTÃO devera ser retornado os dados do extrato com sucesso

Cenário 10: Realizar Consulta de Extrato com operação sem escopo
    [Documentation]    Teste de falha no fluxo de consulta de Extrato.
    ...                Este cenário simula o caso de um usuario valido mas sem
    ...                escopo para realizar a ação.
    [Tags]             Extrato     Conta Corrente    Falha
    DADO que estou utilizando a "api OpenBank/balance" 
    QUANDO informo os dados de extrato "validos mas sem escopo"
    E faço a requisição de buscar extrato
    ENTÃO devera ser retornado mensagem de erro extrato "não autorizado"

Cenário 11: Realizar Consulta de Extrato sem autenticação
    [Documentation]    Teste de falha no fluxo de consulta de Extrato.
    ...                Este cenário simula o caso de um usuario valido mas com
    ...                autenticação expirada/divergente no momento de realizar a ação.
    [Tags]             Extrato     Conta Corrente    Falha
    DADO que estou utilizando a "api OpenBank/balance"
    QUANDO informo os dados de extrato "validos mas sem autenticacao"
    E faço a requisição de buscar extrato
    ENTÃO devera ser retornado mensagem de erro extrato "não autenticado"

Cenário 12: Realizar Consulta de Extrato com conta invalida
    [Documentation]    Teste de falha no fluxo consulta de Extrato.
    ...                Este cenário simula o caso de um usuario autenticado
    ...                mas com dados incorretos de conta corrente no momento de realizar a ação.
    [Tags]             Extrato     Conta Corrente    Falha
    DADO que estou utilizando a "api OpenBank/balance" 
    QUANDO informo os dados de extrato "com conta invalida"
    E faço a requisição de buscar extrato
    ENTÃO devera ser retornado mensagem de erro extrato "conta invalida"