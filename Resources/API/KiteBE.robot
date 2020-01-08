*** Settings ***
Library  RequestsLibrary

*** Variables ***
&{URL_BE}  local=http://localhost:8080/kite/webapi  it=https://kite-dev-it-vn.hito-link.jp/webapi  st=https://st-performance.hito-link.jp/webapi

*** Keywords ***
Create Session For Server
    Create Session  my_session  ${URL_BE.${ENVIRONMENT}}
    Set Global Variable     ${session}      my_session

Login Get Session
    [Arguments]  ${User}
    Create Session For Server
    &{params} =  Create Dictionary  tenantcd=${User.Tenant}  employeemail=${User.Email}  password=${User.Password}

    ${response} =  Post Request   ${session}  /auth/login/confirm  params=${params}

    Should Be Equal As Strings  ${response.status_code}  200

Get User Info
    [Arguments]  ${User}
    ${response} =  Get Request  ${session}  /auth/userInfo
    Log  ${response}

    Should Be Equal As Strings  ${response.status_code}  200

    Set Suite Variable  ${LOGIN_USER}  ${response.json()}
    Log  ${LOGIN_USER}

    Should Be Equal As Strings  ${LOGIN_USER['usermail']}  ${User.Email}

    Set Suite Variable  ${IS_SUPPORT_ACCOUNT}  False
    Run Keyword If    '${LOGIN_USER['adminFlg']}' == 'True'    Set Suite Variable  ${IS_SUPPORT_ACCOUNT}  True

    Set Suite Variable  ${IS_ADMIN}  False
    :FOR  ${authority}  IN  @{LOGIN_USER['authorities']}
    \   Log  ${authority['authority']}
    \   Run Keyword If    '${authority['authority']}'=='00000'    Set Suite Variable  ${IS_ADMIN}  True

    Set Suite Variable  ${IS_SYSTEM_ADMIN}  False
    Run Keyword If    '${IS_SUPPORT_ACCOUNT}'=='True' or '${IS_ADMIN}'=='True'   Set Suite Variable  ${IS_SYSTEM_ADMIN}  True

    Log  ${IS_SUPPORT_ACCOUNT}
    Log  ${IS_ADMIN}
    Log  ${IS_SYSTEM_ADMIN}

Get Evaluation Input
    [Arguments]  ${eventId}  ${evaluateeId}
    ${response} =  Get Request  ${session}  /evaluation/input/${eventId}/${evaluateeId}
    Should Be Equal As Strings  ${response.status_code}  200

    Set Suite Variable  ${EVALUATION_INPUT}  ${response.json()}
    Log  ${EVALUATION_INPUT}

    ${response} =  Get Request  ${session}  /evaluation/input/${eventId}/${evaluateeId}?phaseSteps
    Should Be Equal As Strings  ${response.status_code}  200

    Set Suite Variable  ${EVALUATION_PHASE_STEPS}  ${response.json()['phaseSteps']}
    Log  ${EVALUATION_PHASE_STEPS}