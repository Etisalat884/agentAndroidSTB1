*** Settings ***
Resource    /home/ltts/Documents/evqual_automation/agentLinuxSTB2/workspace/Lib/Robot/STB/Linux_STB/Demo_Keywords.robot

Library   /home/ltts/Documents/evqual_automation/agentLinuxSTB2/workspace/Lib/Python/STB/Etisalat_Linux_STB2/TeardownStatusTC.py

Library   DateTime
Library    Process
Library    Collections


Suite Setup  Suite level setup
Suite Teardown  Suite level teardown
Test Setup  Test Level Setup
Test Teardown  Test Level Teardown

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



Suite level teardown
    #${File_name}  DUMP LOGCAT   ${filename}  ${serial}
    #Log To Console  LogCat file Name: ${File_name}
    #status of device execution

    BuiltIn.Sleep  2
    run keyword if all tests passed  TeardownStatusTC.Status  ${trigger_id}  ${agent_id}  Completed  Pass
    run keyword if any tests failed  TeardownStatusTC.Status  ${trigger_id}  ${agent_id}  Completed  Fail

Test Level Setup
    #start time
    # Generate Logs with Timestamp
    ${start_time}  GET TIME
    Log To Console    ${start_time}
    Set Global Variable  ${start_time}

Test Level Teardown
    #end time & each test case execution result
    ${end_time}  GET TIME
    #Log To Console  ${TEST NAME}:${exdict}[${TEST NAME}]
    #Log To Console  ${exdict}
    run keyword if test passed  TeardownStatusTC.Evaluate_time_result  ${exdict}[${TEST NAME}]  Pass  ${start_time}  ${end_time}
    #run keyword if test failed  TeardownStatusTC.Evaluate_time_result  ${exdict}[${TEST NAME}]  Fail  ${start_time}  ${end_time}


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



*** Test Cases ***
TC_901_DEVICE_ETHERNET_WIFI
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
    ${Result}  Verify Crop Image  ${port}  Settings_Ethernet_wifi_option
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Ethernet_wifi_option Is Displayed
	...  ELSE  Fail  Settings_Ethernet_wifi_option Is Not Displayed

TC_908_BILLING_TRANSACTION_HISTORY
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
	${Result}  Verify Crop Image  ${port}  Transaction_History
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Transaction_History_img Is Displayed
	...  ELSE  Fail  Settings_Transaction_History_img Is Not Displayed
    CLICK OK	
	CLICK BACK
    CLICK BACK
    

TC_902_DEVICE_CHANNEL_INFORMATION_REFRESH
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
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK RIGHT
	CLICK OK
    Sleep   2s
	${Result}  Verify Crop Image  ${port}  Setting_Channel_Info_Refresh
	Run Keyword If  '${Result}' == 'True'  Log To Console  Setting_Channel_Info_Refresh Is Displayed
	...  ELSE  Fail  Setting_Channel_Info_Refresh Is Not Displayed
    CLICK BACK
    Log To Console    Channel information refresh details displayed	
	CLICK BACK

TC_903_DEVICE_BLUETOOTH_CONNECTIVITY
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
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
    Sleep   2s
    Log To Console    Bluetooth connectivity details displayed
    ${Result}  Verify Crop Image  ${port}  Settings_Bluetooth_Not_Connected
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Bluetooth_Not_Connected Is Displayed
	...  ELSE  Fail  Settings_Bluetooth_Not_Connected Is Not Displayed

TC_904_DEVICE_AUDIO_OUTPUT
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
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Audio output
	CLICK OK
	CLICK DOWN
	CLICK OK
    Sleep   2s
    Log To Console    Selected DOLBY DIGITAL AUDIO
	CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK UP
    Sleep   2s
    Log To Console    Selected Stereo
	CLICK OK
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  Success_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Success_Popup Is Displayed
	...  ELSE  Fail  Success_Popup Is Not Displayed
	CLICK OK
    

TC_905_DEVICE_MANUAL_UPGRADE
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
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  Settings_Manual_Upgrade_img
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Manual_Upgrade_img Is Displayed
	...  ELSE  Fail  Settings_Manual_Upgrade_img Is Not Displayed
    
TC_906_DEVICE_SOFT_FACTORY_RESET
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
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
	CLICK DOWN
	Sleep    3s
    ${Result}  Verify Crop Image  ${port}  Settings_Soft_Factory_Reset_Start_Now
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Soft_Factory_Reset_Start_Now Is Displayed
	...  ELSE  Fail  Settings_Soft_Factory_Reset_Start_Now Is Not Displayed

TC_907_DEVICE_BOX_RESTORE
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
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  Settings_Box_Restore
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Box_Restore_Popup Is Displayed
	...  ELSE  Fail  Settings_Box_Restore_Popup Is Not Displayed

TC_909_BILLING_VIEW_AND_PAY_BILLS
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
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s
    ${Result}  Verify Crop Image  ${port}  Settings_Bills_View_And_Paybills
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Bills_View_And_Paybills Is Displayed
	...  ELSE  Fail  Settings_Bills_View_And_Paybills Is Not Displayed
	CLICK OK

TC_910_DIAGNOSIS_CHECK_DEVICE_INFORMATION
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
	CLICK RIGHT
	CLICK DOWN
    Sleep   2s
    Log To Console    Navigated to Diagnosis Settings
	CLICK OK
    Sleep   2s 
    Log To Console    Device information displayed
	CLICK OK
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  Settings_Show_Device_Information
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Show_Device_Information Is Displayed
	...  ELSE  Fail  Settings_Show_Device_Information Is Not Displayed

TC_911_DIAGNOSIS_SELF_CARE
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
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Diagnosis Settings
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    Sleep   2s 
    #Validate Diagnosis self care information Pop Up
	${Result}  Verify Crop Image  ${port}  Settings_Self_Care_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Self_Care_Popup Is Displayed
	...  ELSE  Fail  Settings_Self_Care_Popup Is Not Displayed
	CLICK BACK

TC_912_DIAGNOSIS_AUTO_RESTART_OFF_ON_CHECK
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
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Diagnosis Settings
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK OK
    Sleep   2s
    #Validate Success Pop Up 
    ${Result}  Verify Crop Image  ${port}  Success_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Success_Popup Is Displayed
	...  ELSE  Fail  Success_Popup Is Not Displayed
	CLICK OK
    Sleep   2s
    Log To Console    Auto restart turned Off
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK OK
    Sleep   2s
    Log To Console    Auto restart turned On
    ${Result}  Verify Crop Image  ${port}  Success_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Success_Popup Is Displayed
	...  ELSE  Fail  Success_Popup Is Not Displayed
	CLICK OK

TC_913_DIAGNOSIS_HDMI_CEC_DISABLED_ENABLED
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
	CLICK RIGHT
    Sleep   2s
    Log To Console    Navigated to Diagnosis Settings
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
    Sleep   2s
    Log To Console    HDMI CEC is Enabled
    # Validate success Pop up validation
    ${Result}  Verify Crop Image  ${port}  Success_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Success_Popup Is Displayed
	...  ELSE  Fail  Success_Popup Is Not Displayed
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
    Sleep   2s
    Log To Console    HDMI CEC is Disabled
    ${Result}  Verify Crop Image  ${port}  Success_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Success_Popup Is Displayed
	...  ELSE  Fail  Success_Popup Is Not Displayed
	CLICK OK


#######################################################################

TC_203_VERIFY_ZAPPING_USING_CHANNEL_PLUS_CHANNEL_MINUS_REMOTE_CONTROL
    [Tags]    LIVE TV
    [Documentation]    Verifies channel switching using channel up and channel down buttons on remote.
	CLICK HOME
    Log To Console    Navigated to Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated to TV Section
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
    Log To Console    Navigated to TV Guide
	CLICK ONE
    Sleep    10s
	CLICK OK
    Log To Console    Channel Zapping with Channel Plus
	CLICK CHANNELUP
	CLICK CHANNELUP
	CLICK CHANNELUP
	CLICK CHANNELUP
	CLICK CHANNELUP
	CLICK CHANNELUP
	CLICK CHANNELUP
	CLICK CHANNELUP
	CLICK CHANNELUP
	CLICK CHANNELUP
    Log To Console    Channel Zapping with Channel Minus
	CLICK CHANNELDWN
	CLICK CHANNELDWN
	CLICK CHANNELDWN
	CLICK CHANNELDWN
	CLICK CHANNELDWN
	CLICK CHANNELDWN
	CLICK CHANNELDWN
	CLICK CHANNELDWN
	CLICK CHANNELDWN
	CLICK CHANNELDWN
	Sleep    3s
    #image validation for zapping - verify channel number 1
	${Result}  Verify Crop Image  ${port}  Channel_Number_1
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel_Number_1 Is Displayed
	...  ELSE  Fail  Channel_Number_1 Is Not Displayed	
	CLICK OK

TC_204_ZAPPING_WITH_NUMERIC_KEYS
    [Tags]    LIVE TV
	[Documentation]     Verifies channel switching using numeric key inputs on the remote.   
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
    Log To Console    Navigated To TV Guide
    Sleep    2s
	CLICK SEVEN
	CLICK TWO
	Sleep    2s
    CLICK BACK
	CLICK RIGHT
	# CLICK DOWN
	${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	# CLICK ZERO
	Sleep    3s
    Log To Console    Verify Playback After Zapping Through Numeric Keys
	#image validation required 
	${Result}  Verify Crop Image  ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed

TC_205_VERIFY_ZAPPING_CHANNEL_LIST
    [Tags]    LIVE TV  
    [Documentation]    Verifies channel zapping flow and playback validation
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
    Log To Console    Navigated To TV Guide
    CLICK ONE
    Log To Console    Navigated To Channel 1
	Sleep    3s
	CLICK BACK
	CLICK OK
	SLEEP    2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s
	CLICK RIGHT
	Sleep    2s
	CLICK OK
	FOR    ${i}    IN RANGE    3
		${Pause}=    Verify Crop Image    ${port}    Pause_Side_Panel
		Log To Console    [Iteration ${i}] Pause Icon Found: ${Pause}
		Run Keyword If    '${Pause}' == 'False'    Run Keywords
		...    Log To Console    → Pause not found, going to next program
		...    AND    Click BACK
		...    AND    Click DOWN
		...    AND    Click OK
		...    AND    Sleep    1s
		...    AND    Continue For Loop
		
		Run Keyword If    '${Pause}' == 'True'    Run Keywords
		...    Log To Console    → Pause not found, going to next program
		...    AND    Click DOWN
		...    AND    Click OK
		...    AND    Sleep    1s
		...    AND    Exit For Loop
	END
	Sleep    3s
    #Verify Play Button
	${Result}  Verify Crop Image  ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	# ...  ELSE  Fail  Play_Button Is Not Displayed

TC_211_VERIFY_ADD_TO_FAVORITES
    [Tags]    LIVE TV
	[Documentation]    Verify Content Added To Favorite List
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated to TV Section
	CLICK OK
	Log To Console    Navigated To Live TV
	CLICK OK
	Log To Console    Side Bar Is Displayed
	
	CLICK OK
	Log To Console    Add To Favorites Option Is Selected
	CLICK OK
	Log To Console    Selecting The Favorite List
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}  Remove_From_Fav
	Run Keyword If  '${Result}' == 'True'  Log To Console  Remove_From_Fav Is Displayed
	...  ELSE  Fail  Remove_From_Fav Is Not Displayed

TC_212_VERIFY_REMOVE_FAVORITES
    [Tags]    LIVE TV
	[Documentation]    Verify Content Removed From Favorite List
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated To TV Section
	CLICK OK
	Log To Console    Navigated To Live TV
	CLICK OK
	Log To Console    Side Bar Is Displayed
	CLICK OK
	CLICK OK
	CLICK RIGHT
	Log To Console    Remove Favorites Option Is Selected
	CLICK DOWN
	CLICK OK
	CLICK OK
	Log To Console    Selecting The Favorites list
	CLICK RIGHT
	# verify the sidebar - there should not be remove from favorites
	${Result}=    Verify Crop Image    ${port}    Rmv_Fav
	Run Keyword If    '${Result}' == 'True'    Fail    ❌ Remove_From_Fav should not be displayed
	Run Keyword If    '${Result}' != 'True'    Log To Console    ✅ Remove_From_Fav is not displayed, as expected


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
    CLICK ONE
    Log To Console    Navigated To Channel 1
    Sleep    2s
	CLICK CHANNELDWN
	CLICK BACK
    CLICK RIGHT
    ${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Video paused
	Sleep    2s
    #image validation required - Check play button visibility
	${Result}  Verify Crop Image  ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed	
	CLICK OK

TC_214_VERIFY_LIVE_TV_STARTOVER
	[Tags]    LIVE TV
    [Documentation]    Verifies Live TV start-over feature and confirms seek bar visibility
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section
	CLICK OK
    Log To Console    Navigated To Live TV
    CLICK SEVEN
    CLICK ONE
	CLICK ZERO 
	CLICK TWO
    Log To Console    Navigated To Channel 7102
	CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    Log To Console    Playback Started From Beginning
    #image validation required - check for seekbar visibility
	CLICK OK
    CLICK HOME
    CLICK OK
	
TC_215_VERIFY_LIVE_TV_RECORD
	[Tags]    LIVE TV  
    [Documentation]    Verifies Live TV recording functionality
	CLICK HOME
    Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To TV Section  
	CLICK OK
    Log To Console    Navigated To Live TV
    Sleep    5s
	CLICK SEVEN
	CLICK ONE
	CLICK ZERO
	CLICK FIVE
    Log To Console    Navigated To Channel 7105
	Sleep    10s
	CLICK RIGHT
	Sleep    1s
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    Log To Console    Tapped Record Button
    CLICK DOWN 
    CLICK OK
	Log To Console    Record The Program Is Selected
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    Log To Console    Playback Recording Started
    #image validation required - verify the recording started popup
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
	Log To Console    Navigated To My TV Section
	CLICK OK
	Log To Console    Navigated to Recorder Section
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# validate the stop recording text in sidebar
	Log To Console    Recording Stopped
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK OK
    Log To Console    Navigated To Catch up section all channels
	CLICK OK
	CLICK LEFT
	CLICK OK
    Log To Console    Catchup Selected
	CLICK DOWN
	CLICK OK
    Log To Console    Playback Started Playing
	Sleep    3s
    #image validation required - verify pause button
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed

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
	CLICK ONE
    Log To Console    Navigated To Channel 1
    Sleep    1s
	CLICK CHANNELDWN
	CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK OK
    Log To Console    Navigated To More Details Section
    Sleep    3s
	CLICK OK
    CLICK OK
	CLICK DOWN
	CLICK OK
    #image validation required - verify play button
	
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
    Log To Console    Displayed Search Results 
	CLICK OK
	CLICK OK
    #image validation required - Check for MBC channel name in the screen
TC_219_VERIFY_AUDIO_LANGUAGE
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
	CLICK SEVEN
	CLICK ONE
	CLICK ZERO
	CLICK FIVE
	Log To Console    Channel 7105 Is Pressed
	CLICK BACK
	CLICK RIGHT
    ${STEP_COUNT}=    Move to Audio Launguage On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END

    CLICK OK
	${Result}  Verify Crop Image  ${port}  Audio
	Run Keyword If  '${Result}' == 'True'  Log To Console  Subtitle_Popup Is Displayed
	...  ELSE  Fail  Audio Is Not Displayed
	Log To Console    Audio Section Is Selected
	CLICK OK	
	CLICK DOWN
	CLICK OK
    # check for the language 
	Log To Console    Audio Language Changed

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
	CLICK SEVEN
	CLICK ONE
	CLICK ZERO
	CLICK FIVE
	Log To Console    Channel 7105 Is Pressed
	Sleep    1s
	CLICK BACK
	CLICK RIGHT
	 ${STEP_COUNT}=    Move to subtitle On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END

	CLICK OK
	Log To Console    Subtitle Section Is Selected
	${Result}  Verify Crop Image  ${port}  Subtitle_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Subtitle_Popup Is Displayed
	...  ELSE  Fail  Subtitle_Popup Is Not Displayed
	# check for the subtile present
	Log To Console    Subtitles Appeared In The Screen
   	CLICK OK

###############################################################################

TC_701_ACCESS_CATCHUP_MENU_PLAY_24HRS_AGO_CATCHUP
        [Tags]    CATCHUP
    [Documentation]    Plays catch-up content from the previous 24-hour window.
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
	CLICK OK
	CLICK LEFT
	CLICK OK
    Log To Console    Selected Catch Up Playback
	CLICK DOWN
	CLICK OK
    Log To Console    Catch Up Content Is Playing
	Sleep    3s
    #image validation of seekbar found
	${Result}  Verify Crop Image  ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed


TC_702_ACCESS_CATCHUP_FROM_EPG
    [Tags]    CATCHUP
	[Documentation]    Verifies access to catch-up content directly from the Electronic Program Guide (EPG).
	CLICK HOME
	Log To Console    Navigated to Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated to TV Section
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Log To Console    Navigated To TV Guide Section
	Sleep    2s
	CLICK SEVEN
	CLICK SEVEN
	CLICK ONE
	CLICK BACK
	CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
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
	CLICK BACK
	CLICK BACK
	CLICK RIGHT
	# CLICK OK
	CLICK DOWN
	CLICK OK
	Log To Console    Content Accessed From EPG
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	Sleep    2s
	# REVERT
	CLICK BACK
	CLICK BACK
	CLICK BACK
	CLICK OK
	CLICK LEFT
	CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK OK

TC_703_CATCHUP_PAUSE_RESUME
    [Tags]    CATCHUP
    [Documentation]     Verifies pausing and resuming catch-up content from the same position.
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
	CLICK OK
	CLICK OK
    Log To Console    Selected Catch Up Playback
	CLICK DOWN
	CLICK OK
    Log To Console    Video Streaming Paused
    Sleep    10s
	CLICK OK
    Log To Console    Video Streaming Resumed
	Sleep    3s
    #verify playback - play button
	${Result}  Verify Crop Image  ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed

TC_704_CATCHUP_FAST_FORWARD_RESUME
    [Tags]    CATCHUP
	[Documentation]    Verifies fast-forwarding and resuming catch-up content correctly.   
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
	CLICK OK
	CLICK OK
    Log To Console    Selected Catch Up Playback
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK OK
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  x4_Forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  x4_Forward Is Displayed
	...  ELSE  Fail  x4_Forward Is Not Displayed
	Sleep    1s
	CLICK OK
	# validate 8x fastforward 
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  x8_Forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  x8_Forward Is Displayed
	...  ELSE  Fail  x8_Forward Is Not Displayed
	Log To Console    8x fastforward 
    Sleep    1s
	CLICK OK
	# validate 16x fastforward 
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  x16_Forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  x16_Forward Is Displayed
	...  ELSE  Fail  x16_Forward Is Not Displayed
    Log To Console    Playback Progressed Forward
    #check for 4x,8x,16x visibility in seekbar
    CLICK LEFT
    CLICK OK
    Log To Console    Video Playback Resumed

TC_705_CATCHUP_REWIND_RESUME
    [Tags]    CATCHUP
	[Documentation]    Verifies rewinding and resuming catch-up content accurately.    
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
	CLICK OK
	CLICK OK
    Log To Console    Selected Catch Up Playback
	CLICK DOWN
	CLICK OK
	CLICK LEFT
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    3s
    Log To Console    Returned To A Previous Timestamp
	${Result}  Verify Crop Image  ${port}  REWIND_4X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_4X Is Displayed
	...  ELSE  Fail  REWIND_4X Is Not Displayed
	CLICK RIGHT
	CLICK OK
    Log To Console    Video Playback Resumed	

TC_706_STOP_CATCHUP_MID_PLAYBACK_RETURN_CATCHUP_MENU
    [Tags]    CATCHUP
	[Documentation]    Verifies interrupting catch-up playback and navigating back to catch-up menu.    
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
	CLICK OK
	CLICK OK
    Log To Console    Navigated To Catch Up Feed
	CLICK DOWN
	CLICK OK
    Log To Console    Stopped Catch Up Playback
    Sleep    10s
	CLICK BACK
    #validation - check for tv>catchup in the screen
	Log To Console    Playback Stopped And Returned Back To Catch Up
	${Result}  Verify Crop Image  ${port}  Catch_Up_AllChannels_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Catch_Up_AllChannels_Page Is Displayed
	...  ELSE  Fail  Catch_Up_AllChannels_Page Is Not Displayed



TC_707_VERIFY_CATCHUP_SUBTITLES
    [Tags]    CATCHUP
	[Documentation]    Verifies subtitles display correctly during catch-up content playback.
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated to TV Section
	CLICK DOWN
	CLICK OK
	Log To Console    Navigated To Catch Up Section
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated To Documentary Section
	CLICK OK
	CLICK OK
	Log To Console    Catch Up Playback Selected
	CLICK DOWN
	CLICK OK
	Log To Console    Catch Up Started Playing
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Log To Console    Subtitle Tab Is Displayed
	# verify the Subtitle in the screen
	Log To Console    Subtitle Is Enabled For The Selected Catch Up
	${Result}  Verify Crop Image  ${port}  Subtitle_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Subtitle_Popup Is Displayed
	...  ELSE  Fail  Subtitle_Popup Is Not Displayed
	CLICK OK	

TC_708_VERIFY_CATCHUP_AUDIO_TRACK_SWITCH
    [Tags]    CATCHUP
	[Documentation]    Verifies switching audio tracks during catch-up content playback.
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
	CLICK OK
	CLICK OK
    Log To Console    Navigated To Catch Up Feed
	CLICK DOWN
	CLICK OK
    Log To Console    Catch Up Playback Started
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	#validation- check for the mini pop up displaying arabic,english language in the screen
    Log To Console    Content Audio Switched To English Language
	${Result}  Verify Crop Image  ${port}  Audio_Launguage
	Run Keyword If  '${Result}' == 'True'  Log To Console  Audio_Launguage Is Displayed
	...  ELSE  Fail  Audio_Launguage Is Not Displayed
    Log To Console    Accessed The Audio Button In The Screen
	CLICK DOWN
	CLICK OK
    
TC_711_ADD_CATCHUP_ADD_TO_MY_LIST_AND_ACCESS
    [Tags]    CATCHUP
	[Documentation]    Verifies adding catch-up content to My List and accessing it.   
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
	CLICK OK
	CLICK OK
    Log To Console    Selected Catch Up Playback
	${STEP_COUNT}=    Move to Add To List On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK OK
    Log To Console    Content Added To My List
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To My List Section
	CLICK OK
    Log To Console    Accessed My List Content
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed

TC_712_RESUME_PARTIALLY_WATCHED_CATCHUP_PROGRAM_CONTINUE_WATCHING_SECTION
    [Tags]    CATCHUP
	[Documentation]    Verifies resuming partially watched catch-up programs from Continue Watching section.
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	Sleep    10s
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME


TC_714_BROWSE_CATCHUP_CATEGORIES_AND_PLAY_TITLE
    [Tags]    CATCHUP
	[Documentation]    Verifies resuming partially watched catch-up programs from Continue Watching section.
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
    # check for tv>Catchup>movies in the screen
    Log To Console    Navigated To Catch Up Movies Feed
	CLICK OK
	CLICK OK
    Log To Console    Selected Catch Up Playback
	CLICK DOWN
	CLICK OK
    # Check for the pause button
	Sleep    3s
    Log To Console    Browsed Catch Up Categories And Initiated Content Playback
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed

TC_715_PLAY_CATCHUP_PROGRESS_BAR_WITH_TIMESTAMP_INFORMATION
    [Tags]    CATCHUP
	[Documentation]    Verifies catch-up playback progress bar displays accurate timestamp information.
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
	CLICK OK
	CLICK OK
    Log To Console    Navigated To Catch Up Feed
	CLICK DOWN
	CLICK OK
	Sleep    3s
    #validation - look for the timestamp in the seekbar in the screen
    Log To Console    Catch Up Played And Verified Seek Bar With Timestamp
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed

TC_716_CHECK_CATCHUP_RECOMMENDATIONS_BASED_ON_RECENTLY_WATCHED_PROGRAMS
    [Tags]    CATCHUP
	[Documentation]    Verifies catch-up recommendations based on user’s recently watched programs.
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
	CLICK OK
	CLICK OK
    Log To Console    Navigated To Catch Up Feed
	CLICK DOWN
	CLICK OK
    Log To Console    Catch Up Playback Started
    Sleep    5s
	CLICK BACK
	CLICK BACK
	CLICK BACK
    Log To Console    Navigated Back To Catch Up Section
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    #check for recommended feed and verify that it matched with the recently watched programs
    Log To Console    Navigated To Recommended Feed And Content Played
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed

TC_718_VERIFY_A_RECENTLY_AIRED_SECTION_WITH_LATEST_CATCHUP
    [Tags]    CATCHUP
	[Documentation]    Verifies the Recently Aired section displays the latest catch-up content.
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
	CLICK OK
    #validation- verify yesterday text in the screen
	Sleep    3s
    Log To Console    Recently Aired Content Is Playing
	${Result}  Verify Crop Image  ${port}  Yesterday_Catchup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Yesterday_text_on_Catchup Is Displayed
	...  ELSE  Fail  Yesterday_text_on_Catchup Is Not Displayed


TC_724_BROWSE_CATCHUP_VERIFY_KIDS_SECTION_WITH_AGE_APPROPRIATE_PROGRAMS
    [Tags]    CATCHUP
	[Documentation]    Verifies kids’ catch-up section shows age-appropriate programs only.
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
	CLICK DOWN
	CLICK OK
    Log To Console    Navigated To Catch Up Kids Feed
	CLICK OK
    #validation - check for tv>catchup>kids in the screen
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    # validation - check for the playback 
	Sleep    3s
    Log To Console    Browsed Catch Up Categories And Initiated Content Playback
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed

TC_502_BROWSE_ONDEMAND_PLAYBACK
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK	
    Log To Console	Navigated To On_Demand_Collections
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK
    Log To Console	Playing Video
    #validate pause button
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed


TC_503_SEARCH_VOD_INITIATE_PLAYBACK_FROM_SEARCH
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    Log To Console	Navigated To On_Demand_Collections
	CLICK OK
	CLICK UP
	CLICK OK
    Log To Console	Entering Text ALOHA
	CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK UP
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
	CLICK DOWN
	CLICK OK
    Log To Console    Searched movie is visible	
	CLICK OK
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keywords
    ...        Log To Console    Naviagted to searched video
    ...        AND    CLICK OK
	# validate pause button
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Sleep	10s
    CLICK HOME
	

TC_504_VOD_PAUSE_RESUME
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    Log To Console	Navigated To On_Demand_Collections
	CLICK DOWN
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keywords
    ...        Log To Console    Selected video
    ...        AND    CLICK OK
    Log To Console	Video is Playing   
	# Validate play button
	Sleep	20s
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK OK

TC_505_VOD_FAST_FORWARD_RESUME
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
    Log To Console	Navigated To On_Demand_Collections
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK
	# validate fastforward button
	Log To Console    Playing video
	CLICK RIGHT
	CLICK OK
	Sleep	2s
	${Result}  Verify Crop Image  ${port}  x4_Forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  x4_Forward Is Displayed
	...  ELSE  Fail  x4_Forward Is Not Displayed
	# validate 4x fastforward 
	Log To Console    4x fastforward 
    Sleep    1s
	CLICK OK	
	# validate 8x fastforward 
	Log To Console    8x fastforward 
    Sleep    1s
	CLICK OK
	# validate 16x fastforward 
	Log To Console    16x fastforward 
    Sleep    1s
	CLICK OK
	# validate 32x fastforward 
	Log To Console    32x fastforward 	
    Sleep    1s
	CLICK LEFT
	CLICK OK


TC_506_VOD_REWIND_RESUME
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    Log To Console	Navigated To On_Demand_Collections
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK OK
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  REWIND_4X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_4X Is Displayed
	...  ELSE  Fail  REWIND_4X Is Not Displayed
	#Validate Rewind -4x
	Log To Console    -4x Rewind 
    Sleep   1s
	CLICK OK
	#Validate Rewind -8x
    Log To Console    -8x Rewind
	Sleep   1s
	CLICK OK
	#Validate Rewind -16x
	Log To Console    -16x Rewind
    Sleep   1s
	CLICK OK
	#Validate Rewind -32x
	CLICK RIGHT
	CLICK OK
	CLICK OK

TC_507_STOP_VOD_MID_PLAYBACK_CONFIRM_EXIT_VOD_LIBRARY
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    Log To Console	Navigated To On_Demand_Collections
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK BACK
    Log To Console	Displaying Vod Library
	CLICK BACK
    Sleep   1s
    #validate  vod library page 
	CLICK BACK
    Log To Console	Displaying Home page

TC_508_VERIFY_VOD_SUBTITLE_CHANGE
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    Log To Console	Navigated To On_Demand_Collections
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK UP
	CLICK OK
    Log To Console	Subtitle is changed
    # validatesubtitle
	

TC_513_RESUME_PARTIAL_WATCHED_VOD_FROM_CONTINUE_WATCHING
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
    Log To Console  Playing from continue watching
	Sleep    3s
    # validate play
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed

TC_523_VERIFY_TRENDING_SECTION_TRY_TRENDING_VOD
	CLICK HOME
    Log to Console    Navigated to Home page
	Sleep    3s
	# validate Trending section page
	FOR    ${i}    IN RANGE    50
    ${Result}=    Verify Crop Image    ${port}    Trending_Section
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ Trending_Section is displayed
    ...    AND    Exit For Loop

    CLICK RIGHT
    END

    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Trending_Section is not displayed after navigating right
    Log To Console  Navigating through Trending section
	CLICK OK
	CLICK OK
    
TC_539_VERIFY_DISPLAY_LAST_VIEWED_VOD
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    Log To Console	  Navigated To On_Demand_Collections
	CLICK DOWN
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keywords
    ...        Log To Console    ready to play VOD video
    ...        AND    CLICK OK
    Sleep    20s
	CLICK HOME
    Log To Console	  Navigated To Home Page
	${Result}  Verify Crop Image  ${port}  Continue_Watching_Feeds
	Run Keyword If  '${Result}' == 'True'  Log To Console  Continue watching is displayed
	...  ELSE  Fail  Continue watching is not displayed

	
TC_540_VERIFY_DISPLAY_VOD_DETAILS
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    Log To Console	Navigated To On_Demand_Collections
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
    Log To Console  Displaying VOD details
	Sleep    3s
    	
TC_554_START_OVER_VOD
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    Log To Console	Navigated To On_Demand_Collections
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK RIGHT
    CLICK RIGHT
    CLICK OK
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
    CLICK LEFT
    CLICK LEFT
	CLICK OK
    Log To Console    Playback resumed from the start
	Sleep    2s
	${Result}  Verify Crop Image  ${port}  Start_Over_Progress_Selected
	Run Keyword If  '${Result}' == 'True'  Log To Console  Start_Over_Progress_Selected Is Displayed
	...  ELSE  Fail  Start_Over_Progress_Selected Is Not Displayed

    
TC_553_VERIFY_VOD_PROGRESS_BAR
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    Log To Console	Navigated To On_Demand_Collections
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keywords
    ...        Log To Console    Naviagted to searched video
    ...        AND    CLICK OK
	Sleep	10s
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    Log To Console    skip video to next
    # Sleep    1s
	CLICK RIGHT
	CLICK OK
	Log To Console    skip video to +10sec
    # Sleep    1s
	CLICK LEFT
	CLICK LEFT
	CLICK OK
    Log To Console    Forwarded video +4X 
    Sleep    1s
	CLICK LEFT
	CLICK OK
	# Sleep	1s
    #validate seek bar
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK OK
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed

TC_552_VERIFY_VOD_RESUME
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    Log To Console	Navigated To On_Demand_Collections
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keywords
    ...        Log To Console    Naviagted to searched video
    ...        AND    CLICK OK
	CLICK OK
    Sleep    30s
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
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    Log To Console	Navigated To On_Demand_Collections
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keywords
    ...        Log To Console    Navigated to searched video
    ...        AND    CLICK OK
	CLICK OK
    Sleep    1s
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Resume_Button Is Displayed
	...  ELSE  Fail  Resume_Button Is Not Displayed
	# CLICK OK
    Log To Console    Previously watched video is resumed

TC_551_VERIFY_TRICKMODE_VOD
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    Log To Console	Navigated To On_Demand_Collections
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK OK
    CLICK OK
    CLICK OK
    CLICK OK
    Log To Console    Forwarded +32x
    Sleep    1s
	CLICK LEFT
	CLICK OK
    Sleep    1s
	CLICK LEFT
    Sleep    1s
	CLICK OK
    Log To Console	  Rewinded -4x
	CLICK RIGHT
	CLICK OK
	Sleep    3s
    #validate seek bar
	${Result}  Verify Crop Image  ${port}  Seek_Bar
	Run Keyword If  '${Result}' == 'True'  Log To Console  Seek_Bar Is Displayed
	...  ELSE  Fail  Seek_Bar Is Not Displayed

TC_550_VERIFY_PLAYBACK_SPECIFIC_TIME
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    Log To Console	  Navigated To On_Demand_Collections
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
    Sleep    30s
    CLICK OK
    Log To Console    seeked video for 30sec
    #validate play 
	${Result}  Verify Crop Image  ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed

TC_543_VERIFY_PLAY_TRAILER
	[Tags]    VOD
	[Documentation]    play Trailer

	SEARCH VOD
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	#verify trailer button
    #validate trailer - Flaky steps [It navigating to cast]
	#${Result}  Verify Crop Image  ${port}  Settings_Ethernet_wifi_option
	#Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Ethernet_wifi_option Is Displayed
	#...  ELSE  Fail  Settings_Ethernet_wifi_option Is Not Displayed
    Log To Console    Playing Trailer
    Sleep    5s

TC_535_VOD_LIVE_PLAYBACK_SWITCH
	CLICK HOME
	Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log to Console    Navigated to On Demand collections
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keywords
    ...        Log To Console    Naviagted to searched video
    ...        AND    CLICK OK
	CLICK OK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log to Console    Navigated to LIVE TV
	CLICK CHANNELDWN
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	
TC_307_REWIND_LIVE_TEN_TIMES_CONSECUTIVELY
	CLICK HOME
	Log To Console    Navigated To Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK EIGHT
	CLICK NINE
	Sleep	3s
	CLICK BACK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK LEFT
	# Log To Console    rewinding the video
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK Ok
	#validate rewind button 
	Log To Console    video rewinded consecutively for 10 times
	${Result}  Verify Crop Image  ${port}  Seek_Bar
	Run Keyword If  '${Result}' == 'True'  Log To Console  Seek_Bar Is Displayed
	...  ELSE  Fail  Seek_Bar Is Not Displayed
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keywords
    ...        Log To Console    Naviagted to searched video
    ...        AND    CLICK OK
	CLICK OK
	#validate resume 
	Log To Console    Selecting previously watched VOD
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK OK

TC_529_VOD_LIBRARY_KIDS_SECTION_CONTENT
	CLICK HOME
	Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	Log to Console    Navigated to On Demand junior kids section
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    20s
	CLICK RIGHT
	Log To Console    Playing video from VOD kids Library
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	
TC_528_VERIFY_RELATED_CONTENT_SECTION
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log to Console    Navigated to On Demand collections
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK OK
	Sleep    2s    
	CLICK BACK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    2s    
	CLICK BACK
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Log To Console    Checking previously VOD in continue watching
	#validate recently played content is displayed in continue watching and recomended section - Pending
	# ${Result}  Verify Crop Image  ${port}  Settings_Ethernet_wifi_option
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Ethernet_wifi_option Is Displayed
	# ...  ELSE  Fail  Settings_Ethernet_wifi_option Is Not Displayed


TC_516_VERIFY_VOD_PROGRESS_BAR_TIMESTAMP
	CLICK HOME
	Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log to Console    Navigated to On Demand collections
	CLICK DOWN
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK OK
	Sleep    30s
	CLICK OK
	Log To Console    Checking the Time stamp
    #validate time stamp
	# ${Result}  Verify Crop Image  ${port}  30_Sec_Timestamp
	# Run Keyword If  '${Result}' == 'True'  Log To Console  30_Sec_Timestamp Is Displayed
	# ...  ELSE  Fail  30_Sec_Timestamp Is Not Displayed

TC_710_VERIFY_CATCHUP_UNAVAILABLE_PROGRAM_OUTSIDE_SUPPORTED_WINDOW
    [Tags]    CATCHUP
    [Documentation]    Verifies Catch Up Channel
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
    
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
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	#check for mute button
	Log To Console    Volume Is Decreased
	CLICK VOLUP
	CLICK VOLUP
	#check for volume increase
	Log To Console    Volume Is Increased
	CLICK MUTE
	#check for mute button
	Log To Console    Volume is Muted
	CLICK MUTE
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  Mute_Remote_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Mute_Remote_Button Is Displayed
	...  ELSE  Fail  Mute_Remote_Button Is Not Displayed	
	#checkk for volume bar
	Log To Console    Volume is Unmuted	
	CLICK OK

TC_511_VERIFY_VOD_ADD_TO_LIST
	CLICK HOME
	Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console	  Navigated To On_Demand_Collections
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Log To Console    successfully added to my list
	#validate succesful message
	CLICK HOME
	Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	Log To Console    Navigated to My list
	CLICK OK
	CLICK OK
	Log To Console    Playing video from my list section
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	#validate succesful remove message
	Log To Console    succesfully removed from my list

TC_556_VERIFY_VOD_VOLUME_CONTROL
	CLICK HOME
	Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log to Console    Navigated to On Demand collections
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK VOLUP
	Log to Console    VOLUME UP
	CLICK VOLDWN
	Log to Console    VOLUME DOWN
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  Volume_Down
	Run Keyword If  '${Result}' == 'True'  Log To Console  Volume_Down Is Displayed
	...  ELSE  Fail  Volume_Down Is Not Displayed	


TC_601_RESTART_LIVE_PROGRAM_USING_START_OVER
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK EIGHT
	CLICK NINE
	Sleep    4s
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  Tv_Guide_Start_Over_Side_Pannel
	Run Keyword If  '${Result}' == 'True'  Log To Console  Tv_Guide_Start_Over_Side_Pannel Is Displayed
	...  ELSE  Fail  Tv_Guide_Start_Over_Side_Pannel Is Not Displayed	
	CLICK OK
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK OK

TC_114_VERIFY_TRENDING_NOW_SECTION_CURRENT_POPULAR_CONTENT
	CLICK HOME
	Log to Console    Navigated to Home page
	FOR    ${i}    IN RANGE    50
    ${Result}=    Verify Crop Image    ${port}    Trending_Section
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ Trending_Section is displayed
    ...    AND    Exit For Loop

    CLICK RIGHT
    Sleep    0.3s
    END

    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Trending_Section is not displayed after navigating right
	Sleep    2s

TC_301_TIMESHIFT_PAUSE_RESUME_LIVE
	CLICK HOME
	Log To Console    Navigated To Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK CHANNELUP
	Sleep    1s
	CLICK CHANNELUP
	CLICK OK
	#check for pause and play from side, and click it
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	Log To Console    video is paused
	Sleep    30s
	CLICK OK
	Log To Console    video is resumed		
	CLICK OK
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	

TC_302_TIMESHIFT_REWIND_RESUME_LIVE
	CLICK HOME
	Log To Console    Navigated To Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK EIGHT
	CLICK NINE
	CLICK OK
	CLICK OK
	#check for pause and play from side, and click it
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK OK
	Log To Console    video is rewinding
	Sleep    30s
	#validate rewind button -4x text
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    video is resumed		
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK OK
	

TC_303_TIMESHIFT_PAUSE_FAST_FORWARD_LIVE
	CLICK HOME
	Log To Console    Navigated To Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK EIGHT
	CLICK NINE
	CLICK OK
	CLICK OK
	#check for pause and play from side, and click it
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	Log To Console    Video is paused
	Sleep    30s
	CLICK RIGHT
	CLICK OK
	Log To Console    Video is fast forwarding 
	CLICK OK
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed	

TC_304_TIMESHIFT_REWIND_MAXIMUM_TIMESHIFT_BUFFER_LIVE
	CLICK HOME
	Log To Console    Navigated To Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK EIGHT
	CLICK NINE
	CLICK OK
	CLICK OK
	#check for pause and play from side, and click it
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK OK
	Log To Console    video is rewinding
	Sleep    120s
	#validate rewind button -4x text
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	Log To Console    video is resumed
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed

TC_305_TIMESHIFT_PAUSE_LIVE_ONE_HOUR_RESUME
	CLICK HOME
	Log To Console    Navigated To Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK EIGHT
	CLICK NINE
	CLICK OK
	CLICK OK
	#check for pause and play from side, and click it
	CLICK DOWN
	CLICK OK
	Log To Console    Video is paused
	Sleep    60s
	CLICK OK
	Log To Console    video is resumed
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed

TC_308_PAUSE_FAST_FASTWARD_AT_MAXIMUM_SPEED
	CLICK HOME
	Log To Console    Navigated To Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK EIGHT
	CLICK NINE
	CLICK OK
	CLICK OK
	#check for pause and play from side, and click it
	CLICK DOWN
	CLICK OK
	Log To Console    video is paused
	Sleep    60s
	Click OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	#validate forward +32x 
	Sleep    3s
	# Log To Console    video forwarded 32x times 
	# ${Result}  Verify Crop Image  ${port}  Seek_Bar
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Seek_Bar Is Displayed
	# ...  ELSE  Fail  Seek_Bar Is Not Displayed
	


  
TC_602_VERIFY_STARTOVER_AVAILABILITY_IN_EPG
		[Tags]      STARTOVER
	[Documentation]     Verify Startover availability in EPG
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep	3s
	Log to console		Navigated to TV
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	3s
	Log to console		Navigated to TV GUIDE
	CLICK ONE
	CLICK FIVE
	Sleep	5s
	Log to console		Navigated to Live channel 15
	CLICK OK
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
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	${Result}  Verify Crop Image  ${port}  Start_Over
	Run Keyword If  '${Result}' == 'True'  Log To Console  Start_Over Is Displayed
	...  ELSE  Fail  Start_Over Is Not Displayed	
	CLICK OK
	Sleep	2s
	#Check if startover indicator is seen in channel info bar else need to add loop through channels to identify it
	Log to console		Startover initiated
	#Validate starover initiated or LIVE icon on progress bar
	Sleep	15s 
	CLICK HOME
	CLICK OK

TC_620_VERIFY_STARTOVER_INDICATOR_IN_CHANNEL_INFO_BAR
		[Tags]      STARTOVER
	[Documentation]     Verify Startover availability in Channel info bar under EPG
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep	3s
	Log to console		Navigated to TV 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep	3s
	Log to console		Navigated to TV GUIDE
	CLICK ONE
	CLICK FIVE
	Sleep	3s
	Log to console		Navigated to Live channel 15
	Log to console		Navigated to Live channel 15
	CLICK OK
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
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	#Validate immediately for startover indicator
	#Check if startover indicator is seen in channel info bar else need to add loop through channels to identify it
	Log to console		Startover indicator is seen
	${Result}  Verify Crop Image  ${port}  Start_Over
	Run Keyword If  '${Result}' == 'True'  Log To Console  Start_Over Is Displayed
	...  ELSE  Fail  Start_Over Is Not Displayed
  
TC_804_VERIFY_CATCHUP_AVAILABILITY_FOR_PAST_PROGRAMS
		[Tags]      GUIDE
    [Documentation]     Verify catchup Availability for past programs
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Sleep   2s
    Log To Console    Navigated to TV 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
    Sleep   2s
    Log To Console    Navigated to TV Guide
	CLICK DOWN
	CLICK RIGHT
	Sleep	2s
	CLICK RIGHT
	CLICK UP
	Sleep    3s
    #Validate highlighted yesterday - Needs revisit
    ${Result}  Verify Crop Image  ${port}  Yesterday_Option
	Run Keyword If  '${Result}' == 'True'  Log To Console  Yesterday_Option Is Displayed
	...  ELSE  Fail  Yesterday_Option	 Is Not Displayed
    
TC_815_CHECK_VISUAL_INDICATOR_FOR_RECORDED_PROGRAMS_IN_EPG
		[Tags]      GUIDE
    [Documentation]     Verify visual indicator for recorded programs in EPG
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Sleep   2s
    Log To Console    Navigated to TV
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
    Sleep   2s
    Log To Console    Navigated to TV Guide
	CLICK TWO
	CLICK TWO
    Log To Console     Navigated to the channel
	Sleep	5s
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
    #Validate the Highlighted record button without giving sleep after clicking down
    ${Result}  Verify Crop Image  ${port}  Record_Option_Left_Pannel
	Run Keyword If  '${Result}' == 'True'  Log To Console  Record_Option_Left_Pannel Is Displayed
	...  ELSE  Fail  Record_Option_Left_Pannel Is Not Displayed	
	CLICK OK

TC_818_CANCEL_SCHEDULED_RECORDING_FROM_EPG
		[Tags]      GUIDE
	[Documentation]     Verify Cancel schedule recording from EPG
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
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK RIGHT
	# Pre condition to clear schedule recordings
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep   2s 
	Log To Console     Navigated to TV 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep   2s 
	Log To Console     Navigated to TV GUIDE
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep   2s 
	Log To Console     Recorded future program
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK LEFT
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	#Validate schedule removal pop up
	${Result}  Verify Crop Image  ${port}  Recordings_Popup
		Run Keyword If  '${Result}' == 'True'  Log To Console  Recordings_Popup Is Displayed
		...  ELSE  Fail  Recordings_Popup Is Not Displayed		
	CLICK OK
	#Validate removal

TC_833_VERIFY_STARTOVER_AND_CATCHUP_OPTION_UNDER_EPG_DURING_LIVE_STREAM
	[Tags]      GUIDE
  [Documentation]     Verify startover and catchup option in EPG during live stream
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep   2s 
  Log To Console     Navigated to TV 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	#Sleep   2s 
  Log To Console     Navigated to TV GUIDE
	CLICK ONE
	CLICK FIVE
	Sleep	5s
	CLICK TWO
	CLICK TWO
	Sleep	3s
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	#Validate catchup option
	# ${Result}  Verify Crop Image  ${port}  Catch_up_Option_Left_Pannel
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Catch_up_Option_Left_Pannel Is Displayed
	# ...  ELSE  Fail  Catch_up_Option_Left_Pannel Is Not Displayed	

TC_101_LOAD_HOMEPAGE
	[Tags]      HOMEPAGE
  [Documentation]     Verify HOMEPAGE LOADING
	CLICK HOME
	CLICK BACK
	CLICK BACK
	CLICK MENU
	CLICK RED
	CLICK BLUE
	Sleep    7s 
	CLICK BACK
	Sleep    10s 
    CLICK OK
	CLICK OK
	Sleep    5s
	CLICK HOME
	CLICK UP
	CLICK OK
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed
	...  ELSE  Fail  Home_Page Is Not Displayed	

TC_113_VERIFY_SEARCH_HOMEPAGE
	[Tags]      HOMEPAGE
  [Documentation]     Verify search functionality from homepage
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
	CLICK OK

	# Validate channel name abu dhabi tv hd
	${Result}  Verify Crop Image  ${port}  Abu_Dhabi_Tv_HD_Channel_Name
	Run Keyword If  '${Result}' == 'True'  Log To Console  Abu_Dhabi_Tv_HD_Channel_Name Is Displayed
	...  ELSE  Fail  Abu_Dhabi_Tv_HD_Channel_Name Is Not Displayed	
	CLICK OK
	Sleep    5s 
	CLICK UP


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
	CLICK OK
    Log To Console    Navigated To TV Guide
    CLICK ONE
    Log To Console    Navigated To Channel 1
	Sleep    3s
	CLICK BACK
	CLICK OK
	SLEEP    2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s
	CLICK RIGHT
	Sleep    2s
	CLICK RIGHT
	CLICK OK
	Sleep    3s
    #Verify Today Option
	${Result}  Verify Crop Image  ${port}  Today_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console  Today_EPG Is Displayed
	...  ELSE  Fail  Today_EPG Is Not Displayed

TC_104_VERIFY_PERSONALIZED_RECOMMENDATIONS
	[Tags]      HOMEPAGE
  [Documentation]     Verify Personalized Recommendations from Homepage
	CLICK HOME
	FOR    ${i}    IN RANGE    50
		${Result}=    Verify Crop Image    ${port}    Recommended_Feeds
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ Recommended_Feeds is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recommended_Feeds is not displayed after navigating right	

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
	CLICK OK
	#Validate continue watching text on top left
	${Result}  Verify Crop Image  ${port}  Continue_Watching_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Continue_Watching_Page Is Displayed
	...  ELSE  Fail  Continue_Watching_Page Is Not Displayed

TC_106_VERIFY_SMOOTH_SCROLL_THROUGH_HOMEPAGE
      [Tags]      HOMEPAGE
    [Documentation]     Verify smooth scroll through Homepage
	CLICK HOME
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image    ${port}    Recommended_Feeds
		Run Keyword If    '${Result}' == 'True'    Run Keywords
		...    Log To Console    ✅ My_Box_Office_Rental_Feed is displayed
		...    AND    Exit For Loop

		CLICK RIGHT
	END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ My_Box_Office_Rental_Feed is not displayed after navigating right

TC_207_VERIFY_MOSAIC_CHANNEL
    [Tags]    LIVE TV
    [Documentation]    Verifies Mosaic Nature Of Channel
	CLICK HOME
	Log To Console    Navigated To Home Page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Log To Console    Navigated To TV Section
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Log To Console    Navigated To TV Guide
	CLICK ONE
	Sleep    2s
	CLICK BACK
	CLICK OK
	Log To Console    Channel Zapped
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep    3s
	Log To Console    Selected Playback from Mosaic Channel
	${Result}  Verify Crop Image  ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed

TC_206_VERIFY_ZAPPING_DURABILITY
    [Tags]    LIVE TV
    [Documentation]    Verifies channel Durability
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK BACK
	Sleep    5s
	CLICK TWO
	CLICK TWO
	Sleep    5s
	CLICK SIX
	CLICK ZERO
	Sleep    2s
	CLICK BACK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	Sleep    3s
	#validate play button
	${Result}  Verify Crop Image  ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed

TC_221_VERIFY_FAVORITE_LIVE_TV
    [Tags]    LIVE TV
    [Documentation]    Verifies Manage Favorite
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
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
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    5s
	CLICK DOWN
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
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
	CLICK OK
	Sleep    2s
	#validate the success pop up in the screen
	${Result}  Verify Crop Image  ${port}  Success_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Success_Popup Is Displayed
	...  ELSE  Fail  Success_Popup Is Not Displayed
	CLICK OK

TC_208_VERIFY_AUDIO_LANGUAGE_CHANGE
    [Tags]    LIVE TV
    [Documentation]    Verifies Audio Language
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK SEVEN
	CLICK ONE
	CLICK ZERO
	CLICK FIVE
	Sleep    2s
    CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Audio Launguage On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep    3s
    #validate language change
	${Result}  Verify Crop Image  ${port}  Audio
	Run Keyword If  '${Result}' == 'True'  Log To Console  Audio Is Displayed
	...  ELSE  Fail  Audio Is Not Displayed
    CLICK DOWN
	CLICK OK
TC_726_VERIFY_CATCHUP_STOP_SWITCH_LIVETV_RESUME
    [Tags]    CATCHUP
    [Documentation]    Verifies Catch Up Channel
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${STEP_COUNT}=    Move to Add To List On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK OK
	Sleep    10S
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    10S
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    3s
	#VALIADTION - CHECK IF THE RESUME BUTTON IS VISIBLE IN THE SCREEN
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
    CLICK DOWN
	CLICK OK


TC_825_CONFIRM_LAST_VIEWED_POSITION_RETAINS_AFTER_POWER_CYCLE
    CLICK HOME 
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
	#validate profile user
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Log To Console    Profile Created succesfully



######## SCRIPTS FROM STB3 ########

TC_115_PROFILE_SWITCHING_OPTION_HOMEPAGE_WITH_ALL_PROFILES
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
	Sleep    10s
	Log To console    Profile Switched to Admin and home page is loaded
    ${Result}  Verify Crop Image  ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed
	...  ELSE  Fail  Home_Page Is Not Displayed
    DELETE PROFILE

TC_105_VERIFY_HOMEPAGE_CHILD_PROFILE_AGE_APPROPRIATE_CONTENT
	[Tags]      HOMEPAGE
  [Documentation]     Verify child profile content from from Homepage
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
	Sleep   2s 
  Log To Console     Navigated to profile section
	CLICK RIGHT
	CLICK OK
  Log To Console     Navigated to child profile 
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep	20s
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	Sleep	3s
	CLICK THREE
    Sleep   10s
	CLICK UP
	Sleep	5s
	#Validate child channel content text
	#revert
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
	#Needs revist

TC_811_VERIFY_AGE_APPROPRIATE_PROGRAMS_UNDER_CHILD_PROFILE
		[Tags]      GUIDE
    [Documentation]     Verify age appropriate programs under child profile
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
	CLICK RIGHT
	CLICK OK
    Sleep   2s 
    Log To Console     Navigated to profile section
	CLICK RIGHT
	CLICK OK
    Log To Console     Navigated to child profile 
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    Sleep   15s
    Log To Console     Entered PIN
	CLICK UP
	CLICK RIGHT
	CLICK OK
    Log To Console     Navigated to TV
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
    Log To Console     Navigated to TV GUIDE
    Sleep   5s
    # Clicking 3 so that kids channel from 300 any will be selected for validation
    CLICK THREE
    Sleep   10s
	CLICK UP
    #Validate KIDS category
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
	# Needs revisit

TC_001_CREATE_NEW_PROFILE
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
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}  TC_001_Whos_watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_001_Whos_watching Is Displayed
	...  ELSE  Fail  TC_001_Whos_watching Is Not Displayed
	
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_001_Profile_Type
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_001_Profile_Type Is Displayed
	...  ELSE  Fail  TC_001_Profile_Type Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_001_Nickname
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_001_Nickname Is Displayed
	...  ELSE  Fail  TC_001_Nickname Is Not Displayed
	
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
	# CLICK RIGHT
	# ${Result}  Verify Crop Image  ${port}  TC_001_New_profile
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_001_New_profile Is Displayed
	# ...  ELSE  Fail  TC_001_New_profile Is Not Displayed
	
	# CLICK LEFT
	${Result}  Verify Crop Image  ${port}  TC_001_New_logged_in_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_001_New_logged_in_profile Is Displayed
	...  ELSE  Fail  TC_001_New_logged_in_profile Is Not Displayed
	
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
	CLICK OK
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
	${Result}  Verify Crop Image  ${port}  TC_001_Whos_watching_after_deletion
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_001_Whos_watching_after_deletion Is Displayed
	...  ELSE  Fail  TC_001_Whos_watching_after_deletion Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}   TC_001_Whos_watching_after_deletion
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_001_Whos_watching_after_deletion Is Displayed
	...  ELSE  Fail  TC_001_Whos_watching_after_deletion Is Not Displayed
	Sleep    10s 
	CLICK HOME


TC_006_EDIT_PROFILE_SECURITY_CONTROL_ALWAYS_LOGIN_SAME_PROFILE
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
	${Result}  Verify Crop Image  ${port}  TC_006_whos_watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_whos_watching Is Displayed
	...  ELSE  Fail  TC_006_whos_watching Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_006_profile_type
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_profile_type Is Displayed
	...  ELSE  Fail  TC_006_profile_type Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_006_profile_nickname
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_profile_nickname Is Displayed
	...  ELSE  Fail  TC_006_profile_nickname Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_006_New_Profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_New_Profile Is Displayed
	...  ELSE  Fail  TC_006_New_Profile Is Not Displayed
	
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    3s 
	${Result}  Verify Crop Image  ${port}  TC_006_Personal_Details
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Personal_Details Is Displayed
	...  ELSE  Fail  TC_006_Personal_Details Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_006_Security_Controls
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Security_Controls Is Displayed
	...  ELSE  Fail  TC_006_Security_Controls Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_006_Always_login
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Always_login Is Displayed
	...  ELSE  Fail  TC_006_Always_login Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_006_Success
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Success Is Displayed
	...  ELSE  Fail  TC_006_Success Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_006_Logged_Admin
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

TC_007_EDIT_PROFILE_SECURITY_CONTROL_RENTAL_LIMIT
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
	${Result}  Verify Crop Image  ${port}  TC_007_Whos_watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_007_Whos_watching Is Displayed
	...  ELSE  Fail  TC_007_Whos_watching Is Not Displayed
	
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	Sleep    5s 
	${Result}  Verify Crop Image  ${port}  TC_007_Security_Controls
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_007_Security_Controls Is Displayed
	...  ELSE  Fail  TC_007_Security_Controls Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	
	${Result}  Verify Crop Image  ${port}  TC_007_Rental_unlimited
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_007_Rental_unlimited Is Displayed
	...  ELSE  Fail  TC_007_Rental_unlimited Is Not Displayed
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_007_Success
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_007_Success Is Displayed
	...  ELSE  Fail  TC_007_Success Is Not Displayed
	
	CLICK OK
	CLICK HOME

TC_009_PROFILE_TV_EXPERIENCE_SUBTITLE_LANGUAGE_CHANGE
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
	${Result}  Verify Crop Image  ${port}  TC_009_Whos_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_Whos_Watching Is Displayed
	...  ELSE  Fail  TC_009_Whos_Watching Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_009_TV_Experience
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_TV_Experience Is Displayed
	...  ELSE  Fail  TC_009_TV_Experience Is Not Displayed
	
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
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_009_Success
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_Success Is Displayed
	...  ELSE  Fail  TC_009_Success Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_009_English_highlighted
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_English_highlighted Is Displayed
	...  ELSE  Fail  TC_009_English_highlighted Is Not Displayed
	
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK OK
	Sleep    2s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME

TC_017_PROFILE_INTERFACE_SETTINGS_INTERFACE_CLOCK
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
	${Result}  Verify Crop Image  ${port}  Interface_settings
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_settings Is Displayed
	...  ELSE  Fail  Interface_settings Is Not Displayed
	Sleep    3s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image  ${port}  Interface_clock_off
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
	${Result}  Verify Crop Image  ${port}  Interface_clock_success
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_clock_success Is Displayed
	...  ELSE  Fail  Interface_clock_success Is Not Displayed
	Sleep    3s 
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
	CLICK DOWN
	${Result}  Verify Crop Image  ${port}  Interface_clock_on
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



TC_016_PROFILE_INTERFACE_SETTINGS_BANNER_INTERFACE_TIMEOUT
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
	${Result}  Verify Crop Image  ${port}  Interface_settings
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_settings Is Displayed
	...  ELSE  Fail  Interface_settings Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image  ${port}  Interface_timeout_10secs
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
	${Result}  Verify Crop Image  ${port}  Interface_timeout_success
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_timeout_success Is Displayed
	...  ELSE  Fail  Interface_timeout_success Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  Interface_timeout_5secs
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
	Sleep    3s 
	CLICK OK
	CLICK HOME
TC_501_DISPLAY_BASED_ON_VOD_TYPE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_501_On_Demand_Collection
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_501_On_Demand_Collection Is Displayed
	...  ELSE  Fail  TC_501_On_Demand_Collection Is Not Displayed
	
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT

TC_012_PROFILE_TV_EXPERIENCE_HIDE_CHANNEL
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
	${Result}  Verify Crop Image  ${port}  TC_012_Whos_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_012_Whos_Watching Is Displayed
	...  ELSE  Fail  TC_012_Whos_Watching Is Not Displayed
	
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s 
	${Result}  Verify Crop Image  ${port}  TC_012_TV_Experience
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_012_TV_Experience Is Displayed
	...  ELSE  Fail  TC_012_TV_Experience Is Not Displayed
	
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
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
	${Result}  Verify Crop Image  ${port}  TC_012_Success
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_012_Success Is Displayed
	...  ELSE  Fail  TC_012_Success Is Not Displayed
	
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
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}  TC_012_Hide_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_012_Hide_Channel Is Displayed
	...  ELSE  Fail  TC_012_Hide_Channel Is Not Displayed
	
	CLICK OK
	CLICK UP
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

TC_011_PROFILE_TV_EXPERIENCE_CHANNELS_LOCK
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
	${Result}  Verify Crop Image  ${port}  TC_011_Whos_watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_011_Whos_watching Is Displayed
	...  ELSE  Fail  TC_011_Whos_watching Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_011_TV_Experience
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_011_TV_Experience Is Displayed
	...  ELSE  Fail  TC_011_TV_Experience Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
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
	${Result}  Verify Crop Image  ${port}  TC_011_Success
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_011_Success Is Displayed
	...  ELSE  Fail  TC_011_Success Is Not Displayed
	
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
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image  ${port}  TC_011_Locked_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_011_Locked_Channel Is Displayed
	...  ELSE  Fail  TC_011_Locked_Channel Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK OK
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
	Sleep    5s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
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
	${Result}  Verify Crop Image  ${port}  TC_013_Whos_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_013_Whos_Watching Is Displayed
	...  ELSE  Fail  TC_013_Whos_Watching Is Not Displayed
		
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
	${Result}  Verify Crop Image  ${port}  TC_013_TV_Experience
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_013_TV_Experience Is Displayed
	...  ELSE  Fail  TC_013_TV_Experience Is Not Displayed

	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image  ${port}  TC_013_AD_Default_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_013_AD_Default_Value Is Displayed
	...  ELSE  Fail  TC_013_AD_Default_Value Is Not Displayed
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_013_Success
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_013_Success Is Displayed
	...  ELSE  Fail  TC_013_Success Is Not Displayed
	
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
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image  ${port}  TC_013_After_AD_Edit
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_013_After_AD_Edit Is Displayed
	...  ELSE  Fail  TC_013_After_AD_Edit Is Not Displayed
	
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME

TC_014_PROFILE_INTERFACE_SETTING_RECORDING_STORAGE_SELECTION
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
	${Result}  Verify Crop Image  ${port}  TC_014_Whos_watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_014_Whos_watching Is Displayed
	...  ELSE  Fail  TC_014_Whos_watching Is Not Displayed
	
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
	Sleep    2s 
	CLICK DOWN
	CLICK UP
	${Result}  Verify Crop Image  ${port}  TC_014_Interface_Setting
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_014_Interface_Setting Is Displayed
	...  ELSE  Fail  TC_014_Interface_Setting Is Not Displayed
	
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_014_Local_selected
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_014_Local_selected Is Displayed
	...  ELSE  Fail  TC_014_Local_selected Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_014_Success
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_014_Success Is Displayed
	...  ELSE  Fail  TC_014_Success Is Not Displayed
	
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
	Sleep    2s 
	${Result}  Verify Crop Image  ${port}  TC_014_Navigated_To_Interface_Setting
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_014_Navigated_To_Interface_Setting Is Displayed
	...  ELSE  Fail  TC_014_Navigated_To_Interface_Setting Is Not Displayed
	
	CLICK DOWN
	${Result}  Verify Crop Image  ${port}  TC_014_Local_Storage_Updated
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_014_Local_Storage_Updated Is Displayed
	...  ELSE  Fail  TC_014_Local_Storage_Updated Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME




TC_018_PROFILE_INTERFACE_SETTING_CHANNEL_STYLE
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
	${Result}  Verify Crop Image  ${port}  TC_018_Whos_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_Whos_Watching Is Displayed
	...  ELSE  Fail  TC_018_Whos_Watching Is Not Displayed
	
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
	Sleep    2s 
	CLICK DOWN
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}  TC_018_Default_Channel_Style
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_Default_Channel_Style Is Displayed
	...  ELSE  Fail  TC_018_Default_Channel_Style Is Not Displayed
	
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
	Sleep    2s 
	${Result}  Verify Crop Image  ${port}  TC_018_Interface_Setting
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_Interface_Setting Is Displayed
	...  ELSE  Fail  TC_018_Interface_Setting Is Not Displayed
	
	CLICK DOWN
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}  TC_018_Channel_Style_Updated
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_Channel_Style_Updated Is Displayed
	...  ELSE  Fail  TC_018_Channel_Style_Updated Is Not Displayed
	
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_018_Success
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_Success Is Displayed
	...  ELSE  Fail  TC_018_Success Is Not Displayed
	
	CLICK OK
	CLICK HOME

TC_019_CONFIRM_PROFILE_DELETION
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
	${Result}  Verify Crop Image  ${port}  TC_019_Whos_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_019_Whos_Watching Is Displayed
	...  ELSE  Fail  TC_019_Whos_Watching Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_019_Nickname
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_019_Nickname Is Displayed
	...  ELSE  Fail  TC_019_Nickname Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_019_Profile_Created
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
	${Result}  Verify Crop Image  ${port}  TC_019_Profile_Deleted
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_019_Profile_Deleted Is Displayed
	...  ELSE  Fail  TC_019_Profile_Deleted Is Not Displayed
	Sleep    2s 
	CLICK HOME

TC_022_CREATE_PROFILE_WITH_CUSTOM_AVATAR
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
	${Result}  Verify Crop Image  ${port}  TC_022_Whos_watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_022_Whos_watching Is Displayed
	...  ELSE  Fail  TC_022_Whos_watching Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_022_Profile_Type
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_022_Profile_Type Is Displayed
	...  ELSE  Fail  TC_022_Profile_Type Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_022_Nickname
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_022_Nickname Is Displayed
	...  ELSE  Fail  TC_022_Nickname Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_022_Custom_avatar_selected
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_022_Custom_avatar_selected Is Displayed
	...  ELSE  Fail  TC_022_Custom_avatar_selected Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
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
	${Result}  Verify Crop Image  ${port}  TC_022_Custom_Avatart_Updated
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_022_Custom_Avatart_Updated Is Displayed
	...  ELSE  Fail  TC_022_Custom_Avatart_Updated Is Not Displayed
	
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    5s 
	CLICK UP
	CLICK RIGHT
	CLICK OK
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
	Sleep    3s 
	CLICK TWO
	CLICK TWO
	Sleep    3s 
	CLICK SEVEN
	CLICK ZERO
	CLICK ZERO
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
	${Result}  Verify Crop Image  ${port}  TC_022_Navigated_to_Admin
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_022_Navigated_to_Admin Is Displayed
	...  ELSE  Fail  TC_022_Navigated_to_Admin Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_022_Profile_deleted
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_022_Profile_deleted Is Displayed
	...  ELSE  Fail  TC_022_Profile_deleted Is Not Displayed
	
	CLICK HOME

Rec_play_Test
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image  ${port}  verify_on_demand
	Run Keyword If  '${Result}' == 'True'  Log To Console  verify_on_demand Is Displayed
	...  ELSE  Fail  verify_on_demand Is Not Displayed
	
	CLICK OK
	${Result}  Verify Crop Image  ${port}  On_Demand_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  On_Demand_Page Is Displayed
	...  ELSE  Fail  On_Demand_Page Is Not Displayed
	
	${Result}  Verify Crop Image  ${port}  E_and_guide
	Run Keyword If  '${Result}' == 'True'  Log To Console  E_and_guide Is Displayed
	...  ELSE  Fail  E_and_guide Is Not Displayed
	
	CLICK DOWN
	CLICK OK
