*** Settings ***
Library  SeleniumLibrary
Library  ScreenCapLibrary
Library  DateTime

*** Variables ***
${DIALOG_TRIAL_BUTTON} =  xpath=//*[@id="app"]/div[2]/div/div/div/div/div[2]/button

*** Keywords ***
Begin Web Test
    Open Browser  about:blank  ${BROWSER}
    Maximize Browser Window
    ${d}=    get time
    Run Keyword If  '${Recording}' == 'True'  Start Video Recording  name=Kite
    LandingPage.Load
    Login.Verify Page Loaded
    Login.Login With Valid Credentials  ${ADMIN_USER}
    Postgres.Connect
    Postgres.Get User Login Profile  ${ADMIN_USER}
    Sleep  5s
    KiteBE.Login Get Session  ${ADMIN_USER}
    KiteBE.Get User Info  ${ADMIN_USER}

End Web Test
    Sleep  3s
    Run Keyword If  '${Recording}' == 'True'  Stop Video Recording
    Close Browser
    Postgres.Disconnect

Verify Loading
    Wait Until Element Is Visible  ${ELEMENT_LOADING}  30s
    Wait Until Element Is Not Visible  ${ELEMENT_LOADING}  30s

Close Dialog Trial
    Wait Until Page Contains Element  ${DIALOG_TRIAL_BUTTON}
    Click Element  ${DIALOG_TRIAL_BUTTON}