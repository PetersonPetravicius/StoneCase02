*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections
Resource    ../resources/api_testing.resource

*** Test Cases ***

Cenário 01: Realizar login com usuario e senha validos
    DADO que estou utilizando a "api Login"
    QUANDO informo os dados de usuário "valido"
    E faço requisição de login
    ENTÃO devera ser retornado o token do usuário com sucesso

Cenário 02: Realizar login com senha invalida
    DADO que estou utilizando a "api Login"
    QUANDO informo os dados de usuário "com senha invalida" 
    E faço requisição de login
    ENTÃO devera ser retornado mensagem de erro

Cenário 03: Realizar login com usuario invalido
    DADO que estou utilizando a "api Login"
    QUANDO informo os dados de usuário "invalido"
    E faço requisição de login
    ENTÃO devera ser retornado mensagem de erro    