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
    DADO que estou utilizando a "api OpenBank/Transfers" 
    QUANDO informo os dados de transferencia "valida"
    E faço a requisição de transferencia
    ENTÃO devera ser retornado os dados da transferencia com sucesso

Cenário 02: Realizar Transferencia com operação sem escopo
    [Documentation]    Teste de falha no fluxo de transferencia de valores.
    ...                Este cenário simula o caso de um usuario valido mas sem
    ...                escopo para realizar a ação.
    [Tags]             Transferencia     Conta Corrente    Falha
    DADO que estou utilizando a "api OpenBank/Transfers" 
    QUANDO informo os dados de transferencia "valida mas sem escopo"
    E faço a requisição de transferencia
    ENTÃO devera ser retornado mensagem de "não autorizado"

Cenário 03: Realizar Transferencia sem autenticação
    [Documentation]    Teste de falha no fluxo de transferencia de valores.
    ...                Este cenário simula o caso de um usuario valido mas com
    ...                autenticação expirada/divergente no momento de realizar a ação.
    [Tags]             Transferencia     Conta Corrente    Falha
    DADO que estou utilizando a "api OpenBank/Transfers" 
    QUANDO informo os dados de transferencia "valida mas sem autenticacao"
    E faço a requisição de transferencia
    ENTÃO devera ser retornado mensagem de "não autenticado"

Cenário 04: Realizar Transferencia com conta invalida
    [Documentation]    Teste de falha no fluxo de transferencia de valores.
    ...                Este cenário simula o caso de um usuario autenticado
    ...                mas com dados incorrento de conta corrente no momento de realizar a ação
    [Tags]             Transferencia     Conta Corrente    Falha
    DADO que estou utilizando a "api OpenBank/Transfers" 
    QUANDO informo os dados de transferencia "com conta invalida"
    E faço a requisição de transferencia
    ENTÃO devera ser retornado mensagem de "conta invalida"