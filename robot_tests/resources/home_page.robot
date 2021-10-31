*** Settings ***
Documentation    Resource file for home page related keywords
Library    Selenium2Library
Library    converter.py

*** Variables ***
${PORTAL_TIMEOUT}                      30 sec
${HEADER}                              //span[contains(.,"Supermetrics Kitty Manager")]
${LOG_OUT_BUTTON}                      //div/button[contains(.,"Log out")]
${RESET_BUTTON}                        //div/button[contains(.,"Reset")]
${CAT_NAME}                            //div[@contenteditable]
${CAT_PICTURE}                         //div/img[contains(@src,"image")]
${CAT_RANK}                            //div[child::span[contains(.,"Rank")]]/span[2]
${CAT_AWESOMENESS}                     //div[child::span[contains(.,"Rank")]]/span[4]
${TOTAL_CATS}                          //div[child::div/child::span[contains(.,"Rank")]]
${DELETE_BUTTON}                       //*[local-name() = 'svg'][2]
${SAVE_BUTTON}                         //*[local-name() = 'svg'][1]
${SAVE_BUTTON_ENABLED}                 [contains(@stroke,"green")]
${SAVE_BUTTON_DISABLED}                [contains(@stroke,"gray")]
${SAVE_BUTTON_NOT_ALLOWED}             [contains(@stroke,"red")]

*** Keywords ***
Wait for Home page to load
    Wait Until Element Is Visible    xpath=${SAVE_BUTTON}    5 sec

Verify home page is open
    Element should be visible    ${SAVE_BUTTON}    message="Home page with list should be open but is not"

Verify Delete button is visible
    [Arguments]    ${index}
    ${path} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${DELETE_BUTTON}
    Wait Until Element Is Visible    xpath=${SAVE_BUTTON}    5 sec    error="Delete button should be visible but is not"

Verify Delete button is not visible
    [Arguments]    ${index}
    ${path} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${DELETE_BUTTON}
    Element should not be visible    ${path}    message="Delete button should not be visible but is"

Return Number of Cats
    Run Keyword And Return    Get Matching Xpath Count    xpath=${TOTAL_CATS}

Verify Cat Name is Visible
    [Arguments]    ${index}
    ${path} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${CAT_NAME}
    Element Should Be Visible    xpath=${path}

Verify Cat Picture is Visible
    [Arguments]    ${index}
    ${path} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${CAT_PICTURE}
    Element Should Be Visible    xpath=${path}

Verify Cat Rank is Visible
    [Arguments]    ${index}
    ${path} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${CAT_RANK}
    Element Should Be Visible    xpath=${path}

Verify Cat Awsomeness is Visible
    [Arguments]    ${index}
    ${path} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${CAT_AWESOMENESS}
    Element Should Be Visible    xpath=${path}

Get Cat Name
    [Arguments]    ${index}
    ${path} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${CAT_NAME}
    Element Should Be Visible    xpath=${path}
    Run Keyword And Return    Get Text    xpath=${path}

Get Cat Rank
    [Arguments]    ${index}
    ${path} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${CAT_RANK}
    Element Should Be Visible    xpath=${path}
    Run Keyword And Return    Get Text    xpath=${path}

Get Cat Awsomeness
    [Arguments]    ${index}
    ${path} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${CAT_AWESOMENESS}
    Element Should Be Visible    xpath=${path}
    Run Keyword And Return    Get Text    xpath=${path}

Verify List of Cats
    ${count}=    Return Number of Cats
    FOR    ${i}    IN RANGE    1    ${count} + 1
        Verify Cat Name is Visible    ${i}
        Verify Cat Picture is Visible    ${i}
        Verify Cat Rank is Visible    ${i}
        ${awsomeness}=    Get Cat Awsomeness    ${i}
        ${rank}=    Get Cat Rank    ${i}
        Run Keyword Unless    "${awsomeness}" == "∞"   Verify Awsomeness against Name    ${i}
        Run Keyword Unless    "${awsomeness}" == "∞" or ${rank} == ${count}   Verify Awsomeness with Previous Cat    ${i}
        Verify Cat Awsomeness is Visible    ${i}
    END

Verify Awsomeness with Previous Cat
    [Arguments]    ${index}
    ${current_cat}=    Get Cat Awsomeness    ${index}
    ${previous_cat}=    Get Cat Awsomeness    ${index} + 1
    Run Keyword If    ${current_cat} <= ${previous_cat}    Fail    msg="Awsomeness is not in order"

Verify Awsomeness against Name
    [Arguments]    ${index}
    ${name}=    Get Cat Name    ${index}
    ${awsomeness}=    Get Cat Awsomeness    ${index}
    ${calculated_awsomeness}=    converter.return_sum_of_ascii    ${name}
    Run Keyword If    ${calculated_awsomeness} != ${awsomeness}    Fail    msg="Awsomeness is not correct"

Verify Save Button is Enabled
    [Arguments]    ${index}
    ${path} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${SAVE_BUTTON}    ${SAVE_BUTTON_ENABLED}
    Element Should Be Visible    xpath=${path}    message="Save button should be enabled but is disabled"

Verify Save Button is Disabled
    [Arguments]    ${index}
    ${path} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${SAVE_BUTTON}    ${SAVE_BUTTON_DISABLED}
    Element Should Be Visible    xpath=${path}    message="Save button should be disabled but is enabled"

Verify Save Button is Not Allowed
    [Arguments]    ${index}
    ${path} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${SAVE_BUTTON}    ${SAVE_BUTTON_NOT_ALLOWED}
    Element Should Be Visible    xpath=${path}    message="Save button should be restricted but is not"

Set New Cat Name
    [Arguments]    ${index}    ${new_name}
    ${path} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]
    Element Should Be Visible    xpath=${path}
    ${path2} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${CAT_NAME}
    Click Element    ${path2}
    Input Text    ${path2}    ${new_name}
    Verify Save Button is Enabled    ${index}
    ${path3} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${SAVE_BUTTON}
    Click Element    ${path3}
    Verify Save Button is Disabled    ${index}
    ${name}=    Get Cat Name    ${index}
    Should Be Equal As Strings    ${name}    ${new_name}

Set Duplicate Cat Name
    [Arguments]    ${index}    ${new_name}
    ${path} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]
    Element Should Be Visible    xpath=${path}
    ${path2} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${CAT_NAME}
    Click Element    ${path2}
    Input Text    ${path2}    ${new_name}
    Verify Save Button is Not Allowed    ${index}

Reset Data with Button
    Element Should Be Visible    xpath=${RESET_BUTTON}
    Click Button    xpath=${RESET_BUTTON}

Logout User
    Element Should Be Visible    xpath=${LOG_OUT_BUTTON}
    Click Button    xpath=${LOG_OUT_BUTTON}

Delete a Cat
    [Arguments]    ${index}
    ${path} =   Catenate    SEPARATOR=    ${TOTAL_CATS}    [${index}]    ${DELETE_BUTTON}
    Wait Until Element Is Visible    xpath=${SAVE_BUTTON}    5 sec    error="Delete button should be visible but is not"
    Click Element    ${path}












