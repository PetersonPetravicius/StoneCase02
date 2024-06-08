*** Settings ***

Library    RequestsLibrary
Library    String
Library    Collections

*** Variables ***
${LOWER_BOUND}              1
${UPPER_BOUND}              9999
${BASE_URL_OPENBANK}        https://sandbox-api.openbank.stone.com.br/
${BASE_URL_LOGIN}           https://login.sandbox.stone.com.br/
${ENDPOINT_LOGIN}           auth/realms/stone_account/protocol/openid-connect/token
${ENDPOINT_TRANSF}          api/v1/dry_run/internal_transfers
${CONTENT_TYPE_URLENCODED}    application/x-www-form-urlencoded
${CONTENT_TYPE_JSON}        application/json

${COOKIE_LOGIN}             KEYCLOAK_LOCALE=pt-BR; __cf_bm=oAwV8SmrMeOi1ubjGyq1DWFsPrPT9_7Ikv.WOIRcluc-1717776169-1.0.1.1-GTwjTRJBdAzu7dZrpIPn0r1HCiRRwBmlzX_1l7ZIvV0jfTbmDR4d0.HQo42tVWmNfuyRSBGxmuxl1a0gXiM3797ugQYobDxKvxUSw9Phdw0
${COOKIE_TRANSF}            KEYCLOAK_LOCALE=__cf_bm=59Ou5vJ149mclqGv.dw7RIwi7.NXgY9UYJYkhr7KZc0-1717802987-1.0.1.1-jOfOSsO9hOacEA8levmPketnshbD2UpZsD_BaB3dVaGalx47n8uX6z_fWWUDGQQhQlYjpv4P1rvANAk5qpQiZw
&{USUARIO_VALIDO}           client_id=admin-cli    username=desafioqastone@gmail.com    password=desafioqa           grant_type=password
&{USUARIO_SENHA_INVALIDA}   client_id=admin-cli    username=desafioqastone@gmail.com    password=Invalidoesafioqa    grant_type=password
&{USUARIO_INVALIDO}         client_id=admin-cli    username=invalidoqastone@gmail.com   password=esafioqa            grant_type=password
&{HEADERS_LOGIN}            Content-Type=${CONTENT_TYPE_URLENCODED}   Cookie=${COOKIE_LOGIN}
&{HEADERS_TRANSF}           Content-Type=${CONTENT_TYPE_JSON}   Cookie=${COOKIE_TRANSF}
${BODY_TRANSF_VALIDA}       {"amount": 1, "target": {"account": {"account_code": "475384"}}, "description": "limite de 200 caracteres", "schedule_to": "2021-09-20"}
${BODY_TRANSF_SEM_ESCOPO}   {"amount": 1, "target": {"account": {"account_code": "475384"}}, "description": "limite de 200 caracteres", "schedule_to": "2021-09-20"}
${BODY_TRANSF_INVALIDA}     {"amount": 1, "target": {"account": {"account_code": "475384"}}, "description": "limite de 200 caracteres", "schedule_to": "2021-09-20"}

*** Keywords ***

DADO que estou utilizando a "${texto}"
    Log          ${texto}

    IF           '${texto}' == 'api Login'
                        Create Session       StoneCO        ${BASE_URL_LOGIN}

    ELSE IF      '${texto}' == 'api OpenBank/Transfers' or '${texto}' == 'OpenBank/Balance' or '${texto}' == 'OpenBank/Statement'
                        Create Session       StoneCO        ${BASE_URL_LOGIN}
                                    QUANDO informo os dados de usuário "valido"
                                    E faço requisição de login 
                                    ENTÃO devera ser retornado o token do usuário com sucesso
                        Create Session       StoneCO        ${BASE_URL_OPENBANK}


    ELSE
                  Fail   A ${texto} tem um valor desconhecido!

    END

QUANDO informo os dados de usuário "${status_usuario}"
    Log           ${status_usuario}

    IF            '${status_usuario}' == 'valido'
                        Set Test Variable    ${BODY_LOGIN}      ${USUARIO_VALIDO}
                  Log                  ${BODY_LOGIN}
    
    ELSE IF       '${status_usuario}' == 'com senha invalida'
                        Set Test Variable    ${BODY_LOGIN}      ${USUARIO_SENHA_INVALIDA}
                  Log                  ${BODY_LOGIN}
    
    ELSE IF       '${status_usuario}' == 'invalido'
                        Set Test Variable    ${BODY_LOGIN}      ${USUARIO_INVALIDO}
                  Log                  ${BODY_LOGIN}
   
    ELSE
                  Fail   O usuário ${status_usuario} tem um valor desconhecido!

    END

QUANDO informo os dados de transferencia "${status_transferencia}"
    Log           ${status_transferencia}

    IF            '${status_transferencia}' == 'valida'
                        ${body_transfencia}    Evaluate                json.loads('${BODY_TRANSF_VALIDA}')    json
                        Set To Dictionary      ${body_transfencia}     account_id=${SESSION_STATE}
                        Log                    ${body_transfencia}

                        Set Test Variable      ${TRANSF_ACCESS_TOKEN}  ${ACCESS_TOKEN}

    ELSE IF       '${status_transferencia}' == 'valida mas sem escopo'    
                        ${body_transfencia}    Evaluate                json.loads('${BODY_TRANSF_SEM_ESCOPO}')    json
                        Set To Dictionary      ${body_transfencia}     account_id=${SESSION_STATE}
                        Log                    ${body_transfencia}

                        Set Test Variable      ${TRANSF_ACCESS_TOKEN}  ${ACCESS_TOKEN}

    ELSE IF       '${status_transferencia}' == 'valida mas sem autenticacao'    
                        ${body_transfencia}    Evaluate                json.loads('${BODY_TRANSF_VALIDA}')    json
                        Set To Dictionary      ${body_transfencia}     account_id=${SESSION_STATE}
                        Log                    ${body_transfencia}

                        Set Test Variable      ${TRANSF_ACCESS_TOKEN}  ${ACCESS_TOKEN}123                  

    ELSE IF       '${status_transferencia}' == 'com conta invalida'    
                        ${body_transfencia}    Evaluate                json.loads('${BODY_TRANSF_INVALIDA}')    json
                        Set To Dictionary      ${body_transfencia}     account_id=${SESSION_STATE}123
                        Log                    ${body_transfencia}

                        Set Test Variable      ${TRANSF_ACCESS_TOKEN}  ${ACCESS_TOKEN}                 
              
    ELSE                
                  Fail   A Transferencia ${status_transferencia} tem um valor desconhecido!

    END
    
    ${body_transfencia}    Evaluate                json.dumps(${body_transfencia})    json
    Set Test Variable      ${BODY_TRANSF}          ${body_transfencia}
    Log                    ${BODY_TRANSF}

    ${num_random}          Evaluate                random.randint(${LOWER_BOUND}, ${UPPER_BOUND})    random
    ${num_random_str}      Convert To String       ${num_random}
    Set Test Variable      ${NUM_STRING}           ${num_random_str}

E faço requisição de login
    ${resposta_login}    POST On Session     
    ...                               StoneCO    
    ...                               url=${ENDPOINT_LOGIN}    
    ...                               data=${BODY_LOGIN}    
    ...                               headers=${HEADERS_LOGIN}    
    ...                               expected_status=any 
    log                               ${resposta_login.json()}

    Set Test Variable                 ${STATUS_CODE}         ${resposta_login.status_code}    
    Set Test Variable                 ${RESP_CADASTRO}       ${resposta_login.json()}

E faço a requisição de transferencia

    Set To Dictionary    ${HEADERS_TRANSF}    Authorization=Bearer ${TRANSF_ACCESS_TOKEN}    x-stone-idempotency-key=${NUM_STRING}
    Log    ${HEADERS_TRANSF}
    Log    ${BODY_TRANSF}
    ${resposta_transferencia}    POST On Session     
    ...                               StoneCO    
    ...                               url=${ENDPOINT_TRANSF}    
    ...                               data=${BODY_TRANSF}    
    ...                               headers=${HEADERS_TRANSF}
    ...                               expected_status=any 
    log                               ${resposta_transferencia.json()}

    Set Test Variable                 ${STATUS_CODE_TRANSF}         ${resposta_transferencia.status_code}    
    Set Test Variable                 ${RESP_TRANSF}         ${resposta_transferencia.json()}
ENTÃO devera ser retornado o token do usuário com sucesso
    Log                              ${RESP_CADASTRO}
    

    Should Be Equal As Numbers        ${STATUS_CODE}          200  
    Dictionary Should Contain Item    ${RESP_CADASTRO}        token_type                Bearer
    Dictionary Should Contain Key     ${RESP_CADASTRO}        access_token
    Dictionary Should Contain Key     ${RESP_CADASTRO}        expires_in
    Dictionary Should Contain Key     ${RESP_CADASTRO}        refresh_expires_in
    Dictionary Should Contain Key     ${RESP_CADASTRO}        refresh_token
    Dictionary Should Contain Key     ${RESP_CADASTRO}        not-before-policy     
    Dictionary Should Contain Key     ${RESP_CADASTRO}        session_state
    Dictionary Should Contain Key     ${RESP_CADASTRO}        scope   


    ${access_token}                   Evaluate                $RESP_CADASTRO['access_token']
    ${seasson_state}                  Evaluate                $RESP_CADASTRO['session_state']
    ${not-before-policy}              Evaluate                $RESP_CADASTRO['not-before-policy']
    
    Set Test Variable                 ${ACCESS_TOKEN}         ${access_token}
    Set Test Variable                 ${SESSION_STATE}        ${seasson_state}   
    Set Test Variable                 ${NOT_BEFORE_POLICY}    ${not-before-policy}   



ENTÃO devera ser retornado mensagem de erro
    Log    ${RESP_CADASTRO}
    Log    ${STATUS_CODE}

    Dictionary Should Contain Item    ${RESP_CADASTRO}        error                 invalid_grant
    Dictionary Should Contain Item    ${RESP_CADASTRO}        error_description     Invalid user credentials
    Should Be Equal As Numbers        ${STATUS_CODE}          401  


ENTÃO devera ser retornado os dados da transferencia com sucesso
    Log                              ${RESP_TRANSF}
              
    Should Be Equal As Numbers        ${STATUS_CODE_TRANSF}                       200
    Dictionary Should Contain Item    ${RESP_TRANSF}        amount                1
    Dictionary Should Contain Key     ${RESP_TRANSF}        approval_expired_at
    Dictionary Should Contain Key     ${RESP_TRANSF}        approved_at
    Dictionary Should Contain Key     ${RESP_TRANSF}        approved_by
    Dictionary Should Contain Key     ${RESP_TRANSF}        cancelled_at
    Dictionary Should Contain Key     ${RESP_TRANSF}        created_at
    Dictionary Should Contain Key     ${RESP_TRANSF}        created_by    
    Dictionary Should Contain Key     ${RESP_TRANSF}        description
    Dictionary Should Contain Key     ${RESP_TRANSF}        failed_at
    Dictionary Should Contain Key     ${RESP_TRANSF}        fee  
    Dictionary Should Contain Key     ${RESP_TRANSF}        finished_at  
    Dictionary Should Contain Key     ${RESP_TRANSF}        id  
    Dictionary Should Contain Key     ${RESP_TRANSF}        rejected_at  
    Dictionary Should Contain Key     ${RESP_TRANSF}        rejected_by  
    Dictionary Should Contain Key     ${RESP_TRANSF}        scheduled_to  
    Dictionary Should Contain Item    ${RESP_TRANSF}        status                APRROVED            
    Dictionary Should Contain Key     ${RESP_TRANSF}        target  
    Dictionary Should Contain Key     ${RESP_TRANSF}        account  
    Dictionary Should Contain Key     ${RESP_TRANSF}        account_code  
    Dictionary Should Contain Key     ${RESP_TRANSF}        entity  
    Dictionary Should Contain item    ${RESP_TRANSF}        name                  Fulano da Silva  


ENTÃO devera ser retornado mensagem de "${erro}"

    IF             '${erro}' == 'não autorizado'
                    Log                               ${RESP_TRANSF}
              
                    Should Be Equal As Numbers        ${STATUS_CODE_TRANSF}         403
                    Dictionary Should Contain Item    ${RESP_TRANSF}                type        srn:error:unauthorized

    ELSE IF       '${erro}' == 'não autenticado'    
                    Log                               ${RESP_TRANSF}
              
                    Should Be Equal As Numbers        ${STATUS_CODE_TRANSF}         401
                    Dictionary Should Contain Item    ${RESP_TRANSF}                type        srn:error:unauthenticated

    ELSE IF       '${erro}' == 'não autenticado'    
                    Log                               ${RESP_TRANSF}
              
                    Should Be Equal As Numbers        ${STATUS_CODE_TRANSF}         400
                    Dictionary Should Contain Item    ${RESP_TRANSF}                type        srn:error:validation

    END
