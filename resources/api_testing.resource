*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections

*** Variables ***
${BASE_URL}             https://login.sandbox.stone.com.br/
${ENDPOINT}             auth/realms/stone_account/protocol/openid-connect/token
${CONTENT_TYPE}         application/x-www-form-urlencoded
${COOKIE}               KEYCLOAK_LOCALE=pt-BR; __cf_bm=oAwV8SmrMeOi1ubjGyq1DWFsPrPT9_7Ikv.WOIRcluc-1717776169-1.0.1.1-GTwjTRJBdAzu7dZrpIPn0r1HCiRRwBmlzX_1l7ZIvV0jfTbmDR4d0.HQo42tVWmNfuyRSBGxmuxl1a0gXiM3797ugQYobDxKvxUSw9Phdw0
${USUARIO_VALIDO}           desafioqastone@gmail.com
${SENHA_VALIDA}             desafioqa
${USUARIO_INVALIDO}         invalidoqastone@gmail.com
${SENHA_INVALIDA}           invalidodesafioqa

*** Keywords ***


DADO que estou utilizando a api "Login"

    Create Session       StoneCO        ${BASE_URL}


QUANDO informo os dados de usuário
    [Arguments]          ${user_name}    ${password}
    ${body}              Create Dictionary    
   ...                   client_id=admin-cli    
   ...                   username=${user_name}  
   ...                   password=${password}   
   ...                   grant_type=password
    Log                  ${body}

   
    ${headers}           Create Dictionary    
    ...                  Content-Type=${CONTENT_TYPE}    
    ...                  Cookie=${COOKIE}
      
    ${resposta_login}    POST On Session     
    ...                  StoneCO    
    ...                  ${ENDPOINT}    
    ...                  data=${body}    
    ...                  headers=${headers}
    ...                  expected_status=any 

    log                  ${resposta_login.json()}

    Set Test Variable    ${STATUS_CODE}       ${resposta_login.status_code}    
    Set Test Variable    ${RESP_CADASTRO}       ${resposta_login.json()}

    

ENTÃO devera ser retornado o token do usuário com sucesso
    Log    ${RESP_CADASTRO}
    
    ${expires_in}                     Set Variable            2700
    ${expires_in}                     Evaluate                int(${expires_in})
    ${refresh_expires_in}             Set Variable            14400
    ${refresh_expires_in}             Evaluate                int(${refresh_expires_in})
    ${not-before-policy}              Set Variable            1716936414
    ${not-before-policy}              Evaluate                int(${not-before-policy})

    Should Be Equal As Numbers        ${STATUS_CODE}          200  
    Dictionary Should Contain Key     ${RESP_CADASTRO}        access_token
    Dictionary Should Contain Item    ${RESP_CADASTRO}        expires_in            ${expires_in}
    Dictionary Should Contain Item    ${RESP_CADASTRO}        refresh_expires_in    ${refresh_expires_in}
    Dictionary Should Contain Key     ${RESP_CADASTRO}        refresh_token
    Dictionary Should Contain Item    ${RESP_CADASTRO}        token_type    Bearer
    Dictionary Should Contain Item    ${RESP_CADASTRO}        not-before-policy     ${not-before-policy}
    Dictionary Should Contain Key     ${RESP_CADASTRO}        session_state
    Dictionary Should Contain Key     ${RESP_CADASTRO}        scope   


ENTÃO devera ser retornado mensagem de erro
    Log    ${RESP_CADASTRO}
    Log    ${STATUS_CODE}
    Dictionary Should Contain Item    ${RESP_CADASTRO}        error                 invalid_grant
    Dictionary Should Contain Item    ${RESP_CADASTRO}        error_description     Invalid user credentials
    Should Be Equal As Numbers        ${STATUS_CODE}          401  