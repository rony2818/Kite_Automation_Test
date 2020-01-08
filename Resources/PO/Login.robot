*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${ELEMENT_INPUT_TENANT} =  xpath=//*[@placeholder="Organization code"]
${ELEMENT_INPUT_EMAIL} =  xpath=//*[@placeholder="Email address"]
${ELEMENT_INPUT_PASSWORD} =  xpath=//*[@placeholder="Password"]
${ELEMENT_SUBMIT} =  xpath=//*[@type="submit"]

*** Keywords ***
Verify Page Loaded
    Wait Until Page Contains  LOGIN

Login With Valid Credentials
    [Arguments]  ${User}
    Fill "Tenant" Field  ${User.Tenant}
    Fill "Email" Field  ${User.Email}
    Fill "Password" Field  ${User.Password}
    Click "Log In" Button

Fill "Tenant" Field 
    [Arguments]  ${Tenant}
    Input Text  ${ELEMENT_INPUT_TENANT}  ${Tenant}

Fill "Email" Field
    [Arguments]  ${Email}
    sleep  1s
    Input Text  ${ELEMENT_INPUT_EMAIL}  ${Email}

Fill "Password" Field
    [Arguments]  ${Password}
    sleep  1s
    Input Text  ${ELEMENT_INPUT_PASSWORD}  ${Password}

Click "Log In" Button
    Click Button  ${ELEMENT_SUBMIT}
