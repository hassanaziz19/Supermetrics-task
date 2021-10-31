*** Settings ***
Force Tags   login_tests 

Resource    ../resources/login_page.robot
Resource    ../resources/home_page.robot

Suite Setup    Setup and Open Browser
Suite Teardown    Close Browser
Test Teardown    Reset Data with Button

*** Variables ***
${NORMAL_USER_ID}                user
${NORMAL_USER_PASSWORD}          helloworld
${ADMIN_USER_ID}                 admin
${ADMIN_USER_PASSWORD}           adminpass
${WRONG_USER_ID}                 wrongid
${WRONG_USER_PASSWORD}           wrongpass

*** Test Cases ***
Login with Valid Username and Valid Password
    [Documentation]    User inputs valid username and valid password.
    ...    User is taken to home page with cats list.
    ...    Login should PASS.
    [Tags]    login_case1
    Wait for Login page to load
    Verify Login Page
    Login to Portal    ${NORMAL_USER_ID}    ${NORMAL_USER_PASSWORD}
    Wait for Home page to load
    Verify home page is open
    Logout User

Login with Valid Admin Username and Valid Admin Password
    [Documentation]    User inputs valid admin username and valid admin password.
    ...    User is taken to home page with cats list.
    ...    Login should PASS.
    [Tags]    login_case2
    Wait for Login page to load
    Verify Login Page
    Login to Portal    ${ADMIN_USER_ID}    ${ADMIN_USER_PASSWORD}
    Wait for Home page to load
    Verify home page is open
    Logout User

Login with Valid Username and Invalid Password
    [Documentation]    User inputs valid username and invalid password.
    ...    User is still on login page.
    ...    Login should Fail.
    [Tags]    login_case3
    Wait for Login page to load
    Verify Login Page
    Login to Portal    ${NORMAL_USER_ID}    ${WRONG_USER_PASSWORD}
    Verify Login Page

Login with InValid Username and valid Password
    [Documentation]    User inputs invalid username and valid password.
    ...    User is still on login page.
    ...    Login should Fail.
    [Tags]    login_case4
    Wait for Login page to load
    Verify Login Page
    Login to Portal    ${WRONG_USER_ID}    ${NORMAL_USER_PASSWORD}
    Verify Login Page
