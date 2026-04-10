*** Settings ***
Resource    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Robot/STB/Android_STB/etisalat.robot
Resource    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Robot/STB/Android_STB/Demo_Keywords.robot

Library   /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/Etisalat_Android_STB1/TeardownStatusTC.py

Library   DateTime
Library    Process
Library    OperatingSystem
Library    Collections

*** Variables ***
${ZAP_LIMIT}     0.003    # 3 milliseconds in seconds
@{ZAP_TIMES}     # List to store each zap time
# Suite Setup  Suite level setup
# Suite Teardown  Suite level teardown
# Test Setup  Test Level Setup
# Test Teardown  Test Level Teardown

*** keywords ***

# Generate Logs with Timestamp
#     ${timestamp}=    Get Current Date    result_format=%Y%m%d-%H%M%S
#     ${log_file_path}=    Set Variable    ${log_file_path}_${timestamp}.txt
#     Log    Log file path: ${log_file_path}
#     ${syslog_process}    Start Process    idevicesyslog  ${devices}    stdout=${log_file_path}   shell=True


# Suite level setup
#     #status of device execution
#     Set Library Search Order  Selenium2Library    AppiumLibrary
#     ${exdict}  TeardownStatusTC.listconv  ${execution_id}  ${testcase}
#     Set Global Variable  ${exdict}
#     Run Keyword  TeardownStatusTC.Status  ${trigger_id}  ${agent_id}  In Progress  Pending
#     #CLEAR LOGCAT  ${serial}



# Suite level teardown
#     #${File_name}  DUMP LOGCAT   ${filename}  ${serial}
#     #Log To Console  LogCat file Name: ${File_name}
#     #status of device execution

#     BuiltIn.Sleep  2
#     run keyword if all tests passed  TeardownStatusTC.Status  ${trigger_id}  ${agent_id}  Completed  Pass
#     run keyword if any tests failed  TeardownStatusTC.Status  ${trigger_id}  ${agent_id}  Completed  Fail

# Test Level Setup
#     #start time
#     # Generate Logs with Timestamp
#     ${start_time}  GET TIME
#     Log To Console    ${start_time}
#     Set Global Variable  ${start_time}

# Test Level Teardown
#     #end time & each test case execution result
#     ${end_time}  GET TIME
#     #Log To Console  ${TEST NAME}:${exdict}[${TEST NAME}]
#     #Log To Console  ${exdict}
#     run keyword if test passed  TeardownStatusTC.Evaluate_time_result  ${exdict}[${TEST NAME}]  Pass  ${start_time}  ${end_time}
#     run keyword if test failed  TeardownStatusTC.Evaluate_time_result  ${exdict}[${TEST NAME}]  Fail  ${start_time}  ${end_time}


*** Test Cases ***
TC_001_Power_Cycle_The_Set_Top_Box
    ${pass1} =    Run Keyword    Power_Off_And_Power_On_STB
    Run Keyword If    ${pass1} == True    Log To Console    STB power cycle successful
    ...    ELSE    Fail    STB did not respond after power cycle
    ...    
TC_002_Change_Channel_Using_Program_Buttons_From_Homepage
    ${pass1} =    Run Keyword    User_Zapping_20_Channels_And_Back
    Run Keyword If    ${pass1} == True    Log To Console    Successfully changed the channel
    ...    ELSE    Fail    Couldn't change the channel using Program button

TC_003_Zap_Channels_Using_Numeric_Keys
    ${pass1} =    Run Keyword    User_Zapping_10_Then_Back_5_Then_Switch_To_Channel_514
    Run Keyword If    ${pass1} == True    Log To Console    Successfully zapped 10 channels, back 5, then to 514
    ...    ELSE    Fail    Couldn't zap desired channels

TC_004_Play_VOD_And_Test_Trickmode_Fast_Forward
    ${pass1} =    Run Keyword    Open_VOD_And_Start_Playback
    Run Keyword If    ${pass1} == True    Log To Console    Navigated to VOD and started playback
    ...    ELSE    Fail    Couldn't navigate to VOD or play video
    ${pass2} =    Run Keyword    Play_VOD_Using_Trickmodes_Fast_Forward
    Run Keyword If    ${pass2} == True    Log To Console    Trickmode fast-forward executed successfully
    ...    ELSE    Fail    Trickmode fast-forward failed

TC_005_Startover_Playback_On_VOD_Content
    ${pass1} =    Run Keyword    Perform_Start_Over_On_Video
    Run Keyword If    ${pass1} == True    Log To Console    Video start over executed successfully
    ...    ELSE    Fail    Couldn't perform start over on video

TC_006_Rewind_During_VOD_Playback
    ${pass1} =    Run Keyword    Open_VOD_And_Start_Playback
    Run Keyword If    ${pass1} == True    Log To Console    Navigated to VOD and started playback
    ...    ELSE    Fail    Couldn't navigate to VOD or play video
    ${pass2} =    Run Keyword    Rewind
    Run Keyword If    ${pass2} == True    Log To Console    Rewind executed successfully
    ...    ELSE    Fail    Rewind failed

TC_007_Search_VOD_And_Start_Playback
    ${pass1} =    Run Keyword    Search_Movie
    Run Keyword If    ${pass1} == True    Log To Console    Movie search and playback successful
    ...    ELSE    Fail    Movie search or playback failed

TC_008_Change_Subtitle_Language_During_Playback
    ${pass1} =    Run Keyword    Subtitle_Language
    Run Keyword If    ${pass1} == True    Log To Console    Subtitle language changed successfully
    ...    ELSE    Fail    Couldn't change subtitle language

TC_009_Rent_Movie_With_Invalid_PIN
    ${pass1} =    Run Keyword    Rent_Movie_Under_Boxoffice_With_Wrong_PIN
    Run Keyword If    ${pass1} == True    Log To Console    Error PIN rejected as expected
    ...    ELSE    Fail    Movie was rented using wrong PIN — test failed

TC_010_Rent_Movie_With_Valid_PIN
    ${pass1} =    Run Keyword    Rent_Movie_Under_Boxoffice_With_Valid_PIN
    Run Keyword If    ${pass1} == True    Log To Console    Movie rented successfully with valid PIN
    ...    ELSE    Fail    Couldn't rent movie using valid PIN

TC_011_Play_Live_TV_For_30_Seconds
    ${pass1} =    Run Keyword    Play_Live_TV
    Run Keyword If    ${pass1} == True    Log To Console    Live TV played successfully for 120 seconds
    ...    ELSE    Fail    Live TV playback failed
    ...    

rec_play_7
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK

	${Result}  Verify Crop Image  ${port}  on_demand
	Run Keyword If  '${Result}' == 'True'  Log To Console  on_demand Is Displayed
	...  ELSE  Fail  on_demand Is Not Displayed
	
	CLICK HOME

TC_Zapping
    Navigate To Guide
    ${total_zaps}=    Set Variable    5
    FOR    ${i}    IN RANGE    ${total_zaps}
        ${zap_time}=    Zap And Measure Time
        Append To List    ${ZAP_TIMES}    ${zap_time}
        Log To Console    Zap ${i+1}: ${zap_time} seconds
        Should Be True    ${zap_time} < ${ZAP_LIMIT}    Zap ${i+1} took too long!
    END
    ${total_time}=    Evaluate    sum(${ZAP_TIMES})
    Log To Console    Total zaps: ${total_zaps}
    Log To Console    Total time taken: ${total_time} seconds

Validation
    Undefiend test

Splashscreen Validation
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"Etisalat_Android_STB1"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
    Sleep	16s 
	${Result}  Verify Crop Image  ${port}	Splashscreen
	Run Keyword If  '${Result}' == 'True'  Log To Console  Splashscreen Is Displayed
	...  ELSE  Fail  Splashscreen Is Not Displayed
	Sleep    70s 
    Log To Console    Reboot Success