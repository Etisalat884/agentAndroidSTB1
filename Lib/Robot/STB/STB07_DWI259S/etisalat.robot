*** Settings ***
Library    SeleniumLibrary
# Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/Etisalat_Android_STB1/Signal/Etisalat.py

# Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/Etisalat_Android_STB1/runtime.py
Library    String
Library    DateTime
Variables    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/VariableFiles/STB/Etisalat_Android_STB1/Etisalat_Android_STB1.yaml
*** Keywords ***
Navigate To Favorites
    BuiltIn.Sleep   10s
    # Repeat Keyword  4  Click Down
    FOR    ${i}    IN RANGE    4
        Click Down
    END

    Click OK
    Click Ok
    ${favorite}=    runtime.tempMatch    ${port}    ${favorites}    ${ref_favorites}
    Run Keyword If    ${favorite}
    ...    Log To Console    ✅ User can see favorites page
    ...    ELSE    Fail    ❌ User can't see the favorites viewed page 
    RETURN   True

NAVIGATE TO MENU
    Sleep    2s
    CLICK LEFT
    Sleep    2s
    CLICK LEFT
    Sleep    2s
    CLICK RIGHT
    CLICK OK

Enter Numbers Zero To Nine Using Remote
    Sleep    1s
    CLICK UP
    CLICK 0
    Sleep    1s
    CLICK 1
    Sleep    1s
    CLICK 2
    Sleep    1s
    CLICK 3
    Sleep    1s
    CLICK 4
    Sleep    1s
    CLICK 5
    Sleep    1s
    CLICK 6
    Sleep    1s
    CLICK 7
    Sleep    1s
    CLICK 8
    Sleep    1s
    CLICK 9  

  

# NAVIGATE TO PROFILE
#     CLICK HOME
#     CLICK UP
#     Sleep    2s
#     CLICK MULTIPLE TIMES    10    RIGHT
#     CLICK OK
#     ${pass}  runtime.tempMatch  ${port}  ${eti_profile}  ${ref_profile}
#     log to console    ${pass}
#     RETURN    True  
# SELECT ADMIN PROFILE ALWAYS TO EDIT
#     NAVIGATE TO PROFILE
#     CLICK OK
#     Sleep    2s
#     ${pass}  runtime.tempMatch  ${port}  ${eti_Admin_login}  ${ref_Admin_login}
#     Run Keyword If  ${pass}==True  Run Keywords  CLICK MULTIPLE TIMES    4    2
#         ...  AND    CLICK OK
#         ...  AND    Sleep    30s
#     Run Keyword If  ${pass}==False  Log To Console    Already in Admin
    
# NAVIGATE TO ADD NEW PROFILE 
#     SELECT ADMIN PROFILE ALWAYS TO EDIT
#     NAVIGATE TO PROFILE
#     Sleep    2s
#     FOR  ${i}  IN RANGE  10
#         ${pass}  runtime.tempMatch  ${port}  ${eti_add_profile}  ${ref_add_profile}
#         Run Keyword If  ${pass}==True  Run Keywords  CLICK OK
#         ...  AND    CLICK MULTIPLE TIMES    4    2
#         ...  AND    CLICK OK 
#         Run Keyword If  ${pass}==False  Run Keywords  CLICK RIGHT  
#         Exit For loop IF  ${pass}==True
#     END
#     RETURN    True
# EDIT PROFILE PIC
#     SEARCH FOR USER AND EDIT PROFILE
#     CLICK MULTIPLE TIMES    2    DOWN
#     CLICK RIGHT
#     CLICK MULTIPLE TIMES    2    OK
#     CLICK MULTIPLE TIMES    2    DOWN
#     CLICK OK
#     CLICK MULTIPLE TIMES    5    DOWN
#     CLICK MULTIPLE TIMES    2    OK
#     CLICK MULTIPLE TIMES    7    DOWN
#     CLICK RIGHT
#     CLICK MULTIPLE TIMES    2    OK
# GOTO STARTING POSITION OF KEYBOARD
#     CLICK MULTIPLE TIMES    10    UP
#     CLICK MULTIPLE TIMES    6    LEFT
#     Log To Console    type now...
# CREATE USER PROFILE
#     CLICK OK
#     CLICK DOWN
#     CLICK OK
#     Log To Console    Selected adult profile
#     CLICK DOWN
#     CLICK OK
#     GOTO STARTING POSITION OF KEYBOARD
#     CLICK MULTIPLE TIMES    3    DOWN
#     CLICK MULTIPLE TIMES    2    RIGHT
#     CLICK OK
#     CLICK MULTIPLE TIMES    2    LEFT
#     CLICK OK
#     CLICK MULTIPLE TIMES    3    UP
#     CLICK MULTIPLE TIMES    4    RIGHT
#     CLICK OK
#     CLICK MULTIPLE TIMES    2    DOWN
#     CLICK RIGHT
#     CLICK OK
#     CLICK MULTIPLE TIMES    4    DOWN
#     CLICK OK
#     Log To Console    created profile name
#     CLICK DOWN
#     CLICK RIGHT
#     CLICK OK
#     CLICK MULTIPLE TIMES    2    RIGHT
#     CLICK MULTIPLE TIMES    4    OK
#     CLICK MULTIPLE TIMES    4    DOWN
#     CLICK OK
#     Log To Console    created pin code
#     CLICK MULTIPLE TIMES    4    DOWN
#     CLICK OK
# VERIFY USER ALREADY EXISTS
#     NAVIGATE TO PROFILE
#     FOR  ${i}  IN RANGE  10
#         CLICK RIGHT
#         CLICK OK
#         ${pass}  runtime.tempMatch  ${port}  ${eti_user_login}  ${ref_user_login}
#         Run Keyword If  ${pass}==True  Run Keyword    Log To Console    you are in login page...
#         Run Keyword If  ${pass}==False  Run Keywords  CLICK BACK
#         Exit For loop IF  ${pass}==True
#     END
#     RETURN    True

# VALIDATE USER PROFILE OR ELSE CREATE IT
#     # NAVIGATE TO PROFILE
#     SELECT ADMIN PROFILE ALWAYS TO EDIT
#     ${profile_exists}=  runtime.tempMatch  ${port}  ${eti_validate_user}  ${ref_validate_user}
#     Run Keyword If    '${profile_exists}'=='True'  Log To Console    profile already exists
#     ...    ELSE
#     ...        Run Keywords
#     ...        Log To Console    Creating profile
#     ...        AND    NAVIGATE TO ADD NEW PROFILE 
#     ...        AND    CREATE USER PROFILE
#     ...        AND    NAVIGATE TO PROFILE
#     ...        AND    EDIT PROFILE PIC
#     ...        AND    VERIFY USER ALREADY EXISTS
#     RETURN   True
# SEARCH FOR USER AND EDIT PROFILE
#     NAVIGATE TO PROFILE
#     Sleep    2s
#     FOR  ${i}  IN RANGE  10
#         CLICK DOWN
#         CLICK OK
#         CLICK MULTIPLE TIMES    4    2
#         CLICK OK
#         ${pass}  runtime.tempMatch  ${port}  ${eti_user_profile}  ${ref_user_profile}
#         Run Keyword If  ${pass}==True  Run Keyword  Log To Console    Profile exists 
#         Run Keyword If  ${pass}==False  Run Keywords  CLICK BACK
#         ...  AND    CLICK OK
#         ...  AND    CLICK RIGHT 
#         Exit For loop IF  ${pass}==True
#     END
#     RETURN    True
# EDIT USER NAME TO RENAMED USER
#     CLICK MULTIPLE TIMES    2    DOWN
#     CLICK OK
#     GOTO STARTING POSITION OF KEYBOARD
#     CLICK MULTIPLE TIMES    5    RIGHT
#     CLICK MULTIPLE TIMES    4    DOWN
#     CLICK MULTIPLE TIMES    8    OK
#     CLICK MULTIPLE TIMES    4    LEFT
#     CLICK UP
#     CLICK OK
#     CLICK MULTIPLE TIMES    2    UP
#     CLICK RIGHT
#     CLICK OK
#     CLICK MULTIPLE TIMES    4    RIGHT
#     CLICK DOWN
#     CLICK OK
#     CLICK DOWN
#     CLICK MULTIPLE TIMES    3    LEFT
#     CLICK OK
#     CLICK LEFT
#     CLICK OK
#     CLICK MULTIPLE TIMES    2    UP
#     CLICK OK
#     CLICK RIGHT
#     CLICK OK
#     CLICK MULTIPLE TIMES    5    DOWN
#     CLICK OK
#     Log To Console    Changed profile name
#     CLICK RIGHT
#     CLICK OK
#     CLICK RIGHT
#     CLICK OK
#     CLICK MULTIPLE TIMES    2    DOWN
#     CLICK OK
#     CLICK MULTIPLE TIMES    5    DOWN
#     CLICK MULTIPLE TIMES    2    OK
#     CLICK MULTIPLE TIMES    7    DOWN
#     CLICK RIGHT
#     CLICK MULTIPLE TIMES    2    OK
# VALIDATE RENAMED USER
#     NAVIGATE TO PROFILE
#     ${profile_exists}=  runtime.tempMatch  ${port}  ${eti_user1_profile}  ${ref_user1_profile}
#     Run Keyword If    '${profile_exists}'=='True'    Log To Console    user1 exists
# VALIDATE EDIT PROFILE NAME FROM PROFILE SETTINGS
#     ${profile_exists}=  runtime.tempMatch  ${port}  ${eti_user_profile}  ${ref_user_profile}
#     Run Keyword If    '${profile_exists}'=='True'    
#     ...    Run Keywords    Log To Console    profile already exists   
#     ...    AND    SEARCH FOR USER AND EDIT PROFILE 
#     ...    AND    EDIT USER NAME TO RENAMED USER
#     ...    AND    VALIDATE RENAMED USER    
#     ...    ELSE
#     ...        Run Keywords
#     ...        Log To Console    Creating profile
#     ...        AND    VALIDATE USER PROFILE OR ELSE CREATE IT
#     ...        AND    SEARCH FOR USER AND EDIT PROFILE
#     ...        AND    EDIT USER NAME TO RENAMED USER
#     ...        AND    VALIDATE RENAMED USER
#     [Return]    True
# EDIT PIN CODE FOR USER
#     SEARCH FOR USER AND EDIT PROFILE
#     Log To Console    In profile page to edit pin code...
#     Sleep    2s
#     CLICK RIGHT
#     CLICK DOWN
#     CLICK OK
#     CLICK MULTIPLE TIMES    4    2
#     CLICK OK
#     CLICK RIGHT
#     CLICK OK
#     CLICK DOWN
#     CLICK MULTIPLE TIMES    4    OK
#     CLICK MULTIPLE TIMES    3    DOWN
#     CLICK OK
#     CLICK MULTIPLE TIMES    5    DOWN
#     CLICK OK
#     Log TO Console    Pin Changed
# LOGIN WITH RENAMED PIN USER
#     VERIFY USER ALREADY EXISTS
#     CLICK MULTIPLE TIMES    4    4
#     CLICK MULTIPLE TIMES    4    DOWN
#     CLICK OK
#     Sleep    10s
# VERIFY LOGIN AFTER PIN CHANGED
#     Sleep    30s
#     NAVIGATE TO PROFILE
#     FOR  ${i}  IN RANGE  10
#         ${pass}  runtime.tempMatch  ${port}  ${eti_user_login_after_pin_changed}  ${ref_user_login_after_pin_changed}
#         Run Keyword If  ${pass}==True  Run Keyword    Log To Console    login with changed pin code for user
#         Run Keyword If  ${pass}==False  Run Keywords  CLICK RIGHT  
#         Exit For loop IF  ${pass}==True
#     END
#     [Return]    True
# VALIDATE EDIT PIN CODE
#     ${profile_exists}=  runtime.tempMatch  ${port}  ${eti_user_profile}  ${ref_user_profile}
#     Run Keyword If    '${profile_exists}'=='True'    
#     ...    Run Keywords    Log To Console    profile already exists   
#     ...    AND    EDIT PIN CODE FOR USER
#     ...    AND    LOGIN WITH RENAMED PIN USER
#     ...    AND    VERIFY LOGIN AFTER PIN CHANGED
#     ...    ELSE
#     ...        Run Keywords
#     ...        Log To Console    Creating profile
#     ...        AND    VALIDATE USER PROFILE OR ELSE CREATE IT
#     ...        AND    EDIT PIN CODE FOR USER
#     ...        AND    LOGIN WITH RENAMED PIN USER
#     ...        AND    VERIFY LOGIN AFTER PIN CHANGED
#     [Return]    True
# SELECT DISABLE
#     CLICK MULTIPLE TIMES    2    DOWN
#     CLICK OK
#     CLICK MULTIPLE TIMES    4    DOWN
#     CLICK OK
#     CLICK MULTIPLE TIMES    4    2
#     CLICK OK
#     CLICK OK
# DISABLE PIN CODE FOR USER
#     # NAVIGATE TO PROFILE
#     SEARCH FOR USER AND EDIT PROFILE
#     Log To Console    In profile page to edit pin code...
#     Sleep    2s
#     CLICK RIGHT
#     SELECT DISABLE

#     # ${profile_exists}=  runtime.tempMatch  ${port}  ${eti_disable_pin_login}  ${ref_disable_pin_login}
#     # Run Keyword If    '${profile_exists}'=='True'    Run Keywords    
#     # ...  AND    CLICK OK
#     # ...  AND    Log To Console    profile login with disable pin  
#     # ...    ELSE 
#     # ...        Run Keywords
#     # ...        AND    CLICK MULTIPLE TIMES    4    DOWN
#     # ...        AND    CLICK OK
#     # ...        AND    CLICK MULTIPLE TIMES    4    2
#     # ...        AND    CLICK OK
#     # ...        AND    Log To Console    profile login with disable pin 
#     [Return]    True
# VERIFY PIN IS DISABLED OR NOT
#     VERIFY USER ALREADY EXISTS
#     ${profile_exists}=  runtime.tempMatch  ${port}  ${eti_disable_pin_login}  ${ref_disable_pin_login}
#     Run Keyword If    '${profile_exists}'=='True'    
#     ...    Run Keywords    CLICK OK 
#     ...    AND    Log To Console    profile login with disable pin  
#     ...    ELSE
#     ...        Run Keyword
#     ...        Log To Console    can't able to login
#     [Return]    True
# VALIDATE DISABLE PIN CODE
#     ${profile_exists}=  runtime.tempMatch  ${port}  ${eti_user_profile}  ${ref_user_profile}
#     Run Keyword If    '${profile_exists}'=='True'    
#     ...    Run Keywords    Log To Console    profile already exists   
#     ...    AND    DISABLE PIN CODE FOR USER
#     ...    AND    VERIFY PIN IS DISABLED OR NOT
#     ...    ELSE
#     ...        Run Keywords
#     ...        Log To Console    Creating profile
#     ...        AND    VALIDATE USER PROFILE OR ELSE CREATE IT
#     ...        AND    DISABLE PIN CODE FOR USER
#     ...        AND    VERIFY PIN IS DISABLED OR NOT
#     ...        AND    VERIFY LOGIN AFTER PIN CHANGED
#     [Return]    True
# SELECT DISABLE BOX OFFICE PIN
#     CLICK MULTIPLE TIMES    3    DOWN
#     CLICK OK
#     CLICK MULTIPLE TIMES    3    DOWN
#     CLICK OK
#     CLICK MULTIPLE TIMES    4    2
#     CLICK OK
#     CLICK OK
# DISABLE BOX OFFICE PIN CODE FOR USER
#     SEARCH FOR USER AND EDIT PROFILE
#     Log To Console    In profile page to disable box office pin code...
#     Sleep    2s
#     CLICK RIGHT
#     SELECT DISABLE BOX OFFICE PIN
# VERIFY BOX OFFICE PIN IS DISABLED OR NOT
#     VERIFY USER ALREADY EXISTS
#     CLICK MULTIPLE TIMES    4    3
#     CLICK MULTIPLE TIMES    2    DOWN
#     ${profile_exists}=  runtime.tempMatch  ${port}  ${eti_disable_box_office_pin_login}  ${ref_disable_box_office_pin_login}
#     Run Keyword If    '${profile_exists}'=='True'    
#     ...    Run Keywords    CLICK OK
#     ...    AND    Log To Console    profile login with disable box office pin  
#     ...    ELSE
#     ...        Run Keyword
#     ...        Log To Console    can't able to login
# VALIDATE DISABLE BOX OFFICE PIN CODE
#     ${profile_exists}=  runtime.tempMatch  ${port}  ${eti_user_profile}  ${ref_user_profile}
#     Run Keyword If    '${profile_exists}'=='True'    
#     ...    Run Keywords    Log To Console    profile already exists   
#     ...    AND    DISABLE BOX OFFICE PIN CODE FOR USER
#     ...    AND    VERIFY BOX OFFICE PIN IS DISABLED OR NOT
#     ...    ELSE
#     ...        Run Keywords
#     ...        Log To Console    Creating profile
#     ...        AND    VALIDATE USER PROFILE OR ELSE CREATE IT
#     ...        AND    DISABLE BOX OFFICE PIN CODE FOR USER
#     ...        AND    VERIFY BOX OFFICE PIN IS DISABLED OR NOT
#     ...        AND    VERIFY LOGIN AFTER PIN CHANGED
#     [Return]    True
# GOTO SECURITY CONTROL AND SELECT ALWAYS LOGIN AS SAME PROFILE
#     SEARCH FOR USER AND EDIT PROFILE
#     Log To Console    In security control to select always login as same profile......
#     Sleep    2s
#     CLICK RIGHT
#     CLICK MULTIPLE TIMES    4    DOWN
#     CLICK OK
#     CLICK MULTIPLE TIMES    2    DOWN
#     CLICK OK
#     CLICK MULTIPLE TIMES    4    2
#     CLICK MULTIPLE TIMES    2    OK
# LOGIN AS USER ALWAYS AFTER CHANGING SECURTIY
#     VERIFY USER ALREADY EXISTS
#     CLICK MULTIPLE TIMES    4    3
#     CLICK MULTIPLE TIMES    3    DOWN
#     ${select_always_login_profile}  runtime.tempMatch  ${port}  ${eti_always_login_as_same_profile}  ${ref_always_login_as_same_profile}
#     Run Keyword If    '${select_always_login_profile}'=='True'    
#     ...    Run Keywords    CLICK OK
#     ...    AND    Log To Console    always login as same profile 
#     ...    ELSE
#     ...        Run Keyword
#     ...        Log To Console    can't able to login
# ALWAYS LOGIN WITH SAME PROFILE
#     SELECT ADMIN PROFILE ALWAYS TO EDIT
#     NAVIGATE TO PROFILE
#     ${user_profile_exists}=  runtime.tempMatch  ${port}  ${eti_user_profile}  ${ref_user_profile}
#     Run Keyword If    '${user_profile_exists}'=='True'  
#     ...    Run Keywords    Log To Console    user profile already exists
#     ...    AND    GOTO SECURITY CONTROL AND SELECT ALWAYS LOGIN AS SAME PROFILE
#     ...    AND    LOGIN AS USER ALWAYS AFTER CHANGING SECURTIY
#     ...    AND    VERIFY LOGIN AFTER PIN CHANGED
#     ...    ELSE
#     ...        Run Keywords
#     ...        Log To Console    Creating profile
#     ...        AND    VALIDATE USER PROFILE OR ELSE CREATE IT
#     ...        AND    GOTO SECURITY CONTROL AND SELECT ALWAYS LOGIN AS SAME PROFILE
#     ...        AND    LOGIN AS USER ALWAYS AFTER CHANGING SECURTIY
#     ...        AND    VERIFY LOGIN AFTER PIN CHANGED
#     [Return]    True
# GOTO_SECURITY_CONTROLS_AND_EDIT_RENTAL_LIMIT
#     SEARCH FOR USER AND EDIT PROFILE
#     Log To Console    In security control to edit rental limit profile......
#     Sleep    2s
#     CLICK RIGHT
#     CLICK MULTIPLE TIMES    5    DOWN
#     CLICK OK
#     CLICK MULTIPLE TIMES    11    UP
#     CLICK MULTIPLE TIMES    3    DOWN
#     CLICK OK
#     CLICK MULTIPLE TIMES    5    DOWN
#     CLICK OK
#     CLICK MULTIPLE TIMES    2    OK
# VERIFY_RENTAL_LIMIT
#     SEARCH FOR USER AND EDIT PROFILE
#     Log To Console    In security control to verify rental limit....
#     CLICK RIGHT
#     CLICK MULTIPLE TIMES    5    DOWN
#     ${user_profile_exists}=  runtime.tempMatch  ${port}  ${eti_rental_limit}  ${ref_rental_limit}
#     Run Keyword If    '${user_profile_exists}'=='True'  
#     ...    Run Keyword    Log To Console    checked for rental limit
#     ...    ELSE
#     ...        Run Keyword    Log To Console    can't able to match rental limit
# EDIT_PROFILE_RENTAL_LIMIT
#     SELECT ADMIN PROFILE ALWAYS TO EDIT
#     NAVIGATE TO PROFILE
#     ${user_profile_exists}=  runtime.tempMatch  ${port}  ${eti_user_profile}  ${ref_user_profile}
#     Run Keyword If    '${user_profile_exists}'=='True'  
#     ...    Run Keywords    Log To Console    user profile already exists
#     ...    AND    GOTO_SECURITY_CONTROLS_AND_EDIT_RENTAL_LIMIT
#     ...    AND    VERIFY_RENTAL_LIMIT
#     ...    ELSE
#     ...        Run Keywords
#     ...        Log To Console    Creating profile
#     ...        AND    VALIDATE USER PROFILE OR ELSE CREATE IT
#     ...        AND    GOTO_SECURITY_CONTROLS_AND_EDIT_RENTAL_LIMIT
#     ...        AND    VERIFY_RENTAL_LIMIT
#     [Return]    True
# GOTO_TV_EXPERIENCE
#     SEARCH FOR USER AND EDIT PROFILE
#     CLICK MULTIPLE TIMES    2    RIGHT
#     Sleep    2s
# EDIT CONTENT RATING FROM TV EXPERIENCE
#     GOTO_TV_EXPERIENCE
#     CLICK MULTIPLE TIMES    3    DOWN
#     CLICK OK
#     CLICK MULTIPLE TIMES    5    UP
#     CLICK DOWN
#     CLICK OK
#     CLICK MULTIPLE TIMES    5    DOWN
#     CLICK OK
# LOGIN FOR USER PROFILE
#     VERIFY USER ALREADY EXISTS
#     CLICK MULTIPLE TIMES    4    3
#     CLICK MULTIPLE TIMES    4    DOWN
#     CLICK OK
# GOTO ONDEMAND
#     CLICK HOME
#     CLICK UP
#     CLICK MULTIPLE TIMES    3    RIGHT
#     CLICK MULTIPLE TIMES    2    OK
#     Sleep    10s
# SELECT VIDEO FROM ON DEMAND AND CHECK FOR CONTENT RATING PROFILE
#     GOTO ONDEMAND
#     CLICK MULTIPLE TIMES    3    DOWN
#     CLICK MULTIPLE TIMES    2    OK
#     ${user_profile_exists}=  runtime.tempMatch  ${port}  ${eti_tv_rating}  ${ref_tv_rating}
#     Run Keyword If    '${user_profile_exists}'=='True' 
#     ...    Run Keywords    Log To Console    content restricted as low rating
#     ...    AND    CLICK MULTIPLE TIMES    4    3
#     ...    AND    CLICK OK
#     ...    AND    Log To Console    video is playing.....
#     ...    ELSE
#     ...        Run Keyword
#     ...        Log To Console    This video is not restricted by parental
# EDIT CONTENT RATING
#     SELECT ADMIN PROFILE ALWAYS TO EDIT
#     NAVIGATE TO PROFILE
#     ${user_profile_exists}=  runtime.tempMatch  ${port}  ${eti_user_profile}  ${ref_user_profile}
#     Run Keyword If    '${user_profile_exists}'=='True'  
#     ...    Run Keywords    Log To Console    user profile already exists
#     ...    AND    EDIT CONTENT RATING FROM TV EXPERIENCE
#     ...    AND    LOGIN FOR USER PROFILE
#     ...    AND    SELECT VIDEO FROM ON DEMAND AND CHECK FOR CONTENT RATING PROFILE
#     ...    ELSE
#     ...        Run Keywords
#     ...        Log To Console    Creating profile
#     ...        AND    VALIDATE USER PROFILE OR ELSE CREATE IT
#     ...        AND    EDIT CONTENT RATING FROM TV EXPERIENCE
#     ...        AND    LOGIN FOR USER PROFILE
#     ...        AND    SELECT VIDEO FROM ON DEMAND AND CHECK FOR CONTENT RATING PROFILE   
#     [Return]    True
# CLICK MENU
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  MENU


# CLICK LEFT
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  LEFT


# CLICK RIGHT
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  RIGHT

# CLICK OK
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  OK

# CLICK UP
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  UP

# CLICK DOWN
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  DOWN

# CLICK HOME
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  HOME

# CLICK BACK
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  BACK

# CLICK CHANNEL_MINUS
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  CHANNEL_MINUS

# CLICK CHANNEL_PLUS
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  CHANNEL_PLUS


# CLICK VOLUME_MINUS
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  VOLUME_MINUS

# CLICK VOLUME_PLUS
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  VOLUME_PLUS

# CLICK RED
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  RED

# CLICK GREEN
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  GREEN

# CLICK BLUE
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  BLUE

# CLICK YELLOW
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  YELLOW

# SWITCH OFF MIC
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  MIC
    
# SWITCH ON MIC
#     Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  MIC
# CLICK 0

# 	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  0

# CLICK 1
# 	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  1

# CLICK 2
# 	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  2
# CLICK 3
# 	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  3

# CLICK 4
# 	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  4

# CLICK 5
# 	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  5
# CLICK 6
# 	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  6
# CLICK 7
# 	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  7
# CLICK 8
# 	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  8

# CLICK 9
# 	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  9

# CLICK MULTIPLE TIMES
#     [Arguments]    ${count}    ${key}
#     FOR  ${i}    IN RANGE    ${count}
#         ${keyword}    Catenate    CLICK    ${key}
#         Run Keyword And Return Status    ${keyword}
#     END

# Change Channel On Home Page Using Program Button
#     Sleep    1s
# 	CLICK HOME
#     CLICK UP
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK MULTIPLE TIMES    2    DOWN
# 	CLICK MULTIPLE TIMES    2    OK
# 	Sleep	2s
# 	CLICK MULTIPLE TIMES    20    CHANNEL_MINUS
# 	Sleep	1s
# 	CLICK MULTIPLE TIMES    20    CHANNEL_PLUS

