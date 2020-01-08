*** Settings ***
Library  SeleniumLibrary
Library  Collections

*** Variables ***
${ELEMENT_IFRAME} =  xpath=//*[@id="app"]/div/div[2]/main/div/iframe
${ELEMENT_MENU_YOUR_OBJECTIVE} =  xpath=/html/body/div[2]/div[2]/div[1]/div/div/div/ul/li[1]/a/div/div[2]
${TEXT_YOUR_OBJECTIVE_EN} =  Your objective
${ELEMENT_MENU_MANAGE_TARGET} =  xpath=/html/body/div[2]/div[2]/div[1]/div/div/div/ul/li[2]/a/div/div[2]
${TEXT_MANAGE_TARGET_EN} =  Manage target
${ELEMENT_MBO_INPUT} =  xpath=//*[starts-with(@id,'goal-')]/div/div[1]/div[1]/div
${ELEMENT_LOADING} =  xpath=//*[@id="modal-preloader"]
${ELEMENT_TITLE_EVALUATION} =  xpath=/html/body/div[2]/div[2]/div[2]/div/div[2]/div[1]
${TEXT_YOUR_OBJECTIVE_TITLE_EN} =  Your objective
${TEXT_YOUR_MANAGE_TARGET_EN} =  Manage target
@{List_Event_Name}
${ELEMENT_TABLE} =  xpath=//*[starts-with(@id,'ht_')]/div[1]/div/div/div/table
${ELEMENT_TEMPLATE_TABLE_ROW_INDEX} =  xpath=//*[starts-with(@id,'ht_')]/div[1]/div/div/div/table/tbody/tr[(%)]/td[1]


*** Keywords ***
Switch MBO Iframe
    Wait Until Page Contains Element  ${ELEMENT_IFRAME}  5s
    Select Frame  ${ELEMENT_IFRAME}

Verify MBO Menu Left Side
    Wait Until Page Contains Element  ${ELEMENT_MENU_YOUR_OBJECTIVE}  15s
    sleep  1s
    Element Text Should Be  ${ELEMENT_MENU_YOUR_OBJECTIVE}  ${TEXT_YOUR_OBJECTIVE_EN}
    Wait Until Page Contains Element  ${ELEMENT_MENU_MANAGE_TARGET}
    Element Text Should Be  ${ELEMENT_MENU_MANAGE_TARGET}  ${TEXT_MANAGE_TARGET_EN}

Go To Your Objective
    Click Element  ${ELEMENT_MENU_YOUR_OBJECTIVE}
    # Verify Loading
    Element Text Should Be  ${ELEMENT_TITLE_EVALUATION}  ${TEXT_YOUR_OBJECTIVE_TITLE_EN}

Go To Manager Target
    Click Element  ${ELEMENT_MENU_MANAGE_TARGET}
    # Verify Loading
    Element Text Should Be  ${ELEMENT_TITLE_EVALUATION}  ${TEXT_YOUR_MANAGE_TARGET_EN}

Get List Event Event Name
    Wait Until Page Contains Element  ${ELEMENT_TABLE}
    @{elemnts} =  Get Webelements    ${ELEMENT_TABLE}
    ${row_count} =  Get Element Count  ${ELEMENT_TABLE}/tbody/tr   # Get row count
    :FOR    ${row_index}    IN RANGE    1    ${row_count + 1}
    \    ${event_nm} =  Get Table Cell  ${ELEMENT_TABLE}  ${row_index + 1}  2
    \    Log  ${event_nm}
    \    Append To List  ${List_Event_Name}  ${event_nm}

Select Evaluation Event
    [Arguments]  ${index}
    ${locator} =  Set Variable  ${ELEMENT_TEMPLATE_TABLE_ROW_INDEX.replace('%', '${index}')}
    Click Element  ${locator}
    # Click Element  ${locator}  modifier=CTRL
    # ${index} =  Evaluate      ${index} + 1
    # ${locator} =  Set Variable  ${ELEMENT_TEMPLATE_TABLE_ROW_INDEX.replace('%', '${index}')}
    # Click Element  ${locator}  modifier=CTRL

View Detail Evaluation Input
    YourObjective.Verify Button Target Confirmation Disable
    Run keyword unless  ${List_Event_Name} == @{EMPTY}  YourObjective.Go To Evaluation Input

Evaluation Action
    YourObjective.Verify Button Target Confirmation Disable
    Run keyword unless  ${List_Event_Name} == @{EMPTY}
    ...  Run Keywords
    ...  YourObjective.Go To Evaluation Input
    ...  AND  YourObjective.Evaluation Approve End To End