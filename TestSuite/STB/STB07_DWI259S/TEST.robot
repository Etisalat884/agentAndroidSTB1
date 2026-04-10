*** Settings ***
Library    OperatingSystem
Test Setup    Check STB Health

*** Variables ***
${STB_IP}        10.85.65.44
${PING_COUNT}    2

*** Keywords ***
Check STB Health
    Log    Checking health of STB at ${STB_IP}
    ${result}    Run Process    ping    -c ${PING_COUNT}    ${STB_IP}    shell=True    timeout=5
    Should Be Equal As Integers    ${result.rc}    0    msg=❌ STB at ${STB_IP} is NOT reachable!

*** Test Cases ***
Test Case 1
    Log    ✅ Running Test Case 1

Test Case 2
    Log    ✅ Running Test Case 2
