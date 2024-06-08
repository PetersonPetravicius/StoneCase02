*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections
Resource    ../resources/api_testing.resource

*** Test Cases ***

Cenário 01: Realizar login com usuario e senha validos
    DADO que estou utilizando a api "Login" 
    QUANDO informo os dados de usuário              ${USUARIO_VALIDO}    ${SENHA_VALIDA}
    ENTÃO devera ser retornado o token do usuário com sucesso

Cenário 02: Realizar login com senha invalida
    DADO que estou utilizando a api "Login" 
    QUANDO informo os dados de usuário              ${USUARIO_VALIDO}    ${SENHA_INVALIDA}
    ENTÃO devera ser retornado mensagem de erro

Cenário 03: Realizar login com usuario invalido
    DADO que estou utilizando a api "Login" 
    QUANDO informo os dados de usuário              ${USUARIO_INVALIDO}    ${SENHA_VALIDA}
    ENTÃO devera ser retornado mensagem de erro    