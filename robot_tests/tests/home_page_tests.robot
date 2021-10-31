*** Settings ***
Force Tags   home_page_tests 

Resource    ../resources/login_page.robot
Resource    ../resources/home_page.robot
Library     ../resources/converter.py

Test Setup    Setup and Open Browser
Test Teardown    Run Keywords
    ...    Reset Data with Button
    ...    Close Browser

*** Variables ***
${NORMAL_USER_ID}                user
${NORMAL_USER_PASSWORD}          helloworld
${ADMIN_USER_ID}                 admin
${ADMIN_USER_PASSWORD}           adminpass

*** Test Cases ***

Verify List and Awsomeness of Cats as Normal User
    [Documentation]    Normal user logins with valid credentials.
    ...    List of cats is verified by checking if name, picture, awsomeness and rank exists for each cat.
    ...    Awsomeness of each cat is calculated from its name and comapred to the one mentioned in list.
    ...    Awsomeness of each cat is compared with previous one. Test fails if current awsomeness is more than previous cat.
    [Tags]    home_page_case1
    Wait for Login page to load
    Verify Login Page
    Login to Portal    ${NORMAL_USER_ID}    ${NORMAL_USER_PASSWORD}
    Wait for Home page to load
    Verify home page is open
    Verify List of Cats

Verify List and Awsomeness of Cats as Admin User
        [Documentation]    Admin user logins with valid credentials.
    ...    List of cats is verified by checking if name, picture, awsomeness and rank exists for each cat.
    ...    Awsomeness of each cat is calculated from its name and comapred to the one mentioned in list.
    ...    Awsomeness of each cat is compared with previous one. Test fails if current awsomeness is more than previous cat.
    [Tags]    home_page_case2
    Wait for Login page to load
    Verify Login Page
    Login to Portal    ${ADMIN_USER_ID}    ${ADMIN_USER_PASSWORD}
    Wait for Home page to load
    Verify home page is open
    Verify List of Cats

Verify Normal User can not Delete
    [Documentation]    Normal user logins with valid credentials.
    ...    Test case verifies that delete button is not visible in home page for any cat.
    [Tags]    home_page_case3
    Wait for Login page to load
    Verify Login Page
    Login to Portal    ${NORMAL_USER_ID}    ${NORMAL_USER_PASSWORD}
    Wait for Home page to load
    Verify home page is open
    Verify Delete button is not visible    1

Verify Admin User can Delete Cat
    [Documentation]    Admin user logins with valid credentials.
    ...    Test case verifies that delete button is visible in home page for any cat with index 1.
    ...    Admin then deletes a cat. Total number of cats are compared before and after delete.
    [Tags]    home_page_case4
    Wait for Login page to load
    Verify Login Page
    Login to Portal    ${ADMIN_USER_ID}    ${ADMIN_USER_PASSWORD}
    Wait for Home page to load
    Verify home page is open
    Verify Delete button is visible    1
    ${count}=    Return Number of Cats
    Delete a Cat    1
    Sleep    3 sec
    ${new_count}=    Return Number of Cats
    ${difference} =    Evaluate    ${count}-${new_count}
    Run Keyword If    ${difference} != 1   Fail

Verify Normal user can Rename
    [Documentation]    Normal user logins with valid credentials.
    ...    Test case verifies that user can rename a cat.
    [Tags]    home_page_case5
    Wait for Login page to load
    Verify Login Page
    Login to Portal    ${NORMAL_USER_ID}    ${NORMAL_USER_PASSWORD}
    Wait for Home page to load
    Verify home page is open
    Set New Cat Name    1    new_name

Verify Admin user can Rename
    [Documentation]    Admin user logins with valid credentials.
    ...    Test case verifies that user can rename a cat.
    [Tags]    home_page_case6
    Wait for Login page to load
    Verify Login Page
    Login to Portal    ${ADMIN_USER_ID}    ${ADMIN_USER_PASSWORD}
    Wait for Home page to load
    Verify home page is open
    Set New Cat Name    1    new_name2

Verify 2 Cats cannot have same names
    [Documentation]    Admin user logins with valid credentials.
    ...    Test case verifies that user can not rename a cat which already exists in the list.
    [Tags]    home_page_case7
    Wait for Login page to load
    Verify Login Page
    Login to Portal    ${ADMIN_USER_ID}    ${ADMIN_USER_PASSWORD}
    Wait for Home page to load
    Verify home page is open
    ${existing_name}=    Get Cat Name    1
    Set Duplicate Cat Name    2    ${existing_name}

verify Data persistence between Normal User and Admin User
    [Documentation]    Admin user logins with valid credentials.
    ...    Test case verifies that user can rename a cat.
    ...    after renaming, Normal user logins with valid credentials.
    ...    Test case verifies that new cat name is visible in the list.
    [Tags]    home_page_case8
    Wait for Login page to load
    Verify Login Page
    Login to Portal    ${ADMIN_USER_ID}    ${ADMIN_USER_PASSWORD}
    Wait for Home page to load
    Verify home page is open
    Set New Cat Name    1    new_name2
    Logout User
    Wait for Login page to load
    Verify Login Page
    Login to Portal    ${NORMAL_USER_ID}    ${NORMAL_USER_PASSWORD}
    Wait for Home page to load
    Verify home page is open
    ${new_name}=    Get Cat Name    1
    Should Be Equal As Strings    ${new_name}    new_name2


