*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections
Resource    ../resources/api_testing.resource

*** Test Cases ***

Cenário 01: Realizar Transferencia com sucesso
    DADO que estou utilizando a "api OpenBank/Transfers" 
    QUANDO informo os dados de transferencia "valida"
    E faço a requisição de transferencia
    ENTÃO devera ser retornado os dados da transferencia com sucesso

Cenário 02: Realizar Transferencia com operação sem escopo
    DADO que estou utilizando a "api OpenBank/Transfers" 
    QUANDO informo os dados de transferencia "valida mas sem escopo"
    E faço a requisição de transferencia
    ENTÃO devera ser retornado mensagem de "não autorizado"

Cenário 03: Realizar Transferencia sem autenticação
    DADO que estou utilizando a "api OpenBank/Transfers" 
    QUANDO informo os dados de transferencia "valida mas sem autenticacao"
    E faço a requisição de transferencia
    ENTÃO devera ser retornado mensagem de "não autenticado"

Cenário 04: Realizar Transferencia com conta invalida
    DADO que estou utilizando a "api OpenBank/Transfers" 
    QUANDO informo os dados de transferencia "com conta invalida"
    E faço a requisição de transferencia
    ENTÃO devera ser retornado mensagem de "conta invalida"