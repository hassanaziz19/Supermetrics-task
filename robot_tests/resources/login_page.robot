*** Settings ***
Documentation    Resource file for login page related keywords
Library    Selenium2Library 

*** Variables ***
${PORTAL_TIMEOUT}                      30 sec
${BROWSER}                             GC
${HOST}                                http://localhost:3000/
${USERNAME_FIELD}                      //input[@id="username"]
${PASSWORD_FIELD}                      //input[@id="password"]
${LOGIN_BUTTON}                        //div[child::input[@id="password"]]/following-sibling::button[contains(.,"Log in")]
${HEADER}                              //span[contains(.,"Supermetrics Kitty Manager")]

*** Keywords ***
Setup and Open Browser 
    [Arguments]    ${open_browser}=True
    Open Browser    ${HOST}   ${BROWSER}
    Maximize Browser Window

Input Login Username
    [Arguments]    ${username}
    Wait Until Element Is Visible    xpath=${USERNAME_FIELD}    ${PORTAL_TIMEOUT}
    Click element    xpath=${USERNAME_FIELD}
    Input Text   xpath=${USERNAME_FIELD}     ${username}
    Textfield Value Should Be     xpath=${USERNAME_FIELD}     ${username}

Input Login Password
    [Arguments]    ${password}
    Wait Until Element Is Visible    xpath=${PASSWORD_FIELD}    ${PORTAL_TIMEOUT}
    Click element    xpath=${PASSWORD_FIELD}
    Input Password   xpath=${PASSWORD_FIELD}     ${password}


Login to Portal
    [Documentation]    Login to the Service Portal
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    xpath=${HEADER}    ${PORTAL_TIMEOUT}
    Input Login Username    ${username}
    Input Login Password    ${password}
    Click Button    ${LOGIN_BUTTON}

Verify Login Page
    Element Should Be Visible    xpath=${USERNAME_FIELD}    message="Login page should be open but is not"

Wait for Login page to load
    Wait Until Element Is Visible    xpath=${USERNAME_FIELD}    5 sec
