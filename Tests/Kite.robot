*** Settings ***
Documentation  This is structure and some basic automation test
# notice we're no longer referencing the Selenium2Library in our script!
Resource  ../Resources/Common.robot  # necessary for Setup & Teardown
Resource  ../Resources/KiteApp.robot  # necessary for lower level keywords in test cases
Test Setup  Begin Web Test
Test Teardown  End Web Test

# pip install robotframework-postgresqldb
# pip install -U robotframework-databaselibrary
# pip install -U requests
# pip install -U robotframework-requests
# pip install robotframework-screencaplibrary

# Document Keywords: https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html
# Document BuiltIn: https://robotframework.org/robotframework/latest/libraries/BuiltIn.html

# Copy/paste the below line to Terminal window to execute
# robot -d results -v ENVIRONMENT:local -v Recording:True tests/kite.robot

*** Variables ***
${BROWSER} =  chrome
${ENVIRONMENT} =  it
${Recording} =  False
&{URL}  local=http://localhost:9000/pwa/#/login  it=https://kite-dev-it-vn.hito-link.jp/pwa/#/login  st=https://st-performance.hito-link.jp/pwa/#/login
&{ADMIN_USER}  Tenant=ppt  Email=letu@ppt.com  Password=Tu@123456

*** Test Cases ***
# Kite Home Screen
#     [Documentation]  The home screen app
#     KiteApp.Home Screen

# Open MBO
#     [Documentation]  This is nagivate to MBO page
#     [Tags]  MBO
#     KiteApp.Open Tab MBO

Verify MBO Evaluation Input
    [Documentation]  View Detail Evaluation Input First Time
    [Tags]  Your Objective
    KiteApp.Open Tab MBO
    KiteApp.Your Objective

Verify MBO Action Evaluation Input
    [Documentation]  View Detail Evaluation Input First Time
    [Tags]  Your Objective
    KiteApp.Open Tab MBO
    KiteApp.Action Evaluation Input

# View Detail Evaluation Input Second Time
#     [Documentation]  View Detail Evaluation Input Second Time
#     [Tags]  Your Objective
#     KiteApp.Open Tab MBO
#     KiteApp.View Detail Evaluation Input Again

# Select MBO Manager Target
#     [Documentation]  Select MBO Manager Target
#     [Tags]  Manager Target
#     KiteApp.Open Tab MBO
#     KiteApp.Manager Target