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
${ENDPOINT_SALDO}           api/v1/accounts/
${ENDPOINT_EXTRATO}         api/v1/accounts/
${CONTENT_TYPE_URLENCODED}  application/x-www-form-urlencoded
${CONTENT_TYPE_JSON}        application/json

${COOKIE_LOGIN}             KEYCLOAK_LOCALE=pt-BR; __cf_bm=oAwV8SmrMeOi1ubjGyq1DWFsPrPT9_7Ikv.WOIRcluc-1717776169-1.0.1.1-GTwjTRJBdAzu7dZrpIPn0r1HCiRRwBmlzX_1l7ZIvV0jfTbmDR4d0.HQo42tVWmNfuyRSBGxmuxl1a0gXiM3797ugQYobDxKvxUSw9Phdw0
${COOKIE_TRANSF}            KEYCLOAK_LOCALE=__cf_bm=59Ou5vJ149mclqGv.dw7RIwi7.NXgY9UYJYkhr7KZc0-1717802987-1.0.1.1-jOfOSsO9hOacEA8levmPketnshbD2UpZsD_BaB3dVaGalx47n8uX6z_fWWUDGQQhQlYjpv4P1rvANAk5qpQiZw
${COOKIE_SALDO}             __cf_bm=0uZzJiZCifxKPCRbKrB9lsrUUJHwlsnu05Ad4MJIM2g-1717877689-1.0.1.1-7yL3kh7DumnghbEVqoM5knnToXoZ_U7u62X0le1_UNb2Nsd923aGUw6f5mBdb6V1FkfdD6VWW45BkNLX.qI9IA
${COOKIE_EXTRATO}           __cf_bm=imt6ap1qN9EGF2itHTLNI_pkyJ6wcz1nrojNdvve9fg-1717883498-1.0.1.1-yKMV6ucQPoSGtu8qqggDljWyRR5FL14y2n6KdU7cnoYHKhpSZOBkQK_aUNpycGlYcKN.NbUeuBm.VzCIZkGGjw
&{USUARIO_VALIDO}           client_id=admin-cli    username=desafioqastone@gmail.com    password=desafioqa           grant_type=password
&{USUARIO_SEM_ESCOPO}       client_id=admin-cli    username=desafioqastone@gmail.com    password=desafioqa           grant_type=password
&{USUARIO_SENHA_INVALIDA}   client_id=admin-cli    username=desafioqastone@gmail.com    password=Invalidoesafioqa    grant_type=password
&{USUARIO_INVALIDO}         client_id=admin-cli    username=invalidoqastone@gmail.com   password=esafioqa            grant_type=password
&{HEADERS_LOGIN}            Content-Type=${CONTENT_TYPE_URLENCODED}     Cookie=${COOKIE_LOGIN}
&{HEADERS_TRANSF}           Content-Type=${CONTENT_TYPE_JSON}           Cookie=${COOKIE_TRANSF}
&{HEADERS_SALDO}            Cookie=${COOKIE_SALDO}
&{HEADERS_EXTRATO}          Content-Type=${CONTENT_TYPE_JSON}           Cookie=${COOKIE_EXTRATO}
${BODY_TRANSF_VALIDA}       {"amount": 1, "target": {"account": {"account_code": "475384"}}, "description": "limite de 200 caracteres", "schedule_to": "2021-09-20"}
${BODY_TRANSF_SEM_ESCOPO}   {"amount": 1, "target": {"account": {"account_code": "475384"}}, "description": "limite de 200 caracteres", "schedule_to": "2021-09-20"}
${BODY_TRANSF_INVALIDA}     {"amount": 1, "target": {"account": {"account_code": "475384"}}, "description": "limite de 200 caracteres", "schedule_to": "2021-09-20"}
${EXTRATO_QUERY_PARAM}      /statement?limit=100&start_datetime=2023-01-01T00:00:00Z&end_datetime=2023-12-31T23:59:59Z

*** Keywords ***

DADO que estou utilizando a "${texto}"
    Log          ${texto}

    IF           '${texto}' == 'api Login'
                        Create Session       StoneCO        ${BASE_URL_LOGIN}

    ELSE IF      '${texto}' == 'api OpenBank/internal_transfers' or '${texto}' == 'api OpenBank/balance' or '${texto}' == 'api OpenBank/statement'
                                    DADO que estou utilizando a "api Login"
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

   ELSE IF       '${status_usuario}' == 'sem escopo'
                        Set Test Variable    ${BODY_LOGIN}      ${USUARIO_SEM_ESCOPO}
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

QUANDO informo os dados de saldo "${status_saldo}"

    IF            '${status_saldo}' == 'validos'

                        Set Test Variable      ${SALDO_ACCESS_TOKEN}       ${ACCESS_TOKEN}
                        Set Test Variable      ${SALDO_SESSION_STATE}      ${SESSION_STATE}

    ELSE IF       '${status_saldo}' == 'validos mas sem escopo'    
                        Set Test Variable      ${SALDO_ACCESS_TOKEN}       ${ACCESS_TOKEN}
                        Set Test Variable      ${SALDO_SESSION_STATE}      ${SESSION_STATE}
    
    ELSE IF       '${status_saldo}' == 'validos mas sem autenticacao'    
                        Set Test Variable      ${SALDO_ACCESS_TOKEN}       ${ACCESS_TOKEN}123
                        Set Test Variable      ${SALDO_SESSION_STATE}      ${SESSION_STATE}

    ELSE IF       '${status_saldo}' == 'com conta invalida'    
                        Set Test Variable      ${SALDO_ACCESS_TOKEN}       ${ACCESS_TOKEN}
                        Set Test Variable      ${SALDO_SESSION_STATE}      ${SESSION_STATE}4213
    ELSE                
                  Fail   O saldo ${status_saldo} tem um valor desconhecido!

    END

QUANDO informo os dados de extrato "${status_extrato}"

    IF            '${status_extrato}' == 'validos'

                        Set Test Variable      ${EXTRATO_ACCESS_TOKEN}       ${ACCESS_TOKEN}
                        Set Test Variable      ${EXTRATO_SESSION_STATE}      ${SESSION_STATE}

    ELSE IF       '${status_extrato}' == 'validos mas sem escopo'    
                        Set Test Variable      ${EXTRATO_ACCESS_TOKEN}       ${ACCESS_TOKEN}
                        Set Test Variable      ${EXTRATO_SESSION_STATE}      ${SESSION_STATE}
    
    ELSE IF       '${status_extrato}' == 'validos mas sem autenticacao'    
                        Set Test Variable      ${EXTRATO_ACCESS_TOKEN}       ${ACCESS_TOKEN}123
                        Set Test Variable      ${EXTRATO_SESSION_STATE}      ${SESSION_STATE}

    ELSE IF       '${status_extrato}' == 'com conta invalida'    
                        Set Test Variable      ${EXTRATO_ACCESS_TOKEN}       ${ACCESS_TOKEN}
                        Set Test Variable      ${EXTRATO_SESSION_STATE}      ${SESSION_STATE}4213
    ELSE                
                  Fail   O saldo ${status_extrato} tem um valor desconhecido!

    END
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
    Set Test Variable                 ${RESP_TRANSF}                ${resposta_transferencia.json()}

E faço a requisição de buscar saldo
    ${saldo_access_token}    Set Variable    Bearer ${SALDO_ACCESS_TOKEN}
    Log    ${saldo_access_token}
    Set To Dictionary    ${HEADERS_SALDO}    Authorization=${saldo_access_token}
    Log    ${HEADERS_SALDO}

    ${resposta_saldo}    GET On Session     
    ...                               StoneCO    
    ...                               url=${ENDPOINT_SALDO}${SALDO_SESSION_STATE}/balance          
    ...                               headers=${HEADERS_SALDO}
    ...                               expected_status=any 
    log                               ${resposta_saldo.json()}

    Set Test Variable                 ${STATUS_CODE_SALDO}         ${resposta_saldo.status_code}    
    Set Test Variable                 ${RESP_SALDO}                ${resposta_saldo.json()}

E faço a requisição de buscar extrato
    ${extrato_access_token}    Set Variable    Bearer ${EXTRATO_ACCESS_TOKEN}
    Log    ${extrato_access_token}
    Set To Dictionary    ${HEADERS_EXTRATO}    Authorization=${extrato_access_token}
    Log    ${HEADERS_EXTRATO}

    ${urlcompleta}             Set Variable    ${ENDPOINT_EXTRATO}${EXTRATO_SESSION_STATE}${EXTRATO_QUERY_PARAM}  
    Log    ${urlcompleta}
  
    ${resposta_extrato}    GET On Session     
    ...                               StoneCO    
    ...                               url=${urlcompleta}        
    ...                               headers=${HEADERS_EXTRATO}
    ...                               expected_status=any 
    log                               ${resposta_extrato.json()}

    Set Test Variable                 ${STATUS_CODE_EXTRATO}         ${resposta_extrato.status_code}    
    Set Test Variable                 ${RESP_EXTRATO}                ${resposta_extrato.json()}

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




ENTÃO devera ser retornado os dados da transferencia com sucesso
    Log                              ${RESP_TRANSF}
              
    Should Be Equal As Numbers        ${STATUS_CODE_TRANSF}     200
    Dictionary Should Contain Item    ${RESP_TRANSF}            amount                    1
    Dictionary Should Contain item    ${RESP_TRANSF}            name                      Fulano da Silva
    Dictionary Should Contain Item    ${RESP_TRANSF}            status                    APRROVED     
    Dictionary Should Contain Key     ${RESP_TRANSF}            approval_expired_at
    Dictionary Should Contain Key     ${RESP_TRANSF}            approved_at
    Dictionary Should Contain Key     ${RESP_TRANSF}            approved_by
    Dictionary Should Contain Key     ${RESP_TRANSF}            cancelled_at
    Dictionary Should Contain Key     ${RESP_TRANSF}            created_at
    Dictionary Should Contain Key     ${RESP_TRANSF}            created_by    
    Dictionary Should Contain Key     ${RESP_TRANSF}            description
    Dictionary Should Contain Key     ${RESP_TRANSF}            failed_at
    Dictionary Should Contain Key     ${RESP_TRANSF}            fee  
    Dictionary Should Contain Key     ${RESP_TRANSF}            finished_at  
    Dictionary Should Contain Key     ${RESP_TRANSF}            id  
    Dictionary Should Contain Key     ${RESP_TRANSF}            rejected_at  
    Dictionary Should Contain Key     ${RESP_TRANSF}            rejected_by  
    Dictionary Should Contain Key     ${RESP_TRANSF}            scheduled_to  
    Dictionary Should Contain Key     ${RESP_TRANSF}            target  
    Dictionary Should Contain Key     ${RESP_TRANSF}            account  
    Dictionary Should Contain Key     ${RESP_TRANSF}            account_code  
    Dictionary Should Contain Key     ${RESP_TRANSF}            entity  


ENTÃO devera ser retornado os dados do saldo com sucesso
    Log                              ${RESP_SALDO}
              
    Should Be Equal As Numbers        ${STATUS_CODE_SALDO}    200
    Dictionary Should Contain Key     ${RESP_SALDO}           balance
    Dictionary Should Contain Key     ${RESP_SALDO}           blocked_balance
    Dictionary Should Contain Key     ${RESP_SALDO}           scheduled_balance

ENTÃO devera ser retornado os dados do extrato com sucesso
    Log                              ${RESP_EXTRATO}
              
    Should Be Equal As Numbers        ${STATUS_CODE_EXTRATO}      200
    Dictionary Should Contain Key     ${RESP_EXTRATO}             after
    Dictionary Should Contain Key     ${RESP_EXTRATO}             before
    Dictionary Should Contain Key     ${RESP_EXTRATO}             amount
    Dictionary Should Contain Key     ${RESP_EXTRATO}             balance_after
    Dictionary Should Contain Key     ${RESP_EXTRATO}             balance_before
    Dictionary Should Contain Key     ${RESP_EXTRATO}             account_code
    Dictionary Should Contain Key     ${RESP_EXTRATO}             branch_code
    Dictionary Should Contain Key     ${RESP_EXTRATO}             institution
    Dictionary Should Contain Key     ${RESP_EXTRATO}             institution_name
    Dictionary Should Contain Key     ${RESP_EXTRATO}             name
    Dictionary Should Contain Key     ${RESP_EXTRATO}             created_at
    Dictionary Should Contain Key     ${RESP_EXTRATO}             description
    Dictionary Should Contain Key     ${RESP_EXTRATO}             fee_amount    
    Dictionary Should Contain Key     ${RESP_EXTRATO}             id
    Dictionary Should Contain Key     ${RESP_EXTRATO}             operation
    Dictionary Should Contain Key     ${RESP_EXTRATO}             operation_amount
    Dictionary Should Contain Key     ${RESP_EXTRATO}             operation_id
    Dictionary Should Contain Key     ${RESP_EXTRATO}             scheduled_at
    Dictionary Should Contain Key     ${RESP_EXTRATO}             scheduled_to
    Dictionary Should Contain Key     ${RESP_EXTRATO}             status
    Dictionary Should Contain Key     ${RESP_EXTRATO}             type
ENTÃO devera ser retornado mensagem de login erro 
    Log    ${RESP_CADASTRO}
    Log    ${STATUS_CODE}

    Dictionary Should Contain Item    ${RESP_CADASTRO}        error                 invalid_grant
    Dictionary Should Contain Item    ${RESP_CADASTRO}        error_description     Invalid user credentials
    Should Be Equal As Numbers        ${STATUS_CODE}          401  

ENTÃO devera ser retornado mensagem de erro transação "${erro}"

    IF             '${erro}' == 'não autorizado'
                    Log                               ${RESP_TRANSF}
              
                    Should Be Equal As Numbers        ${STATUS_CODE_TRANSF}         403
                    Dictionary Should Contain Item    ${RESP_TRANSF}                type        srn:error:unauthorized

    ELSE IF       '${erro}' == 'não autenticado'    
                    Log                               ${RESP_TRANSF}
              
                    Should Be Equal As Numbers        ${STATUS_CODE_TRANSF}         401
                    Dictionary Should Contain Item    ${RESP_TRANSF}                type        srn:error:unauthenticated

    ELSE IF       '${erro}' == 'conta invalida'    
                    Log                               ${RESP_TRANSF}
              
                    Should Be Equal As Numbers        ${STATUS_CODE_TRANSF}         400
                    Dictionary Should Contain Item    ${RESP_TRANSF}                type        srn:error:validation

    END

ENTÃO devera ser retornado mensagem de erro saldo "${erro}"

    IF             '${erro}' == 'não autorizado'
                    Log                               ${RESP_SALDO}
              
                    Should Be Equal As Numbers        ${STATUS_CODE_SALDO}         403
                    Dictionary Should Contain Item    ${RESP_SALDO}                reason      insufficient_permission
                    Dictionary Should Contain Item    ${RESP_SALDO}                type        srn:error:unauthorized

    ELSE IF       '${erro}' == 'não autenticado'    
                    Log                               ${RESP_SALDO}
              
                    Should Be Equal As Numbers        ${STATUS_CODE_SALDO}         401
                    Dictionary Should Contain Item    ${RESP_SALDO}                type        srn:error:unauthenticated

    ELSE IF       '${erro}' == 'conta invalida'    
                    Log                               ${RESP_SALDO}
              
                    Should Be Equal As Numbers        ${STATUS_CODE_SALDO}         403
                    Dictionary Should Contain Item    ${RESP_SALDO}                type   srn:error:unauthorized

    END

ENTÃO devera ser retornado mensagem de erro extrato "${erro}"

    IF             '${erro}' == 'não autorizado'
                    Log                               ${RESP_EXTRATO}
              
                    Should Be Equal As Numbers        ${STATUS_CODE_EXTRATO}         403
                    Dictionary Should Contain Item    ${RESP_EXTRATO}                reason      insufficient_permission
                    Dictionary Should Contain Item    ${RESP_EXTRATO}                type        srn:error:unauthorized

    ELSE IF       '${erro}' == 'não autenticado'    
                    Log                               ${RESP_EXTRATO}
              
                    Should Be Equal As Numbers        ${STATUS_CODE_EXTRATO}         401
                    Dictionary Should Contain Item    ${RESP_EXTRATO}                type        srn:error:unauthenticated

    ELSE IF       '${erro}' == 'conta invalida'    
                    Log                               ${RESP_EXTRATO}
              
                    Should Be Equal As Numbers        ${STATUS_CODE_EXTRATO}         403
                    Dictionary Should Contain Item    ${RESP_EXTRATO}                type   srn:error:unauthorized

    END
    