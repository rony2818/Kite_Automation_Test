*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${ELEMENT_LOADING} =  xpath=//*[@id="modal-preloader"]
${ELEMENT_BUTTON_DETAILS} =  xpath=/html/body/div[2]/div[2]/div[2]/div/div[2]/div[2]/div[1]/div[2]/div/div[2]/a
${ELEMENT_MANAGE_TARGET_ROW} =  xpath=//*[starts-with(@id,'ht_')]/div[1]/div/div/div/table/tbody/tr[1]/td[1]  
${ELEMENT_CHECKBOX_MY_EVALUATION} =  xpath=//*[@id="manager"]/div/div[2]/div[1]/div[1]/div[1]/div[1]/div/div[1]


*** Keywords ***
Verify Button Details Disable
    Element Attribute Value Should Be  ${ELEMENT_BUTTON_DETAILS}  disabled  true

Verify Button Details Enabled
    Element Should Be Enabled  ${ELEMENT_BUTTON_DETAILS}

View Detail Evaluation Input
    Click Element  ${ELEMENT_BUTTON_DETAILS}
    Common.Verify Loading

Show All Evaluatee In Manager Target
    Click Element  ${ELEMENT_CHECKBOX_MY_EVALUATION}