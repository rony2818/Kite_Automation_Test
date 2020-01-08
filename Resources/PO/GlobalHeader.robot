*** Settings ***
Documentation  Amazon top navigation
Library  SeleniumLibrary

*** Variables ***
${GLOBAL_HEADER_ELEMENT} =  xpath=//*[@id="app"]/div/div[2]/div/header
${GLOBAL_HEADER_OKR} =  xpath=//*[@id="app"]/div/div[2]/div/header/div/div[1]/div/div[2]/div/a[2]
${GLOBAL_HEADER_TAB} =  xpath=//*[@id="app"]/div/div[2]/div/header/div/div[1]/div/div[2]/div/a[3]

*** Keywords ***
Verify Global Header Show
    Wait Until Page Contains Element  ${GLOBAL_HEADER_ELEMENT}

Verify Tab OKR Active
    Element Attribute Value Should Be  ${GLOBAL_HEADER_OKR}  class  v-tab--active v-tab

Go To MBO
    Click Element  ${GLOBAL_HEADER_TAB}