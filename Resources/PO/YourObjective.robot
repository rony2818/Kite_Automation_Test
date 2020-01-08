*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${ELEMENT_BUTTON_TARGET_CONFIRMATION} =  xpath=/html/body/div[2]/div[2]/div[2]/div/div[2]/div[2]/div[1]/div[2]/div/div[1]/a
${ELEMENT_EVALUATION_INPUT_TITLE} =  xpath=/html/body/div[2]/div[2]/div[2]/div/div/div[1]
${WINDOWS_EVALUATION_TAB_TITLE} =  title=MBO - HITO-Link Performance -
${WINDOWS_EVALUATION_TITLE} =  title=Evaluation - HITO-Link Performance -
${ELEMENT_PHASE_STEPS} =  xpath=//*[starts-with(@id,'goal-')]/div/div[1]/div[1]/div/div[3]/ul/li
${ELEMENT_SUBMITED} =  xpath=//*[starts-with(@id,'goal-')]/div/div[1]/div[2]/div/div/div[2]/a
${ELEMENT_SAVE} =  xpath=//*[starts-with(@id,'goal-')]/div/div[1]/div[2]/div/div/div[1]/a
${ELEMENT_EVALUATION_SUBMIT} =  xpath=//*[starts-with(@id,'goal-')]/div/div[1]/div[2]/div/div/div[2]/a
${ELEMENT_APPROVE} =  xpath=//*[starts-with(@id,'goal-')]/div/div[1]/div[2]/div/div/div[2]/a
${ELEMENT_REJECT_SELFCHECK} =  xpath=//*[starts-with(@id,'goal-')]/div/div[1]/div[2]/div/div/div[3]/a[1]
${ELEMENT_REJECT} =  xpath=//*[starts-with(@id,'goal-')]/div/div[1]/div[2]/div/div/div[3]/a[2]
${ELEMENT_WAITING} =  xpath=//*[starts-with(@id,'goal-')]/div/div[1]/div[2]/div/div/div[2]/a
${ELEMENT_DIALOG_EVLUATION_OK} =  xpath=//*[contains(@class,'modal modal-small modal-fixed-footer')]/div[2]/div/div[2]/a

*** Keywords ***
Verify Button Target Confirmation Disable
    Element Attribute Value Should Be  ${ELEMENT_BUTTON_TARGET_CONFIRMATION}  disabled  true

Verify Button Target Confirmation Enabled
    Element Should Be Enabled  ${ELEMENT_BUTTON_TARGET_CONFIRMATION}

Go To Evaluation Input
    MBO.Select Evaluation Event  4
    ${locator} =  Set Variable  ${ELEMENT_TEMPLATE_TABLE_ROW_INDEX.replace('%', '4')}
    ${EventNm} =  Get Text  ${locator}
    Click Element  ${ELEMENT_BUTTON_TARGET_CONFIRMATION}
    sleep  1s
    Switch Window  ${WINDOWS_EVALUATION_TAB_TITLE}
    ${IsElementVisible} =  Run Keyword And Return Status    Element Should Be Visible   ${DIALOG_TRIAL_BUTTON}
    Run Keyword If    ${IsElementVisible}  Common.Close Dialog Trial
    ${EvaluationInputTitle} =  Get Text  ${ELEMENT_EVALUATION_INPUT_TITLE}
    Should Contain  ${EvaluationInputTitle}  ${EventNm}
    Should Contain  ${EvaluationInputTitle}  Your object
    Get Event Id And Evaluatee Id

Evaluation Approve End To End
    ${typeTestCase} =  Set Variable  End To End
    # IMPROVE LOOP LATER
    :FOR    ${i}    IN RANGE    999999
    \   KiteBE.Get Evaluation Input  ${EVENT_ID}  ${EVALUATEE_ID}
    \   Set Suite Variable  ${isEvaluationFinished}  ${EVALUATION_INPUT['completeFlg']}
    \   Exit For Loop If    '${isEvaluationFinished}' == 'True'
    \   Goal Action  ${typeTestCase}

Get Event Id And Evaluatee Id
    ${url} =   Get Location
    @{words} =  Split String  ${url}  /
    ${id} =  Get From List  ${words}  -1
    Set Suite Variable  ${EVALUATEE_ID}  ${id}
    ${id} =  Get From List  ${words}  -2
    Set Suite Variable  ${EVENT_ID}  ${id}

Goal Action
    [Arguments]  ${typeTestCase}
    Log  ${typeTestCase}
    ${count} =  Get Element Count    ${ELEMENT_PHASE_STEPS}
    :FOR    ${index}    IN RANGE    0    ${count}
    \   ${attribute} =  Get Element Attribute  xpath=//*[starts-with(@id,'goal-')]/div/div[1]/div[1]/div/div[3]/ul/li[${index + 1}]/div[1]/div[1]/i  class
    \   Run Keyword If    '${attribute}' == 'ico-ongoing ico-middle active'    Set Suite Variable  ${processingStepIndex}  ${index}

    ${isEvaluatee} =  Run Keyword If  '${EVALUATEE_ID}' == '${USER_LOGIN_ID}'  Set variable    True
    ...     ELSE  Set variable    False

    ${isSelfCheckProcessing} =  Run Keyword If  '${processingStepIndex}' == '0'  Set variable    True
    ...     ELSE  Set variable    False

    # TODO process calculate validFlg base on startDate and endDate of EVALUATION_INPUT
    ${validFlg} =  Set Variable  True  # ${EVALUATION_INPUT['validFlg']}

    ${isEvaluator} =  Set Variable  False
    
    # Depend api for check isEvaluator
    # ${count} =  Get Length  ${EVALUATION_PHASE_STEPS}
    # :FOR  ${index}  IN RANGE    0    ${count}
    # \   Continue For Loop If    '${index}'=='0'  # ingore step self check
    # \   Exit For Loop If    '${isEvaluatee}'=='True' and ${index} > ${processingStepIndex + 1}
    # \   ${phaseStep} =  Get From List  ${EVALUATION_PHASE_STEPS}  ${index}
    # \   ${isEvaluator} =  Run Keyword If  '${USER_LOGIN_ID}' in ${phaseStep["employeeIds"]}  Set variable    True

    # Depend UI for check isEvaluator
    :FOR    ${index}    IN RANGE    0    ${count}
    \   Continue For Loop If    '${index}'=='0'  # ingore step self check
    \   Exit For Loop If    '${isEvaluatee}' == 'True' and ${index} > ${processingStepIndex}
    \   ${urlImgPIC} =  Get Element Attribute  xpath=//*[starts-with(@id,'goal-')]/div/div[1]/div[1]/div/div[3]/ul/li[${index + 1}]/div[2]/div/span/img  src
    \   @{tmp} =  Split String  ${urlImgPIC}  /
    \   ${idPIC} =  Get From List  ${tmp}  -3
    \   ${isEvaluator} =  Run Keyword If  '${USER_LOGIN_ID}' == '${idPIC}'  Set variable    True

    # Depend api for check isPersonInCharge
    # ${processingStep} =  Get From List  ${EVALUATION_PHASE_STEPS}  ${processingStepIndex}
    # ${isPersonInCharge} =  Run Keyword If  '${isEvaluationFinished}'=='True'  Set variable    False
    # ...     ELSE IF  '${IS_SYSTEM_ADMIN}'=='True' and '${isSelfCheckProcessing}'=='False'  Set variable    True
    # ...     ELSE IF  '${USER_LOGIN_ID}' in ${processingStep["employeeIds"]}  Set variable    True
    # ...     ELSE  Set variable    False

    # Depend UI for check isPersonInCharge
    ${urlImgPICCurrentStep} =  Get Element Attribute  xpath=//*[starts-with(@id,'goal-')]/div/div[1]/div[1]/div/div[3]/ul/li[${processingStepIndex + 1}]/div[2]/div/span/img  src
    @{tmp} =  Split String  ${urlImgPICCurrentStep}  /
    ${idPICCurrentStep} =  Get From List  ${tmp}  -3
    ${isPersonInCharge} =  Run Keyword If  '${isEvaluationFinished}' == 'True'  Set variable    False
    ...     ELSE IF  '${IS_SYSTEM_ADMIN}' == 'True' and '${isSelfCheckProcessing}' == 'False'  Set variable    True
    ...     ELSE IF  '${USER_LOGIN_ID}' == '${idPICCurrentStep}'  Set variable    True
    ...     ELSE  Set variable    False

    ${isNextPhaseProcessing} =  Run Keyword If  '${processingStepIndex}' == '${count - 1}'  Set variable    True  ELSE  Set variable    False

    ${isSave} =  Run Keyword If  '${isPersonInCharge}' == 'True' and '${validFlg}' == 'True' and '${isEvaluationFinished}' == 'False'  Set variable  True
    ...  ELSE  Set variable    False

    ${submitted} =  Run Keyword If  '${IS_SYSTEM_ADMIN}' == 'True' or '${isEvaluator}' == 'True'  Set variable  False
    ...  ELSE IF  '${isEvaluatee}' == 'True' and '${isNextPhaseProcessing}' == 'True' and '${isEvaluationFinished}' == 'False'  Set variable  True
    ...  ELSE  Set variable    False

    ${approvable} =  Run Keyword If  '${validFlg}' == 'False'  Set variable  False
    ...  ELSE IF  '${IS_SYSTEM_ADMIN}' == 'True' and '${isSelfCheckProcessing}' == 'False' and '${isEvaluationFinished}' == 'False'  Set variable  True
    ...  ELSE IF  '${isEvaluator}' == 'True' and '${isPersonInCharge}' == 'True' and '${isSelfCheckProcessing}' == 'False'  Set variable  True
    ...  ELSE  Set variable    False

    ${isReject} =  Set Variable  False
    :FOR  ${index}  IN RANGE    0    ${count}
    \   Continue For Loop If    '${index}'=='0'
    \   Exit For Loop If    '${isEvaluatee}' == 'True' and ${index} > ${processingStepIndex}
    \   ${phaseStep} =  Get From List  ${EVALUATION_PHASE_STEPS}  ${index}
    \   ${isReject} =  Run Keyword If  '${USER_LOGIN_ID}' in ${phaseStep["employeeIds"]}  Set variable    True
    
    ${rejectable} =  Run Keyword If  '${validFlg}' == 'False'  Set variable  False
    ...  ELSE IF  '${IS_SYSTEM_ADMIN}' == 'True' and '${isSelfCheckProcessing}' == 'False' and '${isEvaluationFinished}' == 'False'  Set variable  True
    ...  ELSE IF  '${isEvaluationFinished}' == 'True' or '${isEvaluator}' == 'False'  Set variable  False
    ...  ELSE IF  '${isReject}' == 'True'  Set variable  True
    ...  ELSE  Set variable    False

    ${submittable} =  Run Keyword If  '${IS_SYSTEM_ADMIN}' == 'True' and '${isSelfCheckProcessing}' == 'True' and '${validFlg}' == 'True'  Set variable  True
    ...  ELSE IF  '${isEvaluatee}' == 'True' and '${isPersonInCharge}' == 'True' and '${isSelfCheckProcessing}' == 'True' and '${validFlg}' == 'True'  Set variable  True
    ...  ELSE  Set variable    False

    ${isWaiting} =  Set Variable  False
    :FOR  ${index}  IN RANGE    0    ${count}
    \   Continue For Loop If    ${index} <= ${processingStepIndex}
    \   ${phaseStep} =  Get From List  ${EVALUATION_PHASE_STEPS}  ${index}
    \   ${isWaiting} =  Run Keyword If  '${USER_LOGIN_ID}' in ${phaseStep["employeeIds"]}  Set variable    True

    ${unsubmitted} =  Run Keyword If  '${isSelfCheckProcessing}' == 'True' and '${isEvaluator}' == 'True'  Set variable  True
    ...  ELSE IF  '${isEvaluationFinished}' == 'True' or '${isEvaluator}' == 'False' or '${submittable}' == 'True' or '${rejectable} '== 'True'  Set variable  False
    ...  ELSE IF  '${isWaiting}' == 'True'  Set variable  True
    ...  ELSE  Set variable    False


    Run Keyword If  '${isSave}' == 'True'  Button Save  ${isSave}
    Run Keyword If  '${submitted}' == 'True'  Button Submitted  ${submitted}
    Run Keyword If  '${approvable}' == 'True'  Button Approve  ${approvable}
    Run Keyword If  '${rejectable}' == 'True'  Button Reject  ${rejectable}
    Run Keyword If  '${submittable}' == 'True'  Button Submit  ${submittable}
    Run Keyword If  '${unsubmitted}' == 'True'  Button Unsubmit  ${unsubmitted}

    # ACTION
    Run Keyword If  '${typeTestCase}' == 'End To End'
    ...  Run Keywords
    ...  Run Keyword If  '${submittable}' == 'True'  Evaluation Submit
    ...  AND  Run Keyword If  '${approvable}' == 'True'  Evaluation Approve

Evaluation Submit
    Click Element  ${ELEMENT_EVALUATION_SUBMIT}
    sleep  1s
    Wait Until Page Contains Element  ${ELEMENT_DIALOG_EVLUATION_OK}
    Click Element  ${ELEMENT_DIALOG_EVLUATION_OK}
    Verify Loading

Evaluation Approve
    Click Element  ${ELEMENT_APPROVE}
    sleep  1s
    Wait Until Page Contains Element  ${ELEMENT_DIALOG_EVLUATION_OK}
    Click Element  ${ELEMENT_DIALOG_EVLUATION_OK}
    Verify Loading

Button Save
    [Arguments]  ${isSave}

    Run Keyword If  '${isSave}' == 'True'  Element Should Be Visible   ${ELEMENT_SAVE}
    ...  ELSE  Element Should Not Be Visible   ${ELEMENT_SAVE}

Button Submitted
    [Arguments]  ${submitted}

    Run Keyword If  '${submitted}' == 'True'
    ...  Run Keywords
    ...  Element Should Contain   ${ELEMENT_SUBMITED}  Submitted
    ...  AND  Element Should Be Visible   ${ELEMENT_SUBMITED}

Button Approve
    [Arguments]  ${approvable} 

    Run Keyword If  '${approvable}' == 'True'
    ...  Run Keywords
    ...  Element Should Contain   ${ELEMENT_APPROVE}  Approve
    ...  AND  Element Should Be Visible   ${ELEMENT_APPROVE}

Button Reject
    [Arguments]  ${rejectable}

    Run Keyword If  '${rejectable}' == 'True'
    ...  Run Keywords
    ...  Element Should Contain   ${ELEMENT_REJECT_SELFCHECK}  Reject to selfcheck
    ...  AND  Element Should Contain   ${ELEMENT_REJECT}  Reject
    ...  AND  Element Should Be Visible   ${ELEMENT_REJECT_SELFCHECK}
    ...  AND  Element Should Be Visible   ${ELEMENT_REJECT}

Button Submit
    [Arguments]  ${submittable}

    Run Keyword If  '${submittable}' == 'True'
    ...  Run Keywords
    ...  Element Should Contain   ${ELEMENT_EVALUATION_SUBMIT}  Submit
    ...  AND  Element Should Be Visible   ${ELEMENT_EVALUATION_SUBMIT}

Button Unsubmit
    [Arguments]  ${unsubmitted}

    Run Keyword If  '${unsubmitted}' == 'True'
    ...  Run Keywords
    ...  Element Should Contain   ${ELEMENT_WAITING}  Waiting
    ...  AND  Element Should Be Visible   ${ELEMENT_WAITING}

Verify Page Evaluation Input Again
    Switch Window  ${WINDOWS_EVALUATION_TITLE}
    MBO.Switch MBO Iframe
    Select Evaluation Event Your Objective  2
    ${EventNm} =  Get Text  ${ELEMENT_YOUR_OBJECTIVE_ROW}
    Click Element  ${ELEMENT_BUTTON_TARGET_CONFIRMATION}
    sleep  1s
    Switch Window  ${WINDOWS_EVALUATION_TAB_TITLE}
    ${EvaluationInputTitle} =  Get Text  ${ELEMENT_EVALUATION_INPUT_TITLE}
    Should be equal as strings  ${EventNm}  ${EvaluationInputTitle}  ignore_case=true
