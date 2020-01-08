*** Settings ***
Library  DatabaseLibrary
Library  String
Library  DateTime
Library  Dialogs

# Document DatabaseLibrary: https://franz-see.github.io/Robotframework-Database-Library/api/0.5/DatabaseLibrary.html

*** Variables ***
${DB_NAME} =  kitedb
${DB_USER_NAME} =  kiteuser
${DB_USER_PASSWORD} =  kitepassword
${DB_HOST} =  localhost
${DB_PORT} =  5432

*** Keywords ***
Connect
    [Tags]  Database
    Connect To Database  psycopg2  ${DB_NAME}  ${DB_USER_NAME}  ${DB_USER_PASSWORD}  ${DB_HOST}  ${DB_PORT}

Get User Login Profile
    [Tags]  Database
    [Arguments]  ${User}
    ${queryResult} =  Query  SELECT * FROM employee e INNER JOIN tenant t ON e.tenant_id = t.tenant_id Where tenant_cd = '${User.Tenant}' and employee_mail = '${User.Email}'
    Log  ${queryResult}
    Log  ${queryResult[0][5]}
    # save it at the suite scope so subsequent test can use it
    Set Suite Variable  ${USER_LOGIN_ID}  ${queryResult[0][0]}
    Set Suite Variable  ${USER_Full_NAME}  ${queryResult[0][4]} ${queryResult[0][5]}

Disconnect
    [Tags]  Database
    Disconnect from Database