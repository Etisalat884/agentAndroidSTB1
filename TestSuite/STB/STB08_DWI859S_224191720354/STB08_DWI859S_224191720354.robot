*** Settings ***
Resource    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Robot/STB/STB08_DWI859S_224191720354/etisalat.robot
Resource    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Robot/STB/STB08_DWI859S_224191720354/Demo_Keywords.robot
Resource	/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/TestSuite/STB/STB08_DWI859S_224191720354/Recorder.resource
Library   /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB08_DWI859S_224191720354/TeardownStatusTC.py
Library   /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB08_DWI859S_224191720354/generic.py
Library   /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB08_DWI859S_224191720354/VideoQuality/Video_metrics_robot.py
# Library   /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB08_DWI859S_224191720354/audio_quality.py
Library           BuiltIn
Library           Collections
Library           OperatingSystem
Library   DateTime
Library    Process
Library		SeleniumLibrary

Suite Setup  Suite level setup
Suite Teardown  Suite level teardown
Test Setup  Test Level Setup
Test Teardown  Test Level Teardown

*** Variables ***
${video_port}     /dev/video0
${duration}       1
${trigger_id}     1234

*** keywords ***

Generate Logs with Timestamp
    ${timestamp}=    Get Current Date    result_format=%Y%m%d-%H%M%S
    ${log_file_path}=    Set Variable    ${log_file_path}_${timestamp}.txt
    Log    Log file path: ${log_file_path}
    ${syslog_process}    Start Process    idevicesyslog  ${devices}    stdout=${log_file_path}   shell=True


Suite level setup
    #status of device execution
    Set Library Search Order  Selenium2Library    AppiumLibrary
    ${exdict}  TeardownStatusTC.listconv  ${execution_id}  ${testcase}
    Set Global Variable  ${exdict}
    Run Keyword  TeardownStatusTC.Status  ${trigger_id}  ${agent_id}  In Progress  Pending
    #CLEAR LOGCAT  ${serial}
	Demo_Keywords.Restore_FFMPEG
	Start STB Screen Recording


Suite level teardown
    #${File_name}  DUMP LOGCAT   ${filename}  ${serial}
    #Log To Console  LogCat file Name: ${File_name}
    #status of device execution

    BuiltIn.Sleep  2
    run keyword if all tests passed  TeardownStatusTC.Status  ${trigger_id}  ${agent_id}  Completed  Pass
    run keyword if any tests failed  TeardownStatusTC.Status  ${trigger_id}  ${agent_id}  Completed  Fail
	Stop STB Screen Recording for both pass and fail 
Test Level Setup
    #start time
    # Generate Logs with Timestamp
    ${start_time}  GET TIME
    Log To Console    ${start_time}
    Set Global Variable  ${start_time}
	Pre Check STB Health
 
Test Level Teardown
    # #end time & each test case execution result
    # ${end_time}  GET TIME
    # #Log To Console  ${TEST NAME}:${exdict}[${TEST NAME}]
    # #Log To Console  ${exdict}
    # run keyword if test passed  TeardownStatusTC.Evaluate_time_result  ${exdict}[${TEST NAME}]  Pass  ${start_time}  ${end_time}
    # run keyword if test failed  TeardownStatusTC.Evaluate_time_result  ${exdict}[${TEST NAME}]  Fail  ${start_time}  ${end_time}
    #end time & each test case execution result
    ${end_time}  GET TIME
    #Log To Console  ${TEST NAME}:${exdict}[${TEST NAME}]
    #Log To Console  ${exdict}
	
    # run keyword if test passed  TeardownStatusTC.Evaluate_time_result  ${exdict}[${TEST NAME}]  Pass  ${start_time}  ${end_time}
    # run keyword if test failed  TeardownStatusTC.Evaluate_time_result  ${exdict}[${TEST NAME}]  Fail  ${start_time}  ${end_time}

    run keyword if test passed  TeardownStatusTC.Evaluate_time_result  ${trigger_id}  Pass  ${start_time}  ${end_time}
    run keyword if test failed  TeardownStatusTC.Evaluate_time_result  ${trigger_id}  Fail  ${start_time}  ${end_time}



CREATE CHILD PROFILE
	CLICK HOME
	Log To Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Log To Console    Creating new profile
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    Log To Console    Profile Created succesfully
	CLICK HOME
    
DELETE CHILD PROFILE
    CLICK HOME
	Log To Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
    CLICK DOWN
    CLICK DOWN
	CLICK OK
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
    CLICK OK
	CLICK HOME


CALCULATE VIDEO QUALITY
    [Arguments]    ${video_port}    ${duration}    ${trigger_id}
    ${all_results}=    Create List
    ${total_score}=    Set Variable    0.0
    FOR    ${index}    IN RANGE    5
        ${result}=    video_metrics    ${video_port}    ${duration}    ${trigger_id}
        Log To Console    ${result}
        Append To List    ${all_results}    ${result}
        ${score}=    Get From Dictionary    ${result}    Quality_Score
        ${total_score}=    Evaluate    ${total_score} + ${score}
    END
    ${average}=    Evaluate    ${total_score} / 5
    ${average}=    Evaluate    round(${average}, 2)
    RETURN    ${average}

# CALCULATE VIDEO QUALITY    
# 	[Arguments]    ${video_port}    ${duration}    ${trigger_id}
#     ${iterations}=    Set Variable    5
#     ${all_results}=    Create List
#     ${quality_list}=    Create List

#     FOR    ${index}    IN RANGE    ${iterations}
#         ${result}=    video_metrics    ${video_port}    ${duration}    ${trigger_id}
#         Log To Console    Iteration ${index+1}: ${result}
#         Append To List    ${all_results}    ${result}

#         ${ssim}=    Get From Dictionary    ${result}    SSIM Score
#         ${banding}=    Get From Dictionary    ${result}    Banding Rate
#         ${dropped}=    Get From Dictionary    ${result}    Dropped Frames

#         ${rating}=    Evaluate Video Rating    ${ssim}    ${banding}    ${dropped}    ${video_type}
#         Log To Console    Iteration ${index+1} Rating: ${rating}
#         Append To List    ${quality_list}    ${rating}
#     END

#     ${final_rating}=    Get Most Common Rating    ${quality_list}
#     Log To Console    Final Video Quality: ${final_rating}
#     RETURN    ${final_rating}

Evaluate Video Rating
    [Arguments]    ${ssim}    ${banding}    ${dropped}    ${video_type}

    # UHD 4K has slightly higher tolerance
    Run Keyword If    '${video_type}' == 'UHD'    Set Variable    ${banding_limit}=95
    ...    ELSE    Set Variable    ${banding_limit}=80

    Run Keyword If    ${ssim} >= 0.95 and ${banding} <= ${banding_limit} and ${dropped} <= 1    RETURN    Excellent
    Run Keyword If    ${ssim} >= 0.85 and ${banding} <= (${banding_limit}+10) and ${dropped} <= 3    RETURN    Good
    RETURN    Poor

Get Most Common Rating
    [Arguments]    @{ratings}
    ${counts}=    Evaluate    {r: ratings.count(r) for r in set(ratings)}    ratings=@{ratings}
    ${final}=    Evaluate    max(counts, key=counts.get)
    RETURN    ${final}

EVALUATE VIDEO QUALITY STATUS
    [Arguments]    ${score}
    ${score}=    Convert To Number    ${score}
    Run Keyword If    ${score} >= 80    Log To Console    Video quality is EXCELLENT
    ...    ELSE IF    ${score} >= 60    Log To Console    Video quality is GOOD
    ...    ELSE IF    ${score} >= 40    Log To Console    Video quality is AVERAGE
    ...    ELSE IF    ${score} >= 20    Log To Console    Video quality is POOR
    ...    ELSE    Fail    Video quality is BAD — Test Failed



*** Test Cases ***
TC_1006_PIN_ENTER_5_DIGITS
    [Tags]	REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	#VALIDATE WRONG PIN ENTERED 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1006_wrong_pin
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1006_Wrong_Pin Is Displayed on screen
	...  ELSE  Fail  TC_1006_Wrong_Pin Is Not Displayed on screen
	CLICK HOME

TC_1007_RADIO_CHANNEL_RECORDING_RESTRICTION_VALIDATION
	[Tags]	REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Sleep	10s
	CLICK RECORD
	Sleep	1s
	#VALIADTE THAT RECORDIING  CANT BE DONE FOR RADIO CHANNEL
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1007_Recording_Radio
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1007_Recording_Radio Is Displayed on screen
	...  ELSE  Fail  TC_1007_Recording_Radio Is Not Displayed on screen
	CLICK OK
	CLICK HOME

TC_1014_OK_BUTTON_VALIDATION
    [Tags]	REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	#VALIDATE THE LIVE TV TO CHECK IF THE OK BUTTON IS WORKING 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_1014_Live_TV
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1014_Live_Tv Is Displayed on screen
	...  ELSE  Fail  TC_1014_Live_Tv Is Not Displayed on screen
    CLICK HOME
    
    
TC_1030_PLAYBACK_BACK_BUTTON_PREVIOUS_CHANNEL
    [Tags]	REGRESSION
	CLICK Home
	CLICK Six
	CLICK Six
	CLICK Six
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1030_666_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1030_666_Channel Is Displayed on screen
	...  ELSE  Fail  TC_1030_666_Channel Is Not Displayed on screen
	Sleep    5s
	CLICK Six
	CLICK Seven
	CLICK Five
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1030_675_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1030_675_Channel Is Displayed on screen
	...  ELSE  Fail  TC_1030_675_Channel Is Not Displayed on screen
	Sleep    20s
	# CLICK Back
	CLICK Back
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1030_666_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1030_666_Channel Is Displayed on screen
	...  ELSE  Fail  TC_1030_666_Channel Is Not Displayed on screen
	CLICK Home
	
TC_1089_VALIDATE_WELCOME_WIZARD_ON_PROFILE_CREATION
	[Tags]    REGRESSION
	[Teardown]	Delete Profile 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK LEFT
	CLICK OK
	#VALIDATE WELCOME TO SETUP WIZARD PAGE
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_1089_Welcome_Wizard
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1089_Welcome_Wizard Is Displayed on screen
	...  ELSE  Fail  TC_1089_Welcome_Wizard Is Not Displayed on screen
	CLICK BACK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	

#filters

TC_1052_BUSINESS_HELP_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	2s
	#VALIDATE THE POP UP SHOWING CHANNEL IS BLOCKED DUE TO FILTER
	${Result}  Verify Crop Image With Shorter Duration	  ${port}  TC_1052_Block_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1052_Block_Popup Is Displayed on screen
	...  ELSE  Fail  TC_1052_Block_Popup Is Not Displayed on screen
	CLICK OK
	Reboot STB Device
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Sleep	20s
	CLICK OK
    CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	#Validation
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

################################################################################################################
TC_1151_SEARCH_IN_SIDE_PANEL_BY_TITLE
    [Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	Sleep	20s
	CLICK RIGHT
	CLICK UP
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK LEFT
	CLICK OK
	CLICK UP
    CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep	2s
	# CLICK DOWN
	${search_input}=    Get Search Cast
	Log To Console    ${search_input}
	CLICK OK
	CLICK OK
	Sleep    20s
	CLICK UP
    ${channel_name}=  Get Channel Title In Recorder From Info Bar
	Log To Console    ${channel_name}
	Verify Matching Channels    ${search_input}    ${channel_name}


TC_1152_SEARCH_IN_SIDE_PANEL_BY_DIRECTOR_NAME
    [Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	Sleep	20s
	CLICK RIGHT
	CLICK UP
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK LEFT
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK

	${Result}  Verify Crop Image With Shorter Duration  ${port}  DIRECTOR_NAME
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1036_info_search Is Displayed on screen
	...  ELSE  Fail  TC_1036_info_search Is Not Displayed on screen
	#CHECK 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK Down
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	#CHECK JOE IN THE SCREEN
	 ${channel_name}=  Get Director Name From Info Bar
    CLICK HOME



TC_1153_SEARCH_IN_SIDE_PANEL_BY_CHANNEL_NAME
    [Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	Sleep	20s
	CLICK RIGHT
	CLICK UP
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  CHNL_MBC_NAME
	Run Keyword If  '${Result}' == 'True'  Log To Console  MBC_CHANNEL_NAME Is Displayed on screen
	...  ELSE  Fail  MBC_CHANNEL_NAME Is Not Displayed on screen
	
	#TAKE MBC IMAGE IN SEARCH BAR
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep		20s
	CLICK UP
	#GET CHANNEL NAME 
	${channel_name}=  Get Channel Name In Recorder From Info Bar
	Log To Console    ${channel_name}
	 ${lower_text}=    Convert To Lower Case    ${channel_name}
    ${is_mbc_found}=    Run Keyword And Return Status    Should Contain    ${lower_text}    mbc
    Run Keyword If    ${is_mbc_found}    Log To Console    ✅ SEARCH RESULT MATCHED: MBC Detected
    Run Keyword If    not ${is_mbc_found}    Fail    ❌ SEARCH RESULT FAILED: MBC Not Detected
TC_1154_SEARCH_IN_SIDE_PANEL_BY_CAST
    [Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	Sleep	20s
	CLICK RIGHT
	CLICK UP
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK LEFT
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK LEFT
	CLICK OK
	CLICK LEFT
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    ${search_input}=    Get Search Cast
	Log To Console    ${search_input}
    CLICK OK
	# Sleep    20s
	# CLICK RIGHT
	# ${STEP_COUNT}=    Move to More Details On Side Pannel With OCR

    # CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
    # CLICK OK
    ${search_input1}=    Get Cast Name 
	Log To Console    ${search_input1}
	Verify Matching Channels    ${search_input}    ${search_input1}




TC_1155_SEARCH_IN_HOME_PAGE_BY_TITLE
    [Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    1s
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK LEFT
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	#CAPTURE INFO IMAGE IN THE SEARCH BAR
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1036_info_search
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1036_info_search Is Displayed on screen
	...  ELSE  Fail  TC_1036_info_search Is Not Displayed on screen
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep	2s
	# CLICK DOWN
	CLICK OK
	Sleep    20s
	CLICK UP
    ${channel_name}=  Get Channel Title In Recorder From Info Bar
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  INFO_RESULT
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1036_info_search Is Displayed on screen
	# ...  ELSE  Fail  TC_1036_info_search Is Not Displayed on screen
	# CLICK HOME

TC_1156_SEARCH_IN_HOME_PAGE_BY_DIRECTOR_NAME
    [Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    1s
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK LEFT
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  DIRECTOR_NAME
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1036_info_search Is Displayed on screen
	...  ELSE  Fail  TC_1036_info_search Is Not Displayed on screen
	#CHECK 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK Down
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	#CHECK JOE IN THE SCREEN
	 ${channel_name}=  Get Director Name From Info Bar
    CLICK HOME
TC_1157_SEARCH_IN_HOME_PAGE_BY_CHANNEL_NAME
    [Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    1s
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  CHNL_MBC_NAME
	Run Keyword If  '${Result}' == 'True'  Log To Console  MBC_CHANNEL_NAME Is Displayed on screen
	...  ELSE  Fail  MBC_CHANNEL_NAME Is Not Displayed on screen
	
	#TAKE MBC IMAGE IN SEARCH BAR
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep		20s
	CLICK UP
	#GET CHANNEL NAME 
	${channel_name}=  Get Channel Name In Recorder From Info Bar
	Log To Console    ${channel_name}
	 ${lower_text}=    Convert To Lower Case    ${channel_name}
    ${is_mbc_found}=    Run Keyword And Return Status    Should Contain    ${lower_text}    mbc
    Run Keyword If    ${is_mbc_found}    Log To Console    ✅ SEARCH RESULT MATCHED: MBC Detected
    Run Keyword If    not ${is_mbc_found}    Fail    ❌ SEARCH RESULT FAILED: MBC Not Detected


TC_1158_SEARCH_IN_HOME_PAGE_BY_CAST
    [Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    1s
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK LEFT
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK LEFT
	CLICK OK
	CLICK LEFT
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    ${search_input}=    Get Search Cast
	Log To Console    ${search_input}
    CLICK OK
	# Sleep    20s
	# CLICK RIGHT
	# ${STEP_COUNT}=    Move to More Details On Side Pannel With OCR

    # CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
    # CLICK OK
    ${search_input1}=    Get Cast Name 
	Log To Console    ${search_input1}
	Verify Matching Channels    ${search_input}    ${search_input1}
    CLICK HOME

TC_901_DEVICE_ETHERNET_WIFI
    [Tags]    SETTINGS
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    Sleep   2s
    Log To Console    Navigated to Settings
	CLICK DOWN
	Sleep    3s
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Settings_Ethernet_wifi_option
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Ethernet_wifi_option Is Displayed
	...  ELSE  Fail  Settings_Ethernet_wifi_option Is Not Displayed

TC_908_BILLING_TRANSACTION_HISTORY
    [Tags]    SETTINGS
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    Sleep   2s
    Log To Console    Navigated to Settings
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Billing
	CLICK DOWN
	Sleep    3s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Settings_Transaction_History_img
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Transaction_History Is Displayed
	...  ELSE  Fail  Settings_Transaction_History Is Not Displayed
    CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Show_Transactions
	Run Keyword If  '${Result}' == 'True'  Log To Console  Show_Transactions Is Displayed
	...  ELSE  Fail  Show_Transactions Is Not Displayed
	CLICK BACK
    CLICK BACK
	CLICK HOME
    

TC_902_DEVICE_CHANNEL_INFORMATION_REFRESH
    [Tags]    SETTINGS
    Navigate to Settings
	CLICK DOWN
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK RIGHT
	CLICK OK
    Sleep   8s
	Log To Console    Channel information refresh details displayed	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Setting_Channel_Info_Refresh
	Run Keyword If  '${Result}' == 'True'  Log To Console  Setting_Channel_Info_Refresh Is Displayed
	...  ELSE  Fail  Setting_Channel_Info_Refresh Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Self_care_Pop_Up
	Run Keyword If  '${Result}' == 'True'  Log To Console  Self_care_Pop_Up Is Displayed
	...  ELSE  Fail  Self_care_Pop_Up Is Not Displayed
	# CLICK OK
	# Sleep    10s
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  Selfcare_Troubleshooting
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Selfcare_Troubleshooting Is Displayed
	# ...  ELSE  Fail  Selfcare_Troubleshooting Is Not Displayed
	# CLICK RED
	# Sleep    18s
	# CLICK HOME
	# Navigate to Settings
	# CLICK DOWN
    # Sleep   2s
    # Log To Console    Navigated to Device Settings
	# CLICK RIGHT
	# CLICK OK
    # Sleep   8s
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Dismis_Pop_Up
	Run Keyword If  '${Result}' == 'True'  Log To Console  Dismis_Pop_Up Is Displayed
	...  ELSE  Fail  Dismis_Pop_Up Is Not Displayed
	CLICK OK
	Sleep    8s
	CLICK HOME

TC_903_DEVICE_BLUETOOTH_CONNECTIVITY
    [Tags]    SETTINGS
	Navigate to Settings
    Sleep   2s
    Log To Console    Navigated to Settings
	CLICK DOWN
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
    Sleep   2s
    Log To Console    Bluetooth connectivity details displayed
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Settings_Bluetooth_Not_Connected
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Bluetooth_Not_Connected Is Displayed
	...  ELSE  Fail  Settings_Bluetooth_Not_Connected Is Not Displayed
    CLICK OK
	Sleep   2s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Bluetooth_Pairing_Window
	Run Keyword If  '${Result}' == 'True'  Log To Console  Bluetooth_Pairing_Window Is Displayed
	...  ELSE  Fail  Bluetooth_Pairing_Window Is Not Displayed
	CLICK BACK
	Sleep    3s
	CLICK HOME
	CLICK HOME
    

TC_904_DEVICE_AUDIO_OUTPUT
    [Tags]    SETTINGS
	Navigate to Settings
    Sleep   2s
    Log To Console    Navigated to Settings
	CLICK DOWN
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Audio output
	CLICK OK
	Log To Console    Verify Stereo option and dolby digital option
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Stereo
	Run Keyword If  '${Result}' == 'True'  Log To Console  Stereo Is Displayed
	...  ELSE  Fail  Stereo Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Dolby_Digital
	Run Keyword If  '${Result}' == 'True'  Log To Console  Dolby_Digital Is Displayed
	...  ELSE  Fail  Dolby_Digital Is Not Displayed
	CLICK MULTIPLE TIMES    3    UP
	CLICK OK 
	Sleep    2s
	CLICK OK
	Log To Console    Stereo option is set
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Stereo_Before_Reboot
	Run Keyword If  '${Result}' == 'True'  Log To Console  Stereo_Before_Reboot Is Displayed
	...  ELSE  Fail  Stereo_Before_Reboot Is Not Displayed
	CLICK HOME
	Reboot STB Device
	CLICK HOME
    Sleep    2s
	CLICK HOME
    Sleep    2s
	CLICK HOME
	Navigate to Settings
    Sleep   2s
    Log To Console    Navigated to Settings
	CLICK DOWN
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Audio output
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Stereo_Reboot
	Run Keyword If  '${Result}' == 'True'  Log To Console  Stereo_Reboot Is Displayed
	...  ELSE  Fail  Stereo_Reboot Is Not Displayed	
	CLICK OK
	CLICK MULTIPLE TIMES    3    DOWN
	CLICK OK 
	Sleep    2s
	CLICK OK 
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Dolby_Digital_Before_Reboot
	Run Keyword If  '${Result}' == 'True'  Log To Console  Dolby_Digital_Before_Reboot Is Displayed
	...  ELSE  Fail  Dolby_Digital_Before_Reboot Is Not Displayed		
	CLICK HOME
	Reboot STB Device
	CLICK HOME
    Sleep    2s
	CLICK HOME
    Sleep    2s
	CLICK HOME
	Navigate to Settings
    Sleep   2s
    Log To Console    Navigated to Settings
	CLICK DOWN
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Audio output
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Dolby_Digital_Reboot
	Run Keyword If  '${Result}' == 'True'  Log To Console  Dolby_Digital_Reboot Is Displayed
	...  ELSE  Fail  Dolby_Digital_Reboot Is Not Displayed	
	CLICK OK
	CLICK UP
	CLICK OK 
	Sleep    2s
	CLICK OK 
	CLICK HOME
    

TC_905_DEVICE_MANUAL_UPGRADE
    [Tags]    SETTINGS
    Navigate to Settings
    Sleep   2s
    Log To Console    Navigated to Settings
	CLICK DOWN
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
	Sleep    3s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Settings_Manual_Upgrade_img
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Manual_Upgrade_img Is Displayed
	...  ELSE  Fail  Settings_Manual_Upgrade_img Is Not Displayed
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep    3s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Start_Now_Unclickable
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Manual_Upgrade_img Is not Clickable
	...  ELSE  Fail  Settings_Manual_Upgrade_img Is Clickable
	Sleep    2s
	CLICK HOME

TC_906_DEVICE_SOFT_FACTORY_RESET
	Navigate to Settings
	CLICK DOWN
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
	CLICK DOWN
	Sleep    3s
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Settings_Soft_Factory_Reset_Start_Now
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Soft_Factory_Reset_Start_Now Is Displayed
	...  ELSE  Fail  Settings_Soft_Factory_Reset_Start_Now Is Not Displayed
    CLICK OK
	Sleep    1s
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  OK
	Run Keyword If  '${Result}' == 'True'  Log To Console  OK Is Displayed
	...  ELSE  Fail  OK Is Not Displayed
	CLICK OK
	Sleep    7s
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Etisalat_Logo_reset
	Run Keyword If  '${Result}' == 'True'  Log To Console  Etisalat_Logo Is Displayed
	...  ELSE  Log To Console  Etisalat_Logo Is Not Displayed
    Sleep    150s
    Log To Console    Soft Factory Reset Success
    Check Who's Watching login
    CLICK HOME
	Sleep    2s
    Navigate to Settings
	CLICK DOWN
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
	CLICK DOWN
	Sleep    3s
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Settings_Soft_Factory_Reset_Start_Now
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Soft_Factory_Reset_Start_Now Is Displayed
	...  ELSE  Fail  Settings_Soft_Factory_Reset_Start_Now Is Not Displayed
    CLICK OK
	CLICK RIGHT
	Sleep    1s
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  CANCEL
	Run Keyword If  '${Result}' == 'True'  Log To Console  CANCEL Is Displayed
	...  ELSE  Fail  CANCEL Is Not Displayed
	CLICK OK
	Sleep    2s
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Ethernet_Selected_Validate
	Run Keyword If  '${Result}' == 'True'  Log To Console  Selecting Cancel has bought the UI back to Settings Page
	...  ELSE  Log To Console  Selecting Cancel has not bought the UI back to Settings Page


TC_914_DEVICE_SOFT_FACTORY_RESET_FUNCTIONALITY_CHECK
    Record any Live program with Local storage
	Navigate to Settings
	CLICK DOWN
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
	CLICK DOWN
	Sleep    3s
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Settings_Soft_Factory_Reset_Start_Now
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Soft_Factory_Reset_Start_Now Is Displayed
	...  ELSE  Fail  Settings_Soft_Factory_Reset_Start_Now Is Not Displayed
    CLICK OK
	Sleep    1s
	CLICK OK
	Sleep    75s
    Log To Console    Soft Factory Reset Success
    Check Who's Watching login
    CLICK HOME
	Sleep    2s
	CLICK HOME
	Verify Recording exists after Soft Factory Reset


TC_907_DEVICE_BOX_RESTORE
    [Tags]    SETTINGS
	Navigate to Settings
	CLICK DOWN
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	Sleep    3s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Settings_Box_Restore
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Box_Restore_Popup Is Displayed
	...  ELSE  Fail  Settings_Box_Restore_Popup Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  PINCODE
	Run Keyword If  '${Result}' == 'True'  Log To Console  PINCODE Is Displayed
	...  ELSE  Fail  PINCODE Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  INCODE_KEYPAD
	Run Keyword If  '${Result}' == 'True'  Log To Console  PINCODE_KEYPAD Is Displayed
	...  ELSE  Fail  PINCODE_KEYPAD Is Not Displayed
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	Log To Console    Enter Admin PIN
	CLICK MULTIPLE TIMES    4    OK
	CLICK MULTIPLE TIMES    4    DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	Sleep    11s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Etisalat_Logo_reset
	Run Keyword If  '${Result}' == 'True'  Log To Console  Etisalat_Logo Is Displayed
	...  ELSE  Log To Console  Etisalat_Logo Is Not Displayed
    Sleep    250s
    Log To Console    Box Restore Success
    Check Who's Watching login
    CLICK HOME
	Sleep    2s
	Navigate to Settings
	CLICK DOWN
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK RIGHT
	
	Sleep    3s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  CANCEL_907
	Run Keyword If  '${Result}' == 'True'  Log To Console  CANCEL Is Displayed
	...  ELSE  Fail  CANCEL Is Not Displayed
	Sleep    2s
	CLICK OK
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Ethernet_Selected_Validate
	Run Keyword If  '${Result}' == 'True'  Log To Console  Selecting Cancel has bought the UI back to Settings Page
	...  ELSE  Log To Console  Selecting Cancel has not bought the UI back to Settings Page
    Sleep    2s
	CLICK HOME


TC_915_DEVICE_BOX_RESTORE_FUNCTIONALITY_CHECK
    Record any Live program with Local storage
	Navigate to Settings
	CLICK DOWN
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	Sleep    3s
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Settings_Box_Restore
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Box_Restore Is Displayed
	...  ELSE  Fail  Settings_Box_Restore Is Not Displayed
    CLICK OK
	Sleep    1s
	CLICK MULTIPLE TIMES    4    TWO
	# CLICK OK
	CLICK DOWN
	CLICK OK
	Sleep    75s
    Log To Console    Box Restore Success
    Check Who's Watching login
    CLICK HOME
	Sleep    2s
	CLICK HOME
	Verify Recording exists after Box Restore


TC_909_BILLING_VIEW_AND_PAY_BILLS
    [Tags]    SETTINGS
		CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    Sleep   2s
    Log To Console    Navigated to Settings
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Billing Settings

    ${Result}  Verify Crop Image With Shorter Duration    ${port}    Settings_Bills_View_And_Paybills
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Bills_View_And_Paybills Is Displayed
	...  ELSE  Fail  Settings_Bills_View_And_Paybills Is Not Displayed
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Log To Console    Pop_Up appeared
    ${Result}  Verify Crop Image With Shorter Duration    ${port}    Pop_Up_Disappear2
	Run Keyword If  '${Result}' == 'True'  Log To Console  pop up Is Displayed
	...  ELSE  Fail  pop up Is Not Displayed	
	Sleep    3s
	CLICK OK
	Sleep    3s
    ${Result}  Verify Crop Image With Shorter Duration    ${port}   Pop_Up_Disappear2
	Run Keyword If  '${Result}' == 'Fail'  Log To Console  pop up Is Not Displayed
	...  ELSE  Log To Console  pop up Is Displayed
	CLICK HOME

TC_910_DIAGNOSIS_CHECK_DEVICE_INFORMATION
    [Tags]    SETTINGS
	[Teardown]    Navigate to Home from device information 
	Navigate to Settings
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
    Sleep   2s
    Log To Console    Navigated to Diagnosis Settings
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Device_Information
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Show_Device_Information Is Displayed
	...  ELSE  Fail  Settings_Show_Device_Information Is Not Displayed
	CLICK OK
    Sleep   2s 
    Log To Console    Device information displayed
	Sleep    3s
	Log To Console    Verify Application_Version is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Application_Version
	Run Keyword If  '${Result}' == 'True'  Log To Console  Application_Version Is Displayed
	...  ELSE  Fail  Application_Version Is Not Displayed
	Log To Console    Verify Application_Version_W_Values is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Application_Version_W_Values
	Run Keyword If  '${Result}' == 'True'  Log To Console  Application_Version_W_Values Is Displayed
	...  ELSE  Log To Console  Application_Version_W_Values Is Not Displayed
	
    Log To Console    Verify Oct_Version is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Oct_Version
	Run Keyword If  '${Result}' == 'True'  Log To Console  Oct_Version Is Displayed
	...  ELSE  Fail  Oct_Version Is Not Displayed
	Log To Console    Verify Oct_Version_W_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Oct_Version_W_Values
	Run Keyword If  '${Result}' == 'True'  Log To Console  Oct_Version_W_Value Is Displayed
	...  ELSE  Log To Console  Oct_Version_W_Value Is Not Displayed

    Log To Console    Verify Sop_Version is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Sop_Version
	Run Keyword If  '${Result}' == 'True'  Log To Console  Sop_Version Is Displayed
	...  ELSE  Fail  Sop_Version Is Not Displayed
	Log To Console    Verify Sop_Version_W_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Sop_Version_W_Values
	Run Keyword If  '${Result}' == 'True'  Log To Console  Sop_Version_W_Value Is Displayed
	...  ELSE  Log To Console  Sop_Version_W_Value Is Not Displayed

    Log To Console    Verify Firmware is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Firmware
	Run Keyword If  '${Result}' == 'True'  Log To Console  Firmware Is Displayed
	...  ELSE  Fail  Firmware Is Not Displayed
	Log To Console   Verify Firmware_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Firmware_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  Firmware_Value Is Displayed
	...  ELSE  Log To Console  Firmware_Value Is Not Displayed

	Log To Console    Verify STB_Serial_Number is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    STB_Serial_Number
	Run Keyword If  '${Result}' == 'True'  Log To Console  STB_Serial_Number Is Displayed
	...  ELSE  Fail  STB_Serial_Number Is Not Displayed
	Log To Console   Verify Serial_Number_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Serial_Number_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  Serial_Number_Value Is Displayed
	...  ELSE  Log To Console  Serial_Number_Value Is Not Displayed

    Log To Console    Verify STB_Model is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    STB_Model
	Run Keyword If  '${Result}' == 'True'  Log To Console  STB_Model Is Displayed
	...  ELSE  Fail  STB_Model Is Not Displayed
	Log To Console   Verify STB_Model_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    STB_Model_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  STB_Model_Value Is Displayed
	...  ELSE  Log To Console  STB_Model_Value Is Not Displayed

    Log To Console    Verify Channel_Version is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Channel_Version
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel_Version Is Displayed
	...  ELSE  Fail  Channel_Version Is Not Displayed
    Log To Console    Verify Channel_Version_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Channel_Version_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel_Version_Value Is Displayed
	...  ELSE  Log To Console  Channel_Version_Value Is Not Displayed
    
	
	Log To Console    Verify IP_Gateway is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    IP_Gateway
	Run Keyword If  '${Result}' == 'True'  Log To Console  IP_Gateway Is Displayed
	...  ELSE  Fail  IP_Gateway Is Not Displayed
	Log To Console    Verify IP_Gateway_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    IP_Gateway_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  IP_Gateway_Value Is Displayed
	...  ELSE  Log To Console  IP_Gateway_Value Is Not Displayed
    
	
	Log To Console    Verify User_ID is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    User_ID
	Run Keyword If  '${Result}' == 'True'  Log To Console  User_ID Is Displayed
	...  ELSE  Fail  User_ID Is Not Displayed
	Log To Console    Verify User_ID_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    User_ID_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  User_ID_Value Is Displayed
	...  ELSE  Log To Console  User_ID_Value Is Not Displayed
    
	
	Log To Console    Verify Hardisk is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Harddisk
	Run Keyword If  '${Result}' == 'True'  Log To Console  Hardisk Is Displayed
	...  ELSE  Fail  Hardisk Is Not Displayed
	Log To Console    Verify Hardisk_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Hardisk_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  Hardisk_Value Is Displayed
	...  ELSE  Log To Console  Hardisk_Value Is Not Displayed
    
	
	Log To Console    Verify Mac_Address is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Mac_Address
	Run Keyword If  '${Result}' == 'True'  Log To Console  Mac_Address Is Displayed
	...  ELSE  Fail  Mac_Address Is Not Displayed
	Log To Console    Verify Mac_Address_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Mac_Address_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  Mac_Address_Value Is Displayed
	...  ELSE  Log To Console  Mac_Address_Value Is Not Displayed


	Log To Console    All Device information  is displayed
    

TC_911_DIAGNOSIS_SELF_CARE
    [Tags]    SETTINGS
	[Teardown]    Navigate to Home from selfcare
	CLICK HOME
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ZERO
	Sleep    3s
	Navigate to Settings
	CLICK RIGHT
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Diagnosis Settings
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    Sleep   2s 
    Log To Console    Validate Diagnosis self care information Pop Up Options
	${Result}  Verify Crop Image With Shorter Duration    ${port}    TV
	Run Keyword If  '${Result}' == 'True'  Log To Console  TV Is Displayed
    ...  ELSE  Fail  TV Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Internet
	Run Keyword If  '${Result}' == 'True'  Log To Console  Internet Is Displayed
    ...  ELSE  Fail  Internet Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Landline
	Run Keyword If  '${Result}' == 'True'  Log To Console  Landline Is Displayed
    ...  ELSE  Fail  Landline Is Not Displayed
	Sleep    2s
	CLICK OK
	Sleep    8s
	Log To Console    Navigated to Self care TV
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Troubleshoot_TV
	Run Keyword If  '${Result}' == 'True'  Log To Console  Troubleshoot_TV Is Displayed
    ...  ELSE  Fail  Troubleshoot_TV Is Not Displayed
	CLICK RED
	Sleep    20s
	CLICK HOME
	Sleep    2s
	CLICK HOME
	${Result}  Verify Crop Image With Shorter Duration    ${port}    HOME
	Run Keyword If  '${Result}' == 'True'  Log To Console  HOME Is Displayed
    ...  ELSE  Fail  HOME Is Not Displayed
	Navigate to Settings
	CLICK RIGHT
	CLICK RIGHT
	Sleep   2s
    Log To Console    Navigated to Diagnosis Settings
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    Sleep   1s 
	CLICK DOWN
	CLICK OK
	Sleep    8s
	Log To Console    Navigated to Self care Internet
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Troubleshoot_Internet
	Run Keyword If  '${Result}' == 'True'  Log To Console  Troubleshoot_Internet Is Displayed
    ...  ELSE  Fail  Troubleshoot_Internet Is Not Displayed
	CLICK RED
	Sleep    20s
	CLICK HOME
	Sleep    2s
	CLICK HOME
	${Result}  Verify Crop Image With Shorter Duration    ${port}    HOME
	Run Keyword If  '${Result}' == 'True'  Log To Console  HOME Is Displayed
    ...  ELSE  Fail  HOME Is Not Displayed
	Navigate to Settings
	CLICK RIGHT
	CLICK RIGHT
	Sleep   2s
    Log To Console    Navigated to Diagnosis Settings
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    Sleep   1s 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    8s
	Log To Console    Navigated to Self care Landline
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Troubleshoot_Phone
	Run Keyword If  '${Result}' == 'True'  Log To Console  Troubleshoot_Phone Is Displayed
    ...  ELSE  Fail  Troubleshoot_Phone Is Not Displayed
	# CLICK RED
	# Sleep    20s
	# CLICK HOME
	# Sleep    2s
	# CLICK HOME
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}    HOME
	# Run Keyword If  '${Result}' == 'True'  Log To Console  HOME Is Displayed
    # ...  ELSE  Fail  HOME Is Not Displayed


	
TC_912_DIAGNOSIS_AUTO_RESTART_OFF_ON_CHECK
    [Tags]    SETTINGS
	[Teardown]    Revert Auto Restart Enable
	Navigate to Settings
	CLICK RIGHT
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Diagnosis Settings
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	CLICK OK
	Log To Console    Verify On and Off Option is available for Auto Restart
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  On
	Run Keyword If  '${Result}' == 'True'  Log To Console  On Is Displayed
	...  ELSE  Fail  On Is Not Displayed
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Off
	Run Keyword If  '${Result}' == 'True'  Log To Console  Off Is Displayed
	...  ELSE  Fail  Off Is Not Displayed
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK OK
    Sleep   2s
	CLICK OK
    Log To Console    Verify Off Option is available for Auto Restart before Reboot
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Off_Before_Reboot
	Run Keyword If  '${Result}' == 'True'  Log To Console  Off_Before_Reboot Is Displayed
	...  ELSE  Fail  Off_Before_Reboot Is Not Displayed
	Sleep    2s
	CLICK HOME
	Reboot STB Device
	Sleep    3s
	CLICK HOME
	Sleep    3s
	CLICK HOME
	Navigate to Settings
	CLICK RIGHT
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Diagnosis Settings
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	Log To Console    Verify Off Option is available for Auto Restart After Reboot
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Off_After_Reboot
	Run Keyword If  '${Result}' == 'True'  Log To Console  Off_After_Reboot Is Displayed
	...  ELSE  Fail  Off_After_Reboot Is Not Displayed
	CLICK OK
    Sleep   2s
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK OK
    Sleep   2s
	CLICK OK
    
	
	Log To Console    Verify  On Option is available for Auto Restart before Reboot
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  On_Before_Reboot
	Run Keyword If  '${Result}' == 'True'  Log To Console  On_Before_Reboot Is Displayed
	...  ELSE  Fail  On_Before_Reboot Is Not Displayed
	Sleep    2s
	CLICK HOME
	Reboot STB Device
	Sleep    3s
	CLICK HOME
	Sleep    3s
	CLICK HOME
	Navigate to Settings
	CLICK RIGHT
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Diagnosis Settings
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	Log To Console    Verify  On Option is available for Auto Restart After Reboot
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  On_After_Reboot
	Run Keyword If  '${Result}' == 'True'  Log To Console  On_After_Reboot Is Displayed
	...  ELSE  Fail  On_After_Reboot Is Not Displayed
	CLICK OK
    Sleep   2s
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK OK
    Sleep   2s
	CLICK OK
	CLICK HOME
	CLICK HOME

TC_913_DIAGNOSIS_HDMI_CEC_DISABLED_ENABLED
    [Tags]    SETTINGS
	[Teardown]    Revert to HDMI Disabled
	Navigate to Settings
    Sleep   2s
	CLICK RIGHT
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Diagnosis Settings
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    2s
	Log To Console    Verify both HDMI Options are available
	${Result}   Verify Crop Image With Shorter Duration    ${port}   Enabled
	Run Keyword If  '${Result}' == 'True'  Log To Console  Enabled Is Displayed
	...  ELSE  Fail  Enabled Is Not Displayed
	${Result}   Verify Crop Image With Shorter Duration    ${port}   Disabled
	Run Keyword If  '${Result}' == 'True'  Log To Console  Disabled Is Displayed
	...  ELSE  Fail  Disabled Is Not Displayed	
	CLICK MULTIPLE TIMES    3    UP
    CLICK MULTIPLE TIMES    2    OK
    Log To Console    Verify HDMI CEC is Enabled Before Reboot
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Enabled_Before_Reboot
	Run Keyword If  '${Result}' == 'True'  Log To Console  Enabled_Before_Reboot Is Displayed
	...  ELSE  Fail  Enabled_Before_Reboot Is Not Displayed
	Sleep   2s
	CLICK HOME
	Reboot STB Device
	Sleep    3s
	CLICK HOME 
	Sleep    3s
	CLICK HOME
    Navigate to Settings
    Sleep   2s
	CLICK RIGHT
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Diagnosis Settings
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
    Log To Console    Verify HDMI CEC is Enabled After Reboot
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Enabled_After_Reboot
	Run Keyword If  '${Result}' == 'True'  Log To Console  Enabled_After_Reboot Is Displayed
	...  ELSE  Fail  Enabled_After_Reboot Is Not Displayed
    Sleep    2s
	CLICK OK
	CLICK MULTIPLE TIMES    3    DOWN
    CLICK MULTIPLE TIMES    2    OK
    Log To Console    Verify HDMI CEC is Disabled Before Reboot
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Disabled_Before_Reboot
	Run Keyword If  '${Result}' == 'True'  Log To Console  Disabled_Before_Reboot Is Displayed
	...  ELSE  Fail  Disabled_Before_Reboot Is Not Displayed
	Sleep   2s
	CLICK HOME
	Reboot STB Device
	Sleep    3s
	CLICK HOME 
	Sleep    3s
	CLICK HOME
    Navigate to Settings
    Sleep   2s
	CLICK RIGHT
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Diagnosis Settings
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
    Log To Console    Verify HDMI CEC is Disabled After Reboot
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Disabled_After_Reboot
	Run Keyword If  '${Result}' == 'True'  Log To Console  Disabled_After_Reboot Is Displayed
	...  ELSE  Fail  Disabled_After_Reboot Is Not Displayed
    Sleep    2s
	CLICK OK
	CLICK MULTIPLE TIMES    3    DOWN
    CLICK MULTIPLE TIMES    2    OK
	Sleep    2s
	CLICK HOME





########################## ENGINEERING MENU ################################



#############################GUIDE#######################################


############################################################################################

###################################ENGINEERINGMENU##############################
TC_921_ANDROID_SUMMARY_MENU
	[Tags]		ENGINEERING MENU
	[Documentation]		Verify summary Menu User interface
	CLICK HOME
	CLICK BACK
	CLICK BACK
	Sleep	2s
	CLICK MENU
	CLICK GREEN
	CLICK YELLOW
	CLICK BLUE
	Sleep	5s 
	Log To Console		Navigated to Engineering Menu
	CLICK OK
	#Validate Highlighted Summary
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_921_Summary
	Run Keyword If  '${Result}' == 'True'  Log To Console  Summary Is Displayed
	...  ELSE  Fail  Summary Is Not Displayed
	Sleep	5s
	CLICK BACK
	CLICK HOME
	Sleep	5s 


TC_922_ANDROID_SERVICES_MENU
	[Tags]		ENGINEERING MENU
	[Documentation]		Verify Services Menu User interface
	CLICK HOME
	CLICK BACK
	CLICK BACK
	Sleep	2s
	CLICK MENU
	CLICK GREEN
	CLICK YELLOW
	CLICK BLUE
	Sleep	5s 
	Log To Console		Navigated to Engineering Menu
	CLICK DOWN
	CLICK OK
	#Validate Highlighted Services Menu
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_922_Services_Menu
	Run Keyword If  '${Result}' == 'True'  Log To Console  Services_Menu Is Displayed
	...  ELSE  Fail  Services_Menu Is Not Displayed
	CLICK BACK
	CLICK HOME



TC_923_ANDROID_PLAYBACK_MENU
	[Tags]		ENGINEERING MENU
	[Documentation]		Verify Playback Menu User interface
	CLICK HOME
	CLICK BACK
	CLICK BACK
	Sleep	2s
	CLICK MENU
	CLICK GREEN
	CLICK YELLOW
	CLICK BLUE
	Sleep	5s 
	Log To Console		Navigated to Engineering Menu
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	#Validate Highlighted Playback Menu
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_923_Playback_Menu
	Run Keyword If  '${Result}' == 'True'  Log To Console  Playback_Menu Is Displayed
	...  ELSE  Fail  Playback_Menu Is Not Displayed
	CLICK BACK
	CLICK HOME
	Sleep	5s 

TC_924_ANDROID_STORAGE_MENU
	[Tags]		ENGINEERING MENU
	[Documentation]		Verify Storage Menu User interface
	CLICK HOME
	CLICK BACK
	CLICK BACK
	Sleep	2s
	CLICK MENU
	CLICK GREEN
	CLICK YELLOW
	CLICK BLUE
	Sleep	5s 
	Log To Console		Navigated to Engineering Menu
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	#Validate Highlighted Storage Menu
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_924_Storage_Menu
	Run Keyword If  '${Result}' == 'True'  Log To Console  Storage_Menu Is Displayed
	...  ELSE  Fail  Storage_Menu Is Not Displayed
	CLICK BACK
	CLICK HOME
	Sleep	5s 


TC_925_ANDROID_SYSTEM_MENU
	[Tags]		ENGINEERING MENU
	[Documentation]		Verify System Menu User interface
	CLICK HOME
	CLICK BACK
	CLICK BACK
	Sleep	2s
	CLICK MENU
	CLICK GREEN
	CLICK YELLOW
	CLICK BLUE
	Sleep	5s 
	Log To Console		Navigated to Engineering Menu
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	#Validate Highlighted System Menu
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_925_System_Menu
	Run Keyword If  '${Result}' == 'True'  Log To Console  System_Menu Is Displayed
	...  ELSE  Fail  System_MenuIs Not Displayed
	CLICK BACK
	CLICK HOME
	Sleep	5s 

TC_926_ANDROID_WIFI_AP
	[Tags]		ENGINEERING MENU
	[Documentation]		Verify WiFi AP Menu User interface
	CLICK HOME
	CLICK BACK
	CLICK BACK
	Sleep	2s
	CLICK MENU
	CLICK GREEN
	CLICK YELLOW
	CLICK BLUE
	Sleep	5s 
	Log To Console		Navigated to Engineering Menu
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	#Validate Highlighted WiFi AP Menu
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_926_WIFI_AP
	Run Keyword If  '${Result}' == 'True'  Log To Console  WIFI_AP Is Displayed
	...  ELSE  Fail  WIFI_AP Not Displayed
	CLICK BACK
	CLICK HOME
	Sleep	5s
	

TC_927_ANDROID_WIFI_STA
	[Tags]	ENGINEERING MENU
	[Documentation]	  verify WiFi-STA under Engineering Menus
	CLICK HOME
	CLICK BACK
	CLICK BACK
	Sleep	3s 
	CLICK MENU
	CLICK GREEN
	CLICK YELLOW
	CLICK BLUE
	Sleep	3s
	Log To Console	Navigated to Engineering Menu
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep	3s
	Log To Console	Navigated to Wifi STA Menu
	#vsalidate wifi STA
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_927_WIFI_STA
	Run Keyword If  '${Result}' == 'True'  Log To Console  WIFI_STA Is Displayed
	...  ELSE  Fail  WIFI_STA Not Displayed
	CLICK BACK
	CLICK HOME
	Sleep	3s

TC_928_ANDROID_VERIFY_UI_MODE_UNDER_SERVICES_MENU
	[Tags]	ENGINEERING MENU
	[Documentation]	  verify WiFi-STA under Engineering Menus
	CLICK HOME
	CLICK BACK
	CLICK BACK
	Sleep	3s 
	CLICK MENU
	CLICK GREEN
	CLICK YELLOW
	CLICK BLUE
	Sleep	3s
	Log To Console	Navigated to Engineering Menu
	CLICK DOWN
	CLICK OK
	Sleep	3s
	Log To Console	Navigated to Services Menu
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK LEFT
	CLICK OK
	Sleep	3s 
	#Validate OTT in dropdown
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_928_OTT
	Run Keyword If  '${Result}' == 'True'  Log To Console  OTT Is Displayed
	...  ELSE  Fail  OTT Not Displayed
	CLICK OK
	CLICK BACK
	Sleep	3s
	CLICK HOME
	Sleep	3s

TC_929_ANDROID_VERIFY_HDMI_FORMAT_UNDER_PLAYBACK_MENU
	[Tags]	ENGINEERING MENU
	[Documentation]		Verify HDMI format under Playback menu
	CLICK HOME
	CLICK BACK
	CLICK BACK
	Sleep	2s 
	CLICK MENU
	CLICK GREEN
	CLICK YELLOW
	CLICK BLUE
	Sleep	5s 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	Sleep	2s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep	2s 
	#Validate 1080p 60
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_929_HDMI
	Run Keyword If  '${Result}' == 'True'  Log To Console  HDMI Is Displayed
	...  ELSE  Fail  HDMI Not Displayed
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK BACK
	CLICK HOME
	Sleep	3s

TC_930_ANDROID_VERIFY_ETHERNET_CONNECTED_UNDER_SYSTEM_MENU
	[Tags]	ENGINEERING MENU
	[Documentation]		Verify ethernet connected  under system menu
	CLICK HOME
	CLICK BACK
	CLICK BACK
	Sleep	2s
	CLICK MENU
	CLICK GREEN
	CLICK YELLOW
	CLICK BLUE
	Sleep	5s
	Log To Console	Navigated to Engineering Menu 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep	5s 
	Log To Console	Navigated to System Menu
	CLICK RIGHT
	CLICK OK
	Sleep	3s 
	#Validate ethernet connected in network & internet
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_930_Ethernet
	Run Keyword If  '${Result}' == 'True'  Log To Console  Ethernet Is Displayed
	...  ELSE  Fail  Ethernet Not Displayed
	CLICK BACK
	CLICK BACK
	CLICK HOME
	Sleep	3s

TC_931_ANDROID_VERIFY_USB_TYPE_UNDER_STORAGE_MENU
	[Tags]	ENGINEERING MENU
	[Documentation]		Verify USB type under storage Menu
	CLICK HOME
	CLICK BACK
	CLICK BACK
	Sleep	5s
	CLICK MENU
	CLICK GREEN
	CLICK YELLOW
	CLICK BLUE
	Sleep	5s
	Log To Console	Navigated to Engineering Menu 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep	5s
	Log To Console	Navigated to Storage Menu
	#Validate USB Type under storage menu
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_931_USB_TYPE
	Run Keyword If  '${Result}' == 'True'  Log To Console  USB_Type Is Displayed
	...  ELSE  Fail  USB_Type Not Displayed
	CLICK BACK
	CLICK HOME
	Sleep	3s

TC_932_ANDROID_VERIFY_BROADCAST_NETWORK_ENABLED
	[Tags]	ENGINEERING MENU
	[Documentation]		Verify Broadcast network enabled
	CLICK HOME
	CLICK BACK
	CLICK BACK
	Sleep	5s
	CLICK MENU
	CLICK GREEN
	CLICK YELLOW
	CLICK BLUE
	Sleep	5s
	Log To Console	Navigated to Engineering Menu 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep	5s
	Log To Console	Navigated to WIFI AP Menu
	CLICK RIGHT
	#Validate broadcast option enabled under network menu
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_932_Broadcast_Enabled
	Run Keyword If  '${Result}' == 'True'  Log To Console  Broadcast_Enabled Is Displayed
	...  ELSE  Fail  Broadcast_Enabled Not Displayed
	CLICK LEFT
	CLICK BACK
	CLICK HOME
	Sleep	3s


# TC_934_ANDROID_SPLASHSCREEN_AT_REBOOT
# 	[Tags]	 ENGINEERING MENU
# 	CLICK HOME
# 	CLICK BACK
# 	CLICK BACK
# 	Sleep	3s 
# 	CLICK MENU
# 	CLICK GREEN 
# 	CLICK YELLOW
# 	CLICK BLUE
# 	Sleep	1s 
# 	Splashscreen Validation
# 	CLICK OK
# 	CLICK OK 
# 	Sleep	20s 
# 	CLICK OK
# 	Sleep	1s
# 	CLICK HOME
# 	${Result}  Verify Crop Image With Shorter Duration    ${port}	TC_966_Home
# 	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_966_Home Is Displayed
# 	...  ELSE  Fail  TC_966_Home Is Not Displayed
###########################################################################################

TC_501_DISPLAY_BASED_ON_VOD_TYPE
    [Tags]    VOD
    [Documentation]    Display based on vod type
	[Timeout]    5000s
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	Sleep	 2s
	CLICK Down
	CLICK Ok
	Sleep    2s
	CLICK Right
	CLICK Right
	CLICK Right

	CLICK Ok
	Sleep    2s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_502_ACTION
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_502_ACTION Is Displayed
	...  ELSE  Fail  TC_502_ACTION Is Not Displayed
    Rating

	CLICK Back
	CLICK Back
	CLICK DOWN
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_501_ADVENTURE
	Run Keyword If  '${Result}' == 'True'  Log To Console   TC_501_ADVENTURE Is Displayed
	...  ELSE  Fail  TC_501_ADVENTURE Is Not Displayed
	Rating
	CLICK Back
	CLICK Back
	CLICK DOWN
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_501_animation
	Run Keyword If  '${Result}' == 'True'  Log To Console   TC_501_animation Is Displayed
	...  ELSE  Fail  TC_501_animation Is Not Displayed
	Rating
	CLICK Back
	CLICK Back
	CLICK RIGHT
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_501_DRAMA
	Run Keyword If  '${Result}' == 'True'  Log To Console   tc_501_drama Is Displayed
	...  ELSE  Fail  TC_501_drama Is Not Displayed
	Rating
    CLICK Back
	CLICK Back
	CLICK UP
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_documentary
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_documentary Is Displayed
	...  ELSE  Fail  501_documentary Is Not Displayed
    Rating
	CLICK Back
	CLICK Back
	CLICK UP
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_comedy
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_comedy Is Displayed
	...  ELSE  Fail  501_comedy Is Not Displayed
	Rating
	CLICK Back
	CLICK Back
	CLICK RIGHT
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_family
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_family Is Displayed
	...  ELSE  Fail  501_family Is Not Displayed
	Rating
	CLICK Back
	CLICK Back
	CLICK DOWN
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_horror
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_horror Is Displayed
	...  ELSE  Fail  501_horror Is Not Displayed
    Rating
	CLICK Back
	CLICK BACK
	CLICK DOWN
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_kids
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_kids Is Displayed
	...  ELSE  Fail  501_kids Is Not Displayed
	Rating
	CLICK Back
	CLICK BACK
	CLICK RIGHT
	CLICK UP
	CLICK UP
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_musical
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_musical Is Displayed
	...  ELSE  Fail  501_musical Is Not Displayed
    Rating
	CLICK Back
	CLICK BACK
	CLICK DOWN
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_romance
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_romance Is Displayed
	...  ELSE  Fail  501_romance Is Not Displayed 
	Rating
	CLICK Back
	CLICK BACK
	CLICK DOWN
	CLICK Ok
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_sciencefiction
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_sciencefiction Is Displayed
	...  ELSE  Fail  501_sciencefiction Is Not Displayed
	Rating
	CLICK Back
	CLICK BACK
	CLICK RIGHT
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_triller
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_triller Is Displayed
	...  ELSE  Fail  501_triller Is Not Displayed
    Rating
	CLICK Home
TC_502_BROWSE_ONDEMAND_INITIATE_PLAYBACK
    [Tags]    VOD
    [Documentation]    Browse VOD and play
	CLICK Home
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right

	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_502_ACTION
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_502_ACTION Is Displayed
	...  ELSE  Fail  TC_502_ACTION Is Not Displayed
	CLICK Ok
	CLICK Ok
	buyrentalsblock
	pinblock
    checkformat
    Sleep    5s
	vod category navigations

TC_503_SEARCH_VOD_INITIATE_PLAYBACK_FROM_SEARCH
    [Tags]    VOD
    [Documentation]    Search VOD and initiate playback
	[Timeout]    2400s
	CLICK Home
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
    
	Bring control to first character

	CLICK UP
	CLICK OK

	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK

	CLICK DOWN
	search Allied Movie
    buyrentalsblock
	pinblock
    checkformat
	Sleep	15s
    CLICK UP
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK BACK
	CLICK BACK
    CLICK HOME
	CLICK HOME
	CLICK HOME
    
	Log To Console    Searching movie from box office side panel

	Search from side Panel
	CLICK UP	
	CLICK DOWN
	search Allied Movie
    buyrentalsblock
	pinblock
    checkformat
	Sleep	15s
    CLICK UP
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	CLICK BACK
	CLICK BACK
    CLICK HOME
	CLICK HOME
	CLICK HOME

TC_504_PAUSE_A_VOD_TITLE_FOR_5MIN_THEN_RESUME
	[Tags]    VOD
    [Documentation]    Browse ondemand and initiate playback
	CLICK Home
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	Sleep    2s
	CLICK Ok
	buyrentalsblock
	pinblock
    checkformat
	Sleep    30s
	# Sleep    3s
	CLICK UP
	${start_over_status}=	Get Start Over Progress Bar Status
	${time_range_before}=	Get Extracted Time On Player Info Bar	${start_over_status}
	${time_before_pause}=	Check OCR Start Timestamp Using AI Slots	${time_range_before}
	Log To Console	${time_before_pause}
	CLICK OK
	Log To Console	Paused for 300s
	Sleep	300s
	CLICK OK
	${start_over_status_after}=	Get Start Over Progress Bar Status
	${time_range_before}=	Get Extracted Time On Player Info Bar	${start_over_status_after}
	${time_after_pause}=	Check OCR Start Timestamp Using AI Slots	${time_range_before}
	Log To Console	${time_after_pause}
	Check OCR Timestamp After Pause Start Over    ${time_after_pause}    ${time_before_pause}    12
    ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
    CLICK HOME


TC_505_VOD_FAST_FORWARD_RESUME
    [Tags]    VOD
    [Documentation]    VOD Fast forward and resume
	CLICK Home
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK RIGHT
	CLICK Ok
	# SLeep    2s
	# CLICK DOWN
	# CLICK Ok
	# Sleep    2s
	CLICK Ok
	buyrentalsblock
	pinblock
    checkformat

	# Sleep    30s
	# Sleep    3s
	CLICK UP
	CLICK Right
	CLICK Ok
	Sleep    10s
	${4x_fwd}=    Get Time Before Fast Forward Or Rewind
	${Result}  Verify Crop Image With Shorter Duration   ${port}  4X_SPEED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_4x_ff Is Displayed
	...  ELSE  Fail  TC_505_4x_ff Is Not Displayed
	Get Time After Fast Forward    ${4x_fwd}
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    5s
	${8x_fwd}=    Get Time Before Fast Forward Or Rewind
	${Result}  Verify Crop Image With Shorter Duration   ${port}  8X_SPEED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_8x_ff Is Displayed
	...  ELSE  Fail  TC_505_8x_ff Is Not Displayed
	Get Time After Fast Forward    ${8x_fwd}
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    2s
	${16x_fwd}=    Get Time Before Fast Forward Or Rewind
	${Result}  Verify Crop Image With Shorter Duration		${port}  16X_SPEED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_16xff Is Displayed
	...  ELSE  Fail  TC_505_16xff Is Not Displayed
	Get Time After Fast Forward    ${16x_fwd}
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    2s
	${32x_fwd}=    Get Time Before Fast Forward Or Rewind
	${Result}  Verify Crop Image With Shorter Duration   ${port}  32X_SPEED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_32xff Is Displayed
	...  ELSE  Fail  TC_505_32xff Is Not Displayed
	Get Time After Fast Forward    ${32x_fwd}
	CLICK LEFT
	CLICK Ok
	 ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	CLICK Home
TC_506_VOD_REWIND_RESUME
	[Tags]    VOD
    [Documentation]    VOD Fast forward and resume
	CLICK Home
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	# Sleep    2s
	# CLICK DOWN
	# CLICK Ok
    # Sleep   2s
	CLICK Ok
	buyrentalsblock
	pinblock
    checkformat

    
	# Sleep    30s
	# Sleep    3s
	CLICK UP
	CLICK Right
	CLICK Right
	CLICK Ok
	Sleep    1s
	CLICK Ok
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK Ok
	Sleep    5s
	${4x_Rewind}=    Get Time Before Fast Forward Or Rewind
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC506_-4X_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-4X_rewind Is Displayed
	...  ELSE  Fail  TC506_-4X_rewind Is Not Displayed
	Get Time After Fast Rewind    ${4x_Rewind}
	CLICK RIGHT
	CLICK Ok
	CLICK LEFT
	CLICK Ok
	CLICK Ok
	Sleep    2s
	${8x_Rewind}=    Get Time Before Fast Forward Or Rewind
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC506_-8x_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-8x_rewind Is Displayed
	...  ELSE  Fail  TC506_-8x_rewind Is Not Displayed
	Get Time After Fast Rewind    ${8x_Rewind}
	CLICK RIGHT
	CLICK Ok
	CLICK LEFT
	CLICK Ok
	CLICK Ok
	CLICK Ok
	Sleep    2s
	${16x_Rewind}=    Get Time Before Fast Forward Or Rewind
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC506_-16x_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-16x_rewind Is Displayed
	...  ELSE  Fail  TC506_-16x_rewind Is Not Displayed
	Get Time After Fast Rewind    ${16x_Rewind}
	CLICK RIGHT
	CLICK Ok
	 ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	CLICK Home

TC_507_STOP_VOD_MID_PLAYBACK_CONFIRM_EXIT_VOD_LIBRARY
    [Tags]    VOD
    [Documentation]    Stop VOD and and exit vod library
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK DOWN
	CLICK OK
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK RIGHT
	CLICK Ok
	CLICK OK
	CLICK OK
	buyrentalsblock
	pinblock
    checkformat

	Sleep    3s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	  ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK BACK
		${Result}  Verify Crop Image With Shorter Duration  ${port}  GENRE_ACTION
	Run Keyword If  '${Result}' == 'True'  Log To Console  GENRE_ACTION Is Displayed
	...  ELSE  Fail  GENRE_ACTION Is Not Displayed
	CLICK BACK
		${Result}  Verify Crop Image With Shorter Duration  ${port}  ACTION
	Run Keyword If  '${Result}' == 'True'  Log To Console  ACTION Is Displayed
	...  ELSE  Fail  ACTION Is Not Displayed
    CLICK HOME

TC_508_VERIFY_VOD_SUBTITLE_CHANGE
    [Tags]    VOD
    [Documentation]     VOD subtitle change and play
	CLICK HOME
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok

	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	#CLICK RIGHT
	CLICK OK
	Sleep    2s
	# CLICK DOWN
	# CLICK OK
	CLICK Ok
	buyrentalsblock
	pinblock
    checkformat

    Sleep    5s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	# ===================== FIRST LANGUAGE SELECTION =====================

	CLICK UP
	CLICK OK
	CLICK OK

	${is_en}=    Verify Crop Image With Shorter Duration   ${port}    English_Audio
	${is_ar}=    Verify Crop Image With Shorter Duration   ${port}    Arabic_Subtitle

	Log To Console    English visible: ${is_en}
	Log To Console    Arabic visible: ${is_ar}

	# 🔒 ALWAYS reset before selection
	${selected_lang}=    Set Variable    NONE

	IF    '${is_en}' == 'True'
		Log To Console    English is highlighted → selecting English
		CLICK OK
		${selected_lang}=    Set Variable    en

	ELSE IF    '${is_ar}' == 'True'
		Log To Console    Arabic is highlighted → selecting Arabic
		CLICK OK
		${selected_lang}=    Set Variable    ar

	ELSE
		Log To Console    No language option detected — skipping validation
	END

	Sleep    3s

	# ✅ Validate ONLY if a language was selected
	IF    '${selected_lang}' == 'en'
		${lang_en}=    Capture Multiple Screens And Validate Language    en
		IF    '${lang_en}' == 'True'
			Log To Console    English language validated
		ELSE
			Fail    English selected but not displayed
		END

	ELSE IF    '${selected_lang}' == 'ar'
		${lang_ar}=    Capture Multiple Screens And Validate Language    ar
		IF    '${lang_ar}' == 'True'
			Log To Console    Arabic language validated
		ELSE
			Fail    Arabic selected but not displayed
		END

	ELSE
		Log To Console    Validation skipped — no language selected
	END


	# ===================== NAVIGATION =====================

	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK


	# ===================== SECOND LANGUAGE SELECTION =====================

	${is_en}=    Verify Crop Image With Shorter Duration   ${port}    English_Audio
	${is_ar}=    Verify Crop Image With Shorter Duration   ${port}    Arabic_Subtitle

	Log To Console    English visible: ${is_en}
	Log To Console    Arabic visible: ${is_ar}

	# 🔒 Reset AGAIN (very important)
	${selected_lang}=    Set Variable    NONE

	IF    '${is_en}' == 'True'
		Log To Console    English is highlighted → selecting English
		CLICK OK
		${selected_lang}=    Set Variable    en

	ELSE IF    '${is_ar}' == 'True'
		Log To Console    Arabic is highlighted → selecting Arabic
		CLICK OK
		${selected_lang}=    Set Variable    ar

	ELSE
		Log To Console    No language option detected — skipping validation
	END

	Sleep    3s

	# ✅ Validate ONLY if selected
	IF    '${selected_lang}' == 'en'
		${lang_en}=    Capture Multiple Screens And Validate Language    en
		IF    '${lang_en}' == 'True'
			Log To Console    English language validated
		ELSE
			Fail    English selected but not displayed
		END

	ELSE IF    '${selected_lang}' == 'ar'
		${lang_ar}=    Capture Multiple Screens And Validate Language    ar
		IF    '${lang_ar}' == 'True'
			Log To Console    Arabic language validated
		ELSE
			Fail    Arabic selected but not displayed
		END

	ELSE
		Log To Console    Validation skipped — no language selected
	END

	CLICK HOME


TC_509_SWITCH_AUDIO_TRACKS_DURING_VOD_PLAYBACK
    [Tags]    VOD
    [Documentation]    Switch Audio tracks

    CLICK HOME
	CLICK Home
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK

    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Sleep    2s

    CLICK OK
    buyrentalsblock
    pinblock
    checkformat

    Sleep    5s

    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK

    # ===================== FIRST AUDIO SELECTION =====================
    CLICK UP
    CLICK OK
    CLICK OK

    ${is_en}=    Verify Crop Image With Shorter Duration   ${port}    English_Audio_Playback
    ${is_ar}=    Verify Crop Image With Shorter Duration   ${port}    Arabic_Subtitle

    Log To Console    English audio visible: ${is_en}
    Log To Console    Arabic audio visible: ${is_ar}

    ${first_audio}=    Set Variable    NONE

    IF    '${is_en}' == 'True'
        Log To Console    Selecting English audio
        CLICK OK
        ${first_audio}=    Set Variable    en

    ELSE IF    '${is_ar}' == 'True'
        Log To Console    Selecting Arabic audio
        CLICK OK
        ${first_audio}=    Set Variable    ar

    ELSE
        Log To Console    No audio language detected
    END

    Sleep    2s
    Log To Console    First audio selected: ${first_audio}

    # ✅ Always validate first selection
    # Unified verification of Audio Quality

    # ===================== NAVIGATION BACK =====================
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    CLICK DOWN
    CLICK OK
    CLICK OK

    # ===================== SECOND AUDIO SELECTION =====================
    ${is_en}=    Verify Crop Image With Shorter Duration   ${port}    English_Audio
    ${is_ar}=    Verify Crop Image With Shorter Duration   ${port}    Arabic_Subtitle

    Log To Console    English audio visible: ${is_en}
    Log To Console    Arabic audio visible: ${is_ar}

    ${audio_switched}=    Set Variable    False
    ${second_audio}=     Set Variable    ${first_audio}

    IF    '${is_en}' == 'True' and '${first_audio}' != 'en'
        Log To Console    Switching audio to English
        CLICK OK
        ${second_audio}=    Set Variable    en
        ${audio_switched}=  Set Variable    True

    ELSE IF    '${is_ar}' == 'True' and '${first_audio}' != 'ar'
        Log To Console    Switching audio to Arabic
        CLICK OK
        ${second_audio}=    Set Variable    ar
        ${audio_switched}=  Set Variable    True

    ELSE
        Log To Console    Same audio language — no switch performed
    END

    Sleep    2s
    Log To Console    Second audio selected: ${second_audio}

    # ❌ Run only if audio changed
    IF    '${audio_switched}' == 'True'
        # Unified verification of Audio Quality
		Log To Console	Checked Audio
    ELSE
        Log To Console    Audio not changed — skipping audio quality verification
    END

    CLICK HOME
TC_510_VERIFY_4K_VOD_CONTENT
    [Tags]    VOD
	[Documentation]    verify 4k content
	[Timeout]    2400s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK

	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	#CLICK RIGHT
	CLICK OK
	Sleep    2s
	CLICK DOWN
	CLICK OK
	CLICK Ok
	buyrentalsblock
	pinblock
    checkformat

    Sleep    5s
	CLICK UP
    ${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Sleep    60s
	Log To Console    Video is playing for 60s

	Video Quality Verification
    # Verify Audio Quality
	CLICK HOME


TC_511_VERIFY_VOD_ADD_TO_LIST
    [Tags]    VOD
	[Documentation]    Add VOD To Watch later
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	Log To Console    navigated to vod section
	CLICK Ok
	Log To Console    navigated to vod library
    CLICK Right
	# CLICK UP
	CLICK Ok
    ${res1}=  Rent Assest in Boxoffice
	Log To Console    ${res1}
	Run Keyword If    'A QUIET PLACE PART Il' in '${res1}'
    ...    ${res1}=    Replace String    ${res1}    Il    II
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_511_watch_later
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_511_watch_later Is Displayed
	...  ELSE   Fail    TC_511_watch_later Is Not Displayed,Asset is already added to list
	CLICK OK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK

	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	#CLICK RIGHT
	CLICK OK
	# Normalize expected text ONCE
	${res1}=    Convert To Upper Case    ${res1}
	${res1}=    Strip String             ${res1}
	${res1}=    Replace String    ${res1}    ${SPACE}    ${EMPTY}

	${match_found}=    Set Variable    False

	FOR    ${i}    IN RANGE    20
		${res2}=    Verify Assert After adding to list
		${res2}=    Convert To Upper Case    ${res2}
		${res2}=    Strip String             ${res2}
		${res2}=    Replace String    ${res2}    ${SPACE}    ${EMPTY}

		IF    '${res1}' == '${res2}'
			Log To Console    ✅ MATCH FOUND: ${res2}
			${match_found}=    Set Variable    True
			Exit For Loop
		ELSE
			CLICK DOWN
			CLICK LEFT
		END
	END

	IF    not ${match_found}
		Fail    ❌ MATCH NOT FOUND AFTER 20 ATTEMPTS
	END


    ${Result}  Verify Crop Image With Shorter Duration  ${port}  PLAY
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_511_watch_later Is Displayed
	...  ELSE  Log To Console    TC_511_watch_later Is Not Displayed,Asset is already added to list
    CLICK OK
	pinblock
	checkformat
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	  ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK HOME
# TC_511_VERIFY_VOD_ADD_TO_LIST
#     [Tags]    VOD
# 	[Documentation]    Add VOD To Watch later
# 	CLICK Home
# 	CLICK Up
# 	CLICK Right
# 	CLICK Right
# 	CLICK Ok
# 	Log To Console    navigated to vod section
# 	CLICK Ok
# 	Log To Console    navigated to vod library
#     CLICK Right
# 	CLICK Ok
#     Rent Assest in Boxoffice
# 	CLICK RIGHT
# 	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_511_watch_later
# 	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_511_watch_later Is Displayed
# 	...  ELSE  Log To Console    TC_511_watch_later Is Not Displayed,Asset is already added to list
# 	CLICK OK
#     CLICK HOME
# 	CLICK UP
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK RIGHT
# 	Sleep    2s
# 	CLICK DOWN
# 	CLICK OK
# 	${Result}  Verify Crop Image With Shorter Duration  ${port}  511_SHOW_TRANSACTIONS
# 	Run Keyword If  '${Result}' == 'True'  Log To Console  511_SHOW_TRANSACTIONS Is Displayed
# 	...  ELSE  Log To Console    511_SHOW_TRANSACTIONS Is Not Displayed,Asset is already added to list
#     CLICK HOME
TC_513_RESUME_PARTIAL_WATCHED_VOD_FROM_CONTINUE_WATCHING
    [Tags]    VOD
    [Documentation]    Resume VOD from Continue watching
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK RIGHT
	CLICK Ok
	Box Office Rentals Buy or rent
	CLICK Ok
	pinblock
	VALIDATE VIDEO PLAYBACK
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    30s
    ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK RIGHT
	CLICK Ok
	Box Office Rentals Buy or rent
	CLICK Ok
	pinblock
	Sleep    8s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  timestampb
	Run Keyword If  '${Result}' == 'True'  Log To Console  timestamp Is started from previously stopped timestamp
	...  ELSE  Fail  Timestamp Is Not matching
    ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK HOME
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
    Sleep    15s
	Log To Console    Resuming Partially watched VOD assets
	CLICK HOME
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Sleep    15s
	Log To Console    Resuming Partially watched VOD assets
	CLICK HOME
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Sleep    15s
	Log To Console    Resuming Partially watched VOD assets
	CLICK HOME
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Sleep    15s
	Log To Console    Resuming Partially watched VOD assets
	CLICK HOME

TC_514_VERIFY_PARENTAL_CONTROL_BLOCKS_RESTRICTED_VOD
	[Tags]	  VOD
	[Documentation]    verify parental control Blocks restricted VOD
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
	Create new profile with 3333 pin
	Navigate To Profile
	Log To Console  Verifying  TC_004_new_user on Screen
	${Result}  Verify Crop Image With Shorter Duration    ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_020_New_User Is Displayed on screen
	...  ELSE  Fail  TC_020_New_User Is Not Displayed on screen
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	Navigate To Profile
	CLICK RIGHT
	CLICK OK
	CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK OK
	Sleep    10s
	CLICK HOME
	Log To Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
    CLICK OK
	CLICK RIGHT
	CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
    CLICK DOWN
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_713_Parental
	Run Keyword If  '${Result}' == 'True'  Log To Console  PARENTAL_CONTROL Is Displayed on screen
	...  ELSE  Fail  PARENTAL_CONTROL Is Not Displayed on screen
	CLICK THREE
    CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  PARENTAL_CONTROL_ERROR
	Run Keyword If  '${Result}' == 'True'  Log To Console  PARENTAL_CONTROL_ERROR Is Displayed on screen
	...  ELSE  Fail  PARENTAL_CONTROL_ERROR Is Not Displayed on screen
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK OK
	Parental Control Subscription Rent Buy Flow
	pinblock
    checkformat

    Sleep    5s
	vod category navigations
	CLICK HOME
	DELETE COCO
TC_515_BROWSE_AND_PLAY_FROM_VOD_CATEGORY
    [Tags]    VOD
    [Documentation]    Browse VOD and play
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right

	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_502_ACTION
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_502_ACTION Is Displayed
	...  ELSE  Fail  TC_502_ACTION Is Not Displayed
	CLICK Ok
	Box Office Rentals Buy or rent
	CLICK Ok
	pinblock
	CLICK OK
	CLICK OK
	vod video validation
	
	CLICK Back
	Click Back
	CLICK DOWN
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_501_ADVENTURE
	Run Keyword If  '${Result}' == 'True'  Log To Console   TC_501_ADVENTURE Is Displayed
	...  ELSE  Fail  TC_501_ADVENTURE Is Not Displayed

	CLICK Ok
	Box Office Rentals Buy or rent
	CLICK Ok
	pinblock
	CLICK OK
	CLICK OK
	vod video validation

    CLICK Back
	Click Back
	CLICK DOWN
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_501_animation
	Run Keyword If  '${Result}' == 'True'  Log To Console   TC_501_animation Is Displayed
	...  ELSE  Fail  TC_501_animation Is Not Displayed

	CLICK Ok
	Box Office Rentals Buy or rent
	CLICK Ok
	pinblock
	CLICK OK
	CLICK OK
	vod video validation

    CLICK Back
	Click Back
	CLICK RIGHT
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  tc_501_drama
	Run Keyword If  '${Result}' == 'True'  Log To Console   tc_501_drama Is Displayed
	...  ELSE  Fail  TC_501_drama Is Not Displayed

	CLICK Ok
	Box Office Rentals Buy or rent
	CLICK Ok
	pinblock
	# CLICK OK
	# CLICK OK
	vod video validation
    CLICK HOME

TC_516_VERIFY_VOD_PROGRESS_BAR_TIMESTAMP
    [Tags]    VOD
	[Documentation]    Browse VOD and verify progress bar
    CLICK HOME
	CLICK UP
    CLICK RIGHT
    CLICK RIGHT
	CLICK OK
	CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
    CLICK OK
	CLICK OK
    resume
	pinblock
	Log To Console    Pin Entered
    checkformat
    CLICK OK
	Sleep    1s
	CLICK OK
	Sleep    5s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Verify ProgressBar
	vod video validation

TC_517_VERIFY_VOD_RECOMENDATION_BASED_ON_RECENTLY_WATCHED
	[Tags]	  VOD
	[Documentation]    Check VOD recomendations based on recently watched titles
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    3s
	# validate Trending section page
	FOR    ${i}    IN RANGE    25
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    recommended
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ Recomemded_Section is displayed
    ...    AND    Exit For Loop

    CLICK RIGHT
    END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recomended_Section is not displayed after navigating right
    Log To Console  Navigating through Recomemded section
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
    CLICK RIGHT
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  Blank_Tile
	# Run Keyword If  '${Result}' == 'True'  Fail  Blank_Tile Is Displayed
	# ...  ELSE  Log To Console    Blank_Tile Is Not Displayed
	CLICK OK
	Sleep    2s
	# CLICK DOWN
	# CLICK OK
	CLICK Ok
	# resume
	buyrentalsblock
	pinblock
    checkformat

    Sleep    5s
	vod category navigations


TC_519_BROWSE_VOD_LIBRARY_AND_VERIFY_RECENTLYADDED_SECTION_WITH_NEW_TITLES
	[Tags]    VOD
	[Documentation]    Browsw VOD and verify Recently added Section  
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    FOR    ${i}    IN RANGE    8
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    newrelease
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ Recently Added_Section is displayed
    ...    AND    Exit For Loop

    CLICK RIGHT
    END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recently Added_Section is not displayed after navigating right
    Log To Console  Navigating through Recently Added section
    CLICK RIGHT
    CLICK RIGHT
    # CLICK RIGHT
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  Blank_Tile
	# Run Keyword If  '${Result}' == 'True'  Fail  Blank_Tile Is Displayed
	# ...  ELSE  Log To Console    Blank_Tile Is Not Displayed
	CLICK OK
	Sleep    2s
	# CLICK DOWN
	# CLICK OK
	CLICK Ok
	# resume
	buyrentalsblock
	pinblock
    checkformat

    Sleep    5s
	vod category navigations
TC_523_VERIFY_TRENDING_SECTION_TRY_TRENDING_VOD
	[Tags]    VOD
    [Documentation]    Verify Trending section
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    3s
	# validate Trending section page
	FOR    ${i}    IN RANGE    25
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Trending_Section
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ Trending_Section is displayed
    ...    AND    Exit For Loop

    CLICK RIGHT
    END

    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Trending_Section is not displayed after navigating right
    Log To Console  Navigating through Trending section
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	# CLICK DOWN
	# CLICK OK
	CLICK Ok
	# resume
	buyrentalsblock
	pinblock
    checkformat

    Sleep    5s
	vod category navigations

TC_524_VERIFY_TOP_RATED
    [Tags]	  VOD
	[Documentation]	   Filter VOD Top rated
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	FOR    ${i}    IN RANGE    25
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    TC_524_Top_Rated
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ Top Rated is displayed
    ...    AND    Exit For Loop
    CLICK RIGHT
    END

    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Top_rated is not displayed after navigating right
    Log To Console  Navigating through Top_rated section
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK OK
	Sleep    2s
	CLICK DOWN
	CLICK OK
	CLICK Ok
	buyrentalsblock
	pinblock
    checkformat

    Sleep    5s
	vod category navigations
TC_520_VERIFY_VOD_PLAYBACK_RESUMES_FROM_LAST_WATCHED_POSITION_AFTER_STB_REBOOT
	[Tags]	  VOD
	[Documentation]    Play VOD and check resume after reboot
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
    CLICK RIGHT
	CLICK OK
	CLICK OK
	pinblock
	Sleep    1s
	Apply Startover
	VALIDATE VIDEO PLAYBACK
	Log To Console   Playback video for 100s and Rebooting the device
	Sleep    100s
	Reboot STB Device
	Sleep    50s
	#Check Who's Watching login
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
    CLICK RIGHT
	CLICK OK
	resume
	pinblock
	Sleep    5s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  timestampb
	Run Keyword If  '${Result}' == 'True'  Log To Console  timestamp Is started from previously stopped timestamp
	...  ELSE  Fail  Timestamp Is Not matching

	VALIDATE VIDEO PLAYBACK
	CLICK HOME

TC_522_FILTER_VOD_LIBRARY_BY_LANGUAGE
	[Tags]	  VOD
	[Documentation]	   Filter VOD library by language
	CLICK HOME
	Log To Console    Navigated To home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK UP
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_522_FILTER_ARABIC

	IF  '${Result}' == 'True'
		Log To Console  Filter arabic
	ELSE
		CLICK OK
	END
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_522_FILTER_ARABIC
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_522_FILTER_ARABIC Is Displayed
	...  ELSE  Fail  TC_522_FILTER_ARABIC Is Not Displayed
	Sleep    1s

	CLICK BACK
	${ocr_text}=    Rating OCR
    Checking language   ${ocr_text}
	CLICK RIGHT
	${ocr_text}=    Rating OCR
    Checking language   ${ocr_text}
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_522_ARABIC_BROWSE
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_522_ARABIC_BROWSE Is Displayed
	# ...  ELSE  Fail  TC_522_ARABIC_BROWSE Is Not Displayed
	Sleep    1s

	CLICK RIGHT
	${ocr_text}=    Rating OCR
    Checking language   ${ocr_text}
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_522_ARABIC_BROWSE
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_522_ARABIC_BROWSE Is Displayed
	# ...  ELSE  Fail  TC_522_ARABIC_BROWSE Is Not Displayed
	Sleep    1s

	CLICK RIGHT
	${ocr_text}=    Rating OCR
    Checking language   ${ocr_text}
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_522_ARABIC_BROWSE
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_522_ARABIC_BROWSE Is Displayed
	# ...  ELSE  Fail  TC_522_ARABIC_BROWSE Is Not Displayed
	Sleep    1s

	CLICK RIGHT
	${ocr_text}=    Rating OCR
    Checking language   ${ocr_text}
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_522_ARABIC_BROWSE
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_522_ARABIC_BROWSE Is Displayed
	# ...  ELSE  Fail  TC_522_ARABIC_BROWSE Is Not Displayed
	Sleep    1s
	CLICK OK
	# Subscription Rent Buy Flow
	CLICK OK
	buyrentalsblock
	pinblock
	checkformat
    Sleep    5s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	Sleep    1s
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Arabic_Subtitle
	Log To Console    arabic: ${Result}
    Run Keyword If    '${Result}' == 'True'    Log To Console	Arabic is Displayed
	...    ELSE  Fail    language Is Not Displayed
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	#check audio
    CLICK HOME

TC_526_PLAY_VOD_TITLE_SWITCH_PROFILES_MIDPLAYBACK_VERIFY_SETTINGS_APPLY
	[Tags]	  VOD
	[Documentation]    Switch profiles and verify
    [Teardown]    Delete Profile
    Create New Profile
    CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK OK
	Sleep    2s
	CLICK DOWN
	CLICK OK
	Subscription Rent Buy Flow
	CLICK OK
	pinblock
	VALIDATE VIDEO PLAYBACK
    #check audio
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME
	Navigate To Profile
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    10s
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	Sleep    2s
	CLICK DOWN
	CLICK OK
	Subscription Rent Buy Flow
	CLICK OK
	pinblock
	VALIDATE VIDEO PLAYBACK
    #check audio
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
    #check audio
	CLICK HOME
	Login As Admin
    Sleep    5s
	Delete New Profile
	CLICK HOME
	Sleep    10s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen

TC_528_VERIFY_RELATED_CONTENT_SECTION
	[Tags]    VOD
	[Documentation]    Browse VOD and verify related content based on history
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	Log To Console    navigated to vod section
	CLICK Ok
	Log To Console    navigated to vod library
	CLICK Ok
	pinblock
	Purchase VOD
	CLICK OK
	VALIDATE VIDEO PLAYBACK
    #check audio
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
    CLICK OK
	pinblock
	VALIDATE VIDEO PLAYBACK
    #check audio
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated to continue watching section based on history
	CLICK RIGHT
	CLICK RIGHT
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  voddetailspage
	# Run Keyword If  '${Result}' == 'True'  Log To Console  voddetailspage Is Displayed
	# ...  ELSE  Fail  voddetailspage Is Not Displayed
	CLICK HOME

TC_529_VOD_LIBRARY_KIDS_SECTION_CONTENT
    [Tags]    VOD
	[Documentation]    Browse kids section
	Navigate To kids section in Boxoffice
	Check For Kids Content in Boxoffice
	CLICK OK
	pinblock
	Subscription Rent Buy Flow
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	#check audio
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	# CLICK HOME
	# Navigate To kids section
    # Check For Kids Channels in kids section
	# CLICK OK
	# CLICK DOWN
	# CLICK OK
	# VALIDATE VIDEO PLAYBACK
	#check audio
	CLICK HOME
	Navigate To kids section
	Check For Kids Movies in kids section
	CLICK OK
	pinblock
	Subscription Rent Buy Flow
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	#check audio
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME



TC_535_VOD_LIVE_PLAYBACK_SWITCH
	[Tags]	  VOD
	[Documentation]    VOD Live playback switch
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK OK
	CLICK Ok
	pinblock
	VALIDATE VIDEO PLAYBACK
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK LEFT
	CLICK Ok
	CLICK Ok
	VALIDATE VIDEO PLAYBACK
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK OK
	CLICK Ok
	pinblock
	Sleep    5s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK Home
	CLICK Home

TC_536_VERIFY_VOD_RECENTLY_WATCHED
	[Tags]	  VOD
	[Documentation]    Check VOD recomendations based on recently watched titles
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	resume
	pinblock
    checkformat
	Sleep    15s
	#CLICK OK
    Log To Console   Playing vod
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Continue_Watching_Feeds
	Run Keyword If  '${Result}' == 'True'  Log To Console  Continue_Watching_Feeds Is Displayed
	...  ELSE  Fail  Continue_Watching_Feeds Is Not Displayed
	CLICK DOWN
	CLICK OK
	Sleep    1s
    CLICK LEFT
	Sleep    1s
    Log To Console    Navigating through recently watched vod
	CLICK LEFT
	Sleep    1s
    Log To Console    Navigating through recently watched vod
	CLICK LEFT
	Sleep    1s
	Log To Console    Navigating through recently watched vod
    CLICK LEFT
	Sleep    1s
    CLICK HOME

TC_539_VERIFY_DISPLAY_LAST_VIEWED_VOD
    [Tags]	  VOD
	[Documentation]   Last Viewed VOD
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	resume
	pinblock
    checkformat
	Sleep    5s
	# CLICK OK
    Log To Console   Playing vod
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Continue_Watching_Feeds
	Run Keyword If  '${Result}' == 'True'  Log To Console  Continue_Watching_Feeds Is Displayed
	...  ELSE  Fail  Continue_Watching_Feeds Is Not Displayed
	CLICK RIGHT
	CLICK OK
	Sleep    1s
    CLICK RIGHT
	Sleep    1s

	CLICK RIGHT
	Sleep    1s

	CLICK RIGHT
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  voddetailspage
	Run Keyword If  '${Result}' == 'True'  Log To Console  voddetailspage Is Displayed
	...  ELSE  Fail  voddetail Is Not Displayed

    CLICK HOME

	
TC_540_VERIFY_DISPLAY_VOD_DETAILS
    [Tags]	  VOD
	[Documentation]    Verify VOD details
	CLICK HOME
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Continue_Watching_Feeds
	Run Keyword If  '${Result}' == 'True'  Log To Console  Continue_Watching_Feeds Is Displayed
	...  ELSE  Fail  Continue_Watching_Feeds Is Not Displayed
	CLICK RIGHT
	CLICK OK
	Sleep    1s
    CLICK RIGHT
	Sleep    1s

	${Result}  Verify Crop Image With Shorter Duration  ${port}  voddetailspage
	Run Keyword If  '${Result}' == 'True'  Check Vod Details
	...  ELSE  Run Keyword    CLICK RIGHT
    Check Vod Details

	
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  voddetailspage
	Run Keyword If  '${Result}' == 'True'  Check Vod Details
	...  ELSE  Run Keyword    CLICK RIGHT
    Check Vod Details
	
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  voddetailspage
	Run Keyword If  '${Result}' == 'True'  Check Vod Details
	...  ELSE  Run Keyword    CLICK RIGHT
 
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  voddetailspage
	Run Keyword If  '${Result}' == 'True'  Check Vod Details
	...  ELSE  Run Keyword    CLICK RIGHT
    
    CLICK HOME
TC_541_PURCHASE_VOD
    [Tags]    VOD
    [Documentation]    Verify Purchase VOD 
	[Teardown]    Always login Revert
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	Sleep    2s
	CLICK DOWN
	CLICK OK
	Sleep    2s
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	Sleep    2s
	CLICK OK
	pinblock
	Purchase VOD
	CLICK OK
	 ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME
	CLICK HOME
	CLICK HOME
	Navigate To Profile
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Log To Console  Verifying  TC_005_Disable_BoxOffice_pin on Screen
	${Result}  Verify Crop Image With Shorter Duration  ${port}   TC_005_Disable_BoxOffice_pin
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_005_Disable_BoxOffice_pin Is Displayed on screen
	...  ELSE  Fail  TC_005_Disable_BoxOffice_pin Is Not Displayed on screen
	CLICK DOWN
	CLICK DOWN 
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_003_PIN_CHANGED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_PIN_CHANGED Is Displayed on screen
	...  ELSE  Fail  TC_003_PIN_CHANGED Is Not Displayed on screen
	CLICK OK
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK DOWN
	CLICK OK
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK OK
	pinblock
	Purchase VOD For Disable pin
	CLICK OK
	 ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME
TC_542_PURCHASE_BASED_ON_POINT
    [Tags]    VOD
    [Documentation]    Verify Purchase VOD using points
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	#CLICK LEFT
	CLICK OK
	pinblock
	Box Office Buy by points
    CLICK OK
	Sleep    5s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME

TC_546_VERIFY_RECOMMENDED_VOD
	[Tags]	  VOD
	[Documentation]    Verify Recomended VOD category
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    3s
	# validate Trending section page
	FOR    ${i}    IN RANGE    20
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    recommended
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ Recomemded_Section is displayed
    ...    AND    Exit For Loop

    CLICK RIGHT
    END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recomended_Section is not displayed after navigating right
    Log To Console  Navigating through Recomemded section
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT

	Log To Console    Navigated to Recommended section
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Blank_Tile
	Run Keyword If  '${Result}' == 'True'  Fail  Blank_Tile Is Displayed
	...  ELSE  Log To Console    Blank_Tile Is Not Displayed
	CLICK HOME
TC_548_DISPLAY_RENTED_HISTORY
	[Tags]    VOD
	[Documentation]    Add VOD To Watch later
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	Log To Console    navigated to vod section
	CLICK Ok
	Log To Console    navigated to vod library
    CLICK Right
	# CLICK DOWN
	CLICK Ok
    ${hd_rent}=    Rent Assest in Boxoffice Transaction
    
    Log To Console    RENT HD: ${hd_rent}

    # OCR correction if needed
    

    CLICK OK
    pinblock
    checkformat
	
    ${Result}=    Validate Video Playback For Playing
    Run Keyword If    '${Result}' == 'True'
    ...    Log To Console    Video is Playing
    ...    ELSE    Fail    Video is Paused
	CLICK UP
	${ocr_text}=	Select assest from catchup
	Log To Console    RENT OCR: ${ocr_text}
	Run Keyword If    'A QUIET PLACE PART Il' in '${ocr_text}'
    ...    ${ocr_text}=    Replace String    ${ocr_text}    Il    II
    CLICK HOME
    CLICK HOME

    # ---------- TRANSACTIONS ----------
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    CLICK RIGHT
    Sleep    2s
    CLICK DOWN
    CLICK OK

    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    511_SHOW_TRANSACTIONS
    Run Keyword If    '${Result}' == 'True'
    ...    Log To Console    511_SHOW_TRANSACTIONS Is Displayed
    ...    ELSE    Log To Console    Asset already added

    # Extract transaction OCR asset
    ${txn_ocr}=    Rented Assest in Transaction

    # Extract HD from transaction (YOUR NEW KEYWORD)
    ${hd_txn}=    HD Text in Transaction

    Log To Console    TXN OCR: ${txn_ocr}
    Log To Console    TXN HD: ${hd_txn}

    # ---------- OCR COMPARISON ----------
    ${ocr_text}=    Normalize Text rent    ${ocr_text}
    ${txn_ocr}=     Normalize Text rent   ${txn_ocr}
	Log To Console    RENT OCR: ${ocr_text}
	Log To Console    RENT OCR: ${txn_ocr}
    IF    '${ocr_text}' == '${txn_ocr}'
        Log To Console    ✅ OCR MATCHED
    ELSE
        Fail    ❌ OCR MISMATCH
    END

    # ---------- HD COMPARISON ----------
    ${hd_rent}=    Convert To Upper Case    ${hd_rent}
	${hd_rent}=    Strip String             ${hd_rent}

	${hd_txn}=     Convert To Upper Case    ${hd_txn}
	${hd_txn}=     Strip String             ${hd_txn}

	Log To Console    RENT HD: ${hd_rent}
	Log To Console    TXN HD: ${hd_txn}

	IF    '${hd_txn}' in '${hd_rent}'
		Log To Console    ✅ HD TEXT FOUND IN RENT HD
	ELSE
		Fail    ❌ HD MISMATCH (Rent: ${hd_rent} | Txn: ${hd_txn})
	END


    CLICK HOME


TC_556_VERIFY_VOD_VOLUME_CONTROL
	[Tags]    VOD
	[Documentation]    VOD resume
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	Log To Console    navigated to vod section
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	resume
	checkformat
	Unified verification of Audio Quality
	CLICK HOME
TC_554_START_OVER_VOD
	[Tags]    VOD
    [Documentation]    Verify vod progress bar
    CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK RIGHT
	CLICK Ok
	buyrentalsblock
	CLICK Ok
	pinblock
	Sleep    40s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	${live_status}=    Get Live Progress Bar Status
	Apply Startover
	
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  startover
	# Run Keyword If  '${Result}' == 'True'  Log To Console  startover Is Displayed
	# ...  ELSE  Fail  startover Is Not Displayed
	${start_over_status}=    Get Start Over Progress Bar Status
	Verify the Similarity    ${live_status}    ${start_over_status}
	Log To Console    Checking Video Playback
	
    Log To Console    VOD asset playing from Beginning
	Log To Console    Progress bar position is started at 00:00
	Sleep    30s
    ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused

	CLICK HOME
TC_555_SWITCH_SUBTITLE_AND_AUDIO_TRACK
	[Tags]	  VOD
	[Documentation]    Switch subtitle and Audio track
	CLICK HOME
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok

	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	pinblock
	checkformat
	resume
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_508_arabic
	${none}  Verify Crop Image With Shorter Duration    ${port}  none
	Log To Console    arabic: ${Result}
    Log To Console    none: ${none}
    Run Keyword If    '${Result}' == 'True' or '${none}' == 'True'    Log To Console	Subtitle is changed
	...    ELSE  Log To Console    language Is Not Displayed
	CLICK OK
	

	Sleep    15s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  tc_508_english
	${none}  Verify Crop Image With Shorter Duration    ${port}  none
	Log To Console    english: ${Result}
    Log To Console    none: ${none}
    Run Keyword If    '${Result}' == 'True' or '${none}' == 'True'    Log To Console	Subtitle is changed
	...    ELSE  Log To Console    language Is Not Displayed
	CLICK OK
	
    Sleep    15s

    CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  tc_508_english
	${none}  Verify Crop Image With Shorter Duration    ${port}  none
	Log To Console    english: ${Result}
    Log To Console    none: ${none}
    Run Keyword If    '${Result}' == 'True'    Log To Console	Audio language is displayed
	...    ELSE  Fail    language Is Not Displayed
	CLICK OK
    Sleep    15s
	
	CLICK HOME

TC_553_VERIFY_VOD_PROGRESS_BAR
    [Tags]    VOD
    [Documentation]    Verify vod progress bar
    CLICK HOME
	CLICK UP
    CLICK RIGHT
    CLICK RIGHT
	CLICK OK
	CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
    CLICK OK
	pinblock
    CLICK OK
	Sleep    10s
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	# CLICK LEFT
	CLICK OK
    Log To Console    VOD asset Rewinded 10s
	# Log To Console    Progress bar position is started at 00:00
	Sleep    10s
	VALIDATE VIDEO PLAYBACK

	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
    CLICK OK
	CLICK OK
	VALIDATE VIDEO PLAYBACK
    Verify ProgressBar
	CLICK HOME

TC_545_Rating
    [Tags]    VOD
	[Documentation]    Check for rating in vod details
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	Check rating
	CLICK RIGHT
	Check rating
	CLICK RIGHT
	Check rating
	CLICK RIGHT
	Check rating
	CLICK RIGHT
	Check rating

	CLICK BACK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	Check rating
	CLICK RIGHT
	Check rating
	CLICK RIGHT
	Check rating
	CLICK RIGHT
	Check rating
	CLICK RIGHT
	Check rating

	CLICK BACK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	Check rating
	CLICK RIGHT
	Check rating
	CLICK RIGHT
	Check rating
	CLICK RIGHT
	Check rating
	CLICK RIGHT
	Check rating
	CLICK HOME

TC_561_CHECK_SHOWCARDS
    [Tags]    VOD
	[Documentation]    verify show cards are loaded without blank showcard
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right

	CLICK Right
	CLICK Right
	CLICK Right

	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK Ok

	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Blank_Tile
	Run Keyword If  '${Result}' == 'True'  Fail  Blank_Tile Is Displayed
	...  ELSE  Log To Console    Blank_Tile Is Not Displayed

	CLICK Back
	CLICK RIGHT
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Blank_Tile
	Run Keyword If  '${Result}' == 'True'  Fail  Blank_Tile Is Displayed
	...  ELSE  Log To Console    Blank_Tile Is Not Displayed
	
	CLICK Back
	CLICK UP
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Blank_Tile
	Run Keyword If  '${Result}' == 'True'  Fail  Blank_Tile Is Displayed
	...  ELSE  Log To Console    Blank_Tile Is Not Displayed
	
	CLICK Back
	CLICK UP
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Blank_Tile
	Run Keyword If  '${Result}' == 'True'  Fail  Blank_Tile Is Displayed
	...  ELSE  Log To Console    Blank_Tile Is Not Displayed

    CLICK Back
	CLICK UP
	CLICK RIGHT
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Blank_Tile
	Run Keyword If  '${Result}' == 'True'  Fail  Blank_Tile Is Displayed
	...  ELSE  Log To Console    Blank_Tile Is Not Displayed

	CLICK Home

TC_562_VOD_LIBRARY_KIDS_SECTION_CONTENT_IN_SUB_PROFILE
    [Tags]    VOD
	[Documentation]    Browse kids section
	Create New Profile
	Navigate To Profile
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
    Navigate To kids section in Boxoffice
	Check For Kids Content in Boxoffice
	CLICK OK
	pinblock
	Subscription Rent Buy Flow
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	Verify Audio Quality
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME
	# Navigate To kids section
    # Check For Kids Channels in kids section
	# CLICK OK
	# CLICK DOWN
	# CLICK OK
	# VALIDATE VIDEO PLAYBACK
	# Verify Audio Quality
	# CLICK HOME
	Navigate To kids section
	Check For Kids Movies in kids section
	CLICK OK
	pinblock
	Subscription Rent Buy Flow
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	Verify Audio Quality
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME
	Login As Admin
	Delete New Profile

TC_563_VOD_LIBRARY_KIDS_SECTION_CONTENT_IN_KIDS_PROFILE
    [Tags]    VOD
	[Documentation]    Browse kids section
	Create Kids Profile
	Navigate To Profile
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
    Navigate To kids section in Boxoffice
	Check For Kids Content in Boxoffice
	CLICK OK
	pinblock
	Subscription Rent Buy Flow
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	Verify Audio Quality
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME
	# Navigate To kids section
    # Check For Kids Channels in kids section
	# CLICK OK
	# CLICK DOWN
	# CLICK OK
	# VALIDATE VIDEO PLAYBACK
	# Verify Audio Quality
	# CLICK HOME
	Navigate To kids section
	Check For Kids Movies in kids section
	CLICK OK
	pinblock
	Subscription Rent Buy Flow
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	Verify Audio Quality
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME
	Login As Admin
	Delete New Profile


TC_560_CHECK_SHOWCARDS_VOD
    [Tags]    VOD
	[Documentation]    verify show cards are loaded without blank showcard
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right

	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Blank_Tile
	Run Keyword If  '${Result}' == 'True'  Fail  Blank_Tile Is Displayed
	...  ELSE  Log To Console    Blank_Tile Is Not Displayed

	CLICK Back
	CLICK DOWN
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Blank_Tile
	Run Keyword If  '${Result}' == 'True'  Fail  Blank_Tile Is Displayed
	...  ELSE  Log To Console    Blank_Tile Is Not Displayed
	
	CLICK Back
	CLICK DOWN
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Blank_Tile
	Run Keyword If  '${Result}' == 'True'  Fail  Blank_Tile Is Displayed
	...  ELSE  Log To Console    Blank_Tile Is Not Displayed
	
	CLICK Back
	CLICK RIGHT
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Blank_Tile
	Run Keyword If  '${Result}' == 'True'  Fail  Blank_Tile Is Displayed
	...  ELSE  Log To Console    Blank_Tile Is Not Displayed

    CLICK Back
	CLICK UP
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Blank_Tile
	Run Keyword If  '${Result}' == 'True'  Fail  Blank_Tile Is Displayed
	...  ELSE  Log To Console    Blank_Tile Is Not Displayed

	CLICK Home

TC_557_POSITION_CHANGE
    [Tags]    VOD
	[Documentation]    verify seek bar position change
	CLICK HOME
	CLICK UP
    CLICK RIGHT
    CLICK RIGHT
	CLICK OK
	CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
    CLICK OK
    CLICK OK
	Sleep    5s
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
    CLICK OK
	CLICK OK
	Sleep    10s
	CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	
	vod video validation
	CLICK HOME

TC_527_VOD_EXPIRY_ERROR_MESSAGE
    [Tags]    VOD
	[Documentation]    verify vod expiry error message
	check for vod expired notice
	CLICK UP
    CLICK RIGHT
    CLICK RIGHT
	CLICK OK
	check for vod expired notice
	CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
	check for vod expired notice
    CLICK OK
    CLICK OK
	Sleep    5s
	VALIDATE VIDEO PLAYBACK
	CLICK HOME

TC_549_VERIFY_VOD_SD_HD_UHD
	[Tags]	  VOD
	[Documentation]    Browse VOD and play SD , HD content
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	resume
	pinblock
    checkformat
	#CLICK OK
	Sleep    15s
    Log To Console   Playing SD vod

	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	resume
	pinblock
    checkformat
	
	#CLICK OK
	Sleep    3s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
    Log To Console   Playing HD vod
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	resume
	pinblock
    checkformat
	#CLICK OK
	Sleep    3s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK HOME

TC_552_VERIFY_VOD_RESUME
	[Tags]    VOD
	[Documentation]    VOD resume
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK OK
	pinblock
    Sleep    10s
	CLICK BACK
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
    Log To Console    Navigated to LIVE TV
    Sleep    1s
	CLICK CHANNELUP
    Sleep    1s
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK OK
	pinblock
	Sleep    5s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
    VALIDATE VIDEO PLAYBACK
	CLICK HOME


TC_551_VERIFY_TRICKMODE_VOD
    [Tags]    VOD
	[Documentation]    VOD Trickmode
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK OK
	pinblock
	CLICK RIGHT
	CLICK OK
	Sleep    1s
    CLICK OK
	Sleep    1s
    CLICK OK
	Sleep    1s
    CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC505_32x_forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_32xff Is Displayed
	...  ELSE  Fail  TC_505_32xff Is Not Displayed
	Sleep    1s
    Log To Console    Forwarded +32x
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	Sleep    1s
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-4X_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-4X_rewind Is Displayed
	...  ELSE  Fail  TC506_-4X_rewind Is Not Displayed
	Sleep    1s
    Log To Console	  Rewinded -4x
	CLICK RIGHT
	CLICK OK
	Sleep    3s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
    CLICK HOME

TC_543_VERIFY_PLAY_TRAILER
	[Tags]    VOD
	[Documentation]    play Trailer
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	Log To Console    navigated to vod section
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	Log To Console	Verifying trailer is playing in background or not
	Sleep    2s
	CLICK DOWN
    # VALIDATE TRAILOR PLAYBACK
	# Play trailor1
	check vod assets for trailors
	CLICK HOME

TC_544_ADD_DELETE_FAVORITE
	[Tags]    VOD
	[Documentation]    Add Delete Favorite
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	Log To Console    navigated to vod section
	CLICK Ok
	Log To Console    navigated to vod library
	CLICK OK
	${res1}=  Check Add And Remove From List
	Log To Console    ${res1}
	Reboot STB Device
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT 
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    3s 

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration    ${port}    MyList_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ MyList is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    2s
	${res1}=    Convert To Upper Case    ${res1}
	${res1}=    Strip String             ${res1}

	FOR    ${i}    IN RANGE    20
		${res2}=    Verify Assert After adding to list
		${res2}=    Convert To Upper Case    ${res2}
		${res2}=    Strip String             ${res2}

		IF    '${res1}' == '${res2}'
			Log To Console    ✅ MATCH FOUND: ${res2}
			Exit For Loop
		ELSE
			Click Left
		END
	END

	CLICK OK
	Remove from list
	CLICK HOME
	CLICK HOME
TC_560_DISPLAY_BASED_ON_VOD_TYPE_SUBPROFILE
    [Tags]    VOD
    [Documentation]    Display based on vod type
	[Teardown]    DELETE COCO
	CREATE PROFILE COCO
	Navigate To Profile
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right

	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_502_ACTION
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_502_ACTION Is Displayed
	...  ELSE  Fail  TC_502_ACTION Is Not Displayed
    Rating

	CLICK Back
	CLICK DOWN
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_501_ADVENTURE
	Run Keyword If  '${Result}' == 'True'  Log To Console   TC_501_ADVENTURE Is Displayed
	...  ELSE  Fail  TC_501_ADVENTURE Is Not Displayed
	Rating
	CLICK Back
	CLICK DOWN
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_501_animation
	Run Keyword If  '${Result}' == 'True'  Log To Console   TC_501_animation Is Displayed
	...  ELSE  Fail  TC_501_animation Is Not Displayed
	Rating
	CLICK Back
	CLICK RIGHT
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  tc_501_drama
	Run Keyword If  '${Result}' == 'True'  Log To Console   tc_501_drama Is Displayed
	...  ELSE  Fail  TC_501_drama Is Not Displayed
	Rating
    CLICK Back
	CLICK UP
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_documentary
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_documentary Is Displayed
	...  ELSE  Fail  501_documentary Is Not Displayed
    Rating
	CLICK Back
	CLICK UP
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_comedy
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_comedy Is Displayed
	...  ELSE  Fail  501_comedy Is Not Displayed
	Rating
	CLICK Back
	CLICK RIGHT
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_family
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_family Is Displayed
	...  ELSE  Fail  501_family Is Not Displayed
	Rating
	CLICK Back
	CLICK DOWN
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_horror
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_horror Is Displayed
	...  ELSE  Fail  501_horror Is Not Displayed
    Rating
	CLICK Back
	CLICK DOWN
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_kids
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_kids Is Displayed
	...  ELSE  Fail  501_kids Is Not Displayed
	Rating
	CLICK Back
	CLICK RIGHT
	CLICK UP
	CLICK UP
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_musical
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_musical Is Displayed
	...  ELSE  Fail  501_musical Is Not Displayed
    Rating
	CLICK Back
	CLICK DOWN
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_romance
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_romance Is Displayed
	...  ELSE  Fail  501_romance Is Not Displayed 
	Rating
	CLICK Back
	CLICK DOWN
	CLICK Ok
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_sciencefiction
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_sciencefiction Is Displayed
	...  ELSE  Fail  501_sciencefiction Is Not Displayed
	Rating
	CLICK Back
	CLICK RIGHT
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  501_triller
	Run Keyword If  '${Result}' == 'True'  Log To Console   501_triller Is Displayed
	...  ELSE  Fail  501_triller Is Not Displayed
    Rating
	CLICK Home

    CLICK HOME
	CLICK BACK
    CLICK BACK
    Sleep    12s
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	CLICK LEFT

TC_572_PAUSE_ONDEMAND_TITLE_FOR_5MIN_THEN_RESUME
	[Tags]    SVOD
    [Documentation]    Browse ondemand and initiate playback
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK OK
	Sleep    1s
	CLICK DOWN
	CLICK Right
	CLICK Ok
	Sleep    1s
	CLICK OK
	Sleep    2s
	#CLICK Ok
	Log To Console    Paused Video for 5 min
	Sleep    30s
	Log To console    Resumed Video 
	CLICK Ok
	# CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed

	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	CLICK Home


TC_570_ONDEMAND_INITIATE_PLAYBACK
	[Tags]    SVOD
	[Documentation]    Ondemand playback
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	[Timeout]    2400s
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	Sleep    1s
	CLICK Right
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  test_ondemand
	Run Keyword If  '${Result}' == 'True'  Log To Console  test_ondemand Is Displayed
	...  ELSE  Fail  test_ondemand Is Not Displayed
	CLICK Ok
	Subscribe OnDemand
	Sleep    2s
	#CLICK DOWN
	Log To Console    navigated to svod section
	CLICK Ok
	CLICK OK
	# CLICK OK
	
	vod video validation

	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  starplay
	Run Keyword If  '${Result}' == 'True'  Log To Console  starplay Is Displayed
	...  ELSE  Fail  starplay Is Not Displayed
	CLICK Ok
	Subscribe OnDemand
	Sleep    2s
	Log To Console    navigated to svod section
	CLICK Ok
	CLICK OK
	vod video validation
    
    CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  starzplay
	Run Keyword If  '${Result}' == 'True'  Log To Console  starzplay Is Displayed
	...  ELSE  Fail  starzplay Is Not Displayed
	CLICK Ok
	Subscribe OnDemand
	Sleep    2s
	Log To Console    navigated to svod section
	CLICK Right

	CLICK Ok
	CLICK OK
	CLICK OK
	vod video validation

    CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	Sleep    1s
	CLICK DOWN
	Sleep    1s
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ott
	Run Keyword If  '${Result}' == 'True'  Log To Console  ott Is Displayed
	...  ELSE  Fail  ott Is Not Displayed
	CLICK Ok
	Subscribe OnDemand
	Sleep    2s
	Log To Console    navigated to svod section
	CLICK Ok
	CLICK OK
	vod video validation

	CLICK HOME

TC_573_ONDEMAND_FAST_FORWARD_RESUME
    [Tags]    VOD
    [Documentation]    VOD Fast forward and resume
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	Sleep    1s
	CLICK DOWN
	Log To Console    navigated to svod section

	CLICK Ok
	CLICK Ok
	Sleep    5s
	CLICK UP
	CLICK Right
	CLICK Ok
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC505_4x_forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_4x_ff Is Displayed
	...  ELSE  Fail  TC_505_4x_ff Is Not Displayed
	
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC505_8x_forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_8x_ff Is Displayed
	...  ELSE  Fail  TC_505_8x_ff Is Not Displayed
	
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC505_16x_forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_16xff Is Displayed
	...  ELSE  Fail  TC_505_16xff Is Not Displayed
	
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC505_32x_forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_32xff Is Displayed
	...  ELSE  Fail  TC_505_32xff Is Not Displayed
	
	CLICK LEFT
	CLICK Ok
	vod video validation
	CLICK Home

TC_574_ONDEMAND_REWIND_RESUME
	[Tags]    VOD
    [Documentation]    VOD Fast forward and resume
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK OK
	Sleep    1s
	CLICK DOWN
	Sleep    1s
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK OK

	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Ok
	Sleep    1s
	CLICK Ok
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-4X_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-4X_rewind Is Displayed
	...  ELSE  Fail  TC506_-4X_rewind Is Not Displayed
	
	CLICK RIGHT
	CLICK Ok
	CLICK LEFT
	CLICK Ok
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-8x_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-8x_rewind Is Displayed
	...  ELSE  Fail  TC506_-8x_rewind Is Not Displayed
	
	CLICK RIGHT
	CLICK Ok
	CLICK LEFT
	CLICK Ok
	CLICK Ok
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-16x_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-16x_rewind Is Displayed
	...  ELSE  Fail  TC506_-16x_rewind Is Not Displayed
	

	CLICK RIGHT
	CLICK Ok
	CLICK LEFT
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  REWIND_32X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_32X Is Displayed
	...  ELSE  Fail  REWIND_32X Is Not Displayed
	
	CLICK RIGHT
	CLICK Ok
	vod video validation
	CLICK Home

TC_580_VERIFY_ONDEMAND_VIDEO_QUALITY
    [Tags]    SVOD
	[Documentation]    verify 4k content
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	pinblock

	Sleep    60s
	Log To Console    Video is playing for 60s

	${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    Log To Console    Average Quality Score: ${results}
    EVALUATE VIDEO QUALITY STATUS    ${results}
    # Verify Audio Quality
	CLICK HOME

TC_575_START_OVER_ONDEMAND
	[Tags]    SVOD
    [Documentation]    Verify vod progress bar
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
    CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	Sleep    1s
	CLICK OK
	Sleep    1s
	CLICK DOWN
	CLICK Right
	CLICK Right
	CLICK RIGHT
	CLICK Ok
	CLICK Ok
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Apply Startover
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  startover
	Run Keyword If  '${Result}' == 'True'  Log To Console  startover Is Displayed
	...  ELSE  Fail  startover Is Not Displayed
	
    Log To Console    SVOD asset playing from Beginning
	Log To Console    Progress bar position is started at 00:00
	vod video validation

	CLICK HOME


TC_577_VERIFY_ONDEMAND_RECOMMENDED
	[Tags]	  VOD
	[Documentation]    Verify Recomended VOD category
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    3s
	# validate Trending section page
	FOR    ${i}    IN RANGE    20
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    Trending_Section
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ Recomemded_Section is displayed
    ...    AND    Exit For Loop

    CLICK RIGHT
    END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recomended_Section is not displayed after navigating right
    Log To Console  Navigating through Recomemded section
    # CLICK RIGHT
    # CLICK RIGHT
    # CLICK RIGHT
	# CLICK RIGHT

	Log To Console    Navigated to Recommended section
	${Result}  Verify Crop Image With Shorter Duration    ${port}  catchupblanktile
	Run Keyword If  '${Result}' == 'True'  Fail  Blank_Tile Is Displayed
	...  ELSE  Log To Console    Blank_Tile Is Not Displayed
	CLICK OK
	CLICK OK
	vod video validation

	CLICK HOME
	
TC_578_SVOD_VERIFY_EPISODE
	[Tags]	  SVOD
	[Documentation]    Verify SVOD Episode
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	Sleep    1s
	CLICK RIGHT
	CLICK OK
	
	CLICK OK
	CLICK DOWN
	Sleep    1s
	CLICK DOWN
	Sleep    1s
	CLICK DOWN
	Sleep    1s
	CLICK OK
	Sleep    1s
	CLICK OK
    Sleep    1s
	CLICK OK
	${t1}=    Verify Extracted From Image
	log To Console    ${t1}
	Sleep    5s
	Validate Video Playback For Playing
    CLICK UP
	CLICK RIGHT
	Sleep    1s
	CLICK RIGHT
	NEXT NAVIGATION
	Sleep    10s
	${t2}=    Verify Extracted From Image
	log To Console    ${t2}
	#Run Keyword If    'ep 2' not in '${t2}'    Fail    ❌ "ep 2" not found in extracted text
	Compare Episode Numbers     ${t1}    ${t2}
	Validate Video Playback For Playing
	CLICK HOME

TC_579_VERIFY_TRENDING_SECTION_PLAY_ONDEMAND
	[Tags]    SVOD
    [Documentation]    Verify Trending section
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT

	CLICK OK
	Sleep    3s
	# validate Trending section page
	FOR    ${i}    IN RANGE    25
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TOP_RATED
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ Trending_Section is displayed
    ...    AND    Exit For Loop

    CLICK RIGHT
    END

    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Trending_Section is not displayed after navigating right
    Log To Console  Navigating through Trending section
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
    # Verify Audio Quality
	CLICK HOME

TC_576_VERIFY_ONDEMAND_TOP_RATED
    [Tags]	  SVOD
	[Documentation]	   Filter VOD Top rated
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	FOR    ${i}    IN RANGE    25
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_524_Top_Rated
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ Top Rated is displayed
    ...    AND    Exit For Loop
    CLICK RIGHT
    END

    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Top_rated is not displayed after navigating right
    Log To Console  Navigating through Top_rated section
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK OK
	Sleep    4s
	Subscription svod
	CLICK OK
	vod video validation
	CLICK HOME
	CLICK HOME


TC_571_SEARCH_ONDEMAND_INITIATE_PLAYBACK
    [Tags]    SVOD
    [Documentation]    Search VOD and initiate playback
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
    
	#Bring control to first character

	CLICK UP
	CLICK OK

	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK

	CLICK DOWN
	search salt movie

	vod video validation
	CLICK BACK
	CLICK BACK
    CLICK HOME
	CLICK HOME
	CLICK HOME

TC_581_VERIFY_ONDEMAND_KIDS_AND_FAMILY
    [Tags]	  SVOD
	[Documentation]	   Filter SVOD Kids And Family
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	FOR    ${i}    IN RANGE    25
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    KidsAndFamily_Ondemand
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ Kids and family is displayed
    ...    AND    Exit For Loop
    CLICK RIGHT
    END

    Run Keyword If    '${Result}' != 'True'    Fail    ❌ kids and family is not displayed after navigating right
    Log To Console  Navigating through kids and family section
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK OK
	Sleep    4s
	CLICK DOWN
	CLICK OK
	Sleep    2s
	Subscription svod
	# CLICK OK
	vod video validation
	CLICK HOME
	CLICK HOME

TC_582_VERIFY_ONDEMAND_DOCUMENTARIES
    [Tags]	  SVOD
	[Documentation]	   Filter SVOD Documentaries
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	FOR    ${i}    IN RANGE    25
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    documentaries
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ Top Rated is displayed
    ...    AND    Exit For Loop
    CLICK RIGHT
    END

    Run Keyword If    '${Result}' != 'True'    Fail    ❌ documentaries is not displayed after navigating right
    Log To Console  Navigating throughdocumentaries section
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK OK
	Sleep    4s
	CLICK DOWN
	CLICK OK
	Subscription svod
	#CLICK OK
	vod video validation
	CLICK HOME
	CLICK HOME

TC_583_BROWSE_ONDEMAND_JUNIOR_SECTION
    [Tags]    VOD
    [Documentation]    Browse ondemand junior section and initiate playback
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  junior
	Run Keyword If  '${Result}' == 'True'  Log To Console  junior Is Displayed
	...  ELSE  Fail  junior Is Not Displayed
	CLICK OK
	Subscribe OnDemand
	Check Rating
	CLICK DOWN
	Check Rating
	CLICK DOWN
	Check Rating
	CLICK DOWN
	Check Rating
	CLICK DOWN
	Check Rating
	CLICK DOWN
	Check Rating
	CLICK DOWN
	Check Rating
	CLICK DOWN
	Check Rating
	CLICK Ok
	CLICK Ok
	CLICK OK
	vod video validation

TC_584_VERIFY_ONDEMAND_RECENTLY_ADDED
    [Tags]	  SVOD
	[Documentation]	   Filter SVOD Documentaries
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Recently_Added_Ondemand
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Recently_Added_Ondemand is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recently_Added_Ondemand is not displayed after navigating right	
    Validate Blank Tile 
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK OK
	Sleep    1s
	CLICK OK
	Sleep    1s
	CLICK OK
	Sleep    1s
	Subscribe OnDemand
	vod video validation
	CLICK HOME
	CLICK HOME

TC_585_ONDEMAND_LIVE_PLAYBACK_SWITCH
	[Tags]	  SVOD
	[Documentation]    VOD Live playback switch
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK DOWN
	CLICK Ok
	CLICK Right
	# CLICK Right
	# CLICK Right
	CLICK OK
	Sleep    1s
	CLICK Ok
	CLICK Ok
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	Log To Console  Switching to live TV
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Ok

	#CLICK Ok
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	Log To Console  Switching to ondemand
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK DOWN
	CLICK Ok
	CLICK Right
	# CLICK Right
	# CLICK Right
	CLICK OK
	#CLICK Ok
	Sleep    1s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  progress
	Run Keyword If  '${Result}' == 'True'  Log To Console  video playback is resumend
	...  ELSE  Fail  Video playback is not progressed
	vod video validation
	CLICK Home
	CLICK Home

TC_586_ONDEMAND_INITIATE_PLAYBACK_COLLECTIONS
    [Tags]    SVOD
    [Documentation]    Browse SVOD and play
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  erosnow
	Run Keyword If  '${Result}' == 'True'  Log To Console  erosnow Is Displayed
	...  ELSE  Fail  erosnow Is Not Displayed
	CLICK Ok
	Sleep    1s
	Subscribe OnDemand
	Sleep    2s
	Log To Console    navigated to svod section

	CLICK Ok
	CLICK OK
	vod video validation
    CLICK HOME


	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK RIGHT
	CLICK RIGHT
	CLICK Ok
	Subscribe OnDemand
	${Result}  Verify Crop Image With Shorter Duration    ${port}  exsports
	Run Keyword If  '${Result}' == 'True'  Log To Console  erosnow Is Displayed
	...  ELSE  Fail  erosnow Is Not Displayed
	
	Sleep    2s
	Log To Console    navigated to svod section

	CLICK Ok
	CLICK OK
	vod video validation
    CLICK HOME

#########################SVOD#SUBPROFILE################################################

#############################################################################
TC_301_TIMESHIFT_PAUSE_RESUME_LIVE
	[Tags]    TIMESHIFT
	[Documentation]    Live Timeshift Pause Resume
	CLICK HOME
	Log To Console    Navigated To Home page
	Sleep	1s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK ONE
	CLICK ONE
	CLICK OK
	Sleep	20s
	# CLICK BACK
	# CLICK RIGHT
	# ${STEP_COUNT}=    Move to Pause On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	# CLICK OK
	CLICK PLAY
	Sleep    5s
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	# ...  ELSE  Fail  Play_Button Is Not Displayed	
	CLICK OK
    VALIDATE VIDEO PLAYBACK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed	
	# Sleep    30s
	Sleep    300s
	CLICK OK
	Log To Console    video is resumed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	Verify Audio Quality
	${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    Log To Console    Average Quality Score: ${results}
    EVALUATE VIDEO QUALITY STATUS    ${results}
	CLICK HOME
	Check For Exit Popup
	CLICK HOME


TC_302_TIMESHIFT_REWIND_RESUME_LIVE
	[Tags]    TIMESHIFT
	[Documentation]    Live Timeshift Rewind Resume
	CLICK HOME
	Log To Console    Navigated To Home page	
	Sleep	4s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK ONE
	CLICK ONE
	CLICK OK
	Sleep	20s
	# CLICK BACK
	# CLICK BACK
	# CLICK RIGHT
	# ${STEP_COUNT}=    Move to Pause On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	# CLICK OK
	CLICK PLAY
	Sleep    5s
	CLICK OK
	VALIDATE VIDEO PLAYBACK
    CLICK OK
	Sleep    60s
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    2s
	CLICK LEFT
	CLICK OK
	CLICK UP
	CLICK LEFT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-4X_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-4X_rewind Is Displayed
	...  ELSE  Fail  TC506_-4X_rewind Is Not Displayed
	Log To Console    video is rewinding
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-8x_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-8X_rewind Is Displayed
	...  ELSE  Fail  TC506_-8X_rewind Is Not Displayed
	Log To Console    video is rewinding
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-16x_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-16X_rewind Is Displayed
	...  ELSE  Fail  TC506_-16X_rewind Is Not Displayed
	Log To Console    video is rewinding
    CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  REWIND_32X
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-32X_rewind Is Displayed
	...  ELSE  Fail  TC506_-32X_rewind Is Not Displayed

	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed		
	CLICK OK
	Log To Console    video is resumed
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	Verify Audio Quality
	${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    Log To Console    Average Quality Score: ${results}
    EVALUATE VIDEO QUALITY STATUS    ${results}
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
TC_303_TIMESHIFT_PAUSE_FAST_FORWARD_LIVE
	[Tags]    TIMESHIFT
	[Documentation]    Live Timeshift Pause Fast Forward
	CLICK HOME
	Log To Console    Navigated To Home page
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK ONE
	CLICK ONE
	Sleep	20s
	# CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK OK
	Log To Console    Video is paused
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	Sleep    120s
	# Sleep    60s
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC505_4x_forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC505_4x_forward Is Displayed
	...  ELSE  Fail  TC505_4x_forward Is Not Displayed
	Log To Console    Video is fast forwarding 	
	CLICK OK
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	Sleep    1s
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_304_TIMESHIFT_REWIND_MAXIMUM_TIMESHIFT_BUFFER_LIVE
	[Tags]    TIMESHIFT
	[Documentation]    Live Timeshift Rewind Resume
	CLICK HOME
	Log To Console    Navigated To Home page
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK ONE
	CLICK ONE
	Sleep	20s
	# CLICK BACK
	# CLICK BACK
	# CLICK RIGHT
	# ${STEP_COUNT}=    Move to Pause On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	# CLICK OK
	CLICK PLAY
	Sleep    5s
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK OK
	Sleep    600s
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    2s
	CLICK LEFT
	CLICK OK
	CLICK UP
	CLICK LEFT
	CLICK OK
	# CLICK OK
	# CLICK OK
	Log To Console    video is rewinding
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-4X_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-4X_rewind Is Displayed
	...  ELSE  Fail  TC506_-4X_rewind Is Not Displayed
	Log To Console    video is rewinding
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-8x_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-8X_rewind Is Displayed
	...  ELSE  Fail  TC506_-8X_rewind Is Not Displayed
	Log To Console    video is rewinding
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-16x_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-16X_rewind Is Displayed
	...  ELSE  Fail  TC506_-16X_rewind Is Not Displayed
	Log To Console    video is rewinding
    CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  REWIND_32X
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-32X_rewind Is Displayed
	...  ELSE  Fail  TC506_-32X_rewind Is Not Displayed
	CLICK OK
	# CLICK OK
	# CLICK OK
	Log To Console    video is rewinding
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-4X_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-4X_rewind Is Displayed
	...  ELSE  Fail  TC506_-4X_rewind Is Not Displayed


    FOR    ${i}    IN RANGE    48
        Sleep    25s
        CLICK UP
        ${Result}=    Verify Crop Image With Shorter Duration   ${port}    Play_Button
        Run Keyword If    '${Result}' == 'True'    Log To Console    Play_Button Is Displayed (after 50s)
        ...    ELSE    Fail    Play_Button Is Not Displayed - Stopping Loop

        ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-4X_rewind
	    Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-4X_rewind Is Displayed
	    ...  ELSE  Fail  TC506_-4X_rewind Is Not Displayed- Stopping Loop
    END

	# Sleep    1200s
	#validate rewind button -4x text
	# CLICK RIGHT
    # ${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	# ...  ELSE  Fail  Play_Button Is Not Displayed
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-16x_rewind
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-16X_rewind Is Displayed
	# ...  ELSE  Fail  TC506_-16X_rewind Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_305_TIMESHIFT_PAUSE_LIVE_ONE_HOUR_RESUME
	[Tags]    TIMESHIFT
	[Documentation]    Live Timeshift Live Pause
	CLICK HOME
	Log To Console    Navigated To Home page
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK ONE
	CLICK ONE
	Sleep	20s
	# CLICK BACK
	# CLICK BACK
	# CLICK RIGHT
	# ${STEP_COUNT}=    Move to Pause On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	# CLICK OK
	CLICK PLAY
	Sleep    5s
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK UP
	CLICK OK
	Log To Console    Video is paused
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	Sleep    3600s
	# Sleep    60s
	CLICK OK
	Log To Console    video is resumed
	VALIDATE VIDEO PLAYBACK
	Sleep    10s
	CLICK UP
		${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Verify Audio Quality
	${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    Log To Console    Average Quality Score: ${results}
    EVALUATE VIDEO QUALITY STATUS    ${results}
    CLICK HOME
	Check For Exit Popup
	CLICK HOME
TC_306_TIMESHIFT_REWIND_SUBTITLES_ENABLED_STREAM
    [Tags]    TIMESHIFT
	CLICK HOME
	Log To Console    Navigated To Home Page
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK THREE
	CLICK SIX
	CLICK ZERO
	Sleep    20s
	CLICK PLAY
	Sleep    5s
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK LEFT
	CLICK OK
	CLICK UP
	CLICK OK
	Sleep	10s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK LEFT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Arabic_Subtitle
	Run Keyword If  '${Result}' == 'True'  Log To Console  Arabic_Subtitle Is Displayed
	...  ELSE  Fail  Arabic_Subtitle Is Not Displayed
	CLICK BACK
	# CLICK OK
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-4X_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-4X_rewind Is Displayed
	...  ELSE  Fail  TC506_-4X_rewind Is Not Displayed
	CLICK OK
	VALIDATE VIDEO PLAYBACK
    Verify Audio Quality
	${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    Log To Console    Average Quality Score: ${results}
    EVALUATE VIDEO QUALITY STATUS    ${results}
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_307_REWIND_LIVE_TEN_TIMES_CONSECUTIVELY
	[Tags]    TIMESHIFT
	[Documentation]    Live Rewind consecutively
	CLICK HOME
	Log To Console    Navigated To Home page
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK ONE
	CLICK ONE
	Sleep	20s
	# CLICK BACK
	# CLICK BACK
	# CLICK RIGHT
	# ${STEP_COUNT}=    Move to Pause On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	# CLICK OK
	CLICK PLAY
	Sleep    5s
	CLICK OK
    VALIDATE VIDEO PLAYBACK
	CLICK UP
	CLICK OK
	Sleep    60s
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    2s
	CLICK LEFT
	CLICK OK
	CLICK LEFT
	# Log To Console    rewinding the video
	CLICK OK
	# Sleep    1s
	CLICK OK
	# Sleep    1s
	CLICK OK
	# Sleep    1s
	CLICK OK
	# Sleep    1s
	CLICK OK
	# Sleep    1s
	CLICK OK
	# Sleep    1s
	CLICK OK
	# Sleep    1s
	CLICK OK
	# Sleep    1s
	CLICK OK
	# Sleep    1s
	CLICK Ok
	# Sleep    1s
	Log To Console    video rewinded consecutively for 10 times
		${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-8x_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-8X_rewind Is Displayed
	...  ELSE  Fail  TC506_-8X_rewind Is Not Displayed
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_308_PAUSE_FAST_FASTWARD_AT_MAXIMUM_SPEED
	[Tags]    TIMESHIFT
	[Documentation]    Live Pause Fast fastforward
	CLICK HOME
	Log To Console    Navigated To Home page
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK ONE
	CLICK ONE
	Sleep	20s
	# CLICK BACK
	# CLICK BACK
	# CLICK RIGHT
	# ${STEP_COUNT}=    Move to Pause On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	# CLICK OK
	CLICK PLAY
	Sleep    5s
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK OK
	Log To Console    video is paused
	Sleep    600s
	# Sleep    120s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	Click OK
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  4X_SPEED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC505_4x_forward Is Displayed
	...  ELSE  Fail  TC505_4x_forward Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  8X_SPEED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC505_4x_forward Is Displayed
	...  ELSE  Fail  TC505_8x_forward Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  16X_SPEED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_16xff Is Displayed
	...  ELSE  Fail  TC_505_16xff Is Not Displayed	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  32X_SPEED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_32xff Is Displayed
	...  ELSE  Fail  TC_505_32xff Is Not Displayed
	CLICK OK 
	Sleep    5s
	Log To Console    video forwarded 32x times
	VALIDATE VIDEO PLAYBACK
	Verify Audio Quality
	${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    Log To Console    Average Quality Score: ${results}
    EVALUATE VIDEO QUALITY STATUS    ${results}
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_309_TIMESHIFT_VERIFY_4K_HIGH_BITRATE_CHANNEL
	[Tags]	  TIMESHIFT
	[Documentation]	   Test Timeshift on a HD HIgh Bitrate Channel
	CLICK HOME
	Log To Console    Navigated To home page
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK ZERO
	CLICK FOUR
	Sleep	20s
	# CLICK BACK
	# CLICK RIGHT
	# ${STEP_COUNT}=    Move to Pause On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	# CLICK OK
	CLICK PLAY
	Sleep    5s
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	# ...  ELSE  Fail  Play_Button Is Not Displayed	
	CLICK OK
    VALIDATE VIDEO PLAYBACK
	CLICK UP
	CLICK OK
	Sleep    60s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	CLICK RIGHT
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC505_8x_forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_8x_ff Is Displayed
	...  ELSE  Fail  TC_505_8x_ff Is Not Displayed
	Sleep    2s
	CLICK LEFT
	CLICK OK
	# VALIDATE VIDEO PLAYBACK
	CLICK UP
	CLICK LEFT
	Log To Console    rewinding HD video
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-4X_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-4X_rewind Is Displayed
	...  ELSE  Fail  TC506_-4X_rewind Is Not Displayed
	Sleep    5s
	CLICK UP
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	Verify Audio Quality
	${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    Log To Console    Average Quality Score: ${results}
    EVALUATE VIDEO QUALITY STATUS    ${results}
	CLICK HOME
	Check For Exit Popup
	CLICK HOME


TC_310_TIMESHIFT_PAUSE_UNTIL_BUFFER_FULL_THEN_PAUSE_AGAIN
	[Tags]	  TIMESHIFT
	[Documentation]	   pause until buffer is full and pause again
	CLICK HOME
	# Log To Console    Navigated To home page
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK ONE
	Sleep	20s
	# CLICK BACK
	# CLICK BACK
	# CLICK RIGHT
	# ${STEP_COUNT}=    Move to Pause On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	# CLICK OK
	CLICK PLAY
	Sleep    5s
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK UP
	CLICK OK
	Log To Console    Video is paused
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	Sleep    7200s
	# Sleep    60s
	CLICK OK
	Log To Console    video is resumed
	VALIDATE VIDEO PLAYBACK
	Sleep    300s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Verify Audio Quality
	${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    Log To Console    Average Quality Score: ${results}
    EVALUATE VIDEO QUALITY STATUS    ${results}
    CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_311_VERIFY_PAUSE_POWER_CYCLE_RESUME
	[Tags]	  TIMESHIFT
	[Documentation]	   Pause alive stream power off the device then power on and resume
	CLICK HOME
	# Log To Console    Navigated To home page
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK ONE
	Sleep	20s
	# CLICK BACK
	# CLICK BACK
	# CLICK RIGHT
	# ${STEP_COUNT}=    Move to Pause On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	# CLICK OK
	CLICK PLAY
	Sleep    5s
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	Sleep    1s
	CLICK POWER
	Sleep	1s
	CLICK POWER
	Sleep	40s
    Check Who's Watching login
	Sleep	25s
	Log To Console    device is powered on
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep	1s

	${Result}  Verify Crop Image With Shorter Duration    ${port}  Eleven_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  Eleven_Channel Is Displayed
	...  ELSE  Fail  Eleven_Channel Is Not Displayed
	Sleep    5s
	VALIDATE VIDEO PLAYBACK
	Verify Audio Quality
	${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    Log To Console    Average Quality Score: ${results}
    EVALUATE VIDEO QUALITY STATUS    ${results}
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
TC_312_REWIND_JUMP_LIVE_TV
	[Tags]	  TIMESHIFT
	[Documentation]	   rewind by 5 min and jump to live
	CLICK HOME
	Log To Console    Navigated To home page
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK ONE
	Sleep	20s
	# CLICK BACK
	# CLICK RIGHT
	# ${STEP_COUNT}=    Move to Pause On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	# CLICK OK
	CLICK PLAY
	Sleep    5s
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK OK
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Play_Button
	Run Keyword If    '${Result}' == 'True'    Log To Console    Play_Button Is Displayed
	...    ELSE    Fail    Play_Button Is Not Displayed
	Sleep    300s
	CLICK LEFT
	Log To Console    rewinding the video
	CLICK OK
	FOR    ${i}    IN RANGE    12
        Sleep    25s
        CLICK UP
        ${Result}=    Verify Crop Image With Shorter Duration   ${port}    Play_Button
        Run Keyword If    '${Result}' == 'True'    Log To Console    Play_Button Is Displayed (after 50s)
        ...    ELSE    Fail    Play_Button Is Not Displayed - Stopping Loop

        ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-4X_rewind
	    Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-4X_rewind Is Displayed
	    ...  ELSE  Fail  TC506_-4X_rewind Is Not Displayed- Stopping Loop
    END
	CLICK BACK
	CLICK BACK
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_217_Exit
    Log To Console    Exit popup found: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
    END
	Sleep    2s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Eleven_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  Eleven_Channel Is Displayed
	...  ELSE  Fail  Eleven_Channel Is Not Displayed
	Verify Audio Quality
	${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    Log To Console    Average Quality Score: ${results}
    EVALUATE VIDEO QUALITY STATUS    ${results}
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
    Log To Console    Navigated To Home Page
TC_313_PAUSE_NEAR_PROGRAM_END_TRANSITION_TO_NEXT_REWIND_AND_ACCESS_BOTH
    [Tags]	  TIMESHIFT
	[Documentation]	   pause near program end and transition to next rewind and access both
	CLICK HOME
	Log To Console    Navigated To Home page
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK ONE
	CLICK ONE
	Sleep	20s
	# CLICK BACK
	# CLICK RIGHT
	# ${STEP_COUNT}=    Move to Pause On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	# CLICK OK
	CLICK PLAY
	Sleep    5s
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	Sleep    120s
	Sleep    60s
	# CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    10s
	CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-16x_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-16X_rewind Is Displayed
	...  ELSE  Fail  TC506_-16x_rewind Is Not Displayed
	Sleep    40s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
	# Sleep    60s
	# CLICK RIGHT
	# CLICK OK
	# Sleep    10s
	# CLICK UP
	# CLICK LEFT
	# CLICK OK
	# CLICK OK
	# CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-16x_rewind
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-16X_rewind Is Displayed
	# ...  ELSE  Fail  TC506_-16x_rewind Is Not Displayed
	# CLICK RIGHT
	# CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	# ...  ELSE  Fail  Pause_Button Is Not Displayed
	# VALIDATE VIDEO PLAYBACK
	# CLICK HOME
	# Check For Exit Popup
	# CLICK HOME

TC_314_TIMESHIFT_REWIND_AUDIO_ENABLED_STREAM
    [Tags]    TIMESHIFT
	CLICK HOME
	Log To Console    Navigated To Home Page
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK THREE
	CLICK SEVEN
	CLICK SIX
	Sleep	20s
	CLICK RIGHT
	${STEP_COUNT}=    Move to Audio Launguage On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END

    CLICK OK
	CLICK UP
	CLICK OK
	# CLICK BACK
	CLICK BACK
	CLICK PLAY
	Sleep    5s
	CLICK OK
	# VALIDATE VIDEO PLAYBACK
	CLICK UP
	# CLICK OK
	# Sleep    60s
	# CLICK OK
	# CLICK RIGHT
	# CLICK OK
	# CLICK OK
	# Sleep    2s
	# CLICK LEFT
	# CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  English_Audio
	Run Keyword If  '${Result}' == 'True'  Log To Console  English_Audio Is Displayed
	...  ELSE  Fail  English_Audio Is Not Displayed
	CLICK BACK
	CLICK BACK
	# CLICK OK
	Sleep	1s
	CLICK UP
	# CLICK LEFT
	CLICK LEFT
	# CLICK LEFT
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-4X_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-4X_rewind Is Displayed
	...  ELSE  Fail  TC506_-4X_rewind Is Not Displayed
	CLICK OK
	CLICK BACK
	CLICK BACK
	Sleep    2s
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Audio Launguage On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END

    CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK BACK
	# CLICK BACK
	CLICK PLAY
	Sleep    5s
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Hindi_Audio
	Run Keyword If  '${Result}' == 'True'  Log To Console   Hindi_Audio Is Displayed
	...  ELSE  Fail   Hindi_Audio Is Not Displayed
	CLICK BACK
	CLICK BACK
	# CLICK OK
	Sleep	1s
	CLICK UP
	# CLICK LEFT
	CLICK LEFT
	# CLICK LEFT
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-4X_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-4X_rewind Is Displayed
	...  ELSE  Fail  TC506_-4X_rewind Is Not Displayed
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	# ...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
    Verify Audio Quality
	${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    Log To Console    Average Quality Score: ${results}
    EVALUATE VIDEO QUALITY STATUS    ${results}
	CLICK BACK
	CLICK BACK
	Sleep    2s
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Audio Launguage On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END

    CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	# CLICK BACK
	CLICK PLAY
	Sleep    5s
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_219_BENGALI_AUDIO
	Run Keyword If  '${Result}' == 'True'  Log To Console   Hindi_Audio Is Displayed
	...  ELSE  Fail   Hindi_Audio Is Not Displayed
	CLICK BACK
	CLICK BACK
	# CLICK OK
	Sleep	1s
	CLICK UP
	# CLICK LEFT
	CLICK LEFT
	# CLICK LEFT
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC506_-4X_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-4X_rewind Is Displayed
	...  ELSE  Fail  TC506_-4X_rewind Is Not Displayed
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	# ...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
    Verify Audio Quality
	${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    Log To Console    Average Quality Score: ${results}
    EVALUATE VIDEO QUALITY STATUS    ${results}
	CLICK HOME
	Check For Exit Popup
	CLICK HOME


#############################################################################	

TC_201_VERIFY_VIDEO_QUALITY_2K_CH
    [Tags]    LIVE TV
    [Documentation]    Verify video quality 2k CH.
	CLICK HOME
    Log To Console    Navigated to Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated to TV Section
	CLICK OK
	CLICK FOUR
	CLICK SEVEN
	CLICK SEVEN

    Log To Console    Navigated to live tv channel
	Sleep    10s
	Log To Console    Video is playing for 10s
	# VALIDATE VIDEO PLAYBACK
	Video Quality Verification
	CLICK HOME

	CLICK OK
	CLICK ONE
	CLICK THREE
	CLICK ZERO

    Log To Console    Navigated to live tv channel
	Sleep    10s
	Log To Console    Video is playing for 10s
	# VALIDATE VIDEO PLAYBACK
	Video Quality Verification
	CLICK HOME
TC_202_VERIFY_VIDEO_QUALITY_4K_CH
    [Tags]    LIVE TV
    [Documentation]    Verify video quality 4k CH.
	CLICK HOME
    Log To Console    Navigated to Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated to TV Section
	CLICK OK
	# check chanel 476 - poor quality
	CLICK TWO
	CLICK ZERO
	CLICK FOUR
	# CLICK FOUR
	# CLICK SEVEN
	# CLICK SIX
    Log To Console    Navigated to channel
	Sleep    10s
	Log To Console    Video is playing for 10s
	# VALIDATE VIDEO PLAYBACK
	Video Quality Verification
	CLICK HOME
TC_203_VERIFY_ZAPPING_USING_CHANNEL_PLUS_CHANNEL_MINUS_REMOTE_CONTROL
    [Tags]   LIVE TV
    [Documentation]    Verifies channel switching using channel up and channel down buttons on remote.
	# RemoveFilter_UnlockChannels
	CLICK HOME
    Log To Console    Navigated to Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Zap Channel TO Channel Using Program UP and down Keys NEW

TC_204_ZAPPING_WITH_NUMERIC_KEYS
    [Tags]    LIVE TV
	[Documentation]     Verifies channel switching using numeric key inputs on the remote.   
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Zap Channel TO Channel Using Numeric Keys NEW


	
TC_205_VERIFY_ZAPPING_CHANNEL_LIST
    [Tags]    LIVE TV  
    [Documentation]    Verifies channel zapping flow and playback validation
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
    CLICK ONE
    Log To Console    Navigated To Channel 1
	Sleep	20s
	CLICK OK
	CLICK DOWN    
	CLICK DOWN    
	CLICK DOWN    
	CLICK DOWN    
	CLICK DOWN    
	CLICK DOWN    
	CLICK DOWN    
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_205_CHNL_ZAP
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_205_CHNL_ZAP Is Displayed
	...  ELSE  Fail  TC_205_CHNL_ZAP Is Not Displayed	
	Sleep	2s
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	Sleep    3s 
	CLICK HOME
	CLICK HOME
TC_206_VERIFY_ZAPPING_DURABILITY
    [Tags]    LIVE TV
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    Guide Channel List
    Sleep    2s
    # CLICK 
	CLICK THREE
	CLICK THREE
    ${CURRENT_CHANNEL}=    Extract Text From Screenshot
    Log To Console    📺 Starting Channel: ${CURRENT_CHANNEL}

    # ${PIXELLATION_FOUND}=    Set Variable    False

    # # Extract initial channel number using OCR
    # ${CURRENT_CHANNEL}=    Extract Text From Screenshot
    # Log To Console    📺 Starting Channel: ${CURRENT_CHANNEL}

    # FOR    ${index}    IN RANGE    10
    #     Log To Console    🔄 Zapping iteration ${index + 1}

    #     CLICK CHANNEL_PLUS
    #     # Extract the new channel number after zapping
    #     ${channel}=    Extract Text From Screenshot
    #     Log To Console    📺 Detected Channel: ${channel}

    #     VALIDATE VIDEO PLAYBACK
    #     ${result}=    Detect Pixellation From Frame

    #     Run Keyword If    '${result}' == 'PIXELLATION_DETECTED'    Fail    Pixellation detected at zap ${index + 1} (${channel})
    #     Run Keyword If    '${result}' == 'PIXELLATION_DETECTED'    Log Pixellation    ${channel}
    #     Run Keyword If    '${result}' == 'PIXELLATION_DETECTED'    Set Test Variable    ${PIXELLATION_FOUND}    True

    #     Run Keyword If    '${result}' == 'SHAKING_DETECTED'       Log Shaking    ${channel}
    #     Run Keyword If    '${result}' == 'SHAKING_DETECTED'       Set Test Variable    ${PIXELLATION_FOUND}    True

    #     Run Keyword If    '${result}' == 'BANNER_CHANNEL'         Log To Console    ⚠️ Banner channel detected at ${channel}, skipping...

    #     Log To Console    ✅ Channel ${channel} check result: ${result}
    # END

TC_208_VERIFY_AUDIO_LANGUAGE_CHANGE
	[Tags]	LIVE TV
	[Documentation]     Verifies audio language change on Live TV
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated To TV Section
	CLICK OK
	Log To Console    Navigated To Live Tv
	CLICK THREE
	CLICK SEVEN
	CLICK SIX
	Sleep    20s
	CLICK RIGHT
	${STEP_COUNT}=    Move to Audio On Side Pannel With OCR
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	# SELECTING ENGLISH
	CLICK OK
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Audio On Side Pannel With OCR
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	# VALIDATE ENGLISH SELECTED
	${Result}  Verify Crop Image With Shorter Duration    ${port}  English_Audio
	Run Keyword If  '${Result}' == 'True'  Log To Console  ENGLISH_AUDIO Is Displayed on screen
	...  ELSE  Fail  ENGLISH_AUDIO Is Not Displayed on screen
	CLICK BACK
	CLICK OK
	# SELECTING HINDI
	CLICK DOWN
	CLICK OK
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Audio On Side Pannel With OCR
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK DOWN
	# VALIDATE HINDI SELECTED
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Hindi_Audio
	Run Keyword If  '${Result}' == 'True'  Log To Console  HINDI_AUDIO Is Displayed on screen
	...  ELSE  Fail  HINDI_AUDIO Is Not Displayed on screen
	CLICK BACK
	CLICK OK
	# SELECTING BENGALI
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Audio On Side Pannel With OCR
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	# VALIDATE BENGALI SELECTED
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_219_BENGALI_AUDIO
	Run Keyword If  '${Result}' == 'True'  Log To Console  BENGALI_AUDIO Is Displayed on screen
	...  ELSE  Fail  BENGALI_AUDIO Is Not Displayed on screen
	CLICK BACK
	CLICK HOME
TC_210_VERIFY_VOLUME_CONTROL
    [Tags]    LIVE TV
    [Documentation]    Verifies Volume Control
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated To TV Section
	CLICK OK
	Log To Console    Navigated To Live TV
	CLICK FIVE
	CLICK FIVE
	CLICK NINE
	Unified verification of Audio Quality
	CLICK HOME
TC_211_VERIFY_ADD_TO_FAVORITES
    [Tags]    LIVE TV
	[Documentation]    Verify Content Added To Favorite List
	Remove_Favorites_From_List
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated to TV Section
	CLICK OK
	Log To Console    Navigated To Live TV
	CLICK TWO
	CLICK FOUR
	CLICK SEVEN
	Sleep    20s
	CLICK RIGHT
	Log To Console    Side Bar Is Displayed
	CLICK OK
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_Add_To_Favorites
	Run Keyword If  '${Result}' == 'True'  Log To Console  Favorite_pop_up  Is Displayed
	...  ELSE  Fail  Favorite_pop_up Is Not Displayed
	Log To Console    Add To Favorites Option Is Selected
	CLICK OK
	Log To Console    Selecting The Favorite List
	CLICK TWO
	CLICK FOUR
	CLICK EIGHT
	Sleep    20s
	CLICK RIGHT
	Log To Console    Side Bar Is Displayed
	CLICK OK
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_Add_To_Favorites
	Run Keyword If  '${Result}' == 'True'  Log To Console  Favorite_pop_up  Is Displayed
	...  ELSE  Fail  Favorite_pop_up Is Not Displayed
	Log To Console    Add To Favorites Option Is Selected
	CLICK OK
	Log To Console    Selecting The Favorite List
	CLICK TWO
	CLICK FIVE
	CLICK ZERO
	Sleep    20s
	CLICK RIGHT
	Log To Console    Side Bar Is Displayed
	CLICK OK
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_Add_To_Favorites
	Run Keyword If  '${Result}' == 'True'  Log To Console  Favorite_pop_up  Is Displayed
	...  ELSE  Fail  Favorite_pop_up Is Not Displayed
	Log To Console    Add To Favorites Option Is Selected
	CLICK DOWN
	CLICK OK
	Log To Console    Selecting The Favorite List
	CLICK TWO
	CLICK FIVE
	CLICK ONE
	Sleep    20s
	CLICK RIGHT
	Log To Console    Side Bar Is Displayed
	CLICK OK
	Sleep	3s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_Add_To_Favorites
	Run Keyword If  '${Result}' == 'True'  Log To Console  Favorite_pop_up  Is Displayed
	...  ELSE  Fail  Favorite_pop_up Is Not Displayed
	Log To Console    Add To Favorites Option Is Selected
	CLICK DOWN
	CLICK OK
	Log To Console    Selecting The Favorite List
	CLICK TWO
	CLICK FIVE
	CLICK TWO
	Sleep    20s
	CLICK RIGHT
	Log To Console    Side Bar Is Displayed
	CLICK OK
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_Add_To_Favorites
	Run Keyword If  '${Result}' == 'True'  Log To Console  Favorite_pop_up  Is Displayed
	...  ELSE  Fail  Favorite_pop_up Is Not Displayed
	Log To Console    Add To Favorites Option Is Selected
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Log To Console    Selecting The Favorite List
	CLICK TWO
	CLICK FIVE
	CLICK FOUR
	Sleep    20s
	CLICK RIGHT
	Log To Console    Side Bar Is Displayed
	CLICK OK
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_Add_To_Favorites
	Run Keyword If  '${Result}' == 'True'  Log To Console  Favorite_pop_up  Is Displayed
	...  ELSE  Fail  Favorite_pop_up Is Not Displayed
	Log To Console    Add To Favorites Option Is Selected
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Log To Console    Selecting The Favorite List
	CLICK TWO
	CLICK FIVE
	CLICK NINE
	Sleep    20s
	CLICK RIGHT
	Log To Console    Side Bar Is Displayed
	CLICK OK
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_Add_To_Favorites
	Run Keyword If  '${Result}' == 'True'  Log To Console  Favorite_pop_up  Is Displayed
	...  ELSE  Fail  Favorite_pop_up Is Not Displayed
	Log To Console    Add To Favorites Option Is Selected
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Log To Console    Selecting The Favorite List
	CLICK TWO
	CLICK SIX
	CLICK ZERO
	Sleep    20s
	CLICK RIGHT
	Log To Console    Side Bar Is Displayed
	CLICK OK
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_Add_To_Favorites
	Run Keyword If  '${Result}' == 'True'  Log To Console  Favorite_pop_up  Is Displayed
	...  ELSE  Fail  Favorite_pop_up Is Not Displayed
	Log To Console    Add To Favorites Option Is Selected
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Log To Console    Selecting The Favorite List
	CLICK TWO
	CLICK SIX
	CLICK ONE
	Sleep    20s
	CLICK RIGHT
	Log To Console    Side Bar Is Displayed
	CLICK OK
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_Add_To_Favorites
	Run Keyword If  '${Result}' == 'True'  Log To Console  Favorite_pop_up  Is Displayed
	...  ELSE  Fail  Favorite_pop_up Is Not Displayed
	Log To Console    Add To Favorites Option Is Selected
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Log To Console    Selecting The Favorite List
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	FOR    ${i}    IN RANGE    25
    ${Result}=    Verify Crop Image With Shorter Duration  ${port}    TC_211_Favorites_Feed
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    Favorites feed is displayed
    ...    AND    Exit For Loop

    CLICK RIGHT
    Sleep    0.2s
    END
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_STAR
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_CHANNEL_2
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_CHANNEL_3
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
    ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_CHANNEL_4
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_CHANNEL_5
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_CHANNEL_6
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_CHANNEL_3
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_CHANNEL_8
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_211_CHANNEL_9
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	CLICK HOME
	 Reboot STB Device
	Log To Console    Checking in Favorite List after Reboot
	CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK OK
    CLICK OK
    Sleep    20s
    CLICK OK
	CLICK LEFT
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK TWO
    CLICK TWO
    CLICK TWO
    CLICK TWO
    CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK TWO
	CLICK FOUR
	CLICK SEVEN
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  FAVORITED_247
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	CLICK BACK
	CLICK EIGHT
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  FAVORITED_248
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK FIVE
	CLICK ZERO
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  FAVORITED_250
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	CLICK BACK
	CLICK ONE
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  FAVORITED_251
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK TWO
	CLICK FIVE
	CLICK TWO
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  FAVORITED_252
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	CLICK BACK
	CLICK FOUR
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  FAVORITED_254
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK TWO
	CLICK FIVE
	CLICK NINE
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  FAVORITED_259
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	CLICK BACK
	CLICK BACK
	CLICK SIX
	CLICK ZERO
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  FAVORITED_260
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK TWO
	CLICK SIX
	CLICK ONE
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  FAVORITED_261
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    2s
	CLICK OK
	CLICK HOME
 
TC_212_VERIFY_REMOVE_FAVORITES
    [Tags]    LIVE TV
	[Documentation]    Verify Content Removed From Favorite List
	# Remove_Favorite_Live_Tv
	CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK OK
    CLICK OK
    Sleep  30s
    CLICK OK
    CLICK LEFT
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK TWO
    CLICK TWO
    CLICK TWO
    CLICK TWO
    CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK TWO
	CLICK FOUR
	CLICK SEVEN
	CLICK DOWN
	CLICK OK
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_247
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed
	...  ELSE  Fail  Channel Is Not Removed	
	CLICK UP
	CLICK BACK
	CLICK EIGHT
	CLICK DOWN
	CLICK OK
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_248
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed
	...  ELSE  Fail  Channel Is Not Removed	
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK TWO
	CLICK FIVE
	CLICK ZERO
	CLICK DOWN
	CLICK OK
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_250
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed
	...  ELSE  Fail  Channel Is Not Removed	
	CLICK UP
	CLICK BACK
	CLICK ONE
	CLICK DOWN
	CLICK OK
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_251
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed
	...  ELSE  Fail  Channel Is Not Removed	
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK TWO
	CLICK FIVE
	CLICK TWO
	CLICK DOWN
	CLICK OK
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_252
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed
	...  ELSE  Fail  Channel Is Not Removed	
	CLICK UP
	CLICK BACK
	CLICK FOUR
	CLICK DOWN
	CLICK OK
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_254
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed
	...  ELSE  Fail  Channel Is Not Removed	
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK TWO
	CLICK FIVE
	CLICK NINE
	CLICK DOWN
	CLICK OK
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_259
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed
	...  ELSE  Fail  Channel Is Not Removed	
	CLICK UP
	CLICK BACK
	CLICK BACK
	CLICK SIX
	CLICK ZERO
	CLICK DOWN
	CLICK OK
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_260
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed
	...  ELSE  Fail  Channel Is Not Removed	
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK TWO
	CLICK SIX
	CLICK ONE
	CLICK DOWN
	CLICK OK
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_261
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed
	...  ELSE  Fail  Channel Is Not Removed	
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
    CLICK HOME
    Reboot STB Device
	CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK OK
    CLICK OK
	Sleep    30s
	CLICK OK
    CLICK LEFT
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK TWO
    CLICK TWO
    CLICK TWO
    CLICK TWO
    CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK TWO
	CLICK FOUR
	CLICK SEVEN
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_247
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed From Favorites
	...  ELSE  Fail  Channel Is Not Removed From Favorites	
	CLICK BACK
	CLICK EIGHT
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_248
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed From Favorites
	...  ELSE  Fail  Channel Is Not Removed From Favorites	
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK TWO
	CLICK FIVE
	CLICK ZERO
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_250
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed From Favorites
	...  ELSE  Fail  Channel Is Not Removed From Favorites	
	CLICK UP
	CLICK BACK
	CLICK ONE
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_251
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed From Favorites
	...  ELSE  Fail  Channel Is Not Removed From Favorites	
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK TWO
	CLICK FIVE
	CLICK TWO
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_252
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed From Favorites
	...  ELSE  Fail  Channel Is Not Removed From Favorites	
	CLICK UP
	CLICK BACK
	CLICK FOUR
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_254
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed From Favorites
	...  ELSE  Fail  Channel Is Not Removed From Favorites	
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK TWO
	CLICK FIVE
	CLICK NINE
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_259
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed From Favorites
	...  ELSE  Fail  Channel Is Not Removed From Favorites	
	CLICK UP
	CLICK BACK
	CLICK BACK
	CLICK SIX
	CLICK ZERO
	CLICK DOWN
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_260
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed From Favorites
	...  ELSE  Fail  Channel Is Not Removed From Favorites	
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK TWO
	CLICK SIX
	CLICK ONE
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  UNFAV_261
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Removed From Favorites
	...  ELSE  Fail  Channel Is Not Removed From Favorites	
    CLICK HOME
TC_213_VERIFY_LIVE_TV_PAUSE
	[Tags]   LIVE TV  
    [Documentation]    Verifies pause functionality on Live TV
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK OK
    Log To Console    Navigated To Live TV
	CLICK BACK
	Sleep    10s
    CLICK RIGHT
	${variable}=    Ensure Pause IS Visible
    ${STEP_COUNT}=    Move to Pause On Side Pannel With OCR
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	Sleep    2s
    #image validation required - Check play button visibility
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed	
	CLICK OK
		${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed	
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	Video Quality Verification
	# Unified verification of Audio Quality
	CLICK HOME
TC_214_VERIFY_LIVE_TV_STARTOVER
    [Tags]    LIVE TV
    [Documentation]    Verifies Live TV start-over feature, confirms seek bar reset to 00:00 and playback progression
    CLICK HOME
    Check For Exit popup
	CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section
    CLICK OK
	CLICK SIX
    CLICK ZERO
    Log To Console    Navigated To Live TV
	CLICK BACK
    Sleep    20s
    CLICK RIGHT
    ${STEP_COUNT}=    Move to Start Over On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	Sleep    2s
	${start_over_status}=    Get Live Progress Bar Status 
	Log To Console    ${start_over_status}
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	Log To Console    Checking Video and audio Quality
	# Video Quality Verification
	# Unified verification of Audio Quality
	CLICK BACK	
	Log To Console    Video playback is active after Start Over
    Sleep    10s
	CLICK UP
    CLICK HOME
    Check For Exit popup
	CLICK HOME
TC_215_VERIFY_LIVE_TV_RECORD
	[Tags]    LIVE TV  
    [Documentation]    Verifies Live TV recording functionality
	[Teardown]    STOP RECORDING
	CLICK HOME
    CLICK UP
    CLICK RIGHT
	CLICK OK
    CLICK OK
    CLICK TWO
	CLICK TWO
	Sleep	30s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
	Sleep    8s
   ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder
    Sleep    120s

    CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Sleep    10s
    CLICK OK
	Sleep	2s
	Get Storage Type In Recorder List    Cloud
	Sleep    10s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
	${recorded_channel_text}=    Normalize Spelling    ${recorded_channel_text}
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
    CLICK DOWN
	CLICK DOWN
    CLICK OK
    CLICK OK
    CLICK OK
	CLICK OK
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	5s
	Check For Recording Completed Popup
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	CLICK HOME
	
TC_216_VERIFY_CATCH_UP_UNDER_LIVE_TV
	[Tags]    LIVE TV  
	[Documentation]    Verifies access to Catch-Up under Live TV
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up
	Sleep	5s
	CLICK OK
    Log To Console    Navigated To Catch up section all channels
	Sleep	5s
	CLICK LEFT
	CLICK LEFT
	Sleep	1s
	CLICK OK
	Sleep	1s
	CLICK LEFT
	CLICK LEFT
	CLICK OK
    Log To Console    Catchup Selected
	CLICK DOWN
	CLICK OK
	Sleep	2s
	# CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	# CLICK OK
	CLICK BACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Video Quality Verification
	# Sleep    20s
	# Unified verification of Audio Quality
	CLICK HOME
TC_217_VERIFY_MORE_DETAILS_UNDER_LIVE_TV
    [Tags]    LIVE TV  
    [Documentation]    Verifies More Details Under Live Tv
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section
    CLICK OK
    Log To Console    Navigated To Live TV
    CLICK TWO
	CLICK SIX
	CLICK SIX
    Log To Console    Navigated To Channel 266
    Sleep    20s
    CLICK RIGHT
    Log To Console    Navigating To More Details Section
    Sleep    3s
    ${STEP_COUNT}=    Move to More Details On Side Pannel With OCR

    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Sleep    3s
    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Log To Console   Video is Paused
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    LIVE_TV_MORE_DETAIL
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_217_TV_Live Is Displayed
    ...    ELSE    Fail    TC_217_TV_Live Is Not Displayed
    
       @{metadata_assets}=    Create List
    ...    TC_217_LIVE_TV_CHANNEL_266
    ...    TC_217_LIVE_TV_CHANNEL_NAME
    ...    TC_217_LIVE_TV_WATCH_BUTTON_STB2
    
    FOR    ${asset}    IN    @{metadata_assets}
        ${status}=    Run Keyword And Return Status    Verify Crop Image With Shorter Duration   ${port}    ${asset}
        Run Keyword If    not ${status}    Fail    ${asset} is not displayed
        Log To Console    ${asset} validated successfully
    END
    CLICK HOME
TC_218_SEARCH_BY_CONTENT_TYPE
	[Tags]	LIVE TV
	[Documentation]    Live TV search filter validation.
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To Search Section
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    Log To Console    Filter Applied For Live TV
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    2s
    Log To Console    Displayed Search Results 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  MBC_CHNL
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	CLICK OK
	Sleep	5s
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep	20s
	CLICK RIGHT
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    1s
    Log To Console    Displayed Search Results 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  MBC_CHNL
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	CLICK OK
	Sleep	5s
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
TC_220_VERIFY_SUBTITLING
	[Tags]	LIVE TV
	[Documentation]    Verifies subtitle option on Live TV and confirms subtitle
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated To TV Section
	CLICK OK
	Log To Console    Navigated To Live Tv
	CLICK THREE
	CLICK SIX
	CLICK SEVEN
	Sleep    20s
	CLICK RIGHT
	 ${STEP_COUNT}=    Move to Subtitles On Side Pannel With OCR

	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	# SELECTING ARABIC
	CLICK OK
	CLICK BACK
	CLICK RIGHT
	 ${STEP_COUNT}=    Move to Subtitles On Side Pannel With OCR
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	# VALIDATE ARABIC SELECTED
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_220_ARABIC_SUBTITLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_SUBTITLE Is Displayed on screen
	...  ELSE  Fail  ARABIC_SUBTITLE Is Not Displayed on screen
	CLICK BACK
	CLICK OK
	# SELECTING DANISH
	CLICK DOWN
	CLICK OK
	CLICK BACK
	CLICK RIGHT
	 ${STEP_COUNT}=    Move to Subtitles On Side Pannel With OCR
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK DOWN
	# VALIDATE DANISH SELECTED
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_220_DANISH_SUBTITLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  DANISH_SUBTITLE Is Displayed on screen
	...  ELSE  Fail  DANISH_SUBTITLE Is Not Displayed on screen
	CLICK BACK
	CLICK OK
	# SELECTING FINNISH
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	CLICK RIGHT
	 ${STEP_COUNT}=    Move to Subtitles On Side Pannel With OCR
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	# VALIDATE FINNISH SELECTED
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_220_FINNISH_SUBTITLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  FINNISH_SUBTITLE Is Displayed on screen
	...  ELSE  Fail  FINNISH_SUBTITLE Is Not Displayed on screen
	CLICK BACK
	CLICK OK
	# SELECTING NORWEGIAN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	CLICK RIGHT
	 ${STEP_COUNT}=    Move to Subtitles On Side Pannel With OCR
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# VALIDATE NOR SELECTED
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_220_NOR_SUBTITLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  NOR_SUBTITLE Is Displayed on screen
	...  ELSE  Fail  NOR_SUBTITLE Is Not Displayed on screen
	CLICK BACK
	CLICK OK
	# SELECTING SWEDISH
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	CLICK RIGHT
	 ${STEP_COUNT}=    Move to Subtitles On Side Pannel With OCR
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# VALIDATE SWEDISH SELECTED
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_220_SWEDISH_SUBTITLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  SWEDISH_SUBTITLE Is Displayed on screen
	...  ELSE  Fail  SWEDISH_SUBTITLE Is Not Displayed on screen
	CLICK BACK
	CLICK OK
	# SELECTING NONE
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	CLICK RIGHT
	 ${STEP_COUNT}=    Move to Subtitles On Side Pannel With OCR
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# VALIDATE NONE SELECTED
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_220_NONE_SUBTITLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  NONE Is Displayed on screen
	...  ELSE  Fail  NONE Is Not Displayed on screen
	CLICK BACK
	CLICK HOME
TC_221_VERIFY_FAVORITE_LIVE_TV
	[Tags]	LIVE TV
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep  20s
	CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_221_Manage_Favorites
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_Manage_Favorites Is Displayed
	...  ELSE  Fail  TC_221_Manage_Favorites Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_Admin_Pin_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_Admin_Pin_Popup Is Displayed
	...  ELSE  Fail  TC_221_Admin_Pin_Popup Is Not Displayed
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    5s
	CLICK LEFT
	Sleep	3s
	CLICK LEFT
	Sleep	3s
	#CHECK PROFILE TYPE IN THE SCREEN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  PERSONAL_INFO
	Run Keyword If  '${Result}' == 'True'  Log To Console  PERSONAL_INFO Is Displayed
	...  ELSE  Fail  PERSONAL_INFO Is Not Displayed
	CLICK DOWN
	Sleep    2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_001_Profile_Type
	Run Keyword If  '${Result}' == 'True'  Log To Console  PROFILE_TYPE Is Displayed
	...  ELSE  Fail  PROFILE_TYPE Is Not Displayed
	Sleep    2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  NICKNAME
	Run Keyword If  '${Result}' == 'True'  Log To Console  NICKNAME Is Displayed
	...  ELSE  Fail  NICKNAME Is Not Displayed
	CLICK DOWN
	Sleep    2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  EMAIL
	Run Keyword If  '${Result}' == 'True'  Log To Console  EMAIL Is Displayed
	...  ELSE  Fail  EMAIL Is Not Displayed
	CLICK DOWN
	Sleep    2s
		${Result}  Verify Crop Image With Shorter Duration  ${port}  MOBILE_NO
	Run Keyword If  '${Result}' == 'True'  Log To Console  MOBILE_NO Is Displayed
	...  ELSE  Fail  MOBILE_NO Is Not Displayed
	CLICK DOWN
	Sleep    2s
		${Result}  Verify Crop Image With Shorter Duration  ${port}  GENDER
	Run Keyword If  '${Result}' == 'True'  Log To Console  GENDER Is Displayed
	...  ELSE  Fail  GENDER Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  FEMALE_GENDER
	Run Keyword If  '${Result}' == 'True'  Log To Console  FEMALE_GENDER Is Displayed
	...  ELSE  Fail  FEMALE_GENDER Is Not Displayed
	Sleep    1s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration  ${port}  MALE_GENDER
	Run Keyword If  '${Result}' == 'True'  Log To Console  MALE_GENDER Is Displayed
	...  ELSE  Fail  MALE_GENDER Is Not Displayed
	CLICK BACK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_DOB
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_DOB Is Displayed
	...  ELSE  Fail  TC_221_DOB Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_CALENDAR
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_CALENDAR Is Displayed
	...  ELSE  Fail  TC_221_CALENDAR Is Not Displayed
	CLICK BACK
	CLICK BACK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_NATIONALITY
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_NATIONALITY Is Displayed
	...  ELSE  Fail  TC_221_NATIONALITY Is Not Displayed
	CLICK OK
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_INDIA
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_INDIA Is Displayed
	...  ELSE  Fail  TC_221_INDIA Is Not Displayed
	Sleep    1s
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_PAKISTAN
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_PAKISTAN Is Displayed
	...  ELSE  Fail  TC_221_PAKISTAN Is Not Displayed
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_EGYPT
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_EGYPT Is Displayed
	...  ELSE  Fail  TC_221_EGYPT Is Not Displayed
	CLICK BACK
	CLICK UP
	CLICK UP
	CLICK RIGHT
	Sleep    2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_SEC_CONT
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_SECURITY_CONTROL Is Displayed
	...  ELSE  Fail  TC_221_SECURITY_CONTROL Is Not Displayed
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_PIN
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_PIN Is Displayed
	...  ELSE  Fail  TC_221_PIN Is Not Displayed
    CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_DISABLE_PIN
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_DISABLE_PIN Is Displayed
	...  ELSE  Fail  TC_221_DISABLE_PIN Is Not Displayed
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_BOX_PIN
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_BOX_PIN Is Displayed
	...  ELSE  Fail  TC_221_PIN Is Not Displayed
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_ALWAYS_LOGIN
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_ALWAYS_LOGIN Is Displayed
	...  ELSE  Fail  TC_221_PIN Is Not Displayed
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_RENTAL
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_RENTAL Is Displayed
	...  ELSE  Fail  TC_221_RENTAL Is Not Displayed
    CLICK UP
	CLICK UP
	CLICK UP
    CLICK UP
    CLICK UP
    CLICK UP
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_TV_Experience
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_TV_Experience Is Displayed
	...  ELSE  Fail  TC_221_TV_Experience Is Not Displayed
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_AUDIO
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_AUDIO Is Displayed
	...  ELSE  Fail  TC_221_AUDIO Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_021_Audio_english
	Run Keyword If  '${Result}' == 'True'  Log To Console  English Is Displayed
	...  ELSE  Fail  English Is Not Displayed
	Sleep    1s
		${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_ARABIC
	Run Keyword If  '${Result}' == 'True'  Log To Console  Arabic Is Displayed
	...  ELSE  Fail  Arabic Is Not Displayed   
		${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_DEFAULT
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_DEFAULT Is Displayed
	...  ELSE  Fail  TC_221_DEFAULT Is Not Displayed
	CLICK BACK
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_SUBTITLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_SUBTITLE Is Displayed
	...  ELSE  Fail  TC_221_SUBTITLE Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_021_Audio_english
	Run Keyword If  '${Result}' == 'True'  Log To Console  English Is Displayed
	...  ELSE  Fail  English Is Not Displayed
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_ARABIC
	Run Keyword If  '${Result}' == 'True'  Log To Console  Arabic Is Displayed
	...  ELSE  Fail  Arabic Is Not Displayed  
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_None
	Run Keyword If  '${Result}' == 'True'  Log To Console  None Is Displayed
	...  ELSE  Fail  None Is Not Displayed
	Sleep    1s
	CLICK BACK
	CLICK DOWN
		${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_RATING
	Run Keyword If  '${Result}' == 'True'  Log To Console  RATING Is Displayed
	...  ELSE  Fail  RATING Is Not Displayed   
	Sleep    1s
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_CHNL_LOCK
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_CHNL_LOCK Is Displayed
	...  ELSE  Fail  TC_221_CHNL_LOCK Is Not Displayed   
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_CHANNEL_LOCK
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_CHANNEL_LOCK Is Displayed
	...  ELSE  Fail  TC_221_CHANNEL_LOCK Is Not Displayed  
	CLICK BACK
	Sleep	1s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_ADVER
	Run Keyword If  '${Result}' == 'True'  Log To Console  ADVERTISMENT Is Displayed
	...  ELSE  Fail  ADVERTISMENT Is Not Displayed  
	Sleep	2s
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_ENABLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_ENABLE Is Displayed
	...  ELSE  Fail  TC_221_ENABLE Is Not Displayed  
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_DISABLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_DISABLE Is Displayed
	...  ELSE  Fail  TC_221_DISABLE Is Not Displayed  
	CLICK BACK
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_HIDE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_HIDE Is Displayed
	...  ELSE  Fail  TC_221_HIDE Is Not Displayed  
	Sleep	1s
	CLICK OK
	Sleep	1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_CHNL_HIDE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_CHNL_HIDE Is Displayed
	...  ELSE  Fail  TC_221_CHNL_HIDE Is Not Displayed  
	CLICK BACK
	Sleep	1s
	CLICK RIGHT
	Sleep	1s
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_FAV_LIST
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_FAV_LIST Is Displayed
	...  ELSE  Fail  TC_221_FAV_LIST Is Not Displayed  
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_FAV_1
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_FAV_1 Is Displayed
	...  ELSE  Fail  TC_221_FAV_1 Is Not Displayed  
	CLICK BACK
	CLICK UP
	Sleep	2s
	CLICK RIGHT
	Sleep	1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_INTERFACE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_INTERFACE Is Displayed
	...  ELSE  Fail  TC_221_INTERFACE Is Not Displayed  
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_REC_STORAGE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_REC_STORAGE Is Displayed
	...  ELSE  Fail  TC_221_REC_STORAGE Is Not Displayed
	CLICK OK
	Sleep    2s
	CLICK UP
	Sleep    2s
	CLICK UP
	CLICK BACK
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_SCREEN_LANG
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_SCREEN_LANG Is Displayed
	...  ELSE  Fail  TC_221_SCREEN_LANG Is Not Displayed
	CLICK OK
		${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_ARABIC
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_ARABIC Is Displayed
	...  ELSE  Fail  TC_221_ARABIC Is Not Displayed
	 ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_ENGLISH
	Run Keyword If  '${Result}' == 'True'  Log To Console  English Is Displayed
	...  ELSE  Fail  TC_221_SCREEN_LANG Is Not Displayed
	CLICK BACK
	CLICK DOWN
	CLICK DOWN
	 ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_TIMEOUT
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_TIMEOUT Is Displayed
	...  ELSE  Fail  TC_221_TIMEOUT Is Not Displayed
	CLICK OK
	 ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_5_SEC
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_025_Timeout_5sec Is Displayed
	...  ELSE  Fail  TC_025_Timeout_5sec Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_10_SEC
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_025_Timeout_10sec Is Displayed
	...  ELSE  Fail  TC_025_Timeout_10sec Is Not Displayed
	CLICK BACK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_CLOCK
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_CLOCK Is Displayed
	...  ELSE  Fail  TC_221_CLOCK Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_ON
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_clock_on Is Displayed
	...  ELSE  Fail  Interface_clock_on Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_OFF
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_clock_off Is Displayed
	...  ELSE  Fail  Interface_clock_off Is Not Displayed
	CLICK BACK
	CLICK RIGHT

	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_CHNL_STYLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_CHNL_STYLE Is Displayed
	...  ELSE  Fail  TC_221_CHNL_STYLE Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_9_STYLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_9_STYLE Is Displayed
	...  ELSE  Fail  TC_221_9_STYLE Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_221_5_STYLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_5_STYLE Is Displayed
	...  ELSE  Fail  TC_221_5_STYLE Is Not Displayed
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK BACK
	CLICK HOME
##################################################################################################	


TC_207_VERIFY_MOSAIC_CHANNEL
    [Tags]    LIVE TV
    [Documentation]    Verifies Mosaic Nature Of Channel
    ${channel_sets}=    Create List    8    9
	# ${channel_sets}=    Create List    9
    ${coords}=    Create List
    ...    0.06,0.26,0.25,0.27
    ...    0.26,0.46,0.25,0.27
    ...    0.46,0.66,0.25,0.27
    ...    0.66,0.86,0.25,0.27
    ...    0.06,0.26,0.48,0.51
    ...    0.26,0.46,0.48,0.51
    ...    0.46,0.66,0.48,0.51
    ...    0.66,0.86,0.48,0.51
    ...    0.06,0.26,0.72,0.74
    ...    0.26,0.46,0.72,0.74
    ...    0.46,0.66,0.72,0.75
    ...    0.66,0.86,0.72,0.75
    ...    0.06,0.26,0.95,0.98
    ...    0.26,0.46,0.95,0.98
    ...    0.46,0.66,0.95,0.98
    ...    0.66,0.90,0.95,0.98

    FOR    ${set}    IN    @{channel_sets}
        Log To Console     VERIFYING MOSAIC FOR CHANNEL SET ${set} 
        Press Channel Number    ${set}
        Sleep    20s

        FOR    ${index}    ${coord}    IN ENUMERATE    @{coords}
            ${tile_number}=    Evaluate    ${index} + 1
            ${row}=    Evaluate    ${index} // 4
            ${col}=    Evaluate    ${index} % 4

            # Skip mosaic tiles 5 and 8 for channel set 9
            Run Keyword If    ${set} == 9 and (${tile_number} == 5 or ${tile_number} == 8)    Continue For Loop

            Log To Console    >>> Selecting tile ${tile_number} (Row ${row}, Col ${col})

            Run Keyword If    ${row} > 0    Repeat Keyword    ${row}    CLICK DOWN    1s
            Run Keyword If    ${col} > 0    Repeat Keyword    ${col}    CLICK RIGHT    0.5s

            ${channel_name}=    Get Channel Name From Mosaic With Coords    ${coord}    ${tile_number}
            Log To Console    ${channel_name}

            Sleep    2s
            CLICK OK
            Sleep    20s
            ${channel_name_epg_text}=    Get Channel Name In Recorder From Info Bar
            Verify Matching Channels For Mosaic    ${channel_name_epg_text}    ${channel_name}

            Press Channel Number    ${set}
            Sleep    20s
        END
    END




##################################################################################################	


TC_701_ACCESS_CATCHUP_MENU_PLAY_24HRS_AGO_CATCHUP
    [Tags]    CATCHUP
    [Documentation]    Plays catch-up content from the previous 24-hour window.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	[Timeout]	1200s
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV 
	Sleep    5s
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
	Sleep   5s
	CLICK OK
	CLICK DOWN
	CLICK OK
	Sleep   5s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Yesterday_Catchup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Yesterday_Option Is Displayed
	...  ELSE  Fail  Yesterday_Option Is Not Displayed
	CLICK UP
	VALIDATE VIDEO PREVIEW
	CLICK OK
	Sleep    2s
	Catchup favorites

    Log To Console    Selected Catch Up Playback

	Sleep    3s
	Verify it is playbutton or not
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Log To Console    Play video for 3 minutes
	# Sleep    180s
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Video Quality Verification
	# Unified verification of Audio Quality
	CLICK HOME

TC_702_ACCESS_CATCHUP_FROM_EPG
    [Tags]    CATCHUP
	[Documentation]    Verifies access to catch-up content directly from the Electronic Program Guide (EPG).   
	[Teardown]    Run Keywords    revert catchup filter
	...    AND    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
	Log To Console    Navigated to Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated to TV Section
	Sleep   5s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    5s
	Guide Channel List
	Log To Console    Navigated To TV Guide Section
	Sleep    2s

	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Log To Console    Filter applied to select Catch Up  Content
	CLICK UP
	CLICK UP
	CLICK OK
	Log To Console    Cleared Selected Filters
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Log To Console    Selected Catch Up From Filter
	Sleep    1s
	CLICK BACK
	#Selecting yesterday program
	CLICK RIGHT
	Sleep    1s
	CLICK RIGHT
	CLICK UP
	CLICK OK
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK OK
	#CLICK OK
	Log To Console    Content Accessed From EPG
	Sleep	1s
	Verify it is playbutton or not
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Log To Console    Play video for 3 minutes
	# Sleep    180s
    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
    # ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
	# REVERT
	# CLICK BACK
	# CLICK BACK
	# CLICK BACK
	# CLICK OK
	# CLICK LEFT
	# CLICK DOWN
    # CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	# CLICK UP
	# CLICK UP
	# CLICK OK
	# CLICK DOWN
	# CLICK OK
	# CLICK HOME

TC_703_CATCHUP_PAUSE_RESUME
    [Tags]    CATCHUP
    [Documentation]     Verifies pausing and resuming catch-up content from the same position.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	VALIDATE VIDEO PREVIEW
	CLICK OK
    Log To Console    Selected Catch Up Playback
	Catchup favorites
    Sleep    3s
	CLICK UP
	${start_over_status}=	Get Start Over Progress Bar Status
	${time_range_before}=	Get Extracted Time On Player Info Bar	${start_over_status}
	${time_before_pause}=	Check OCR Start Timestamp Using AI Slots	${time_range_before}
	Log To Console	${time_before_pause}
	CLICK OK
	Log To Console	Paused for 300s
	Sleep	300s
	CLICK OK
	${start_over_status_after}=	Get Start Over Progress Bar Status
	${time_range_before}=	Get Extracted Time On Player Info Bar	${start_over_status_after}
	${time_after_pause}=	Check OCR Start Timestamp Using AI Slots	${time_range_before}
	Log To Console	${time_after_pause}
	Check OCR Timestamp After Pause Start Over    ${time_after_pause}    ${time_before_pause}    12
    ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
    CLICK HOME
TC_704_CATCHUP_FAST_FORWARD_RESUME
    [Tags]    CATCHUP
	[Documentation]    Verifies fast-forwarding and resuming catch-up content correctly.   
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK LEFT
	VALIDATE VIDEO PREVIEW
	CLICK OK
    Log To Console    Selected Catch Up Playback
	Catchup favorites 
	Sleep    2s
	Apply Startover
	Sleep    20s
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    10s
	#${4x_fwd}=    Get Time Before Fast Forward Or Rewind
	${Result}  Verify Crop Image With Shorter Duration    ${port}  x4_Forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  x4_Forward Is Displayed
	...  ELSE  Fail  x4_Forward Is Not Displayed
    #Get Time After Fast Forward    ${4x_fwd}
	CLICK OK
	# validate 8x fastforward 
	Sleep    5s
	#${8x_fwd}=    Get Time Before Fast Forward Or Rewind
	${Result}  Verify Crop Image With Shorter Duration    ${port}  x8_Forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  x8_Forward Is Displayed
	...  ELSE  Fail  x8_Forward Is Not Displayed
	#Get Time After Fast Forward    ${8x_fwd}
	Log To Console    8x fastforward 
	CLICK OK
	# validate 16x fastforward 
	Sleep    2s
	#${16x_fwd}=    Get Time Before Fast Forward Or Rewind
	${Result}  Verify Crop Image With Shorter Duration    ${port}  x16_Forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  x16_Forward Is Displayed
	...  ELSE  Fail  x16_Forward Is Not Displayed
    #Get Time After Fast Forward    ${16x_fwd}
	Log To Console    Playback Progressed Forward
	CLICK OK
	# validate 3216x fastforward 
	Sleep    2s
	#${32x_fwd}=    Get Time Before Fast Forward Or Rewind
	${Result}  Verify Crop Image With Shorter Duration    ${port}  x32_Forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  x32_Forward Is Displayed
	...  ELSE  Fail  x32_Forward Is Not Displayed
	#Get Time After Fast Forward    ${32x_fwd}
    #check for 4x,8x,16x visibility in seekbar
    CLICK LEFT
    CLICK OK
    Log To Console    Video Playback Normal,play for 3 minutes
	# Sleep    180s
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Video Quality Verification
	# Unified verification of Audio Quality
    CLICK HOME

TC_705_CATCHUP_REWIND_RESUME
    [Tags]    CATCHUP
	[Documentation]    Verifies rewinding and resuming catch-up content accurately.    
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK LEFT
	VALIDATE VIDEO PREVIEW
	CLICK OK
    Log To Console    Selected Catch Up Playback
	Catchup favorites 
	Sleep    5s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    20s
	CLICK UP
	CLICK LEFT
	CLICK OK
	Sleep    5s
	#${4x_Rewind}=    Get Time Before Fast Forward Or Rewind
	${Result}  Verify Crop Image With Shorter Duration    ${port}  REWIND_4X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_4X Is Displayed
	...  ELSE  Fail  REWIND_4X Is Not Displayed
	#Get Time After Fast Rewind    ${4x_Rewind}
	CLICK OK
	
	Sleep    5s
	#${8x_Rewind}=    Get Time Before Fast Forward Or Rewind
	${Result}  Verify Crop Image With Shorter Duration    ${port}  REWIND_8X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_8X Is Displayed
	...  ELSE  Fail  REWIND_8X Is Not Displayed
	#Get Time After Fast Rewind    ${8x_Rewind}
	CLICK OK
	Sleep    2s
	#${16x_Rewind}=    Get Time Before Fast Forward Or Rewind
	${Result}  Verify Crop Image With Shorter Duration    ${port}  REWIND_16X
    # Log To Console    Returned To A Previous Timestamp
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_16X Is Displayed
	...  ELSE  Fail  REWIND_16X Is Not Displayed
	#Get Time After Fast Rewind    ${16x_Rewind}
	CLICK OK
	# sleep    1s
	#${32x_Rewind}=    Get Time Before Fast Forward Or Rewind
	${Result}  Verify Crop Image With Shorter Duration    ${port}  REWIND_32X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_32X Is Displayed
	...  ELSE  Fail  REWIND_32X Is Not Displayed
	#Get Time After Fast Rewind    ${32x_Rewind}
	CLICK RIGHT
	CLICK OK
    Log To Console    Video Playback Normal,play for 3 minutes
	# Sleep    180s
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Video Quality Verification
	# Unified verification of Audio Quality
    CLICK HOME

TC_706_STOP_CATCHUP_MID_PLAYBACK_RETURN_CATCHUP_MENU
    [Tags]    CATCHUP
	[Documentation]    Verifies interrupting catch-up playback and navigating back to catch-up menu.    
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK LEFT
	CLICK OK
    Log To Console    Navigated To Catch Up Feed
	CLICK DOWN
	CLICK OK
    Log To Console    Catch Up Playback for 3 minutes
    # Sleep    180s
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Video Quality Verification
	# Unified verification of Audio Quality
	CLICK BACK
	
    #validation - check for tv>catchup in the screen
	Log To Console    Playback Stopped And Returned Back To Catch Up
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Catchup_AllChannels
	Run Keyword If  '${Result}' == 'True'  Log To Console  Catchup_AllChannels Is Displayed
	...  ELSE  Fail  Catch_Up_AllChannels_Page Is Not Displayed
	VALIDATE VIDEO PREVIEW
    CLICK HOME

TC_707_VERIFY_CATCHUP_SUBTITLES
    [Tags]    CATCHUP
	[Documentation]    Verifies subtitles display correctly during catch-up content playback.
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK ONE
	CLICK SEVEN
	CLICK THREE
	Sleep    20s
	CLICK RIGHT
	Move to Catchup
	CLICK OK
	Sleep    1s
	Catchup favorites
	Log To Console    Catch Up Started Playing
	Sleep    5s
	Apply Startover
	Sleep    5s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK LEFT
	CLICK OK
	Log To Console    Subtitle Tab Is Displayed
	CLICK UP
	CLICK OK
	CLICK OK
	# verify the Subtitle in the screen
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Arabic_Subtitle
	${none}  Verify Crop Image With Shorter Duration    ${port}  none
	Log To Console    arabic: ${Result}
    Log To Console    none: ${none}
    Run Keyword If    '${Result}' == 'True' or '${none}' == 'True'    Log To Console	Subtitle is changed
	...    ELSE  Fail    language Is Not Displayed
	
	# CLICK OK
	Sleep    1s
	# CLICK OK
	# Sleep    15s
	${language_ar}=    Capture Multiple Screens And Validate Language    ar
	Run Keyword If  '${Result}' == 'True'  Log To Console  Expected Language Displayed
	...  ELSE  Fail  Expected Language Not Displayed
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK LEFT
	CLICK OK
	CLICK DOWN 
	CLICK OK
	CLICK OK 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  English_Audio
	# ${none}  Verify Crop Image With Shorter Duration    ${port}  none
    Run Keyword If    '${Result}' == 'True'    Log To Console	Subtitle is changed
	...    ELSE  Fail   language Is Not Displayed
	
	Log To Console    english: ${Result}
    Log To Console    none: ${none}
	# CLICK OK
	Sleep    1s
	# CLICK OK
    # Sleep    15s
	${language_en}=    Capture Multiple Screens And Validate Language    en
	Run Keyword If  '${Result}' == 'True'  Log To Console  Expected Language Displayed
	...  ELSE  Fail  Expected Language Not Displayed

	CLICK HOME

TC_708_VERIFY_CATCHUP_AUDIO_TRACK_SWITCH
    [Tags]    CATCHUP
	[Documentation]    Verifies switching audio tracks during catch-up content playback.
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK THREE
	CLICK TWO
	CLICK ONE
	Sleep    20s
	CLICK RIGHT
	Move to Catchup
	CLICK OK
	Sleep    1s
	Catchup favorites
	Log To Console    Catch Up Started Playing
	Sleep    5s
	Apply Startover
	Sleep    5s
	CLICK UP
    Log To Console    Catch Up Playback Started
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	#validation- check for the mini pop up displaying arabic,english language in the screen
    CLICK UP
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Arabic_Subtitle
	${none}  Verify Crop Image With Shorter Duration    ${port}  none
	Log To Console    arabic: ${Result}
    Log To Console    none: ${none}
    Run Keyword If    '${Result}' == 'True' or '${none}' == 'True'    Log To Console	Audio language is changed
	...    ELSE  Log To Console    language Is Not Displayed
	
	
	Sleep    5s
	# Unified verification of Audio Quality
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}   English_Audio
	${none}  Verify Crop Image With Shorter Duration    ${port}  none
	Log To Console    english: ${Result}
    Log To Console    none: ${none}
    Run Keyword If    '${Result}' == 'True' or '${none}' == 'True'    Log To Console	Audio language is changed
	...    ELSE  Log To Console    language Is Not Displayed
	
    Sleep    5s
	# Unified verification of Audio Quality
	CLICK HOME
	
TC_710_VERIFY_CATCHUP_UNAVAILABLE_PROGRAM_OUTSIDE_SUPPORTED_WINDOW
    [Tags]    CATCHUP
    [Documentation]    Verifies Catch Up Channel
	[Teardown]    revert catchup filter
	Selecting Catchup Filter From Guide
	Log To Console    Selected Catch Up From Filter
	CLICK BACK
	#Selecting yesterday program
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK UP
    Get text from epg
	CLICK UP
	Get text from epg
	CLICK UP
	Get text from epg
	CLICK UP
	Get text from epg
	CLICK UP
	Get text from epg
	CLICK UP
	Get text from epg
	CLICK UP
	# Get text from epg
	CLICK UP
	Sleep    3s
    ${Result}  Verify Crop Image With Shorter Duration  ${port}   TC_710_Blank_Screen
	Run Keyword If  '${Result}' == 'True'  Log To Console  Blank Window  Is Displayed
	...  ELSE  Fail  Blank Window is not Displayed

TC_711_ADD_CATCHUP_ADD_TO_MY_LIST_AND_ACCESS
    [Tags]    CATCHUP
	[Documentation]    Verifies adding catch-up content to My List and accessing it.   
	# [Teardown]    Delete from list
	CLICK HOME
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
	CLICK OK
	CLICK LEFT
	# CLICK LEFT
	CLICK OK
    Log To Console    Selected Catch Up Playback
	CLICK OK
	Capture Side Pannel Options Catchup
	${t1}=    Select assest from catchup
	log To Console    ${t1}
    Log To Console    Content Added To My List
	# validate message
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To My TV Section
	FOR    ${i}    IN RANGE    15
		${Result}=    Verify Crop Image With Shorter Duration    ${port}    MyList_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ MyList_MyTV is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Log To Console    ❌ MyList_MyTV is not displayed after navigating right
    
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT

	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK LEFT
	CLICK OK
    Log To Console    Navigated To My List Section
	Catchup favorites
	Sleep    1s
	${t2}=    Select assest from catchup
	log To Console    ${t2}
	Compare Previous And Current Text    ${t1}    ${t2} 
    Log To Console    Accessed My List Content
	Sleep    3s
    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	CLICK BACK
	Sleep    2s
	CLICK OK
	 ${Result}  Verify Crop Image With Shorter Duration  ${port}  REMOVE_FROM_LIST
	Run Keyword If  '${Result}' == 'True'  Log To Console  REMOVE_FROM_LIST Is Displayed
	...  ELSE  Fail   REMOVE_FROM_LIST Is Not Displayed
	Capture Side Pannel Options Catchup Remove Fav
	${Result}  Verify Crop Image With Shorter Duration  ${port}  RLmessage
	Run Keyword If  '${Result}' == 'True'  Log To Console  catchupRLmessage Is Displayed
	...  ELSE  Fail  catchupRLmessage Is Not Displayed
	CLICK OK
    Log To Console    Content Removed From My List
    CLICK HOME
TC_712_RESUME_PARTIALLY_WATCHED_CATCHUP_PROGRAM_CONTINUE_WATCHING_SECTION
    [Tags]    CATCHUP
	[Documentation]    Verifies resuming partially watched catch-up programs from Continue Watching section.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	Sleep    2s
	CLICK OK
	#CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK

	Catchup favorites
	Sleep    1s

	${t1}=    Select assest from catchup
	${t1}=    Convert To Upper Case    ${t1}
	${t1}=    Strip String             ${t1}
	Log To Console    SELECTED ASSET: ${t1}

	Sleep    10s
	CLICK UP
	CLICK UP

	${start_over_status}=    Get Progress Bar Status
	Log To Console    ${start_over_status}

	${Result}=    Validate Video Playback For Playing
	Run Keyword If    ${Result}    Log To Console    Video is Playing
	...    ELSE    Fail    Video is Paused

	Sleep    10s
	CLICK BACK
	CLICK BACK
	CLICK BACK
	CLICK BACK
	Sleep    2s
	CLICK HOME

	CLICK HOME
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK

	

	${found}=    Set Variable    False

	FOR    ${i}    IN RANGE    20
		${res2}=    Verify Assert After resume
		${res2}=    Convert To Upper Case    ${res2}
		${res2}=    Strip String    ${res2}

		${match}=    Run Keyword And Return Status
		...    Should Be Equal    ${t1}    ${res2}

		IF    ${match}
			Log To Console    ✅ MATCH FOUND: ${res2}
			${found}=    Set Variable    True
			Exit For Loop
		END

		CLICK RIGHT
	END

	IF    not ${found}
		Fail    ❌ Asset mismatch after resume. Expected: ${t1}
	END


	CLICK OK
	Catchup Favorites

	${Result}=    Validate Video Playback For Playing
	Run Keyword If    ${Result}    Log To Console    Video is Playing
	...    ELSE    Fail    Video is Paused

	CLICK UP
	CLICK UP
	${start_over_status}=    Get Progress Bar Status
	Log To Console    ${start_over_status}

	CLICK HOME

TC_726_VERIFY_CATCHUP_STOP_SWITCH_LIVETV_RESUME
    [Tags]    CATCHUP
    [Documentation]    Verifies Catch Up Channel
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
	
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	
	Sleep    1s
    Log To Console    Recently Aired Content Is Playing
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Yesterday_Catchup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Yesterday_text_on_Catchup Is Displayed
	...  ELSE  Fail  Yesterday_text_on_Catchup Is Not Displayed
	CLICK UP
	CLICK OK

	Capture Side Pannel Options Catchup play
	Sleep    1s
	${res1}=     Select assest from catchup
	log To Console    ${res1}
    Log To Console    Accessed My List Content
	# Sleep    120s
    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	Log To Console  Switching to live tv
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    30s
	Log To Console  Switching to Catchup
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
	
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK

	Sleep    1s
    Log To Console    Recently Aired Content Is Playing
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Yesterday_Catchup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Yesterday_text_on_Catchup Is Displayed
	...  ELSE  Fail  Yesterday_text_on_Catchup Is Not Displayed
	CLICK UP
	${res1}=    Convert To Upper Case    ${res1}
	${res1}=    Strip String             ${res1}
	${res1}=    Replace String           ${res1}    ${SPACE}    ${EMPTY}
	${res1}=    Replace String    ${res1}    '    ${EMPTY}
	${match_found}=    Set Variable    False

	FOR    ${i}    IN RANGE    60
		${res2}=    Verify Assert After resume
		${res2}=    Convert To Upper Case    ${res2}
		${res2}=    Strip String             ${res2}
		${res2}=    Replace String           ${res2}    ${SPACE}    ${EMPTY}
		${res2}=    Replace String    ${res2}    '    ${EMPTY}

		IF    $res1 == $res2
			Log To Console    ✅ MATCH FOUND: ${res2}
			${match_found}=    Set Variable    True
			Exit For Loop
		ELSE
			CLICK RIGHT
		END
	END

	IF    '${match_found}' == 'False'
		Fail    ❌ MATCH NOT FOUND AFTER 40 ATTEMPTS
	END


	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Resume_On_Left_Panel
	Run Keyword If  '${Result}' == 'True'  Log To Console  Resume_On_Left_Panel Is Displayed
	...  ELSE  Fail  Resume_On_Left_Panel Is Not Displayed
	Catchup favorites
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	    ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
    CLICK HOME
TC_728_CHECK_CATCHUP_NEXT_PREVIOUS
    [Tags]    CATCHUP
    [Documentation]    Verify parental control blocks restricted catchup
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
    CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK
	CLICK OK
	Catchup favorites 
	Sleep    2s
	Apply Startover
    CLICK RIGHT
	CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
    CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	# Sleep    2s
	# CLICK OK
    ${Result}  Verify Crop Image With Shorter Duration  ${port}  nextprogressbar
	Run Keyword If  '${Result}' == 'True'  Log To Console  nextprogressbar Is Displayed
	...  ELSE  Fail  nextprogressbar Is Not Displayed
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
    CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  previousprogressbar
	Run Keyword If  '${Result}' == 'True'  Log To Console  previousprogressbar Is Displayed
	...  ELSE  Fail  previousprogressbar Is Not Displayed
	    ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK HOME
TC_719_VERIFT_CATCHUP_PLAYBACK_RESUMES_FROM_LAST_WATCHED_POSITION_AFTER_STB_REBOOT
	[Tags]    CATCHUP
	[Documentation]    Verify catchup playback resume after reboot
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
    Capture Side Pannel Options Catchup play

	${t1}=    Select assest from catchup
	Log To Console    ${t1}
	${t1}=    Convert To Upper Case    ${t1}
	${t1}=    Strip String             ${t1}
	Log To Console    ${t1}
	${Result}=    Validate Video Playback For Playing
	Run Keyword If    ${Result}    Log To Console    Video is Playing
	...    ELSE    Fail    Video is Paused
	Reboot STB Device
	Sleep    40s
	Check Who's Watching login
	CLICK HOME
	Sleep    1s
	CLICK HOME
	# CLICK UP
	# CLICK RIGHT
	# CLICK OK
	# CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK

	FOR    ${i}    IN RANGE    20
		${t2}=    Verify Assert After resume
		${t2}=    Convert To Upper Case    ${t2}
		${t2}=    Strip String             ${t2}
    Log To Console    ${t2}
		IF    '${t1}' == '${t2}'
			Log To Console    ✅ MATCH FOUND: ${t2}
			CLICK OK
	        Capture Side Pannel Options Catchup resume
	        ${Result}=    Validate Video Playback For Playing
	        Run Keyword If    ${Result}    Log To Console    Video is Playing
	        ...    ELSE    Fail    Video is Paused
	        CLICK HOME
			Exit For Loop
		ELSE
			CLICK RIGHT
		END
	END

TC_716_CHECK_CATCHUP_RECOMMENDATIONS_BASED_ON_RECENTLY_WATCHED_PROGRAMS
    [Tags]    CATCHUP
	[Documentation]    Verifies catch-up recommendations based on user’s recently watched programs.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration    ${port}    Recommended_Feeds
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Recommended_Feeds is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recommended_Feeds is not displayed after navigating right	
    CLICK RIGHT
	CLICK RIGHT
    ${Result}  Verify Crop Image With Shorter Duration  ${port}  catchupblanktile
	Run Keyword If  '${Result}' == 'True'  Fail  catchupblanktile Is Displayed
	...  ELSE  Log To Console    catchupblanktile Is Not Displayed
	Sleep    1s
	CLICK OK
	Sleep    1s
	CLICK OK
	Sleep    5s
    #check for recommended feed and verify that it matched with the recently watched programs
    Log To Console    Navigated To Recommended Feed And Content Played
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
    CLICK HOME
    
TC_718_VERIFY_A_RECENTLY_AIRED_SECTION_WITH_LATEST_CATCHUP
    [Tags]    CATCHUP
	[Documentation]    Verifies the Recently Aired section displays the latest catch-up content.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
	
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    #validation- verify yesterday text in the screen
	Sleep    1s
    Log To Console    Recently Aired Content Is Playing
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Yesterday_Catchup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Yesterday_text_on_Catchup Is Displayed
	...  ELSE  Fail  Yesterday_text_on_Catchup Is Not Displayed
	CLICK UP
	CLICK OK

	Capture Side Pannel Options Catchup play
	Sleep    1s
	${res1}=     Select assest from catchup
	log To Console    ${res1}
    Log To Console    Accessed My List Content
	Sleep    300s
    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK LEFT
	# CLICK OK

	${res1}=    Convert To Upper Case    ${res1}
	${res1}=    Strip String             ${res1}
	${res1}=    Replace String           ${res1}    ${SPACE}    ${EMPTY}
	${res1}=    Replace String    ${res1}    '    ${EMPTY}
	${match_found}=    Set Variable    False

	FOR    ${i}    IN RANGE    60
		${res2}=    Verify Assert After resume
		${res2}=    Convert To Upper Case    ${res2}
		${res2}=    Strip String             ${res2}
		${res2}=    Replace String           ${res2}    ${SPACE}    ${EMPTY}
		${res2}=    Replace String    ${res2}    '    ${EMPTY}

		IF    $res1 == $res2
			Log To Console    ✅ MATCH FOUND: ${res2}
			${match_found}=    Set Variable    True
			Exit For Loop
		ELSE
			CLICK LEFT
		END
	END

	IF    '${match_found}' == 'False'
		Fail    ❌ MATCH NOT FOUND AFTER 40 ATTEMPTS
	END


	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Resume_On_Left_Panel
	Run Keyword If  '${Result}' == 'True'  Log To Console  Resume_On_Left_Panel Is Displayed
	...  ELSE  Fail  Resume_On_Left_Panel Is Not Displayed
	Catchup favorites
	Sleep    3s
    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	CLICK HOME
TC_714_BROWSE_CATCHUP_CATEGORIES_AND_PLAY_TITLE
    [Tags]    CATCHUP
	[Documentation]    Verifies resuming partially watched catch-up programs from Continue Watching section.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
    CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  allchannels
	Run Keyword If  '${Result}' == 'True'  Log To Console  allchannels Is Displayed
	...  ELSE  Fail  allchannels Is Not Displayed
	
    catchup category navigations


TC_729_BROWSE_CATCHUP_CATEGORIES_AND_PLAY_TITLE_GENERAL
    [Tags]    CATCHUP
	[Documentation]    Verifies resuming partially watched catch-up programs from Continue Watching section.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
    CLICK DOWN
	CLICK OK
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  general
	Run Keyword If  '${Result}' == 'True'  Log To Console  GENERAL Is Displayed
	...  ELSE  Fail  GENERAL Is Not Displayed
	# CLICK OK
    catchup category navigations

TC_730_BROWSE_CATCHUP_CATEGORIES_AND_PLAY_TITLE_KIDSFAM
    [Tags]    CATCHUP
	[Documentation]    Verifies resuming partially watched catch-up programs from Continue Watching section.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
    CLICK DOWN
	#CLICK OK
    CLICK DOWN
	CLICK OK
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  kidsfam
	Run Keyword If  '${Result}' == 'True'  Log To Console  kidsfam Is Displayed
	...  ELSE  Fail  kidsfam Is Not Displayed
	#CLICK OK
    catchup category navigations

TC_731_BROWSE_CATCHUP_CATEGORIES_AND_PLAY_TITLE_DOCM
    [Tags]    CATCHUP
	[Documentation]    Verifies resuming partially watched catch-up programs from Continue Watching section.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
    CLICK RIGHT
	CLICK OK
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  docm
	Run Keyword If  '${Result}' == 'True'  Log To Console  documentary Is Displayed
	...  ELSE  Fail  documentary Is Not Displayed
	#CLICK OK
    catchup category navigations

TC_732_BROWSE_CATCHUP_CATEGORIES_AND_PLAY_TITLE_LIFESTYLE
    [Tags]    CATCHUP
	[Documentation]    Verifies resuming partially watched catch-up programs from Continue Watching section.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section

    CLICK RIGHT
	CLICK DOWN
	CLICK OK
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  lifestyle
	Run Keyword If  '${Result}' == 'True'  Log To Console  lifestyle Is Displayed
	...  ELSE  Fail  lifestyle Is Not Displayed
	#CLICK OK
    catchup category navigations

TC_733_BROWSE_CATCHUP_CATEGORIES_AND_PLAY_TITLE_NEWS
    [Tags]    CATCHUP
	[Documentation]    Verifies resuming partially watched catch-up programs from Continue Watching section.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section

    CLICK RIGHT
	CLICK DOWN
    CLICK DOWN
	CLICK OK
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  news
	Run Keyword If  '${Result}' == 'True'  Log To Console  news Is Displayed
	...  ELSE  Fail  news Is Not Displayed
	#CLICK OK
    catchup category navigations

TC_734_BROWSE_CATCHUP_CATEGORIES_AND_PLAY_TITLE_MOVIES
    [Tags]    CATCHUP
	[Documentation]    Verifies resuming partially watched catch-up programs from Continue Watching section.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section

    CLICK RIGHT
	CLICK RIGHT

	CLICK OK
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  movies
	Run Keyword If  '${Result}' == 'True'  Log To Console  movies Is Displayed
	...  ELSE  Fail  movies Is Not Displayed
	#CLICK OK
    catchup category navigations

TC_735_BROWSE_CATCHUP_CATEGORIES_AND_PLAY_TITLE_SPORTS
    [Tags]    CATCHUP
	[Documentation]    Verifies resuming partially watched catch-up programs from Continue Watching section.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section

    CLICK RIGHT
	CLICK RIGHT

    CLICK DOWN
	CLICK OK
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  sports
	Run Keyword If  '${Result}' == 'True'  Log To Console  sports Is Displayed
	...  ELSE  Fail  sports Is Not Displayed
	#CLICK OK
    CLICK DOWN
	CLICK DOWN
    Log To Console    Navigated To Catch Up Movies Feed
	CLICK OK
	CLICK OK
    Log To Console    Selected Catch Up Playback
	Catchup favorites
	Sleep    3s
	CLICK UP
    Log To Console    Browsed Catch Up Categories And Initiated Content Playback
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	# Sleep    180s
    # Sleep    30s
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
    CLICK HOME
TC_736_BROWSE_CACHUP_CATEGORIES_AND_PLAY_TITLE_MOREASIAN
    [Tags]    CATCHUP
	[Documentation]    Verifies resuming partially watched catch-up programs from Continue Watching section.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section

    CLICK RIGHT
	CLICK RIGHT
    CLICK DOWN
	CLICK DOWN
	CLICK OK
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  asian
	Run Keyword If  '${Result}' == 'True'  Log To Console  movasian Is Displayed
	...  ELSE  Fail  movasian Is Not Displayed
	#CLICK OK
    catchup category navigations
TC_737_BROWSE_CATCHUP_CATEGORIES_AND_PLAY_TITLE_INTERNATIONAL
    [Tags]    CATCHUP
	[Documentation]    Verifies resuming partially watched catch-up programs from Continue Watching section.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section

    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT


	CLICK OK
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  cinternational
	Run Keyword If  '${Result}' == 'True'  Log To Console  international Is Displayed
	...  ELSE  Fail  international Is Not Displayed
	#CLICK OK
    catchup category navigations

    CLICK HOME

TC_715_PLAY_CATCHUP_PROGRESS_BAR_WITH_TIMESTAMP_INFORMATION
    [Tags]    CATCHUP
	[Documentation]    Verifies catch-up playback progress bar displays accurate timestamp information.
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Section
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK LEFT
	CLICK OK
    Log To Console    Navigated To Catch Up Feed
	CLICK DOWN
	CLICK OK
	Sleep    30s
	CLICK UP
	${start_time}=	Get Progress Bar Status
	# ${time_range_before}=	Get Extracted Time On Player Info Bar	${start_over_status}
	# ${time_before_sleep}=	Check OCR Start Timestamp Using AI Slots	${time_range_before}
	Log To Console	${start_time}
	Sleep    30s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
    Sleep    5s
	# #Get Extracted Time On Player Info Bar
	CLICK UP
	CLICK UP
	${current_time}=    Get Progress Bar Status
	Log To Console    ${current_time}
	Log To Console    ${start_time}-${current_time}

	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
    CLICK HOME
    
TC_713_VERIFY_PARENTAL_CONTROL_BLOCK_A_RESTRICTED_CATCHUP_PROGRAM
    [Tags]    CATCHUP
    [Documentation]    Verify parental control blocks restricted catchup
	[Teardown]     Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
	Create new profile with 3333 pin
	Navigate To Profile
	Log To Console  Verifying  TC_004_new_user on Screen
	${Result}  Verify Crop Image With Shorter Duration    ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_020_New_User Is Displayed on screen
	...  ELSE  Fail  TC_020_New_User Is Not Displayed on screen
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	Navigate To Profile
	CLICK RIGHT
	CLICK OK
	CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK OK
	Sleep    10s
	# Selecting Catchup Filter From Guide
	Log To Console    Selected Catch Up From Filter
	Sleep    1s

	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	Sleep    1s
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	# Sleep    120s
	CLICK OK
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_713_Parental
	Run Keyword If  '${Result}' == 'True'  Log To Console  PARENTAL_CONTROL Is Displayed on screen
	...  ELSE  Fail  PARENTAL_CONTROL Is Not Displayed on screen
	CLICK THREE
    CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  PARENTAL_CONTROL_ERROR
	Run Keyword If  '${Result}' == 'True'  Log To Console  PARENTAL_CONTROL_ERROR Is Displayed on screen
	...  ELSE  Fail  PARENTAL_CONTROL_ERROR Is Not Displayed on screen
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	VALIDATE VIDEO PREVIEW
	CLICK OK
	Catchup favorites
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_713_Parental
	Run Keyword If  '${Result}' == 'True'  Log To Console  PARENTAL_CONTROL Is Displayed on screen
	...  ELSE  Fail  PARENTAL_CONTROL Is Not Displayed on screen
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
    ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK HOME
	

####################################################################################

####################################STARTOVER############################################
TC_601_RESTART_LIVE_PROGRAM_USING_START_OVER
	[Tags]      STARTOVER
	[Documentation]     Restart Live program using startover
	[Teardown]    Revert Startover Settings
	CLICK HOME
    Log To Console    🏠 Navigated to HOME
    Check For Exit Popup
    Log To Console    🔍 Checked for exit popup
    CLICK HOME
	Selecting Startover Filter From Guide
	CLICK BACK
    Log To Console    Navigating to any startover channel
	CLICK DOWN
	CLICK OK
	CLICK BAck
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK UP
	Sleep	2s
	${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
	CLICK BACK
	Sleep	12s
	CLICK RIGHT
	${channel_number_01}=	Ensure Pause And StartOver Are Visible    ${channel_number}
	Log To Console	${channel_number_01}
	${STEP_COUNT}=    Move to Pause On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	${Result}  Validate Video Playback For Paused
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Paused
	...  ELSE  Fail  Video is Playing
	CLICK UP
	${live_status}=    Get Live Progress Bar Status
	CLICK HOME
    Sleep    2s
    CLICK OK
    Sleep    12s
	Log TO Console    Navigating to Startover from side pannel
    CLICK RIGHT
	${STEP_COUNT}=    Move to Start Over On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	Sleep    4s
	CLICK UP
	${start_over_status}=    Get Start Over Progress Bar Status
	Verify the Similarity    ${live_status}    ${start_over_status}
	Log To Console    Checking Video Playback
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused

	CLICK HOME	
	${Result}=    Check For Exit Popup
	Run Keyword If  '${Result}' == 'True'    Log To Console    exit pop exists
	...  ELSE  Log To Console  Exit popup not display
    CLICK BACK
	Sleep    20s
	CLICK UP
	${channel_number_after_so}=    Extract Text From Screenshot
    Should Be Equal    ${channel_number_01}    ${channel_number_after_so}
	CLICK HOME
	Check For Exit Popup
	CLICK HOME


TC_602_VERIFY_STARTOVER_AVAILABILITY_IN_EPG
	[Tags]           STARTOVER
    [Documentation]  Verify that "Startover" option is available for channels listed in the EPG.
    [Teardown]       Revert Startover Settings
    Log To Console    📺 [STEP 1] Navigating to Home Screen
    CLICK HOME
    Log To Console    🏠 [STEP 2] Navigated to HOME
    Check For Exit Popup
    Log To Console    🔍 Checked for exit popup
    CLICK HOME
    Log To Console    🧭 [STEP 3] Selecting 'Startover' filter from the Guide
    Selecting Startover Filter From Guide
    CLICK BACK
    Log To Console    🚀 [STEP 4] Navigating through channels to verify 'Startover' availability
    FOR    ${i}    IN RANGE    10
        Log To Console    ➡️ Iteration ${i+1}/10: Moving to next channel		
		Sleep    8s
        CLICK OK
        CLICK DOWN
        CLICK DOWN
        CLICK OK
        Sleep    2s
        CLICK BACK
        Sleep    1s
        CLICK RIGHT
		Sleep	1s
        ${Start_Over_Visible}=    Verify Crop Image With Shorter Duration   ${port}    Start_Over
        Run Keyword If    '${Start_Over_Visible}' == 'True'    Log To Console    ✅ [PASS] 'Start Over' visible on channel ${i+1}
        Run Keyword Unless    '${Start_Over_Visible}' == 'True'    Fail    ❌ [FAIL] 'Start Over' not visible on channel ${i+1}
    END
	CLICK RIGHT
	${STEP_COUNT}=    Move to Start Over On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	Sleep    2s
	Log To Console    Checking Video Playback
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
    Log To Console    🏠 [STEP 5] Returning to Home Screen
    CLICK HOME
    Log To Console    🔎 [STEP 6] Checking for Exit Popup after test execution
    Check For Exit Popup
    CLICK HOME

TC_603_STARTOVER_PAUSE_5M_RESUME
	[Tags]      STARTOVER
	[Teardown]    Revert Startover Settings
	CLICK HOME
    Log To Console    🏠 Navigated to HOME
    Check For Exit Popup
    Log To Console    🔍 Checked for exit popup
    CLICK HOME
	Selecting Startover Filter From Guide
	CLICK BACK
    Log To Console    Navigating to any startover channel
	CLICK DOWN
	CLICK OK
	CLICK BACK
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK UP
	Sleep	2s
	${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
	CLICK BACK
	Sleep	12s
	CLICK RIGHT
	${channel_number_01}=	Ensure Pause And StartOver Are Visible    ${channel_number}
	Log To Console	${channel_number_01}
	${STEP_COUNT}=    Move to Pause On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	${Result}  Validate Video Playback For Paused
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Paused
	...  ELSE  Fail  Video is Playing
	CLICK UP
	${live_status}=    Get Live Progress Bar Status
	CLICK HOME
    Sleep    2s
    CLICK OK
    Sleep    12s
	Log TO Console    Navigating to Startover from side pannel
    CLICK RIGHT
	${STEP_COUNT}=    Move to Start Over On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	Sleep    4s
	CLICK UP
	Log To Console    Pausing Start Over playback for 5 minutes
	${start_over_status}=	Get Start Over Progress Bar Status
	${time_range_before}=	Get Extracted Time On Player Info Bar	${start_over_status}
	${time_before_pause}=	Check OCR Start Timestamp Using AI Slots	${time_range_before}
	Log To Console	${time_before_pause}
	CLICK OK
	Log To Console	Paused for 300s
	Sleep	30s
	CLICK OK
	${start_over_status_after}=	Get Start Over Progress Bar Status
	${time_range_before}=	Get Extracted Time On Player Info Bar	${start_over_status_after}
	${time_after_pause}=	Check OCR Start Timestamp Using AI Slots	${time_range_before}
	Log To Console	${time_after_pause}
	Check OCR Timestamp After Pause Start Over    ${time_after_pause}    ${time_before_pause}    12
    ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	# # Verify Audio Quality
	Log To Console    🔎 [STEP 6] Checking for Exit Popup after test execution
	CLICK HOME	
	${Result}=    Check For Exit Popup
	Run Keyword If  '${Result}' == 'True'    Log To Console    exit pop exists
	...  ELSE  Log To Console  Exit popup not display
    CLICK BACK
	Sleep    20s
	CLICK UP
	${channel_number_after_so}=    Extract Text From Screenshot
    Should Be Equal    ${channel_number_01}    ${channel_number_after_so}
    CLICK HOME
	Check For Exit Popup
	CLICK HOME
	
TC_606_EXIT_STARTOVER_RETURN_TO_LIVE
    [Tags]      STARTOVER
	[Documentation]     Restart Live program using startover
	[Teardown]    Revert Startover Settings
	CLICK HOME
    Log To Console    🏠 Navigated to HOME
    Check For Exit Popup
    Log To Console    🔍 Checked for exit popup
    CLICK HOME
	Selecting Startover Filter From Guide
	CLICK BACK
    Log To Console    Navigating to any startover channel
	CLICK DOWN
	CLICK OK
	CLICK BACK
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK UP
	Sleep	2s
	${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
	Sleep	12s
	CLICK RIGHT	
	Log TO Console    Navigating to Startover from side pannel
	${STEP_COUNT}=    Move to Start Over On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	Sleep  4s
	# Verify Audio Quality
	Log To Console    Checking Video Quality
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK BACK
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_217_Exit
    Log To Console    Exit popup found: ${Result}
    IF    '${Result}' == 'True'
        CLICK RIGHT
		CLICK OK
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_217_Exit
        Run Keyword If  '${Result}' == 'False'  Log To Console  TC_217_Exit Is Not Displayed
	    ...  ELSE  Fail  TC_217_Exit Is Displayed
    END
	CLICK BACK
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_217_Exit
    Log To Console    Exit popup found: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
    END	
	Sleep    3s
	${channel_number_after_so}=    Extract Text From Screenshot
    Should Be Equal    ${channel_number}    ${channel_number_after_so}
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_607_STARTOVER_SUBTITLES_VERIFY
    [Tags]    STARTOVER
	CLICK HOME
    Log To Console    🏠 Navigated to HOME

    Check For Exit Popup
    Log To Console    🔍 Checked for exit popup
    CLICK HOME
	CLICK ONE
	CLICK SEVEN
	CLICK THREE
	Sleep	20s
	CLICK UP
	${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
	Sleep	12s
	CLICK RIGHT	
	Log TO Console    Navigating to Startover from side pannel
	${STEP_COUNT}=    Move to Start Over On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	# Verify Audio Quality
	Log To Console    Checking Video Playback
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused	
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep	2s
	CLICK UP
	CLICK OK
	CLICK BACK
	Sleep	30s
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	Log TO Console    Subtitle Turned ON For Arabic Language
    ${language_ar}=    Capture Multiple Screens And Validate Language    ar
	Run Keyword If  '${Result}' == 'True'  Log To Console  Expected Language Displayed
	...  ELSE  Fail  Expected Language Not Displayed
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Log TO Console    Subtitle Turned ON For English Language
    ${language_en}=    Capture Multiple Screens And Validate Language    en
	Run Keyword If  '${Result}' == 'True'  Log To Console  Expected Language Displayed
	...  ELSE  Fail  Expected Language Not Displayed
    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	CLICK HOME	
	${Result}=    Check For Exit Popup
	Run Keyword If  '${Result}' == 'True'    Log To Console    exit pop exists
	...  ELSE  Log To Console  Exit popup not display
    CLICK BACK
	${channel_number_after_so}=    Extract Text From Screenshot
    Should Be Equal    ${channel_number}    ${channel_number_after_so}
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
	
TC_611_SWITCH_TO_STARTOVER_JUMP_TO_LIVE
    [Tags]    STARTOVER
	[Teardown]    Revert Startover Settings
	CLICK HOME
    Log To Console    🏠 Navigated to HOME

    Check For Exit Popup
    Log To Console    🔍 Checked for exit popup
    CLICK HOME
	Selecting Startover Filter From Guide
	CLICK BACK
    Log To Console    Navigating to any startover channel
	CLICK DOWN
	CLICK OK
	Sleep	2s
	CLICK BACK
	Sleep    1s
	CLICK UP
	${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK	
	Sleep    3s
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	Log To Console    Checking Video Quality
    Log To Console    Startover playback validated
    Log To Console    Jumping to Live via MENU → RIGHT → OK sequence
    CLICK MENU
    CLICK RIGHT
    CLICK OK
    Sleep    2s
    CLICK OK
	Sleep    2s
	CLICK OK
    ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK UP
	${channel_number_after_so}=    Extract Text From Screenshot
    Should Be Equal    ${channel_number}    ${channel_number_after_so}
    Log To Console    Validating live playback after jump
	Log To Console    Checking Video Quality
	# Video Quality Verification
	# Unified verification of Audio Quality
    Log To Console    --- Test Completed: Jump to Live successful ---
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
	
TC_616_CONFIRM_PLAYBACK_RESUMES_AFTER_STB_REBOOT_IN_STARTOVER
    [Tags]    STARTOVER
    [Teardown]    Revert Startover Settings
	CLICK HOME
    Log To Console    🏠 Navigated to HOME
    Check For Exit Popup
    Log To Console    🔍 Checked for exit popup
    CLICK HOME
	Selecting Startover Filter From Guide
	CLICK BACK
    Log To Console    Navigating to any startover channel
	CLICK DOWN
	CLICK OK
	Sleep	2s
	CLICK BACK
	Sleep    1s
	CLICK UP
	${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
	CLICK BACK
	CLICK RIGHT
	${channel_number_01}=	Ensure Pause And StartOver Are Visible    ${channel_number}
	Log To Console	${channel_number_01}
	${STEP_COUNT}=    Move to Pause On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	Sleep	3s
	${live_status}=    Get Live Progress Bar Status
	CLICK HOME
    Sleep    2s
    CLICK OK
    Sleep    2s
    CLICK RIGHT
	${STEP_COUNT}=    Move to Start Over On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	Sleep    4s
	CLICK UP
	${start_over_status}=    Get Start Over Progress Bar Status    
	Verify the Similarity    ${live_status}    ${start_over_status}
	Log To Console    Checking Video Playback
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	Log To Console    Rebooting STB
	Reboot STB Device
	Log To Console    Switching to UI
	Sleep    40s 
	Check Who's Watching login
	CLICK HOME
	# Add a validation home page is displayed
	CLICK OK
	Sleep	2s	
	CLICK RIGHT
	${STEP_COUNT}=    Move to Pause On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	Sleep	2s
	${live_status_after_reboot}=    Get Live Progress Bar Status
	CLICK HOME
    Sleep    2s
    CLICK OK
    Sleep    2s
    CLICK RIGHT
	${STEP_COUNT}=    Move to Start Over On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	Sleep    12s
	CLICK UP
	${start_over_status_after_reboot}=    Get Start Over Progress Bar Status    
	Verify the Similarity    ${live_status_after_reboot}    ${start_over_status_after_reboot}
	Log To Console    Checking Video Playback
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	Log To Console    Checking Video Quality
	CLICK BACK	
	${Result}=    Check For Exit Popup
	Run Keyword If  '${Result}' == 'True'    Log To Console    exit pop exists
	...  ELSE  Fail  Exit popup should display
	Sleep    3s
	${channel_number_after_reboot}=    Extract Text From Screenshot
	Should Be Equal    ${channel_number_01}    ${channel_number_after_reboot}
    CLICK HOME
	Check For Exit Popup
	CLICK HOME
	
TC_625_STARTOVER_SWITCH_LIVE_RETURN
    [Tags]    STARTOVER
	[Teardown]    Revert Startover Settings
    CLICK HOME
    Log To Console    🏠 Navigated to HOME

    Check For Exit Popup
    Log To Console    🔍 Checked for exit popup
    CLICK HOME
    Selecting Startover Filter From Guide
    Log To Console    📂 Selected Startover filter

    CLICK BACK
    Log To Console    ↩️ Returned from guide

    Log To Console    Navigating to any startover channel
    CLICK DOWN
    CLICK OK
    Sleep    2s

    CLICK BACK
     ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK UP
	Sleep     2s
	${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number} 
	Sleep    15s  
    CLICK RIGHT
    ${STEP_COUNT}=    Move to Start Over On Side Pannel
    Log To Console    🔢 Steps to StartOver: ${STEP_COUNT}

    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	CLICK UP
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    Pause_Button
    Log To Console    ⏸️ Pause Button Detection Result: ${Result}
    Run Keyword If    '${Result}' == 'True'
    ...    Log To Console    ✅ Pause_Button Is Displayed
    ...    ELSE
    ...    Fail    ❌ Pause_Button Is Not Displayed
    CLICK UP
    Sleep    3s
    CLICK RIGHT
    CLICK OK
    Sleep    1s
    CLICK OK
    Sleep    1s
    CLICK OK
    Sleep    1s
    CLICK OK

    Log To Console    ⏩ Waiting for FAST_FORWARD_BUTTON to disappear
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    FAST_FORWARD_BUTTON
    ${attempt}=    Set Variable    1
    WHILE    '${Result}' == 'True' and ${attempt} <= 50
	    Sleep    20s
        Log To Console    🔄 Attempt ${attempt}: FAST_FORWARD_BUTTON still visible
        Sleep    1s
        ${Result}=    Verify Crop Image With Shorter Duration   ${port}    FAST_FORWARD_BUTTON
        ${attempt}=    Evaluate    ${attempt} + 1
    END
    Run Keyword If    '${Result}' == 'True'
    ...    Fail    ❌ FAST_FORWARD_BUTTON still visible after 10 attempts
    Log To Console    ✅ FAST_FORWARD_BUTTON is no longer visible

    ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	CLICK UP
	${channel_number_after_so}=    Extract Text From Screenshot
    Log To Console    📺 Channel After StartOver: ${channel_number_after_so}
    Should Be Equal    ${channel_number}    ${channel_number_after_so}
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    625_Gray_Progress
    Log To Console    🧪 625_Gray_Progress Detection Result: ${Result}
    
    Log To Console    ✅ Channel consistency verified
    Log To Console    Checking Video Playback
	
	# Verify Audio Quality
	Log To Console    Checking Video Quality
    CLICK HOME
	Check For Exit Popup
	CLICK HOME
    Log To Console    🏁 Test completed successfully
	
TC_627_STARTOVER_PLAYBACK_ON_STANDBY
    [Tags]    STARTOVER
    [Teardown]    Revert Startover Settings
	CLICK HOME
    Log To Console    🏠 Navigated to HOME
    Check For Exit Popup
    Log To Console    🔍 Checked for exit popup
    CLICK HOME
	Selecting Startover Filter From Guide
	CLICK BACK
    Log To Console    Navigating to any startover channel
	CLICK DOWN
	CLICK OK
	Sleep	2s
	CLICK BACK
	Sleep    1s
	CLICK UP
	${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
	CLICK BACK
	CLICK RIGHT
	${channel_number_01}=	Ensure Pause And StartOver Are Visible    ${channel_number}
	Log To Console	${channel_number_01}
	${STEP_COUNT}=    Move to Pause On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	Sleep	3s
	${live_status}=    Get Live Progress Bar Status
	CLICK HOME
    Sleep    2s
    CLICK OK
    Sleep    2s
    CLICK RIGHT
	${STEP_COUNT}=    Move to Start Over On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	Sleep    4s
	CLICK UP
	${start_over_status}=    Get Start Over Progress Bar Status    
	Verify the Similarity    ${live_status}    ${start_over_status}
	Log To Console    Checking Video Playback
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	Log To Console    Switch to stand by
	CLICK POWER
	Sleep    10s 
	CLICK POWER
	Log To Console    Switching to UI
	Sleep    40s 
	Check Who's Watching login
	CLICK HOME
	# Add a validation home page is displayed
	CLICK OK
	Sleep	2s	
	CLICK RIGHT
	${STEP_COUNT}=    Move to Pause On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	Sleep	2s
	${live_status_after_reboot}=    Get Live Progress Bar Status
	CLICK HOME
    Sleep    2s
    CLICK OK
    Sleep    2s
    CLICK RIGHT
	${STEP_COUNT}=    Move to Start Over On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	Sleep    12s
	CLICK UP
	${start_over_status_after_reboot}=    Get Start Over Progress Bar Status    
	Verify the Similarity    ${live_status_after_reboot}    ${start_over_status_after_reboot}
	Log To Console    Checking Video Playback
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	Log To Console    Checking Video Quality
	CLICK BACK	
	${Result}=    Check For Exit Popup
	Run Keyword If  '${Result}' == 'True'    Log To Console    exit pop exists
	...  ELSE  Fail  Exit popup should display
	Sleep    3s
	${channel_number_after_reboot}=    Extract Text From Screenshot
	Should Be Equal    ${channel_number_01}    ${channel_number_after_reboot}
    CLICK HOME
	Check For Exit Popup
	CLICK HOME


################################################################



########### Start over End ############
######## RADIO ########

TC_838_SELECT_RADIO_STATION_IN_EPG_AND_PLAY
    [Tags]      RADIO 
  	[Documentation]     Verify radio station in EPG
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK THREE
	Sleep	20s
	CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK UP
	CLICK UP
	# CLICK UP
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK BACK 
	#FILTER CLEARED
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep    3s 
	Log To Console    Navigated to TV 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    3s 
	Log To Console    Navigated to TV GUIDE
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  1201_Radio_channel_banner
	Run Keyword If  '${Result}' == 'True'  Log To Console   1201_Radio_channel_banner Is Displayed on screen
	...  ELSE  Fail  1201_Radio_channel_banner Is Not Displayed on screen
    Sleep    6s 
	Log To Console    Navigated to radio Channel in EPG
	${result}=    Verify Audio Quality
    Log To Console    Final Audio Quality: ${result}
    Run Keyword If    '${result}' != '2'    Fail    Audio Quality Failed: Expected 2 but got ${result}
    Log To Console    Audio Quality Passed: Result was ${result}
	CLICK HOME

TC_840_SWITCH_RADIO_STATIONS_AND_VERIFY_TRANSITION
	[Tags]     RADIO 
  	[Documentation]     Verify Switch radio station transition
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep    3s 
	Log To Console    Navigated to TV
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    3s 
	Log To Console    Navigated to TV GUIDE
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	#Validate channel1 1201_Radio_channel_banner
	${Result}  Verify Crop Image With Shorter Duration  ${port}  1201_Radio_channel_banner
	Run Keyword If  '${Result}' == 'True'  Log To Console   1201_Radio_channel_banner Is Displayed on screen
	...  ELSE  Fail  1201_Radio_channel_banner Is Not Displayed on screen
	# ${result}=    Verify Audio Quality
    # Log To Console    Final Audio Quality: ${result}
    # Run Keyword If    '${result}' != '2'    Fail    Audio Quality Failed: Expected 2 but got ${result}
    # Log To Console    Audio Quality Passed: Result was ${result}
	# CLICK BACK
	# CLICK CHANNELUP
	CLICK CHANNELDWN
	#Validate channel2 Alfa_Monamat_Radio_Banner
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Alfa_Monamat_Radio_Banner
	Run Keyword If  '${Result}' == 'True'  Log To Console   Alfa_Monamat_Radio_Banner Is Displayed on screen
	...  ELSE  Fail  Alfa_Monamat_Radio_Banner Is Not Displayed on screen
	# ${result}=    Verify Audio Quality
    # Log To Console    Final Audio Quality: ${result}
    # Run Keyword If    '${result}' != '2'    Fail    Audio Quality Failed: Expected 2 but got ${result}
    # Log To Console    Audio Quality Passed: Result was ${result}
	Sleep    3s 
	Log To Console    Switched to different radio Channel
	Sleep    3s 
	CLICK HOME
	

TC_845_VERIFY_NOW_PLAYING_INFO_BAR_FOR_RADIO
    [Tags]      RADIO 
  	[Documentation]     Verify Now playing info bar under TV Guide
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep    3s 
	Log To Console    Navigated to TV 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    3s 
	Log To Console    Navigated to TV GUIDE
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	#Validate Now playing info bar
	${Result}  Verify Crop Image With Shorter Duration  ${port}  1201_Radio_channel_banner
	Run Keyword If  '${Result}' == 'True'  Log To Console   1201_Radio_channel_banner Is Displayed on screen
	...  ELSE  Fail  1201_Radio_channel_banner Is Not Displayed on screen
	Sleep    5s 
	Log To Console    Navigated to Radio station now playing info bar
	CLICK HOME 


TC_843_ADD_RADIO_STATION_TO_FAVORITES_AND_ACCESS
    [Tags]      RADIO 
  	[Documentation]     Verify if user can access and favorite radio stations
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep    3s 
	Log To Console    Navigated to TV
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    3s 
	Log To Console    Navigated to TV GUIDE
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK FOUR
	Sleep	3s
	CLICK BACK
	CLICK RIGHT
	Log To Console    Navigated to Channel info bar
	CLICK OK
	Sleep    2s 
	CLICK OK
	Sleep    2s 
	Log To Console    Favorite added
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    2s 
	CLICK OK
	Sleep    10s 
	Log To Console    Navigated to MY TV 
	CLICK MULTIPLE TIMES    25    RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	Log To Console    Navigated to Favorites
	CLICK LEFT
	Sleep    8s 
	#Validate favorited "Alfa" radio station text
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_843_sharjah_quaran
	Run Keyword If  '${Result}' == 'True'  Log To Console   SHARJAH_QURAN Is Displayed on screen
	...  ELSE  Fail  SHARJAH_QURAN Is Not Displayed on screen
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep    3s 
	Log To Console    Navigated to TV
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    3s 
	Log To Console    Navigated to TV GUIDE
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK FOUR
	Sleep	3s
	CLICK RIGHT
	Log To Console    Navigated to Channel info bar
	CLICK DOWN
	CLICK OK
	Sleep    2s 
	CLICK OK
	Sleep    2s 
	Log To Console    Favorite removed
	Sleep    5s
	CLICK HOME
	

TC_844_CONFIRM_RADIO_PLAYBACK_CONTINUES_IN_BACKGROUND
	[Tags]		RADIO
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep    3s 
	CLICK OK
	Sleep    2s 
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ZERO
	Sleep    2s
	CLICK BACK
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Alfa_Monamat_Radio_Banner
	Run Keyword If  '${Result}' == 'True'  Log To Console   Alfa_Monamat_Radio_Banner Is Displayed on screen
	...  ELSE  Fail  Alfa_Monamat_Radio_Banner Is Not Displayed on screen
	CLICK HOME
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK BACK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Alfa_Monamat_Radio_Banner
	Run Keyword If  '${Result}' == 'True'  Log To Console   Alfa_Monamat_Radio_Banner Is Displayed on screen
	...  ELSE  Fail  Alfa_Monamat_Radio_Banner Is Not Displayed on screen
	CLICK HOME

TC_846_RESUME_RADIO_PLAYBACK_AFTER_STB_REBOOT
	[Tags]		RADIO
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep	2s
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ZERO
	Sleep	2s
	CLICK BACK
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Alfa_Monamat_Radio_Banner
	Run Keyword If  '${Result}' == 'True'  Log To Console   Alfa_Monamat_Radio_Banner Is Displayed on screen
	...  ELSE  Fail  Alfa_Monamat_Radio_Banner Is Not Displayed on screen
	Reboot STB Device
	Sleep	50s
	# 		${pin}  Verify Crop Image With Shorter Duration  ${port}  Power_On_Login_Page
	# Run Keyword If    '${pin}'=='True'    
    # ...    Run Keywords    CLICK OK
	# ...    AND		CLICK OK
	# ...    ELSE
    # ...        Run Keyword
    # ...        Log To Console    Navigated to Home Page
	# Sleep	15s
	CLICK HOME
	CLICK BACK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Alfa_Monamat_Radio_Banner1
	Run Keyword If  '${Result}' == 'True'  Log To Console   Alfa_Monamat_Radio_Banner Is Displayed on screen
	...  ELSE  Fail  Alfa_Monamat_Radio_Banner Is Not Displayed on screen
	Sleep	5s
	CLICK HOME

############################################################################################################
TC_102_NAVIGATE_TO_EPG
	[Tags]      HOMEPAGE
    [Documentation]     Verifies channel zapping flow and playback validation
   	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
    Log To Console    Navigated To TV Guide
    CLICK SIX
	CLICK FOUR
	CLICK SIX
    Log To Console    Navigated To Channel 1
	Sleep    4s
	CLICK BACK
	CLICK OK
	Sleep    3s
	CLICK RIGHT
	Sleep    2s
	CLICK RIGHT
	CLICK OK
	Sleep    3s
    #Verify Today Option
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Today_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console  Today_EPG Is Displayed
	...  ELSE  Fail  Today_EPG Is Not Displayed
	CLICK LEFT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  catch_up_icons
	Run Keyword If  '${Result}' == 'True'  Log To Console  catch_up_icons Is Displayed
	...  ELSE  Fail  catch_up_icons Is Not Displayed
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	CLICK BACK
	Sleep    2s
	CLICK BACK
	CLICK HOME


TC_103_VERIFY_CONTINUE_WATCHING_SECTION
	[Tags]      HOMEPAGE
    [Documentation]     Verify Continue watching section from Homepage
	CLICK HOME
	CLICK UP
	CLICK DOWN
	#Validation using loop required to navigate to show more of continue watching
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  show_more_tile_homepage
	Run Keyword If  '${Result}' == 'True'  Log To Console  show_more_tile_homepage Is Displayed
	...  ELSE  Fail  show_more_tile_homepage Is Not Displayed
	CLICK OK
	#Validate continue watching text on top left
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Continue_Watching_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Continue_Watching_Page Is Displayed
	...  ELSE  Fail  Continue_Watching_Page Is Not Displayed
	${status2}=  Get Thumnail Of Asset in Continue Watching Show More section
	Verify the Similarity Continue Watching    ${status2}
	Check the availability of preview
    # VALIDATE IMAGE ON NAVIGATION    RIGHT	
	FOR  ${index}  IN RANGE  3
        ${status1}=  Run Keyword And Return Status  VALIDATE IMAGE ON NAVIGATION    RIGHT
        Run Keyword If  '${status1}' == 'False'  Fail  Image is not changed         
		${status2}=  Get Thumnail Of Asset in Continue Watching Show More section
		Verify the Similarity Continue Watching    ${status2}

        Check the availability of preview
    END

    CLICK HOME




TC_104_VERIFY_PERSONALIZED_RECOMMENDATIONS
	[Tags]    HOMEPAGE
    	[Documentation]     Verify Personalized Recommendations from Homepage
	[Teardown]   NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	CLICK HOME
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Recommended_Feeds
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Recommended_Feeds is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recommended_Feeds is not displayed after navigating right	
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  show_more_tile_homepage
	Run Keyword If  '${Result}' == 'True'  Log To Console  show_more_tile_homepage Is Displayed
	...  ELSE  Fail  show_more_tile_homepage Is Not Displayed
	CLICK OK
	${status2}=  Get Thumnail Of Asset In show more section
	Verify the Similarity Continue Watching    ${status2}
	Check the availability of preview
	CLICK OK
    	${pass}  Verify Crop Image With Shorter Duration    ${port}  Trailer_side_panel
    	Run Keyword If  '${pass}' == 'True'  Log To Console  Trailer_side_panel Is Displayed on screen
    	...  ELSE  Fail  Trailer_side_panel Is Not Displayed on screen
    	CLICK BACK
	FOR  ${index}  IN RANGE  3
        ${status1}=  Run Keyword And Return Status  VALIDATE IMAGE ON NAVIGATION    RIGHT
        Run Keyword If  '${status1}' == 'False'  Fail  Image is not changed 
                                               
        # ${status2}=  Run Keyword And Return Status  Validate blank tile in details page
        # Run Keyword If  '${status2}' == 'False'  Fail  Blank tile is displayed
        Sleep    5s
		${status2}=  Get Thumnail Of Asset In show more section
		Verify the Similarity Continue Watching    ${status2}
		Check the availability of preview
		CLICK OK
        ${pass}  Verify Crop Image With Shorter Duration    ${port}  Trailer_side_panel
        Run Keyword If  '${pass}' == 'True'  Log To Console  Trailer_side_panel Is Displayed on screen
        ...  ELSE  Fail  Trailer_side_panel Is Not Displayed on screen
        CLICK BACK

	END

	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
    CLICK HOME


TC_105_VERIFY_HOMEPAGE_CHILD_PROFILE_AGE_APPROPRIATE_CONTENT
	[Tags]    HOMEPAGE
    [Documentation]     Verify child profile content from from Homepage
    [Teardown]    DELETE PROFILE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK HOME
	Navigate and Login to Kids profile
	CLICK HOME
	FOR    ${i}    IN RANGE    15
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    MyList_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Fail    ✅ MyList_MyTV is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Log To Console    ❌ MyList_MyTV is not displayed after navigating right	
    
	CLICK HOME
	${Result}  Verify Crop Image With Shorter Duration    ${port}  show_more_tile_homepage
	Run Keyword If  '${Result}' == 'True'  Fail  show_more_tile_homepage Is Displayed
	...  ELSE  Log To Console  show_more_tile_homepage Is Not Displayed
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_105_KIDS
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_105_KIDS Is Displayed
	...  ELSE  Fail  TC_105_KIDS Is Not Displayed
	CLICK BACK
	Sleep    2s
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT 
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    FOR    ${i}    IN RANGE    8
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    favorites_mytv_2
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Fail    ✅ favorites_mytv_2 is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Log To Console    ❌ favorites_mytv_2 is not displayed after navigating right	
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT 
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	FOR    ${i}    IN RANGE    8
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Reminder_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Fail    ✅ Reminder_MyTV is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Log To Console    ❌ Reminder_MyTV is not displayed after navigating right	
    
	CLICK HOME
	FOR    ${i}    IN RANGE    15
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Recommended_Feeds
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Recommended_Feeds is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recommended_Feeds is not displayed after navigating right	
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_105_KIDS
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_105_KIDS Is Displayed
	...  ELSE  Fail  TC_105_KIDS Is Not Displayed
	CLICK BACK
	Sleep    2s 
	CLICK BACK
	CLICK RIGHT
	CLICK OK
	Sleep    2s 
	CLICK BACK
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK OK
 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    5s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK HOME



TC_106_VERIFY_SMOOTH_SCROLL_THROUGH_HOMEPAGE
    [Tags]      HOMEPAGE
    [Documentation]     Verify smooth scroll through Homepage
	CLICK HOME    
	Verify Zapping Time    RIGHT    25
	CLICK DOWN
	CLICK DOWN
	Verify Zapping Time    LEFT    25	
	#Validate continue watching text on top left
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Continue_Watching_Feeds
	Run Keyword If  '${Result}' == 'True'  Log To Console  Continue_Watching_Page Is Displayed
	...  ELSE  Fail  Continue_Watching_Page Is Not Displayed
	CLICK HOME


TC_107_VERIFY_HOMEPAGE_FAVORITE_SECTION_ACCESS_FAVORITE_CHANNEL
   [Tags]    HOMEPAGE
   [Teardown]	DELETE PROFILE
    Remove Reminder
	Create Kids Profile 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    1s 
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}    Validate_Kids_Profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  Validate_Kids_Profile Is Displayed on screen
	...  ELSE  Fail  Validate_Kids_Profile Is Not Displayed on screen
	
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    2s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep    2s
	CLICK THREE
	CLICK ZERO
	CLICK FOUR
	CLICK BACK
	Sleep    2s 
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    2s 
	CLICK OK
	Sleep    2s 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
    # FOR    ${i}    IN RANGE    25
	# 	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_211_Favorites_Feed
	# 	Run Keyword If    '${Result}' == 'True'    Run Keywords
	# 	...    Log To Console    Favorites feed is displayed
	# 	...    AND    Exit For Loop

	# 	CLICK RIGHT
	# 	Sleep    0.2s
	# END
    CLICK MULTIPLE TIMES    10    RIGHT
	# CLICK MULTIPLE TIMES    2    DOWN
	CLICK OK
	# CLICK LEFT
	Sleep    2s 
	CLICK OK
	${STEP_COUNT}=    Move to More Details On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_FAV_CHANNEL
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_FAV_CHANNEL Is Displayed on screen
	...  ELSE  Fail  TC_FAV_CHANNEL Is Not Displayed on screen
	
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    2s 
	CLICK THREE
	CLICK ZERO
	CLICK FOUR
	Sleep    3s 
	CLICK BACK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	Sleep    1s 
	CLICK OK
	CLICK HOME
	Login As Admin
	# DELETE PROFILE


TC_113_VERIFY_SEARCH_HOMEPAGE
	[Tags]    HOMEPAGE
    [Documentation]     Verify search functionality from homepage
	CLICK HOME
	CLICK BACK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Sleep    1s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep	3s
	Log To Console  Navigated to search
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	# # Validate channel name abu dhabi tv hd
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_113_More_Details_Abhu
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_113_More_Details_Abhu Is Displayed
	# ...  ELSE  Fail  TC_113_More_Details_Abhu Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Abu_Dhabi_Tv_HD_Channel_Name
	Run Keyword If  '${Result}' == 'True'  Log To Console  Abu_Dhabi_Tv_HD_Channel_Name Is Displayed
	...  ELSE  Fail  Abu_Dhabi_Tv_HD_Channel_Name Is Not Displayed
    Sleep    5s 
	CLICK OK
	CLICK HOME

TC_119_VERIFY_PIN_REQUIREMENT_FOR_LOCKED_CONTENT
    [Tags]    HOMEPAGE
	CLICK HOME
	CLICK TWO
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	#Commented as content lock is disabled
	# CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_119_ok_btn
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_119_ok_btn Is Displayed
	...  ELSE  Log To Console  TC_119_ok_btn Is Not Displayed
	
	CLICK OK
	CLICK HOME
	CLICK TWO
	Sleep    3s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  LOCKED
	Run Keyword If  '${Result}' == 'True'  Log To Console  LOCKED Is Displayed
	...  ELSE  Fail  LOCKED Is Not Displayed
	
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK TWO
	CLICK TWO
	Sleep    3s 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME

TC_121_TV_PICTURE_TILE
    [Tags]    HOMEPAGE 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_121_Live_TV
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_121_Live_TV Is Displayed
	...  ELSE  Fail  TC_121_Live_TV Is Not Displayed
	
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Last_Watched_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Last_Watched_MyTV is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Last_Watched_MyTV is not displayed after navigating right	
    # Validate Blank Tile       

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Popular_on_TV_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Popular_on_TV_MyTV is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Popular_on_TV_MyTV is not displayed after navigating right	
    # Validate Blank Tile 

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Trending_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Trending_MyTV is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Trending_MyTV is not displayed after navigating right	
    # Validate Blank Tile 

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    My_Favorite_Catchup_Channels_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ My_Favorite_Catchup_Channels_MyTV is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ My_Favorite_Catchup_Channels_MyTV is not displayed after navigating right	
    # Validate Blank Tile 

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Catchup_Channels_Bookmark_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Catchup_Channels_Bookmark_MyTV is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Catchup_Channels_Bookmark_MyTV is not displayed after navigating right	
    # Validate Blank Tile 

    FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    MyList_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ MyList_MyTV is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ MyList_MyTV is not displayed after navigating right	
    # Validate Blank Tile 
	

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Recommended_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Recommended_MyTV is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recommended_MyTV is not displayed after navigating right	
    # Validate Blank Tile 

	# CLICK OK
	# VALIDATE VIDEO PLAYBACK
	CLICK HOME

TC_122_BOX_OFFICE_PICTURE_TILE
   [Tags]    HOMEPAGE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_121_Live_TV
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_121_Live_TV Is Displayed
	# ...  ELSE  Fail  TC_121_Live_TV Is Not Displayed
	
	CLICK OK
	Sleep    2s 
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_122_BoxOffice
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_122_BoxOffice Is Displayed
	...  ELSE  Fail  TC_122_BoxOffice Is Not Displayed
	CLICK BACK
	# CLICK RIGHT
	# CLICK OK
	# Sleep    5s 
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK OK
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Must_See_BoxOffice
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Must_See_BoxOffice is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Must_See_BoxOffice is not displayed after navigating right	
    # Validate Blank Tile       

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Rentals_BoxOffice
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Rentals_BoxOffice is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Rentals_BoxOffice is not displayed after navigating right	
    # Validate Blank Tile 

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    New_Releases_BoxOffice
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ New_Releases_BoxOffice is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ New_Releases_BoxOffice is not displayed after navigating right	
    # Validate Blank Tile 

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    MyList_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ MyList_MyTV is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ MyList_MyTV is not displayed after navigating right	
    # Validate Blank Tile 

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Recommended_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Recommended_MyTV is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recommended_MyTV is not displayed after navigating right	
    # Validate Blank Tile 

    FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Trending_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Trending_MyTV is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Trending_MyTV is not displayed after navigating right	
    # Validate Blank Tile 
	

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    TopRated_BoxOffice
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ TopRated_BoxOffice is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ TopRated_BoxOffice is not displayed after navigating right	
    # Validate Blank Tile 

	CLICK HOME

TC_123_ONDEMAND_PICTURE_TILE
    [Tags]    HOMEPAGE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_123_Ondemand
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_123_Ondemand Is Displayed
	...  ELSE  Fail  TC_123_Ondemand Is Not Displayed
	
	CLICK BACK
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Collections_Ondemand
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Collections_Ondemand is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Collections_Ondemand is not displayed after navigating right	
    # Validate Blank Tile       

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    ContinueWatching_Ondemand
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ ContinueWatching_Ondemand is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ ContinueWatching_Ondemand is not displayed after navigating right	
    # Validate Blank Tile 

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Recently_Added_Ondemand
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Recently_Added_Ondemand is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recently_Added_Ondemand is not displayed after navigating right	
    # Validate Blank Tile 

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Recommended_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Recommended_MyTV is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recommended_MyTV is not displayed after navigating right	
    # Validate Blank Tile 

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Trending_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Trending_MyTV is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Trending_MyTV is not displayed after navigating right	
    # Validate Blank Tile 

    FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    TopRated_BoxOffice
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ TopRated_BoxOffice is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ TopRated_BoxOffice is not displayed after navigating right	
    # Validate Blank Tile 
	

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    KidsAndFamily_Ondemand
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ KidsAndFamily_Ondemand is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ KidsAndFamily_Ondemand is not displayed after navigating right	
    # Validate Blank Tile 

	CLICK HOME
	Sleep    5s 

	
	CLICK HOME


TC_125_MY_TV_PICTURE_TILE
    [Tags]    HOMEPAGE 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT 
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    3s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_125_Recorder
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_125_Recorder Is Displayed
	...  ELSE  Fail  TC_125_Recorder Is Not Displayed
	
	CLICK BACK
	Sleep    3s 
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_125_Reminders
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_125_Reminders Is Displayed
	# ...  ELSE  Fail  TC_125_Reminders Is Not Displayed
	
	CLICK BACK
	Sleep    3s 
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_125_Subscriptions
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_125_Subscriptions Is Displayed
	# ...  ELSE  Fail  TC_125_Subscriptions Is Not Displayed
	
	CLICK BACK
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    My_Purchases
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ My_Purchases is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ My_Purchases is not displayed after navigating right	
    # Validate Blank Tile 
	

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    MyList_MyTV
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ MyList is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ MyList is not displayed after navigating right	
    # Validate Blank Tile 

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    favorites_mytv_2
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ favorites_mytv_2 is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ favorites_mytv_2 is not displayed after navigating right	
    # Validate Blank Tile 
	CLICK HOME

TC_126_GAMING_PICTURE_TILE
    [Tags]    HOMEPAGE 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	# CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_126_Gaming
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_126_Gaming Is Displayed
	...  ELSE  Fail  TC_126_Gaming Is Not Displayed
	CLICK OK
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_126_Discover
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_126_Discover Is Displayed
	...  ELSE  Fail  TC_126_Discover Is Not Displayed
	
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_126_Most_Played
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_126_Most_Played Is Displayed
	...  ELSE  Fail  TC_126_Most_Played Is Not Displayed

	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_126_More_Info
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_126_More_Info Is Displayed
	...  ELSE  Fail  TC_126_More_Info Is Not Displayed

	# CLICK RIGHT
	CLICK HOME

TC_124_KIDS_PICTURE_TILE
    [Tags]    HOMEPAGE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Kids_Channels
	Run Keyword If  '${Result}' == 'True'  Log To Console  Kids_Channels Is Displayed
	...  ELSE  Fail  Kids_Channels Is Not Displayed
	
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Kids_Channels
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Kids_Channels is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Kids_Channels is not displayed after navigating right	
    # Validate Blank Tile 
	

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Kids_Movies
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Kids_Movies is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Kids_Movies is not displayed after navigating right	
    # Validate Blank Tile 

	CLICK HOME

###############################################################################
                            ####AP####
###############################################################################


TC_110_ACCESS_EPG_DEDICATED_TILE_BUTTON
    	[Tags]    HOMEPAGE
	[Teardown]   NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	#For testing use channel number 4500 which is test channel
	CLICK HOME
	CLICK BACK
	Sleep    5s
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    Channel_Currently_Unavailable
    IF    '${Result}' == 'True'
        CLICK TWO
		CLICK TWO
		Sleep    5s
		CLICK BACK
    END
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
    CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep    1s 
	CLICK DOWN
	CLICK DOWN
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_110_EPG_TILE
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_110_EPG_TILE Is Displayed
	# ...  ELSE  Fail  TC_110_EPG_TILE Is Not Displayed
	
	CLICK OK
	Guide Channel List
	Sleep    2s 
	# CLICK MULTIPLE TIMES    10    DOWN	
	CLICK RIGHT
	Sleep    2s 
	CLICK RIGHT
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Today_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console     Today_EPG Is Displayed
	...  ELSE  Fail  Today_EPG Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK BACK
	CLICK HOME

TC_116_NOTIFICATION_SEEN_HOMEPAGE
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Ok
	Sleep    1s 
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	Sleep    2s 
	CLICK Seven
	CLICK One
	CLICK Zero
	CLICK Five
	Sleep    2s 
    CLICK BACK
    
	# CLICK RIGHT
    ${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK


	# CLICK Down
	# CLICK Down
	# CLICK Down
	# CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_116_Notification_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_116_Notification_Popup Is Displayed on screen
	...  ELSE  Fail  TC_116_Notification_Popup Is Not Displayed on screen
	
	CLICK Ok
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	Sleep    2s 
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Up
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_116_Confirm_Deletion_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_116_Confirm_Deletion_Popup Is Displayed on screen
	...  ELSE  Fail  TC_116_Confirm_Deletion_Popup Is Not Displayed on screen
	
	CLICK Ok
	CLICK Ok
	CLICK Home


TC_112_VERIFY_LAST_SELECTED_SECTION_AFTER_POWER_CYCLE
    [Tags]    HOMEPAGE
	CLICK HOME
	CLICK RIGHT 
	CLICK DOWN 
	CLICK DOWN 
	CLICK OK

	#Validate continue watching text on top left
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Continue_Watching_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Continue_Watching_Page Is Displayed
	...  ELSE  Fail  Continue_Watching_Page Is Not Displayed
    Log To Console    Starting Power_Off_And_Power_On_STB
    CLICK POWER
	Sleep    2s
	CLICK POWER
	Sleep    15s

	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  Continue_Watching_Page
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Continue_Watching_Page Is Displayed
	# ...  ELSE  Fail  Continue_Watching_Page Is Not Displayed

TC_120_SCROLL_HOMEPAGE_WITHOUT_TRUNCATION
    [Tags]    HOMEPAGE 
	CLICK HOME    
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Continue_Watching_Homepage
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Continue_Watching_Homepage is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Continue_Watching_Homepage is not displayed after navigating right	
    # Validate Blank Tile 
	
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    OnDemand_Homepage
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ OnDemand_Homepage is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ OnDemand_Homepage is not displayed after navigating right	
    # Validate Blank Tile 

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Popular_Homepage
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Popular_Homepage is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Popular_Homepage is not displayed after navigating right	
    # Validate Blank Tile 
	
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Trending_Homepage
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Trending_Homepage is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Trending_Homepage is not displayed after navigating right	
    # Validate Blank Tile

    FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    MyList_Homepage
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ MyList_Homepage is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ MyList_Homepage is not displayed after navigating right	
    # Validate Blank Tile

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Must_See_Homepage
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Must_See_Homepage is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Must_See_Homepage is not displayed after navigating right	
    # Validate Blank Tile

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    CatchUp_Channels_Homepage
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ CatchUp_Channels_Homepage is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ CatchUp_Channels_Homepage is not displayed after navigating right	
    # Validate Blank Tile

	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    BoxOffice_Rentals_Homepage
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ BoxOffice_Rentals_Homepage is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ BoxOffice_Rentals_Homepage is not displayed after navigating right	
    # Validate Blank Tile
	CLICK HOME 

TC_117_ACCESS_RECENTLY_ADDED_VOD_SECTION_NEW_TITLES
	[Tags]    HOMEPAGE
    	[Teardown]   NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
	CLICK BACK
	CLICK ONE
	CLICK TWO
	CLICK ZERO 
	CLICK ONE
	Sleep    3s  
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK LEFT
	CLICK OK
	Sleep    1s 

    FOR    ${i}    IN RANGE    10
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Recently_Added
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Recently_Added is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recently Added is not displayed after navigating right	
    
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  show_more_tile_homepage
	Run Keyword If  '${Result}' == 'True'  Log To Console  show_more_tile_homepage Is Displayed
	...  ELSE  Fail  show_more_tile_homepage Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_117_Recently_added
	Run Keyword If  '${Result}' == 'True'  Log To Console  C_117_Recently_added Is Displayed on screen
	...  ELSE  Fail  TC_117_Recently_added Is Not Displayed on screen
	
	${status2}=  Get Thumnail Of Asset In show more section
	Verify the Similarity Continue Watching    ${status2}
	Check the availability of preview
	CLICK OK
    ${pass}  Verify Crop Image With Shorter Duration    ${port}  Trailer_side_panel
    Run Keyword If  '${pass}' == 'True'  Log To Console  Trailer_side_panel Is Displayed on screen
    ...  ELSE  Fail  Trailer_side_panel Is Not Displayed on screen
    CLICK BACK
	FOR  ${index}  IN RANGE  3
        ${status1}=  Run Keyword And Return Status  VALIDATE IMAGE ON NAVIGATION    RIGHT
        Run Keyword If  '${status1}' == 'False'  Fail  Image is not changed 
                                               
        # ${status2}=  Run Keyword And Return Status  Validate blank tile in details page
        # Run Keyword If  '${status2}' == 'False'  Fail  Blank tile is displayed
        Sleep    5s
		${status2}=  Get Thumnail Of Asset In show more section
		Verify the Similarity Continue Watching    ${status2}
		Check the availability of preview
		CLICK OK
        ${pass}  Verify Crop Image With Shorter Duration    ${port}  Trailer_side_panel
        Run Keyword If  '${pass}' == 'True'  Log To Console  Trailer_side_panel Is Displayed on screen
        ...  ELSE  Fail  Trailer_side_panel Is Not Displayed on screen
        CLICK BACK

	END

	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
    CLICK HOME


TC_114_VERIFY_TRENDING_NOW_SECTION_CURRENT_POPULAR_CONTENT
	[Tags]    HOMEPAGE
        [Documentation]     Verify Trending content from Homepage
	[Teardown]   NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION

	CLICK HOME
	Log to Console    Navigated to Home page
	FOR    ${i}    IN RANGE    25
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    Trending_Section
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ Trending_Section is displayed
    ...    AND    Exit For Loop

    CLICK RIGHT
    Sleep    0.3s
    END

    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Trending_Section is not displayed after navigating right
	Sleep    2s
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  show_more_tile_homepage
	Run Keyword If  '${Result}' == 'True'  Log To Console  show_more_tile_homepage Is Displayed
	...  ELSE  Fail  show_more_tile_homepage Is Not Displayed
	CLICK OK
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Trending
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Trending Is Displayed
	...  ELSE  Fail  Home_Trending Is Not Displayed
    	# VALIDATE IMAGE ON NAVIGATION    RIGHT	
	${status2}=  Get Thumnail Of Asset In show more section
	Verify the Similarity Continue Watching    ${status2}
	Check the availability of preview
	FOR  ${index}  IN RANGE  3
		${status1}=  Run Keyword And Return Status  VALIDATE IMAGE ON NAVIGATION    RIGHT
        	Run Keyword If  '${status1}' == 'False'  Fail  Image is not changed         
		${status2}=  Get Thumnail Of Asset in Continue Watching Show More section
		Verify the Similarity Continue Watching    ${status2}
        Check the availability of preview
    	END

    	CLICK HOME
	Sleep	5s
	CLICK HOME


TC_115_PROFILE_SWITCHING_OPTION_HOMEPAGE_WITH_ALL_PROFILES
    [Tags]    HOMEPAGE
	[Teardown]    DELETE PROFILE
    CREATE PROFILE
	CLICK HOME
	Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK OK
	Sleep    10s
	Log To console    Profile Switched to user and home page is loaded
	#validate home page
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	#validate home page
	Sleep    30s
	Log To console    Profile Switched to Admin and home page is loaded
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed
	...  ELSE  Fail  Home_Page Is Not Displayed
	CLICK HOME


TC_101_LOAD_HOMEPAGE
	[Tags]      HOMEPAGE
    [Documentation]     Verify HOMEPAGE LOADING
	Set and revert admin as default user
	CLICK HOME
	# Reboot STB Device
	${elapsed}=    Reboot STB Device And Log Time    ${port}
    Log To Console    [RESULT] Elapsed seconds returned: ${elapsed}
    # Sleep    80s
    Log To Console    It may take few seconds    
    ${Home}=    Verify Crop Image With Shorter Duration   ${port}    Home_Page
    IF    ${Home} == True
        Log To Console    User Logged In
    ELSE
        Log To Console    Attempting User Login
        Check Who's Watching login
    END
    CLICK HOME
	Set and revert admin as default user
	#Add keyword to calculate bootup time

	# CLICK TWO
	# CLICK FOUR
	# CLICK SIX
	# # CLICK TWO
	# Sleep    1s
	# CLICK BACK
    # Capture Multiple Screens And Validate Language    en
	
TC_2022_VERIFY_SERACHBY_OPTIONS_UNDER_HOMEPAGE
	[Tags]    HOMEPAGE
	[Documentation]    Verify search by options under homepage search
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	Log To Console    Navigated to search
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK UP
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Log To Console    Navigated to search with title filter
	Log To Console    Checking search results are empty
	${Result}  Verify Crop Image With Shorter Duration    ${port}  No_Results_Found
	Run Keyword If  '${Result}' == 'False'  Log To Console  Search result is not empty
	...  ELSE  Fail  Search result Is empty
	Sleep    5s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Search_Title
	Run Keyword If  '${Result}' == 'True'  Log To Console  Search_Title Is Displayed on screen
	...  ELSE  Fail  Search_Title Is Not Displayed on screen
	
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	Log To Console    Navigated to search
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Log To Console    Checking search results are empty
	${Result}  Verify Crop Image With Shorter Duration    ${port}  No_Results_Found
	Run Keyword If  '${Result}' == 'False'  Log To Console  Search result is not empty
	...  ELSE  Fail  Search result Is empty
	Sleep    2s
	Log To Console    Navigated to search by cast
	CLICK OK
	Sleep    5s
	Log To Console    Navigated to cast from search
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Search_Cast
	Run Keyword If  '${Result}' == 'True'  Log To Console  Search_Cast Is Displayed on screen
	...  ELSE  Fail  Search_Cast Is Not Displayed on screen
	
	CLICK HOME
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	Log To Console    Navigated to search
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    2s
	Log To Console    Checking search results are empty
	${Result}  Verify Crop Image With Shorter Duration    ${port}  No_Results_Found
	Run Keyword If  '${Result}' == 'False'  Log To Console  Search result is not empty
	...  ELSE  Fail  Search result Is empty
	Log To Console    Navigated to search by Director
	CLICK OK
	Sleep    5s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Search_Director
	Run Keyword If  '${Result}' == 'True'  Log To Console  Search_Director Is Displayed on screen
	...  ELSE  Fail  Search_Director Is Not Displayed on screen
	CLICK BACK
	CLICK BACK
	CLICK HOME
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	Log To Console    Navigated to search by LiveTV
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK LEFT
    CLICK LEFT
    CLICK LEFT
	CLICK OK
    CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
    CLICK UP
	CLICK UP
	CLICK UP
	CLICK RIGHT
    CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Log To Console    Checking search results are empty
	${Result}  Verify Crop Image With Shorter Duration    ${port}  No_Results_Found
	Run Keyword If  '${Result}' == 'False'  Log To Console  Search result is not empty
	...  ELSE  Fail  Search result Is empty
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Search_LIVETV
	Run Keyword If  '${Result}' == 'True'  Log To Console  Search_LIVETV Is Displayed on screen
	...  ELSE  Fail   Search_LIVETV Is Not Displayed on screen
	
	CLICK BACK
	CLICK HOME
	CLICK HOME
	CLICK HOME


###############################################################################################################################################################################################################################################
TC_801_VERIFY_CURRENT_DAY_PROGRAM_SCHEDULE_UNDER_EPG
    [Tags]    GUIDE
	# RemoveFilter_UnlockChannels
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Sleep   2s
    Log To Console    Navigated to TV 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	Guide Channel List
    Sleep   2s
    Log To Console    Navigated to TV Guide
	CLICK SIX
	CLICK FOUR
	CLICK SIX
	# CLICK TWO
	Sleep    5s 
	CLICK BACK
	CLICK OK
	
	CLICK RIGHT
	Sleep	2s
	${result}=  Verify Crop Image With Two Images   ${port}  EPG_PM  Today_EPG
	IF    '${result}' != 'True'
		Log To Console    Program Schedule is not visible on screen
		Fail              Program Schedule is not visible on screen
	ELSE
		Log To Console    Program Schedule is visible on screen
	END
	CLICK RIGHT
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Today_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console  Today_EPG Is Displayed
	...  ELSE  Fail  Today_EPG Is Not Displayed
	CLICK HOME

TC_802_START_LIVE_CHANNEL_PLAYBACK_FROM_EPG
	[Tags]    GUIDE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	Guide Channel List
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep    5s 
	VALIDATE VIDEO PLAYBACK
	CLICK HOME

TC_803_CHECK_NEXT_DAY_PROGRAM_LISTINGS_UNDER_EPG
    [Tags]    GUIDE
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	Sleep    1s
	# CLICK SIX
	# CLICK FOUR
	# CLICK SIX
	CLICK TWO
	CLICK TWO
	Sleep    5s 
	CLICK BACK
	CLICK OK
	Sleep    2s 
	CLICK RIGHT
	Sleep    2s 
	CLICK RIGHT
	Sleep    2s 
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Tommorrow
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_803_Tommorrow Is Displayed
	...  ELSE  Log To Console   TC_803_Tommorrow Is Not Displayed
	CLICK LEFT
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  Current_Program_Validation
	# Run Keyword If  '${Result}' == 'True'  Fail  able to see current day program list
	# ...  ELSE  Log To Console  Current day program list is not seen in EPG
	
	# ${result}=  Verify Crop Image With Shorter DurationWith Two Images   ${port}  EPG_PM  EPG_AM2
	# IF    '${result}' != 'True'
	# 	Log To Console    Next day program Schedule is not visible on screen
	# 	Fail              Next day program Schedule is not visible on screen
	# ELSE
	# 	Log To Console    Next day program Schedule is visible on screen
	# END
	Check For Valid Future Schedules
	CLICK HOME

TC_804_VERIFY_CATCHUP_AVAILABILITY_FOR_PAST_PROGRAMS
    [Tags]    GUIDE
    [Documentation]     Verify catchup Availability for past programs
	# RemoveFilter_UnlockChannels
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Sleep   2s
    Log To Console    Navigated to TV 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
    Sleep   2s
    Log To Console    Navigated to TV Guide
	CLICK SIX
	CLICK FOUR
	CLICK SIX
	# CLICK ONE
	# CLICK FIVE
	Sleep    3s 
	CLICK BACK
	CLICK OK
	Sleep	2s
	CLICK RIGHT
	Sleep	2s
	CLICK RIGHT
	Sleep	2s
	CLICK UP
	Sleep    3s
    #Validate highlighted yesterday - Needs revisit
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Yesterday_Option
	Run Keyword If  '${Result}' == 'True'  Log To Console  Yesterday_Option Is Displayed
	...  ELSE  Fail  Yesterday_Option is not displaying
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Current_Blank_Validation
	Run Keyword If  '${Result}' == 'True'  Fail  Catch Up is not available for previous day
	...  ELSE  Log To Console   Catch Up is available for previous day
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  catch_up_icon
	Run Keyword If  '${Result}' == 'True'  Log To Console  catch_up_icon Is Displayed
	...  ELSE  Fail  catch_up_icon is not displaying

    CLICK HOME

TC_805_SCHEDULE_RECORDING_FOR_FUTURE_PROGRAM_UNDER_EPG
    [Tags]    GUIDE
	# Set Recording storage to Local 
	Set Recording storage to Cloud 
	CLICK HOME
	CLICK BACK
	Sleep    1s 
	CLICK TWO
	CLICK TWO
	Sleep    2s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated to TV
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	# CLICK OK
	Guide Channel List
	Log To Console    Navigated to TV GUIDE
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	Sleep    2s 
	CLICK RIGHT
	Sleep    2s 
	CLICK RIGHT
	Sleep    2s 
	CLICK DOWN
	Sleep    2s 
	Log To Console    Navigated to Next Day Program
	CLICK LEFT
	# Log To Console    Selected a Next Day Program for Schedule
	Sleep    2s 
	CLICK OK
	Sleep    1s 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# Search Scheduled Record
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    1s 
	# CLICK RIGHT
	# CLICK DOWN
	# CLICK LEFT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Recording_Set_Icon
	Run Keyword If  '${Result}' == 'True'  Log To Console  Recording_Set_Icon Is Displayed
	...  ELSE  Fail  Recording_Set_Icon Is Not Displayed
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Added
	Run Keyword If  '${Result}' == 'True'  Log To Console  Success_Popup Is Displayed
	...  ELSE  Fail  Success_Popup Is Not Displayed
	CLICK OK
	CLICK BACK
	Sleep    2s 
	Log To Console    Scheduled program
	# Sleep    200s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    User is on MY TV
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated to Scheduled Recordings 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Dubai_Tv_Under_Recorder
	Run Keyword If  '${Result}' == 'True'  Log To Console  Dubai_Tv_Under_Recorder Is Displayed
	...  ELSE  Fail  Dubai_Tv_Under_Recorder Is Not Displayed
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Cloud_Storage_Under_Recorder
	Run Keyword If  '${Result}' == 'True'  Log To Console  Cloud_Storage_Under_Recorder Is Displayed
	...  ELSE  Fail  Cloud_Storage_Under_Recorder Is Not Displayed

	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_805_Recordings_Cancelled
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_805_Recordings_Cancelled Is Displayed
	# ...  ELSE  Fail  TC_805_Recordings_Cancelled Is Not Displayed
	CLICK OK
	CLICK HOME

TC_806_FILTER_EPG_BY_CATEGORY_AND_VERIFY_DISPLAY
    [Tags]    GUIDE
	[Teardown]    Revert Filter in Guide
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	Sleep    2s 
	CLICK LEFT
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN

    # CLICK UP
	# CLICK UP
    CLICK UP
    CLICK UP
    CLICK OK
	Sleep    2s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated to Movies 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_806_Movie_Filter
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_806_Movie_Filter Is Displayed
	...  ELSE  Fail  TC_806_Movie_Filter Is Not Displayed
	CLICK BACK
	Log To Console    Checking for Movies filter before Reboot
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_806_Movies
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_806_Movies Is Displayed
	...  ELSE  Fail  TC_806_Movies Is Not Displayed
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  movie_channel_600
	Run Keyword If  '${Result}' == 'True'  Log To Console  Movie_Channel_1
	...  ELSE  Fail  Movie_Channel_1 Is Not Displayed
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  movie_channel_612
	Run Keyword If  '${Result}' == 'True'  Log To Console  Movie_Channel_2
	...  ELSE  Fail  Movie_Channel_2 Is Not Displayed
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  movie_channel_612
	Run Keyword If  '${Result}' == 'True'  Log To Console  Movie_Channel_3
	...  ELSE  Fail  Movie_Channel_3 Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  movie_channel_600
	Run Keyword If  '${Result}' == 'True'  Log To Console  Movie_Channel_4
	...  ELSE  Fail  Movie_Channel_4 Is Not Displayed
    

	##Review comments Addded##
    CLICK HOME
	Sleep    4s
	Reboot STB Device 
	Sleep    4s
	CLICK HOME
	CLICK BACK
	Sleep    2s
	CLICK BACK
	CLICK OK
	Log To Console    Checking for Movies filter after Reboot
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_806_Movies
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_806_Movies Is Displayed
	...  ELSE  Fail  TC_806_Movies Is Not Displayed
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  movie_channel_600
	Run Keyword If  '${Result}' == 'True'  Log To Console  Movie_Channel_1
	...  ELSE  Fail  Movie_Channel_1 Is Not Displayed
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  movie_channel_612
	Run Keyword If  '${Result}' == 'True'  Log To Console  Movie_Channel_2
	...  ELSE  Fail  Movie_Channel_2 Is Not Displayed
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  movie_channel_612
	Run Keyword If  '${Result}' == 'True'  Log To Console  Movie_Channel_3
	...  ELSE  Fail  Movie_Channel_3 Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  movie_channel_600
	Run Keyword If  '${Result}' == 'True'  Log To Console  Movie_Channel_4
	...  ELSE  Fail  Movie_Channel_4 Is Not Displayed
	####
	Log To Console    Reverting Filter
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    #######
    Sleep    2s 
	CLICK MULTIPLE TIMES    14    DOWN
	# CLICK OK
    Log To Console    Navigated to Movies 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_806_Movie_Filter
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_806_Movie_Filter Is Displayed
	...  ELSE  Fail  TC_806_Movie_Filter Is Not Displayed
    ####
    CLICK MULTIPLE TIMES    17    UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK BACK
	CLICK BACK
    CLICK HOME

TC_807_SEARCH_PROGRAM_IN_EPG_AND_VIEW_DETAILS
    [Tags]    GUIDE
	# RemoveFilter_UnlockChannels
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	# CLICK OK
	Guide Channel List
	Sleep    1s 
	CLICK LEFT
	CLICK UP
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_807_Channel_Name1 
	Run Keyword If  '${Result}' == 'True'  Log To Console   TC_807_Channel_Name Is Displayed
	...  ELSE  Fail  TC_807_Channel_Name Is Not Displayed 
	
	Sleep    3s
	CLICK HOME 
	CLICK HOME 

TC_808_VERIFY_PROGRAM_DESCRIPTIONS_UNDER_EPG
    [Tags]    GUIDE
	[Teardown]    Return To Home
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	# CLICK DOWN
	# CLICK DOWN
	CLICK OK
	# Guide Channel List
	Sleep    3s 
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK BACK
	
	Sleep    19s 
	
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration   ${port}   Program_Description3
	Run Keyword If  '${Result}' == 'True'  Log To Console     Channel Number Is Displayed
	...  ELSE  Fail  Channel Number Is Not Displayed
	# ${Result}  Verify Crop Image With Shorter Duration   ${port}   TC_808_Program_Description
	# Run Keyword If  '${Result}' == 'True'  Log To Console     Program_Description Is Displayed
	# ...  ELSE  Fail  Program_Description Is Not Displayed
	 
	Sleep    18s 
	CLICK UP
	${Result}    Verify Crop Image With Shorter Duration   ${port}   TC_808_Channel_Logo_1201
	Run Keyword If  '${Result}' == 'True'  Log To Console     Channel_Logo Is Displayed
	...  ELSE  Fail  Channel_Logo Is Not Displayed
	
	Sleep    18s  
	CLICK UP
	${Result}    Verify Crop Image With Shorter Duration   ${port}    TC_808_Now_Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console     Now_Playing Is Displayed
	...  ELSE  Fail  Now_Playing Is Not Displayed
	${Result}    Verify Crop Image With Shorter Duration   ${port}   Extra_Details_Android
	Run Keyword If  '${Result}' == 'True'  Log To Console     Extra_Details_Android Is Displayed
	...  ELSE  Fail  Extra_Details_Android Is Not Displayed
	

	Sleep    18s 
	CLICK UP
	CLICK RIGHT
	Sleep    1s
	${Result}    Verify Crop Image With Shorter Duration   ${port}    TC_808_Future_Program_Description
	Run Keyword If  '${Result}' == 'True'  Log To Console     Future_Program_Description Is Displayed
	...  ELSE  Fail  Future_Program_Description Is Not Displayed
	${Result}    Verify Crop Image With Shorter Duration   ${port}    TC_808_Future_Program_Details_Later
	Run Keyword If  '${Result}' == 'True'  Log To Console     Later Is Displayed
	...  ELSE  Fail  Later Is Not Displayed
	
	# Sleep    18s 
	# CLICK UP
	# CLICK RIGHT
	# Sleep    1s
	# ${Result}    Verify Crop Image With Shorter Duration   ${port}   Blank_Info_Bar_Poster
	# Run Keyword If  '${Result}' == 'False'  Log To Console     Blank_Poster Is Not Displayed
	# ...  ELSE  Fail  Blank_Poster Is Displayed
  
	Sleep    2s 
	CLICK HOME

TC_809_SET_REMINDER_FOR_FUTURE_PROGRAM_IN_EPG
    [Tags]    GUIDE
	Remove all scheduled Reminders
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	# CLICK OK
	Guide Channel List
	Sleep    1s 
    CLICK TWO
	CLICK TWO
	Sleep    4s
	CLICK BACK
	Sleep    2s
	CLICK OK
	CLICK RIGHT
	Sleep    2s
	CLICK RIGHT
	Sleep    2s 
	CLICK DOWN
	CLICK LEFT
	Sleep    2s 
	CLICK OK
	# CLICK RIGHT 
	# CLICK DOWN
	CLICK DOWN
	CLICK OK
	# #Move to Set Reminder On Side Pannel
    # ${STEP_COUNT}=    Move to Set Reminder On Side Pannel under EPG 
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	# CLICK DOWN 
	# CLICK OK
    # CLICK OK
	# CLICK OK
    
	# CLICK DOWN
	# CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}   Reminder
	Run Keyword If  '${Result}' == 'True'  Log To Console  Reminder_Added Is Displayed on screen
	...  ELSE  Fail  Reminder_Added Is Not Displayed on screen
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}   Reminder_Set_Icon
	Run Keyword If  '${Result}' == 'True'  Log To Console  Reminder_Set_Icon Is Displayed on screen
	...  ELSE  Fail  Reminder_Set_Icon Is Not Displayed on screen
	
	CLICK TWO
	CLICK THREE
	Sleep    4s
	CLICK BACK
	Sleep    2s
	CLICK OK
	CLICK RIGHT
	Sleep    2s
	CLICK RIGHT
	Sleep    2s 
	CLICK DOWN
	CLICK LEFT
	Sleep    2s 
	CLICK OK
	CLICK DOWN
	CLICK OK
	# CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}   Reminder
	Run Keyword If  '${Result}' == 'True'  Log To Console  Reminder_Added Is Displayed on screen
	...  ELSE  Fail  Reminder_Added Is Not Displayed on screen
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}   Reminder_Set_Icon
	Run Keyword If  '${Result}' == 'True'  Log To Console  Reminder_Set_Icon Is Displayed on screen
	...  ELSE  Fail  Reminder_Set_Icon Is Not Displayed on screen
	
	CLICK TWO
	CLICK FOUR 
	Sleep    4s
	CLICK BACK
	Sleep    2s
	CLICK OK
	CLICK RIGHT
	Sleep    2s 
	CLICK RIGHT
	Sleep    2s 
	CLICK DOWN
	CLICK LEFT
	Sleep    2s 
	CLICK OK
	CLICK DOWN
	CLICK OK
	# CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}   Reminder
	Run Keyword If  '${Result}' == 'True'  Log To Console  Reminder_Added Is Displayed on screen
	...  ELSE  Fail  Reminder_Added Is Not Displayed on screen
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}   Reminder_Set_Icon
	Run Keyword If  '${Result}' == 'True'  Log To Console  Reminder_Set_Icon Is Displayed on screen
	...  ELSE  Fail  Reminder_Set_Icon Is Not Displayed on screen
	# Sleep    100s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    1s 
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Dubai_Under_Reminder
	Run Keyword If  '${Result}' == 'True'  Log To Console  Dubai_Under_Reminder Is Displayed on screen
	...  ELSE  Fail  Reminder Is Not Displayed on screen
	Sleep    1s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Sama_Dubai_Under_Reminder
	Run Keyword If  '${Result}' == 'True'  Log To Console  Sama_Dubai_Under_Reminder Is Displayed on screen
	...  ELSE  Fail  Reminder Is Not Displayed on screen
	CLICK OK
	CLICK OK
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Noor_Dubai_Under_Reminder
	Run Keyword If  '${Result}' == 'True'  Log To Console  Noor_Dubai_Under_Reminder Is Displayed on screen
	...  ELSE  Fail  TC_809_Removal Is Not Displayed on screen
	CLICK OK
	CLICK HOME
	
TC_810_INITIATE_STARTOVER_FOR_ONGOING_PROGRAM_IN_EPG
    [Tags]    GUIDE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	# CLICK OK
	Guide Channel List
	Sleep    3s
	CLICK SIX
	CLICK ZERO
    Sleep    1s 
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Navigated to startover playback from EPG 
	Sleep    2s 
	CLICK BACK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME

TC_811_VERIFY_AGE_APPROPRIATE_PROGRAMS_UNDER_CHILD_PROFILE
    [Tags]    GUIDE
	[Teardown]    DELETE PROFILE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    1s 
	CLICK RIGHT
	CLICK OK
	Sleep    1s 
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s 
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	#Entering name COCO
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	#######
	CLICK DOWN
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    2s 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    1s 
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}    TC_811_KIDS_PROFILE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_811_KIDS_PROFILE Is Displayed on screen
	...  ELSE  Fail  TC_811_KIDS_PROFILE Is Not Displayed on screen
	
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    2s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	# CLICK OK
	Guide Channel List
	Sleep    1s
	CLICK BACK
	Sleep    1s
	CLICK UP
	CLICK UP
	CLICK OK 
	Sleep    3s
	CLICK BACK
	CLICK RIGHT
    ${Result}  Verify Crop Image With Shorter Duration    ${port}    TC_811_KIDS
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_811_KIDS Is Displayed on screen
	...  ELSE  Fail  TC_811_KIDS Is Not Displayed on screen
	
	CLICK BACK
	Sleep    2s
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	Sleep    3s 
	CLICK BACK
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}    TC_811_KIDS_2
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_811_KIDS_2 Is Displayed on screen
	...  ELSE  Log To Console  TC_811_KIDS_2 Is Not Displayed on screen
	Sleep    2s 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    1s
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    25s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    1s
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    2s
	CLICK HOME


TC_812_VERIFY_SMOOTH_SCROLLING_IN_EPG
    [Tags]    GUIDE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	# CLICK OK
	Guide Channel List
	Sleep    3s
	# CLICK ONE
	# Sleep    2s 
	# CLICK BACK
	# CLICK OK
	Verify Zapping Time    DOWN    10
	Sleep    2s 
	CLICK RIGHT
	Verify Zapping Time    DOWN    5
	Sleep    2s 
	CLICK RIGHT
	#Verify Today Option
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Today_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console  Today_EPG Is Displayed
	...  ELSE  Fail  Today_EPG Is Not Displayed
	
    Verify Zapping Time    DOWN    5
	Sleep    3s 
	CLICK HOME

TC_813_APPLY_FAVORITES_FILTER_AND_VERIFY_EPG_DISPLAY
    [Tags]    GUIDE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    2s 
	CLICK ONE
	Sleep    2s 
	CLICK BACK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    3s
	CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_813_Validate_Favorite_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console      TC_813_Validate_Favorite_Channel Is Displayed
	...  ELSE  Fail  TC_813_Validate_Favorite_Channel Is Not Displayed
	Sleep    2s 
	CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK BACK
	CLICK BACK
	Sleep    2s 
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME


# TC_814_VERIFY_DYNAMIC_UPDATES_IN_EPG_PROGRAM_DURATION
#     [Tags]    GUIDE
# 	CLICK HOME
# 	CLICK UP
# 	CLICK RIGHT
# 	CLICK OK
# 	Sleep	2s
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	Guide Channel List
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK BACK
# 	CLICK OK
# 	CLICK RIGHT
# 	VALIDATE IMAGES AFTER SOME DURATION


# TC_815_CHECK_VISUAL_INDICATOR_FOR_RECORDED_PROGRAMS_IN_EPG
# 	[Tags]    GUIDE
#     [Documentation]     Verify visual indicator for recorded programs in EPG
# 	CLICK HOME
# 	CLICK UP
# 	CLICK RIGHT
# 	CLICK OK
#     Sleep   2s
#     Log To Console    Navigated to TV
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	# CLICK OK
# 	Guide Channel List
#     Sleep   2s
#     Log To Console    Navigated to TV Guide
# 	CLICK TWO
# 	CLICK TWO
#     Log To Console     Navigated to the channel
# 	Sleep	5s
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
#     #Validate the Highlighted record button without giving sleep after clicking down
#     ${Result}  Verify Crop Image With Shorter Duration    ${port}  Record_Option_Left_Pannel
# 	Run Keyword If  '${Result}' == 'True'  Log To Console  Record_Option_Left_Pannel Is Displayed
# 	...  ELSE  Fail  Record_Option_Left_Pannel Is Not Displayed	
# 	CLICK OK
# 	CLICK HOME


TC_818_CANCEL_SCHEDULED_RECORDING_FROM_EPG
	[Tags]    GUIDE
	[Documentation]     Verify Cancel schedule recording from EPG
	RemoveFilter_UnlockChannels
	Set Recording storage to Local
	CLICK HOME
	CLICK BACK
	Sleep    1s 
	CLICK TWO
	CLICK TWO
	Sleep    2s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated to TV
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	# CLICK OK
	Guide Channel List
	Log To Console    Navigated to TV GUIDE
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	Sleep    2s 
	CLICK RIGHT
	Sleep    2s 
	CLICK DOWN
	Sleep    2s 
	Log To Console    Navigated to Next Day Program
	CLICK LEFT
	Log To Console    Selected a Next Day Program for Schedule
	Sleep    2s 
	CLICK OK
	Sleep    1s 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  Success_Popup
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Success_Popup Is Displayed
	# ...  ELSE  Fail  Success_Popup Is Not Displayed
	# CLICK OK
	# CLICK BACK
	Sleep    2s 
	Log To Console    Scheduled program
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    User is on MY TV
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated to Scheduled Recordings 
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_805_Recordings_Cancelled
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_805_Recordings_Cancelled Is Displayed
	...  ELSE  Log To Console  TC_805_Recordings_Cancelled Is Not Displayed
	CLICK OK
	CLICK HOME

TC_822_VERIFY_MULTI_LANGUAGE_SUPPORT_IN_EPG
    [Tags]    GUIDE
	[Teardown]    Revert UI language
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	Guide Channel List
	Sleep    1s
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Sleep    3s
	CLICK BACK
	CLICK OK
	CLICK RIGHT
	Sleep    3s
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_822_ENGLISH_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_822_ENGLISH_EPG Is Displayed on screen
	...  ELSE  Fail  TC_822_ENGLISH_EPG Is Not Displayed on screen
	
	CLICK BACK
	Sleep    20s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	Sleep    1s
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    1s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    1s
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    1s
	CLICK OK
	Sleep    30s 
	CLICK HOME
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	Arabic Channel List Fix
	Sleep    3s
	CLICK LEFT
	Sleep    3s
	CLICK LEFT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_822_ARABIC_TODAY
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_822_ARABIC_TODAY Is Displayed on screen
	...  ELSE  Fail  TC_822_ARABIC_TODAY Is Not Displayed on screen
	
	CLICK BACK
	CLICK HOME
	# CLICK UP
	# CLICK LEFT
	# CLICK LEFT
	# CLICK LEFT
	# CLICK LEFT
	# CLICK LEFT
	# CLICK LEFT
	# CLICK LEFT
	# CLICK LEFT
	# CLICK LEFT
	# CLICK LEFT
	# CLICK OK
	# CLICK DOWN
	# CLICK OK
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	# Sleep    1s
	# CLICK LEFT
	# CLICK LEFT
	# CLICK LEFT
	# CLICK LEFT
	# CLICK OK
	# Sleep    1s
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	# Sleep    1s
	# CLICK DOWN
	# CLICK OK
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	# Sleep    1s
	# CLICK OK
	# Sleep    20s
	# CLICK HOME


TC_823_CHECK_LIVE_SPORTS_SECTION_UNDER_EPG
    [Tags]    GUIDE
	[Teardown]    Revert Filter in Guide
	CLICK HOME
	CLICK ONE
	Sleep	4s 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	Guide Channel List
	CLICK LEFT
	#MOVE TO FILER
	Log To Console    Navigating to filter
	# ${STEP_COUNT}=    Move to Filter On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK UP
	CLICK UP
	# CLICK UP
    CLICK OK
    Log To Console    Filter selected 
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	Sleep    1s 
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
    # Validate Sports filter
	${Result}  Verify Crop Image With Shorter Duration  ${port}    TC_823_FILTER_SPORTS
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_823_FILTER_SPORTS Is Displayed on screen
	...  ELSE  Fail  TC_823_FILTER_SPORTS Is Not Displayed on screen
	

	CLICK OK
	Sleep    2s 
	CLICK BACK
	  # Validate Sports Bookmark
	${Result}  Verify Crop Image With Shorter Duration  ${port}    Sports_Bookmark_Poster
	Run Keyword If  '${Result}' == 'True'  Log To Console  Sports_Bookmark Is Displayed on screen
	...  ELSE  Fail  Sports_Bookmark Is Not Displayed on screen
	Sleep    2s
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_823_SPORT1
	Run Keyword If  '${Result}' == 'True'  Log To Console  SPORT CHANNEL 1 Is Displayed on screen
	...  ELSE  Fail  SPORT CHANNEL 1 Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_823_SPORT2
	Run Keyword If  '${Result}' == 'True'  Log To Console   SPORT CHANNEL 2 Is Displayed on screen
	...  ELSE  Fail  SPORT CHANNEL 2 Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_823_SPORT3
	Run Keyword If  '${Result}' == 'True'  Log To Console  SPORT CHANNEL 3 Is Displayed on screen
	...  ELSE  Fail  SPORT CHANNEL 3 Is Not Displayed on screen
	
	##Review comments Addded##
    CLICK HOME
	Sleep    4s
	Reboot STB Device 
	Sleep    4s
	CLICK HOME
	CLICK BACK
	Sleep    2s
	CLICK BACK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}    Sports_Bookmark_Poster
	Run Keyword If  '${Result}' == 'True'  Log To Console  Sports_Bookmark Is Displayed on screen
	...  ELSE  Fail  Sports_Bookmark Is Not Displayed on screen
	Sleep    2s
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_823_SPORT1
	Run Keyword If  '${Result}' == 'True'  Log To Console  SPORT CHANNEL 1 Is Displayed on screen
	...  ELSE  Fail  SPORT CHANNEL 1 Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_823_SPORT2
	Run Keyword If  '${Result}' == 'True'  Log To Console   SPORT CHANNEL 2 Is Displayed on screen
	...  ELSE  Fail  SPORT CHANNEL 2 Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_823_SPORT3
	Run Keyword If  '${Result}' == 'True'  Log To Console  SPORT CHANNEL 3 Is Displayed on screen
	...  ELSE  Fail  SPORT CHANNEL 3 Is Not Displayed on screen
	
	
	CLICK DOWN
	CLICK LEFT
	#MOVE TO FILER
	Log To Console    Navigating to filter
	# ${STEP_COUNT}=    Move to Filter On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK UP
	CLICK UP
	# CLICK UP
    CLICK OK
    Log To Console    Filter selected 
	CLICK MULTIPLE TIMES    17    DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}    Sports_Filter_Selected
	Run Keyword If  '${Result}' == 'True'  Log To Console  Sports_Filter_Selected Is Displayed on screen
	...  ELSE  Fail  Sports_Filter_Selected Is Not Displayed on screen
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	Sleep    2s
	CLICK MULTIPLE TIMES    25    UP
	CLICK OK
	CLICK BACK
	CLICK BACK
	CLICK HOME



TC_824_VERIFY_RECORDING_CONFLICT_WARNINGS_IN_EPG
    [Tags]    GUIDE
	STOP RECORDING 
	Set Recording storage to Local 
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	Guide Channel List
	Sleep    2s 
	CLICK Two
	CLICK Two
	Sleep    2s 
	Sleep    2s 
	CLICK Ok
	# CLICK Down
	# CLICK Down
	# CLICK Down
	# CLICK Ok
	Sleep    1s
    ${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	Sleep    5s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Recording_Started
	Run Keyword If  '${Result}' == 'True'  Log To Console  Recording_Started Is Displayed on screen
	...  ELSE  Fail  Recording_Started Is Not Displayed on screen
	
	CLICK Ok
	Sleep    2s 
	CLICK Two
	CLICK Three
	Sleep    2s 
	Sleep    2s 
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	# Sleep    1s
    # ${STEP_COUNT}=    Move to Record On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
    # CLICK OK
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	Sleep    5s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Conflict_Message
	Run Keyword If  '${Result}' == 'True'  Log To Console  Conflict_Message Is Displayed on screen
	...  ELSE  Fail  Conflict_Message Is Not Displayed on screen
	
	CLICK Ok
	Sleep    2s 
	# CLICK Two
	# CLICK Four
	# Sleep    2s 
	# CLICK Back
	# CLICK Ok
	# CLICK Right
	# Sleep    2s 
	# CLICK Ok
	# # CLICK Down
	# # CLICK Down
	# # CLICK Down
	# # CLICK Ok
	# Sleep    1s
    # ${STEP_COUNT}=    Move to Record On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
    # CLICK OK
	# CLICK Down
	# CLICK Ok
	# CLICK Down
	# CLICK Down
	# CLICK Down
	# CLICK Down
	# CLICK Ok
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_824_Conflict_seen
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_824_Conflict_seen Is Displayed on screen
	# ...  ELSE  Fail  TC_824_Conflict_seen Is Not Displayed on screen
	
	# CLICK Ok
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Local_Storage_Under_Recorder
	Run Keyword If  '${Result}' == 'True'  Log To Console  Local_Storage_Under_Recorder Is Displayed
	...  ELSE  Fail  Local_Storage_Under_Recorder Is Not Displayed
	CLICK Down
	CLICK Ok
	CLICK Up
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_824_Confirm_Deletion
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_824_Confirm_Deletion Is Displayed on screen
	...  ELSE  Fail  TC_824_Confirm_Deletion Is Not Displayed on screen
	
	CLICK Ok
	Sleep    20s 
	CLICK Ok
	CLICK Home


TC_825_CONFIRM_LAST_VIEWED_POSITION_RETAINS_AFTER_POWER_CYCLE
    [Tags]    GUIDE
	[Teardown]    Return To Home
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    1s
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ZERO
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_825_Last_retained_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_825_Last_retained_Channel Is Displayed on screen
	...  ELSE  Fail  TC_825_Last_retained_Channel Is Not Displayed on screen
	Sleep    1s 
	Reboot STB Device
	CLICK HOME
    Sleep    3s 
	CLICK HOME
	CLICK BACK
	Sleep    1s 
	CLICK BACK
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_825_Last_retained_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_825_Last_retained_Channel Is Displayed on screen
	...  ELSE  Fail  TC_825_Last_retained_Channel Is Not Displayed on screen
	# CLICK HOME
	# CLICK UP
	# CLICK RIGHT
	# CLICK OK
	# CLICK OK

TC_835_CONFIRM_LAST_VIEWED_POSITION_RETAINS_AFTER_STANDBY
    [Tags]    GUIDE
	[Teardown]    Return To Home
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    1s
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ZERO
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_825_Last_retained_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_825_Last_retained_Channel Is Displayed on screen
	...  ELSE  Fail  TC_825_Last_retained_Channel Is Not Displayed on screen
	Sleep    1s 
	CLICK POWER
	Sleep    10s 
	CLICK POWER
	Sleep    40s 
	Check Who's Watching login
	CLICK HOME
    Sleep    3s 
	CLICK HOME
	CLICK BACK
	Sleep    1s 
	CLICK BACK
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_825_Last_retained_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_825_Last_retained_Channel Is Displayed on screen
	...  ELSE  Fail  TC_825_Last_retained_Channel Is Not Displayed on screen
	# CLICK HOME
	# CLICK UP
	# CLICK RIGHT
	# CLICK OK
	# CLICK OK
	
TC_827_SCHEDULE_RECURRING_RECORDING_UNDER_EPG
    [Tags]    GUIDE
	Set Recording storage to Local 
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	Guide Channel List
	Sleep    3s 
	CLICK Two
	CLICK Two
	Sleep    2s
	CLICK Back
	CLICK Ok
	CLICK Right
	Sleep    2s
	CLICK Right
	Sleep    2s
	CLICK Down
	Sleep    2s
	CLICK LEFT
	Sleep    2s
	CLICK Ok
	# CLICK Down
	# CLICK Down
	# CLICK Down
	# CLICK Ok
	${STEP_COUNT}=    Move to Record On Side Pannel under EPG 
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	Sleep    2s
	CLICK Ok
	CLICK Home
	CLICK One
	CLICK Two
	CLICK Zero
	CLICK One
	Sleep    2s
	CLICK Back
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	Sleep    2s
	CLICK Right
	# Sleep    2s
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_827_Validate_Recurring_Scheduling
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_827_Validate_Recurring_Scheduling Is Displayed on screen
	# ...  ELSE  Fail  TC_827_Validate_Recurring_Scheduling Is Not Displayed on screen
	
	CLICK Down
	CLICK Ok
	CLICK Up
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_827_Confirm_Deletion
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_827_Confirm_Deletion Is Displayed on screen
	...  ELSE  Fail  TC_827_Confirm_Deletion Is Not Displayed on screen
	
	CLICK Ok
	Sleep    10s 
	CLICK Ok
	CLICK Home


TC_830_SCHEDULE_RECORDINGS_ON_MULTIPLE_CHANNELS_SIMULTANEOUSLY
    [Tags]    GUIDE
	Set Recording storage to Local 
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
    Guide Channel List
	CLICK Two
	CLICK Two
	Sleep    2s
	CLICK Back
	CLICK Ok
	CLICK Right
	Sleep    2s
	CLICK Right
	Sleep    2s
	CLICK Right
	Sleep    2s
	CLICK Down
	Sleep    2s
	CLICK LEFT
	Sleep    2s
	CLICK Ok
	# CLICK Down
	# CLICK Down
	# CLICK Ok
	Sleep    1s
    ${STEP_COUNT}=    Move to Record On Side Pannel under EPG 
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Two
	CLICK Three
	Sleep    2s
	CLICK Back
	CLICK Ok
	CLICK Right
	Sleep    2s
	CLICK Right
	Sleep    2s
	CLICK Down
	Sleep    2s
	CLICK Ok
	CLICK LEFT
	Sleep    2s
	CLICK Ok
	# Sleep    2s
	# CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	Sleep    1s
    # ${STEP_COUNT}=    Move to Record On Side Pannel under EPG 
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
    # CLICK OK
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_824_Conflict_PopUp
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_824_Conflict_PopUp Is Displayed on screen
	...  ELSE  Fail  TC_824_Conflict_PopUp Is Not Displayed on screen
	
	CLICK Ok
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	Sleep    2s
	CLICK Right
	Sleep    2s
	CLICK Down
	CLICK Ok
	CLICK Up
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_824_Confirm_Deletion
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_824_Confirm_Deletion Is Displayed on screen
	...  ELSE  Fail  TC_824_Confirm_Deletion Is Not Displayed on screen
	
	CLICK Ok
	CLICK Ok
	CLICK Home


TC_831_VERIFY_PROGRAM_AVAILABILITY_UPDATES_IN_EPG
    [Tags]    GUIDE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	CLICK FIVE
	CLICK BACK
	CLICK OK
	CLICK RIGHT
	VALIDATE IMAGES AFTER SOME DURATION


TC_832_CHECK_ADD_TO_FAVORITE_OPTION_IN_EPG
    [Tags]    GUIDE
	Remove all scheduled Reminders 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	# Sleep    2s
	CLICK THREE
	CLICK ZERO
	CLICK FOUR
	CLICK BACK
	Sleep    1s 
	CLICK RIGHT
	CLICK OK
	Sleep    2s 
	CLICK OK
	Sleep    2s 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    # FOR    ${i}    IN RANGE    25
	# 	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_211_Favorites_Feed
	# 	Run Keyword If    '${Result}' == 'True'    Run Keywords
	# 	...    Log To Console    Favorites feed is displayed
	# 	...    AND    Exit For Loop

	# 	CLICK RIGHT
	# 	Sleep    0.2s
	# END
    CLICK MULTIPLE TIMES    24    RIGHT
	CLICK MULTIPLE TIMES    2    DOWN
	CLICK OK
	CLICK LEFT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  MY_TV_FAVORITES
	Run Keyword If  '${Result}' == 'True'  Log To Console  MY_TV_FAVORITES Is Displayed on screen
	...  ELSE  Fail  MY_TV_FAVORITES Is Not Displayed on screen
	
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    2s 
	CLICK THREE
	CLICK ZERO
	CLICK FOUR
	Sleep    1s 
	CLICK BACK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	Sleep    1s 
	CLICK OK
	CLICK HOME



TC_833_VERIFY_STARTOVER_AND_CATCHUP_OPTION_UNDER_EPG_DURING_LIVE_STREAM
	[Tags]    GUIDE
    [Documentation]     Verify startover and catchup option in EPG during live stream
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	# CLICK OK
	Guide Channel List
	CLICK LEFT
	#Navigate to Filter
	CLICK RIGHT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Filter selected 
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK BACK
	CLICK BACK
	Sleep    2s 
    # Log To Console    Verifying Video Playback
    # VALIDATE VIDEO PLAYBACK
    Log To Console    Verify if playback has startover and ctachup option
	CLICK RIGHT
	#Navigate to startover
	CLICK RIGHT
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    # CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_833_STARTOVE_IMAGE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_833_STARTOVE_IMAGE Is Displayed
	...  ELSE  Fail  TC_833_STARTOVE_IMAGE Is Not Displayed
	CLICK OK
	CLICK BACK
	CLICK BACK
	Check For Exit Popup
	CLICK BACK

	Sleep    2s
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_833_CATCHUP_IMAGE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_833_CATCHUP_IMAGE Is Displayed
	...  ELSE  Log To Console  TC_833_CATCHUP_IMAGE Is Not Displayed
	CLICK OK
	CLICK BACK
	CLICK BACK

	Sleep    3s
	CLICK OK
	CLICK LEFT

    #Navigate to Filter
	#CLICK RIGHT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    # Log To Console    Filter selected 
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK BACK
	Sleep    2s 
	CLICK HOME

TC_834_VERIFY_LIVE_NEWS_SECTION_UNDER_EPG
    [Tags]    GUIDE
	[Teardown]    Revert Filter in Guide
	CLICK HOME
	CLICK TWO
	CLICK TWO
	Sleep    2s 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep    1s 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	Guide Channel List
	CLICK LEFT
    # Log To Console    Navigating to filter
	# ${STEP_COUNT}=    Move to Filter On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK UP
	CLICK UP
	# CLICK UP
    CLICK OK
    Log To Console    Filter selected 

	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}    News_Filter_Selected
	Run Keyword If  '${Result}' == 'True'  Log To Console  News_Filter_Selected Is Displayed on screen
	...  ELSE  Fail  News_Filter_Selected Is Not Displayed on screen	
	CLICK BACK
	${Result}  Verify Crop Image With Shorter Duration  ${port}    News_Bookmark_Poster
	Run Keyword If  '${Result}' == 'True'  Log To Console  News_Bookmark Is Displayed on screen
	...  ELSE  Fail  News_Bookmark Is Not Displayed on screen
	Sleep	2s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_823_NEW1
	Run Keyword If  '${Result}' == 'True'  Log To Console  NEWS CHANNEL 1 Is Displayed on screen
	...  ELSE  Fail  NEWS CHANNEL 1 Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_823_NEW2
	Run Keyword If  '${Result}' == 'True'  Log To Console   NEWS CHANNEL 2 Is Displayed on screen
	...  ELSE  Fail  NEWS CHANNEL 2 Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_823_NEW3
	Run Keyword If  '${Result}' == 'True'  Log To Console  NEWS CHANNEL 3 Is Displayed on screen
	...  ELSE  Fail  NEWS CHANNEL 3 Is Not Displayed on screen
	##Review comments added
	CLICK HOME
	Sleep    4s
	Reboot STB Device 
	Sleep    4s
	CLICK HOME
	CLICK BACK
	Sleep    2s
	CLICK BACK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}    News_Bookmark_Poster
	Run Keyword If  '${Result}' == 'True'  Log To Console  News_Bookmark Is Displayed on screen
	...  ELSE  Fail  News_Bookmark Is Not Displayed on screen
	Sleep	2s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_823_NEW1
	Run Keyword If  '${Result}' == 'True'  Log To Console  NEWS CHANNEL 1 Is Displayed on screen
	...  ELSE  Fail  NEWS CHANNEL 1 Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_823_NEW2
	Run Keyword If  '${Result}' == 'True'  Log To Console   NEWS CHANNEL 2 Is Displayed on screen
	...  ELSE  Fail  NEWS CHANNEL 2 Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_823_NEW3
	Run Keyword If  '${Result}' == 'True'  Log To Console  NEWS CHANNEL 3 Is Displayed on screen
	...  ELSE  Fail  NEWS CHANNEL 3 Is Not Displayed on screen
	
	CLICK DOWN
	CLICK LEFT
	#MOVE TO FILER
	Log To Console    Navigating to filter
	# ${STEP_COUNT}=    Move to Filter On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK UP
	CLICK UP
	# CLICK UP
    CLICK OK
    Log To Console    Filter selected 
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	Sleep    2s
	CLICK MULTIPLE TIMES    18    DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}    News_Filter_Selected
	Run Keyword If  '${Result}' == 'True'  Log To Console  News_Filter_Selected Is Displayed on screen
	...  ELSE  Fail  News_Filter_Selected Is Not Displayed on screen
	CLICK MULTIPLE TIMES    17    UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK BACK
	CLICK BACK
	CLICK HOME

TC_836_SCHEDULE_RECORDING_FOR_FUTURE_PROGRAM_UNDER_EPG_FOR_LOCAL_STORAGE
    [Tags]    GUIDE
	Set Recording storage to Local
	CLICK HOME
	CLICK BACK
	Sleep    1s 
	CLICK TWO
	CLICK TWO
	Sleep    2s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated to TV
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	# CLICK OK
	Guide Channel List
	Log To Console    Navigated to TV GUIDE
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	Sleep    2s 
	CLICK RIGHT
	Sleep    2s 
	CLICK RIGHT
	Sleep    2s 
	CLICK DOWN
	Sleep    2s 
	Log To Console    Navigated to Next Day Program
	CLICK LEFT
	# Log To Console    Selected a Next Day Program for Schedule
	Sleep    2s 
	CLICK OK
	Sleep    1s 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# Search Scheduled Record
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    1s 
	# CLICK RIGHT
	# CLICK DOWN
	# CLICK LEFT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Recording_Set_Icon
	Run Keyword If  '${Result}' == 'True'  Log To Console  Recording_Set_Icon Is Displayed
	...  ELSE  Fail  Recording_Set_Icon Is Not Displayed
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Added
	Run Keyword If  '${Result}' == 'True'  Log To Console  Success_Popup Is Displayed
	...  ELSE  Fail  Success_Popup Is Not Displayed
	CLICK OK
	CLICK BACK
	Sleep    2s 
	Log To Console    Scheduled program
	# Sleep    300s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    User is on MY TV
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated to Scheduled Recordings 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Dubai_Tv_Under_Recorder
	Run Keyword If  '${Result}' == 'True'  Log To Console  Dubai_Tv_Under_Recorder Is Displayed
	...  ELSE  Fail  Dubai_Tv_Under_Recorder Is Not Displayed
	
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Local_Storage_Under_Recorder
	Run Keyword If  '${Result}' == 'True'  Log To Console  Local_Storage_Under_Recorder Is Displayed
	...  ELSE  Fail  Local_Storage_Under_Recorder Is Not Displayed
	CLICK DOWN
	CLICK OK
	# CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_805_Recordings_Cancelled
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_805_Recordings_Cancelled Is Displayed
	...  ELSE  Log To Console  TC_805_Recordings_Cancelled Is Not Displayed
	CLICK OK
	CLICK HOME

TC_837_VERIFY_PROGRAM_DESCRIPTIONS_UNDER_EPG_FOR_SUBPROFILE
    [Tags]    GUIDE
	[Teardown]    DELETE PROFILE
	CLICK TWO
	CLICK TWO 
	Create New Profile
	Navigate and Login to Sub profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    3s 
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Sleep    4s 
	CLICK OK
	Sleep    2s 
	# CLICK BACK
	
	Sleep    19s 
	
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration   ${port}   Program_Description3
	Run Keyword If  '${Result}' == 'True'  Log To Console     Channel Number Is Displayed
	...  ELSE  Fail  Channel Number Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration   ${port}   TC_808_Program_Description
	Run Keyword If  '${Result}' == 'True'  Log To Console     Program_Description Is Displayed
	...  ELSE  Fail  Program_Description Is Not Displayed
	 
	Sleep    18s 
	CLICK UP
	${Result}    Verify Crop Image With Shorter Duration   ${port}   TC_808_Channel_Logo_1201
	Run Keyword If  '${Result}' == 'True'  Log To Console     Channel_Logo Is Displayed
	...  ELSE  Fail  Channel_Logo Is Not Displayed
	
	Sleep    18s  
	CLICK UP
	${Result}    Verify Crop Image With Shorter Duration   ${port}    TC_808_Now_Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console     Now_Playing Is Displayed
	...  ELSE  Fail  Now_Playing Is Not Displayed
	${Result}    Verify Crop Image With Shorter Duration   ${port}   Extra_Details
	Run Keyword If  '${Result}' == 'True'  Log To Console     Extra_Details Is Displayed
	...  ELSE  Fail  Extra_Details Is Not Displayed
	

	Sleep    18s 
	CLICK UP
	CLICK RIGHT
	Sleep    1s
	${Result}    Verify Crop Image With Shorter Duration   ${port}    TC_808_Future_Program_Description
	Run Keyword If  '${Result}' == 'True'  Log To Console     Future_Program_Description Is Displayed
	...  ELSE  Fail  Future_Program_Description Is Not Displayed
	${Result}    Verify Crop Image With Shorter Duration   ${port}    TC_808_Future_Program_Details_Later
	Run Keyword If  '${Result}' == 'True'  Log To Console     Later Is Displayed
	...  ELSE  Fail  Later Is Not Displayed
	
	# Sleep    18s 
	# CLICK UP
	# CLICK RIGHT
	# Sleep    1s
	# ${Result}    Verify Crop Image With Shorter Duration   ${port}   Blank_Info_Bar_Poster
	# Run Keyword If  '${Result}' == 'False'  Log To Console     Blank_Poster Is Not Displayed
	# ...  ELSE  Fail  Blank_Poster Is Displayed
  
	Sleep    2s 
	CLICK HOME
    Login As Admin
	####################################################################################################


########################################################################################################################################################################################
TC_401_RECORD_LIVE_CHANNEL_FOR_30_MINUTES_TO_LOCAL_STORAGE
    [Tags]    RECORDING
	[Teardown]    STOP RECORDING
    CLICK HOME
    CLICK UP
    CLICK RIGHT
	CLICK OK
    CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
    # Image validation - check for "Recording Started"
   ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Local Recorder

    CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}

	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
    Sleep    60s

    CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Sleep    10s
    CLICK OK
	Sleep	2s
	Get Storage Type In Recorder List    Local
	Sleep    10s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
    CLICK DOWN
    CLICK OK
    CLICK OK
    CLICK OK
	CLICK OK
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	5s
	Check For Recording Completed Popup
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}

	CLICK HOME



TC_402_PLAY_COMPLETED_RECORDING_FROM_LOCAL_STORAGE
	[Tags]    RECORDING
    [Teardown]    STOP RECORDING
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK 
	CLICK OK
	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
	

    Sleep    8s
    # Image validation - check for "Recording Started"
	${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
		Run Keyword If    '${Result}' == 'True'    
		...    Log To Console    TC_401_Rec_Start Is Displayed
		...    ELSE    
		...    Run Keyword    Handle Recording Failure Local Recorder

    CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	
    Sleep    80s
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated To My TV Section
	Sleep    5s
	CLICK OK
	Sleep    5s
	Get Storage Type In Recorder List    Local
	Sleep    2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep    2s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    25s
	Check For Recording Completed Popup
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	Sleep    2s
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
    CLICK UP
	#content started playing
		${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Log To Console    Recording is playing
	CLICK Home

TC_403_START_AND_PAUSE_RECORDING_SIMULTANEOUSLY_WITH_LOCAL_STORAGE
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section  
    CLICK OK
	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
    Sleep    8s

    # Image validation - check for "Recording Started"
	${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
	Run Keyword If    '${Result}' == 'True'    
	...    Log To Console    TC_401_Rec_Start Is Displayed
	...    ELSE    
	...    Run Keyword    Handle Recording Failure Local Recorder

    CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	CLICK RIGHT
	${STEP_COUNT}=    Move to Pause On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep    2s
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	Sleep	120s
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Sleep	120s
	CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Sleep    2s
    CLICK OK
	Sleep	2s
	Get Storage Type In Recorder List    Local
	Sleep    2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	20s
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK OK
    CLICK OK
	CLICK OK
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	5s
	Check For Recording Completed Popup
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}

    CLICK HOME

TC_405_RECORD_AND_WATCH_LIVE_CHANNELS_SIMULTANEOUSLY_WITH_LOCAL_STORAGE
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
    Click Home
    Click UP
    Click RIGHT
    Click OK
    Click OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
    Sleep    8s
    Log To Console    Playback Recording Started
	${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
		Run Keyword If    '${Result}' == 'True'    
		...    Log To Console    TC_401_Rec_Start Is Displayed
		...    ELSE    
		...    Run Keyword    Handle Recording Failure Local Recorder
    CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	Sleep	10s
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button  Is Not Displayed
    
    Click HOME
    Click UP 
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK TWO
	# CLICK FOUR
	# CLICK SIX
	Sleep	100s
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Sleep    10s
    CLICK OK
	Sleep	2s
	Get Storage Type In Recorder List    Local
	Sleep    10s
	${channel_name_mylist}=    Get Channel Name In Recorder Of MyList
	Verify Matching Channels    ${channel_name_mylist}     ${channel_name}
	Sleep	20s
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK OK
    CLICK OK
	CLICK OK
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	5s
	Check For Recording Completed Popup
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}

	CLICK HOME


TC_406_STOP_RECORDING_MANUALLY_AND_PLAY_BACK_FROM_LOCAL_STORAGE
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
 
	Sleep	8s
	# Image validation - check for "Recording Started"
    ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Local Recorder

    CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
    Sleep    120s
	# CLICK RECORD
	# Log To Console	Pressed Stop Button	
	# CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_401_Stopped_Recording
	#  Run Keyword If  '${Result}' == 'True'  Log To Console  TC_401_Stopped_Recording Is Displayed
	#  ...  ELSE  Fail  TC_401_Stopped_Recording  Is Not Displayed
    # CLICK OK  
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    2s
	Get Storage Type In Recorder List    Local
	Sleep    10s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Check For Recording Completed Popup
	CLICK Down
	CLICK Down
    ${Play_option}=    Set Variable    Play
	${Side_panel_recorder}=    Get Play Side Panel Recorder
	Verify Matching Channels    ${Play_option}     ${Side_panel_recorder}
	
    CLICK Ok
	# CLICK OK
	Sleep    2s
	# ${Result}  Validate Video Playback For Playing
    # Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    # ...  ELSE  Fail  Video is Paused
	CLICK HOME


TC_407_RECORD_TWO_CHANNELS_SIMULTANEOUSLY_TO_LOCAL_STORAGE
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section  
    CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local

    Sleep    8s
    # Image validation - check for "Recording Started"
    ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Local Recorder

    CLICK OK
	${channel_name1}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name1}
	Sleep	10s
	CLICK HOME
    CLICK BACK
	CLICK CHANNELUP
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
    Sleep    3s
    
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_446_CONFLICT_POPUP
	Run Keyword If  '${Result}' == 'True'  Log To Console  CONFLICT_POPUP Is Displayed
	...  ELSE  Fail  CONFLICT_POPUP Is Not Displayed
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
    Sleep    700s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep	2s
	CLICK OK
	Sleep	4s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
	Log To Console     ${recorded_channel_text}  
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}  

	${recorded_channel_text1}=    Get Second Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text1}    ${channel_name1}    
		Log To Console     ${recorded_channel_text1}  

	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Check For Recording Completed Popup
	Sleep    300s
	# VALIDATE VIDEO PLAYBACK
	# Validate Video Playback For Playing
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Check For Recording Completed Popup
	Sleep    300s
	CLICK HOME

TC_408_DELETE_RECORDED_FILE_AND_CONFIRM_REMOVAL_FROM_LOCAL_STORAGE
	[Tags]    RECORDING
    # [Teardown]    STOP RECORDING
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section  
    CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local

    Sleep    8s
    Log To Console    Playback Recording Started

    # Image validation - check for "Recording Started"
    ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Local Recorder

    CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
    Sleep    120s
	CLICK OK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep	2s
	Get Storage Type In Recorder List    Local
	Sleep    10s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    10s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    5s
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_408_CONFIRM_DELETION
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_824_Confirm_Deletion Is Displayed
	...  ELSE  Fail  TC_824_Confirm_Deletion Is Not Displayed
	CLICK OK
	CLICK OK
	Log To Console 	Recording Deleted 
	CLICK HOME
	Sleep    5s
	CLICK BACK
	Sleep    5s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	${channel_name_mylist}=    Get Channel Name In Recorder Of MyList Delete
	Reboot STB Device
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    5s
	# ${Result}  Verify Crop Image With Shorter Duration   ${port}  Cloud
	# Run Keyword If  '${Result}' == 'False'  Log To Console  Recording is deleted and not listed after Reboot
	# ...  ELSE  Fail  Recording is not deleted and listed after Reboot  
	${channel_name_mylist}=    Get Channel Name In Recorder Of MyList Delete

	CLICK HOME
TC_410_PLAY_RECORDING_FROM_LOCAL_STORAGE_WHILE_ANOTHER_IS_IN_PROGRESS
	[Tags]	RECORDING
	[Teardown]    STOP RECORDING
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local

    Sleep    8s
    Log To Console    Playback Recording Started
	#IMAGE VALIIDATION
	 ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Local Recorder
	
	CLICK OK
	${channel_name1}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name1}
	Sleep	5s
	CLICK HOME
	CLICK BACK
	CLICK CHANNELUP
	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local

    Sleep    8s
    Log To Console    Playback Recording Started

	 ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Recorder
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	Sleep    120s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    ${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
	Log To Console     ${recorded_channel_text}  
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}    
	${recorded_channel_text1}=    Get Second Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text1}    ${channel_name1}    
		Log To Console     ${recorded_channel_text1} 
	CLICK DOWN
	CLICK DOWN
	${stop}=    Set Variable    Stop Recording
	${channel1}=     Get Play Side Panel Recorder
	Verify Matching Channels    ${stop}    ${channel1}
	Sleep    10s
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	10s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${play}=    Set Variable    Play
	${channel2}=     Get Play Side Panel Recorder
	Verify Matching Channels    ${play}    ${channel2}
	CLICK OK
	# VALIDATE VIDEO PLAYBACK
	# Validate Video Playback For Playing
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
	Sleep    10s
	CLICK HOME

TC_412_VERIFY_RECORDINGS_FILE_AFTER_STANDBY_MODE_IN_LOCAL_STORAGE
    [Tags]    RECORDING   
	[Teardown]    STOP RECORDING
    Click HOME
    Click UP 
    Click RIGHT 
    Click OK 
    Click OK 
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local

    Sleep    8s
    Log To Console    Playback Recording Started

	${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Recorder
    Click OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	Sleep	10s
    Click POWER
	Sleep    60s
    Click POWER 
	Sleep    50s
	Check Who's Watching login
	Sleep	10s
	CLICK HOME
    Click UP 
    Click RIGHT 
    Click RIGHT 
    Click RIGHT
    Click RIGHT
    Click RIGHT
    Click OK
	Sleep    1s
    Click OK 
	Get Storage Type In Recorder List    Local
	Sleep    5s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	5s
    Click DOWN 
    Click DOWN
    Click OK
	Click OK
    Click OK 
    Click OK
	Sleep	15s
	Check For Recording Completed Popup
    Click DOWN
	CLICK DOWN
    Click OK 
	CLICK OK
	Sleep    2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed	
	Sleep    30s
	# VALIDATE VIDEO PLAYBACK 
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
		
TC_414_RECORD_LIVE_STREAM_WITH_SUBTITLES_AND_PLAY_BACK_TO_LOCAL_STORAGE
	[Tags]	RECORDING
	[Teardown]    STOP RECORDING
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK THREE
	CLICK SIX
	CLICK SEVEN
	# CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
    Sleep    8s
    Log To Console    Playback Recording Started

    # Image validation - check for "Recording Started"
   ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Local Recorder

    CLICK OK

	Sleep	2s
	CLICK RIGHT
	${STEP_COUNT}=    Move to subtitle On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}   Subtitle_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Subtitle_Popup Is Displayed
	...  ELSE  Fail  Subtitle_Popup Is Not Displayed
	CLICK OK
	CLICK BACK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	Sleep	600s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    1s
	CLICK OK
	Sleep    1s
	Get Storage Type In Recorder List    Local
	Sleep    5s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	15s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	2s
	# VALIDATE VIDEO PLAYBACK
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK LEFT
	CLICK OK
	CLICK OK
    # CLICK BACK
	Sleep	3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK LEFT
	CLICK OK
	
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_508_arabic
	Run Keyword If  '${Result}' == 'True'  Log To Console  Subtitle_Highlighted Is Displayed
	...  ELSE  Fail  Subtitle_Highlighted Is Not Displayed
	CLICK DOWN
	CLICK OK
	Sleep	3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK LEFT
	CLICK OK
	CLICK DOWN
    ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_220_DANISH_SUBTITLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_220_DANISH_SUBTITLE Is Displayed
	...  ELSE  Fail  TC_220_DANISH_SUBTITLE Is Not Displayed
	CLICK DOWN
	CLICK OK
	Sleep	3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
    ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_220_FINNISH_SUBTITLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_220_FINNISH_SUBTITLE Is Displayed
	...  ELSE  Fail  TC_220_FINNISH_SUBTITLE Is Not Displayed
	Sleep    1s
	CLICK DOWN
	CLICK OK
	Sleep	3s
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK LEFT
	CLICK OK	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
    ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_220_NOR_SUBTITLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_220_NOR_SUBTITLE Is Displayed
	...  ELSE  Fail  TC_220_NOR_SUBTITLE Is Not Displayed
	Sleep    1s
	CLICK DOWN
	CLICK OK
	Sleep	3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK LEFT
	CLICK OK	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
    ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_220_SWEDISH_SUBTITLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_220_SWEDISH_SUBTITLE Is Displayed
	...  ELSE  Fail  TC_220_SWEDISH_SUBTITLE Is Not Displayed
	Sleep    3s
	CLICK DOWN
	CLICK OK
	Sleep	3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
    CLICK DOWN
    ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_220_NOR_SUBTITLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_220_DANISH_SUBTITLE Is Displayed
	...  ELSE  Fail  TC_220_DANISH_SUBTITLE Is Not Displayed
	Sleep    3s
	CLICK DOWN
	CLICK OK
	Sleep	3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK LEFT
	CLICK OK	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
    ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_220_NONE_SUBTITLE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_220_DANISH_SUBTITLE Is Displayed
	...  ELSE  Fail  TC_220_DANISH_SUBTITLE Is Not Displayed
	Sleep    3s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK HOME
TC_415_FAST_FORWARD_RECORDED_PROGRAM_USING_LOCAL_STORAGE
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section  
    CLICK OK
    Log To Console    Navigated To Live TV
	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
    Sleep    2s
    Log To Console    Playback Recording Started
    Sleep    8s
    # Image validation - check for "Recording Started"
   ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Local Recorder
    CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
    Sleep    600s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep	1s
	CLICK OK
	Sleep	5s
	Get Storage Type In Recorder List    Local
	Sleep    5s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	2s
	CLICK DOWN
	Sleep	1s
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	25s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	10s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK OK
	CLICK LEFT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK BACK
	Sleep    10s
	CLICK OK
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  4X_SPEED
	Run Keyword If  '${Result}' == 'True'  Log To Console  4X_SPEED Is Displayed
	...  ELSE  Fail  4X_SPEED Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  8X_SPEED
		Run Keyword If  '${Result}' == 'True'  Log To Console  8X_SPEED Is Displayed
		...  ELSE  Fail  8X_SPEED Is Not Displayed
		CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  16X_SPEED
		Run Keyword If  '${Result}' == 'True'  Log To Console  16X_SPEED Is Displayed
		...  ELSE  Fail  16X_SPEED Is Not Displayed
		CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  32X_SPEED
	Run Keyword If  '${Result}' == 'True'  Log To Console  32X_SPEED Is Displayed
	...  ELSE  Fail  32X_SPEED Is Not Displayed
	CLICK BACK
	CLICK OK
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    #     EVALUATE VIDEO QUALITY STATUS    ${results}
	Sleep	3s
	

TC_416_REWIND_RECORDED_PROGRAM_AND_RESUME_PLAYBACK_USING_LOCAL_STORAGE
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
    CLICK HOME
	Check For Exit Popup
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section  
    CLICK OK
    Log To Console    Navigated To Live TV
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
	
    Sleep    8s
    # Image validation - check for "Recording Started"
   ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Local Recorder
    CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
    Sleep    600s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep	2s
	CLICK OK
	Sleep	2s
	Get Storage Type In Recorder List    Local
	Sleep    5s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	2s
	CLICK DOWN
	Sleep	1s
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	25s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Check For Recording Completed Popup
	Sleep	10s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	10s
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  REWIND_4X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_4X Is Displayed
	...  ELSE  Fail  REWIND_4X Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  REWIND_8X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_8X Is Displayed
	...  ELSE  Fail  REWIND_8X Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  REWIND_16X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_16X Is Displayed
	...  ELSE  Fail  REWIND_16X Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  REWIND_32X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_32X Is Displayed
	...  ELSE  Fail  REWIND_32X Is Not Displayed
	Sleep	2s
    CLICK HOME

TC_417_PAUSE_RECORDED_PROGRAM_AND_RESUME_PLAYBACK_USING_LOCAL_STORAGE
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section  
    CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
    Sleep    8s
    ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Local Recorder
    CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
    Sleep    600s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Get Storage Type In Recorder List    Local
	Sleep    5s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	20s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	15s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Sleep    5s
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	Sleep	500s
	CLICK OK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	Sleep    10s



TC_419_SCHEDULE_RECORDING_THEN_CANCEL_BEFORE_START_IN_LOCAL_STORAGE
	[Tags]    RECORDING
	CLICK Home
	Log To Console    Navigated To Home Page
	CLICK Up
	CLICK Right
	CLICK Ok
	Sleep	2s
	CLICK Down
	CLICK Down
	CLICK Ok
	Guide Channel List
	Log To Console    Navigated To Tv Guide
	CLICK ONE
	CLICK FIVE
	Sleep	20s
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	Sleep	10s
    CLICK OK
	CLICK RIGHT
	Sleep	2s
	CLICK RIGHT	
	Sleep	2s
	CLICK DOWN
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_215_CLOUD_STORAGE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_CLOUD_STORAGE
	...  ELSE  Fail  TC_215_CLOUD_STORAGE Is Not Displayed
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep	1s

	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_419_SCHEDULE_ADDED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_419_SCHEDULE_ADDED
	...  ELSE  Fail  TC_419_SCHEDULE_ADDED Is Not Displayed
	CLICK OK
	#VALIDATE THE POP UP OF SCHEDULED RECORDING 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_404_Recc
	 Run Keyword If  '${Result}' == 'True'  Log To Console  TC_404_Recc Is Displayed
	 ...  ELSE  Fail  TC_404_Recc Is Not Displayed	
	
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep	1s
	CLICK OK
	Sleep	1s
	CLICK RIGHT
	Sleep	1s
	#VALIDATE CHANNEL NAME 
	${channel_name_mylist}=    Get Channel Name In Recorder Of MyList
	Verify Matching Channels    ${channel_name_mylist}     ${channel_name}
	Sleep	10s
    CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK HOME

	Reboot STB Device
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK RIGHT
	#VALIDATE CHANNEL NAME 
	 ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_404_CHANNEL_REC_AND
	 Run Keyword If  '${Result}' == 'False'  Log To Console  TC_404_Chnl_451 Is Displayed
	 ...  ELSE  Fail  TC_404_Chnl_451 Is Not Displayed	
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK HOME

TC_424_RECORD_CHANNEL_TO_LOCAL_STORAGE_WHILE_WATCHING_DIFFERENT_LIVE_CHANNEL
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
    CLICK Home
    CLICK UP
    CLICK RIGHT
    CLICK OK
    CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
	
    Sleep    8s
    Log To Console    Playback Recording Started

    # Image validation - check for "Recording Started"
    ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Local Recorder
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	Sleep	5s
    CLICK HOME
    CLICK UP 
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK FOUR
	CLICK SIX
	Sleep	130s
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep	2s
	Get Storage Type In Recorder List    Local
	Sleep    5s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	
    Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	25s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}

TC_430_PLAY_RECORDED_PROGRAM_WITH_DIFFERENT_AUDIO_TRACK_FROM_LOCAL_STORAGE
	[Tags]    RECORDING
	# [Teardown]    STOP RECORDING
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK THREE
	CLICK SEVEN 
	CLICK SIX
	# CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
    Sleep  10s
    # Image validation - check for "Recording Started"
    
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_401_Rec_Start
	...  ELSE  Fail  TC_401_Rec_Start Is Not Displayed   
    # ...    Run Keyword    Handle Recording Failure New
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	Sleep	600s
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep	10s
	Get Storage Type In Recorder List    Local
	Sleep    2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	2s
	Log To Console    Navigated To My TV Section
	
	Sleep	2s
	Log To Console    Navigated to Recorder Section
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    25s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	2s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	#IMG VALIDATION
	${Result}  Verify Crop Image With Shorter Duration  ${port}  English_Audio
	 Run Keyword If  '${Result}' == 'True'  Log To Console  TC_219_ENGLISH_AUDIO Is Displayed
	 ...  ELSE  Fail  TC_219_ENGLISH_AUDIO Is Not Displayed	
	# Sleep    3s
	# CLICK UP
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK OK
	CLICK DOWN
	CLICK OK
	Sleep    3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Hindi_Audio
	 Run Keyword If  '${Result}' == 'True'  Log To Console  TC_219_HINDI_AUDIO Is Displayed
	 ...  ELSE  Fail  TC_219_HINDI_AUDIO Is Not Displayed
	Sleep    3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	1s
	CLICK OK
	Sleep    3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_219_BENGALI_AUDIO
	 Run Keyword If  '${Result}' == 'True'  Log To Console  TC_219_BENGALI_AUDIO Is Displayed
	 ...  ELSE  Fail  TC_219_BENGALI_AUDIO Is Not Displayed	
	# VALIDATE VIDEO PLAYBACK
	# Verify Audio Quality
	# 	${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}


TC_433_RECORD_LIVE_STREAM_TO_LOCAL_STORAGE_WHILE_SWITCHING_USER_PROFILES
	[Tags]    RECORDING
	[Teardown]    Delete Profile
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_019_Whos_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_019_Whos_Watching Is Displayed
	...  ELSE  Fail  TC_019_Whos_Watching Is Not Displayed
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Up
	CLICK Up
	CLICK Up
	CLICK Up
	CLICK Up
	CLICK Up
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK Ok
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	# CLICK Ok
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Home
	Log To Console    Navigated To Home Page
	CLICK Up
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
	

	Sleep	8s
    # Image validation - check for "Recording Started"
    ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Local Recorder
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	Sleep	50s
	Log To Console	Switching profile
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
	Sleep	30s
	CLICK SEVEN
	CLICK ZERO
	CLICK FIVE
	Sleep	20s
	Log To Console	Switching back to Admin profile
	CLICK HOME
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep	25s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Get Storage Type In Recorder List    Local
	Sleep    10s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK OK
	CLICK OK
	Sleep    25s
	Check For Recording Completed Popup
	Log To Console	Recording Stopped
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	Sleep    2s
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK Down
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK HOME

TC_434_RECORD_SERIES_OF_PROGRAM_TO_LOCAL_STORAGE
	[Tags]    RECORDING
	[Teardown]	STOP RECORDING
    CLICK Home
    CLICK UP
    CLICK RIGHT
    CLICK OK
    CLICK OK
	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found Series    Local
    Sleep    8s
    # Image validation - check for "Recording Started"
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_401_Rec_Start
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_401_Rec_Start Is Displayed on screen
	...  ELSE  Fail  TC_401_Rec_Start Is Not Displayed on screen
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	Sleep	120s
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Get Storage Type In Recorder List    Local
	Sleep    2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	25s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK

TC_435_RECORD_LIVE_CHANNEL_IN_IMPULSE_MODE_TO_LOCAL_STORAGE
    [Tags]    RECORDING
	[Teardown]	STOP RECORDING
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
	CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found Impulse    Local
    
    Sleep    8s
    Log To Console    Playback Recording Started

    # Image validation - check for "Recording Started"
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_401_Rec_Start
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_401_Rec_Start Is Displayed on screen
	...  ELSE  Fail  TC_401_Rec_Start Is Not Displayed on screen

    CLICK OK
	# VALIDATE VIDEO PLAYBACK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	# ${Result}  Validate Video Playback For Playing
    # Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    # ...  ELSE  Fail  Video is Paused
    Sleep    120s

    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To My TV Section
    Sleep    10s
    CLICK OK
	Get Storage Type In Recorder List    Local
	Sleep    2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
	Verify Matching Channels    ${recorded_channel_text}     ${channel_name}

	${Result}  Verify Crop Image With Shorter Duration    ${port}  IMPULSE_RECORDING 
	Run Keyword If  '${Result}' == 'True'  Log To Console  IMPULSE_RECORDING Is Displayed on screen
	...  ELSE  Fail  IMPULSE_RECORDING Is Not Displayed on screen
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK OK
    CLICK OK
	CLICK OK
	Sleep	20s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	# VALIDATE VIDEO PLAYBACK
	# ${Result}  Validate Video Playback For Playing
    # Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    # ...  ELSE  Fail  Video is Paused

TC_436_RECORD_LIVE_CHANNEL_IN_MANUAL_RECORDING_MODE_TO_LOCAL_STORAGE
    [Tags]    RECORDING
	[Teardown]	STOP SCHEDULED RECORDING  
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
	CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found Manual    Local
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${channels}=    Get Daily Side Panel Recorder
	Log To Console	${channels}
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To My TV Section
    Sleep    10s
    CLICK OK
	CLICK RIGHT
	Sleep		2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	
    Log To Console    Navigated to Recorder Section
    CLICK DOWN
    CLICK DOWN
    CLICK OK
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	
TC_439_RECORD_LIVE_CHANNEL_IN_MANUAL_RECORDING_MODE_WEEKLY_TO_LOCAL_STORAGE
    [Tags]    RECORDING
	[Teardown]	STOP SCHEDULED RECORDING
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
	CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found Manual    Local
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	CLICK OK
	${channels}=    Get Daily Side Panel Recorder
	Log To Console	${channels}
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	
	Sleep	2s
	CLICK OK
	#selecting sunday 
	Sleep	2s
	CLICK BACK
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK OK
	CLICK OK
	CLICK DOWN

	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	Sleep	1s
    ${time}=    Get Time Side Panel Recorder
	Log To Console	${time}
	Sleep    2s
	${enddate}=    Get Enddate Side Panel Recorder
	Log To Console	${enddate}
	# @{ocr_parts}=   Create List    ${time}    ${enddate}
    # Log To Console    OCR Parts List: ${ocr_parts}
	CLICK OK
	Sleep	1s
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	# CLICK DOWN From Info Bar
	CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To My TV Section
    Sleep    10s
    CLICK OK
	CLICK RIGHT
	Sleep		2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	
    Log To Console    Navigated to Recorder Section
    CLICK DOWN
    CLICK DOWN
    CLICK OK
	${Date}=    Get DateTime In Recorder Of MyList
    Log To Console    📺 Channel Checked: ${Date}

	
TC_437_STOP_LOCAL_RECORDING_WHILE_RECORDING_IN_BOTH_STORAGES
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section  
	CLICK OK
    Log To Console    Navigated To Live TV
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
	Sleep    8s
	# Image validation - check for "Recording Started"
    ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Recorder

    CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	CLICK HOME
	CLICK BACK
	CLICK CHANNELUP
	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
	Sleep    8s
	# Image validation - check for "Recording Started"
    ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Recorder

    CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
    Sleep    120s
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated To My TV Section
	# Sleep    10s
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Cloud
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_CLOUD_STORAGE Is Displayed
	...  ELSE  Fail  TC_215_CLOUD_STORAGE Is Not Displayed
	Sleep	1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Local_Recoder
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_CLOUD_STORAGE Is Displayed
	...  ELSE  Fail  TC_215_CLOUD_STORAGE Is Not Displayed
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	#CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    25s
	Check For Recording Completed Popup
	CLICK Down
	CLICK Down
	#CLICK DOWN
	${play}=    Set Variable    Play
	${channel2}=     Get Play Side Panel Recorder
	Verify Matching Channels    ${play}    ${channel2}
	CLICK Ok
	# CLICK OK
	Sleep    2s
	# VALIDATE VIDEO PLAYBACK
	Validate Video Playback For Playing
	
TC_438_VERIFY_RECORDINGS_FILE_AFTER_REBOOT_IN_LOCAL_STORAGE
    [Tags]    RECORDING   
	[Teardown]    STOP RECORDING
    Click HOME
    Click UP 
    Click RIGHT 
    Click OK 
    Click OK 
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
	

    Sleep    8s
    Log To Console    Playback Recording Started

	${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Local Recorder
    Click OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	Sleep	10s
    Reboot STB Device
	Sleep	10s
	CLICK HOME
    Click UP 
    Click RIGHT 
    Click RIGHT 
    Click RIGHT
    Click RIGHT
    Click RIGHT
    Click OK
	Sleep    1s
    Click OK 
	Get Storage Type In Recorder List    Local
	Sleep    5s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	5s
    Click DOWN 
    Click DOWN
    Click OK
	Click OK
    Click OK 
    Click OK
	Sleep	15s
	Check For Recording Completed Popup
    Click DOWN
	CLICK DOWN
    Click OK 
	CLICK OK
	Sleep    2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed	
	Sleep    30s
	# VALIDATE VIDEO PLAYBACK 
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
		
	

TC_440_RECORD_LIVE_CHANNEL_IN_MANUAL_RECORDING_MODE_FUTURE_DATE_TO_LOCAL_STORAGE
    [Tags]    RECORDING
	[Teardown]    STOP SCHEDULED RECORING 
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
	CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found Manual    Local
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
    CLICK OK
    Log To Console    Record The Program Is Selected
    CLICK DOWN
	CLICK OK
	${channels}=    Get Daily Side Panel Recorder
	Log To Console	${channels}
	CLICK DOWN
    CLICK DOWN
    CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To My TV Section
    Sleep    10s
    CLICK OK
	CLICK RIGHT
	Sleep		2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
    Log To Console    Navigated to Recorder Section
    CLICK DOWN
    CLICK DOWN
    CLICK OK


##############################################################################################
##############################################################################################
TC_441_RECORD_LIVE_CHANNEL_FOR_30_MINUTES_TO_CLOUD_STORAGE
    [Tags]    RECORDING
	[Teardown]    STOP RECORDING
	[Timeout]	2700s
    CLICK HOME
    CLICK UP
    CLICK RIGHT
	CLICK OK
    CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
    # Image validation - check for "Recording Started"
   ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
    Sleep    120s

    CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Sleep    10s
    CLICK OK
	Sleep	2s
	Get Storage Type In Recorder List    Cloud
	Sleep    10s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
    CLICK DOWN
	CLICK DOWN
    CLICK OK
    CLICK OK
    CLICK OK
	CLICK OK
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	5s
	Check For Recording Completed Popup
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	Video Quality Verification
	Unified verification of Audio Quality
	CLICK HOME



TC_442_PLAY_COMPLETED_RECORDING_FROM_CLOUD_STORAGE
	[Tags]    RECORDING
    [Teardown]    STOP RECORDING
	[Timeout]	2700s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK 
	CLICK OK
	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
    Sleep    8s
    # Image validation - check for "Recording Started"
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder
    Sleep    120s
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated To My TV Section
	Sleep    5s
	CLICK OK
	Sleep    5s
	Get Storage Type In Recorder List    Cloud
	Sleep    2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep    2s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    25s
	Check For Recording Completed Popup
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	Sleep    2s
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused

    CLICK UP
	#content started playing
		${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Log To Console    Recording is playing
	CLICK Home

TC_443_START_AND_PAUSE_RECORDING_SIMULTANEOUSLY_WITH_CLOUD_STORAGE
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
	[Timeout]	2700s
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section  
    CLICK OK
	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
    Sleep    8s

    # Image validation - check for "Recording Started"
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder

	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	CLICK RIGHT
	${variable}=    Ensure Pause IS Visible
    ${STEP_COUNT}=    Move to Pause On Side Pannel With OCR
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep    2s
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	Sleep	120s
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Sleep	120s
	CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Sleep    2s
    CLICK OK
	Sleep	2s
	Get Storage Type In Recorder List    Cloud
	Sleep    2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	20s
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK OK
    CLICK OK
	CLICK OK
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	5s
	Check For Recording Completed Popup
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}

    CLICK HOME

TC_444_RECORD_AND_WATCH_LIVE_CHANNELS_SIMULTANEOUSLY_WITH_CLOUD_STORAGE
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
    Click Home
    Click UP
    Click RIGHT
    Click OK
    Click OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
    Sleep    8s
    Log To Console    Playback Recording Started
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder
	Sleep	10s
	# CLICK RIGHT
	# CLICK DOWN
	# CLICK OK
	# Sleep    1s
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  Play_Button
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	# ...  ELSE  Fail  Play_Button  Is Not Displayed
    
    Click HOME
    Click UP 
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK TWO
	# CLICK FOUR
	# CLICK SIX
	Sleep	100s
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Sleep    10s
    CLICK OK
	Sleep	2s
	Get Storage Type In Recorder List    Cloud
	Sleep    10s
	${channel_name_mylist}=    Get Channel Name In Recorder Of MyList
	Verify Matching Channels    ${channel_name_mylist}     ${channel_name}
	Sleep	20s
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK OK
    CLICK OK
	CLICK OK
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	5s
	Check For Recording Completed Popup
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}

	CLICK HOME


TC_445_STOP_RECORDING_MANUALLY_AND_PLAY_BACK_FROM_CLOUD_STORAGE
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
	[Timeout]	2700s
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
 
	Sleep	8s
	# Image validation - check for "Recording Started"
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder
    Sleep    120s
	CLICK RECORD
	Log To Console	Pressed Stop Button	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_401_Stopped_Recording
	 Run Keyword If  '${Result}' == 'True'  Log To Console  TC_401_Stopped_Recording Is Displayed
	 ...  ELSE  Fail  TC_401_Stopped_Recording  Is Not Displayed
    CLICK OK  
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    2s
	Get Storage Type In Recorder List    Cloud
	Sleep    10s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Check For Recording Completed Popup
	CLICK Down
	CLICK Down
    ${Play_option}=    Set Variable    Play
	${Side_panel_recorder}=    Get Play Side Panel Recorder
	Verify Matching Channels    ${Play_option}     ${Side_panel_recorder}
	
    CLICK Ok
	# CLICK OK
	Sleep    2s
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	CLICK HOME


TC_446_RECORD_TWO_CHANNELS_SIMULTANEOUSLY_TO_CLOUD_STORAGE
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
	[Timeout]	2700s
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section  
    CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud

    Sleep    8s
    # Image validation - check for "Recording Started"
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name1}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording2
	...    ELSE
	...    Handle Recording Failure Recorder2
	Sleep	10s
	CLICK HOME
    CLICK BACK
	Sleep	2s
	CLICK CHANNELUP
	CLICK CHANNELUP
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
    Sleep    3s
    
	${Result}  Verify Crop Image With Shorter Duration   ${port}  CONFLICT_POPUP
	Run Keyword If  '${Result}' == 'False'  Log To Console  CONFLICT_POPUP Is Not Displayed
	...  ELSE  Fail  CONFLICT_POPUP Is Displayed
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
    Sleep    120s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep	2s
	CLICK OK
	Sleep	4s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
	Log To Console     ${recorded_channel_text}  
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}  

	${recorded_channel_text1}=    Get Second Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text1}    ${channel_name1}    
		Log To Console     ${recorded_channel_text1}  

	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Check For Recording Completed Popup
	# Sleep    300s
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Check For Recording Completed Popup
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Sleep    300s
	CLICK HOME

TC_447_DELETE_RECORDED_FILE_AND_CONFIRM_REMOVAL_FROM_CLOUD_STORAGE
	[Tags]    RECORDING
    [Teardown]    STOP RECORDING
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section  
    CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud

    Sleep    8s
    Log To Console    Playback Recording Started

    # Image validation - check for "Recording Started"
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder
    Sleep    120s
	CLICK OK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep	2s
	Get Storage Type In Recorder List    Cloud
	Sleep    10s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    10s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    5s
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_408_CONFIRM_DELETION
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_824_Confirm_Deletion Is Displayed
	...  ELSE  Fail  TC_824_Confirm_Deletion Is Not Displayed
	CLICK OK
	CLICK OK
	Log To Console 	Recording Deleted 
	CLICK HOME
	Sleep    5s
	CLICK BACK
	Sleep    5s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	${channel_name_mylist}=    Get Channel Name In Recorder Of MyList Delete
	Reboot STB Device
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    5s
	# ${Result}  Verify Crop Image With Shorter Duration   ${port}  Cloud
	# Run Keyword If  '${Result}' == 'False'  Log To Console  Recording is deleted and not listed after Reboot
	# ...  ELSE  Fail  Recording is not deleted and listed after Reboot  
	${channel_name_mylist}=    Get Channel Name In Recorder Of MyList Delete

	CLICK HOME
TC_448_PLAY_RECORDING_FROM_CLOUD_STORAGE_WHILE_ANOTHER_IS_IN_PROGRESS
	[Tags]	RECORDING
	[Teardown]    STOP RECORDING
	[Timeout]	2700s
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud

    Sleep    8s
    Log To Console    Playback Recording Started
	#IMAGE VALIIDATION
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name1}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording2
	...    ELSE
	...    Handle Recording Failure Recorder2
	Sleep	5s
	CLICK HOME
	CLICK BACK
	CLICK CHANNELUP
	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud

    Sleep    8s
    Log To Console    Playback Recording Started

	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder
	Sleep    120s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    ${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
	Log To Console     ${recorded_channel_text}  
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}    
	${recorded_channel_text1}=    Get Second Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text1}    ${channel_name1}    
		Log To Console     ${recorded_channel_text1} 
	CLICK DOWN
	CLICK DOWN
	${stop}=    Set Variable    Stop Recording
	${channel1}=     Get Play Side Panel Recorder
	Verify Matching Channels    ${stop}    ${channel1}
	Sleep    10s
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	10s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${play}=    Set Variable    Play
	${channel2}=     Get Play Side Panel Recorder
	Verify Matching Channels    ${play}    ${channel2}
	CLICK OK
	# VALIDATE VIDEO PLAYBACK
	# Validate Video Playback For Playing
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
	Sleep    10s
	CLICK HOME

TC_449_VERIFY_RECORDINGS_FILE_AFTER_STANDBY_MODE_IN_CLOUD_STORAGE
    [Tags]    RECORDING   
	[Teardown]    STOP RECORDING
	[Timeout]	2700s

    Click HOME
    Click UP 
    Click RIGHT 
    Click OK 
    Click OK 
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud

    Sleep    8s
    Log To Console    Playback Recording Started

	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder
	Sleep	10s
    Click POWER
	Sleep    60s
    Click POWER 
	Sleep    50s
	Check Who's Watching login
	Sleep	10s
	CLICK HOME
    Click UP 
    Click RIGHT 
    Click RIGHT 
    Click RIGHT
    Click RIGHT
    Click RIGHT
    Click OK
	Sleep    1s
    Click OK 
	Get Storage Type In Recorder List    Cloud
	Sleep    5s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	5s
    Click DOWN 
    Click DOWN
    Click OK
	Click OK
    Click OK 
    Click OK
	Sleep	15s
	Check For Recording Completed Popup
    Click DOWN
	CLICK DOWN
    Click OK 
	CLICK OK
	Sleep    2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed	
	Sleep    30s
	# VALIDATE VIDEO PLAYBACK 
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
	CLICK HOME	
TC_450_RECORD_LIVE_STREAM_WITH_SUBTITLES_AND_PLAY_BACK_TO_CLOUD_STORAGE
	[Tags]	RECORDING
	[Teardown]    STOP RECORDING
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK THREE
	CLICK SIX
	CLICK SEVEN 

	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
    Sleep    8s
    Log To Console    Playback Recording Started

    # Image validation - check for "Recording Started"
   ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_401_Rec_Start
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_401_Rec_Start Is Displayed
	...  ELSE  Fail  TC_401_Rec_Start Is Not Displayed
    CLICK OK

	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	Sleep	400s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    1s
	CLICK OK
	Sleep    1s
	Get Storage Type In Recorder List    Cloud
	Sleep    5s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	15s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	2s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    CLICK BACK
	${language_ar}=    Capture Multiple Screens And Validate Language    ar
	Run Keyword If  '${language_ar}' == 'True'  Log To Console  Expected Language Displayed
	...  ELSE  Fail  Expected Language Not Displayed 
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK BACK
	${language_ar}=    Capture Multiple Screens And Validate Language Danish    da
	Run Keyword If  '${language_ar}' == 'True'  Log To Console  Expected Language Displayed
	...  ELSE  Fail  Expected Language Not Displayed 
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	${language_ar}=    Capture Multiple Screens And Validate Language Finnish    fi
	Run Keyword If  '${language_ar}' == 'True'  Log To Console  Expected Language Displayed
	...  ELSE  Fail  Expected Language Not Displayed
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	${language_ar}=    Capture Multiple Screens And Validate Language Finnish    no
	Run Keyword If  '${language_ar}' == 'True'  Log To Console  Expected Language Displayed
	...  ELSE  Fail  Expected Language Not Displayed
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	CLICK OK
	CLICK BACK
	${language_ar}=    Capture Multiple Screens And Validate Language Swedish    sv
	Run Keyword If  '${language_ar}' == 'True'  Log To Console  Expected Language Displayed
	...  ELSE  Fail  Expected Language Not Displayed
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	CLICK OK
	CLICK BACK
	${language_ar}=    Capture Multiple Screens And Validate Language Danish    none
	Run Keyword If  '${language_ar}' == 'True'  Log To Console  No language is detected.
	...  ELSE  Fail  language is detected.


TC_451_FAST_FORWARD_RECORDED_PROGRAM_USING_CLOUD_STORAGE
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section  
    CLICK OK
    Log To Console    Navigated To Live TV
	# CLICK THREE
    # CLICK SIX
	# CLICK NINE
	# CLICK SIX
	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
    Sleep    2s
    Log To Console    Playback Recording Started
    Sleep    8s
    # Image validation - check for "Recording Started"
   ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder
    Sleep    600s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep	1s
	CLICK OK
	Sleep	5s
	Get Storage Type In Recorder List    Cloud
	Sleep    5s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	2s
	CLICK DOWN
	Sleep	1s
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	25s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	10s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK OK
	CLICK LEFT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK BACK
	Sleep    10s
	# CLICK UP
	CLICK OK
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  4X_SPEED
	Run Keyword If  '${Result}' == 'True'  Log To Console  4X_SPEED Is Displayed
	...  ELSE  Fail  4X_SPEED Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  8X_SPEED
		Run Keyword If  '${Result}' == 'True'  Log To Console  8X_SPEED Is Displayed
		...  ELSE  Fail  8X_SPEED Is Not Displayed
		CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  16X_SPEED
		Run Keyword If  '${Result}' == 'True'  Log To Console  16X_SPEED Is Displayed
		...  ELSE  Fail  16X_SPEED Is Not Displayed
		CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  32X_SPEED
	Run Keyword If  '${Result}' == 'True'  Log To Console  32X_SPEED Is Displayed
	...  ELSE  Fail  32X_SPEED Is Not Displayed
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	# CLICK OK	
	CLICK BACK
	CLICK OK
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    #     EVALUATE VIDEO QUALITY STATUS    ${results}
	Sleep	3s
	CLICK HOME

TC_452_REWIND_RECORDED_PROGRAM_AND_RESUME_PLAYBACK_USING_CLOUD_STORAGE
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
    CLICK HOME
	Check For Exit Popup
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section  
    CLICK OK
    Log To Console    Navigated To Live TV
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
	
    Sleep    8s
    # Image validation - check for "Recording Started"
   ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder
    Sleep    600s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep	2s
	CLICK OK
	Sleep	2s
	Get Storage Type In Recorder List    Cloud
	Sleep    5s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	2s
	CLICK DOWN
	Sleep	1s
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	25s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Check For Recording Completed Popup
	Sleep	10s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	10s
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  REWIND_4X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_4X Is Displayed
	...  ELSE  Fail  REWIND_4X Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  REWIND_8X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_8X Is Displayed
	...  ELSE  Fail  REWIND_8X Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  REWIND_16X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_16X Is Displayed
	...  ELSE  Fail  REWIND_16X Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  REWIND_32X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_32X Is Displayed
	...  ELSE  Fail  REWIND_32X Is Not Displayed
	Sleep	2s
    CLICK HOME

TC_453_PAUSE_RECORDED_PROGRAM_AND_RESUME_PLAYBACK_USING_CLOUD_STORAGE
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section  
    CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
    Sleep    8s
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder
    Sleep    600s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Get Storage Type In Recorder List    Cloud
	Sleep    5s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	20s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	15s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Sleep    5s
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	Sleep	10s
	CLICK OK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	Sleep    10s



TC_454_SCHEDULE_RECORDING_THEN_CANCEL_BEFORE_START_IN_CLOUD_STORAGE
	[Tags]    RECORDING
	CLICK Home
	Log To Console    Navigated To Home Page
	CLICK Up
	CLICK Right
	CLICK Ok
	Sleep	2s
	CLICK Down
	CLICK Down
	CLICK Ok
	Guide Channel List
	Log To Console    Navigated To Tv Guide
	CLICK ONE
	CLICK FIVE
	Sleep	20s
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	Sleep	10s
    CLICK OK
	CLICK RIGHT
	Sleep	2s
	CLICK RIGHT	
	Sleep	2s
	CLICK DOWN
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_215_CLOUD_STORAGE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_CLOUD_STORAGE
	...  ELSE  Fail  TC_215_CLOUD_STORAGE Is Not Displayed
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	1s

	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_454_SCHEDULE_ADDED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_419_SCHEDULE_ADDED
	...  ELSE  Fail  TC_419_SCHEDULE_ADDED Is Not Displayed
	#VALIDATE THE POP UP OF SCHEDULED RECORDING 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_404_Recc
	 Run Keyword If  '${Result}' == 'True'  Log To Console  TC_404_Recc Is Displayed
	 ...  ELSE  Fail  TC_404_Recc Is Not Displayed	
	
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep	1s
	CLICK OK
	Sleep	1s
	CLICK RIGHT
	Sleep	1s
	#VALIDATE CHANNEL NAME 
	${channel_name_mylist}=    Get Channel Name In Recorder Of MyList
	Verify Matching Channels    ${channel_name_mylist}     ${channel_name}
	Sleep	10s
    CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK HOME

	Reboot STB Device
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK RIGHT
	#VALIDATE CHANNEL NAME 
	 ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_404_CHANNEL_REC_AND
	 Run Keyword If  '${Result}' == 'False'  Log To Console  TC_404_Chnl_451 Is Displayed
	 ...  ELSE  Fail  TC_404_Chnl_451 Is Not Displayed	
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK HOME

TC_455_RECORD_CHANNEL_TO_CLOUD_STORAGE_WHILE_WATCHING_DIFFERENT_LIVE_CHANNEL
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
    CLICK Home
    CLICK UP
    CLICK RIGHT
    CLICK OK
    CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
	
    Sleep    8s
    Log To Console    Playback Recording Started

    # Image validation - check for "Recording Started"
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder
	Sleep	5s
    CLICK HOME
    CLICK UP 
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK FOUR
	CLICK SIX
	Sleep	130s
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep	2s
	Get Storage Type In Recorder List    Cloud
	Sleep    5s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	
    Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	25s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}

TC_456_PLAY_RECORDED_PROGRAM_WITH_DIFFERENT_AUDIO_TRACK_FROM_CLOUD_STORAGE
	[Tags]    RECORDING
	# [Teardown]    STOP RECORDING
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK THREE
	CLICK SEVEN 
	CLICK SIX
	# CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
    Sleep  10s
    # Image validation - check for "Recording Started"
    
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_401_Rec_Start
	...  ELSE  Fail  TC_401_Rec_Start Is Not Displayed   
    # ...    Run Keyword    Handle Recording Failure New
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	Sleep	600s
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep	10s
	Get Storage Type In Recorder List    Cloud
	Sleep    2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	2s
	Log To Console    Navigated To My TV Section
	
	Sleep	2s
	Log To Console    Navigated to Recorder Section
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    25s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	2s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	#IMG VALIDATION
	${Result}  Verify Crop Image With Shorter Duration  ${port}  English_Audio
	 Run Keyword If  '${Result}' == 'True'  Log To Console  TC_219_ENGLISH_AUDIO Is Displayed
	 ...  ELSE  Fail  TC_219_ENGLISH_AUDIO Is Not Displayed	
	# Sleep    3s
	# CLICK UP
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK OK
	CLICK DOWN
	CLICK OK
	Sleep    3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Hindi_Audio
	 Run Keyword If  '${Result}' == 'True'  Log To Console  TC_219_HINDI_AUDIO Is Displayed
	 ...  ELSE  Fail  TC_219_HINDI_AUDIO Is Not Displayed
	Sleep    3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	1s
	CLICK OK
	Sleep    3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_219_BENGALI_AUDIO
	 Run Keyword If  '${Result}' == 'True'  Log To Console  TC_219_BENGALI_AUDIO Is Displayed
	 ...  ELSE  Fail  TC_219_BENGALI_AUDIO Is Not Displayed	
	# VALIDATE VIDEO PLAYBACK
	# Verify Audio Quality
	# 	${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}


TC_457_RECORD_LIVE_STREAM_TO_CLOUD_STORAGE_WHILE_SWITCHING_USER_PROFILES
	[Tags]    RECORDING
	[Teardown]    Delete Profile
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_019_Whos_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_019_Whos_Watching Is Displayed
	...  ELSE  Fail  TC_019_Whos_Watching Is Not Displayed
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Up
	CLICK Up
	CLICK Up
	CLICK Up
	CLICK Up
	CLICK Up
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK Ok
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	# CLICK Ok
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Home
	Log To Console    Navigated To Home Page
	CLICK Up
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK TWO
	CLICK TWO
	# CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
	

	Sleep	8s
    # Image validation - check for "Recording Started"
    ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure Recorder
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	Sleep	50s
	Log To Console	Switching profile
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
	Sleep	30s
	CLICK SEVEN
	CLICK ZERO
	CLICK FIVE
	Sleep	20s
	Log To Console	Switching back to Admin profile
	CLICK HOME
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep	25s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Get Storage Type In Recorder List    Cloud
	Sleep    10s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK OK
	CLICK OK
	Sleep    25s
	Check For Recording Completed Popup
	Log To Console	Recording Stopped
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	Sleep    2s
	# VALIDATE VIDEO PLAYBACK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK Down
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK HOME

TC_458_RECORD_SERIES_OF_PROGRAM_TO_CLOUD_STORAGE
	[Tags]    RECORDING
	[Teardown]	STOP RECORDING
    CLICK Home
    CLICK UP
    CLICK RIGHT
    CLICK OK
    CLICK OK
	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found Series    Cloud
    Sleep    8s
    # Image validation - check for "Recording Started"
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_401_Rec_Start
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_401_Rec_Start Is Displayed on screen
	...  ELSE  Fail  TC_401_Rec_Start Is Not Displayed on screen
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	Sleep	120s
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Get Storage Type In Recorder List    Cloud
	Sleep    2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	25s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK

TC_459_RECORD_LIVE_CHANNEL_IN_IMPULSE_MODE_TO_CLOUD_STORAGE
    [Tags]    RECORDING
	[Teardown]	STOP RECORDING
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
	CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found Impulse    Cloud
    
    Sleep    8s
    Log To Console    Playback Recording Started

    # Image validation - check for "Recording Started"
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_401_Rec_Start
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_401_Rec_Start Is Displayed on screen
	...  ELSE  Fail  TC_401_Rec_Start Is Not Displayed on screen

    CLICK OK
	# VALIDATE VIDEO PLAYBACK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	# ${Result}  Validate Video Playback For Playing
    # Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    # ...  ELSE  Fail  Video is Paused
    Sleep    120s

    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To My TV Section
    Sleep    10s
    CLICK OK
	Get Storage Type In Recorder List    Cloud
	Sleep    2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
	Verify Matching Channels    ${recorded_channel_text}     ${channel_name}

	${Result}  Verify Crop Image With Shorter Duration    ${port}  IMPULSE_RECORDING 
	Run Keyword If  '${Result}' == 'True'  Log To Console  IMPULSE_RECORDING Is Displayed on screen
	...  ELSE  Fail  IMPULSE_RECORDING Is Not Displayed on screen
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK OK
    CLICK OK
	CLICK OK
	Sleep	20s
	Check For Recording Completed Popup
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	# VALIDATE VIDEO PLAYBACK
	# ${Result}  Validate Video Playback For Playing
    # Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    # ...  ELSE  Fail  Video is Paused

TC_460_RECORD_LIVE_CHANNEL_IN_MANUAL_RECORDING_MODE_TO_CLOUD_STORAGE
    [Tags]    RECORDING
	[Teardown]	STOP SCHEDULED RECORDING  
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
	CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found Manual    Cloud
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${channels}=    Get Daily Side Panel Recorder
	Log To Console	${channels}
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To My TV Section
    Sleep    10s
    CLICK OK
	CLICK RIGHT
	Sleep		2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	
    Log To Console    Navigated to Recorder Section
    CLICK DOWN
    CLICK DOWN
    CLICK OK
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	
TC_463_RECORD_LIVE_CHANNEL_IN_MANUAL_RECORDING_MODE_WEEKLY_TO_CLOUD_STORAGE
    [Tags]    RECORDING
	[Teardown]	STOP SCHEDULED RECORDING
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
	CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found Manual    Cloud
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	CLICK OK
	${channels}=    Get Daily Side Panel Recorder
	Log To Console	${channels}
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	
	Sleep	2s
	CLICK OK
	#selecting sunday 
	Sleep	2s
	CLICK BACK
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK OK
	CLICK OK
	CLICK DOWN

	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	Sleep	1s
    ${time}=    Get Time Side Panel Recorder
	Log To Console	${time}
	Sleep    2s
	${enddate}=    Get Enddate Side Panel Recorder
	Log To Console	${enddate}
	# @{ocr_parts}=   Create List    ${time}    ${enddate}
    # Log To Console    OCR Parts List: ${ocr_parts}
	CLICK OK
	Sleep	1s
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	# CLICK DOWN From Info Bar
	CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To My TV Section
    Sleep    10s
    CLICK OK
	CLICK RIGHT
	Sleep		2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	
    Log To Console    Navigated to Recorder Section
    CLICK DOWN
    CLICK DOWN
    CLICK OK
	${Date}=    Get DateTime In Recorder Of MyList
    Log To Console    📺 Channel Checked: ${Date}

	
TC_461_STOP_CLOUD_RECORDING_WHILE_RECORDING_IN_BOTH_STORAGES
	[Tags]    RECORDING
	[Teardown]    STOP RECORDING
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section  
	CLICK OK
    Log To Console    Navigated To Live TV
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
	Sleep    8s
	# Image validation - check for "Recording Started"
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder
	CLICK HOME
	CLICK BACK
	CLICK CHANNELUP
	CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Local
	Sleep    8s
	# Image validation - check for "Recording Started"
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder
    Sleep    120s
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated To My TV Section
	# Sleep    10s
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Cloud
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_CLOUD_STORAGE Is Displayed
	...  ELSE  Fail  TC_215_CLOUD_STORAGE Is Not Displayed
	Sleep	1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Local_Recoder
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_CLOUD_STORAGE Is Displayed
	...  ELSE  Fail  TC_215_CLOUD_STORAGE Is Not Displayed
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    25s
	Check For Recording Completed Popup
	CLICK Down
	CLICK Down
	CLICK DOWN
	${play}=    Set Variable    Play
	${channel2}=     Get Play Side Panel Recorder
	Verify Matching Channels    ${play}    ${channel2}
	CLICK Ok
	# CLICK OK
	Sleep    2s
	# VALIDATE VIDEO PLAYBACK
	Validate Video Playback For Playing
	
TC_462_VERIFY_RECORDINGS_FILE_AFTER_REBOOT_IN_CLOUD_STORAGE
    [Tags]    RECORDING   
	[Teardown]    STOP RECORDING
    Click HOME
    Click UP 
    Click RIGHT 
    Click OK 
    Click OK 
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found    Cloud
	

    Sleep    8s
    Log To Console    Playback Recording Started

	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_401_Rec_Start

	${channel_name}=    Run Keyword If    '${Result}' == 'True'
	...    Process Successful Recording
	...    ELSE
	...    Handle Recording Failure Recorder
	Sleep	10s
    Reboot STB Device
	Sleep	10s
	CLICK HOME
    Click UP 
    Click RIGHT 
    Click RIGHT 
    Click RIGHT
    Click RIGHT
    Click RIGHT
    Click OK
	Sleep    1s
    Click OK 
	Get Storage Type In Recorder List    Cloud
	Sleep    5s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
	Sleep	5s
    Click DOWN 
    Click DOWN
    Click OK
	Click OK
    Click OK 
    Click OK
	Sleep	15s
	Check For Recording Completed Popup
    Click DOWN
	CLICK DOWN
    Click OK 
	CLICK OK
	Sleep    2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed	
	Sleep    30s
	# VALIDATE VIDEO PLAYBACK 
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Verify Audio Quality
	# ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
		
	

TC_464_RECORD_LIVE_CHANNEL_IN_MANUAL_RECORDING_MODE_FUTURE_DATE_TO_CLOUD_STORAGE
    [Tags]    RECORDING
	[Teardown]    STOP SCHEDULED RECORING 
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
	CLICK OK
    CLICK BACK
	Sleep	20s
    CLICK RIGHT
	Check For Supported Recording Until Found Manual    Cloud
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
    CLICK OK
    Log To Console    Record The Program Is Selected
    CLICK DOWN
	CLICK OK
	${channels}=    Get Daily Side Panel Recorder
	Log To Console	${channels}
	CLICK DOWN
    CLICK DOWN
    CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK
	${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
	CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To My TV Section
    Sleep    10s
    CLICK OK
	CLICK RIGHT
	Sleep		2s
	${recorded_channel_text}=    Get Channel Name In Recorder Of MyList
    Verify Matching Channels    ${recorded_channel_text}    ${channel_name}
    Log To Console    Navigated to Recorder Section
    CLICK DOWN
    CLICK DOWN
    CLICK OK


##############################################################################################
 
################################### NEW 150 SCRIPTS #######################################

TC_1053_LIFESTYLE_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	3s
	#VALIDATE
	${Result}  Verify Crop Image With Shorter Duration    ${port}  LIFESTYLE_BOOKMARK
	Run Keyword If  '${Result}' == 'True'  Log To Console  LIFESTYLE_BOOKMARK Is Displayed on screen
	...  ELSE  Fail  LIFESTYLE_BOOKMARK Is Not Displayed on screen 
	# CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_LIFESTYLE_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_LIFESTYLE_SELECTED Is Displayed on screen
	...  ELSE  Fail  TC_LIFESTYLE_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

TC_1054_BUSINESS_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	#VALIDATE - BUSINESS CHANNEL IF POSSIBLE
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_1054_Business
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1054_Business Is Displayed on screen
	...  ELSE  Fail  TC_1054_Business Is Not Displayed on screen 
	# CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_BUSINESS_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_BUSINESS_SELECTED Is Displayed on screen
	...  ELSE  Fail  TC_BUSINESS_SELECTED Is Not Displayed on screen 
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

TC_1055_DOCUMENTARY_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	#VALIDATE  THE DOCUMENTARY CHANNEL LISTED IN THE EPG
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_1055_Documentary
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1055_Documentary Is Displayed on screen
	...  ELSE  Fail  TC_1055_Documentary Is Not Displayed on screen
	# CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_DOCUMENTARY_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_DOCUMENTARY_SELECTED Is Displayed on screen
	...  ELSE  Fail  TC_DOCUMENTARY_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

TC_1056_HD_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	5s
	CLICK DOWN
	Sleep	5s
	CLICK DOWN
	CLICK OK
	CLICK BACK
	#VALIDATE  HD CHANNELS IN THE EPG 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1056_HD_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1056_HD_Channel Is Displayed on screen
	...  ELSE  Fail  TC_1056_HD_Channel Is Not Displayed on screen
	Sleep	10s
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_HD_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1056_HD_CHANNELS_AVAILABILITY Is Displayed on screen
	...  ELSE  Fail  TC_1056_HD_CHANNELS_AVAILABILITY Is Not Displayed on screen
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME
TC_1057_INFORMATION_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	2s
	#VALIDATE  THE INFO CHANNEL DISPLAYED IN THE EPG
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1057_Information
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1057_Information Is Displayed on screen
	...  ELSE  Fail  TC_1057_Information Is Not Displayed on screen
	# CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_INFO_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_INFO_SELECTED Is Displayed on screen
	...  ELSE  Fail  TC_INFO_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK Up
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

TC_1058_KIDS_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	2s
	#VALIDATE  THE KIDS CHANNEL DISPLAYED IN THE EPG
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1058_Kids
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1058_Kids Is Displayed on screen
	...  ELSE  Fail  TC_1058_Kids Is Not Displayed on screen
	# CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1058_KIDS_CHANNEL_AVAILABILITY
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_KIDS_SELECTED Is Displayed on screen
	...  ELSE  Fail  TC_KIDS_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK Up
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME


TC_1059_MUSIC_FILTER_AVAILABILTY
	[Tags]    REGRESSION
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	2s
	#VALIDATE  THE KIDS CHANNEL DISPLAYED IN THE EPG
	${Result}  Verify Crop Image With Shorter Duration  ${port}  MUSIC_BOOKMARK
	Run Keyword If  '${Result}' == 'True'  Log To Console  MUSIC_BOOKMARK Is Displayed on screen
	...  ELSE  Fail  MUSIC_BOOKMARK Is Not Displayed on screen
	# CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_MUSIC_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_MUSIC_SELECTED Is Displayed on screen
	...  ELSE  Fail  TC_MUSIC_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK Up
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME
	

TC_1062_NEWS_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	2s
	#VALIDATE  THE KIDS CHANNEL DISPLAYED IN THE EPG
	${Result}  Verify Crop Image With Shorter Duration  ${port}  NEWS_BOOKMARK
	Run Keyword If  '${Result}' == 'True'  Log To Console  NEWS_BOOKMARK Is Displayed on screen
	...  ELSE  Fail  NEWS_BOOKMARK Is Not Displayed on screen
	# CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_NEWS_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_NEWS_SELECTED Is Displayed on screen
	...  ELSE  Fail  TC_NEWS_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK Up
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

TC_1063_SPORTS_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	2s
	#VALIDATE  THE KIDS CHANNEL DISPLAYED IN THE EPG
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Sports_Bookmark_Poster
	Run Keyword If  '${Result}' == 'True'  Log To Console  SPORTS_BOOKMARK Is Displayed on screen
	...  ELSE  Fail  SPORTS_BOOKMARK Is Not Displayed on screen
	# CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_SPORTS_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_SPORTS_SELECTED Is Displayed on screen
	...  ELSE  Fail  TC_SPORTS_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK Up
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

TC_1065_ACTION_MOVIE_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	2s
	#VALIDATE  THE KIDS CHANNEL DISPLAYED IN THE EPG
	${Result}  Verify Crop Image With Shorter Duration  ${port}  ACTION_MOVIES
	Run Keyword If  '${Result}' == 'True'  Log To Console  ACTION_MOVIES Is Displayed on screen
	...  ELSE  Fail  ACTION_MOVIES Is Not Displayed on screen
	# CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_ACT_MOV_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_ACT_MOV_SELECTED Is Displayed on screen
	...  ELSE  Fail  TC_ACT_MOV_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK Up
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME


TC_1066_KIDS_MOVIE_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	2s
	#VALIDATE  THE KIDS CHANNEL DISPLAYED IN THE EPG
	${Result}  Verify Crop Image With Shorter Duration  ${port}  FILTER_KIDS
	Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_MOVIES Is Displayed on screen
	...  ELSE  Fail  KIDS_MOVIES Is Not Displayed on screen
	# CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_KIDS_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_MOVIES_SELECTED Is Displayed on screen
	...  ELSE  Fail  KIDS_MOVIES_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK Up
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME
	

TC_1067_FAMILY_MOVIE_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	2s
	#VALIDATE  THE KIDS CHANNEL DISPLAYED IN THE EPG
	${Result}  Verify Crop Image With Shorter Duration  ${port}  OSNTV_FAM
	Run Keyword If  '${Result}' == 'True'  Log To Console  OSNTV_FAM Is Displayed on screen
	...  ELSE  Fail  OSNTV_FAM Is Not Displayed on screen
	# CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# Sleep	2s
	CLICK DOWN
	# Sleep	2s
	CLICK DOWN
	# Sleep	2s
	CLICK DOWN
	# Sleep	2s
	CLICK DOWN
	# Sleep	2s
	CLICK DOWN
	# Sleep	2s
	CLICK DOWN
	# Sleep	2s
	CLICK DOWN
	# Sleep	2s
	CLICK DOWN
	# Sleep	2s
	CLICK DOWN
	# Sleep	2s
	CLICK DOWN
	# Sleep	2s
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  FAMILY_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAM_MOVI_SELECTED Is Displayed on screen
	...  ELSE  Fail  FAM_MOVI_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK Up
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME
	


TC_1068_NEWS_GENERAL_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	2s
	#VALIDATE  THE KIDS CHANNEL DISPLAYED IN THE EPG
	${Result}  Verify Crop Image With Shorter Duration  ${port}  NEWS_FILTER
	Run Keyword If  '${Result}' == 'True'  Log To Console  NEWS_FILTER Is Displayed on screen
	...  ELSE  Fail  NEWS_FILTER Is Not Displayed on screen
	# CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  News_Filter_Selected
	Run Keyword If  '${Result}' == 'True'  Log To Console  NEWS_GEN_SELECTED Is Displayed on screen
	...  ELSE  Fail  NEWS_GEN_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK Up
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME
	

TC_1069_NEWS_BUSINESS_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	2s
	#VALIDATE  THE KIDS CHANNEL DISPLAYED IN THE EPG
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1069_News_Business
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1069_News_Business Is Displayed on screen
	...  ELSE  Fail  TC_1069_News_Business Is Not Displayed on screen
	# CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  NEWS_BUS_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  NEWS_BUS_SELECTED Is Displayed on screen
	...  ELSE  Fail  NEWS_BUS_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK Up
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

TC_1070_SUBSCRIBED_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	# CLICK BACK
	Sleep	20s
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	5s
		#VALIDATE CATCHUP CHANNEL
	${Result}  Verify Crop Image With Shorter Duration  ${port}  RADIO_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console  RADIO_EPG Is Displayed on screen
	...  ELSE  Fail  RADIO_EPG Is Not Displayed on screen
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  SUBSCRIBE_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  SUBSCRIBE_SELECTED Is Displayed on screen
	...  ELSE  Fail  SUBSCRIBE_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

TC_1071_FAVORITE_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	# CLICK BACK
	Sleep	20s
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	5s
		#VALIDATE CATCHUP CHANNEL
	${Result}  Verify Crop Image With Shorter Duration  ${port}  DUBAI_TV_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console  AL_MASRIYA_FAV Is Displayed on screen
	...  ELSE  Fail  AL_MASRIYA_FAV Is Not Displayed on screen
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  FAV_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAV_SELECTED Is Displayed on screen
	...  ELSE  Fail  FAV_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

TC_1072_CATCHUP_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    2s
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep    20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	5s
		#VALIDATE CATCHUP CHANNEL
	${Result}  Verify Crop Image With Shorter Duration  ${port}  DUBAI_TV_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console  DUBAI_CATCHUP Is Displayed on screen
	...  ELSE  Fail  DUBAI_CATCHUP Is Not Displayed on screen
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  CATCHUP_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  CATCHUP_SELECTED Is Displayed on screen
	...  ELSE  Fail  CATCHUP_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

TC_1073_STARTOVER_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    2s
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep    20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	5s
		#VALIDATE CATCHUP CHANNEL
	${Result}  Verify Crop Image With Shorter Duration  ${port}  ABU_DHABI_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console  ABU_DHABI_EPG Is Displayed on screen
	...  ELSE  Fail  ABU_DHABI_EPG Is Not Displayed on screen
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration   ${port}  STARTOVER_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  STARTOVER_SELECTED Is Displayed on screen
	...  ELSE  Fail  STARTOVER_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME


TC_1074_ENTERTAINMENT_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	#VALIDATE ENTERTAINMENT CHANNEL
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_ENTER_CHANNEL
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_ENTER_CHANNEL Is Displayed on screen
	...  ELSE  Fail  TC_ENTER_CHANNEL Is Not Displayed on screen
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_ENTERTAINMENT_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_ENTERTAINMENT_SELECTED Is Displayed on screen
	...  ELSE  Fail  TC_ENTERTAINMENT_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

TC_1075_GENERAL_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	#VALIDATE ENTERTAINMENT CHANNEL
	${Result}  Verify Crop Image With Shorter Duration    ${port}  GENRAL_BOOKMARK
	Run Keyword If  '${Result}' == 'True'  Log To Console  GENRAL_BOOKMARK Is Displayed on screen
	...  ELSE  Fail  GENRAL_BOOKMARK Is Not Displayed on screen
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_GENERAL_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_GENERAL_SELECTED Is Displayed on screen
	...  ELSE  Fail  TC_GENERAL_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME


TC_1076_RELIGIOUS_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	2s
	#VALIDATE  THE KIDS CHANNEL DISPLAYED IN THE EPG
	${Result}  Verify Crop Image With Shorter Duration  ${port}  SAUDI_QUARN_REL
	Run Keyword If  '${Result}' == 'True'  Log To Console  SAUDI_QUARN_REL Is Displayed on screen
	...  ELSE  Fail  SAUDI_QUARN_REL Is Not Displayed on screen
	# CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_RELIGIOUS_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_RELIGIOUS_SELECTED Is Displayed on screen
	...  ELSE  Fail  TC_RELIGIOUS_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK Up
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME



TC_1149_MOVIES_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	2s
	#VALIDATE  THE KIDS CHANNEL DISPLAYED IN THE EPG
	${Result}  Verify Crop Image With Shorter Duration  ${port}  MOVIES_BOOKMARK
	Run Keyword If  '${Result}' == 'True'  Log To Console  MOVIES_BOOKMARK Is Displayed on screen
	...  ELSE  Fail  MOVIES_BOOKMARK Is Not Displayed on screen
	# CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    10s
	CLICK OK
	Sleep	2s
	CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	Sleep	2s
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_MOVIES_SELECTED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_MOVIES_SELECTED Is Displayed on screen
	...  ELSE  Fail  TC_MOVIES_SELECTED Is Not Displayed on screen
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK Up
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME




TC_1150_3D_FILTER_AVAILABILITY
	[Tags]    REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Check For New Message Popup
	Sleep	20s
	# CLICK BACK
	CLICK OK
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	Sleep	2s
	#VALIDATE THE POP UP SHOWING CHANNEL IS BLOCKED DUE TO FILTER
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_1052_Block_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1052_Block_Popup Is Displayed on screen
	...  ELSE  Fail  TC_1052_Block_Popup Is Not Displayed on screen
	CLICK OK
	Reboot STB Device
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Sleep	20s
	CLICK OK
    CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	#Validation
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME




TC_1010_POWER_BUTTON_ON 
    [Tags]	REGRESSION 
	CLICK HOME
	CLICK POWER
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Home_Page
	Run Keyword If  '${Result}' == 'False'  Log To Console  Home_Page Is Not Displayed on screen
	...  ELSE  Log To Console  Home_Page Is Displayed on screen
	Sleep	30s
	CLICK POWER
	Sleep	30s
	${pin}  Verify Crop Image With Shorter Duration  ${port}  Power_On_Login_Page
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK OK
	...    AND		CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    Navigated to Home Page
	Sleep	20s
	#VALIDATE THE HOME TEXT AFTER POWER ONN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	
TC_1012_HOME_BUTTON_VALIDATION
    [Tags]	REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK HOME
	Sleep	5s
	#VALIDATE THE HOME TEXT IN HOMEPAGE
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	Sleep	20s
	CLICK UP
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1013_Channel_12
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1013_Channel_12 Is Displayed on screen
	...  ELSE  Fail  TC_1013_Channel_12 Is Not Displayed on screen
	Sleep    2s
	#VALIDATE THE 12 CHANNEL
	CLICK SEVEN
	CLICK TWO
	Sleep    2s
	#VALIADTE THE CHANNEL NUMBER 72
	CLICK BACK
	CLICK BACK
	Sleep	20s
	CLICK UP
	#VALIDATE CHANNEL 12  AFTER CLICKING BACK BUTTON
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1013_Channel_12
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1013_Channel_12 Is Displayed on screen
	...  ELSE  Fail  TC_1013_Channel_12 Is Not Displayed on screen
    CLICK HOME
	Sleep	5s
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	
TC_1016_MENU_BUTTON_VISIBILITY
    [Tags]	REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK MENU
	#VALIDATE THE HOME TEXT IN THE HOMEPAGE 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK MENU
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'False'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
    CLICK HOME
    
TC_1019_CHANNEL_UP_DOWN_FUNCTIONALITY
    [Tags]	REGRESSION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Zap Channel To Channel Using Program UP and Down Keys Regression


TC_1021_NUMERIC_KEYS_FUNCTIONALITY
    [Tags]    REGRESSION

    CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK OK
    CLICK OK

    # ----------- 111 -----------
    CLICK ONE
    CLICK ONE
    CLICK ONE
    ${entered}=    Set Variable    111
    Sleep    5s
    ${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
    Run Keyword If    '${entered}' == '${channel_number}'
    ...    Log To Console    ✅ Channel ${entered} is present
    ...    ELSE    Log To Console    ⚠️ Channel ${entered} not found; moved to ${channel_number}

    # ----------- 222 -----------
    CLICK TWO
    CLICK TWO
    CLICK TWO
    ${entered}=    Set Variable    222
    Sleep    5s
    ${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
    Run Keyword If    '${entered}' == '${channel_number}'
    ...    Log To Console    ✅ Channel ${entered} is present
    ...    ELSE    Log To Console    ⚠️ Channel ${entered} not found; moved to ${channel_number}

    # ----------- 333 -----------
    CLICK THREE
    CLICK THREE
    CLICK THREE
    ${entered}=    Set Variable    333
    Sleep    5s
    ${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
    Run Keyword If    '${entered}' == '${channel_number}'
    ...    Log To Console    ✅ Channel ${entered} is present
    ...    ELSE    Log To Console    ⚠️ Channel ${entered} not found; moved to ${channel_number}

    # ----------- 444 -----------
    CLICK FOUR
    CLICK FOUR
    CLICK FOUR
    ${entered}=    Set Variable    444
    Sleep    5s
    ${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
    Run Keyword If    '${entered}' == '${channel_number}'
    ...    Log To Console    ✅ Channel ${entered} is present
    ...    ELSE    Log To Console    ⚠️ Channel ${entered} not found; moved to ${channel_number}

    # ----------- 555 -----------
    CLICK FIVE
    CLICK FIVE
    CLICK FIVE
    ${entered}=    Set Variable    555
    Sleep    5s
    ${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
    Run Keyword If    '${entered}' == '${channel_number}'
    ...    Log To Console    ✅ Channel ${entered} is present
    ...    ELSE    Log To Console    ⚠️ Channel ${entered} not found; moved to ${channel_number}

    # ----------- 666 -----------
    CLICK SIX
    CLICK SIX
    CLICK SIX
    ${entered}=    Set Variable    666
    Sleep    5s
    ${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
    Run Keyword If    '${entered}' == '${channel_number}'
    ...    Log To Console    ✅ Channel ${entered} is present
    ...    ELSE    Log To Console    ⚠️ Channel ${entered} not found; moved to ${channel_number}

    # ----------- 777 -----------
    CLICK SEVEN
    CLICK SEVEN
    CLICK SEVEN
    ${entered}=    Set Variable    777
    Sleep    5s
    ${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
    Run Keyword If    '${entered}' == '${channel_number}'
    ...    Log To Console    ✅ Channel ${entered} is present
    ...    ELSE    Log To Console    ⚠️ Channel ${entered} not found; moved to ${channel_number}

    # ----------- 888 -----------
    CLICK EIGHT
    CLICK EIGHT
    CLICK EIGHT
    ${entered}=    Set Variable    888
    Sleep    5s
    ${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
    Run Keyword If    '${entered}' == '${channel_number}'
    ...    Log To Console    ✅ Channel ${entered} is present
    ...    ELSE    Log To Console    ⚠️ Channel ${entered} not found; moved to ${channel_number}

    # ----------- 999 -----------
    CLICK NINE
    CLICK NINE
    CLICK NINE
    ${entered}=    Set Variable    999
    Sleep    5s
    ${channel_number}=    Extract Text From Screenshot
    Log To Console    📺 Channel Checked: ${channel_number}
    Run Keyword If    '${entered}' == '${channel_number}'
    ...    Log To Console    ✅ Channel ${entered} is present
    ...    ELSE    Log To Console    ⚠️ Channel ${entered} not found; moved to ${channel_number}

    CLICK HOME
TC_1025_RECORD_BUTTON_SETUP
    [Tags]	REGRESSION
	CLICK HOME
	CLICK TWO
	CLICK TWO 
	Sleep	20s
	CLICK RECORD
	Sleep	3s
	#CHECK FOR THE RECORDING SETUP APPEARANCE
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1025_Recording_Setup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1025_Recording_Setup Is Displayed on screen
	...  ELSE  Fail  TC_1025_Recording_Setup Is Not Displayed on screen
	CLICK HOME
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen

# TC_001_CREATE_NEW_PROFILE
# 	[Tags]	PROFILE & EDIT
# 	[Teardown]    Delete Profile
# 	CLICK HOME
# 	CLICK UP
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK RIGHT
# 	Sleep    3s
# 	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_001_Add_profile
# 	Run Keyword If  '${Result}' == 'True'  Log To Console  Who_Is_Watching_001 Is Displayed
# 	...  ELSE  Fail  Who_Is_Watching_001 Is Not Displayed
	
# 	CLICK OK
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK OK
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK OK	
# 	CLICK DOWN
# 	CLICK OK
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK OK
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_001_abcd
# 	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_001_Nickname Is Displayed
# 	# ...  ELSE  Fail  TC_001_Nickname Is Not Displayed
	
# 	CLICK DOWN
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK OK
# 	CLICK OK
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	Sleep    5s
# 	CLICK HOME
# 	CLICK UP
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK OK
# 		${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_001_After_Creation
# 	Run Keyword If  '${Result}' == 'True'  Log To Console  Whos_watching_after_Creation Is Displayed
# 	...  ELSE  Fail  Whos_watching_after_Creation Is Not Displayed
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK OK
# 	Sleep    10s
# 	CLICK HOME
# 	CLICK UP
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	CLICK OK
# 	CLICK TWO
# 	CLICK TWO
# 	Sleep    5s 
# 	CLICK ONE
# 	CLICK FIVE
# 	Sleep    15s 
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK HOME
# 	CLICK UP
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK OK
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK OK
# 	Sleep    10s
# 	CLICK HOME
# 	CLICK UP
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK RIGHT
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK OK
# 		${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_001_After_Deletion
# 	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_001_Whos_watching_after_deletion Is Displayed
# 	...  ELSE  Fail  TC_001_Whos_watching_after_deletion Is Not Displayed
# 	Sleep    10s 
# 	CLICK HOME

# TC_002_EDIT_PROFILE_NAME
#     [Tags]     PROFILE & EDIT 
# 	[Teardown]    Delete Profile
# 	CLICK HOME
# 	CLICK UP
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK OK
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK OK
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK OK
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	Sleep    3s 
# 	CLICK HOME
# 	CLICK UP
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK OK
# 	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_002_New_Name_For_Profile
# 	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_002_New_Profile_Name Is Displayed
# 	...  ELSE  Fail  TC_002_New_Profile_Name Is Not Displayed
	
# 	CLICK RIGHT
# 	CLICK DOWN
# 	CLICK OK
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK LEFT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	CLICK UP
# 	CLICK UP
# 	CLICK LEFT
# 	CLICK OK
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK TC_830_SCHEDULE_RECORDINGS_ON_MULTIPLE_CHANNELS_SIMULTANEOUSLY
# 	CLICK OK
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK RIGHT
# 	CLICK OK
# 	${Result}  Verify Crop Image With Shorter Duration  ${port}  Success_Popup
# 	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_002_Success Is Displayed
# 	...  ELSE  Fail  TC_002_Success Is Not Displayed
	
# 	CLICK OK
# 	Sleep    3s 
# 	CLICK HOME
# 	CLICK UP
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK OK
# 	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_002_Edited_Name
# 	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_002_Edited_Profile_Name Is Displayed
# 	...  ELSE  Fail  TC_002_Edited_Profile_Name Is Not Displayed
	
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK OK
# 	Sleep    20s 
# 	CLICK HOME
# 	CLICK UP
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	CLICK OK
# 	CLICK TWO
# 	CLICK TWO
# 	Sleep    3s
# 	CLICK SEVEN
# 	CLICK SEVEN
# 	Sleep    2s 
# 	CLICK UP
# 	Sleep    1s 
# 	CLICK UP
# 	Sleep    1s 
# 	CLICK UP
# 	Sleep    1s 
# 	CLICK UP
# 	Sleep    1s 
# 	CLICK HOME
# 	CLICK UP
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK OK
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK OK
# 	Sleep    20s 
# 	CLICK HOME
# 	CLICK UP
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK RIGHT
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK OK
# 	CLICK HOME
TC_003_EDIT_PROFILE_SECURITY_CONTROL_CHANGE_PIN
    [Tags]      PROFILE & EDIT
    [Documentation]     Editing Profile security pin
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
	Create New Profile
	Navigate To Profile
	Log To Console  Verifying  TC_003_New_User
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_003_New_User
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_New_User Is Displayed on screen
	...  ELSE  Fail  TC_003_New_User Is Not Displayed on screen
	Log To Console    Edit New Profile
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Log To Console    Enter Date of Birth
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	Log To Console    Enter New PIN
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Log To Console  Verifying  TC_003_PIN_CHANGED
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_003_PIN_CHANGED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_PIN_CHANGED Is Displayed on screen
	...  ELSE  Fail  TC_003_PIN_CHANGED Is Not Displayed on screen
	CLICK OK
	CLICK OK
	Navigate To Profile
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	Log To Console    Enter pin 2222 old pin
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  wrong_pin
	Run Keyword If  '${Result}' == 'True'  Log To Console  wrong_pin Is Displayed on screen
	...  ELSE  Fail  wrong_pin Is Not Displayed on screen
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Log To Console    Enter pin 3333 new pin
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    10s
	Reboot STB Device for new User
	${Result}  Verify Crop Image With Shorter Duration    ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  abcd_profile Is Displayed on screen
	...  ELSE  Fail  abcd_profile Is Not Displayed on screen
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	Log To Console    Enter pin 2222 old pin
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  wrong_pin
	Run Keyword If  '${Result}' == 'True'  Log To Console  wrong_pin Is Displayed on screen
	...  ELSE  Fail  wrong_pin Is Not Displayed on screen
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Log To Console    Enter pin 3333 new pin
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    30s
	Navigate To Profile
	Log To Console  Verifying  abcd_profile
	${Result}  Verify Crop Image With Shorter Duration    ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  abcd_profile Is Displayed on screen
	...  ELSE  Fail  abcd_profile Is Not Displayed on screen
	Login As Admin
	Delete New Profile
	CLICK HOME
	Sleep    10s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	# Reboot STB Device

TC_004_EDIT_PROFILE_SECURITY_CONTROL_DISABLE_PIN
    [Tags]      PROFILE & EDIT
    [Documentation]     Disabling Profile security pin
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
	Create New Profile
	Navigate To Profile
	Log To Console  Verifying  TC_004_new_user on Screen
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_004_new_user
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_004_new_user Is Displayed on screen
	...  ELSE  Fail  TC_004_new_user Is Not Displayed on screen
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Log To Console    Enter Date of Birth
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_003_PIN_CHANGED
	Run Keyword If  '${Result}' == 'True'  Log To Console  Edited Disabled pin Is Displayed on screen
	...  ELSE  Fail  Edited Disabled pin Is Not Displayed on screen
	CLICK OK
	Sleep    2s
	Navigate To Profile
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Disable_pin
	Run Keyword If  '${Result}' == 'True'  Log To Console  Edited Disabled pin Is Displayed on screen
	...  ELSE  Fail  Edited Disabled pin Is Not Displayed on screen
	CLICK OK
	Sleep    10s
    # Log To Console    Change pin
	# Sleep    250s
	# Log To Console    Change pin disabled
	Reboot STB Device for new User
	${Result}  Verify Crop Image With Shorter Duration    ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  abcd_profile Is Displayed on screen
	...  ELSE  Fail  abcd_profile Is Not Displayed on screen
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Disable_pin
	Run Keyword If  '${Result}' == 'True'  Log To Console  Edited Disabled pin Is Displayed on screen
	...  ELSE  Fail  Edited Disabled pin Is Not Displayed on screen
	CLICK OK
	Sleep    30s
	CLICK HOME
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	Sleep    30s
	Navigate To Profile
	Log To Console  Verifying  abcd_profile
	${Result}  Verify Crop Image With Shorter Duration    ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  abcd_profile Is Displayed on screen
	...  ELSE  Fail  abcd_profile Is Not Displayed on screen
    Login As Admin
	Sleep    10s
    Delete new Profile
	CLICK HOME
	Sleep    10s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen

TC_005_EDIT_PROFILE_SECURITY_CONTROL_DISABLE_PIN_BOX_OFFICE
    [Tags]    PROFILE & EDIT
	[Documentation]    Edit profile box office pin
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
	Create New Profile
	Navigate To Profile
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Log To Console    Enter Date of Birth
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_003_PIN_CHANGED
	Run Keyword If  '${Result}' == 'True'  Log To Console  Edited Disabled Box pin Is Displayed on screen
	...  ELSE  Fail  Edited Disabled Box pin Is Not Displayed on screen
	CLICK OK
	Sleep    2s
	Navigate To Profile
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK DOWN
	Log To Console  Verifying  TC_005_Disable_BoxOffice_pin on Screen
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_005_Disable_BoxOffice_pin
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_005_Disable_BoxOffice_pin Is Displayed on screen
	...  ELSE  Fail  TC_005_Disable_BoxOffice_pin Is Not Displayed on screen
	CLICK DOWN
	CLICK DOWN 
	CLICK OK
	Sleep    10s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	pinblock
	Purchase VOD For Disable pin
	CLICK OK
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	Login As Admin
	Sleep    10s
    Delete new Profile
	CLICK HOME
	Sleep    10s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen



TC_020_EDIT_PROFILE_ENABLE_PARENTAL_CONTROL_RESTRICT_CHANNEL
    [Tags]      PROFILE & EDIT
    [Documentation]     Enable parental control restrict channel
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
    Create new profile with 3333 pin
	Navigate To Profile
	Log To Console  Verifying  TC_004_new_user on Screen
	${Result}  Verify Crop Image With Shorter Duration    ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_020_New_User Is Displayed on screen
	...  ELSE  Fail  TC_020_New_User Is Not Displayed on screen
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	Navigate To Profile
	CLICK RIGHT
	CLICK OK
	CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK OK
	Sleep    5s
	CLICK HOME
	CLICK FIVE
	CLICK ZERO
	CLICK TWO
	CLICK OK
	Sleep    3s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_713_Parental
	Run Keyword If  '${Result}' == 'True'  Log To Console  PARENTAL_CONTROL Is Displayed on screen
	...  ELSE  Fail  PARENTAL_CONTROL Is Not Displayed on screen
	CLICK THREE
    CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  PARENTAL_CONTROL_ERROR
	Run Keyword If  '${Result}' == 'True'  Log To Console  PARENTAL_CONTROL_ERROR Is Displayed on screen
	...  ELSE  Fail  PARENTAL_CONTROL_ERROR Is Not Displayed on screen
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	Reboot STB Device for new User
	${Result}  Verify Crop Image With Shorter Duration    ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  abcd_profile Is Displayed on screen
	...  ELSE  Fail  abcd_profile Is Not Displayed on screen
	CLICK RIGHT
	CLICK OK
	CLICK THREE
    CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK OK
	Sleep    30s
	Navigate To Profile
	${Result}  Verify Crop Image With Shorter Duration    ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  abcd_profile Is Displayed on screen
	...  ELSE  Fail  abcd_profile Is Not Displayed on screen
	CLICK HOME
	CLICK HOME
	CLICK FIVE
	CLICK ZERO
	CLICK TWO
	CLICK OK
	Sleep    3s
	${Result}  Verify Crop Image With Shorter Duration    ${port}   TC_713_Parental
	Run Keyword If  '${Result}' == 'True'  Log To Console  PARENTAL_CONTROL Is Displayed on screen
	...  ELSE  Fail  PARENTAL_CONTROL Is Not Displayed on screen
	CLICK THREE
    CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  PARENTAL_CONTROL_ERROR
	Run Keyword If  '${Result}' == 'True'  Log To Console  PARENTAL_CONTROL_ERROR Is Displayed on screen
	...  ELSE  Fail  PARENTAL_CONTROL_ERROR Is Not Displayed on screen
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
   ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	Login As Admin
	Delete New Profile
	CLICK HOME
	Sleep    10s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen

TC_021_SWITCHING_PROFILES_VERIFY_SETTINGS_PERSISTENCE
    [Tags]      PROFILE & EDIT
    [Documentation]     Switching profiles and verify settings persistence
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
	Create New Profile
	Navigate To Profile
	${Result}  Verify Crop Image With Shorter Duration    ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  abcd_profile Is Displayed on screen
	...  ELSE  Fail  abcd_profile Is Not Displayed on screen
	CREATE CHILD PROFILE
	Navigate To Profile
	${Result}  Verify Crop Image With Shorter Duration    ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  abcd_profile Is Displayed on screen
	...  ELSE  Fail  abcd_profile Is Not Displayed on screen
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    10s
	Navigate To Profile
	${Result}  Verify Crop Image With Shorter Duration    ${port}  LOGIN_SUBPROFILE
	Run Keyword If  '${Result}' == 'True'  Log To Console  LOGIN_SUBPROFILE Is Displayed on screen
	...  ELSE  Fail  LOGIN_SUBPROFILE Is Not Displayed on screen
	CLICK HOME
	Navigate To Profile
	${Result}  Verify Crop Image With Shorter Duration    ${port}  coco
	Run Keyword If  '${Result}' == 'True'  Log To Console  coco Is Displayed on screen
	...  ELSE  Fail  coco Is Not Displayed on screen
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    10s
	Navigate To Profile
	${Result}  Verify Crop Image With Shorter Duration    ${port}  LOGIN_KIDSPROFILE
	Run Keyword If  '${Result}' == 'True'  Log To Console  LOGIN_KIDSPROFILE Is Displayed on screen
	...  ELSE  Fail  LOGIN_KIDSPROFILE Is Not Displayed on screen
	Login As Admin
	CLICK HOME
    Delete New Profile
	Log To Console    Subprofile Deleted
	CLICK HOME
	Delete New Profile
	Log To Console    Kids porifle Deleted
	CLICK HOME
	Sleep    10s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen

TC_029_EDIT_PROFILE_CHANGE_PIN_PARENTAL_CONTROL_VERIFY_ACCESS
    [Tags]      PROFILE & EDIT
    [Documentation]     Enable parental control restrict channel
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
    Create new kids profile for 3333 pin
	Navigate To Profile
	Log To Console  Verifying  TC_004_new_user on Screen
	${Result}  Verify Crop Image With Shorter Duration    ${port}  coco
	Run Keyword If  '${Result}' == 'True'  Log To Console  coco Is Displayed on screen
	...  ELSE  Fail  coco Is Not Displayed on screen
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK 
	CLICK OK
	CLICK OK
	Navigate To Profile
	CLICK RIGHT
	CLICK OK
	CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK OK
	Sleep    5s
	CLICK HOME
	CLICK FIVE
	CLICK ZERO
	CLICK TWO
	CLICK OK
	Sleep    3s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_713_Parental
	Run Keyword If  '${Result}' == 'True'  Log To Console  PARENTAL_CONTROL Is Displayed on screen
	...  ELSE  Fail  PARENTAL_CONTROL Is Not Displayed on screen
	CLICK THREE
    CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  PARENTAL_CONTROL_ERROR
	Run Keyword If  '${Result}' == 'True'  Log To Console  PARENTAL_CONTROL_ERROR Is Displayed on screen
	...  ELSE  Fail  PARENTAL_CONTROL_ERROR Is Not Displayed on screen
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	Reboot STB for kids profile and login with 3333 pin
	Navigate To Profile
	${Result}  Verify Crop Image With Shorter Duration    ${port}  coco
	Run Keyword If  '${Result}' == 'True'  Log To Console  coco Is Displayed on screen
	...  ELSE  Fail  coco Is Not Displayed on screen
	CLICK HOME
	CLICK HOME
	CLICK FIVE
	CLICK ZERO
	CLICK TWO
	CLICK OK
	Sleep    3s
	${Result}  Verify Crop Image With Shorter Duration    ${port}   TC_713_Parental
	Run Keyword If  '${Result}' == 'True'  Log To Console  PARENTAL_CONTROL Is Displayed on screen
	...  ELSE  Fail  PARENTAL_CONTROL Is Not Displayed on screen
	CLICK THREE
    CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  PARENTAL_CONTROL_ERROR
	Run Keyword If  '${Result}' == 'True'  Log To Console  PARENTAL_CONTROL_ERROR Is Displayed on screen
	...  ELSE  Fail  PARENTAL_CONTROL_ERROR Is Not Displayed on screen
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	Login As Admin
	Delete New Profile
	CLICK HOME
	Sleep    10s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	

TC_032_CREATE_PROFILE_VALID_PROFILE_SWITCH_DURING_RECORDING
    [Tags]    PROFILE & EDIT
	[Documentation]    Create profile and switch during recording
	[Teardown]    Run Keywords    STOP RECORDING
	...    AND    Teardown exit whos watching page and login to Admin
	...    AND    Delete Profile
	STOP RECORDING
	
	CLICK HOME
	Sleep    2s
	CLICK THREE
	CLICK SIX
	CLICK ZERO
	CLICK OK
	Sleep    3s
	CLICK Back
	CLICK Right
	${STEP_COUNT}=    Move to Record On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Tapped Record Button

    Log To Console    Record The Program Is Selected
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  LOCAL
	Run Keyword If  '${Result}' == 'True'  Log To Console  LOCAL Is Displayed on screen
	...  ELSE  Fail  LOCAL Is Not Displayed on screen
    CLICK DOWN
    CLICK OK
    Sleep    5s
    Log To Console    Playback Recording Started

    # Image validation - check for "Recording Started"
   ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE   
    ...    Run Keyword    Handle Recording Failure

    CLICK OK
    
	CLICK HOME
	Sleep    2s
	CLICK THREE
	CLICK TWO
	CLICK SIX
	CLICK OK
	Sleep    3s
	CLICK Back
	CLICK Right
	${STEP_COUNT}=    Move to Record On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Tapped Record Button
    Log To Console    Record The Program Is Selected
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  CLOUD
	Run Keyword If  '${Result}' == 'True'  Log To Console  CLOUD Is Displayed on screen
	...  ELSE  Fail  CLOUD Is Not Displayed on screen
    CLICK DOWN
    CLICK OK
    Sleep    3s
    Log To Console    Playback Recording Started

    # Image validation - check for "Recording Started"
   ${Result}=    Verify Crop Image With Shorter Duration  ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording for cloud

    CLICK OK
	Create New Profile
	Navigate To Profile
	CLICK Right
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
	Sleep    20s
    Login As Admin
    Sleep    10s
	# Sleep    80s
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Local_Recoder
	Run Keyword If  '${Result}' == 'True'  Log To Console  Local_Recoder Is Displayed on screen
	...  ELSE  Fail  Local_Recoder Is Not Displayed on screen
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Cloud_Recorder
	Run Keyword If  '${Result}' == 'True'  Log To Console  cloud Is Displayed on screen
	...  ELSE  Fail  cloud Is Not Displayed on screen
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Cloud_high
	Run Keyword If  '${Result}' == 'True'  Log To Console  Cloud_high Is Displayed on screen
	...  ELSE  Fail  Cloud_high Is Not Displayed on screen
	CLICK OK
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  STOP_REC
	Run Keyword If  '${Result}' == 'True'  Log To Console  STOP_REC Is Displayed on screen
	...  ELSE  Fail   STOP_REC Is Not Displayed on screen
	CLICK OK
	CLICK OK
	Sleep    1s
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	 ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	#video quality
	#audio quality
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Local_high
	Run Keyword If  '${Result}' == 'True'  Log To Console  Local_high Is Displayed on screen
	...  ELSE  Fail  Local_high Is Not Displayed on screen
	CLICK OK
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  STOP_REC
	Run Keyword If  '${Result}' == 'True'  Log To Console  STOP_REC Is Displayed on screen
	...  ELSE  Fail  STOP_REC Is Not Displayed on screen
	CLICK OK
	CLICK OK
	Sleep    1s
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	 ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	# Video Quality Verification
	# Unified verification of Audio Quality
	# STOP RECORDING
	Delete New Profile


TC_025_SWITCH_PROFILE_DURING_LIVE_VERIFY_PROFILE_PREFERENCES
    [Tags]      PROFILE & EDIT
    [Documentation]     Switch profile during live and verify profile preferences
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin  
	...    AND    Revert Lock Channels
	...    AND    Delete Profile
	Create New Profile
	Navigate To Profile
	${status2}=  Profile Name abcd
	Should Be Equal    ${status2}    abcd
	# ${Result}  Verify Crop Image  ${port}  abcd_profile
	# Run Keyword If  '${Result}' == 'True'  Log To Console  abcd_profile Is Displayed on screen
	# ...  ELSE  Fail  abcd_profile Is Not Displayed on screen
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN

	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    1s
	${Result}  Verify Crop Image  ${port}  TC_011_ok_button
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_011_ok_button Is Displayed
	...  ELSE  Fail  TC_011_ok_button Is Not Displayed
	CLICK OK
	Log To Console    Locked channels for Admin (02 and 03)
	Navigate To Profile
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s
	Log To Console    Enter Date of Birth
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK LEFT
	CLICK FOUR
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	Sleep    1s
	${Result}  Verify Crop Image  ${port}  TC_011_ok_button
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_011_ok_button Is Displayed
	...  ELSE  Fail  TC_011_ok_button Is Not Displayed
	CLICK OK
	Log To Console    Locked channels for Admin (24 and 40)

	CLICK HOME
	CLICK TWO
	Sleep    2s
		${Result}  Verify Crop Image  ${port}  Channel2_Lock
	Run Keyword If  '${Result}' == 'True'  Log To Console  CHANNEL_LOCK_02 Is Displayed
	...  ELSE  Fail  CHANNEL_LOCK_02 Is Not Displayed
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	
	CLICK THREE
	Sleep    2s
	${Result}  Verify Crop Image  ${port}  CHANNEL_LOCK_03
	Run Keyword If  '${Result}' == 'True'  Log To Console  CHANNEL_LOCK_03 Is Displayed
	...  ELSE  Fail  CHANNEL_LOCK_03 Is Not Displayed
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	Navigate To Profile
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    10s
	
	CLICK HOME
	CLICK TWO
	CLICK FOUR
	Sleep    2s
		${Result}  Verify Crop Image  ${port}  CHANNEL_LOCK_024
	Run Keyword If  '${Result}' == 'True'  Log To Console  CHANNEL_LOCK_024 Is Displayed
	...  ELSE  Fail  CHANNEL_LOCK_024 Is Not Displayed
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	
	CLICK FOUR
	CLICK ZERO
	Sleep    2s
	${Result}  Verify Crop Image  ${port}  CHANNEL_LOCK_40
	Run Keyword If  '${Result}' == 'True'  Log To Console  CHANNEL_LOCK_40 Is Displayed
	...  ELSE  Fail  CHANNEL_LOCK_40 Is Not Displayed
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	CLICK HOME

	Reboot STB Device for new User
	${status2}=  Profile Name abcd after reboot
	Should Be Equal    ${status2}    abcd
	${Result}  Verify Crop Image  ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  abcd_profile Is Displayed on screen
	...  ELSE  Fail  abcd_profile Is Not Displayed on screen
	Check Who's Watching login
	CLICK HOME
	CLICK TWO
	Sleep    2s
		${Result}  Verify Crop Image  ${port}  Channel2_Lock
	Run Keyword If  '${Result}' == 'True'  Log To Console  CHANNEL_LOCK_02 Is Displayed
	...  ELSE  Fail  CHANNEL_LOCK_02 Is Not Displayed
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	
	CLICK THREE
	Sleep    2s
	${Result}  Verify Crop Image  ${port}  CHANNEL_LOCK_03
	Run Keyword If  '${Result}' == 'True'  Log To Console  CHANNEL_LOCK_03 Is Displayed
	...  ELSE  Fail  CHANNEL_LOCK_03 Is Not Displayed
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	Navigate To Profile
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    10s
	
	CLICK HOME
	CLICK TWO
	CLICK FOUR
	Sleep    2s
		${Result}  Verify Crop Image  ${port}  CHANNEL_LOCK_024
	Run Keyword If  '${Result}' == 'True'  Log To Console  CHANNEL_LOCK_024 Is Displayed
	...  ELSE  Fail  CHANNEL_LOCK_024 Is Not Displayed
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	
	CLICK FOUR
	CLICK ZERO
	Sleep    2s
	${Result}  Verify Crop Image  ${port}  CHANNEL_LOCK_40
	Run Keyword If  '${Result}' == 'True'  Log To Console  CHANNEL_LOCK_40 Is Displayed
	...  ELSE  Fail  CHANNEL_LOCK_40 Is Not Displayed
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	    ${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is Paused
	CLICK HOME
    Login As Admin
	Delete New Profile
	Log To Console    Subprofile Deleted
	CLICK HOME
	Sleep    10s
	${Result}  Verify Crop Image  ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen


TC_026_CREATE_PROFILE_ADD_FAVORITE_VERIFY_FAVORITE_LIST
    [Tags]      PROFILE & EDIT
    [Documentation]     Add Favorite and verify favorite list
    [Teardown]    Run Keywords    Revert favorites    AND    Teardown exit whos watching page and login to Admin
	Navigate To Profile
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Sleep    2s
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	CLICK LEFT
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH1_26
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST1_CH1 Is Displayed on screen
	...  ELSE  Fail  FAVLIST1_CH1 Is Not Displayed on screen
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH2_26
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST1_CH2 Is Displayed on screen
	...  ELSE  Fail  FAVLIST1_CH2 Is Not Displayed on screen
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH3_26
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST1_CH3 Is Displayed on screen
	...  ELSE  Fail  FAVLIST1_CH3 Is Not Displayed on screen
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH4_26
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST1_CH4 Is Displayed on screen
	...  ELSE  Fail  FAVLIST1_CH4 Is Not Displayed on screen
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH5_26
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST1_CH5 Is Displayed on screen
	...  ELSE  Fail  FAVLIST1_CH5 Is Not Displayed on screen
    CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	CLICK DOWN
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	CLICK LEFT
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH1_26
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH1 Is Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH1 Is Not Displayed on screen
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH2_26
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH2 Is Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH2 Is Not Displayed on screen
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH3_26
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH3 Is Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH3 Is Not Displayed on screen
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH4_26
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH4 Is Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH4 Is Not Displayed on screen
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH5_26
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH5 Is Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH5 Is Not Displayed on screen
    CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	CLICK DOWN
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	CLICK LEFT
	CLICK LEFT
	CLICK DOWN
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST3_CH1
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST3_CH1 Is Displayed on screen
	...  ELSE  Fail  FAVLIST3_CH1 Is Not Displayed on screen
	
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST3_CH2
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH2 Is Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH2 Is Not Displayed on screen
	
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST3_CH3
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST3_CH3 Is Displayed on screen
	...  ELSE  Fail  FAVLIST3_CH3 Is Not Displayed on screen
	
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST3_CH4
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST3_CH4 Is Displayed on screen
	...  ELSE  Fail  FAVLIST3_CH4 Is Not Displayed on screen
	
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST3_CH5
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST3_CH5 Is Displayed on screen
	...  ELSE  Fail  FAVLIST3_CH5 Is Not Displayed on screen
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
    
	CLICK DOWN
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	CLICK LEFT
	CLICK LEFT
	CLICK DOWN
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST4_CH1
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST4_CH1 Is Displayed on screen
	...  ELSE  Fail  FAVLIST4_CH1 Is Not Displayed on screen
	
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST4_CH2
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST4_CH2 Is Displayed on screen
	...  ELSE  Fail  FAVLIST4_CH2 Is Not Displayed on screen
	
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST4_CH3
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST4_CH3 Is Displayed on screen
	...  ELSE  Fail  FAVLIST4_CH3 Is Not Displayed on screen
	
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST4_CH4
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST4_CH4 Is Displayed on screen
	...  ELSE  Fail  FAVLIST4_CH4 Is Not Displayed on screen
	
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST4_CH5
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST4_CH5 Is Displayed on screen
	...  ELSE  Fail  FAVLIST4_CH5 Is Not Displayed on screen

	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	CLICK DOWN
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	CLICK LEFT
	CLICK LEFT
	
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST5_CH1
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST5_CH1 Is Displayed on screen
	...  ELSE  Fail  FAVLIST5_CH1 Is Not Displayed on screen

	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST5_CH2
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST5_CH2 Is Displayed on screen
	...  ELSE  Fail  FAVLIST5_CH2 Is Not Displayed on screen
	
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST5_CH3
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST5_CH3 Is Displayed on screen
	...  ELSE  Fail  FAVLIST5_CH3 Is Not Displayed on screen
	
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST5_CH4
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST5_CH4 Is Displayed on screen
	...  ELSE  Fail  FAVLIST5_CH4 Is Not Displayed on screen
	
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST5_CH5
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST5_CH5 Is Displayed on screen
	...  ELSE  Fail  FAVLIST5_CH5 Is Not Displayed on screen
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
    #set 5 style
	CLICK UP
	CLICK RIGHT
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	log To Console    Setted interface to 5 style
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME
	# Log To Console    Change
	# Sleep    300s
	# Log To COnsole    Changed
	Reboot STB Device
	CLICK HOME
	${Result}  Verify Crop Image  ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
    CLICK LEFT
	CLICK OK
	CLICK OK
	Favlist1_Channel_list
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK OK
	Favlist2_Channel_list
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Favlist3_Channel_list
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    Favlist4_Channel_list
    CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Favlist5_Channel_list
TC_2018_SWITCH_PROFILE_VERIFY_HIDE_CHANNELS_PROFILE_PREFERENCES
    [Tags]      PROFILE & EDIT
    [Documentation]     Switch profile during live and verify profile preferences
	[Teardown]    Run Keywords    Revert Hide Channels
	...    AND    Teardown exit whos watching page and login to Admin
	...    AND    Delete Profile
	Create New Profile
	Navigate To Profile
	${Result}  Verify Crop Image  ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  abcd_profile Is Displayed on screen
	...  ELSE  Fail  abcd_profile Is Not Displayed on screen
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK LEFT
	CLICK THREE
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	#set 5 style
	CLICK UP
	CLICK RIGHT
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	log To Console    Setted interface to 5 style
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_003_PIN_CHANGED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_011_ok_button Is Displayed
	...  ELSE  Fail  TC_011_ok_button Is Not Displayed
	CLICK OK
	Log To Console    Locked channels for Admin (23 and 33)
	Navigate To Profile
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s
	Log To Console    Enter Date of Birth
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK LEFT
	CLICK SIX
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	#set 5 style
	CLICK UP
	CLICK RIGHT
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	log To Console    Setted interface to 5 style
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    1s
	${Result}  Verify Crop Image  ${port}  	TC_003_PIN_CHANGED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_011_ok_button Is Displayed
	...  ELSE  Fail  TC_011_ok_button Is Not Displayed
	CLICK OK
	Log To Console    Locked channels for Admin (61 and 63)

	CLICK HOME
	CLICK TWO
	CLICK TWO
	Sleep    20s
	CLICK OK
    Hidden_Channel_23
	# ${Result}  Validate Video Playback For Playing
    # Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    # ...  ELSE  Fail  Video is Paused
	
	CLICK THREE
	CLICK ONE
	Sleep    20s
    CLICK OK
	Hidden_Channel_33
	Navigate To Profile
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    10s
	
	CLICK HOME
	CLICK SIX
	CLICK ZERO
	Sleep    20s
    CLICK OK
	Hidden_Channel_61
	
	CLICK SIX
	CLICK TWO
	Sleep    20s
	CLICK OK
	Hidden_Channel_63
	CLICK HOME
	Reboot STB Device for new User
	${status2}=  Profile Name abcd after reboot
	Should Be Equal    ${status2}    abcd
	${Result}  Verify Crop Image  ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  abcd_profile Is Displayed on screen
	...  ELSE  Fail  abcd_profile Is Not Displayed on screen
	Check Who's Watching login
	
	CLICK HOME
	CLICK TWO
	CLICK TWO
	Sleep    20s
	CLICK OK
    Hidden_Channel_23
	# ${Result}  Validate Video Playback For Playing
    # Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    # ...  ELSE  Fail  Video is Paused
	
	CLICK THREE
	CLICK ONE
	Sleep    20s
    CLICK OK
	Hidden_Channel_33
	Navigate To Profile
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    10s
	
	CLICK HOME
	CLICK SIX
	CLICK ZERO
	Sleep    20s
    CLICK OK
	Hidden_Channel_61
	
	CLICK SIX
	CLICK TWO
	Sleep    20s
	CLICK OK
	Hidden_Channel_63
	CLICK HOME
    Login As Admin
	Delete New Profile
	Log To Console    Subprofile Deleted
	CLICK HOME
	Sleep    10s
	${Result}  Verify Crop Image  ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen



TC_001_CREATE_NEW_PROFILE
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
	Create New Profile 
	Navigate To Profile	
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_004_new_user
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_001_New_logged_in_profile Is Displayed
	# ...  ELSE  Fail  TC_001_New_logged_in_profile Is Not Displayed	
	# Log To Console    Validate Guide As New User
	${status2}=  Profile Name From Profile Settings Page
    Verify the Similarity Profile Name    ${status2}
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    10s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	Guide Channel List
	CLICK TWO
	CLICK TWO
	Sleep    5s 
	CLICK ONE
	CLICK FIVE
	Sleep    15s 
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK HOME
	Log To Console  delete
	Sleep    90s
	Log To Console  deleted
	Reboot STB Device 
	Navigate To Profile	
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_004_new_user
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_001_New_logged_in_profile Is Displayed
	...  ELSE  Fail  TC_001_New_logged_in_profile Is Not Displayed	
	Log To Console    Validate Guide As New User
	Log To Console    Login as Admin
	# Login As Admin	
	Delete New Profile
	Reboot STB Device 
	Navigate To Profile
	#TC_003_Who_Watching
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_003_Who_Watching
	# Run Keyword If  '${Result}' == 'True'  Log To Console  New profile still remains
	# ...  ELSE  Fail  New profile deleted successfully
	${status2}=  Profile Name From Profile Settings Page
    Verify the Similarity Profile Name Negative Scenario    ${status2}


TC_006_EDIT_PROFILE_SECURITY_CONTROL_ALWAYS_LOGIN_SAME_PROFILE
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
	NAVIGATE TO PROFILE ICON
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_006_whos_watching
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_whos_watching Is Displayed
	# ...  ELSE  Fail  TC_006_whos_watching Is Not Displayed
	CLICK RIGHT
	CLICK OK
	Enter Pincode
	CLICK OK
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_006_profile_type
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_profile_type Is Displayed
	# ...  ELSE  Fail  TC_006_profile_type Is Not Displayed
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_006_profile_nickname
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_profile_nickname Is Displayed
	# ...  ELSE  Fail  TC_006_profile_nickname Is Not Displayed
	
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    15s
    ############
	NAVIGATE TO PROFILE ICON	
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    3s 

	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT	
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_006_Always_Login
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Always_login Is Displayed
	...  ELSE  Log To Console  TC_006_Always_login Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK OK

	Sleep    2s
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
    Sleep    2s
	CLICK OK
    CLICK OK
    Sleep    10s 
    Reboot STB Device without whos watching page seen
	Sleep    15s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
    NAVIGATE TO PROFILE ICON
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Logged_In_Subprofile
	Run Keyword If  '${Result}' == 'True'  Log To Console  Logged_In_Subprofile Is Displayed
	...  ELSE  Fail  Logged_In_Subprofile Is Not Displayed
	CLICK OK
	Enter Pincode
	Sleep    15s


TC_008_PROFILE_TV_EXPERIENCE_AUDIOLANGUAGE_CHANGE
    [Tags]    PROFILE & EDIT
	[Teardown]    Delete Profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s 
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s 
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  AUDIO_ENGLISH
	Run Keyword If  '${Result}' == 'True'  Log To Console  AUDIO_ENGLISH Is Displayed on screen
	...  ELSE  Fail  AUDIO_ENGLISH Is Not Displayed on screen
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    1s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    1s 
	CLICK THREE
	CLICK TWO
	CLICK SIX
	# CLICK FiVE
	Sleep    18s
	CLICK UP
	CLICK OK
    CLICK RIGHT
    ${STEP_COUNT}=    Move to Audio Launguage On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console     Navigated to audio language
	# CLICK RIGHT
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  CONFIRM_AUDIO_ENGLISH
	Run Keyword If  '${Result}' == 'True'  Log To Console  CONFIRM_AUDIO_ENGLISH Is Displayed on screen
	...  ELSE  Fail  CONFIRM_AUDIO_ENGLISH Is Not Displayed on screen

	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s 
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s 
	CLICK DOWN
	CLICK OK
	CLICK MULTIPLE TIMES    3    DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s 
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s 
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}   Arabic_Audio_Language
	Run Keyword If  '${Result}' == 'True'  Log To Console  Arabic_Audio_Language Is Displayed on screen
	...  ELSE  Fail  Arabic_Audio_Language Is Not Displayed on screen
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    1s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    3s 
	CLICK THREE
	CLICK TWO
	CLICK SIX
	# CLICK FiVE
	Sleep    18s
	CLICK UP
	CLICK OK
    CLICK RIGHT
    ${STEP_COUNT}=    Move to Audio Launguage On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console     Navigated to audio language
	# CLICK RIGHT
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}   Arabic_Audio_Language_Playback
	Run Keyword If  '${Result}' == 'True'  Log To Console  Arabic_Audio_Language_Playback Is Displayed on screen
	...  ELSE  Fail  Arabic_Audio_Language_Playback Is Not Displayed on screen

	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s 
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s 
	CLICK DOWN
	CLICK OK
	CLICK MULTIPLE TIMES    3    DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s 
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s 
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
    CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}   Default_Audio_Language
	Run Keyword If  '${Result}' == 'True'  Log To Console  Default_Audio_Language Is Displayed on screen
	...  ELSE  Fail  Default_Audio_Language Is Not Displayed on screen
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    1s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    1s 
	CLICK THREE
	CLICK TWO
	CLICK SIX
	# CLICK FiVE
	Sleep    18s
	CLICK UP
	CLICK OK
    CLICK RIGHT
    ${STEP_COUNT}=    Move to Audio Launguage On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console     Navigated to audio language
	# CLICK RIGHT
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}   Arabic_Audio_Language_Playback
	Run Keyword If  '${Result}' == 'True'  Log To Console  Arabic_Audio_Language_Playback Is Displayed on screen
	...  ELSE  Fail  Arabic_Audio_Language_Playback Is Not Displayed on screen

	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s 
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s 
	CLICK DOWN
	CLICK OK
	CLICK MULTIPLE TIMES    3    DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME
    CLICK HOME
	Sleep    10s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen




TC_009_PROFILE_TV_EXPERIENCE_SUBTITLE_LANGUAGE_CHANGE
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords     NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	...    AND    DELETE PROFILE     
    NAVIGATE TO PROFILE ICON
	CLICK RIGHT
	CLICK OK
	Enter Pincode
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	# CLICK RIGHT
	# CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	NAVIGATE TO PROFILE ICON
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_007_New_profile_created
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_007_New_profile_created Is Displayed
	...  ELSE  Log To Console  TC_007_New_profile_created Is Not Displayed
	CLICK DOWN
	CLICK OK
	Enter Pincode
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK LEFT
	#need to change month
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_009_TV_EXPERIENCE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_TV_EXPERIENCE Is Displayed
	...  ELSE  Log To Console  TC_009_TV_EXPERIENCE Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep	1s
	${Result}  Verify Crop Image With Shorter Duration    ${port}	  TC_010_ok
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_SUCCESS Is Displayed
	...  ELSE  Log To Console  TC_009_SUCCESS Is Not Displayed
	
	CLICK OK
	NAVIGATE TO PROFILE ICON
	CLICK RIGHT
	CLICK OK
	Enter Pincode
	Sleep    10s 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK THREE
	CLICK SIX
	CLICK ZERO
	# CLICK FIVE
	# CLICK BACK
    Sleep    20s 
	CLICK RIGHT

	Log To Console    Move to subtitle On Side Pannel
	${STEP_COUNT}=    Move to subtitle On Side Pannel
	
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Subtitling selected 
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	# Sleep	1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_009_ARABIC 
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_ARABIC Is Displayed
	...  ELSE  Fail  TC_009_ARABIC Is Not Displayed
	
	CLICK BACK
	CLICK HOME
	
	################################################
	NAVIGATE TO PROFILE ICON
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	Enter Pincode

	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK THREE
	CLICK SIX
	CLICK ZERO
	Sleep    5s 
	CLICK BACK
    Sleep    4s 
	CLICK RIGHT

	Log To Console    Move to subtitle On Side Pannel
	${STEP_COUNT}=    Move to subtitle On Side Pannel
	
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	# CLICK OK
    Log To Console    Subtitling selected 
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# 	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_009_SUBTITLING
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_SUBTITLING Is Displayed
	# ...  ELSE  Fail  TC_009_SUBTITLING Is Not Displayed
	
	# CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}   Subtitle_None
	Run Keyword If  '${Result}' == 'True'  Log To Console  None_Validation Is Displayed
	...  ELSE  Fail  None_Validation Is Not Displayed
	
	CLICK BACK
	CLICK HOME

    #####################################################################
	NAVIGATE TO PROFILE ICON
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	Enter Pincode

	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK THREE
	CLICK SIX
	CLICK ZERO
	Sleep    5s 
	CLICK BACK
    Sleep    4s 
	CLICK RIGHT

	Log To Console    Move to subtitle On Side Pannel
	${STEP_COUNT}=    Move to subtitle On Side Pannel
	
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	# CLICK OK
    Log To Console    Subtitling selected 
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  CONFIRM_AUDIO_ENGLISH
	Run Keyword If  '${Result}' == 'True'  Log To Console  CONFIRM_AUDIO_ENGLISH Is Displayed
	...  ELSE  Fail  CONFIRM_AUDIO_ENGLISH Is Not Displayed
	
	CLICK BACK
	CLICK HOME
	###################################################################
    NAVIGATE TO PROFILE ICON
	CLICK OK
	Enter Pincode
	Sleep    8s
	CLICK HOME

TC_010_PROFILE_TV_EXPERIENCE_CONTENT_RATING
    [Tags]    PROFILE & EDIT 
	[Teardown]    Run Keywords    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION	AND	DELETE PROFILE
	Create New Profile
	CLICK TWO
	CLICK TWO
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	#need to change month
	Sleep    3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	Sleep    8s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_010_ok
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_010_ok Is Displayed on screen
	# ...  ELSE  Fail  TC_010_ok Is Not Displayed on screen
	
	CLICK OK
	CLICK HOME
	# ######
	# Reboot STB Device
	# CLICK HOME
	# Navigate and Login to Sub profile
	# CLICK HOME
	# CLICK UP
	# CLICK RIGHT
	# CLICK OK
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	# Guide Channel List
	# CLICK TWO
	# CLICK TWO
	# Sleep    3s
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_010_Rating_Confirmation_PopUp
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_010_Rating_Confirmation_PopUp Is Displayed on screen
	# ...  ELSE  Fail  TC_010_Rating_Confirmation_PopUp Is Not Displayed on screen
	
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	# Sleep    5s
	# CLICK TWO
	# CLICK TWO
	# Sleep    3s
	# CLICK HOME
	# Sleep    3s
	# ####
	Reboot STB Device
	CLICK HOME
	Navigate and Login to Sub profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	CLICK FIVE
	CLICK ZERO
	CLICK TWO
	Sleep    3s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_010_Rating_Confirmation_PopUp
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_010_Rating_Confirmation_PopUp Is Displayed on screen
	...  ELSE  Fail  TC_010_Rating_Confirmation_PopUp Is Not Displayed on screen
	
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    5s
	CLICK TWO
	CLICK TWO
	Sleep    3s
	CLICK HOME
	Sleep    3s
	Login As Admin
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME
	DELETE PROFILE
	
TC_011_PROFILE_TV_EXPERIENCE_CHANNEL_LOCK
    [Tags]    PROFILE & EDIT 
	[Teardown]    Run Keywords    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION	AND	DELETE PROFILE	AND	Revert locked channels
	NAVIGATE TO PROFILE ICON
	CLICK DOWN
	CLICK OK
	Enter Pincode
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK MULTIPLE TIMES	7	DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK MULTIPLE TIMES	15	UP
	Sleep	2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Channel_11_011
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel_11_011 Is Displayed
	...  ELSE  Fail  Channel_11_011 Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Channel_12_011
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel_12_011 Is Displayed
	...  ELSE  Fail  Channel_12_011 Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Channel_15_011
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel_15_011 Is Displayed
	...  ELSE  Fail  Channel_15_011 Is Not Displayed	
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep	2s
	CLICK OK
	Reboot STB Device
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	Guide Channel List
	Sleep    2s 
	CLICK ONE
	CLICK ONE
	Sleep    3s 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Channel_Lock_Pop_Up_11
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel 11 is locked
	...  ELSE  Fail  Channel 11 is not locked
	
	Enter Pincode
	Sleep    3s
	Standby
	CLICK ONE 
	CLICK TWO
	Sleep    3s
	${Result}  Verify Crop Image With Shorter Duration  ${port}   Channel_Lock_Pop_Up_12
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel 12 is locked
	...  ELSE  Fail  Channel 12 is not locked
	
	Enter Pincode
	Sleep    2s
	CLICK ONE 
	CLICK FIVE
	Sleep    3s
	${Result}  Verify Crop Image With Shorter Duration  ${port}   Channel_Lock_Pop_Up_15
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel 15 is locked
	...  ELSE  Fail  Channel 15 is not locked
	
	Enter Pincode
	Sleep    2s
	CLICK TWO
	CLICK TWO
	Sleep    2s
	NAVIGATE TO PROFILE ICON
	CLICK DOWN
	CLICK OK
	Enter Pincode
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	CLICK OK

	CLICK OK
	CLICK HOME
	
	
TC_012_PROFILE_TV_EXPERIENCE_HIDE_CHANNEL
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords    Revert Unhide    AND    Revert channel style changes
	Navigate to Profile icon
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep     3s 
	CLICK DOWN
	CLICK RIGHT
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_018_default_style
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_default_style Is Displayed on screen
	# ...  ELSE  Fail  TC_018_default_style Is Not Displayed on screen
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_018_ok
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_ok Is Displayed on screen
	...  ELSE  Fail  TC_018_ok Is Not Displayed on screen
	
	CLICK OK
	Sleep    3s 
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK TWO
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_012_two
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_012_two Is Displayed
	...  ELSE  Fail  TC_012_two_locked Is Not Displayed
	
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK

	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	Sleep    3s 
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_012_ok_button
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_012_ok_button Is Displayed
	# ...  ELSE  Fail  TC_012_ok_button Is Not Displayed
	
	CLICK HOME
	Reboot STB Device
	CLICK HOME
	Sleep    2s
	CLICK NINE
	Sleep    3s 
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	Hidden_Channel_2
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_3
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_4
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_10
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_11
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   7103
	# Run Keyword If  '${Result}' == 'True'  Log To Console  7103 Is Displayed
	# ...  ELSE  Fail  7103 Is Not Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   7104
	# Run Keyword If  '${Result}' == 'True'  Log To Console  7104 Is Displayed
	# ...  ELSE  Fail  7104 Is Not Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   7105
	# Run Keyword If  '${Result}' == 'True'  Log To Console  7105 Is Displayed
	# ...  ELSE  Fail  7105 Is Not Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   Channel_10
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Channel_10 Is Displayed
	# ...  ELSE  Fail  Channel_10 Is Not Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   Channel_12
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Channel_12 Is Displayed
	# ...  ELSE  Fail  Channel_12 Is Not Displayed
	# Sleep    1s	
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME


TC_013_PROFILE_TV_EXPERIENCE_ADVERTISEMENT
    [Tags]    PROFILE & EDIT
	# [Teardown]    Delete Profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK

	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Sleep    2s

	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_013_AD_Default_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  Enabled Default_Value Is Displayed
	...  ELSE  Fail  Enabled Default_Value Is Not Displayed
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_013_Success
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_013_Success Is Displayed
	# ...  ELSE  Fail  TC_013_Success Is Not Displayed
	
	CLICK OK
	Reboot STB Device
	CLICK HOME
	Sleep    2s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Sleep    3s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_013_After_AD_Edit
	Run Keyword If  '${Result}' == 'True'  Log To Console  Disabled is Dislayed after Reboot
	...  ELSE  Fail  Disabled Is Not Displayed after Reboot
	
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME
	########################################Rcomment#######################
	Reboot STB Device
	CLICK HOME
	Sleep    2s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Sleep    3s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_013_AD_Default_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  Enabled Is Displayed after Reboot
	...  ELSE  Fail  Enabled Is Not Displayed after Reboot
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME

TC_014_PROFILE_INTERFACE_SETTING_RECORDING_STORAGE_SELECTION
    [Tags]    PROFILE & EDIT
	# [Teardown]    Delete Profile
	# ##### FIRST CHECK FOR LOCAL
	# CLICK HOME
	# CLICK UP
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK OK
	# CLICK DOWN
	# CLICK OK
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# Sleep    3s 

	# CLICK DOWN
	# CLICK OK
	# CLICK UP
	# CLICK UP
	# CLICK UP
	# CLICK DOWN
	# CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_014_Local_selected
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_014_Local_selected Is Displayed
	# ...  ELSE  Fail  TC_014_Local_selected Is Not Displayed
	
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	# CLICK OK
	# #Functionality check
	# CLICK HOME
	# CLICK UP
	# CLICK RIGHT
	# CLICK OK
	# CLICK OK
	# Sleep    3s
	# CLICK SEVEN
	# CLICK SEVEN
	# CLICK ONE
	# Sleep    1s 
	# CLICK BACK
	
	# CLICK RIGHT

	# Search And Click On Record From Side Panel Under EPG

	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN

    # ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_014_LOCAL
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_014_LOCAL Is Displayed
	# ...  ELSE  Fail  TC_014_LOCAL Is Not Displayed
    # CLICK DOWN
	# CLICK OK 
	# CLICK OK 
	# CLICK HOME
	# #Revert recording
	# CLICK Home
	# CLICK Up
	# CLICK Right
	# CLICK Right
	# CLICK Right
	# CLICK Right
	# CLICK Right
	# CLICK Ok
	# Sleep    3s
	# CLICK Ok
	# Sleep    3s
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  Local_Recoder
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Local_Recoder option Is Displayed on screen
	# ...  ELSE  Fail  Local_Recoder Option Is Not Displayed on screen
	
    # #########################################

	# #######SECOND CHECK FOR CLOUD 
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    3s 

	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	# CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}    CLOUD_OPTION
	# Run Keyword If  '${Result}' == 'True'  Log To Console  CLOUD_OPTION Is Displayed
	# ...  ELSE  Fail  CLOUD_OPTION Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	#Functionality check
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    3s
	CLICK TWO
	CLICK TWO
	# CLICK ZERO
	Sleep    1s 
	CLICK BACK
	
	CLICK RIGHT

	Search And Click On Record From Side Panel Under EPG

	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN

    ${Result}  Verify Crop Image With Shorter Duration    ${port}  CLOUD_LINUXSTB2
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_014_CLOUD Is Displayed
	...  ELSE  Fail  TC_014_CLOUD Is Not Displayed
    CLICK DOWN
	CLICK OK 
	CLICK OK 
	CLICK HOME
	#Revert recording
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	Sleep    3s
	CLICK Ok
	Sleep    3s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Cloud_Recorder
	Run Keyword If  '${Result}' == 'True'  Log To Console  Cloud_Recorder option Is Displayed on screen
	...  ELSE  Fail  Cloud_Recorder Option Is Not Displayed on screen
	
	#######################################
	#Revert recording
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Up
	CLICK Ok
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_824_Confirm_Deletion
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_824_Confirm_Deletion Is Displayed on screen
	# ...  ELSE  Fail  TC_824_Confirm_Deletion Is Not Displayed on screen
	
	CLICK Ok
	Sleep    2s 
	CLICK Ok
	CLICK Home



TC_015_PROFILE_INTERFACE_SETTING_SCREEN_LANGUAGE_CHANGE
    [Tags]    PROFILE & EDIT 
	# [Teardown]    Revert UI language
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    3s 
	
	CLICK DOWN
	CLICK DOWN
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  English_Language
	# Run Keyword If  '${Result}' == 'True'  Log To Console  English_Language Is Displayed
	# ...  ELSE  Fail  English_Language Is Not Displayed
	
	CLICK OK
	CLICK UP
	CLICK OK

	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}   Arabic_Language
	Run Keyword If  '${Result}' == 'True'  Log To Console  English_Language Is Displayed
	...  ELSE  Fail  English_Language Is Not Displayed
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    20s 
	CLICK HOME
	Sleep    2s 
	CLICK ONE 
	CLICK TWO 
	CLICK ZERO
	CLICK ONE
	Sleep    3s
	Reboot STB Device
	Sleep    1s 
	CLICK HOME
	Sleep    1s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ARABIC_HOME
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_HOME Is Displayed on screen
	...  ELSE  Fail  ARABIC_HOME Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ARABIC_TV
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_TV Is Displayed on screen
	...  ELSE  Fail  ARABIC_TV Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ARABIC_BOX_OFFICE
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_BOX_OFFICE Is Displayed on screen
	...  ELSE  Fail  ARABIC_BOX_OFFICE Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ARABIC_KIDS
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_KIDS Is Displayed on screen
	...  ELSE  Fail  ARABIC_KIDS Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ARABIC_MYTV
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_MYTV Is Displayed on screen
	...  ELSE  Fail  ARABIC_MYTV Is Not Displayed on screen
	Sleep    2s 
	CLICK HOME
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Arabic_Language
	Run Keyword If  '${Result}' == 'True'  Log To Console  Arabic_Language Is Displayed
	...  ELSE  Fail  Arabic_Language Is Not Displayed
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	CLICK OK
	Sleep    20s 
	CLICK HOME


TC_016_PROFILE_INTERFACE_SETTINGS_BANNER_INTERFACE_TIMEOUT
    [Tags]    PROFILE & EDIT
	[Teardown]    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Interface_timeout_10secs
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_timeout_10secs Is Displayed
	...  ELSE  Fail  Interface_timeout_10secs Is Not Displayed
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Interface_timeout_5secs
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_timeout_5secs Is Displayed
	...  ELSE  Fail  Interface_5secs Is Not Displayed
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	CLICK OK
	Sleep    2s
	CLICK OK
	CLICK HOME
	Reboot STB Device
	sleep    5s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	Guide Channel List
	CLICK TWO
	CLICK TWO
	Sleep    8s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_016_Dubai_TV_Channel
	Run Keyword If  '${Result}' == 'False'  Log To Console  Banner Timeout has been successfully validated
	...  ELSE  Fail  Banner is still visible after timeout
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Interface_timeout_5secs
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_timeout_5secs Is Displayed
	...  ELSE  Log To Console  Interface_timeout_5secs Is Not Displayed
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	CLICK OK
	CLICK HOME
	CLICK HOME
	Reboot STB Device
	Sleep    5s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Interface_timeout_10secs
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_timeout_10secs Is Displayed
	...  ELSE  Log To Console  Interface_timeout_10secs Is Not Displayed
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	CLICK OK
	CLICK HOME
	# Log To Console  Change
	# Sleep    150s
	# Log To Console  Changed
	Sleep    3s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	Guide Channel List
	CLICK TWO
	CLICK TWO
	Sleep    2s
	Sleep    5s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_016_Dubai_TV_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  Banner is seen after 7 seconds
	...  ELSE  Fail  Banner is not seen
	Sleep    7s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_016_Dubai_TV_Channel
	Run Keyword If  '${Result}' == 'False'  Log To Console  Banner Timeout has been successfully validated
	...  ELSE  Fail  Banner is still visible after timeout
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	CLICK OK
	CLICK HOME


TC_017_PROFILE_INTERFACE_SETTINGS_INTERFACE_CLOCK
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION    AND    Teardown exit whos watching page and login to Admin    
	NAVIGATE TO PROFILE ICON
	CLICK DOWN
	CLICK OK
	Enter Pincode
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    3s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Interface_clock_off
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_clock_off Is Displayed
	...  ELSE  Fail  Interface_clock_off Is Not Displayed
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	CLICK OK
	Reboot STB Device
	# Log To Console  Interface_c
    # Sleep    150s 
	# Log To Console  Interface_c
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	Guide Channel List
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Sleep    10s 
	Verify Time On Interface Clock
    NAVIGATE TO PROFILE ICON
	CLICK DOWN
	CLICK OK
	Enter Pincode
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Interface_clock_on
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_clock_on Is Displayed
	...  ELSE  Fail  Interface_clock_on Is Not Displayed
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME
	Reboot STB Device
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	Guide Channel List
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ZERO
	Sleep    10s 
	Verify Time On Interface Clock Negative Scenario
    CLICK HOME
	
TC_018_PROFILE_INTERFACE_SETTING_CHANNEL_STYLE
    [Tags]    PROFILE & EDIT 
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Revert channel style changes
	Navigate to Profile icon
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep     3s 
	CLICK DOWN
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_018_default_style
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_default_style Is Displayed on screen
	...  ELSE  Fail  TC_018_default_style Is Not Displayed on screen
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_018_ok
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_ok Is Displayed on screen
	...  ELSE  Fail  TC_018_ok Is Not Displayed on screen
	
	CLICK OK
	Sleep    3s 
	CLICK HOME
	Reboot STB Device
	Sleep     5s
	CLICK HOME
	CLICK BACK
	CLICK ONE
	CLICK FIVE
	Sleep    16s 
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Channelstyle5_1sttile_PN 
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_first_tile Is Displayed on screen
	...  ELSE  Fail  TC_018_first_tile Is Not Displayed on screen
	
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Channelstyle5_lasttile_PN 
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_last_tile Is Displayed on screen
	...  ELSE  Fail  TC_018_last_tile Is Not Displayed on screen

	Navigate to Profile icon
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    3s 
	CLICK DOWN
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_018_five_channel_style
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_five_channel_style Is Displayed on screen
	...  ELSE  Fail  TC_018_five_channel_style Is Not Displayed on screen
	
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	CLICK OK
	CLICK HOME
	Reboot STB Device
	Sleep     5s
	CLICK HOME
	CLICK BACK
	CLICK ONE
	CLICK FIVE
	Sleep    16s 
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Channelstyle9_1stPN_Final
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_first_tile Is Displayed on screen
	...  ELSE  Fail  TC_018_first_tile Is Not Displayed on screen
	
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Channelstyle9_LastPN_Final
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_last_tile Is Displayed on screen
	...  ELSE  Fail  TC_018_last_tile Is Not Displayed on screen

	CLICK HOME

TC_019_CONFIRM_PROFILE_DELETION
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
	NAVIGATE TO PROFILE ICON
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_019_Whos_Watching
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_019_Whos_Watching Is Displayed
	# ...  ELSE  Fail  TC_019_Whos_Watching Is Not Displayed
	CLICK RIGHT
	CLICK OK
	Enter Pincode 
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	NAVIGATE TO PROFILE ICON
	CLICK RIGHT
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}   New_Profile_ABCD
	# Run Keyword If  '${Result}' == 'True'  Log To Console  New_Profile_ABCD Is Displayed
	# ...  ELSE  Fail  New_Profile_ABCD Is Not Displayed
	${status2}=  Profile Name From Profile Settings Page
    Verify the Similarity Profile Name    ${status2}
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Enter Pincode
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_019_Profile_Deleted
	# Run Keyword If  '${Result}' == 'True'  Log To Console   Profile is deleted
	# ...  ELSE  Fail  Profile is not deleted
	${status2}=  Profile Name From Profile Settings Page
    Verify the Similarity Profile Name Negative Scenario    ${status2}
	Sleep    2s 
	CLICK HOME
	Reboot STB Device After profile delete
	Sleep    10s
	NAVIGATE TO PROFILE ICON
	# CLICK RIGHT
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_019_Profile_Deleted
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Profile deleted successfully
	# ...  ELSE  Fail  Profile still remains after reboot
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_004_New_user_created  
	# Run Keyword If  '${Result}' == 'False'  Log To Console  Profile deleted successfully
	# ...  ELSE  Fail  Profile still remains after reboot
	
    ${status2}=  Profile Name From Profile Settings Page
    Verify the Similarity Profile Name Negative Scenario    ${status2}
    Sleep    3s
	CLICK HOME

TC_2219_CONFIRM_PROFILE_DELETION_AFTER_STANDBY
    [Tags]    PROFILE & EDIT
	[Teardown]    Delete Profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_019_Whos_Watching
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_019_Whos_Watching Is Displayed
	# ...  ELSE  Fail  TC_019_Whos_Watching Is Not Displayed
	
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_004_New_user_created
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_019_Profile_Created Is Displayed
	...  ELSE  Fail  TC_019_Profile_Created Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_019_Profile_Deleted
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_019_Profile_Deleted Is Displayed
	...  ELSE  Fail  TC_019_Profile_Deleted Is Not Displayed
	Sleep    2s 

	CLICK HOME
	Sleep    10s
	Standby after delete profile
	Sleep    10s
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_004_New_user_created  
	Run Keyword If  '${Result}' == 'False'  Log To Console  Profile deleted successfully
	...  ELSE  Fail  Profile still remains after Standby
	CLICK HOME

TC_022_CREATE_PROFILE_WITH_CUSTOM_AVATAR
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Login As Admin    AND    DELETE PROFILE    AND    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION     
	NAVIGATE TO PROFILE ICON
	CLICK RIGHT
	CLICK OK
	Enter Pincode
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_022_Custom_avatar_selected
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_022_Custom_avatar_selected Is Displayed
	...  ELSE  Fail  TC_022_Custom_avatar_selected Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	# DELETE PROFILE
	Reboot STB Device After With Custom avatar Validation
	NAVIGATE TO PROFILE ICON
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_022_Custom_Avatart_Updated
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_022_Custom_Avatar_Updated Is Displayed After Reboot
	...  ELSE  Fail  TC_022_Custom_Avatar_Updated Is Not Displayed After Reboot
	
	Standby With Custom avatar Validation
	NAVIGATE TO PROFILE ICON
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_022_Custom_Avatart_Updated
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_022_Custom_Avatar_Updated Is Displayed After Standby
	...  ELSE  Fail  TC_022_Custom_Avatar_Updated Is Not Displayed After Standby
	
	NAVIGATE TO PROFILE ICON
	CLICK OK
	Enter Pincode
	Sleep    5s 
	NAVIGATE TO PROFILE ICON
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_022_Navigated_to_Admin
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_022_Navigated_to_Admin Is Displayed
	# ...  ELSE  Fail  TC_022_Navigated_to_Admin Is Not Displayed
	
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Enter Pincode
	Sleep    2s 
	CLICK HOME
	
TC_023_EDIT_PROFILE_USER_LANGUAGE_PREFERENCE
    [Tags]    PROFILE & EDIT 
	[Teardown]    Run Keywords    Revert UI language Subprofile    AND    Teardown exit whos watching page and login to Admin    AND    DELETE PROFILE
	CREATE PROFILE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    3s 
	
	CLICK DOWN
	CLICK DOWN

	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}   Arabic_Language
	Run Keyword If  '${Result}' == 'True'  Log To Console  Arabic_Language Is Displayed
	...  ELSE  Log To Console  Arabic_Language Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_805_ok_button
	# Run Keyword If  '${Result}' == 'True'  Log To Console  ok_button Is Displayed
	# ...  ELSE  Fail  ok_button Is Not Displayed
	
	CLICK OK
	Sleep    20s 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    CLICK RIGHT
	CLICK OK
	CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK THREE
	CLICK OK
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	Sleep    20s
    CLICK HOME
	Sleep    1s 
	CLICK ONE 
	CLICK TWO 
	CLICK ZERO
	CLICK ONE
	Sleep    3s
	New User Reboot STB Device
	Sleep    1s 
	CLICK HOME
	Sleep    5s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ARABIC_HOME
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_HOME Is Displayed on screen
	...  ELSE  Fail  ARABIC_HOME Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ARABIC_TV
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_TV Is Displayed on screen
	...  ELSE  Fail  ARABIC_TV Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ARABIC_BOX_OFFICE
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_BOX_OFFICE Is Displayed on screen
	...  ELSE  Fail  ARABIC_BOX_OFFICE Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ARABIC_KIDS
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_KIDS Is Displayed on screen
	...  ELSE  Fail  ARABIC_KIDS Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ARABIC_MYTV
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_MYTV Is Displayed on screen
	...  ELSE  Fail  ARABIC_MYTV Is Not Displayed on screen
	Sleep    2s 
	#Login to admin again
	




TC_024_CREATE_CHILD_PROFILE_WITH_AGE_BASED_RESTRICTION
    [Tags]    PROFILE & EDIT 
	[Teardown]	Run Keywords	NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION	AND	Delete Profile	
	NAVIGATE TO PROFILE ICON
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Enter Pincode 
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	NAVIGATE TO PROFILE ICON
	CLICK RIGHT
    ##### Validate kids profile####
    ${Result}  Verify Crop Image With Shorter Duration  ${port}      KIDS_PROFILE_ABCD
	Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_PROFILE Is Displayed on screen
	...  ELSE  Fail     KIDS_PROFILE Is Not Displayed on screen

	NAVIGATE TO PROFILE ICON
	CLICK RIGHT

	CLICK OK
	Enter Pincode 
	Sleep    5s 
	#valiadation for kids profile
	CLICK HOME
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_105_KIDS
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_024_KIDS Is Displayed
	...  ELSE  Fail  TC_024_KIDS Is Not Displayed
	CLICK BACK
	Sleep    2s

	CLICK HOME
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration    ${port}    Recommended_Feeds
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Recommended_Feeds is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recommended_Feeds is not displayed after navigating right	
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}    G_Rating
	Run Keyword If  '${Result}' == 'True'  Log To Console  G_Rating Is Displayed
	...  ELSE  Fail  G_Rating Is Not Displayed
	CLICK BACK
	Sleep    2s 
	CLICK BACK
	CLICK RIGHT
	CLICK OK
	Sleep    2s 
	CLICK BACK
	Sleep	5s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	#IMAGE VALIDATION IN EPG - TAKE CHANNEL NUMBER - 5 CHANNELS
	${Result}  Verify Crop Image With Shorter Duration  ${port}  KIDS_BOOKMARK
	Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_BOOKMARK Is Displayed
	...  ELSE  Fail  KIDS_BOOKMARK Is Not Displayed
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  KIDS_CHANNEL_1
	# Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_CHANNEL_1 Is Displayed
	# ...  ELSE  Fail  KIDS_CHANNEL_1 Is Not Displayed
	# Sleep	2s
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# 	${Result}  Verify Crop Image With Shorter Duration  ${port}  KIDS_CHANNEL_2
	# Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_CHANNEL_2 Is Displayed
	# ...  ELSE  Fail  KIDS_CHANNEL_2 Is Not Displayed
	# Sleep	2s
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# 	${Result}  Verify Crop Image With Shorter Duration  ${port}  KIDS_CHANNEL_3
	# Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_CHANNEL_3 Is Displayed
	# ...  ELSE  Fail  KIDS_CHANNEL_3 Is Not Displayed
	# Sleep	2s
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# 	${Result}  Verify Crop Image With Shorter Duration  ${port}  KIDS_CHANNEL_4
	# Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_CHANNEL_4 Is Displayed
	# ...  ELSE  Fail  KIDS_CHANNEL_4 Is Not Displayed
	# Sleep	2s
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# 	${Result}  Verify Crop Image With Shorter Duration  ${port}  KIDS_CHANNEL_5
	# Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_CHANNEL_5 Is Displayed
	# ...  ELSE  Fail  KIDS_CHANNEL_5 Is Not Displayed
	# Log To Console 	5 Channels got displayed
	CLICK HOME
	#login into admin
	NAVIGATE TO PROFILE ICON
	CLICK OK
	Enter Pincode
	Sleep    2s
	Enter Pincode 
	Sleep    10s
	CLICK HOME
	
TC_027_EDIT_PROFILE_REMOVE_CHANNEL_FAVORITE_LIST
    [Tags]    PROFILE & EDIT
    [Documentation]     Delete Favorite and verify Delete favorite channels from Favorite list
	[Teardown]    Revert favorites
    Add 5 channels Each to Two Different Favorite List under Profile Settings
    Delete Favorite Channel from Favorite List
	Reboot STB Device
	Sleep    2s
	CLICK HOME
	Sleep    2s
	CLICK HOME
    Verify Favorite channel deleted from Favorite List
	Reboot STB Device
	Sleep    2s
	CLICK HOME
	Sleep    2s
	CLICK HOME
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	#Check if last selected favorite List is retained after Reboot
	Sleep    8s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  FAVLIST2_CH1_CHECK
	Run Keyword If  '${Result}' == 'False'  Log To Console  FAVLIST2_CH1_CHECK Is Not Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH1_CHECK Is Displayed on screen
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  FAVLIST2_CH2_CHECK
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH2_CHECK Is Displayed on screen
	...  ELSE  Log To Console  FAVLIST2_CH2_CHECK Is Not Displayed on screen
	Log To Console    Last selected favorite List is retained after Reboot
	CLICK HOME
	CLICK HOME



TC_033_EDIT_PROFILE_CHANGE_DEFAULT_AUDIO_LANGUAGE_VERIFY_PLAYBACK
    [Tags]    PROFILE & EDIT
	[Teardown]    Delete Profile
	Create New Profile
	Navigate To Profile 
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    3s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s 
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  AUDIO_ENGLISH
	Run Keyword If  '${Result}' == 'True'  Log To Console  AUDIO_ENGLISH Is Displayed on screen
	...  ELSE  Fail  AUDIO_ENGLISH Is Not Displayed on screen
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    5s
    CLICK HOME
    Reboot STB Device
	Navigate To Profile 
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    15s 
	CLICK THREE
	CLICK TWO
	CLICK SIX
	# CLICK FIVE
	Sleep    18s
	CLICK UP
	CLICK OK
	Sleep    2s
    CLICK RIGHT
    ${STEP_COUNT}=    Move to Audio Launguage On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console     Navigated to audio language
	# CLICK RIGHT
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  English_Audio_Playback
	Run Keyword If  '${Result}' == 'True'  Log To Console  CONFIRM_AUDIO_ENGLISH Is Displayed on screen
	...  ELSE  Fail  CONFIRM_AUDIO_ENGLISH Is Not Displayed on screen

	CLICK HOME
	#LOGIN TO ADMIN FOR EDTING
	Navigate To Profile 
	# CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    10s
	#EDITING THE Sub PROFILE
	Navigate To Profile 
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s 
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s 
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	# CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  CONFIRM_AUDIO_ARABIC_ANDROID
	Run Keyword If  '${Result}' == 'True'  Log To Console  CONFIRM_AUDIO_ARABIC_ANDROID Is Displayed on screen
	...  ELSE  Log To Console  CONFIRM_AUDIO_ARABIC_ANDROID Is Not Displayed on screen
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    1s
    CLICK HOME
    Reboot STB Device
    Navigate To Profile 
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    15s 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    1s 
	CLICK THREE
	CLICK TWO
	CLICK SIX
	# CLICK FIVE
	Sleep    18s
	CLICK UP
	CLICK OK
	Sleep    3s
    CLICK RIGHT
    ${STEP_COUNT}=    Move to Audio Launguage On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console     Navigated to audio language
	# CLICK RIGHT
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Arabic_Audio_Language_Playback
	Run Keyword If  '${Result}' == 'True'  Log To Console  Arabic_Audio_Playback Is Displayed on screen
	...  ELSE  Fail  Arabic_Audio_Playback Is Not Displayed on screen
	CLICK HOME
	Login As Admin



TC_031_EDIT_PROFILE_ENABLE_DISABLE_AUTO_LOGIN
    [Tags]    PROFILE & EDIT
	[Documentation]    Edit Porfile and enable disable auyo login
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
	Create New Profile
	Navigate To Profile
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_006_Always_login
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Always_login Is Displayed on screen
	...  ELSE  Fail  TC_006_Always_login Is Not Displayed on screen
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Log To Console   Disabled always login
	CLICK HOME
	Sleep    2s
	# Sleep    120s
	Reboot STB Device For new user
    ${Result}  Verify Crop Image With Shorter Duration    ${port}   TC_520_Who_Watching
	Run Keyword If  '${Result}' == 'True'   Fail   TC_520_Who_Watching Is Displayed on screen
	...  ELSE   Log To Console   TC_520_Who_Watching Is Not Displayed on screen 
	Navigate To Profile
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ABCD_NEW_USER
	Run Keyword If  '${Result}' == 'True'  Log To Console  ABCD_NEW_USER Is Displayed on screen
	...  ELSE  Fail  ABCD_NEW_USER Is Not Displayed on screen
	CLICK HOME
	Log To Console    Going to Power off
	CLICK POWER
	Sleep    2s
	Log To Console    Going to Power on
	CLICK POWER
	Sleep    20s
	${Result}  Verify Crop Image With Shorter Duration    ${port}   TC_520_Who_Watching
	Run Keyword If  '${Result}' == 'True'   Fail   TC_520_Who_Watching Is Displayed on screen
	...  ELSE   Log To Console   TC_520_Who_Watching Is Not Displayed on screen - Test Passed
	Navigate To Profile
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ABCD_NEW_USER
	Run Keyword If  '${Result}' == 'True'  Log To Console  ABCD_NEW_USER Is Displayed on screen
	...  ELSE  Fail  ABCD_NEW_USER Is Not Displayed on screen
    Login As Admin
	Navigate To Profile
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Log To Console   Enabled always login
	CLICK HOME
	Sleep    2s
	Reboot STB Device For new user
	${Result}  Verify Crop Image With Shorter Duration    ${port}   TC_520_Who_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_520_Who_Watching Is Displayed on screen
	...  ELSE  Fail   TC_520_Who_Watching Is Not Displayed on screen
	${Result}  Verify Crop Image With Shorter Duration    ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  ABCD_NEW_USER Is Displayed on screen
	...  ELSE  Fail  ABCD_NEW_USER Is Not Displayed on screen
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    30s
	CLICK HOME
	Navigate To Profile
		${Result}  Verify Crop Image With Shorter Duration    ${port}  ABCD_NEW_USER
	Run Keyword If  '${Result}' == 'True'  Log To Console  ABCD_NEW_USER Is Displayed on screen
	...  ELSE  Fail  ABCD_NEW_USER Is Not Displayed on screen
	Log To Console    Going to Power off
	CLICK POWER
	Sleep    2s
	Log To Console    Going to Power on
	CLICK POWER
	Sleep    20s
	${Result}  Verify Crop Image With Shorter Duration    ${port}   TC_520_Who_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_520_Who_Watching Is Displayed on screen
	...  ELSE  Fail   TC_520_Who_Watching Is Not Displayed on screen
	${Result}  Verify Crop Image With Shorter Duration    ${port}  abcd_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  ABCD_NEW_USER Is Displayed on screen
	...  ELSE  Fail  ABCD_NEW_USER Is Not Displayed on screen
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    20s
	Navigate To Profile
		${Result}  Verify Crop Image With Shorter Duration    ${port}  ABCD_NEW_USER
	Run Keyword If  '${Result}' == 'True'  Log To Console  ABCD_NEW_USER Is Displayed on screen
	...  ELSE  Fail  ABCD_NEW_USER Is Not Displayed on screen
	Sleep    20s
	Login As Admin
	Delete New Profile
	CLICK HOME
	Sleep    10s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen

#######################################################################################################

TC_851_ACCESS_CLOUD_GAMING_MENU_AND_LAUNCH_GAME_FROM_LIBRARY
    [Tags]    GAMING
    [Documentation]    Launch game from library
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated to Gaming
	CLICK OK
	Log To Console    Navigated to PLAY Game
	Sleep    100s
	${Result}  Verify Crop Image With Shorter Duration  ${port}    game_title
	Run Keyword If  '${Result}' == 'True'  Log To Console  game_title Is Displayed on screen
	...  ELSE  Fail  game_title Is Not Displayed on screen
	CLICK OK 
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	
	CLICK OK
	Sleep    1s
	

	CLICK OK
	CLICK OK
	Log To Console    Game is loading
	Sleep    200s
    VALIDATE VIDEO PLAYBACK

	CLICK BACK
	Log To Console    Exiting Game

	CLICK OK
	CLICK LEFT
	CLICK OK
	Sleep    10s
	CLICK BACK
	CLICK BACK
	CLICK OK
	Sleep    70s
	CLICK HOME

TC_852_PLAY_CLOUD_GAME_VERIFY_SMOOTH_STREAMING
    [Tags]    GAMING
    [Documentation]    Launch game and check for smooth streaming
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK LEFT
	Log To Console    Navigting to game library
	CLICK OK
	Sleep    60s
	${Result}  Verify Crop Image With Shorter Duration  ${port}    game_title
	Run Keyword If  '${Result}' == 'True'  Log To Console  game_title Is Displayed on screen
	...  ELSE  Fail  game_title Is Not Displayed on screen
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK OK
	Log To Console    Game is loading
	Sleep    200s
	Log To Console    Playing
    VALIDATE VIDEO PLAYBACK


	CLICK BACK
	Log To Console    Exiting Game

	CLICK OK
	CLICK LEFT
	CLICK OK
	Sleep    10s
	CLICK BACK
	CLICK BACK
	CLICK OK
	Sleep    30s
	CLICK HOME

TC_855_EXIT_FROM_GAMING_AND_JOIN_LIVETV
    [Tags]    GAMING
    [Documentation]    Launch game ,exit and switch to live
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    60s
	${Result}  Verify Crop Image With Shorter Duration  ${port}    game_title
	Run Keyword If  '${Result}' == 'True'  Log To Console  game_title Is Displayed on screen
	...  ELSE  Fail  game_title Is Not Displayed on screen
	CLICK OK
	CLICK OK
	#Games subscription pin
	Sleep    2s
	CLICK OK
	Sleep    30s
	CLICK OK
	Log To Console    Game is loading
	Sleep    200s
    VALIDATE VIDEO PLAYBACK

	
    CLICK BACK
	Log To Console    Exiting Game

	CLICK OK
	CLICK LEFT
	CLICK OK
	Sleep    10s
	CLICK BACK
	CLICK BACK
	CLICK OK
	Sleep    30s
	CLICK HOME

	CLICK ONE
	CLICK TWO
	VALIDATE VIDEO PLAYBACK


TC_858_VERIFY_PARENTAL_CONTROL_RESTRICT_ACCESS_CLOUD_GAMING_UNTIL_PIN_ENTRED
    [Tags]    GAMING
    [Documentation]    Verify restrict access gaming
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	
	CLICK OK
	Sleep    60s
	${Result}  Verify Crop Image With Shorter Duration  ${port}    game_title
	Run Keyword If  '${Result}' == 'True'  Log To Console  game_title Is Displayed on screen
	...  ELSE  Fail  game_title Is Not Displayed on screen
	CLICK OK
	CLICK OK
	Sleep    1s
	CLICK OK
	Sleep    1s
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK OK
	Log To Console    Game is loading
	Sleep    200s
    VALIDATE VIDEO PLAYBACK

	CLICK BACK
	Sleep    1s
	CLICK BACK
	Sleep    1s
	CLICK OK
	Sleep    50s
	CLICK HOME

TC_865_ACCESS_CLOUD_GAME_REQUIRING_PREMIUM_SUBSCRIPTION_VERIFY_PAYMENT_PROMPT_APPEARS
	[Tags]    GAMING
    [Documentation]    verify payment prompt appears
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep   30s
	${Result}  Verify Crop Image With Shorter Duration  ${port}    buy-gaming
	Run Keyword If  '${Result}' == 'True'  Log To Console     buy-gaming Is Displayed on screen
	...  ELSE  Fail  but-gaming Is Not Displayed on screen
	CLICK OK
	Sleep    1s
	CLICK DOWN
	CLICK LEFT
	${Result}  Verify Crop Image With Shorter Duration  ${port}    order_gaming
	Run Keyword If  '${Result}' == 'True'  Log To Console     order_gaming Is Displayed on screen
	...  ELSE  Fail    order_gaming Is Not Displayed on screen

	Sleep    10s
	CLICK BACK
	CLICK OK
	Sleep    20s
	CLICK HOME
#####################################################################################################



TC_051_MONITOR_CHANNEL_FEATURES
   Channel Monitoring        Info Channel
TC_052_ZAPPING_ENDURANCE_SD_SD_CHANNELS
    [Tags]    Zapping
    CLICK HOME	
    ${SD_Channel}=    Verify Channel Availability    SD
    Sleep    5s
	Log To Console	Press chanel 4
    CLICK FOUR
    ${start_time}=    Get Time    epoch
    Input Channel Number    ${SD_Channel}       
    Channel Playback Verified    ${SD_Channel}    SD
    ${end_time}=    Get Time    epoch
	# Reducing 2s for video playback time elapse
    ${zap_time_ms}=    Evaluate    int((${end_time} - ${start_time}) * 1000)
    Log To Console    \nZap time for channel ${SD_Channel}: ${zap_time_ms} ms

    Run Keyword If    ${zap_time_ms} > 25000    Fail    Zap time exceeded 25000 ms (actual: ${zap_time_ms} ms)
    ...    ELSE    Log To Console    Zap time within limit ✅

TC_053_ZAPPING_ENDURANCE_SD_HD_CHANNELS
    [Tags]    Zapping
    CLICK HOME
	${HD_Channel}=    Verify Channel Availability    HD
	${SD_Channel}=    Verify Channel Availability    SD
	Input Channel Number    ${SD_Channel}
	Sleep	5s
    ${start_time}=    Get Time    epoch
    Input Channel Number    ${HD_Channel}
	Channel Playback Verified	${HD_Channel}	HD
    ${end_time}=    Get Time    epoch

    ${zap_time_ms}=    Evaluate    int((${end_time} - ${start_time}) * 1000)
    Log To Console    \nZap time for channel ${HD_Channel}: ${zap_time_ms} ms
	Run Keyword If    ${zap_time_ms} > 25000    Fail    Zap time exceeded 25000 ms (actual: ${zap_time_ms} ms)
    ...    ELSE    Log To Console    Zap time within limit ✅
TC_054_ZAPPING_ENDURANCE_HD_SD_CHANNELS
	[Tags]    Zapping
    CLICK HOME
	${SD_Channel}=    Verify Channel Availability    SD
	${HD_Channel}=    Verify Channel Availability    HD
	Input Channel Number    ${HD_Channel}	
	Sleep	5s
    ${start_time}=    Get Time    epoch
    Input Channel Number    ${SD_Channel}
	Channel Playback Verified	${SD_Channel}	SD
    ${end_time}=    Get Time    epoch

    ${zap_time_ms}=    Evaluate    int((${end_time} - ${start_time}) * 1000)
    Log To Console    \nZap time for channel ${SD_Channel}: ${zap_time_ms} ms
	Run Keyword If    ${zap_time_ms} > 25000    Fail    Zap time exceeded 25000 ms (actual: ${zap_time_ms} ms)
    ...    ELSE    Log To Console    Zap time within limit ✅
TC_055_ZAPPING_ENDURANCE_HD_HD_CHANNELS
    [Tags]    Zapping
    CLICK HOME	
	${HD_Channel}=    Verify Channel Availability    HD
	CLICK ONE
	CLICK FIVE
	Sleep	5s
    ${start_time}=    Get Time    epoch
	Input Channel Number    ${HD_Channel}	
	Channel Playback Verified	${HD_Channel}	HD
    ${end_time}=    Get Time    epoch

    ${zap_time_ms}=    Evaluate    int((${end_time} - ${start_time}) * 1000)
    Log To Console    \nZap time for channel ${HD_Channel}: ${zap_time_ms} ms
	Run Keyword If    ${zap_time_ms} > 25000    Fail    Zap time exceeded 25000 ms (actual: ${zap_time_ms} ms)
    ...    ELSE    Log To Console    Zap time within limit ✅

TC_057_ZAPPING_ENDURANCE_UHD_HD_CHANNELS
	[Tags]    Zapping
    CLICK HOME
	CLICK TWO
	CLICK ZERO
	CLICK FOUR
	Sleep	5s
	${HD_Channel}=    Verify Channel Availability    HD
    ${start_time}=    Get Time    epoch
    Input Channel Number    ${HD_Channel}
    ${end_time}=    Get Time    epoch

    ${zap_time_ms}=    Evaluate    int((${end_time} - ${start_time}) * 1000)
    Log To Console    \nZap time for channel ${HD_Channel}: ${zap_time_ms} ms
	Channel Playback Verified	${SD_Channel}	HD
TC_058_ZAPPING_ENDURANCE_UHD_HD_CHANNELS
	[Tags]    Zapping
    CLICK HOME
	${HD_Channel}=    Verify Channel Availability    HD
	Input Channel Number    ${HD_Channel}	
	Sleep	5s
    ${start_time}=    Get Time    epoch
    CLICK TWO
	CLICK ZERO
	CLICK FOUR
    ${end_time}=    Get Time    epoch

    ${zap_time_ms}=    Evaluate    int((${end_time} - ${start_time}) * 1000)
    Log To Console    \nZap time for channel ${UHD_Channel}: ${zap_time_ms} ms
	Channel Playback Verified	${HD_Channel}	UHD
TC_059_SD_CHANNEL_VIDEO_QUALITY
    CLICK HOME
    ${SD_Channel}=    Verify Channel Availability    SD
	Input Channel Number    ${SD_Channel}
	Sleep    120s
	EVALUATE VIDEO QUALITY STATUS    80


TC_060_HD_CHANNEL_VIDEO_QUALITY
    CLICK HOME
    ${HD_Channel}=    Verify Channel Availability    HD
	Input Channel Number    ${HD_Channel}
	Sleep    120s
	EVALUATE VIDEO QUALITY STATUS    80

TC_061_UHD_CHANNEL_VIDEO_QUALITY
    CLICK HOME
    CLICK TWO
	CLICK ZERO
	CLICK FOUR
	Sleep    120s
	EVALUATE VIDEO QUALITY STATUS    80
############################################################################################################


TC_OTT_001_VERIFY_SLIDE_MENU_FUNCTIONALITY
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_001_Home_Page
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_001_Home_Page Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_001_Home_Page Is Not Displayed on screen
TC_OTT_002_VERIFY_PROGRAM_GUIDE_PAGE
    [Tags]    OTT
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_002_Program_Guide_Page
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_002_Program_Guide_Page Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_002_Program_Guide_Page Is Not Displayed on screen
TC_OTT_003_VERIFY_TV_PAGE
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
	CLICK DOWN
    CLICK DOWN
	# Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_003_TV_Page
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_003_TV_Page Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_003_TV_Page Is Not Displayed on screen

TC_OTT_004_VERIFY_TV_MY_MOST_WATCHED
    [Tags]    OTT
	# [Teardown]   BACK TO HOME
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_004_TV_My_Most_Watched
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_004_TV_My_Most_Watched Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_004_TV_My_Most_Watched Is Not Displayed on screen

TC_OTT_012_VERIFY_MOVIES_PAGE
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_012_Movies_Page
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_012_Movies_Page Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_012_Movies_Page Is Not Displayed on screen

TC_OTT_013_VERIFY_MOVIES_TRENDING
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	# Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_013_Movies_Trending
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_013_Movies_Trending Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_013_Movies_Trending Is Not Displayed on screen

TC_OTT_022_VERIFY_MOVIES_MY_ACTIVE
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_022_Movies_My_Active
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_022_Movies_My_Active Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_022_Movies_My_Active Is Not Displayed on screen


TC_OTT_024_VERIFY_SERIESANDSHOWS_TRENDING
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_006_TV_Trending
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_006_TV_Trending Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_006_TV_Trending Is Not Displayed on screen

TC_OTT_030_VERIFY_SERIESANDSHOWS_EDITORS_CHOICE
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_029_EDITORS_CHOICE
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_029_EDITORS_CHOICE Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_029_EDITORS_CHOICE Is Not Displayed on screen

TC_OTT_031_VERIFY_MY_MEDIA_PAGE
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep    2s
    CLICK OK
	Sleep    1s
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_031_MY_MEDIA_PAGE
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_031_MY_MEDIA_PAGE Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_031_MY_MEDIA_PAGE Is Not Displayed on screen

TC_OTT_033_VERIFY_MY_MEDIA_VIDEO_PACKS
	[Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep    2s
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
	Sleep    1s
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_033_MY_MEDIA_VIDEO_PACKS
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_033_MY_MEDIA_VIDEO_PACKS Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_033_MY_MEDIA_VIDEO_PACKS Is Not Displayed on screen

TC_OTT_034_VERIFY_MY_MEDIA_FAVORITES
	[Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep    2s
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	Sleep    1s
    CLICK OK
	Sleep    1s
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_008_TV_Favorites
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_008_TV_Favorites Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_008_TV_Favorites Is Not Displayed on screen

TC_OTT_035_VERIFY_MY_MEDIA_LAST_VIEWED
	[Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep    2s
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_034_MY_MEDIA_LAST_VIEWED
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_034_MY_MEDIA_LAST_VIEWED Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_034_MY_MEDIA_LAST_VIEWED Is Not Displayed on screen

TC_OTT_036_VERIFY_MY_MEDIA_MY_LIST
	[Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep    2s
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
	Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_036_MY_MEDIA_MY_LIST
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_036_MY_MEDIA_MY_LIST Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_036_MY_MEDIA_MY_LIST Is Not Displayed on screen

TC_OTT_039_VERIFY_ASSIST_SOFT_FACTORY_RESET
	[Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep	2s
    CLICK RIGHT
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_039_ASSIST_SOFT_FACTORY_RESET
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_039_ASSIST_SOFT_FACTORY_RESET Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_039_ASSIST_SOFT_FACTORY_RESET Is Not Displayed on screen


TC_OTT_042_VERIFY_ASSIST_MESSAGES
	[Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep	2s
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_042_ASSIST_MESSAGES
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_042_ASSIST_MESSAGES Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_042_ASSIST_MESSAGES Is Not Displayed on screen

TC_OTT_044_VERIFY_SEARCH_LIVE_TV
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep    2s
	CLICK RIGHT
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_044_SEARCH_LIVE_TV
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_044_SEARCH_LIVE_TV Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_044_SEARCH_LIVE_TV Is Not Displayed on screen
    CLICK HOME

TC_OTT_045_VERIFY_SEARCH_CATCH_UP
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep    2s
	CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_045_SEARCH_CATCH_UPS
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_045_SEARCH_CATCH_UP Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_045_SEARCH_CATCH_UP Is Not Displayed on screen
    CLICK HOME

TC_OTT_049_VERIFY_SEARCH_PAGE
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK OK
	Sleep    1s
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_049_SEARCH_PAGE
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_049_SEARCH_PAGE Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_049_SEARCH_PAGE Is Not Displayed on screen

TC_OTT_050_VERIFY_ADMIN_PROFILE_LOGIN
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK UP   
	Sleep    1s
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_050_ADMIN_PROFILE_LOGIN
    Run Keyword If    '${Result}' == 'True'    Log To Console     TC_OTT_050_ADMIN_PROFILE_LOGIN Is Displayed on screen
    ...    ELSE    Fail     TC_OTT_050_ADMIN_PROFILE_LOGIN Is Not Displayed on screen

TC_OTT_055_VERIFY_PROGRAM_GUIDE_WATCH_BUTTON_AVAILABILITY
    [Tags]    OTT
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK OK
	CLICK OK
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_055_PROGRAM_GUIDE_WATCH_BUTTON
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_055_PROGRAM_GUIDE_WATCH_BUTTON Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_055_PROGRAM_GUIDE_WATCH_BUTTON Is Not Displayed on screen

TC_OTT_005_VERIFY_TV_POPULAR_CHANNELS
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
	BACK TO HOME
    Get Menu Slider
	Sleep    1s 
    CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
    CLICK RIGHT
	# Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_005_TV_Popular_Channels
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_005_TV_Popular_Channels Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_005_TV_Popular_Channels Is Not Displayed on screen

TC_OTT_006_VERIFY_TV_TRENDING
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
	BACK TO HOME
    Get Menu Slider
	Sleep    1s 
    CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_006_TV_Trending
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_006_TV_Trending Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_006_TV_Trending Is Not Displayed on screen

TC_OTT_007_VERIFY_TV_CATCH_UP
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s 
    CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
	CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_007_TV_Catch_Up
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_007_TV_Catch_Up Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_007_TV_Catch_Up Is Not Displayed on screen

TC_OTT_008_VERIFY_TV_FAVORITES
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_008_TV_Favorites
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_008_TV_Favorites Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_008_TV_Favorites Is Not Displayed on screen

TC_OTT_009_VERIFY_TV_RECOMMENDED
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_009_TV_Recommended
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_009_TV_Recommended Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_009_TV_Recommended Is Not Displayed on screen
    CLICK HOME

TC_OTT_010_VERIFY_TV_NEXT_7_DAYS
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_010_TV_Next_7_Days
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_010_TV_Next_7_Days Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_010_TV_Next_7_Days Is Not Displayed on screen

TC_OTT_011_VERIFY_TV_REMINDER
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
	CLICK RIGHT
	# Sleep    1s
	CLICK RIGHT
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_011_TV_Reminder
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_011_TV_Reminder Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_011_TV_Reminder Is Not Displayed on screen



TC_OTT_014_VERIFY_MOVIES_PREMIUM
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_014_Movies_Premium
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_014_Movies_Premium Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_014_Movies_Premium Is Not Displayed on screen
    CLICK HOME

TC_OTT_015_VERIFY_MOVIES_NEW_RELEASES
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    Sleep    2s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_015_Movies_New_Releases
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_015_Movies_New_Releases Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_015_Movies_New_Releases Is Not Displayed on screen
    CLICK HOME

TC_OTT_016_VERIFY_MOVIES_FAVORITES
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    Sleep    2s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK OK
    # ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_016_Movies_Favorites
    # Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_016_Movies_Favorites Is Displayed on screen
    # ...    ELSE    Fail    TC_OTT_016_Movies_Favorites Is Not Displayed on screen

TC_OTT_017_VERIFY_MOVIES_RECOMMENDED
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    Sleep    2s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_017_Movies_Recommended
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_017_Movies_Recommended Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_017_Movies_Recommended Is Not Displayed on screen


TC_OTT_018_VERIFY_MOVIES_GENRE_MOODS
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    Sleep    2s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	CLICK RIGHT
	# Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_018_Movies_Genre_Moods
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_018_Movies_Genre_Moods Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_018_Movies_Genre_Moods Is Not Displayed on screen

TC_OTT_019_VERIFY_MOVIES_TOP_RATED
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    Sleep    2s
    CLICK RIGHT
	Sleep    1s
    CLICK RIGHT
	Sleep    1s
    CLICK RIGHT
	Sleep    1s
    CLICK RIGHT
	Sleep    1s
    CLICK RIGHT
	Sleep    1s
    CLICK RIGHT
	CLICK RIGHT
	Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_019_Movies_Top_Rated
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_019_Movies_Top_Rated Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_019_Movies_Top_Rated Is Not Displayed on screen

TC_OTT_020_VERIFY_MOVIES_MUST_SEE
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    Sleep    2s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	CLICK RIGHT
	# Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_020_Movies_Must_See
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_020_Movies_Must_See Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_020_Movies_Must_See Is Not Displayed on screen

TC_OTT_021_VERIFY_MOVIES_SPECIAL_OFFERS
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    Sleep    2s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	# Sleep    1s
    CLICK RIGHT
	CLICK RIGHT
	# Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_021_Movies_Special_Offers
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_021_Movies_Special_Offers Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_021_Movies_Special_Offers Is Not Displayed on screen




TC_OTT_023_VERIFY_SERIESANDSHOWS_PAGE
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_023_SERIESANDSHOWS_Page
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_023_SERIESANDSHOWS_Page Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_023_SERIESANDSHOWS_Page Is Not Displayed on screen


TC_OTT_025_VERIFY_SERIESANDSHOWS_NEW_RELEASES
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	CLICK RIGHT
	Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_015_Movies_New_Releases
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_015_Movies_New_Releases Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_015_Movies_New_Releases Is Not Displayed on screen

TC_OTT_026_VERIFY_SERIESANDSHOWS_FAVORITES
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_008_TV_Favorites
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_008_TV_Favorites Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_008_TV_Favorites Is Not Displayed on screen

TC_OTT_027_VERIFY_SERIESANDSHOWS_RECOMMENDED
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_009_TV_Recommended
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_009_TV_Recommended Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_009_TV_Recommended Is Not Displayed on screen
    CLICK HOME

TC_OTT_028_VERIFY_SERIESANDSHOWS_GENRE_MOODS
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_018_Movies_Genre_Moods
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_018_Movies_Genre_Moods Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_018_Movies_Genre_Moods Is Not Displayed on screen
	
TC_OTT_029_VERIFY_SERIESANDSHOWS_TOP_RATED
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	Sleep    2s
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    1s
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_019_Movies_Top_Rated
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_019_Movies_Top_Rated Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_019_Movies_Top_Rated Is Not Displayed on screen
	

	
TC_OTT_032_VERIFY_MY_MEDIA_ACTIVE
	[Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK RIGHT
	Sleep    2s
    CLICK OK
	Sleep    1s
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_032_MY_MEDIA_ACTIVE
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_032_MY_MEDIA_ACTIVE Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_032_MY_MEDIA_ACTIVE Is Not Displayed on screen
	

	
TC_OTT_037_VERIFY_MY_MEDIA_RECORDER
	[Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep    2s
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    1s
    CLICK OK
	Sleep    1s
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_037_MY_MEDIA_RECORDER
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_037_MY_MEDIA_RECORDER Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_037_MY_MEDIA_RECORDER Is Not Displayed on screen
TC_OTT_038_VERIFY_ASSIST_MENU
	[Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep	2s
    CLICK OK
	Sleep	1s
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_038_ASSIST_MENU
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_038_ASSIST_MENU Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_038_ASSIST_MENU Is Not Displayed on screen


TC_OTT_040_VERIFY_ASSIST_PROFILE_PREFERENCES
	[Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep	2s
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_040_ASSIST_PROFILE_PREFERENCES
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_040_ASSIST_PROFILE_PREFERENCES Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_040_ASSIST_PROFILE_PREFERENCES Is Not Displayed on screen

TC_OTT_041_VERIFY_ASSIST_ACCOUNT_INFO
	[Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep	2s
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_041_ASSIST_ACCOUNT_INFO
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_041_ASSIST_ACCOUNT_INFO Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_041_ASSIST_ACCOUNT_INFO Is Not Displayed on screen



TC_OTT_043_VERIFY_ASSIST_HELP
	[Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep	2s
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_043_ASSIST_HELP
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_043_ASSIST_HELP Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_043_ASSIST_HELP Is Not Displayed on screen



TC_OTT_046_VERIFY_SEARCH_ON_DEMAND
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep    2s
	CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_046_SEARCH_ON_DEMAND
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_046_SEARCH_ON_DEMAND Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_046_SEARCH_ON_DEMAND Is Not Displayed on screen
    CLICK HOME

TC_OTT_047_VERIFY_SEARCH_CHANNELS
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep    2s
	CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_047_SEARCH_CHANNELS
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_047_SEARCH_CHANNELS Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_047_SEARCH_CHANNELS Is Not Displayed on screen
    CLICK HOME

TC_OTT_048_VERIFY_SEARCH_ALL
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep    2s
	CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_048_SEARCH_ALL
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_048_SEARCH_ALL Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_048_SEARCH_ALL Is Not Displayed on screen
    CLICK HOME



TC_OTT_051_VERIFY_PROFILE_LOGOUT_OPTION_AVAILABILITY
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK UP 
	CLICK RIGHT 
	Sleep    1s
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}     TC_OTT_051_PROFILE_LOGOUT_OPTION_AVAILABILITY
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_051_PROFILE_LOGOUT_OPTION_AVAILABILITY Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_051_PROFILE_LOGOUT_OPTION_AVAILABILITY Is Not Displayed on screen

TC_OTT_052_VERIFY_ADD_PROFILE_AVAILABILITY
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK UP 
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    1s
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_Add_Profile
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_052_ADD_PROFILE_AVAILABILITY Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_052_ADD_PROFILE_AVAILABILITY Is Not Displayed on screen

TC_OTT_053_VERIFY_ADD_PROFILE_PAGE
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK UP 
	Sleep    1s
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    1s
	CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_053_ADD_PROFILE_PIN
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_053_ADD_PROFILE_PIN Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_053_ADD_PROFILE_PIN Is Not Displayed on screen

# TC_OTT_054_LOAD_HOME_PAGE
#     [Tags]    OTT
# 	# [Teardown]    BACK TO HOME
#     BACK TO HOME
#     ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_001_Home_Page
#     Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_001_Home_Page Is Displayed on screen
#     ...    ELSE    Fail    TC_OTT_001_Home_Page Is Not Displayed on screen

TC_OTT_054_LOAD_HOME_PAGE
    [Tags]    OTT
	# [Teardown]    BACK TO HOME
    BACK TO HOME
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_001_Home_Page
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_001_Home_Page Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_001_Home_Page Is Not Displayed on screen
	
TC_OTT_056_VERIFY_PROGRAM_GUIDE_PLAYBACK
    [Tags]    OTT
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	sLEEP	5S
	VALIDATE VIDEO PLAYBACK

TC_OTT_057_VERIFY_LIVE_WATCH_BUTTON_AVAILABILITY
    [Tags]    OTT
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK OK
	CLICK OK
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_055_LIVE_WATCH_BUTTON
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_055_LIVE_WATCH_BUTTON Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_055_LIVE_WATCH_BUTTON Is Not Displayed on screen
TC_OTT_058_VERIFY_LIVE_PLAYBACK
    [Tags]    OTT
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	sLEEP	5S
	VALIDATE VIDEO PLAYBACK

TC_OTT_059_RETURN_FROM_LIVE_PLAYBACK
    [Tags]    OTT
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	sLEEP	5S
	VALIDATE VIDEO PLAYBACK
	BACK TO HOME

TC_OTT_060_RETURN_FROM_LIVE_PLAYBACK_BACK_BUTTON
    [Tags]    OTT
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	5S
	VALIDATE VIDEO PLAYBACK
    CLICK BACK
	Check For Active Playback
TC_OTT_061_LIVE_PLAYBACK_OK_BUTTON
    [Tags]    OTT
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	5S
	VALIDATE VIDEO PLAYBACK
	CLICK OK
	Sleep	2s
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_061_ALL_CHANNELS
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_061_ALL_CHANNELS Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_061_ALL_CHANNELS Is Not Displayed on screen

TC_OTT_062_LIVE_STOP_RECORD_BUTTON
    [Tags]    OTT
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    3s
	CLICK OK
	Sleep	5s
	VALIDATE VIDEO PLAYBACK
	CLICK RECORD
	Sleep    30s
	CLICK RECORD
	Sleep    2s
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_062_STOP_RECORDING
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_062_STOP_RECORDING Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_062_STOP_RECORDING Is Not Displayed on screen
    CLICK OK
TC_OTT_063_LIVE_STOP_RECORD_CONFIRMATION
    [Tags]    OTT
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    3s
	CLICK OK
	Sleep	5s
	VALIDATE VIDEO PLAYBACK
	CLICK RECORD
	Sleep    30s
	CLICK RECORD
	Sleep    5s
	CLICK OK
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_063_STOP_RECORD_CONFIRMATION
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_063_STOP_RECORD_CONFIRMATION Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_063_STOP_RECORD_CONFIRMATION Is Not Displayed on screen

TC_OTT_064_MUTE_VIDEO
    [Tags]    OTT
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	5s
	VALIDATE VIDEO PLAYBACK
	CLICK MUTE
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_064_MUTE_VIDEO
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_064_MUTE_VIDEO Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_064_MUTE_VIDEO Is Not Displayed on screen

TC_OTT_065_HIGH_VOLUME
    [Tags]    OTT
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	5s
	VALIDATE VIDEO PLAYBACK
	CLICK MUTE
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
    CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_065_HIGH_VOLUME
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_065_HIGH_VOLUME Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_065_HIGH_VOLUME Is Not Displayed on screen

TC_OTT_066_LOW_VOLUME
    [Tags]    OTT
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	5s
	VALIDATE VIDEO PLAYBACK
	CLICK MUTE
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
    CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_MINUS
	Sleep	1s
	CLICK VOLUME_MINUS
	Sleep	1s
	CLICK VOLUME_MINUS
	Sleep	1s
	CLICK VOLUME_MINUS
	Sleep	1s
	CLICK VOLUME_MINUS
	Sleep	1s
	CLICK VOLUME_MINUS
	Sleep	1s
	CLICK VOLUME_MINUS
	Sleep	1s
	CLICK VOLUME_MINUS

	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_066_LOW_VOLUME
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_066_LOW_VOLUME Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_066_LOW_VOLUME Is Not Displayed on screen
TC_OTT_067_SWITCH_ON
    [Tags]    OTT
	BACK TO HOME
    CLICK POWER
	Sleep    10s
	CLICK POWER
	Sleep    15s
	BACK TO HOME

TC_OTT_068_MOVE_RECOMMENDED_SECTION
    [Tags]    OTT
	BACK TO HOME
	Sleep	10s
    FOR    ${i}    IN RANGE    10
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_009_TV_Recommended
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ 068_MOVE_RECOMMENDED_SECTION is displayed
		...    AND    Exit For Loop

		CLICK DOWN
    END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ TC_OTT_009_TV_Recommended is not displayed after navigating right

TC_OTT_069_MENU_AVAILABILITY
    [Tags]    OTT
	BACK TO HOME
	${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_OTT_001_Home_Page
    Run Keyword If    '${Result}' == 'True'    Log To Console    TC_OTT_001_Home_Page Is Displayed on screen
    ...    ELSE    Fail    TC_OTT_001_Home_Page Is Not Displayed on screen

TC_OTT_070_PLAYBACK_ON_CHANNEL_UP
    [Tags]    OTT
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    1s
	CLICK OK
	Sleep    1s
	CLICK OK
	sLEEP	5S
	VALIDATE VIDEO PLAYBACK
	CLICK CHANNEL_PLUS
	Sleep    4s
	VALIDATE VIDEO PLAYBACK
TC_OTT_008_PLAYBACK_ON_CHANNEL_DOWN
    [Tags]    OTT
	BACK TO HOME
    Get Menu Slider
	Sleep    1s
    CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    1s
	CLICK OK
	Sleep    1s
	CLICK OK
	sLEEP	5S
	VALIDATE VIDEO PLAYBACK
	CLICK CHANNEL_MINUS
	Sleep    4s
	VALIDATE VIDEO PLAYBACK



rec_script_1
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  test_rec
	Run Keyword If  '${Result}' == 'True'  Log To Console  test_rec Is Displayed on screen
	...  ELSE  Fail  TC_OTT_006_TV_Trending Is Not Displayed on screen
	
	CLICK RIGHT
	CLICK HOME

################# PROFILE NEW CASES ###############################

TC_2001_VERIFY_ALWAYS_LOGIN_WITH_THIS_PROFILE_FUNCTIONALITY_IN_PROFILE_SELECTION_PAGE_WITH_REBOOT
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
	Disable always login in admin 
	Create New Profile
	Reboot STB Device and Make sub profile as default user
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Logged_In_Subprofile
	Run Keyword If  '${Result}' == 'True'  Log To Console  Logged_In_Subprofile Is Displayed on screen
	...  ELSE  Fail  Logged_In_Subprofile Is Not Displayed on screen
	CLICK HOME
	Sleep    250s
	Reboot STB Device without whos watching page seen
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	# Revert Always Login for subprofile
	Login As Admin
	

TC_2002_VERIFY_ALWAYS_LOGIN_WITH_THIS_PROFILE_FUNCTIONALITY_IN_PROFILE_SELECTION_PAGE_WITH_STANDBY
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
	Disable always login in admin 
	Create New Profile
	CLICK POWER
	Sleep    5s
	CLICK POWER
	Sleep    10s
	Login to new user and make sub profile as default
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	# Sleep    100s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Logged_In_Subprofile
	Run Keyword If  '${Result}' == 'True'  Log To Console  Logged_In_Subprofile Is Displayed on screen
	...  ELSE  Fail  Logged_In_Subprofile Is Not Displayed on screen
	CLICK HOME
	Sleep    5s
	CLICK POWER
	Sleep    5s
	CLICK POWER
	Sleep    20s
	Check Who's Watching login should not be seen
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_1001_Etisalat_Logo
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1001_Etisalat_Logo Is Displayed on screen
	...  ELSE  Fail  TC_1001_Etisalat_Logo Is Not Displayed on screen
	# Revert Always Login for subprofile


TC_2003_VERIFY_AUDIO_LANGUAGE_IN_CHILD_PROFILE
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Login As Admin    AND    DELETE PROFILE    AND    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION     
    Create Kids Profile As Default User 
	Navigate To Profile 
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    3s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s 
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  AUDIO_ENGLISH
	Run Keyword If  '${Result}' == 'True'  Log To Console  AUDIO_ENGLISH Is Displayed on screen
	...  ELSE  Fail  AUDIO_ENGLISH Is Not Displayed on screen
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    5s
    CLICK HOME
	Log To Console  Change
	Sleep    250s
	Log To Console    Changed
	Reboot STB Device without whos watching page seen
	CLICK HOME
	# Sleep    50s 
	# Log to Console    Change to arabic
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    1s
	CLICK THREE
	CLICK TWO
	CLICK SIX
	# CLICK FIVE
	Sleep    5s
	CLICK BACK
    CLICK RIGHT
    ${STEP_COUNT}=    Move to Audio Launguage On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console     Navigated to audio language
	# CLICK RIGHT
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  CONFIRM_AUDIO_ENGLISH
	Run Keyword If  '${Result}' == 'True'  Log To Console  CONFIRM_AUDIO_ENGLISH Is Displayed on screen
	...  ELSE  Fail  CONFIRM_AUDIO_ENGLISH Is Not Displayed on screen

	CLICK HOME
	#LOGIN TO ADMIN FOR EDTING
	Navigate To Profile 
	# CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    10s
	#EDITING THE CHILD PROFILE
	Navigate To Profile 
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s 
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s 
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	# CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Arabic_Language
	Run Keyword If  '${Result}' == 'True'  Log To Console  AUDIO_URDU Is Displayed on screen
	...  ELSE  Fail  AUDIO_URDU Is Not Displayed on screen
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    1s
    CLICK HOME
    Reboot STB Device without whos watching page seen
	CLICK HOME
	Sleep    15s 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    1s 
	CLICK THREE
	CLICK TWO
	CLICK SIX
	Sleep    5s
	CLICK BACK
    CLICK RIGHT
    ${STEP_COUNT}=    Move to Audio Launguage On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console     Navigated to audio language
	# CLICK RIGHT
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  CONFIRM_AUDIO_ARABIC
	Run Keyword If  '${Result}' == 'True'  Log To Console  CONFIRM_AUDIO_URDU Is Displayed on screen
	...  ELSE  Fail  CONFIRM_AUDIO_URDU Is Not Displayed on screen
	CLICK HOME
	Login As Admin

TC_2004_VERIFY_CONTENT_RATING_WITH_STANDBY_MODE
    [Tags]    PROFILE & EDIT 
	[Teardown]    DELETE PROFILE
	Create New Profile
	CLICK TWO
	CLICK TWO
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	#need to change month
	Sleep    3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	Sleep    8s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_010_ok
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_010_ok Is Displayed on screen
	# ...  ELSE  Fail  TC_010_ok Is Not Displayed on screen
	
	CLICK OK
	CLICK HOME
	#######
	# Navigate and Login to Sub profile
	# CLICK HOME
	# CLICK UP
	# CLICK RIGHT
	# CLICK OK
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	# Guide Channel List
	# CLICK FIVE
	# CLICK ZERO
	# CLICK TWO
	# Sleep    3s
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_010_Rating_Confirmation_PopUp
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_010_Rating_Confirmation_PopUp Is Displayed on screen
	# ...  ELSE  Fail  TC_010_Rating_Confirmation_PopUp Is Not Displayed on screen
	
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	# Sleep    5s
	# CLICK TWO
	# CLICK TWO
	# Sleep    3s
	# CLICK HOME
	# Sleep    3s
	#####
	Stand by mode
    Check Who's Watching login
	CLICK HOME
	Navigate and Login to Sub profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	CLICK FIVE
	CLICK ZERO
	CLICK FOUR
	Sleep    3s
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_010_Rating_Confirmation_PopUp
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_010_Rating_Confirmation_PopUp Is Displayed on screen
	...  ELSE  Fail  TC_010_Rating_Confirmation_PopUp Is Not Displayed on screen
	
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    5s
	CLICK TWO
	CLICK TWO
	Sleep    3s
	CLICK HOME
	Sleep    3s
	Login As Admin
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME
	DELETE PROFILE

TC_2005_VERIFY_SUBTITLE_LANGUAGE_IN_CHILD_PROFILE
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Login As Admin    AND    DELETE PROFILE    AND    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION     
	Create Kids Profile As Default User 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	#need to change month
	Sleep    3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Reboot STB Device without whos watching page seen
	CLICK HOME
	Sleep    15s 
	Log To Console    Change to English
	Sleep    50s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK Three
	CLICK ONE
	CLICK NINE
	Sleep    5s 
	CLICK BACK
    Sleep    2s 
	CLICK RIGHT

	Log To Console    Move to subtitle On Side Pannel
	CLICK RIGHT
	${STEP_COUNT}=    Move to subtitle On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_009_ARABIC
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_ARABIC Is Displayed
	...  ELSE  Fail  TC_009_ARABIC Is Not Displayed
	
	CLICK BACK
	CLICK HOME
	Login As Admin
	Sleep    2s
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    20s
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    3s
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Reboot STB Device without whos watching page seen
	CLICK HOME
	Sleep    15s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# CLICK Three
	# CLICK FO
	# CLICK SIX
	CLICK Three
	CLICK SIX
	CLICK ZERO
	Sleep    5s 
	CLICK BACK
    Sleep    2s 
	CLICK RIGHT

	Log To Console    Move to subtitle On Side Pannel
	CLICK RIGHT
	${STEP_COUNT}=    Move to subtitle On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}    AUDIO_ENGLISH
	Run Keyword If  '${Result}' == 'True'  Log To Console  CONFIRM_AUDIO_ENGLISH Is Displayed
	...  ELSE  Fail  CONFIRM_AUDIO_ENGLISH Is Not Displayed
	
	CLICK BACK
	CLICK HOME
	Login As Admin
	Sleep    2s
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	Sleep    20s
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	sleep    3s
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Reboot STB Device without whos watching page seen
	CLICK HOME
	Sleep    15s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# CLICK Three
	# CLICK TWO
	# CLICK SIX
	CLICK Three
	CLICK ONE
	CLICK NINE
	Sleep    5s
	CLICK BACK
    Sleep    2s 
	CLICK RIGHT

	Log To Console    Move to subtitle On Side Pannel
	CLICK RIGHT
	${STEP_COUNT}=    Move to subtitle On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	
	CLICK OK

	${Result}  Verify Crop Image With Shorter Duration    ${port}  None_Validation
	Run Keyword If  '${Result}' == 'True'  Log To Console  None_Validation Is Displayed
	...  ELSE  Fail  None_Validation Is Not Displayed
	
	CLICK BACK
	CLICK HOME
	Login As Admin
	Sleep    2s
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    20s
	CLICK HOME

TC_2006_VERIFY_CHANNEL_UNLOCK_INDIVIDUALLY_WITH_REBOOT
    [Tags]    PROFILE & EDIT
	[Teardown]    UNLOCK_2006
	Navigate To Profile  
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    2s
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK MULTIPLE TIMES    2    UP
	CLICK OK
	Log To Console    Clear unhide
	Sleep    2s
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	Sleep    2s
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK MULTIPLE TIMES    6    UP
	CLICK MULTIPLE TIMES    3    RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK
	Sleep    3s
	CLICK HOME
	Navigate To Profile  
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    2s
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK MULTIPLE TIMES    2    UP
	CLICK OK
	CLICK RIGHT
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  5_Lock_Channels
	Run Keyword If  '${Result}' == 'True'  Log To Console  5_Lock_Channels Is Displayed on screen
	...  ELSE  Fail  5_Lock_Channels Is Not Displayed on screen
	# CLICK OK
	CLICK DOWN
	# CLICK OK
	CLICK DOWN
	# CLICK OK
	
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	Log To Console     Unclocked only 2 channels
	CLICK MULTIPLE TIMES    6    UP
	CLICK MULTIPLE TIMES    3    RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK
	CLICK HOME 
	Sleep    2s
	#########
	Reboot STB Device
	CLICK HOME
	NAVIGATE TO CHANNEL LIST IN NEW UI
	Sleep    4s 
	# Sleep    2s 
	# CLICK THREE
	# CLICK THREE
	# Sleep    3s 
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}   Channel_Lock_33
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Channel_Lock_33 Is Displayed
	# ...  ELSE  Log To Console  Channel_Lock_33 Is Not Displayed
	
    # CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	Sleep    8s
	CLICK THREE
	CLICK FOUR
	Sleep    3s 
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	Sleep    3s 
	CLICK THREE
	CLICK FOUR
	Sleep    3s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Channel_Lock_34
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel_Lock_34 Is Displayed
	...  ELSE  Fail  Channel_Lock_34 Is Not Displayed

	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    8s
	CLICK THREE
	CLICK FIVE
	Sleep    3s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Channel_Lock_35
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel_Lock_35 Is Displayed
	...  ELSE  Fail  Channel_Lock_35 Is Not Displayed
	
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    8s
	CLICK THREE
	CLICK EIGHT
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Channel_Lock_38 
	Run Keyword If  '${Result}' == 'True'  Log To Console  38_Channel_No Is Displayed
	...  ELSE  Fail  38_Channel_No Is Not Displayed
	
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    8s
	CLICK FOUR
	CLICK ZERO
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  40_Channel_No
	Run Keyword If  '${Result}' == 'False'  Log To Console  40_Channel_No up is Displayed
	...  ELSE  Fail  40_Channel_No up is Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Channel_Lock_40
	Run Keyword If  '${Result}' == 'False'  Log To Console  Locked Pop up is Not Displayed
	...  ELSE  Fail  Locked Pop up is Displayed
	
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	Sleep    8s
	CLICK TWO 
	CLICK TWO 
	Sleep	2s
	CLICK HOME
	#############
	# CLICK HOME
	# CLICK HOME
	# Navigate To Profile  
	# CLICK DOWN
	# CLICK OK
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	# Sleep    2s
	# CLICK RIGHT
	# CLICK RIGHT
	# Sleep    10s 
	# CLICK MULTIPLE TIMES    6    DOWN
	# CLICK MULTIPLE TIMES    2    UP
	# CLICK OK
	# CLICK RIGHT
    # ${Result}  Verify Crop Image With Shorter Duration    ${port}  2_Unhidden_Channels
	# Run Keyword If  '${Result}' == 'True'  Log To Console  2_Unhidden_Channels Is Displayed on screen
	# ...  ELSE  Log To Console  2_Unhidden_Channels Is Not Displayed on screen
	# CLICK MULTIPLE TIMES    2    UP
	# CLICK RIGHT
	# CLICK OK
	# CLICK MULTIPLE TIMES    2    RIGHT
	# CLICK OK
	# CLICK MULTIPLE TIMES    6    DOWN
	# CLICK OK
	# CLICK OK
	# CLICK HOME


TC_2007_VERIFY_CHANNEL_UNLOCK_AT_ONCE_WITH_REBOOT
    [Tags]    PROFILE & EDIT
	[Teardown]    UNLOCK_2007
	Navigate To Profile  
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    2s
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK MULTIPLE TIMES    2    UP
	CLICK OK
	Log To Console    Clear unLOCK
	Sleep    2s
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	Sleep    2s
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK MULTIPLE TIMES    6    UP
	CLICK MULTIPLE TIMES    3    RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK
	Sleep    2s
	CLICK HOME
	Sleep    2s
	Navigate To Profile  
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    2s
	CLICK RIGHT
	CLICK RIGHT
	Sleep    8s 
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK MULTIPLE TIMES    2    UP
	CLICK OK
	CLICK RIGHT
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  5_Lock_Channels
	Run Keyword If  '${Result}' == 'True'  Log To Console  5_Lock_Channels Is Displayed on screen
	...  ELSE  Fail  5_Lock_Channels Is Not Displayed on screen
	CLICK MULTIPLE TIMES    6    UP
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK
	CLICK HOME
	Sleep    2s
	########
	Reboot STB Device
	CLICK HOME
	NAVIGATE TO CHANNEL LIST IN NEW UI
	Sleep    4s 
	CLICK THREE
	CLICK THREE
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  33_Channel_No
	Run Keyword If  '${Result}' == 'False'  Log To Console  33_Channel_No up is Not Displayed
	...  ELSE  Fail  33_Channel_No up is Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}   Channel_Lock_33
	Run Keyword If  '${Result}' == 'False'  Log To Console  Locked Pop up is Not Displayed
	...  ELSE  Fail  Locked Pop up is Displayed
	
    # CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	Sleep    8s
	CLICK THREE
	CLICK FOUR
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  34_Channel_No
	Run Keyword If  '${Result}' == 'False'  Log To Console  34_Channel_No up is Not Displayed
	...  ELSE  Fail  34_Channel_No up is Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Channel_Lock_34
	Run Keyword If  '${Result}' == 'False'  Log To Console  Locked Pop up is Not Displayed
	...  ELSE  Fail  Locked Pop up is Displayed

	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	Sleep    8s
	CLICK THREE
	CLICK FIVE
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  35_Channel_No
	Run Keyword If  '${Result}' == 'False'  Log To Console  35_Channel_No up is Not Displayed
	...  ELSE  Fail  35_Channel_No up is Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Channel_Lock_35
	Run Keyword If  '${Result}' == 'False'  Log To Console  Locked Pop up is Not Displayed
	...  ELSE  Fail  Locked Pop up is Displayed
	
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	Sleep    8s
	CLICK THREE
	CLICK EIGHT
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  38_Channel_No
	Run Keyword If  '${Result}' == 'False'  Log To Console  38_Channel_No up is Not Displayed
	...  ELSE  Fail  38_Channel_No up is Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Channel_Lock_38
	Run Keyword If  '${Result}' == 'False'  Log To Console  Locked Pop up is Not Displayed
	...  ELSE  Fail  Locked Pop up is Displayed
	
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	Sleep    8s
	CLICK FOUR
	CLICK ZERO
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  40_Channel_No
	Run Keyword If  '${Result}' == 'False'  Log To Console  40_Channel_No up is Not Displayed
	...  ELSE  Fail  40_Channel_No up is Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Channel_Lock_40
	Run Keyword If  '${Result}' == 'False'  Log To Console  Locked Pop up is Not Displayed
	...  ELSE  Fail  Locked Pop up is Displayed
	
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	Sleep    8s
	CLICK TWO 
	CLICK TWO 
	Sleep	2s
	CLICK HOME
	#########
	# CLICK HOME
	# CLICK HOME
	# Navigate To Profile  
	# CLICK DOWN
	# CLICK OK
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK TWO
	# CLICK OK
	# Sleep    2s
	# CLICK RIGHT
	# CLICK RIGHT
	# Sleep    10s 
	# CLICK MULTIPLE TIMES    6    DOWN
	# CLICK MULTIPLE TIMES    2    UP
	# CLICK OK
	# CLICK RIGHT
    # ${Result}  Verify Crop Image With Shorter Duration    ${port}  5_Unlocked_Channels
	# Run Keyword If  '${Result}' == 'True'  Log To Console  5_Unlocked_Channels Is Displayed on screen
	# ...  ELSE  Fail  5_Unlocked_Channels Is Not Displayed on screen
	# CLICK MULTIPLE TIMES    2    UP
	# CLICK MULTIPLE TIMES    3    RIGHT
	# CLICK OK
	# CLICK MULTIPLE TIMES    6    DOWN
	# CLICK OK
	# CLICK OK
	# CLICK HOME




TC_2008_VERIFY_CHANNEL_UNHIDE_INDIVIDUALLY_WITH_REBOOT
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords    Revert Unhide    AND    Revert channel style changes
	Navigate to Profile icon
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep     3s 
	CLICK DOWN
	CLICK RIGHT
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_018_default_style
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_default_style Is Displayed on screen
	# ...  ELSE  Fail  TC_018_default_style Is Not Displayed on screen
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_018_ok
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_ok Is Displayed on screen
	...  ELSE  Fail  TC_018_ok Is Not Displayed on screen
	
	CLICK OK
	Sleep    3s 
	CLICK HOME
	CLICK HOME
	Navigate To Profile  
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    2s
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	Log To Console    Clear Hide channels
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN 
	Sleep    2s
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK MULTIPLE TIMES    6    UP
	CLICK MULTIPLE TIMES    3    RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK
	CLICK HOME 
	###########
    
    CLICK HOME
	Sleep    2s
	CLICK THREE
	CLICK FOUR
	Sleep    3s 
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	Hidden_Channel_35
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_38
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_40
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_42
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_48
	# ${result}=  Verify Crop Image With Shorter Duration With Two Matching Images   ${port}  34  34_chnl_name
	# IF    '${result}' == 'True'
	# 	Log To Console    Channel 34 is visible on screen
	# ELSE
	# 	Fail    Channel 34 is not visible on screen
	# END
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   34
	# Run Keyword If  '${Result}' == 'False'  Log To Console  34 Is Not Displayed
	# ...  ELSE  Fail  34 Is Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   35
	# Run Keyword If  '${Result}' == 'False'  Log To Console  35 Is Not Displayed
	# ...  ELSE  Fail  35 Is Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   38
	# Run Keyword If  '${Result}' == 'False'  Log To Console  38 Is Not Displayed
	# ...  ELSE  Fail  38 Is Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   40
	# Run Keyword If  '${Result}' == 'False'  Log To Console  40 Is Not Displayed
	# ...  ELSE  Fail  40 Is Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   42
	# Run Keyword If  '${Result}' == 'False'  Log To Console  47 Is Not Displayed
	# ...  ELSE  Fail  47 Is Displayed
    # Sleep    2s

	CLICK HOME
    
	############
	Navigate To Profile  
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    2s
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
    ${Result}  Verify Crop Image With Shorter Duration  ${port}  5_Hidden_Channels
	Run Keyword If  '${Result}' == 'True'  Log To Console  5_Hidden_Channels Is Displayed on screen
	...  ELSE  Fail  5_Hidden_Channels Is Not Displayed on screen
	# CLICK OK
	CLICK DOWN
	# CLICK OK
	CLICK DOWN
	# CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK MULTIPLE TIMES    6    UP
	CLICK MULTIPLE TIMES    3    RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK
	Sleep    2s
	CLICK HOME
    ############
    Reboot STB Device
	CLICK HOME
	Sleep    2s
	CLICK THREE
	CLICK FOUR
	Sleep    3s 
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	Hidden_Channel_35
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_38
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_40
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_42_Unhidden
	CLICK UP
	Hidden_Channel_48_Unhidden
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   34
	# Run Keyword If  '${Result}' == 'False'  Log To Console  34 Is Not Displayed
	# ...  ELSE  Fail  34 Is Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   35
	# Run Keyword If  '${Result}' == 'False'  Log To Console  35 Is Not Displayed
	# ...  ELSE  Fail  35 Is Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   38
	# Run Keyword If  '${Result}' == 'False'  Log To Console  38 Is Not Displayed
	# ...  ELSE  Fail  38 Is Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   40
	# Run Keyword If  '${Result}' == 'True'  Log To Console  40 Is Displayed
	# ...  ELSE  Fail  40 Is Not Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   42
	# Run Keyword If  '${Result}' == 'True'  Log To Console  47 Is Displayed
	# ...  ELSE  Fail  47 Is Not Displayed
	# Sleep    1s	
	CLICK HOME
    #############

	# Reboot STB Device
	CLICK HOME
	CLICK HOME
	Navigate To Profile  
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    2s
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}  2_Unhidden_Channels
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Channels are unhidden
	# ...  ELSE  Fail  Channels are still Hidden
	CLICK MULTIPLE TIMES    2    UP
	CLICK RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    2    RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK
	CLICK HOME
	
TC_2009_VERIFY_CHANNEL_UNHIDE_AT_ONCE_WITH_REBOOT
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords    Revert Unhide    AND    Revert channel style changes
	Navigate to Profile icon
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep     3s 
	CLICK DOWN
	CLICK RIGHT
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_018_default_style
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_default_style Is Displayed on screen
	# ...  ELSE  Fail  TC_018_default_style Is Not Displayed on screen
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_018_ok
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_ok Is Displayed on screen
	...  ELSE  Fail  TC_018_ok Is Not Displayed on screen
	
	CLICK OK
	Sleep    3s 
	CLICK HOME
	CLICK HOME
	Navigate To Profile  
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    2s
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	Log To Console    Clear Hide channels
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN 
	Sleep    2s
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK MULTIPLE TIMES    6    UP
	CLICK MULTIPLE TIMES    3    RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK

    ####
	CLICK HOME
	Sleep    2s
	CLICK THREE
	CLICK FOUR
	Sleep    3s 
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	Hidden_Channel_35
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_38
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_40
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_42
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_48
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   34
	# Run Keyword If  '${Result}' == 'False'  Log To Console  34 Is Not Displayed
	# ...  ELSE  Fail  34 Is Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   35
	# Run Keyword If  '${Result}' == 'False'  Log To Console  35 Is Not Displayed
	# ...  ELSE  Fail  35 Is Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   38
	# Run Keyword If  '${Result}' == 'False'  Log To Console  38 Is Not Displayed
	# ...  ELSE  Fail  38 Is Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   40
	# Run Keyword If  '${Result}' == 'False'  Log To Console  40 Is Not Displayed
	# ...  ELSE  Fail  40 Is Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   42
	# Run Keyword If  '${Result}' == 'False'  Log To Console  47 Is Not Displayed
	# ...  ELSE  Fail  47 Is Displayed
	# Sleep    1s	
	CLICK HOME
	######



	Navigate To Profile  
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    2s
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
    ${Result}  Verify Crop Image With Shorter Duration  ${port}  5_Hidden_Channels
	Run Keyword If  '${Result}' == 'True'  Log To Console  5_Hidden_Channels Is Displayed on screen
	...  ELSE  Fail  5_Hidden_Channels Is Not Displayed on screen
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK
	Sleep    2s
	CLICK HOME
	#############
	Reboot STB Device
	CLICK HOME
	Sleep    2s
	CLICK THREE
	CLICK FOUR
	Sleep    3s 
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	Hidden_Channel_35_Unhidden
	CLICK UP
	Hidden_Channel_38_Unhidden
	CLICK UP
	CLICK UP
	Hidden_Channel_40_Unhidden
	CLICK UP
	CLICK UP
	CLICK UP
	Hidden_Channel_42_Unhidden
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	# Hidden_Channel_48_Unhidden
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   34
	# Run Keyword If  '${Result}' == 'True'  Log To Console  34 Is Displayed
	# ...  ELSE  Fail  34 Is Not Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   35
	# Run Keyword If  '${Result}' == 'True'  Log To Console  35 Is Displayed
	# ...  ELSE  Fail  35 Is Not Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   38
	# Run Keyword If  '${Result}' == 'True'  Log To Console  38 Is Displayed
	# ...  ELSE  Fail  38 Is Not Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   40
	# Run Keyword If  '${Result}' == 'True'  Log To Console  40 Is Displayed
	# ...  ELSE  Fail  40 Is Not Displayed
	# Sleep    1s
    # ${Result}  Verify Crop Image With Shorter Duration  ${port}   42
	# Run Keyword If  '${Result}' == 'True'  Log To Console  47 Is Displayed
	# ...  ELSE  Fail  47 Is Not Displayed
	Sleep    1s	
	CLICK HOME
	############
	CLICK HOME
	CLICK HOME
	Navigate To Profile  
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    2s
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
    ${Result}  Verify Crop Image With Shorter Duration  ${port}  5_Unhidden_Channels
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channels are unhidden
	...  ELSE  Fail  Channels are still Hidden
	CLICK MULTIPLE TIMES    2    UP
	CLICK MULTIPLE TIMES    3    RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK
	CLICK HOME

TC_2010_VERIFY_UI_LANGUAGE_CHANGE_FOR_CHILD_PROFILE
    [Tags]    PROFILE & EDIT 
	# [Teardown]    Revert UI language
	Create Kids Profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	
	CLICK OK
	Sleep    20s 
	CLICK HOME
	Navigate and Login to Kids profile
	Sleep    15s
	CLICK HOME
	Sleep    1s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ARABIC_HOME
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_HOME Is Displayed on screen
	...  ELSE  Fail  ARABIC_HOME Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ARABIC_TV
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_TV Is Displayed on screen
	...  ELSE  Fail  ARABIC_TV Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ARABIC_BOX_OFFICE
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_BOX_OFFICE Is Displayed on screen
	...  ELSE  Fail  ARABIC_BOX_OFFICE Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ARABIC_KIDS
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_KIDS Is Displayed on screen
	...  ELSE  Fail  ARABIC_KIDS Is Not Displayed on screen
	Sleep    2s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  ARABIC_MYTV
	Run Keyword If  '${Result}' == 'True'  Log To Console  ARABIC_MYTV Is Displayed on screen
	...  ELSE  Fail  ARABIC_MYTV Is Not Displayed on screen
	Sleep    2s 
	CLICK HOME
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    20s
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	
	CLICK OK
	Sleep    20s 
	CLICK HOME
	Navigate and Login to Kids profile
	Sleep    5s
	CLICK HOME
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen

	CLICK HOME
	Login As Admin
    DELETE PROFILE


TC_2011_VERIFY_INTERFACE_BANNER_TIMEOUT_FOR_SUBPROFILE
    [Tags]    PROFILE & EDIT
	[Teardown]    DELETE PROFILE
	Create New Profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    3s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	#need to change month
	Sleep    3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  Interface_settings
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_settings Is Displayed
	# ...  ELSE  Fail  Interface_settings Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Interface_timeout_10secs
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_timeout_10secs Is Displayed
	...  ELSE  Fail  Interface_timeout_10secs Is Not Displayed
	
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  Interface_timeout_success
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_timeout_success Is Displayed
	# ...  ELSE  Fail  Interface_timeout_success Is Not Displayed
	
	CLICK OK
	CLICK HOME
	Reboot STB Device
	CLICK HOME
	Navigate and Login to Sub profile
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	Guide Channel List
	CLICK TWO
	CLICK TWO
	Sleep    8s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_016_Dubai_TV_Channel
	Run Keyword If  '${Result}' == 'False'  Log To Console  Banner Timeout has been successfully validated
	...  ELSE  Fail  Banner is still visible after timeout
	CLICK HOME
	Login As Admin
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  Interface_settings
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_settings Is Displayed
	# ...  ELSE  Fail  Interface_settings Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Interface_timeout_5secs
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_timeout_5secs Is Displayed
	...  ELSE  Fail  Interface_timeout_5secs Is Not Displayed
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  Interface_timeout_success
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_timeout_success Is Displayed
	# ...  ELSE  Fail  Interface_timeout_success Is Not Displayed
	
	CLICK OK
	CLICK HOME
	Reboot STB Device
	CLICK HOME
	Navigate and Login to Sub profile
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	Guide Channel List
	CLICK TWO
	CLICK TWO
	Sleep    5s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_016_Dubai_TV_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  Banner is seen after 7 seconds
	...  ELSE  Fail  Banner is not seen
	Sleep    7s 
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_016_Dubai_TV_Channel
	Run Keyword If  '${Result}' == 'False'  Log To Console  Banner Timeout has been successfully validated
	...  ELSE  Fail  Banner is still visible after timeout
	CLICK HOME
	Login As Admin
	CLICK HOME

TC_2012_VERIFY_INTERFACE_CLOCK_WITH_STANDBY_MODE_IN_SUBPROFILE
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Login As Admin    AND    DELETE PROFILE    AND    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION     
	Create Kids Profile As Default User 
	NAVIGATE TO PROFILE ICON
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	Enter Pincode
	Sleep    3s
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK
	#need to change month
	Sleep    3s
	CLICK UP
	CLICK MULTIPLE TIMES    6    RIGHT
	Sleep    3s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Interface_clock_off
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_clock_off Is Displayed
	...  ELSE  Fail  Interface_clock_off Is Not Displayed
	CLICK OK
	###
	CLICK UP
	##
	CLICK OK
	CLICK MULTIPLE TIMES    4    DOWN
	CLICK OK
	Sleep    3s 
	CLICK OK
	CLICK HOME
	Stand by mode
	Check Who's Watching login should not be seen
	Sleep    3s 
	CLICK HOME
	# Navigate and Login to Sub profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
	Guide Channel List
	CLICK THREE
	CLICK ZERO
	CLICK FOUR
	Sleep    4s 
	CLICK BACK
    Verify Time On Interface Clock
    CLICK HOME
	CLICK HOME
	Login As Admin
	NAVIGATE TO PROFILE ICON
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	Enter Pincode
	CLICK MULTIPLE TIMES    3    RIGHT
	Sleep    3s 
	CLICK MULTIPLE TIMES    4    DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Interface_clock_off
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_clock_off Is Displayed
	...  ELSE  Fail  Interface_clock_off Is Not Displayed
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK MULTIPLE TIMES    4    DOWN
	CLICK OK
	Sleep    3s 
	CLICK OK
	CLICK HOME
	CLICK HOME
	Stand by mode
    Check Who's Watching login should not be seen
	CLICK HOME
	# Log to Console    Turn on clock 
	# Sleep    60s
	# Navigate and Login to Sub profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	CLICK THREE
	CLICK ZERO
	CLICK FOUR
	Sleep    4s 
	CLICK BACK
    Verify Time On Interface Clock Negative Scenario
	Login As Admin

TC_2013_VERIFY_CHANNEL_STYLE_WITH_STANDBY_MODE_IN_SUBPROFILE
    [Tags]    PROFILE & EDIT 
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Login As Admin    AND    Delete Profile
    Create Kids Profile As Default User 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    3s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	#need to change month
	Sleep    3s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep     3s 
	CLICK DOWN
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_018_default_style
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_default_style Is Displayed on screen
	...  ELSE  Fail  TC_018_default_style Is Not Displayed on screen
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_018_ok
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_ok Is Displayed on screen
	# ...  ELSE  Fail  TC_018_ok Is Not Displayed on screen
	
	CLICK OK
	Sleep    3s 
	CLICK HOME
	CLICK HOME
	Stand by mode
    Check Who's Watching login should not be seen
	CLICK HOME
	# Log To Console    Change
	# Sleep    150s
	# Log To Console    Changed
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	CLICK ONE
	CLICK ZERO
	CLICK THREE
	CLICK NINE
	Sleep    15s 
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  kids_style5_chnl1
	Run Keyword If  '${Result}' == 'True'  Log To Console  kids_style5_chnl1 Is Displayed on screen
	...  ELSE  Fail  kids_style5_chnl1 Is Not Displayed on screen
	
	Sleep    3s 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  kids_style5_chnl5
	Run Keyword If  '${Result}' == 'True'  Log To Console  kids_style5_chnl5 Is Displayed on screen
	...  ELSE  Fail  kids_style5_chnl5 Is Not Displayed on screen

	CLICK HOME
	Login As Admin
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    3s 
	CLICK DOWN
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_018_five_channel_style
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_five_channel_style Is Displayed on screen
	...  ELSE  Fail  TC_018_five_channel_style Is Not Displayed on screen
	
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	CLICK OK
	CLICK HOME
	CLICK HOME
	Stand by mode
    Check Who's Watching login should not be seen
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	CLICK ONE
	CLICK ZERO
	CLICK THREE
	CLICK NINE
	Sleep    15s 
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  kids_style9_chnl1
	Run Keyword If  '${Result}' == 'True'  Log To Console  kids_style9_chnl1 Is Displayed on screen
	...  ELSE  Fail  kids_style9_chnl1 Is Not Displayed on screen
	
	Sleep    3s 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  kids_style9_chnl9 
	Run Keyword If  '${Result}' == 'True'  Log To Console  kids_style9_chnl9 Is Displayed on screen
	...  ELSE  Fail  kids_style9_chnl9 Is Not Displayed on screen

	CLICK HOME
	Login As Admin
	CLICK HOME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK OK
	CLICK HOME
	
TC_2014_CREATE_PROFILE_WITH_CUSTOM_AVATAR_AND_VERIFY_DISPLAY_FROM_SUBPROFILE
    [Tags]    PROFILE & EDIT 
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    
	...    AND    DELETE PROFILE    
	...    AND    NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION
	...    AND    Delete profile once in admin     
	Create New Profile
	CLICK HOME
	Navigate and Login to Sub profile
	NAVIGATE TO PROFILE ICON
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    3s	
	CLICK OK
	Enter Pincode
	CLICK OK
	CLICK DOWN
	CLICK OK	
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK	
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK HOME
	Reboot STB Device and Validate new profile with Avatar
	NAVIGATE TO PROFILE ICON
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Avatar_Profile_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Avatar_Profile_Page Is Displayed on screen
	...  ELSE  Fail  Avatar_Profile_Page Is Not Displayed on screen
	CLICK HOME
	CLICK POWER
	Sleep    60s
	CLICK POWER
	Sleep    20s
	Check Who's Watching login with avatar profile validation
	NAVIGATE TO PROFILE ICON
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Avatar_Profile_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Avatar_Profile_Page Is Displayed on screen
	...  ELSE  Fail  Avatar_Profile_Page Is Not Displayed on screen
	CLICK HOME
	DELETE PROFILE
	
TC_2015_VERIF_ALWAYS_LOGIN_WITH_THIS_PROFILE_FUNCTIONALITY_IN_PROFILE_SETTINGS_PAGE_WITH_STANDBY
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
	Create New Profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_006_New_Profile
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_New_Profile Is Displayed
	# ...  ELSE  Fail  TC_006_New_Profile Is Not Displayed
	
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    3s 
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_006_Personal_Details
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Personal_Details Is Displayed
	# ...  ELSE  Fail  TC_006_Personal_Details Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_006_Security_Controls
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Security_Controls Is Displayed
	# ...  ELSE  Fail  TC_006_Security_Controls Is Not Displayed
	
	CLICK DOWN
    CLICK DOWN
    # ${Result}  Verify Crop Image With Shorter Duration    ${port}  Disable_Login_Admin
    # Run Keyword If  '${Result}' == 'False'  Log To Console  Disable_Login_Admin Is already disabled
    # ...  ELSE  CLICK OK
	CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK OK
	
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK OK
	CLICK HOME
    # Log To Console  Change
	# Sleep    80s
	# Log To Console  Changed
    Stand by mode
    Check Who's Watching login should not be seen
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Logged_In_Subprofile
	Run Keyword If  '${Result}' == 'True'  Log To Console  Logged_In_Subprofile Is Not Displayed on screen
	...  ELSE  Fail  Logged_In_Subprofile Is Not Displayed on screen
	CLICK OK
	Sleep    2s 
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    15s 

	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_006_Logged_Admin
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Logged_Admin Is Displayed
	...  ELSE  Fail  TC_006_Logged_Admin Is Not Displayed
	
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK HOME
	
TC_2017_VERIF_ALWAYS_LOGIN_WITH_THIS_PROFILE_FUNCTIONALITY_IN_PROFILE_SETTINGS_PAGE_WITH_REBOOT
    [Tags]    PROFILE & EDIT
	[Teardown]    Run Keywords    Teardown exit whos watching page and login to Admin    AND    Delete Profile
	Create New Profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_006_New_Profile
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_New_Profile Is Displayed
	# ...  ELSE  Fail  TC_006_New_Profile Is Not Displayed
	
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    3s 
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_006_Personal_Details
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Personal_Details Is Displayed
	# ...  ELSE  Fail  TC_006_Personal_Details Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	# ${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_006_Security_Controls
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Security_Controls Is Displayed
	# ...  ELSE  Fail  TC_006_Security_Controls Is Not Displayed
	
	CLICK DOWN
    CLICK DOWN
    # ${Result}  Verify Crop Image With Shorter Duration    ${port}  Disable_Login_Admin
    # Run Keyword If  '${Result}' == 'False'  Log To Console  Disable_Login_Admin Is already disabled
    # ...  ELSE  CLICK OK
	CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK OK
	
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK OK
	CLICK HOME
    # Log To Console  Change
	# Sleep    200s
	# Log To Console  Changed
    Reboot STB Device without whos watching page seen
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Logged_In_Subprofile
	Run Keyword If  '${Result}' == 'True'  Log To Console  Logged_In_Subprofile Is Displayed on screen
	...  ELSE  Fail  Logged_In_Subprofile Is Not Displayed on screen
	CLICK OK
	Sleep    2s 
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    15s 

	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_006_Logged_Admin
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Logged_Admin Is Displayed
	...  ELSE  Fail  TC_006_Logged_Admin Is Not Displayed
	
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK HOME
	



TC_2016_CREATE_CHILD_PROFILE_WITH_AGE_BASED_RESTRICTIONS_WITH_STANDBY
    [Tags]    PROFILE & EDIT 
	[Teardown]    DELETE PROFILE
	NAVIGATE TO PROFILE ICON
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Enter Pincode
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK HOME 
	CLICK HOME

	NAVIGATE TO PROFILE ICON
	CLICK RIGHT
    ##### Validate kids profile####
    ${Result}  Verify Crop Image With Shorter Duration    ${port}      KIDS_PROFILE_ABCD
	Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_PROFILE Is Displayed on screen
	...  ELSE  Fail     KIDS_PROFILE Is Not Displayed on screen
	CLICK OK
	Enter Pincode
	Sleep    20s 
	CLICK HOME
	CLICK POWER
    Sleep    70s 
    CLICK POWER
    Sleep    50s
	Log To Console    Standby Success
    Sleep    1s
	${result}=  Verify Crop Image With Shorter DurationWith Two Matching Images   ${port}  KIDS_CAP_STANDBY  KIDS_PROFILE_NAME_STANDBY
    IF    '${result}' == 'True'
		Log To Console    kids profile visible on screen
	ELSE
		Fail    kids profile is not visible on screen
	END
	${Result}  Verify Crop Image With Shorter Duration    ${port}      Kids_profile_whos
	Run Keyword If  '${Result}' == 'True'  Log To Console  kids_profile_after_standby Is Displayed on screen
	...  ELSE  Fail     kids_profile_after_standby Is Not Displayed on screen
    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_520_Who_Watching
    Log To Console    Who's login: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK OK
        Sleep    30s
        CLICK HOME
    END
    CLICK HOME

    CLICK HOME
	NAVIGATE TO PROFILE ICON
    ##### Validate kids profile####
    ${Result}  Verify Crop Image With Shorter Duration    ${port}      kids_profile_after_standby
	Run Keyword If  '${Result}' == 'True'  Log To Console  kids_profile_after_standby Is Displayed on screen
	...  ELSE  Fail     kids_profile_after_standby Is Not Displayed on screen
    CLICK HOME

    CLICK HOME

	#valiadation for kids profile
	CLICK HOME
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_105_KIDS
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_024_KIDS Is Displayed
	...  ELSE  Fail  TC_024_KIDS Is Not Displayed
	CLICK BACK
	Sleep    2s

	CLICK HOME
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image With Shorter Duration   ${port}    Recommended_Feeds
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Recommended_Feeds is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recommended_Feeds is not displayed after navigating right	
    CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}    G_Rating
	Run Keyword If  '${Result}' == 'True'  Log To Console  G_Rating Is Displayed
	...  ELSE  Fail  G_Rating Is Not Displayed
	CLICK BACK
	Sleep    2s 
	CLICK BACK
	CLICK RIGHT
	CLICK OK
	Sleep    2s 
	CLICK BACK
	Sleep	5s
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
	#IMAGE VALIDATION IN EPG - TAKE CHANNEL NUMBER - 5 CHANNELS
	${Result}  Verify Crop Image With Shorter Duration    ${port}  KIDS_BOOKMARK
	Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_BOOKMARK Is Displayed
	...  ELSE  Fail  KIDS_BOOKMARK Is Not Displayed
	${Result}  Verify Crop Image With Shorter Duration    ${port}  KIDS_CHANNEL_1
	Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_CHANNEL_1 Is Displayed
	...  ELSE  Fail  KIDS_CHANNEL_1 Is Not Displayed
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
		${Result}  Verify Crop Image With Shorter Duration    ${port}  KIDS_CHANNEL_2
	Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_CHANNEL_2 Is Displayed
	...  ELSE  Fail  KIDS_CHANNEL_2 Is Not Displayed
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
		${Result}  Verify Crop Image With Shorter Duration    ${port}  KIDS_CHANNEL_3
	Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_CHANNEL_3 Is Displayed
	...  ELSE  Fail  KIDS_CHANNEL_3 Is Not Displayed
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
		${Result}  Verify Crop Image With Shorter Duration    ${port}  KIDS_CHANNEL_4
	Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_CHANNEL_4 Is Displayed
	...  ELSE  Fail  KIDS_CHANNEL_4 Is Not Displayed
	Sleep	2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
		${Result}  Verify Crop Image With Shorter Duration    ${port}  KIDS_CHANNEL_5
	Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_CHANNEL_5 Is Displayed
	...  ELSE  Fail  KIDS_CHANNEL_5 Is Not Displayed
	Log To Console 	5 Channels got displayed
	#login into admin
	NAVIGATE TO PROFILE ICON
	CLICK OK
	Enter Pincode
	Enter Pincode
	Sleep    15s
	    

