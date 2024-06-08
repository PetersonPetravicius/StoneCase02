*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections
Resource    ../resources/api_testing.resource

*** Test Cases ***

Cenário 01: Realizar login com usuario e senha validos
    [Documentation]    Teste de sucesso no fluxo de login de usuário.
    ...                Este cenário realizar um login de usuário com sucesso.
    [Tags]             Login     Autenticação    Sucesso
    DADO que estou utilizando a "api Login"
    QUANDO informo os dados de usuário "valido"
    E faço requisição de login
    ENTÃO devera ser retornado o token do usuário com sucesso

Cenário 02: Realizar login com usuario sem escopo
    [Documentation]    Teste de sucesso no fluxo de login de usuário.
    ...                Este cenário realizar um login de usuário com sucesso,
    ...                porém este usuario nao possui escopo para realizar outras ações de API.
    [Tags]             Login     Autenticação    Sucesso
    DADO que estou utilizando a "api Login"
    QUANDO informo os dados de usuário "sem escopo"
    E faço requisição de login
    ENTÃO devera ser retornado o token do usuário com sucesso      

Cenário 03: Realizar login com senha invalida
    [Documentation]    Teste de falha no fluxo de login de usuário.
    ...                Este cenário simula o caso de um usuario com senha invalida
    ...                no momento de realizar a ação.
    [Tags]             Login     Autenticação    Falha
    DADO que estou utilizando a "api Login"
    QUANDO informo os dados de usuário "com senha invalida" 
    E faço requisição de login
    ENTÃO devera ser retornado mensagem de login erro 

Cenário 04: Realizar login com usuario invalido
    [Documentation]    Teste de falha no fluxo de login de usuário.
    ...                Este cenário simula o caso de um usuario invalido
    ...                no momento de realizar a ação.
    [Tags]             Login     Autenticação    Falha
    DADO que estou utilizando a "api Login"
    QUANDO informo os dados de usuário "invalido"
    E faço requisição de login
    ENTÃO devera ser retornado mensagem de login erro 

