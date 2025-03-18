*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${URL}            https://www.saucedemo.com/
${BROWSER}        chrome
${USERNAME}       standard_user
${PASSWORD}       secret_sauce

*** Keywords ***
Add First Product To Cart
    Click Button    xpath=//button[contains(@class, 'btn_inventory')]
    Click Element   xpath=//a[contains(@class, 'shopping_cart_link')]

Open Browser To Login Page
    Open Browser    ${URL}    ${BROWSER}    options=--headless --disable-gpu --no-sandbox --disable-dev-shm-usage --user-data-dir=/tmp/unique_chrome_profile
    Maximize Browser Window

Login To Application
    [Arguments]    ${username}    ${password}
    Input Text    xpath=//input[@data-test='username']    ${username}
    Input Text    xpath=//input[@data-test='password']    ${password}
    Click Button    xpath=//input[@data-test='login-button']

Complete Checkout
    [Arguments]    ${firstName}    ${lastName}    ${postalCode}
    Click Button    xpath=//button[@data-test='checkout']
    Input Text    xpath=//input[@data-test='firstName']    ${firstName}
    Input Text    xpath=//input[@data-test='lastName']    ${lastName}
    Input Text    xpath=//input[@data-test='postalCode']    ${postalCode}
    Click Button    xpath=//input[@data-test='continue']
    Click Button    xpath=//button[@data-test='finish']

*** Test Cases ***
Successful Login
    Open Browser To Login Page
    Login To Application    ${USERNAME}    ${PASSWORD}
    Location Should Contain    /inventory.html
    Close Browser

Failed Login
    Open Browser To Login Page
    Login To Application    locked_out_user    ${PASSWORD}
    Run Keyword And Expect Error    *inventory.html*    Location Should Contain    /inventory.html
    Element Should Be Visible    xpath=//h3[@data-test='error']
    Close Browser

Successful Checkout
    Open Browser To Login Page
    Login To Application    ${USERNAME}    ${PASSWORD}
    Add First Product To Cart
    Complete Checkout    BetoG    QA    1234
    Element Should Contain    xpath=//h2[@class='complete-header']    Thank you
    Close Browser
