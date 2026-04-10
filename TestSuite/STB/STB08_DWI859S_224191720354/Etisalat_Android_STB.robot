*** Settings ***
Resource    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Robot/STB/Android_STB/etisalat.robot
Resource    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Robot/STB/Android_STB/Demo_Keywords.robot

Library   /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/Etisalat_Android_STB1/TeardownStatusTC.py
Library   /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/Etisalat_Android_STB1/generic.py
Library   DateTime
Library    Process
Library		SeleniumLibrary


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
	# Pre Check STB Health
 
Test Level Teardown
    #end time & each test case execution result
    ${end_time}  GET TIME
    #Log To Console  ${TEST NAME}:${exdict}[${TEST NAME}]
    #Log To Console  ${exdict}
    run keyword if test passed  TeardownStatusTC.Evaluate_time_result  ${exdict}[${TEST NAME}]  Pass  ${start_time}  ${end_time}
    run keyword if test failed  TeardownStatusTC.Evaluate_time_result  ${exdict}[${TEST NAME}]  Fail  ${start_time}  ${end_time}


*** Test Cases ***


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
    Sleep    2s
    Log To Console    Channel Zapping with Channel Minus
	CLICK CHANNELDWN
	CLICK CHANNELDWN
	CLICK CHANNELDWN
	CLICK CHANNELDWN
	CLICK CHANNELDWN
	#validate the channel number 7101
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_203_Channel_7101
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel_Number_7101 Is Displayed
	...  ELSE  Fail  Channel_Number_7101 Is Not Displayed	
    Log To Console    Channel Zapping with Channel Plus
	CLICK CHANNELUP
	CLICK CHANNELUP
	CLICK CHANNELUP
	CLICK CHANNELUP
	CLICK CHANNELUP
    #image validation for zapping - verify channel number 1
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Chnl_1
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel_Number_1 Is Displayed
	...  ELSE  Fail  Channel_Number_1 Is Not Displayed	
	CLICK HOME

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
    CLICK BACK
	CLICK SEVEN
	CLICK TWO
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_204_Channel_72
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_204_Channel_72 Is Displayed
	...  ELSE  Fail  TC_204_Channel_72 Is Not Displayed
	Sleep    2s
    # CLICK BACK
	VALIDATE VIDEO PLAYBACK
	CLICK RIGHT
	# CLICK DOWN
	${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	Sleep    3s
    Log To Console    Verify Playback After Zapping Through Numeric Keys
	#image validation required 
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	CLICK BACK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME

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
	CLICK DOWN
	CLICK OK
	Sleep    3s
	CLICK RIGHT
	Sleep    2s
	CLICK OK
	FOR    ${i}    IN RANGE    5
		${Pause}=    Verify Crop Image With Shorter Duration    ${port}    Pause_Side_Panel
		Log To Console    [Iteration ${i}] Pause Icon Found: ${Pause}
		Run Keyword If    '${Pause}' == 'False'    Run Keywords
		...    Log To Console    → Pause not found, going to next program
		...    AND    Click BACK
		...    AND    Click DOWN
		...    AND    Click OK
		...    AND    Sleep    1s
		...    AND    Continue For Loop
		
		Run Keyword If    '${Pause}' == 'True'    Run Keywords
		...    Log To Console    → Pause found, Proceeding to click
		...    AND    Click DOWN
		...    AND    Click OK
		...    AND    Sleep    1s
		...    AND    Exit For Loop
	END
	Sleep    3s
    #Verify Play Button
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	CLICK OK
	CLICK BACK
	VALIDATE VIDEO PLAYBACK
    CLICK HOME

TC_207_VERIFY_MOSAIC_CHANNEL
    [Tags]    LIVE TV
    [Documentation]    Verifies Mosaic Nature Of Channel
	CLICK HOME
	CLICK ZERO
	CLICK ZERO
	CLICK SEVEN
	#image capture to valiadte channel number
	# ${Result}  Verify Crop Image  ${port}  TC_207_007_Channel
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_207_007_Channel Is Displayed
	# ...  ELSE  Fail  TC_207_007_Channel Is Not Displayed
	VALIDATE IMAGE ON NAVIGATION    RIGHT
	VALIDATE IMAGE ON NAVIGATION    RIGHT
	VALIDATE IMAGE ON NAVIGATION    DOWN
	Click Ok
	VALIDATE VIDEO PLAYBACK
	# Check for 008 channel
	CLICK ZERO
	CLICK ZERO
	CLICK EIGHT
	#image capture to valiadte channel number
	# ${Result}  Verify Crop Image  ${port}  TC_207_008_Channel
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_207_008_Channel Is Displayed
	# ...  ELSE  Fail  TC_208_007_Channel Is Not Displayed
	VALIDATE IMAGE ON NAVIGATION    DOWN
	VALIDATE IMAGE ON NAVIGATION    RIGHT
	VALIDATE IMAGE ON NAVIGATION    RIGHT
	Click Ok
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME


TC_206_VERIFY_ZAPPING_DURABILITY
	[Tags]	LIVE TV
	[Documentation]    Verifies channel zapping endurance
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	CLICK OK
	CLICK BACK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME


TC_208_VERIFY_AUDIO_LANGUAGE_CHANGE
	[Tags]	LIVE TV
	[Documentation]	 Verifies the Audio Language
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
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Audio
	Run Keyword If  '${Result}' == 'True'  Log To Console  Audio Is Displayed
	...  ELSE  Fail  Audio Is Not Displayed
    CLICK DOWN
	CLICK OK
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
	CLICK SEVEN
	CLICK TWO
	Sleep    1s
	CLICK Back
	VALIDATE VIDEO PLAYBACK
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_210_Mute
	Run Keyword If  '${Result}' == 'True'  Log To Console  Mute_Remote_Button Is Displayed
	...  ELSE  Fail  Mute_Remote_Button Is Not Displayed
	#check for mute button
	Log To Console    Volume Is Decreased
	CLICK VOLUP
	CLICK VOLUP
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_210_Volume
	Run Keyword If  '${Result}' == 'True'  Log To Console  Mute_Remote_Button Is Displayed
	...  ELSE  Fail  Mute_Remote_Button Is Not Displayed
	#check for volume increase
	Log To Console    Volume Is Increased
	CLICK MUTE
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_210_Mute
	Run Keyword If  '${Result}' == 'True'  Log To Console  Mute_Remote_Button Is Displayed
	...  ELSE  Fail  Mute_Remote_Button Is Not Displayed
	Log To Console    Volume is Muted
	CLICK MUTE
	#checkk for volume bar
	Log To Console    Volume is Unmuted	
	CLICK HOME


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
	CLICK TWO
	CLICK FOUR
	CLICK SEVEN
	Sleep    2s
	CLICK BACK
	CLICK RIGHT
	Log To Console    Side Bar Is Displayed
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_211_Add_To_Favorites
	Run Keyword If  '${Result}' == 'True'  Log To Console  Favorite_pop_up  Is Displayed
	...  ELSE  Fail  Favorite_pop_up Is Not Displayed
	Log To Console    Add To Favorites Option Is Selected
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
	FOR    ${i}    IN RANGE    20
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    TC_211_Favorites_Feed
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    Favorites feed is displayed
    ...    AND    Exit For Loop

    CLICK RIGHT
    Sleep    0.2s
    END
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_214_Star_Bharat_Channel
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	# ...  ELSE  Fail  Channel Is Not Displayed
	
	CLICK TWO
	CLICK FOUR
	CLICK SEVEN
	Sleep    2s
	CLICK BACK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK OK
    CLICK HOME

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
	CLICK SEVEN
	CLICK ONE
	CLICK ZERO
	CLICK TWO
	CLICK BACK
	CLICK RIGHT
	Log To Console    Side Bar Is Displayed
	CLICK OK
	CLICK OK
	Log To Console    Selecting The Favorites list
	CLICK SEVEN
	CLICK ONE
	CLICK ZERO
	CLICK TWO
	CLICK BACK
	CLICK RIGHT
    CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK RIGHT
	# verify the sidebar - there should not be remove from favorites
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    Rmv_Fav
	Run Keyword If    '${Result}' == 'True'    Fail    Remove_From_Fav should not be displayed
	Run Keyword If    '${Result}' != 'True'    Log To Console    Remove_From_Fav is not displayed, as expected
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
    CLICK SEVEN
	CLICK ONE
	CLICK ZERO
	CLICK TWO
    Log To Console    Navigated To Channel 7102
    Sleep    1s
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed	
	CLICK OK
	CLICK BACK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME

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
	CLICK BACK
	CLICK RIGHT
    ${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Playback Started From Beginning
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_214_Start_time
	Run Keyword If  '${Result}' == 'True'  Log To Console  Starting Timestamp Is Displayed
	...  ELSE  Fail  Starting Timestamp Is Not Displayed	
    CLICK HOME
	CLICK OK
	CLICK HOME

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
	CLICK TWO
    Log To Console    Navigated To Channel 7102
	CLICK BACK
	CLICK RIGHT
	Sleep    1s
    ${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
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
    ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_215_Recording_Started
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Started Is Displayed
	...  ELSE  Fail  TC_215_Recording_Started Is Not Displayed	
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
	CLICK OK
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_215_Recording_Stopped
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Stopped Is Displayed
	...  ELSE  Fail  TC_215_Recording_Stopped Is Not Displayed	
	Log To Console    Recording Stopped
	CLICK OK
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
	CLICK OK
    Log To Console    Navigated To Catch up section all channels
	CLICK OK
	CLICK LEFT
	CLICK OK
    Log To Console    Catchup Selected
	CLICK DOWN
	CLICK OK
	sleep	2s
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	CLICK OK
	CLICK BACK
	VALIDATE VIDEO PLAYBACK
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
	CLICK BACK
	CLICK RIGHT
    Log To Console    Navigated To More Details Section
    Sleep    3s
	#image validation
	${STEP_COUNT}=    Move to More Details On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_217_TV_Live
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_217_TV_Live Is Displayed
	...  ELSE  Fail  TC_217_TV_Live Is Not Displayed
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
    Log To Console    Displayed Search Results 
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_218_MBC_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel Is Displayed
	...  ELSE  Fail  Channel Is Not Displayed
	CLICK HOME
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_219_Audio
	Run Keyword If  '${Result}' == 'True'  Log To Console  Audio Is Displayed
	...  ELSE  Fail  Audio Is Not Displayed
	Log To Console    Audio Section Is Selected
	# CLICK OK	
	CLICK DOWN
	CLICK OK
    # check for the language 
	Log To Console    Audio Language Changed
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Subtitle_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Subtitle_Popup Is Displayed
	...  ELSE  Fail  Subtitle_Popup Is Not Displayed
	# check for the subtile present
	Log To Console    Subtitles Appeared In The Screen
   	CLICK OK
	CLICK HOME

TC_221_VERIFY_FAVORITE_LIVE_TV
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_221_Manage_Favorites
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_Manage_Favorites Is Displayed
	...  ELSE  Fail  TC_221_Manage_Favorites Is Not Displayed
	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_221_Admin_Pin_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_Admin_Pin_Popup Is Displayed
	...  ELSE  Fail  TC_221_Admin_Pin_Popup Is Not Displayed
	
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_221_TV_Experience
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_TV_Experience Is Displayed
	...  ELSE  Fail  TC_221_TV_Experience Is Not Displayed
	
	CLICK DOWN
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  TC_221_Fav_Screen
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Favorite Screen Is Displayed
	# ...  ELSE  Fail  Favorite Screen Is Not Displayed
	
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
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
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_221_Success_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_221_Success_Popup Is Displayed
	...  ELSE  Fail  TC_221_Success_Popup Is Not Displayed
	
	CLICK OK
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
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
	CLICK OK
	CLICK OK
	CLICK HOME


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
	# Sleep    1s
    #image validation of seekbar found
	${Result}  Verify Crop Image With Shorter Duration 	${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
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
	${STEP_COUNT}=    Move to Filter On Side Pannel
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
	CLICK BACK
	#Selecting yesterday program
	CLICK RIGHT
	CLICK RIGHT
	CLICK UP
	CLICK OK
	CLICK LEFT
	CLICK OK

	# CLICK BACK
	# CLICK RIGHT
	# CLICK OK
	# ${STEP_COUNT}=    Move to Filter On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	CLICK DOWN
    CLICK OK
	Log To Console    Content Accessed From EPG
	# Sleep	1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Play_Button
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
	CLICK HOME
	Check For Exit Popup
	CLICK HOME



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
	CLICK LEFT
	CLICK OK
    Log To Console    Selected Catch Up Playback
	CLICK DOWN
	CLICK OK
    Log To Console    Video Streaming Paused
    Sleep    10s
	CLICK OK
    Log To Console    Video Streaming Resumed
    #verify playback - play button
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	CLICK OK
	Sleep	2s
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
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
	CLICK LEFT
	CLICK OK
    Log To Console    Selected Catch Up Playback
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  x4_Forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  x4_Forward Is Displayed
	...  ELSE  Fail  x4_Forward Is Not Displayed
	CLICK OK
	# validate 8x fastforward 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  x8_Forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  x8_Forward Is Displayed
	...  ELSE  Fail  x8_Forward Is Not Displayed
	Log To Console    8x fastforward 
    Sleep    1s
	CLICK OK
	# validate 16x fastforward 
	${Result}  Verify Crop Image With Shorter Duration   ${port}  x16_Forward
	Run Keyword If  '${Result}' == 'True'  Log To Console  x16_Forward Is Displayed
	...  ELSE  Fail  x16_Forward Is Not Displayed
    Log To Console    Playback Progressed Forward
    #check for 4x,8x,16x visibility in seekbar
    CLICK LEFT
    CLICK OK
    Log To Console    Video Playback Resumed
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

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
	CLICK LEFT
	CLICK LEFT
	CLICK OK
    Log To Console    Selected Catch Up Playback
	CLICK DOWN
	CLICK OK
	Sleep	10s
	CLICK OK
	CLICK LEFT
	CLICK OK
    Log To Console    Returned To A Previous Timestamp
	${Result}  Verify Crop Image With Shorter Duration  ${port}  REWIND_4X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_4X Is Displayed
	...  ELSE  Fail  REWIND_4X Is Not Displayed
    Log To Console    Video Playback Resumed	
	CLICK RIGHT
	CLICK OK
	Sleep 	2s
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

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
	CLICK LEFT
	CLICK OK
    Log To Console    Navigated To Catch Up Feed
	CLICK DOWN
	CLICK OK
    Log To Console    Stopped Catch Up Playback
    Sleep    10s
	CLICK BACK
    #validation - check for tv>catchup in the screen
	Log To Console    Playback Stopped And Returned Back To Catch Up
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_706_ALL_chnl
	Run Keyword If  '${Result}' == 'True'  Log To Console  Catch_Up_AllChannels_Page Is Displayed
	...  ELSE  Fail  Catch_Up_AllChannels_Page Is Not Displayed
	CLICK HOME
	Check For Exit Popup
	CLICK HOME



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
	CLICK LEFT
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
	${Result}  Verify Crop Image With Shorter Duration 	${port}  Subtitle_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Subtitle_Popup Is Displayed
	...  ELSE  Fail  Subtitle_Popup Is Not Displayed
	CLICK OK	
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

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
	CLICK LEFT
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Audio_Launguage
	Run Keyword If  '${Result}' == 'True'  Log To Console  Audio_Launguage Is Displayed
	...  ELSE  Fail  Audio_Launguage Is Not Displayed
    Log To Console    Accessed The Audio Button In The Screen
	# CLICK DOWN
	# CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
    
TC_710_VERIFY_CATCHUP_UNAVAILABLE_PROGRAM_OUTSIDE_SUPPORTED_WINDOW
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
	#validation - blank screen
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_710_Blank_Screen
	Run Keyword If  '${Result}' == 'True'  Log To Console  Blank_Screen Is Displayed
	...  ELSE  Fail  Blank_Screen Is Not Displayed
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

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
	CLICK LEFT
	CLICK OK
    Log To Console    Selected Catch Up Playback
	# ${STEP_COUNT}=    Move to Add To List On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	# ${STEP_COUNT}=    6
	# # CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_711_ADD_to_list
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_711_ADD_to_list Is Displayed
	...  ELSE  Fail  TC_711_ADD_to_list Is Not Displayed
	CLICK OK
	Sleep	1s
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated To My List Section
	CLICK OK
    Log To Console    Accessed My List Content

	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
    VALIDATE VIDEO PLAYBACK
    CLICK HOME
	Check For Exit Popup
	#revert back
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
    #Remove the content in My list section

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
	CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
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
	CLICK LEFT
	CLICK OK
    Log To Console    Selected Catch Up Playback
	CLICK DOWN
	CLICK OK
    # Check for the pause button

    Log To Console    Browsed Catch Up Categories And Initiated Content Playback
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

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
	CLICK LEFT
	CLICK OK
    Log To Console    Navigated To Catch Up Feed
	CLICK DOWN
	CLICK OK
    #validation - look for the timestamp in the seekbar in the screen
    Log To Console    Catch Up Played And Verified Seek Bar With Timestamp
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

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
	CLICK LEFT
	CLICK LEFT 
	CLICK OK
    Log To Console    Navigated To Catch Up Feed
	CLICK DOWN
	CLICK OK
    Log To Console    Catch Up Playback Started
    Sleep    5s
	CLICK BACK
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
	CLICK DOWN
	CLICK OK
    #check for recommended feed and verify that it matched with the recently watched programs
    Log To Console    Navigated To Recommended Feed And Content Played
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

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
	CLICK LEFT
	CLICK LEFT
    #validation- verify yesterday text in the screen
    Log To Console    Recently Aired Content Is Playing
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_718_YesterDay
	Run Keyword If  '${Result}' == 'True'  Log To Console  Yesterday_text_on_Catchup Is Displayed
	...  ELSE  Fail  Yesterday_text_on_Catchup Is Not Displayed
	CLICK OK
	CLICK DOWN
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME


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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_724_KIDS
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_724_KIDS Is Displayed
	...  ELSE  Fail  TC_724_KIDS Is Not Displayed
	CLICK OK
	CLICK DOWN
	CLICK OK
    Log To Console    Browsed Catch Up Categories And Initiated Content Playback
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_726_VERIFY_CATCHUP_STOP_SWITCH_LIVETV_RESUME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK DOWN
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
	CLICK LEFT
	CLICK LEFT
	CLICK OK
   	CLICK DOWN
	CLICK OK
	#VALIADTION - CHECK IF THE RESUME BUTTON IS VISIBLE IN THE SCREEN
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
TC_713_VERIFY_PARENTAL_CONTROL_BLOCK_A_RESTRICTED_CATCHUP_PROGRAM
    [Tags]    CATCHUP
    [Documentation]    Verify parental control blocks restricted catchup
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
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK OK
	CLICK UP
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
	CLICK OK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	${pin}  Verify Crop Image  ${port}     TC_713_Parental
    Log To Console    login: ${pin}
    IF    '${pin}'=='True'    
	    CLICK BACK
		CLICK UP
		CLICK UP
	END
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	parental_block
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    1s
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	VALIDATE VIDEO PLAYBACK
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
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK LEFT
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

TC_727_CHECK_CATCHUP_RECENTLY_WATCHED_SECTION_WITH_PROFILE_SPECIFIC_HISTORY
    [Tags]    CATCHUP
    [Documentation]    Verify parental control blocks restricted catchup
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	FOR    ${i}    IN RANGE    25
    ${Result}=    Verify Crop Image    ${port}    TC_727_LAST_WATCHED
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ TC_727_LAST_WATCHED is displayed
    ...    AND    Exit For Loop

    CLICK RIGHT
    END

    Run Keyword If    '${Result}' != 'True'    Fail    ❌ TC_727_LAST_WATCHED is not displayed after navigating right
    Log To Console  Navigating through Trending section
    CLICK RIGHT
	CLICK OK
	VALIDATE VIDEO PLAYBACK
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	Sleep    30s
	CLICK POWER
	Sleep    10s
	CLICK POWER
	Sleep    20s
	Check Who's Watching login
	CLICK OK
	Sleep    2s
	CLICK BACK
	CLICK DOWN
	CLICK OK
	Sleep    2s
	VALIDATE VIDEO PLAYBACK
	CLICK HOME

TC_722_CHECK_TRENDING_CATCHUP
    [Tags]    CATCHUP
    [Documentation]    Verify Trending section
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	# validate Trending section page
	FOR    ${i}    IN RANGE    25
    ${Result}=    Verify Crop Image    ${port}    Trending_Section
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
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME

####################################################################################

TC_501_DISPLAY_BASED_ON_VOD_TYPE
	[Tags]	VOD
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_502_ACTION
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_502_ACTION Is Displayed
	...  ELSE  Fail  TC_502_ACTION Is Not Displayed
	CLICK Ok
	
	${pin}  Verify Crop Image With Shorter Duration   ${port}  Pin_Block
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
	VALIDATE VIDEO PLAYBACK
	
	CLICK Back
	Click Back
	CLICK DOWN
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_501_ADVENTURE
	Run Keyword If  '${Result}' == 'True'  Log To Console   TC_501_ADVENTURE Is Displayed
	...  ELSE  Fail  TC_501_ADVENTURE Is Not Displayed
	CLICK Ok
	${pin}  Verify Crop Image With Shorter Duration   ${port}  Pin_Block
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
	
	VALIDATE VIDEO PLAYBACK
	CLICK Home



TC_502_BROWSE_ONDEMAND_INITIATE_PLAYBACK
	[Tags]	VOD
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
	CLICK Ok
	${pin}  Verify Crop Image With Shorter Duration   ${port}  Pin_Block
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
	...        AND    CLICK OK
	CLICK Ok
	VALIDATE VIDEO PLAYBACK
	CLICK Home

TC_503_SEARCH_VOD_INITIATE_PLAYBACK_FROM_SEARCH
	[Tags]	VOD
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
	${pin}  Verify Crop Image With Shorter Duration   ${port}  Pin_Block
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
	# is_playback_active(capture_screen)
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	Sleep	10s
    CLICK HOME

TC_504_VOD_PAUSE_RESUME
	[Tags]	VOD
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    Log To Console	Navigated To On_Demand_Collections
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	${pin}  Verify Crop Image With Shorter Duration   ${port}  Pin_Block
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
	Sleep	5s
	VALIDATE VIDEO PLAYBACK
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME

TC_505_VOD_FAST_FORWARD_RESUME
	[Tags]	VOD
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Right
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_505_4x_ff
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_4x_ff Is Displayed
	...  ELSE  Fail  TC_505_4x_ff Is Not Displayed
	# CLICK LEFT
	# CLICK OK
	# CLICK RIGHT
	CLICK OK
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_505_8x_ff
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_8x_ff Is Displayed
	# ...  ELSE  Fail  TC_505_8x_ff Is Not Displayed
	# CLICK LEFT
	# CLICK OK
	# CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_505_16xff
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_16xff Is Displayed
	# ...  ELSE  Fail  TC_505_16xff Is Not Displayed
	# CLICK LEFT
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK Home

TC_506_VOD_REWIND_RESUME
	[Tags]	VOD
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Ok
	Sleep    1s
	CLICK Ok
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC506_-4X_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-4X_rewind Is Displayed
	...  ELSE  Fail  TC506_-4X_rewind Is Not Displayed
	CLICK RIGHT
	CLICK Ok
	CLICK LEFT
	CLICK Ok
	CLICK Ok
	# ${Result}  Verify Crop Image With Shorter Duration  ${port}  TC506_-8x_rewind
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-8x_rewind Is Displayed
	# ...  ELSE  Fail  TC506_-8x_rewind Is Not Displayed
	CLICK RIGHT
	CLICK Ok
	CLICK LEFT
	CLICK Ok
	CLICK Ok
	CLICK Ok
	# ${Result}  Verify Crop Image  ${port}  TC506_-16x_rewind
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-16x_rewind Is Displayed
	# ...  ELSE  Fail  TC506_-16x_rewind Is Not Displayed
	CLICK RIGHT
	CLICK Ok
	CLICK Home


TC_507_STOP_VOD_MID_PLAYBACK_CONFIRM_EXIT_VOD_LIBRARY
	[Tags]	VOD
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
	${pin}  Verify Crop Image With Shorter Duration   ${port}  Pin_Block
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
	...        AND    CLICK OK
	CLICK OK
	Sleep	5s
	VALIDATE VIDEO PLAYBACK
	CLICK BACK
    Log To Console	Displaying Vod Library
	CLICK BACK
    Sleep   1s
    #validate  vod library page 
	CLICK BACK
    Log To Console	Displaying Home page
	CLICK HOME

TC_508_VERIFY_VOD_SUBTITLE_CHANGE
	[Tags]	VOD
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
	CLICK HOME
	
TC_513_RESUME_PARTIAL_WATCHED_VOD_FROM_CONTINUE_WATCHING
	[Tags]	VOD
	CLICK HOME
    Log to Console    Navigated to Home page
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK OK
    # CLICK DOWN
	CLICK OK
    Log To Console  Playing from continue watching
	# Sleep    3s
    # validate play
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK HOME

TC_523_VERIFY_TRENDING_SECTION_TRY_TRENDING_VOD
	[Tags]	VOD
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    3s
	# validate Trending section page
	FOR    ${i}    IN RANGE    25
    ${Result}=    Verify Crop Image    ${port}    Trending_Section
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
    ...    Run Keywords
    ...    Log To Console    Naviagted to searched video
	...    AND    CLICK OK
	...    AND    CLICK OK
	# CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
    
TC_539_VERIFY_DISPLAY_LAST_VIEWED_VOD
	[Tags]	VOD
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Continue_Watching_Feeds
	Run Keyword If  '${Result}' == 'True'  Log To Console  Continue watching is displayed
	...  ELSE  Fail  Continue watching is not displayed
	CLICK HOME
	
TC_540_VERIFY_DISPLAY_VOD_DETAILS
	[Tags]	VOD
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
	[Tags]	VOD
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Start_Over_Progress_Selected
	Run Keyword If  '${Result}' == 'True'  Log To Console  Start_Over_Progress_Selected Is Displayed
	...  ELSE  Fail  Start_Over_Progress_Selected Is Not Displayed
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

TC_553_VERIFY_VOD_PROGRESS_BAR
	[Tags]	VOD
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed

TC_552_VERIFY_VOD_RESUME
	[Tags]	VOD
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
	[Tags]	VOD
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
	[Tags]	VOD
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
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	Log To Console    navigated to vod section
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	Log To Console    Trailor is clicked
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME


TC_535_VOD_LIVE_PLAYBACK_SWITCH
	[Tags]	VOD
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Ok
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
	CLICK Ok
	CLICK Ok
	CLICK Ok
	VALIDATE VIDEO PLAYBACK
	CLICK Home
	CLICK Home

TC_529_VOD_LIBRARY_KIDS_SECTION_CONTENT
	[Tags]	VOD
	CLICK HOME
	Log to Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    1s
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed
	CLICK BACK
	CLICK RIGHT
	CLICK OK
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed
	CLICK HOME
	
TC_528_VERIFY_RELATED_CONTENT_SECTION
	[Tags]	VOD
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
	[Tags]	VOD
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
	CLICK OK
	Sleep    30s
	CLICK OK
	Log To Console    Checking the Time stamp
    #validate time stamp
	# ${Result}  Verify Crop Image  ${port}  30_Sec_Timestamp
	# Run Keyword If  '${Result}' == 'True'  Log To Console  30_Sec_Timestamp Is Displayed
	# ...  ELSE  Fail  30_Sec_Timestamp Is Not Displayed
	CLICK HOME

TC_511_VERIFY_VOD_ADD_TO_LIST
	[Tags]	VOD
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	#validate succesful remove message
	CLICK OK
	CLICK HOME
	Log To Console    succesfully removed from my list

TC_556_VERIFY_VOD_VOLUME_CONTROL
	[Tags]	VOD
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
	CLICK VOLUP
	Log to Console    VOLUME UP
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	Log to Console    VOLUME DOWN
	Sleep    3s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_210_Mute
	Run Keyword If  '${Result}' == 'True'  Log To Console  Mute Is Displayed
	...  ELSE  Fail  Mute Is Not Displayed	
	CLICK VOLUP
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
	${Result}  Verify Crop Image  ${port}  TC_522_FILTER_ARABIC
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_522_FILTER_ARABIC Is Displayed
	...  ELSE  Fail  TC_522_FILTER_ARABIC Is Not Displayed
	Sleep    1s
	CLICK BACK
    ${Result}  Verify Crop Image  ${port}  TC_522_ARABIC_BROWSE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_522_ARABIC_BROWSE Is Displayed
	...  ELSE  Fail  TC_522_ARABIC_BROWSE Is Not Displayed
	Sleep    1s
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}  TC_522_ARABIC_BROWSE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_522_ARABIC_BROWSE Is Displayed
	...  ELSE  Fail  TC_522_ARABIC_BROWSE Is Not Displayed
	Sleep    1s
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
	CLICK OK
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
	
	CLICK OK
	Sleep    5s
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
	CLICK OK
	Sleep    5s
	VALIDATE VIDEO PLAYBACK


TC_509_SWITCH_AUDIO_TRACKS_DURING_VOD_PLAYBACK
    [Tags]    VOD
	[Documentation]    Switch Audio tracks
	search lionking movie
	Box Office Rentals Buy or rent
	CLICK OK
	pinblock
	checkformat
	resume
	Sleep    5s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK UP
	${Result}  Verify Crop Image  ${port}  tc_508_english
	${none}  Verify Crop Image  ${port}  none
	Log To Console    english: ${Result}
    Log To Console    none: ${none}
    Run Keyword If    '${Result}' == 'True' or '${none}' == 'True'    Log To Console	Subtitle is changed
	...    ELSE  Log To Console    language Is Not Displayed
	...    CLICK OK
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
	${Result}  Verify Crop Image  ${port}  TC_508_arabic
	${none}  Verify Crop Image  ${port}  none
	Log To Console    arabic: ${Result}
    Log To Console    none: ${none}
    Run Keyword If    '${Result}' == 'True' or '${none}' == 'True'    Log To Console	Subtitle is changed
	...    ELSE  Log To Console    language Is Not Displayed
	...    CLICK OK

	CLICK HOME

TC_510_VERIFY_4K_VOD_CONTENT
    [Tags]    VOD
	[Documentation]    verify 4k content
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
	CLICK OK
	pinblock
	CLICK OK
	Sleep    5s
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
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
	${Result}  Verify Crop Image  ${port}  TC_502_ACTION
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_502_ACTION Is Displayed
	...  ELSE  Fail  TC_502_ACTION Is Not Displayed
	CLICK Ok
	Box Office Rentals Buy or rent
	CLICK Ok
	pinblock
	CLICK OK
	#CLICK OK
	VALIDATE VIDEO PLAYBACK
	
	CLICK Back
	Click Back
	CLICK DOWN
	CLICK Ok
	${Result}  Verify Crop Image  ${port}  TC_501_ADVENTURE
	Run Keyword If  '${Result}' == 'True'  Log To Console   TC_501_ADVENTURE Is Displayed
	...  ELSE  Fail  TC_501_ADVENTURE Is Not Displayed

	CLICK Ok
	Box Office Rentals Buy or rent
	CLICK Ok
	pinblock
	CLICK OK
	CLICK OK
	VALIDATE VIDEO PLAYBACK
    CLICK HOME
  
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
    ${Result}=    Verify Crop Image    ${port}    recommended
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
	CLICK OK
	recommendations
	VALIDATE VIDEO PLAYBACK
	CLICK HOME


TC_519_BROWSE_VOD_LIBRARY_AND_VERIFY_RECENTLYADDED_SECTION_WITH_NEW_TITLES
	[Tags]    VOD
	[Documentation]    Browsw VOD and verify Recently added Section  
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    FOR    ${i}    IN RANGE    8
    ${Result}=    Verify Crop Image    ${port}    newrelease
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ Recently Added_Section is displayed
    ...    AND    Exit For Loop

    CLICK RIGHT
    END
    Run Keyword If    '${Result}' != 'True'    Fail    ❌ Recently Added_Section is not displayed after navigating right
    Log To Console  Navigating through Recently Added section
    CLICK RIGHT
    CLICK RIGHT

	Log To Console    Navigated to Recently Added section
	CLICK HOME

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
	VALIDATE VIDEO PLAYBACK
	Sleep    2s
	CLICK POWER
	Sleep    2s
	CLICK POWER
	Sleep    30s
	Check Who's Watching login
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
	VALIDATE VIDEO PLAYBACK
	CLICK HOME

TC_514_VERIFY_PARENTAL_CONTROL_BLOCKS_RESTRICTED_VOD
	[Tags]	  VOD
	[Documentation]    verify parental control Blocks restricted VOD
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
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	SEARCH VOD
	Sleep    2s
	CLICK RIGHT
	CLICK OK
	Sleep    1s
	Box Office Rentals Buy or rent
	CLICK OK
	pinblock
	CLICK OK
	Sleep    5s
	Log To Console    video is playing after entering parental control pin
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
	CLICK OK
	CLICK UP
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
	CLICK HOME
  
TC_541_PURCHASE_VOD
    [Tags]    VOD
    [Documentation]    Verify Purchase VOD 
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
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	Box Office Buy
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
	CLICK LEFT
	CLICK OK
	pinblock
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	Box Office Buy by points
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
    ${Result}=    Verify Crop Image    ${port}    recommended
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

	CLICK OK
	Log To Console    Navigated to Recommended section
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
	${Result}  Verify Crop Image  ${port}  TC_508_arabic
	${none}  Verify Crop Image  ${port}  none
	Log To Console    arabic: ${Result}
    Log To Console    none: ${none}
    Run Keyword If    '${Result}' == 'True' or '${none}' == 'True'    Log To Console	Subtitle is changed
	...    ELSE  Log To Console    language Is Not Displayed
	...    CLICK OK
	

	Sleep    15s
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	${Result}  Verify Crop Image  ${port}  tc_508_english
	${none}  Verify Crop Image  ${port}  none
	Log To Console    english: ${Result}
    Log To Console    none: ${none}
    Run Keyword If    '${Result}' == 'True' or '${none}' == 'True'    Log To Console	Subtitle is changed
	...    ELSE  Log To Console    language Is Not Displayed
	...    CLICK OK
	
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
	${Result}  Verify Crop Image  ${port}  tc_508_english
	${none}  Verify Crop Image  ${port}  none
	Log To Console    english: ${Result}
    Log To Console    none: ${none}
    Run Keyword If    '${Result}' == 'True' or '${none}' == 'True'    Log To Console	Audio language is displayed
	...    ELSE  Log To Console    language Is Not Displayed
	...    CLICK OK

	CLICK HOME
TC_524_VERIFY_TOP_RATED
    [Tags]	  VOD
	[Documentation]	   Filter VOD library by language
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	FOR    ${i}    IN RANGE    25
    ${Result}=    Verify Crop Image    ${port}    TC_524_Top_Rated
    Run Keyword If    '${Result}' == 'True'    Run Keywords
    ...    Log To Console    ✅ Top Rated is displayed
    ...    AND    Exit For Loop
    CLICK RIGHT
    Sleep    0.3s
    END
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	pinblock
	Buy_Top_rated
	Rent_Top_rated
	CLICK OK
	Sleep    5s
	CLICK HOME
TC_526_PLAY_VOD_TITLE_SWITCH_PROFILES_MIDPLAYBACK_VERIFY_SETTINGS_APPLY
	[Tags]	  VOD
	[Documentation]    Switch profiles and verify 
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
	Log To Console  Verifying  TC_003_Who_Watching on Screen
	${Result}  Verify Crop Image  ${port}  TC_003_Who_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_Who_Watching Is Displayed on screen
	...  ELSE  Log To Console  TC_003_Who_Watching Is Not Displayed on screen
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
	CLICK OK
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
	${Result}  Verify Crop Image  ${port}  TC_522_FILTER_ARABIC
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_522_FILTER_ARABIC Is Displayed
	...  ELSE  Log To Console  TC_522_FILTER_ARABIC Is Not Displayed
	Sleep    1s
	CLICK BACK
    ${Result}  Verify Crop Image  ${port}  TC_522_ARABIC_BROWSE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_522_ARABIC_BROWSE Is Displayed
	...  ELSE  Log To Console  TC_522_ARABIC_BROWSE Is Not Displayed
	Sleep    1s
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}  TC_522_ARABIC_BROWSE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_522_ARABIC_BROWSE Is Displayed
	...  ELSE  Log To Console  TC_522_ARABIC_BROWSE Is Not Displayed
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    5s
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
	${Result}  Verify Crop Image  ${port}  TC_526_ARABIC_NONFILTER
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_526_ARABIC_NONFILTER Is Displayed
	...  ELSE  Log To Console  TC_526_ARABIC_NONFILTER Is Not Displayed
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

TC_557_POSITION_CHANGE
    [Tags]    VOD
	[Documentation]    verify seek bar position change
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
	Sleep    10
	CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	Verify ProgressBar

TC_544_ADD_DELETE_FAVORITE
	[Tags]    VOD
	[Documentation]    Add Delete Favorite
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	Log To Console    navigated to vod section
    CLICK Right
	CLICK Right
    CLICK Right
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
    CLICK OK
	CLICK OK
	${Result}  Verify Crop Image  ${port}  addtolist
	Run Keyword If  '${Result}' == 'True'  Log To Console  Asset is added to list
	...  ELSE  Log To Console    Asset is already added to list

	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	Log To Console    navigated to vod section
    CLICK Right
	CLICK Right
    CLICK Right
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
    CLICK OK
	CLICK OK
	${Result}  Verify Crop Image  ${port}  removefromlist
	Run Keyword If  '${Result}' == 'True'  Log To Console  Asset is removed from list
	...  ELSE  Log To Console    Asset is already removed from list
	
	CLICK HOME
	CLICK HOME

#############################################################################

TC_301_TIMESHIFT_PAUSE_RESUME_LIVE
	[Tags]	TIMESHIFT
	[Documentation]		Pause and Resume using Timeshift
	CLICK HOME
	Log To Console    Navigated To Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK THREE
	CLICK THREE
	CLICK THREE
	Sleep	1s
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	CLICK BACK
	VALIDATE VIDEO PLAYBACK
	CLICK UP
	# Log To Console    video is resumed
	${Result}  Verify Crop Image With Shorter Duration		${port}   Play_Button 
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	# Log To Console    video is paused
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

	

TC_302_TIMESHIFT_REWIND_RESUME_LIVE
	[Tags]	TIMESHIFT
	[Documentation]		Rewind and Resume using Timeshift
	CLICK HOME
	Log To Console    Navigated To Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK THREE
	CLICK THREE
	CLICK THREE
	Sleep	1s
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# CLICK DOWN
	CLICK OK
	CLICK LEFT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration		${port}   REWIND_4X 
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_4X Is Displayed
	...  ELSE  Fail  REWIND_4X Is Not Displayed
	Log To Console    video is rewinding in 4x
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration		${port}   REWIND_8X 
	# Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_8X Is Displayed
	# ...  ELSE  Fail  REWIND_8X Is Not Displayed
	Log To Console    video is rewinding in 8x
	CLICK OK
	# ${Result}  Verify Crop Image With Shorter Duration		${port}   REWIND_16X 
	# Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_16X Is Displayed
	# ...  ELSE  Fail  REWIND_16X Is Not Displayed
	Log To Console    video is rewinding in 16x
    Sleep	10s
	CLICK RIGHT
	CLICK OK
	Log To Console    video is resumed
	CLICK BACK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
	
TC_303_TIMESHIFT_PAUSE_FAST_FORWARD_LIVE
	[Tags]	TIMESHIFT
	[Documentation]		Pause and Fast Forward using Timeshift
	CLICK HOME
	Log To Console    Navigated To Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK THREE
	CLICK THREE
	CLICK THREE
	Sleep	1s
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# CLICK DOWN
	# CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	Log To Console    Video is paused
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}   4X_SPEED
	Run Keyword If  '${Result}' == 'True'  Log To Console  4X_SPEED Is Displayed
	...  ELSE  Fail  4X_SPEED Is Not Displayed
	Log To Console    Video is fast forwarding 	
	Sleep    1s
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_304_TIMESHIFT_REWIND_MAXIMUM_TIMESHIFT_BUFFER_LIVE
	[Tags]	TIMESHIFT
	[Documentation]		Rewind and Resume using Timeshift
	CLICK HOME
	Log To Console    Navigated To Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK THREE
	CLICK THREE
	CLICK THREE
	Sleep	1s
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# CLICK DOWN
	CLICK OK
	CLICK LEFT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  REWIND_4X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_4X Is Displayed
	...  ELSE  Fail  REWIND_4X Is Not Displayed
	Log To Console    video is rewinding
	Sleep    10s
	#validate rewind button -4x text
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK OK
	CLICK OK
	CLICK BACK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_305_TIMESHIFT_PAUSE_LIVE_ONE_HOUR_RESUME
	[Tags]	TIMESHIFT
	[Documentation]		Pause the live using Timeshift
	CLICK HOME
	Log To Console    Navigated To Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK THREE
	CLICK THREE
	CLICK THREE
	Sleep	1s
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# CLICK DOWN
	CLICK OK
	Log To Console    Video is paused
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	Sleep    10s
	CLICK OK
	Log To Console    video is resumed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed

    VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_307_REWIND_LIVE_TEN_TIMES_CONSECUTIVELY
	[Tags]	TIMESHIFT
	[Documentation]		Rewind the live using Timeshift
	CLICK HOME
	Log To Console    Navigated To Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK THREE
	CLICK THREE
	CLICK THREE
	Sleep	1s
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# CLICK DOWN
	CLICK OK
	CLICK LEFT
	# Log To Console    rewinding the video
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration		${port}  REWIND_4X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_4X Is Displayed
	...  ELSE  Fail  REWIND_4X Is Not Displayed
	# Sleep    2s
	CLICK OK
	# Sleep    2s
	CLICK OK
	# Sleep    2s
	CLICK OK
	# Sleep    2s
	CLICK OK
	# Sleep    2s
	CLICK OK
	# Sleep    2s
	CLICK OK
	# Sleep    2s
	CLICK OK
	# Sleep    2s
	CLICK OK
	# Sleep    2s
	CLICK Ok
	# Sleep    2s
	Log To Console    video rewinded consecutively for 10 times
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME	

TC_308_PAUSE_FAST_FASTWARD_AT_MAXIMUM_SPEED
	[Tags]	TIMESHIFT
	[Documentation]		Fast Forward the live using Timeshift
	CLICK HOME
	Log To Console    Navigated To Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK THREE
	CLICK THREE
	CLICK THREE
	Sleep	1s
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# CLICK DOWN
	CLICK OK
	Log To Console    video is paused
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	Sleep    10s
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	#validate forward +32x
	Sleep    3s
	# Log To Console    video forwarded 32x times 
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
TC_309_TIMESHIFT_VERIFY_4K_HIGH_BITRATE_CHANNEL
	[Tags]	  TIMESHIFT
	[Documentation]	   Test Timeshift on a HD HIgh Bitrate Channel
	CLICK HOME
	Log To Console    Navigated To home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK SEVEN
	CLICK NINE
	Sleep	1s
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	1s
	CLICK LEFT
	Log To Console    rewinding HD video
	CLICK OK
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC506_-16x_rewind
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC506_-16x_rewind Is Displayed
	...  ELSE  Fail  TC506_-16x_rewind Is Not Displayed
	CLICK RIGHT
	CLICK OK
	Sleep    1s
	CLICK RIGHT
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_505_8x_ff
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_505_8x_ff Is Displayed
	...  ELSE  Fail  TC_505_8x_ff Is Not Displayed
	CLICK LEFT
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME

TC_310_TIMESHIFT_PAUSE_UNTIL_BUFFER_FULL_THEN_PAUSE_AGAIN
	[Tags]	  TIMESHIFT
	[Documentation]	   pause until buffer is full and pause again
	CLICK HOME
	# Log To Console    Navigated To home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK EIGHT
	CLICK NINE
	Sleep	1s
	CLICK BACK
	CLICK RIGHT
	${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep	120s
	CLICK RIGHT
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	# Log To Console    paused the video
	CLICK HOME

TC_311_VERIFY_PAUSE_POWER_CYCLE_RESUME
	[Tags]	  TIMESHIFT
	[Documentation]	   Pause alive stream power off the device then power on and resume
	CLICK HOME
	# Log To Console    Navigated To home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK EIGHT
	CLICK NINE
	Sleep	1s
	CLICK BACK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	Sleep    1s
	CLICK OK
	CLICK POWER
	Sleep	1s
	CLICK POWER
	Sleep	40s
    CLICK OK
	CLICK OK
	Sleep	25s
	# Log To Console    device is powered on
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep	1s
	VALIDATE VIDEO PLAYBACK
TC_312_REWIND_JUMP_LIVE_TV
	[Tags]	  TIMESHIFT
	[Documentation]	   rewind by 5 min and jump to live
	CLICK HOME
	Log To Console    Navigated To home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK EIGHT
	CLICK NINE
	Sleep	1s
	CLICK BACK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK LEFT
	Log To Console    rewinding the video
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	30s
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep	40s
	VALIDATE VIDEO PLAYBACK
	Log To Console    back to the live
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_313_PAUSE_NEAR_PROGRAM_END_TRANSITION_TO_NEXT_REWIND_AND_ACCESS_BOTH
    [Tags]	  TIMESHIFT
	[Documentation]	   pause near program end and transition to next rewind and access both
	CLICK HOME
	Log To Console    Navigated To Home page
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Log To Console    Navigated To LIVE
	CLICK THREE
	CLICK THREE
	CLICK THREE
	Sleep	1s
	CLICK BACK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	Sleep    20s
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK OK
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME



#############################################################################	

TC_601_RESTART_LIVE_PROGRAM_USING_START_OVER
	[Tags]      STARTOVER
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK EIGHT
	CLICK NINE
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	Sleep	2s
	# CLICK OK
	# Sleep    2s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_602_VERIFY_STARTOVER_AVAILABILITY_IN_EPG
	[Tags]      STARTOVER
	[Documentation]     Verify Startover availability in EPG
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK LEFT
    Log To Console    Navigating to filter
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Filter selected 
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
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
	CLICK BACK
    Log To Console    Navigating to any startover channel
	CLICK DOWN
	CLICK OK
	Sleep    2s 
	CLICK BACK
	Sleep    2s 
	
	CLICK RIGHT
	# CLICK DOWN
	# CLICK DOWN
	# ${Result}  Verify Crop Image  ${port}  TC_602_STARTOVER_IMAGE
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_602_STARTOVER_IMAGE Is Displayed
	# ...  ELSE  Fail  TC_602_STARTOVER_IMAGE Is Not Displayed
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	Sleep    2s 
    Log To Console    Verifying Video Playback
    VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK BACK
	CLICK BACK
	CLICK OK
	CLICK LEFT
	Log To Console    Navigating to filter
	${STEP_COUNT}=    Move to Filter On Side Pannel
	
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
	CLICK OK
	CLICK BACK
	CLICK BACK
	CLICK HOME

TC_603_USE_STARTOVER_ON_A_PROGRAM_AND_PAUSE_PLAYBACK_FOR_5_MINUTES_THEN_RESUME
	[Tags]      STARTOVER
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep	2s
	CLICK ONE
	CLICK TWO
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	Sleep    3s
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	# Sleep    300s
	# CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_604_FAST_FORWARD_A_STARTOVER_PROGRAM_TO_CATCH_UP_TO_LIVE_TV_AND_RESUME_PLAYBACK
	[Tags]      STARTOVER
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep	2s
	CLICK ONE
	CLICK TWO
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK OK
	Sleep    3s
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  4X_SPEED
	Run Keyword If  '${Result}' == 'True'  Log To Console  4X_SPEED Is Displayed
	...  ELSE  Fail  4X_SPEED Is Not Displayed
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK OK
	Sleep    3s
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_605_REWIND_A_STARTOVER_PROGRAM_BY_5_MINUTES_FROM_A_MID_POINT_AND_RESUME_PLAYBACK
	[Tags]      STARTOVER
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep	2s
	CLICK ONE
	CLICK TWO
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK

	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK OK
	Sleep    3s
	CLICK LEFT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  REWIND_4X
	Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_4X Is Displayed
	...  ELSE  Fail  REWIND_4X Is Not Displayed
	Sleep    2s
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK OK
	Sleep    5s
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_606_EXIT_A_STARTOVER_PROGRAM_MID_PLAYBACK_AND_CONFIRM_RETURN_TO_LIVE_TV
	[Tags]      STARTOVER
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep	2s
	CLICK ONE
	CLICK TWO
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image with Shorter Duration  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Sleep    3s
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	VALIDATE VIDEO PLAYBACK
    CLICK HOME

TC_607_STARTOVER_SUBTITLES_VERIFY
	[Tags]      STARTOVER
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Check For Exit Popup
	Sleep    3s
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	 #  Validate subtitle popup
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Subtitle_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Subtitle_Popup Is Displayed
	...  ELSE  Fail  Subtitle_Popup Is Not Displayed
	CLICK UP
	CLICK OK
   
	Check For Exit Popup
	CLICK HOME
	VALIDATE VIDEO PLAYBACK
    CLICK HOME

TC_608_SWITCH_AUDIO_TRACKS_DURING_STARTOVER
	[Tags]      STARTOVER
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Sleep    3s
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
    Log To Console    Content Audio Switched To English Language
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Audio_Launguage
	Run Keyword If  '${Result}' == 'True'  Log To Console  Audio_Launguage Is Displayed
	...  ELSE  Fail  Audio_Launguage Is Not Displayed
    Log To Console    Accessed The Audio Button In The Screen
	VALIDATE VIDEO PLAYBACK
    CLICK HOME
	Check For Exit Popup
	CLICK HOME
    Log To Console    Navigated To Home Page

TC_611_SWITCH_TO_STARTOVER_JUMP_TO_LIVE
	[Tags]      STARTOVER
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Sleep    3s	
	VALIDATE VIDEO PLAYBACK
	CLICK BACK
    CLICK BACK
	Check For Exit Popup
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
    Log To Console    Navigated To Home Page

TC_612_STARTOVER_WHILE_RECORDING_VERIFY
	[Tags]      STARTOVER
    CLICK HOME
	CLICK ONE
	CLICK TWO
	Sleep    2s
	CLICK BACK
	# ${STEP_COUNT}=    Move to Record On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	# Remove and replace above
	Sleep    2s
	CLICK RIGHT
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	# CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	Click OK
	SLeep	5s
	CLICK OK
	Sleep	15s
	CLICK RIGHT
	# ${STEP_COUNT}=    Move to Pause On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	#Remove and use above
	CLICK DOWN
	CLICK OK
	Sleep    3s
	CLICK LEFT
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	CLICK OK
	Sleep    2s
	CLICK MENU
	Sleep    2s
	CLICK RIGHT
	Check For Exit Popup
	CLICK OK
	CLICK OK
	Click BACK
	Sleep    2s
	CLICK RIGHT
	# ${STEP_COUNT}=    Move to Pause On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	#Remove and use above
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
	Sleep    2s
	CLICK DOWN
	CLICK DOWN
	CLICK oK
	Sleep	5s
	VALIDATE VIDEO PLAYBACK
	CLICK BACK
	CLICK DOWN
	CLICK OK
	CLICK OK
	Click OK
	CLICK HOME
TC_613_BLOCK_STARTOVER_PARENTAL_CONTROL
	[Tags]      STARTOVER
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
	# ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_613_Edit_Admin_Profile
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_613_Edit_Admin_Profile Is Displayed
	# ...  ELSE  Fail  TC_613_Edit_Admin_Profile Is Not Displayed
	
	CLICK Down
	CLICK Ok
	# ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_613_Admin_Pin_Popup
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_613_Admin_Pin_Popup Is Displayed
	# ...  ELSE  Fail  TC_613_Admin_Pin_Popup Is Not Displayed
	
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
	CLICK Right
	CLICK Right
	Sleep    5s
	# ${Result}  Verify Crop Image  ${port}  TC_613_TV_Experience
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_613_TV_Experience Is Displayed
	# ...  ELSE  Fail  TC_613_TV_Experience Is Not Displayed
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	Sleep    1s
	# ${Result}  Verify Crop Image  ${port}  TC_613_Channel_Lock_Screen
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_613_Channel_Lock_Screen Is Displayed
	# ...  ELSE  Fail  TC_613_Channel_Lock_Screen Is Not Displayed
	CLICK OK
	CLICK Up
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK

	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
    Log To Console    select start over
	CLICK ONE
	Sleep    2s
	CLICK BACK
	Sleep    5s
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    Log To Console    Enter PIN
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
    VALIDATE VIDEO PLAYBACK
	
	CLICK HOME
	Check For Exit Popup
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
	# ${Result}  Verify Crop Image  ${port}  TC_613_Edit_Admin_Profile
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_613_Edit_Admin_Profile Is Displayed
	# ...  ELSE  Fail  TC_613_Edit_Admin_Profile Is Not Displayed
	
	CLICK Down
	CLICK Ok
	# ${Result}  Verify Crop Image  ${port}  TC_613_Admin_Pin_Popup
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_613_Admin_Pin_Popup Is Displayed
	# ...  ELSE  Fail  TC_613_Admin_Pin_Popup Is Not Displayed
	
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
	CLICK Right
	CLICK Right
	Sleep    5s
	# ${Result}  Verify Crop Image  ${port}  TC_613_TV_Experience
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_613_TV_Experience Is Displayed
	# ...  ELSE  Fail  TC_613_TV_Experience Is Not Displayed
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	Sleep    1s
	# ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_613_Channel_Lock_Screen
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_613_Channel_Lock_Screen Is Displayed
	# ...  ELSE  Fail  TC_613_Channel_Lock_Screen Is Not Displayed
	CLICK OK
	CLICK Up
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK HOME

TC_614_CHECK_PROGRESS_BAR_AND_TIMESTAMP_IN_STARTOVER_PROGRAM
	[Tags]      STARTOVER
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_614_Start_Over_Time
	Run Keyword If  '${Result}' == 'True'  Log To Console  Tv_Guide_Start_Over_Zero_Zero Is Displayed
	...  ELSE  Fail  Tv_Guide_Start_Over_Zero_Zero Is Not Displayed
	CLICK Home
	Check For Exit Popup
    CLICK Home
	
TC_616_CONFIRM_PLAYBACK_RESUMES_AFTER_STB_REBOOT_IN_STARTOVER
    [Tags]    Startover
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep    1s 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK MULTIPLE TIMES    3    UP
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    1s 
	CLICK BACK
	CLICK OK
	CLICK DOWN
	CLICK OK
	Sleep    2s 
	CLICK BACK
	CLICK RIGHT
    ${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Startover Initiated

	VALIDATE VIDEO PLAYBACK
    Log To Console    Startover Playback is working

	Log To Console    Rebooting STB
	Reboot STB Device

	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
    Sleep    20s
	CLICK HOME
	CLICK BACK
	CLICK BACK
	Sleep    2s
	CLICK RIGHT
	${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	CLICK OK
	CLICK BACK
	VALIDATE VIDEO PLAYBACK
    Log To Console    Resumed Startover Playback is working
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep    1s 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK MULTIPLE TIMES    3    UP
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK HOME


TC_618_VERIFY_STARTOVER_WITH_TIMESHIFT
	[Tags]      STARTOVER
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK LEFT
	CLICK Ok
	Sleep    2s
	${Result}  Verify Crop Image With Shorter Duration   ${port}  REWIND_4X
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_618_Rewind_4X Is Displayed
	...  ELSE  Fail  TC_618_Rewind_4X Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK LEFT
	CLICK LEFT
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_618_Starting_Timestamp
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_618_Starting_Timestamp Is Displayed
	...  ELSE  Fail  TC_618_Starting_Timestamp Is Not Displayed
	
	CLICK Home
	Check For Exit Popup
    CLICK Home

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
	Sleep	1s
	CLICK BACK
	Log to console		Navigated to Live channel 15
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Start_Over
	Run Keyword If  '${Result}' == 'True'  Log To Console  Start_Over Is Displayed
	...  ELSE  Fail  Start_Over Is Not Displayed
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK
	#Validate immediately for startover indicator
	#Check if startover indicator is seen in channel info bar else need to add loop through channels to identify it
	Log to console		Startover indicator is seen

	# CLICK OK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME


TC_621_STARTOVER_SUBTITLES_FF_SWITCH_TO_LIVE
	[Tags]      STARTOVER
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Check For Exit Popup
	Sleep    3s
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	 #  Validate subtitle popup
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Subtitle_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Subtitle_Popup     Is Displayed
	...  ELSE  Fail  Subtitle_Popup Is Not Displayed
	CLICK UP
	CLICK OK
   
	Check For Exit Popup
	CLICK HOME
	VALIDATE VIDEO PLAYBACK
    CLICK HOME
	#Verify subtitle sync

TC_622_STARTOVER_NEWS_PLAY_FROM_BEGINNING
	[Tags]      STARTOVER
	CLICK HOME
	Log To Console    Play BBC News
	CLICK FIVE
	CLICK TWO
	CLICK EIGHT
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
    VALIDATE VIDEO PLAYBACK

TC_625_STARTOVER_SWITCH_LIVE_RETURN
	[Tags]      STARTOVER
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	CLICK ONE
	CLICK FIVE
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK ONE
	Check For Exit Popup
	CLICK BACK
	# Sleep    1s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Sleep    3s
	CLICK Ok
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_626_Live
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME
	Check For Exit Popup
	CLICK HOME  

TC_627_STARTOVER_PLAYBACK_STOP_LIVE_CATCHUP
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	CLICK ONE
	CLICK FIVE
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK POWER
	Sleep    3s
	CLICK POWER
	Sleep    10s
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    10s
	CLICK ONE
	CLICK TWO
	Sleep	2s
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_628_STARTOVER_PLAYBACK_STOP_LIVE_CATCHUP
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	CLICK ONE
	CLICK FIVE
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK OK
	# Wait Until Play Button Is Displayed
	Sleep    30s
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Play_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	...  ELSE  Fail  Play_Button Is Not Displayed
	VALIDATE VIDEO PLAYBACK
	CLICK HOME
	Check For Exit Popup
	CLICK HOME

TC_629_VOLUME_CONTROL
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration S  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	Sleep    5s
	CLICK MUTE
	# ${Result}  Verify Crop Image  ${port}  TC_1027_Mute_Button
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1027_Mute_Button Is Displayed
	# ...  ELSE  Fail  TC_629_Mute_Symbol Is Not Displayed
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLUP
	CLICK VOLUP
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Volume_Down
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_629_Volume_Up Is Displayed
	...  ELSE  Fail  TC_629_Volume_Up Is Not Displayed
	CLICK Home







######## SCRIPTS FROM STB3 ########

TC_321_Pause_Verifation
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image  ${port}  Recorded_Pause
	Run Keyword If  '${Result}' == 'True'  Log To Console  Recorded_Pause Is Displayed
	...  ELSE  Fail  Recorded_Pause Is Not Displayed



TC_801_VERIFY_CURRENT_DAY_PROGRAM_SCHEDULE_UNDER_EPG
    [Tags]    GUIDE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK Ok
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
	CLICK RIGHT
	Sleep    2s 
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Today_EPG
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
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK BACK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME

TC_803_CHECK_NEXT_DAY_PROGRAM_LISTINGS_UNDER_EPG
    [Tags]    GUIDE
	CLICK HOME
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
	# CLICK DOWN
	CLICK RIGHT
	Sleep    2s 
	CLICK RIGHT
	Sleep    2s 
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_803_Tom_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_803_Tommorrow Is Displayed
	...  ELSE  Fail  TC_803_Tommorrow Is Not Displayed
	CLICK HOME

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
	CLICK HOME

TC_805_SCHEDULE_RECORDING_FOR_FUTURE_PROGRAM_UNDER_EPG
    [Tags]    GUIDE
	CLICK HOME
	CLICK HOME
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
	CLICK RIGHT
	Sleep    2s 
	CLICK RIGHT
	Sleep    2s 
	CLICK DOWN
	Sleep    2s 
	# ${Result}  Verify Crop Image  ${port}  TC_803_Tommorrow
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_803_Tommorrow Is Displayed
	# ...  ELSE  Fail  TC_803_Tommorrow Is Not Displayed
	CLICK LEFT
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
	# ${Result}  Verify Crop Image  ${port}  Success_Popup
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Success_Popup Is Displayed
	# ...  ELSE  Fail  Success_Popup Is Not Displayed
	# CLICK OK
	# CLICK BACK
	Sleep    2s 
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
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_805_Cancel_Rec
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_805_Recordings_Cancelled Is Displayed
	...  ELSE  Fail  TC_805_Recordings_Cancelled Is Not Displayed
	CLICK OK
	CLICK HOME

TC_806_FILTER_EPG_BY_CATEGORY_AND_VERIFY_DISPLAY
    [Tags]    GUIDE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    2s 
	CLICK LEFT
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	Sleep    2s 
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
	CLICK OK
    Log To Console    Navigated to Movies 
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_806_Movies_Filter_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_806_Movie_Filter Is Displayed
	...  ELSE  Fail  TC_806_Movie_Filter Is Not Displayed
	CLICK BACK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_806_Movies_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_806_Movies Is Displayed
	...  ELSE  Fail  TC_806_Movies Is Not Displayed
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK BACK
	CLICK BACK

TC_807_SEARCH_PROGRAM_IN_EPG_AND_VIEW_DETAILS
    [Tags]    GUIDE 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    1s 
	CLICK LEFT
	CLICK UP
	CLICK OK
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
    ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_807_Abu_Dhabi_Chnl 
	Run Keyword If  '${Result}' == 'True'  Log To Console   TC_807_Channel_Name Is Displayed
	...  ELSE  Fail  TC_807_Channel_Name Is Not Displayed 
	CLICK OK
	CLICK HOME 

TC_808_VERIFY_PROGRAM_DESCRIPTIONS_UNDER_EPG
    [Tags]    GUIDE
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
	Sleep    1s 
	CLICK BACK
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration    ${port}   TC_808_Program_Description
	Run Keyword If  '${Result}' == 'True'  Log To Console     TC_808_Program_Description Is Displayed
	...  ELSE  Fail  TC_808_Program_Description Is Not Displayed
	Sleep    2s 
	CLICK HOME

TC_809_SET_REMINDER_FOR_FUTURE_PROGRAM_IN_EPG
    [Tags]    GUIDE 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    1s 
    CLICK TWO
	CLICK TWO
	Sleep    2s
	CLICK BACK
	CLICK OK
	CLICK RIGHT
	Sleep    1s
	CLICK RIGHT
	Sleep    1s 
	CLICK DOWN
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# #Move to Set Reminder On Side Pannel
    # ${STEP_COUNT}=    Move to Set Reminder On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
	Sleep	1s
	CLICK DOWN
	CLICK OK
	#CLICK OK
    
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	${Result}   Verify Crop Image With Shorter Duration    ${port}   TC_809_Reminder_Added
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_809_Reminder_Added Is Displayed on screen
	...  ELSE  Fail  TC_809_Reminder_Added Is Not Displayed on screen
	Sleep	1s
	CLICK OK
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
	Sleep    1s 
	CLICK OK
	CLICK OK
	CLICK UP
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
	CLICK OK
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
	Check For Exit Popup
	CLICK HOME

TC_811_VERIFY_AGE_APPROPRIATE_PROGRAMS_UNDER_CHILD_PROFILE
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}    TC_811_KIDS_PROFILE
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
	CLICK OK
	CLICK OK
	Sleep    1s
	CLICK BACK
	Sleep    1s
	CLICK UP
	CLICK UP
	CLICK OK 
	Sleep    3s
	CLICK BACK
	CLICK RIGHT
    ${Result}  Verify Crop Image With Shorter Duration   ${port}    TC_811_KIDS
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}    TC_811_KIDS
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_811_KIDS_2 Is Displayed on screen
	...  ELSE  Fail  TC_811_KIDS_2 Is Not Displayed on screen
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
	CLICK OK
	Sleep    3s
	CLICK ONE
	Sleep    2s 
	CLICK BACK
	CLICK OK
	Verify Zapping Time    DOWN    10
	Sleep    2s 
	CLICK RIGHT
	Verify Zapping Time    DOWN    5
	Sleep    2s 
	CLICK RIGHT
	#Verify Today Option
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Today_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console  Today_EPG Is Displayed
	...  ELSE  Fail  Today_EPG Is Not Displayed
	
    Verify Zapping Time    DOWN    5
	Sleep    3s 
	CLICK HOME




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
	${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    #Validate the Highlighted record button without giving sleep after clicking down
    ${Result}  Verify Crop Image With Shorter Duration 	 ${port}  Side_Pannel_Record
	Run Keyword If  '${Result}' == 'True'  Log To Console  Record_Option_Left_Pannel Is Displayed
	...  ELSE  Fail  Record_Option_Left_Pannel Is Not Displayed	
	# CLICK OK
	CLICK HOME

TC_818_CANCEL_SCHEDULED_RECORDING_FROM_EPG
	[Tags]      GUIDE
	[Documentation]     Verify Cancel schedule recording from EPG
	# CLICK HOME
	# CLICK UP
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK OK
	# CLICK OK
	# CLICK RIGHT
	# CLICK DOWN
	# CLICK OK
	# CLICK UP
	# CLICK OK
	# CLICK OK
	# CLICK OK
	# CLICK RIGHT
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
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	Sleep   2s 
	CLICK RIGHT
	Sleep   2s 
	CLICK DOWN
	Sleep   2s 
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep   2s 
	#Log To Console     Recorded future program
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep	1s
	CLICK OK
	CLICK LEFT
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# Sleep   2s 
	CLICK RIGHT
	Sleep   2s 
	CLICK DOWN
	CLICK OK
	CLICK UP 
	CLICK OK
	CLICK OK
	#Validate schedule removal pop up
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Recordings_Popup
		Run Keyword If  '${Result}' == 'True'  Log To Console  Recordings_Popup Is Displayed
		...  ELSE  Fail  Recordings_Popup Is Not Displayed		
	CLICK OK
	#Validate removal
	CLICK HOME

TC_822_VERIFY_MULTI_LANGUAGE_SUPPORT_IN_EPG
    [Tags]    GUIDE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    1s
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Sleep    1s
	CLICK BACK
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	${Result}   Verify Crop Image With Shorter Duration   ${port}  TC_822_ENGLISH_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_822_ENGLISH_EPG Is Displayed on screen
	...  ELSE  Fail  TC_822_ENGLISH_EPG Is Not Displayed on screen
	
	CLICK BACK
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
	Sleep    20s 
	CLICK HOME
	CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK LEFT
	${Result}   Verify Crop Image With Shorter Duration   ${port}  TC_822_ARABIC_TODAY
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_822_ARABIC_TODAY Is Displayed on screen
	...  ELSE  Fail  TC_822_ARABIC_TODAY Is Not Displayed on screen
	
	CLICK BACK
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
	Sleep    1s
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	Sleep    1s
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    1s
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    1s
	CLICK OK
	Sleep    20s
	CLICK HOME

TC_823_CHECK_LIVE_SPORTS_SECTION_UNDER_EPG
    [Tags]    GUIDE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK LEFT
	#MOVE TO FILER
	Log To Console    Navigating to filter
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
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
    #Validate Sports filter
	${Result}   Verify Crop Image With Shorter Duration   ${port}    TC_823_FILTER_SPORTS
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_823_FILTER_SPORTS Is Displayed on screen
	...  ELSE  Fail  TC_823_FILTER_SPORTS Is Not Displayed on screen
	

	CLICK OK
	Sleep    2s 
	CLICK BACK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	Sleep    2s
	CLICK BACK
	Sleep    2s
	CLICK RIGHT
	${Result}   Verify Crop Image With Shorter Duration  ${port}  TC_823_SPORT
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_823_SPORT Is Displayed on screen
	...  ELSE  Fail  TC_823_SPORT Is Not Displayed on screen
	
	Sleep    2s 
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	Sleep    2s
	CLICK BACK
	Sleep    2s
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_823_SPORT
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_823_SPORT Is Displayed on screen
	...  ELSE  Fail  TC_823_SPORT Is Not Displayed on screen
	
	Sleep    2s
	CLICK UP
	CLICK UP
	CLICK OK
	Sleep    2s
	CLICK UP
	CLICK OK
	Sleep    2s
	CLICK UP
	CLICK BACK
	Sleep    2s
	CLICK OK
	CLICK LEFT
	#MOVE TO FILER
	Log To Console    Navigating to filter
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Filter selected 
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	Sleep    2s
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK BACK
	CLICK BACK
	CLICK HOME

TC_824_VERIFY_RECORDING_CONFLICT_WARNINGS_IN_EPG
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	Sleep    2s 
	CLICK Two
	CLICK Two
	Sleep    2s 
	CLICK Back
	# CLICK Ok
	CLICK Right
	# CLICK Ok
	# CLICK Down
	# CLICK Down
	# CLICK Down
	# CLICK Ok
	# Sleep    1s
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_119_ok_btn
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_824_Ok_Button Is Displayed on screen
	...  ELSE  Fail  TC_824_Ok_Button Is Not Displayed on screen
	
	CLICK Ok
	Sleep    2s 
	CLICK Two
	CLICK Three
	Sleep    2s 
	CLICK Back
	# CLICK Ok
	CLICK Right
	# Sleep    2s 
	# CLICK Ok
	# CLICK Down
	# CLICK Down
	# CLICK Down
	# CLICK Ok
	# Sleep    1s
    ${STEP_COUNT}=    Move to Record On Side Pannel
	# CLICK RIGHT
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_824_conflict_rec_popup
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
	CLICK Down
	CLICK Ok
	CLICK Up
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_824_Confirm_Deletion
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_824_Confirm_Deletion Is Displayed on screen
	...  ELSE  Fail  TC_824_Confirm_Deletion Is Not Displayed on screen
	
	CLICK Ok
	Sleep    20s 
	CLICK Ok
	CLICK Home


TC_825_CONFIRM_LAST_VIEWED_POSITION_RETAINS_AFTER_POWER_CYCLE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    1s
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ZERO
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_825_Last_retained_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_825_Last_retained_Channel Is Displayed on screen
	...  ELSE  Fail  TC_825_Last_retained_Channel Is Not Displayed on screen
	Sleep    1s 
	CLICK POWER
	Sleep    2s 
	CLICK POWER
	Sleep    20s 
	CLICK BACK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_825_Last_retained_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_825_Last_retained_Channel Is Displayed on screen
	...  ELSE  Fail  TC_825_Last_retained_Channel Is Not Displayed on screen
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK

TC_827_SCHEDULE_RECURRING_RECORDING_UNDER_EPG
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	Sleep    3s 
	CLICK Two
	CLICK Two
	Sleep    2s
	CLICK Back
	# CLICK Ok
	CLICK Right
	# Sleep    2s
	# CLICK Right
	# CLICK Down
	# Sleep    2s
	# CLICK LEFT
	# Sleep    2s
	# CLICK Ok
	# CLICK Down
	# CLICK Down
	# CLICK Down
	# CLICK Ok
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
	# ${Result}  Verify Crop Image  ${port}  TC_827_Validate_Recurring_Scheduling
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_827_Validate_Recurring_Scheduling Is Displayed on screen
	# ...  ELSE  Fail  TC_827_Validate_Recurring_Scheduling Is Not Displayed on screen
	
	CLICK Down
	CLICK Ok
	CLICK Up
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_827_Confirm_Deletion
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_827_Confirm_Deletion Is Displayed on screen
	...  ELSE  Fail  TC_827_Confirm_Deletion Is Not Displayed on screen
	
	CLICK Ok
	Sleep    10s 
	CLICK Ok
	CLICK Home

TC_830_SCHEDULE_RECORDINGS_ON_MULTIPLE_CHANNELS_SIMULTANEOUSLY
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
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
	CLICK Down
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_824_Conflict_PopUp
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_824_Confirm_Deletion
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_824_Confirm_Deletion Is Displayed on screen
	...  ELSE  Fail  TC_824_Confirm_Deletion Is Not Displayed on screen
	
	CLICK Ok
	CLICK Ok
	CLICK Home


TC_832_CHECK_ADD_TO_FAVORITE_OPTION_IN_EPG
    [Tags]    GUIDE
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
	# 	${Result}=    Verify Crop Image    ${port}    TC_211_Favorites_Feed
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_FAV_CHANNEL
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
	Sleep    1s 
	CLICK BACK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	Sleep    1s 
	CLICK OK
	CLICK HOME


TC_833_VERIFY_STARTOVER_AND_CATCHUP_OPTION_UNDER_EPG_DURING_LIVE_STREAM
	[Tags]      GUIDE
    [Documentation]     Verify startover and catchup option in EPG during live stream
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
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
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_833_STARTOVE_IMAGE
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_833_CATCHUP_IMAGE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_833_CATCHUP_IMAGE Is Displayed
	...  ELSE  Fail  TC_833_CATCHUP_IMAGE Is Not Displayed
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
    Log To Console    Filter selected 
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
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep    1s 
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK LEFT
    Log To Console    Navigating to filter
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Filter selected 

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
	CLICK BACK
	CLICK BACK
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_834_News
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_834_News Is Displayed
	...  ELSE  Fail  TC_834_News Is Not Displayed
    Sleep    3s 
    CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK BACK
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_834_News2
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_834_News2 Is Displayed
	...  ELSE  Fail  TC_834_News2 Is Not Displayed
    CLICK BACK
	Sleep    3s 
	CLICK OK
	CLICK LEFT
    Log To Console    Navigating to filter
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
	CLICK OK
	CLICK BACK
	CLICK BACK
	CLICK HOME


TC_838_SELECT_RADIO_STATION_IN_EPG_AND_PLAY
    [Tags]      RADIO 
  	[Documentation]     Verify radio station in EPG
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep    3s 
	Log To Console    Navigated to TV 
	CLICK DOWN
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
	
	${Result}  Verify Crop Image With Shorter Duration  ${port}  1201_Radio_channel_banner
	Run Keyword If  '${Result}' == 'True'  Log To Console   1201_Radio_channel_banner Is Displayed on screen
	...  ELSE  Fail  1201_Radio_channel_banner Is Not Displayed on screen
    Sleep    6s 
	Log To Console    Navigated to radio Channel in EPG
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  1201_Radio_channel_banner
	Run Keyword If  '${Result}' == 'True'  Log To Console   1201_Radio_channel_banner Is Displayed on screen
	...  ELSE  Fail  1201_Radio_channel_banner Is Not Displayed on screen
	Sleep	2s
	CLICK BACK
	CLICK UP
	CLICK DOWN
	#Validate channel2 Alfa_Monamat_Radio_Banner
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Alfa_Monamat_Radio_Banner
	Run Keyword If  '${Result}' == 'True'  Log To Console   Alfa_Monamat_Radio_Banner Is Displayed on screen
	...  ELSE  Fail  Alfa_Monamat_Radio_Banner Is Not Displayed on screen
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  1201_Radio_channel_banner
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  SHARJAH_QURAN
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
	CLICK BACK
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Alfa_Monamat_Radio_Banner
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Alfa_Monamat_Radio_Banner
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Alfa_Monamat_Radio_Banner
	Run Keyword If  '${Result}' == 'True'  Log To Console   Alfa_Monamat_Radio_Banner Is Displayed on screen
	...  ELSE  Fail  Alfa_Monamat_Radio_Banner Is Not Displayed on screen
	Reboot STB Device
	Sleep	40s
	CLICK HOME
	CLICK BACK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Alfa_Monamat_Radio_Banner
	Run Keyword If  '${Result}' == 'True'  Log To Console   Alfa_Monamat_Radio_Banner Is Displayed on screen
	...  ELSE  Fail  Alfa_Monamat_Radio_Banner Is Not Displayed on screen
	Sleep	5s
	CLICK HOME


# ####################################################################################################
TC_101_LOAD_HOMEPAGE
	[Tags]      HOMEPAGE
  	[Documentation]     Verify HOMEPAGE LOADING
	CLICK HOME
	CLICK UP
	CLICK OK
	Sleep    3s
	${Result}  Verify Crop Image  ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed
	...  ELSE  Fail  Home_Page Is Not Displayed	
	CLICK HOME
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
	CLICK OK
	#Validate continue watching text on top left
	${Result}  Verify Crop Image  ${port}  TC_103_Continue_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  Continue_Watching_Page Is Displayed
	...  ELSE  Fail  Continue_Watching_Page Is Not Displayed
	CLICK HOME
TC_104_VERIFY_PERSONALIZED_RECOMMENDATIONS
	[Tags]      HOMEPAGE
  [Documentation]     Verify Personalized Recommendations from Homepage
	CLICK HOME
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image    ${port}    Recommended_Feeds
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
	CLICK OK
	CLICK DOWN
	VALIDATE IMAGE ON NAVIGATION    RIGHT
	CLICK HOME

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

TC_106_VERIFY_SMOOTH_SCROLL_THROUGH_HOMEPAGE
      [Tags]      HOMEPAGE
    [Documentation]     Verify smooth scroll through Homepage
	CLICK HOME    
	Verify Zapping Time    RIGHT    25
	CLICK DOWN
	CLICK DOWN
	Verify Zapping Time    LEFT    25	
	#Validate continue watching text on top left
	${Result}  Verify Crop Image  ${port}  Continue_Watching_Feeds
	Run Keyword If  '${Result}' == 'True'  Log To Console  Continue_Watching_Page Is Displayed
	...  ELSE  Fail  Continue_Watching_Page Is Not Displayed
	CLICK HOME

TC_107_VERIFY_HOMEPAGE_FAVORITE_SECTION_ACCESS_FAVORITE_CHANNEL
    [Tags]    HOMEPAGE
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
	# 	${Result}=    Verify Crop Image    ${port}    TC_211_Favorites_Feed
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
	${Result}  Verify Crop Image  ${port}  TC_FAV_CHANNEL
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
	Sleep    1s 
	CLICK BACK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	Sleep    1s 
	CLICK OK
	CLICK HOME


TC_110_ACCESS_EPG_DEDICATED_TILE_BUTTON
    [Tags]    HOMEPAGE
	CLICK HOME
    CLICK UP
	CLICK RIGHT
	CLICK OK
	Sleep    1s 
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_110_EPG_TILE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_110_EPG_TILE Is Displayed
	...  ELSE  Fail  TC_110_EPG_TILE Is Not Displayed
	
	CLICK OK
	CLICK OK
	Sleep    2s 
	CLICK MULTIPLE TIMES    10    DOWN	
	CLICK RIGHT
	Sleep    1s 
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Today_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console     TC_110_EPG_VALIDATION Is Displayed
	...  ELSE  Fail  TC_110_EPG_VALIDATION Is Not Displayed
	
	CLICK BACK
	CLICK HOME

TC_112_VERIFY_LAST_SELECTED_SECTION_AFTER_POWER_CYCLE
    [Tags]    HOMEPAGE
	CLICK HOME
    Power_Off_And_Power_On_STB

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
	# Move to More Details On Side Pannel
    ${STEP_COUNT}=    Move to More Details On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	CLICK OK

	# FOR    ${i}    IN RANGE    20
	# 	${Result}=    Verify Crop Image    ${port}        TC_113_More_Details_Side_Panel
	# 	Run Keyword If    '${Result}' == 'True'    Run Keywords
	# 	...    Log To Console    ✅ More_Details_Side_Panel is displayed
	# 	...    AND   CLICK OK
	# 	...    AND    Exit For Loop

	# 	CLICK DOWN
	# END
    # Run Keyword If    '${Result}' != 'True'    Fail    ❌ More_Details is not displayed after navigating right	
  	# #CLICK DOWN
    Sleep    2s 
	# Validate channel name abu dhabi tv hd
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_113_More_Details_Abhu
	Run Keyword If  '${Result}' == 'True'  Log To Console  Abu_Dhabi_Tv_HD_Channel_Name Is Displayed
	...  ELSE  Fail  Abu_Dhabi_Tv_HD_Channel_Name Is Not Displayed
    Sleep    5s 
	CLICK HOME

TC_114_VERIFY_TRENDING_NOW_SECTION_CURRENT_POPULAR_CONTENT
	CLICK HOME
	Log to Console    Navigated to Home page
	FOR    ${i}    IN RANGE    25
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Trending_Section
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
	CLICK OK
	${pin}  Verify Crop Image With Shorter Duration  ${port}  Pin_Block
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
	...        AND    CLICK OK
	Sleep	5s
	CLICK HOME


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
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    10s
	Log To console    Profile Switched to user and home page is loaded
	#validate home page
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed
	...  ELSE  Fail  Home_Page Is Not Displayed
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
    ${Result}  Verify Crop Image With Shorter Duration    ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed
	...  ELSE  Fail  Home_Page Is Not Displayed
    DELETE PROFILE
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
	${Result}  Verify Crop Image  ${port}  TC_116_Notification_Popup
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
	${Result}  Verify Crop Image  ${port}  TC_116_Confirm_Deletion_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_116_Confirm_Deletion_Popup Is Displayed on screen
	...  ELSE  Fail  TC_116_Confirm_Deletion_Popup Is Not Displayed on screen
	
	CLICK Ok
	CLICK Ok
	CLICK Home

TC_117_ACCESS_RECENTLY_ADDED_VOD_SECTION_NEW_TITLES
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    1s 
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
	CLICK LEFT
	CLICK OK
	Sleep    1s 

    FOR    ${i}    IN RANGE    10
		${Result}=    Verify Crop Image    ${port}    Recently_Added
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
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_117_Recently_added
	Run Keyword If  '${Result}' == 'True'  Log To Console  C_117_Recently_added Is Displayed on screen
	...  ELSE  Fail  TC_117_Recently_added Is Not Displayed on screen
	
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
    CLICK HOME




TC_121_TV_PICTURE_TILE
    [Tags]    HOMEPAGE 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	# ${Result}  Verify Crop Image  ${port}  TC_121_TV_tile
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_121_TV_tile Is Displayed
	# ...  ELSE  Fail  TC_121_TV_tile Is Not Displayed
	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_121_TV_Tile_Live_Tv
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_121_Live_TV Is Displayed
	...  ELSE  Fail  TC_121_Live_TV Is Not Displayed
	
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME

TC_122_BOX_OFFICE_PICTURE_TILE
    [Tags]    HOMEPAGE 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	# ${Result}  Verify Crop Image  ${port}  TC_121_Live_TV
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_121_Live_TV Is Displayed
	# ...  ELSE  Fail  TC_121_Live_TV Is Not Displayed
	
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_122_Library_Tile
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_122_Library Is Displayed
	...  ELSE  Fail  TC_122_Library Is Not Displayed
	CLICK RIGHT
	CLICK OK
	CLICK OK
	${pin}  Verify Crop Image With Shorter Duration  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keywords
    ...        Log To Console    Selected video
    ...        AND    CLICK OK

	Sleep    5s 
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	VALIDATE VIDEO PLAYBACK
	CLICK HOME

TC_123_ONDEMAND_PICTURE_TILE
    [Tags]    HOMEPAGE 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}	TC_123_Ondemand_Tile
	Run Keyword If  '${Result}' == 'True'  Log To Console  Ondemand Is Displayed
	...  ELSE  Fail  Ondemand Is Not Displayed
	
	CLICK OK
	CLICK OK
	CLICK OK
	Sleep    5s 
	VALIDATE VIDEO PLAYBACK
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
	CLICK OK
	Sleep    5s 
	Move to More Details On Side Pannel
	# CLICK OK
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_124_Kids_Title
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_124_kids Is Displayed
	...  ELSE  Fail  TC_124_kids Is Not Displayed
	
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
	Sleep    3s 
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_125_Recorder_My_Tv
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_125_Recorder Is Displayed
	...  ELSE  Fail  TC_125_Recorder Is Not Displayed
	CLICK OK
	CLICK BACK
	Sleep    3s 
	CLICK DOWN

	Sleep    3s 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_125_Reminder_My_Tv
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_125_Reminders Is Displayed
	...  ELSE  Fail  TC_125_Reminders Is Not Displayed
	CLICK OK
	CLICK BACK
	Sleep    3s 
	CLICK DOWN
	Sleep    3s 
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_125_Subscription_My_Tv
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_125_Subscriptions Is Displayed
	...  ELSE  Fail  TC_125_Subscriptions Is Not Displayed
	CLICK OK
	CLICK BACK
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
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_126_Gaming_Tile
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_126_Play Is Displayed
	...  ELSE  Fail  TC_126_Play Is Not Displayed
	
	CLICK RIGHT
	# ${Result}  Verify Crop Image  ${port}  TC_126_Discover
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_126_Discover Is Displayed
	# ...  ELSE  Fail  TC_126_Discover Is Not Displayed
	
	CLICK RIGHT
	# ${Result}  Verify Crop Image  ${port}  TC_126_Most_Played
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_126_Most_Played Is Displayed
	# ...  ELSE  Fail  TC_126_Most_Played Is Not Displayed

	CLICK RIGHT
	# ${Result}  Verify Crop Image  ${port}  TC_126_More_Info
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_126_More_Info Is Displayed
	# ...  ELSE  Fail  TC_126_More_Info Is Not Displayed

	CLICK RIGHT
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
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# CLICK DOWN
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Success_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Success_Popup Is Displayed
	...  ELSE  Fail  Success_Popup Is Not Displayed
	
	CLICK OK
	CLICK HOME
	CLICK TWO
	Sleep    3s 
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_119_Pin_Block
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_011_channel2_locked Is Displayed
	...  ELSE  Fail  TC_011_channel2_locked Is Not Displayed
	
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
	CLICK OK
	CLICK OK
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


TC_120_SCROLL_HOMEPAGE_WITHOUT_TRUNCATION
    [Tags]    HOMEPAGE 
	CLICK HOME    
	Verify Zapping Time    RIGHT    25
	CLICK DOWN
	CLICK DOWN
	Verify Zapping Time    LEFT    25	
	#Validate continue watching text on top left
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Continue_Watching_Feeds
	Run Keyword If  '${Result}' == 'True'  Log To Console  Continue_Watching_Page Is Displayed
	...  ELSE  Fail  Continue_Watching_Page Is Not Displayed
	CLICK HOME




###############################################################################################################################################################################################################################################

TC_001_CREATE_NEW_PROFILE
	[Tags]	PROFILE
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
	Sleep    3s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_001_Add_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  Who_Is_Watching_001 Is Displayed
	...  ELSE  Fail  Who_Is_Watching_001 Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_001_abcd
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
		${Result}  Verify Crop Image  ${port}  TC_001_After_Creation
	Run Keyword If  '${Result}' == 'True'  Log To Console  Whos_watching_after_Creation Is Displayed
	...  ELSE  Fail  Whos_watching_after_Creation Is Not Displayed
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
		${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_001_After_Deletion
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_001_Whos_watching_after_deletion Is Displayed
	...  ELSE  Fail  TC_001_Whos_watching_after_deletion Is Not Displayed
	Sleep    10s 
	CLICK HOME

TC_002_EDIT_PROFILE_NAME
    [Tags]     PROFILE & EDIT 
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
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
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
	${Result}  Verify Crop Image  ${port}  TC_002_New_Name_For_Profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_002_New_Profile_Name Is Displayed
	...  ELSE  Fail  TC_002_New_Profile_Name Is Not Displayed
	
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
	CLICK OK
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
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
	CLICK OK
	CLICK DOWN
	CLICK DOWN
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
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image  ${port}  Success_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_002_Success Is Displayed
	...  ELSE  Fail  TC_002_Success Is Not Displayed
	
	CLICK OK
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
	${Result}  Verify Crop Image  ${port}  TC_002_Edited_Name
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_002_Edited_Profile_Name Is Displayed
	...  ELSE  Fail  TC_002_Edited_Profile_Name Is Not Displayed
	
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
	Sleep    3s
	CLICK SEVEN
	CLICK SEVEN
	Sleep    2s 
	CLICK UP
	Sleep    1s 
	CLICK UP
	Sleep    1s 
	CLICK UP
	Sleep    1s 
	CLICK UP
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
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
	CLICK HOME

TC_005_EDIT_PROFILE_SECURITY_CONTROL_DISABLE_PIN_BOX_OFFICE
    [Tags]    PROFILE & EDIT
	[Documentation]    Edit profile box office pin
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
	CLICK RIGHT
	CLICK OK
	Log To Console  Verifying  TC_003_Who_Watching on Screen
	${Result}  Verify Crop Image  ${port}  TC_003_Who_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_Who_Watching Is Displayed on screen
	...  ELSE  Log To Console  TC_003_Who_Watching Is Not Displayed on screen
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
	CLICK OK
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
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK DOWN
	Log To Console  Verifying  TC_005_Disable_BoxOffice_pin on Screen
	${Result}  Verify Crop Image  ${port}  TC_005_Disable_BoxOffice_pin
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_005_Disable_BoxOffice_pin Is Displayed on screen
	...  ELSE  Log To Console  TC_005_Disable_BoxOffice_pin Is Not Displayed on screen
	CLICK DOWN
	CLICK DOWN 
	CLICK OK
	# CLICK HOME
	# CLICK UP
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK OK
	# CLICK DOWN
	# CLICK OK
    # CLICK RIGHT
	# CLICK RIGHT
	# CLICK RIGHT
	# CLICK OK
	# CLICK OK
	# Boxoffice Pin Disabled
	# Log To Console  Verifying  TC_005_Disable_BoxOffice_pin on Screen
	# ${Result}  Verify Crop Image  ${port}  TC_005_Disable_BoxOffice_pin
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_005_Disable_BoxOffice_pin Is Displayed on screen
	# ...  ELSE  Fail  TC_005_Disable_BoxOffice_pin Is Not Displayed on screen
	# CLICK DOWN
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	# CLICK RIGHT
	# CLICK OK
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
	# Log To Console  Verifying  TC_005_Profile_Deleted on Screen
	# ${Result}  Verify Crop Image  ${port}  TC_005_Profile_Deleted
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_005_Profile_Deleted Is Displayed on screen
	# ...  ELSE  Fail  TC_005_Profile_Deleted Is Not Displayed on screen
	CLICK OK
	CLICK HOME
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
	${Result}  Verify Crop Image  ${port}  AUDIO_ENGLISH
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
	CLICK SEVEN
	CLICK ONE
	CLICK ZERO
	CLICK FIVE
	Sleep    1s
	CLICK BACK

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
	${Result}  Verify Crop Image  ${port}  CONFIRM_AUDIO_ENGLISH
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


TC_006_EDIT_PROFILE_SECURITY_CONTROL_ALWAYS_LOGIN_SAME_PROFILE
	[Tags]	PROFILE
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_006_Profile_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Profile_Page Is Displayed
	...  ELSE  Fail  TC_006_Profile_Page Is Not Displayed
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_006_Profile_Type
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_001_abcd
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_006_new_profile
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_006_personal_details
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_006_security
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Security_Controls Is Displayed
	...  ELSE  Fail  TC_006_Security_Controls Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_006_always_Login
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Always_login Is Displayed
	...  ELSE  Fail  TC_006_Always_login Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Success_Popup
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_006_logged_admin_profile
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
	[Tags]	PROFILE
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
	${Result}  Verify Crop Image  ${port}  TC_006_Profile_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Whos_watching Is Displayed
	...  ELSE  Fail  Whos_watching Is Not Displayed
	
	CLICK RIGHT
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
	# ${Result}  Verify Crop Image  ${port}  TC_007_Details_entered
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_007_Details_entered Is Displayed
	# ...  ELSE  Fail  TC_007_Details_entered Is Not Displayed
	
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
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}  TC_006_new_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_007_New_profile_created Is Displayed
	...  ELSE  Fail  TC_007_New_profile_created Is Not Displayed
	
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    2s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
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
	CLICK RIGHT
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_007_rental_Unlimited
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_007_Rental_unlimited Is Displayed
	...  ELSE  Fail  TC_007_Rental_unlimited Is Not Displayed
	
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Success_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_007_Success Is Displayed
	...  ELSE  Fail  TC_007_Success Is Not Displayed
	
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
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    8s 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK UP
	CLICK UP
	# # CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  TC_007_Insufficient_quota
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_007_Insufficient_quota Is Displayed
	# ...  ELSE  Fail  TC_007_Insufficient_quota Is Not Displayed
	
	CLICK OK
	CLICK BACK
	CLICK BACK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK UP
	CLICK UP
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  TC_007_Insufficient_quota
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_007_Insufficient_quota Is Displayed
	# ...  ELSE  Fail  TC_007_Insufficient_quota Is Not Displayed
	
	CLICK OK
	CLICK BACK
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
	Sleep    8s
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
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK HOME

TC_009_PROFILE_TV_EXPERIENCE_SUBTITLE_LANGUAGE_CHANGE
	[Tags]	PROFILE
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_006_Profile_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_WHOS_WATCHING Is Displayed
	...  ELSE  Fail  TC_009_WHOS_WATCHING Is Not Displayed
	
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
	# ${Result}  Verify Crop Image  ${port}  TC_009_Details_entered
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_Details_entered Is Displayed
	# ...  ELSE  Fail  TC_009_Details_entered Is Not Displayed

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
	${Result}  Verify Crop Image  ${port}  TC_006_new_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_NEW_PROFILE Is Displayed
	...  ELSE  Fail  TC_009_NEW_PROFILE Is Not Displayed
	
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
	CLICK LEFT
	#need to change month
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_009_TV_experience
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_TV_EXPERIENCE Is Displayed
	...  ELSE  Fail  TC_009_TV_EXPERIENCE Is Not Displayed
	
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Success_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_SUCCESS Is Displayed
	...  ELSE  Fail  TC_009_SUCCESS Is Not Displayed
	
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
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    8s 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK SEVEN
	CLICK ONE
	CLICK ZERO
	CLICK FIVE
	CLICK BACK
    Sleep    2s 
	CLICK RIGHT

	# Log To Console    Move to subtitle On Side Pannel
	# ${STEP_COUNT}=    Move to Filter On Side Pannel
	
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
    # CLICK OK
    # Log To Console    Subtitling selected 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
		${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_217_Subtitling
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_SUBTITLING Is Displayed
	...  ELSE  Fail  TC_009_SUBTITLING Is Not Displayed
	
	CLICK OK
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_009_Arabic
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_009_ARABIC Is Displayed
	...  ELSE  Fail  TC_009_ARABIC Is Not Displayed
	
	CLICK BACK
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
	Sleep    8s 
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

TC_010_PROFILE_TV_EXPERIENCE_CONTENT_RATING
    [Tags]    PROFILE & EDIT 
	[Teardown]    Delete Profile
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
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Sleep    15s 
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
	${Result}  Verify Crop Image  ${port}  TC_010_ok
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_010_ok Is Displayed on screen
	...  ELSE  Fail  TC_010_ok Is Not Displayed on screen
	
	CLICK OK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK FIVE
	CLICK ZERO
	CLICK TWO
	${Result}  Verify Crop Image  ${port}  TC_010_Rating_Confirmation_PopUp
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_010_Rating_Confirmation_PopUp Is Displayed on screen
	...  ELSE  Fail  TC_010_Rating_Confirmation_PopUp Is Not Displayed on screen
	
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
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

TC_011_PROFILE_TV_EXPERIENCE_CHANNEL_LOCK
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
	CLICK RIGHT
	CLICK RIGHT
	Sleep    10s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
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
	${Result}  Verify Crop Image  ${port}  TC_011_ok_button
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_011_ok_button Is Displayed
	...  ELSE  Fail  TC_011_ok_button Is Not Displayed
	
	CLICK OK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    2s 
	CLICK ONE
	Sleep    3s 
	# ${Result}  Verify Crop Image  ${port}  TC_011_locked
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_011_channel1_locked Is Displayed
	# ...  ELSE  Fail  TC_011_channel1_locked Is Not Displayed
	
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    3s
	CLICK TWO
	Sleep    3s
	# ${Result}  Verify Crop Image  ${port}  TC_011_locked
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_011_channel2_locked Is Displayed
	# ...  ELSE  Fail  TC_011_channel2_locked Is Not Displayed
	
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    2s
	CLICK TWO
	CLICK TWO
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
	Sleep    10s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
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
	${Result}  Verify Crop Image  ${port}  TC_011_ok_button
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_011_ok_button Is Displayed
	...  ELSE  Fail  TC_011_ok_button Is Not Displayed
	CLICK OK
	CLICK HOME

TC_012_PROFILE_TV_EXPERIENCE_HIDE_CHANNEL
    [Tags]    PROFILE & EDIT 
	[Teardown]    Delete Profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK TWO
	${Result}  Verify Crop Image  ${port}  TC_012_two
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
	# ${Result}  Verify Crop Image  ${port}  TC_012_ok_button
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_012_ok_button Is Displayed
	# ...  ELSE  Fail  TC_012_ok_button Is Not Displayed
	
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK TWO
	${Result}  Verify Crop Image  ${port}  TC_012_three
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_012_three Is Displayed
	...  ELSE  Fail  TC_012_three Is Not Displayed
	
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
	${Result}  Verify Crop Image  ${port}  TC_012_ok_button
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_012_ok_button Is Displayed
	...  ELSE  Fail  TC_012_ok_button Is Not Displayed
	
	CLICK OK
	CLICK HOME


TC_013_PROFILE_TV_EXPERIENCE_ADVERTISEMENT
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
	CLICK RIGHT
	CLICK RIGHT
	Sleep    2s

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
	# ${Result}  Verify Crop Image  ${port}  TC_013_Success
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_013_Success Is Displayed
	# ...  ELSE  Fail  TC_013_Success Is Not Displayed
	
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
	# ${Result}  Verify Crop Image  ${port}  TC_014_Whos_watching
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_014_Whos_watching Is Displayed
	# ...  ELSE  Fail  TC_014_Whos_watching Is Not Displayed
	
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
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_014_Local_selected
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_014_Local_selected Is Displayed
	...  ELSE  Fail  TC_014_Local_selected Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  TC_014_Success
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_014_Success Is Displayed
	# ...  ELSE  Fail  TC_014_Success Is Not Displayed
	
	CLICK OK
	#Functionality check
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    3s
	CLICK SEVEN
	CLICK SEVEN
	CLICK ONE
	Sleep    1s 
	CLICK BACK
	
	CLICK RIGHT
	${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK

	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN

    ${Result}  Verify Crop Image  ${port}  TC_014_LOCAL
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_014_LOCAL Is Displayed
	...  ELSE  Fail  TC_014_LOCAL Is Not Displayed

	CLICK HOME
	#
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
	# ${Result}  Verify Crop Image  ${port}  TC_014_Navigated_To_Interface_Setting
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_014_Navigated_To_Interface_Setting Is Displayed
	# ...  ELSE  Fail  TC_014_Navigated_To_Interface_Setting Is Not Displayed
	
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


TC_015_PROFILE_INTERFACE_SETTING_SCREEN_LANGUAGE_CHANGE
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    3s 
	
	CLICK DOWN
	CLICK DOWN
	# ${Result}  Verify Crop Image  ${port}  English_Language
	# Run Keyword If  '${Result}' == 'True'  Log To Console  English_Language Is Displayed
	# ...  ELSE  Fail  English_Language Is Not Displayed
	
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  TC_805_ok_button
	# Run Keyword If  '${Result}' == 'True'  Log To Console  ok_button Is Displayed
	# ...  ELSE  Fail  ok_button Is Not Displayed
	
	CLICK OK
	Sleep    20s 
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
	# ${Result}  Verify Crop Image  ${port}  Arabic_Language
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Arabic_Language Is Displayed
	# ...  ELSE  Fail  Arabic_Language Is Not Displayed
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	# ${Result}  Verify Crop Image  ${port}  English_Language
	# Run Keyword If  '${Result}' == 'True'  Log To Console  English_Language Is Displayed
	# ...  ELSE  Fail  English_Language Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	CLICK OK
	Sleep    20s 
	CLICK HOME

TC_018_PROFILE_INTERFACE_SETTING_CHANNEL_STYLE
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep     3s 
	CLICK DOWN
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}  TC_018_default_style
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
	${Result}  Verify Crop Image  ${port}  TC_018_ok
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_ok Is Displayed on screen
	...  ELSE  Fail  TC_018_ok Is Not Displayed on screen
	
	CLICK OK
	Sleep    3s 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK ONE
	Sleep    15s 
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_018_first_tile 
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_first_tile Is Displayed on screen
	...  ELSE  Fail  TC_018_first_tile Is Not Displayed on screen
	
	Sleep    3s 
	${Result}  Verify Crop Image  ${port}  TC_018_last_tile 
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_last_tile Is Displayed on screen
	...  ELSE  Fail  TC_018_last_tile Is Not Displayed on screen

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
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}  TC_018_five_channel_style
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

TC_019_CONFIRM_PROFILE_DELETION
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
	# ${Result}  Verify Crop Image  ${port}  TC_019_Whos_Watching
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
	# ${Result}  Verify Crop Image  ${port}  TC_022_Whos_watching
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_022_Whos_watching Is Displayed
	# ...  ELSE  Fail  TC_022_Whos_watching Is Not Displayed
	
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
	Sleep    8s 
	CLICK HOME
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
	CLICK HOME

TC_023_EDIT_PROFILE_USER_LANGUAGE_PREFERENCE
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	Sleep    3s 
	
	CLICK DOWN
	CLICK DOWN
	# ${Result}  Verify Crop Image  ${port}  English_Language
	# Run Keyword If  '${Result}' == 'True'  Log To Console  English_Language Is Displayed
	# ...  ELSE  Fail  English_Language Is Not Displayed
	
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  TC_805_ok_button
	# Run Keyword If  '${Result}' == 'True'  Log To Console  ok_button Is Displayed
	# ...  ELSE  Fail  ok_button Is Not Displayed
	
	CLICK OK
	Sleep    20s 
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
	# ${Result}  Verify Crop Image  ${port}  Arabic_Language
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Arabic_Language Is Displayed
	# ...  ELSE  Fail  Arabic_Language Is Not Displayed
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	# ${Result}  Verify Crop Image  ${port}  English_Language
	# Run Keyword If  '${Result}' == 'True'  Log To Console  English_Language Is Displayed
	# ...  ELSE  Fail  English_Language Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	CLICK OK
	Sleep    20s 
	CLICK HOME



TC_024_CREATE_CHILD_PROFILE_WITH_AGE_BASED_RESTRICTION
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
	Sleep    2s 
	CLICK MULTIPLE TIMES    6    DOWN   
	CLICK MULTIPLE TIMES    2    OK 
	CLICK UP
    CLICK MULTIPLE TIMES    2    RIGHT
	Sleep    3s 
    CLICK MULTIPLE TIMES    3    DOWN 
	CLICK OK
	CLICK MULTIPLE TIMES    3    DOWN 
	CLICK OK
    ${Result}  Verify Crop Image  ${port}      TC_024_RATING
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_024_RATING Is Displayed on screen
	...  ELSE  Fail     TC_024_RATING Is Not Displayed on screen
	CLICK MULTIPLE TIMES    5    DOWN 
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
	CLICK RIGHT

	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    5s 
	CLICK HOME
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_105_KIDS
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_024_KIDS Is Displayed
	...  ELSE  Fail  TC_024_KIDS Is Not Displayed
	CLICK BACK
	Sleep    2s

	CLICK HOME
	FOR    ${i}    IN RANGE    20
		${Result}=    Verify Crop Image    ${port}    Recommended_Feeds
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
	${Result}  Verify Crop Image  ${port}  TC_105_KIDS
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_024_KIDS Is Displayed
	...  ELSE  Fail  TC_024_KIDS Is Not Displayed
	CLICK BACK
	Sleep    2s 
	CLICK BACK
	CLICK RIGHT
	CLICK OK
	Sleep    2s 
	CLICK BACK

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


TC_027_EDIT_PROFILE_REMOVE_CHANNEL_FAVORITE_LIST
    [Tags]    PROFILE & EDIT
	[Teardown]    Delete Profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    1s 
	CLICK ONE
	CLICK FIVE
	Sleep    1s 
	CLICK BACK
	Sleep    1s 
	CLICK RIGHT
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
	Sleep    1s
	CLICK RIGHT
	CLICK RIGHT
	Sleep    5s 
	CLICK DOWN
	CLICK DOWN
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
	${Result}  Verify Crop Image  ${port}  TC_027_FAVORITE_CHANNEL
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_027_FAVORITE_CHANNEL Is Displayed on screen
	...  ELSE  Fail  TC_027_FAVORITE_CHANNEL Is Not Displayed on screen
	
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
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_027_CHANNEL_REMOVED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_027_CHANNEL_REMOVED Is Displayed on screen
	...  ELSE  Fail  TC_027_CHANNEL_REMOVED Is Not Displayed on screen
	
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

TC_033_EDIT_PROFILE_CHANGE_DEFAULT_AUDIO_LANGUAGE_VERIFY_PLAYBACK
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
	${Result}  Verify Crop Image  ${port}  AUDIO_ENGLISH
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
	CLICK SEVEN
	CLICK ONE
	CLICK ZERO
	CLICK FIVE
	Sleep    1s
	CLICK BACK

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
	${Result}  Verify Crop Image  ${port}  CONFIRM_AUDIO_ENGLISH
	Run Keyword If  '${Result}' == 'True'  Log To Console  CONFIRM_AUDIO_ENGLISH Is Displayed on screen
	...  ELSE  Fail  CONFIRM_AUDIO_ENGLISH Is Not Displayed on screen
	CLICK BACK
	CLICK BACK
	VALIDATE VIDEO PLAYBACK

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
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Interface_setting
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_settings Is Displayed
	...  ELSE  Fail  Interface_settings Is Not Displayed
	Sleep    3s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  clock_off
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_clock_off Is Displayed
	...  ELSE  Fail  Interface_clock_off Is Not Displayed
	
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK UP 
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	${Result}  Verify Crop Image  ${port}  Success_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_clock_success Is Displayed
	...  ELSE  Fail  Interface_clock_success Is Not Displayed
	Sleep    3s 
	CLICK OK
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
	Sleep    10s 
	# ${result}=  Verify Crop Image With Two Images   ${port}  TC_017_clock_pm  TC_017_clock_am
    # Run Keyword Unless  '${result}'=='True'  Fail  Cropped image does not match either expected image     15s 
    ${result}=  Verify Crop Image With Two Images   ${port}  TC_017_clock_pm  TC_017_clock_am
	IF    '${result}' != 'True'
		Log To Console    Interface clock is not visible on screen
		Fail              Interface clock is not visible on screen
	ELSE
		Log To Console    Interface clock is visible on screen
	END


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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  clock_on
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_clock_on Is Displayed
	...  ELSE  Fail  Interface_clock_on Is Not Displayed
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK DOWN
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  interface_setting_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_settings Is Displayed
	...  ELSE  Fail  Interface_settings Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration   ${port}  interface_timeout_10_sec
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Success_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_timeout_success Is Displayed
	...  ELSE  Fail  Interface_timeout_success Is Not Displayed
	
	CLICK OK
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_016_Dubai_TV
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
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  interface_timeout_5sec
	Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_timeout_5secs Is Displayed
	...  ELSE  Fail  Interface_timeout_5secs Is Not Displayed
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	CLICK OK
	CLICK HOME

TC_003_EDIT_PROFILE_SECURITY_CONTROL_CHANGE_PIN
    [Tags]      PROFILE & EDIT
    [Documentation]     Editing Profile security pin
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
	Log To Console  Verifying  TC_003_Who_Watching on Screen
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_003_Who_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_Who_Watching Is Displayed on screen
	...  ELSE  Fail  TC_003_Who_Watching Is Not Displayed on screen
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
	CLICK OK
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
	Log To Console  Verifying  TC_003_New_User
	${Result}  Verify Crop Image  ${port}  TC_003_New_User
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_New_User Is Displayed on screen
	...  ELSE  Fail  TC_003_New_User Is Not Displayed on screen
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
	CLICK OK
	CLICK DOWN
	CLICK OK
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
	${Result}  Verify Crop Image  ${port}  TC_003_PIN_CHANGED
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_PIN_CHANGED Is Displayed on screen
	...  ELSE  Fail  TC_003_PIN_CHANGED Is Not Displayed on screen
	CLICK OK
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
	CLICK RIGHT
	CLICK OK
	Log To Console  Verifying  TC_003_Login_as_new_user
	${Result}  Verify Crop Image  ${port}  TC_003_Login_as_new_user
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_Login_as_new_user Is Displayed on screen
	...  ELSE  Fail  TC_003_Login_as_new_user Is Not Displayed on screen
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
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
  
  
  

TC_004_EDIT_PROFILE_SECURITY_CONTROL_DISABLE_PIN
    [Tags]      PROFILE & EDIT
    [Documentation]     Disabling Profile security pin
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
    Log To Console  Verifying  TC_003_Login_as_new_user
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_006_Profile_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_Login_as_new_user Is Displayed on screen
	...  ELSE  Fail  TC_003_Login_as_new_user Is Not Displayed on screen
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
	CLICK OK
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
	Log To Console  Verifying  TC_004_New_user_created on Screen
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_006_new_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_004_New_user_created Is Displayed on screen
	...  ELSE  Fail  TC_004_New_user_created Is Not Displayed on screen
	
	CLICK RIGHT
	CLICK OK
	# Log To Console  Verifying  TC_004_Checking_disable_pin on Screen
	# ${Result}  Verify Crop Image  ${port}  TC_004_Checking_disable_pin
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_004_Checking_disable_pin Is Displayed on screen
	# ...  ELSE  Fail  TC_004_Checking_disable_pin Is Not Displayed on screen
	
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

TC_020_EDIT_PROFILE_ENABLE_PARENTAL_CONTROL_RESTRICT_CHANNEL
    [Tags]      PROFILE & EDIT
    [Documentation]     Enable parental control restrict channel
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
	Log To Console  Verifying  TC_003_Who_Watching on Screen
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_006_Profile_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_Who_Watching Is Displayed on screen
	...  ELSE  Fail  TC_003_Who_Watching Is Not Displayed on screen
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
	Log To Console  Verifying  TC_020_New_User on Screen
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_006_new_profile
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
	CLICK DOWN
	CLICK OK
	CLICK EIGHT
	CLICK FIVE
	CLICK OK
	CLICK BACK
	CLICK BACK
	CLICK EIGHT
	CLICK SIX
	CLICK TWO
	CLICK OK
	CLICK BACK
	CLICK BACK
	CLICK SEVEN
	CLICK ZERO
	CLICK OK
	CLICK UP
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
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    5s
	CLICK HOME
	CLICK EIGHT
	CLICK FIVE
	Log To Console  Verifying  TC_020_Channel_lock1 on Screen
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_020_Channel_lock1
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_020_Channel_lock1 Is Displayed on screen
	...  ELSE  Fail  $TC_020_Channel_lock1 Is Not Displayed on screen
	
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK EIGHT
	CLICK SEVEN
	CLICK ZERO
	Log To Console  Verifying  TC_020_Channel_lock1 on Screen
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_020_Channel_lock1
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_020_Channel_lock1 Is Displayed on screen
	...  ELSE  Fail  TC_020_Channel_lock1 Is Not Displayed on screen
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
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


TC_021_SWITCHING_PROFILES_VERIFY_SETTINGS_PERSISTENCE
    [Tags]      PROFILE & EDIT
    [Documentation]     Switching profiles and verify settings persistence
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_006_Profile_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_Who_Watching Is Displayed on screen
	...  ELSE  Fail  TC_003_Who_Watching Is Not Displayed on screen
	
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
	
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_021_Audio_urdu
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_021_Audio_urdu Is Displayed on screen
	...  ELSE  Fail  TC_021_Audio_urdu Is Not Displayed on screen
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
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
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_021_Audio_english
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_021_Audio_english Is Displayed on screen
	...  ELSE  Fail  TC_021_Audio_english Is Not Displayed on screen
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
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
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_021_checking_eng_audio
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_021_checking_eng_audio Is Displayed on screen
	...  ELSE  Fail  TC_021_checking_eng_audio Is Not Displayed on screen
	
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

TC_025_SWITCH_PROFILE_DURING_LIVE_VERIFY_PROFILE_PREFERENCES
    [Tags]      PROFILE & EDIT
    [Documentation]     Switch profile during live and verify profile preferences
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
	${Result}  Verify Crop Image  ${port}  TC_003_Who_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_Who_Watching Is Displayed on screen
	...  ELSE  Fail  TC_003_Who_Watching Is Not Displayed on screen
	
	CLICK Right
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
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
	CLICK Up
	CLICK Up
	CLICK Up
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
	CLICK Down
	CLICK Ok
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
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Down
	CLICK Down
	CLICK Down
	${Result}  Verify Crop Image  ${port}  TC_025_Timeout_10sec
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_025_Timeout_10sec Is Displayed on screen
	...  ELSE  Fail  TC_025_Timeout_10sec Is Not Displayed on screen
	
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Right
	CLICK Down
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Right
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Up
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
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
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Home
	CLICK Eight
	CLICK Nine
	Sleep    2s
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
	CLICK Right
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
	Sleep    5s
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
	CLICK Right
	CLICK Down
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Down
	CLICK Down
	CLICK Down
	${Result}  Verify Crop Image  ${port}  TC_025_Timeout_5sec
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_025_Timeout_5sec Is Displayed on screen
	...  ELSE  Fail  TC_025_Timeout_5sec Is Not Displayed on screen
	
	CLICK Down
	CLICK Down
	CLICK Right
	CLICK Ok
	CLICK LEFT
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
	Sleep    5s
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
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
	CLICK Home

TC_026_CREATE_PROFILE_ADD_FAVORITE_VERIFY_FAVORITE_LIST
    [Tags]      PROFILE & EDIT
    [Documentation]     Add Favorite and verify favorite list
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
	${Result}  Verify Crop Image  ${port}  TC_003_Who_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_Who_Watching Is Displayed on screen
	...  ELSE  Fail  TC_003_Who_Watching Is Not Displayed on screen
	
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
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_026_New_user
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_026_New_user Is Displayed on screen
	...  ELSE  Fail  TC_026_New_user Is Not Displayed on screen
	
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    5s
	CLICK HOME
	CLICK TWO
	CLICK ZERO
	CLICK FOUR
	Sleep    1s
	CLICK BACK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK ZERO
	CLICK SIX
	Sleep    1s
	CLICK BACK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK ONE
	CLICK EIGHT
	Sleep    1s
	CLICK BACK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK ZERO
	Sleep    1s
	CLICK BACK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK ONE
	CLICK EIGHT
	Sleep    1s
	CLICK BACK
	CLICK RIGHT
	CLICK BACK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	Sleep    1s
	CLICK BACK
	CLICK RIGHT
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
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	Sleep    3s
	CLICK DOWN
	CLICK DOWN
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}  TC_026_Fav_channels
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_026_Fav_channels Is Displayed on screen
	...  ELSE  Fail  TC_026_Fav_channels Is Not Displayed on screen
	
	CLICK OK
	CLICK TWO
	CLICK ZERO
	CLICK FOUR
	${Result}  Verify Crop Image  ${port}  TC_026_First_fav_channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_026_First_fav_channel Is Displayed on screen
	...  ELSE  Fail  TC_026_First_fav_channel Is Not Displayed on screen
	
	CLICK BACK
	CLICK SIX
	${Result}  Verify Crop Image  ${port}  TC_026_second_fav_channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_026_second_fav_channel Is Displayed on screen
	...  ELSE  Fail  TC_026_second_fav_channel Is Not Displayed on screen
	
	CLICK BACK
	CLICK BACK
	CLICK ONE
	CLICK EIGHT
	${Result}  Verify Crop Image  ${port}  TC_026_third_fav_channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_026_third_fav_channel Is Displayed on screen
	...  ELSE  Fail  TC_026_third_fav_channel Is Not Displayed on screen
	
	CLICK BACK
	CLICK BACK
	CLICK TWO
	CLICK ZERO
	${Result}  Verify Crop Image  ${port}  TC_026_fourth_fav_channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_026_fourth_fav_channel Is Displayed on screen
	...  ELSE  Fail  TC_026_fourth_fav_channel Is Not Displayed on screen
	
	CLICK BACK
	CLICK TWO
	${Result}  Verify Crop Image  ${port}  TC_026_fifth_fav_channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_026_fifth_fav_channel Is Displayed on screen
	...  ELSE  Fail  TC_026_fifth_fav_channel Is Not Displayed on screen
	
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

TC_029_EDIT_PROFILE_CHANGE_PIN_PARENTAL_CONTROL_VERIFY_ACCESS
    [Tags]      PROFILE & EDIT
    [Documentation]     Edit profile pin parental control and verify access
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
	${Result}  Verify Crop Image  ${port}  TC_003_Who_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_Who_Watching Is Displayed on screen
	...  ELSE  Fail  TC_003_Who_Watching Is Not Displayed on screen
	
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
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
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
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_029_Parental_control
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_029_Parental_control Is Displayed on screen
	...  ELSE  Fail  TC_029_Parental_control Is Not Displayed on screen
	
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
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

TC_031_EDIT_PROFILE_ENABLE_DISABLE_AUTO_LOGIN
    [Tags]    PROFILE & EDIT
	[Documentation]    Edit Porfile and enable disable auyo login
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
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_003_Who_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_Who_Watching Is Displayed on screen
	...  ELSE  Log To Console  TC_003_Who_Watching Is Not Displayed on screen
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
	CLICK UP
	CLICK UP
	CLICK UP
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
	CLICK OK
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_004_new_user
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_031_New_user Is Displayed on screen
	...  ELSE  Log To Console  TC_031_New_user Is Not Displayed on screen
	
	CLICK RIGHT
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image  ${port}  TC_031_Login_as_same_profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_031_Login_as_same_profile Is Displayed on screen
	...  ELSE  Log To Console  TC_031_Login_as_same_profile Is Not Displayed on screen
	
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

TC_032_CREATE_PROFILE_VALID_PROFILE_SWITCH_DURING_RECORDING
    [Tags]    PROFILE & EDIT
	[Documentation]    Create profile and switch during recording
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
	${Result}  Verify Crop Image  ${port}  TC_003_Who_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_003_Who_Watching Is Displayed on screen
	...  ELSE  Log To Console  TC_003_Who_Watching Is Not Displayed on screen
	
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
	CLICK DOWN
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK OK
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
	Sleep    2s
	CLICK HOME
	Sleep    2s
	CLICK Two
	CLICK Three
	Sleep    1s
	CLICK Back
	CLICK Right
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
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
	CLICK Right
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
	Sleep    5s
	CLICK Home
	Sleep    10s
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
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
	Sleep    5s
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	# ${Result}  Verify Crop Image  ${port}  TC_032_Recording
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_032_Recording Is Displayed on screen
	# ...  ELSE  Fail  TC_032_Recording Is Not Displayed on screen
	
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Ok
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
	CLICK Right
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
	CLICK Home

#######################################################################################################
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
    ${Result}  Verify Crop Image  ${port}  Settings_Ethernet_wifi_option
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
	${Result}  Verify Crop Image  ${port}  Settings_Transaction_History_img
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Transaction_History Is Displayed
	...  ELSE  Fail  Settings_Transaction_History Is Not Displayed
    CLICK OK
	${Result}  Verify Crop Image  ${port}  Show_Transactions
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
	${Result}  Verify Crop Image  ${port}  Setting_Channel_Info_Refresh
	Run Keyword If  '${Result}' == 'True'  Log To Console  Setting_Channel_Info_Refresh Is Displayed
	...  ELSE  Fail  Setting_Channel_Info_Refresh Is Not Displayed
	${Result}  Verify Crop Image  ${port}  Self_care_Pop_Up
	Run Keyword If  '${Result}' == 'True'  Log To Console  Self_care_Pop_Up Is Displayed
	...  ELSE  Fail  Self_care_Pop_Up Is Not Displayed
	CLICK OK
	Sleep    10s
	${Result}  Verify Crop Image  ${port}  Selfcare_Troubleshooting
	Run Keyword If  '${Result}' == 'True'  Log To Console  Selfcare_Troubleshooting Is Displayed
	...  ELSE  Fail  Selfcare_Troubleshooting Is Not Displayed
	CLICK RED
	Sleep    18s
	CLICK HOME
	Navigate to Settings
	CLICK DOWN
    Sleep   2s
    Log To Console    Navigated to Device Settings
	CLICK RIGHT
	CLICK OK
    Sleep   8s
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}    Dismis_Pop_Up
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
    ${Result}  Verify Crop Image  ${port}  Settings_Bluetooth_Not_Connected
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Bluetooth_Not_Connected Is Displayed
	...  ELSE  Fail  Settings_Bluetooth_Not_Connected Is Not Displayed
    CLICK OK
	${Result}  Verify Crop Image  ${port}  Bluetooth_Pairing_Window
	Run Keyword If  '${Result}' == 'True'  Log To Console  Bluetooth_Pairing_Window Is Displayed
	...  ELSE  Fail  Bluetooth_Pairing_Window Is Not Displayed
	CLICK MULTIPLE TIMES    30    DOWN
	CLICK LEFT
	CLICK OK
	Sleep    3s
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
	${Result}  Verify Crop Image  ${port}    Stereo
	Run Keyword If  '${Result}' == 'True'  Log To Console  Stereo Is Displayed
	...  ELSE  Fail  Stereo Is Not Displayed
	${Result}  Verify Crop Image  ${port}  Dolby_Digital
	Run Keyword If  '${Result}' == 'True'  Log To Console  Dolby_Digital Is Displayed
	...  ELSE  Fail  Dolby_Digital Is Not Displayed
	CLICK MULTIPLE TIMES    3    UP
	CLICK OK 
	Sleep    2s
	CLICK OK
	Log To Console    Stereo option is set
	${Result}  Verify Crop Image  ${port}    Stereo_Before_Reboot
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
	${Result}  Verify Crop Image  ${port}    Stereo_Reboot
	Run Keyword If  '${Result}' == 'True'  Log To Console  Stereo_Reboot Is Displayed
	...  ELSE  Fail  Stereo_Reboot Is Not Displayed	
	CLICK OK
	CLICK MULTIPLE TIMES    3    DOWN
	CLICK OK 
	Sleep    2s
	CLICK OK 
	${Result}  Verify Crop Image  ${port}    Dolby_Digital_Before_Reboot
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
	${Result}  Verify Crop Image  ${port}    Dolby_Digital_Reboot
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
	${Result}  Verify Crop Image  ${port}  Settings_Manual_Upgrade_img
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Manual_Upgrade_img Is Displayed
	...  ELSE  Fail  Settings_Manual_Upgrade_img Is Not Displayed
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
	Sleep    3s
	CLICK UP
	${Result}  Verify Crop Image  ${port}  Start_Now_Unclickable
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
    ${Result}  Verify Crop Image  ${port}  Settings_Soft_Factory_Reset_Start_Now
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Soft_Factory_Reset_Start_Now Is Displayed
	...  ELSE  Fail  Settings_Soft_Factory_Reset_Start_Now Is Not Displayed
    CLICK OK
	Sleep    1s
    ${Result}  Verify Crop Image  ${port}  OK
	Run Keyword If  '${Result}' == 'True'  Log To Console  OK Is Displayed
	...  ELSE  Fail  OK Is Not Displayed
	CLICK OK
	Sleep    7s
    ${Result}  Verify Crop Image  ${port}  Etisalat_Logo_reset
	Run Keyword If  '${Result}' == 'True'  Log To Console  Etisalat_Logo Is Displayed
	...  ELSE  Log To Console  Etisalat_Logo Is Not Displayed
    Sleep    75s
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
    ${Result}  Verify Crop Image  ${port}  Settings_Soft_Factory_Reset_Start_Now
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Soft_Factory_Reset_Start_Now Is Displayed
	...  ELSE  Fail  Settings_Soft_Factory_Reset_Start_Now Is Not Displayed
    CLICK OK
	CLICK RIGHT
	Sleep    1s
    ${Result}  Verify Crop Image  ${port}  CANCEL
	Run Keyword If  '${Result}' == 'True'  Log To Console  CANCEL Is Displayed
	...  ELSE  Fail  CANCEL Is Not Displayed
	CLICK OK
	Sleep    2s
    ${Result}  Verify Crop Image  ${port}  Ethernet_Selected_Validate
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
    ${Result}  Verify Crop Image  ${port}  Settings_Soft_Factory_Reset_Start_Now
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
	${Result}  Verify Crop Image  ${port}  Settings_Box_Restore
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Box_Restore_Popup Is Displayed
	...  ELSE  Fail  Settings_Box_Restore_Popup Is Not Displayed
	CLICK OK
	${Result}  Verify Crop Image  ${port}  PINCODE
	Run Keyword If  '${Result}' == 'True'  Log To Console  PINCODE Is Displayed
	...  ELSE  Fail  PINCODE Is Not Displayed
	${Result}  Verify Crop Image  ${port}  INCODE_KEYPAD
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
	${Result}  Verify Crop Image  ${port}  Etisalat_Logo_reset
	Run Keyword If  '${Result}' == 'True'  Log To Console  Etisalat_Logo Is Displayed
	...  ELSE  Log To Console  Etisalat_Logo Is Not Displayed
    Sleep    75s
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
	${Result}  Verify Crop Image  ${port}  CANCEL_907
	Run Keyword If  '${Result}' == 'True'  Log To Console  CANCEL Is Displayed
	...  ELSE  Fail  CANCEL Is Not Displayed
	Sleep    2s
	CLICK OK
    ${Result}  Verify Crop Image  ${port}  Ethernet_Selected_Validate
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
    ${Result}  Verify Crop Image  ${port}  Settings_Box_Restore
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

    ${Result}  Verify Crop Image  ${port}    Settings_Bills_View_And_Paybills
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Bills_View_And_Paybills Is Displayed
	...  ELSE  Fail  Settings_Bills_View_And_Paybills Is Not Displayed
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Log To Console    Pop_Up appeared
    ${Result}  Verify Crop Image  ${port}    Pop_Up_Disappear
	Run Keyword If  '${Result}' == 'True'  Log To Console  pop up Is Displayed
	...  ELSE  Fail  pop up Is Not Displayed	
	Sleep    3s
	CLICK OK
	Sleep    3s
    ${Result}  Verify Crop Image  ${port}  Pop_Up_Disappear
	Run Keyword If  '${Result}' == 'Fail'  Log To Console  pop up Is Not Displayed
	...  ELSE  Fail  pop up Is Displayed
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Device_Information
	Run Keyword If  '${Result}' == 'True'  Log To Console  Settings_Show_Device_Information Is Displayed
	...  ELSE  Fail  Settings_Show_Device_Information Is Not Displayed
	CLICK OK
    Sleep   2s 
    Log To Console    Device information displayed
	Sleep    3s
	Log To Console    Verify Application_Version is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Application_Version
	Run Keyword If  '${Result}' == 'True'  Log To Console  Application_Version Is Displayed
	...  ELSE  Fail  Application_Version Is Not Displayed
	Log To Console    Verify Application_Version_W_Values is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Application_Version_W_Values
	Run Keyword If  '${Result}' == 'True'  Log To Console  Application_Version_W_Values Is Displayed
	...  ELSE  Log To Console  Application_Version_W_Values Is Not Displayed
	
    Log To Console    Verify Oct_Version is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Oct_Version
	Run Keyword If  '${Result}' == 'True'  Log To Console  Oct_Version Is Displayed
	...  ELSE  Fail  Oct_Version Is Not Displayed
	Log To Console    Verify Oct_Version_W_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Oct_Version_W_Values
	Run Keyword If  '${Result}' == 'True'  Log To Console  Oct_Version_W_Value Is Displayed
	...  ELSE  Log To Console  Oct_Version_W_Value Is Not Displayed

    Log To Console    Verify Sop_Version is displayed
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Sop_Version
	Run Keyword If  '${Result}' == 'True'  Log To Console  Sop_Version Is Displayed
	...  ELSE  Fail  Sop_Version Is Not Displayed
	Log To Console    Verify Sop_Version_W_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}  Sop_Version_W_Values
	Run Keyword If  '${Result}' == 'True'  Log To Console  Sop_Version_W_Value Is Displayed
	...  ELSE  Log To Console  Sop_Version_W_Value Is Not Displayed

    Log To Console    Verify Firmware is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    Firmware
	Run Keyword If  '${Result}' == 'True'  Log To Console  Firmware Is Displayed
	...  ELSE  Fail  Firmware Is Not Displayed
	Log To Console   Verify Firmware_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    Firmware_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  Firmware_Value Is Displayed
	...  ELSE  Log To Console  Firmware_Value Is Not Displayed

	Log To Console    Verify STB_Serial_Number is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    STB_Serial_Number
	Run Keyword If  '${Result}' == 'True'  Log To Console  STB_Serial_Number Is Displayed
	...  ELSE  Fail  STB_Serial_Number Is Not Displayed
	Log To Console   Verify Serial_Number_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    Serial_Number_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  Serial_Number_Value Is Displayed
	...  ELSE  Log To Console  Serial_Number_Value Is Not Displayed

    Log To Console    Verify STB_Model is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    STB_Model
	Run Keyword If  '${Result}' == 'True'  Log To Console  STB_Model Is Displayed
	...  ELSE  Fail  STB_Model Is Not Displayed
	Log To Console   Verify STB_Model_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    STB_Model_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  STB_Model_Value Is Displayed
	...  ELSE  Log To Console  STB_Model_Value Is Not Displayed

    Log To Console    Verify Channel_Version is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    Channel_Version
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel_Version Is Displayed
	...  ELSE  Fail  Channel_Version Is Not Displayed
    Log To Console    Verify Channel_Version_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    Channel_Version_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channel_Version_Value Is Displayed
	...  ELSE  Log To Console  Channel_Version_Value Is Not Displayed
    
	
	Log To Console    Verify IP_Gateway is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    IP_Gateway
	Run Keyword If  '${Result}' == 'True'  Log To Console  IP_Gateway Is Displayed
	...  ELSE  Fail  IP_Gateway Is Not Displayed
	Log To Console    Verify IP_Gateway_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    IP_Gateway_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  IP_Gateway_Value Is Displayed
	...  ELSE  Log To Console  IP_Gateway_Value Is Not Displayed
    
	
	Log To Console    Verify User_ID is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    User_ID
	Run Keyword If  '${Result}' == 'True'  Log To Console  User_ID Is Displayed
	...  ELSE  Fail  User_ID Is Not Displayed
	Log To Console    Verify User_ID_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    User_ID_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  User_ID_Value Is Displayed
	...  ELSE  Log To Console  User_ID_Value Is Not Displayed
    
	
	Log To Console    Verify Hardisk is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    Harddisk
	Run Keyword If  '${Result}' == 'True'  Log To Console  Hardisk Is Displayed
	...  ELSE  Fail  Hardisk Is Not Displayed
	Log To Console    Verify Hardisk_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    Hardisk_Value
	Run Keyword If  '${Result}' == 'True'  Log To Console  Hardisk_Value Is Displayed
	...  ELSE  Log To Console  Hardisk_Value Is Not Displayed
    
	
	Log To Console    Verify Mac_Address is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    Mac_Address
	Run Keyword If  '${Result}' == 'True'  Log To Console  Mac_Address Is Displayed
	...  ELSE  Fail  Mac_Address Is Not Displayed
	Log To Console    Verify Mac_Address_Value is displayed
	${Result}  Verify Crop Image With Shorter Duration  ${port}    Mac_Address_Value
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
	${Result}  Verify Crop Image  ${port}    TV
	Run Keyword If  '${Result}' == 'True'  Log To Console  TV Is Displayed
    ...  ELSE  Fail  TV Is Not Displayed
	${Result}  Verify Crop Image  ${port}    Internet
	Run Keyword If  '${Result}' == 'True'  Log To Console  Internet Is Displayed
    ...  ELSE  Fail  Internet Is Not Displayed
	${Result}  Verify Crop Image  ${port}    Landline
	Run Keyword If  '${Result}' == 'True'  Log To Console  Landline Is Displayed
    ...  ELSE  Fail  Landline Is Not Displayed
	Sleep    2s
	CLICK OK
	Sleep    8s
	Log To Console    Navigated to Self care TV
	${Result}  Verify Crop Image  ${port}    Troubleshoot_TV
	Run Keyword If  '${Result}' == 'True'  Log To Console  Troubleshoot_TV Is Displayed
    ...  ELSE  Fail  Troubleshoot_TV Is Not Displayed
	CLICK RED
	Sleep    20s
	CLICK HOME
	Sleep    2s
	CLICK HOME
	${Result}  Verify Crop Image  ${port}    HOME
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
	${Result}  Verify Crop Image  ${port}    Troubleshoot_Internet
	Run Keyword If  '${Result}' == 'True'  Log To Console  Troubleshoot_Internet Is Displayed
    ...  ELSE  Fail  Troubleshoot_Internet Is Not Displayed
	CLICK RED
	Sleep    20s
	CLICK HOME
	Sleep    2s
	CLICK HOME
	${Result}  Verify Crop Image  ${port}    HOME
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
	${Result}  Verify Crop Image  ${port}    Troubleshoot_Phone
	Run Keyword If  '${Result}' == 'True'  Log To Console  Troubleshoot_Phone Is Displayed
    ...  ELSE  Fail  Troubleshoot_Phone Is Not Displayed
	# CLICK RED
	# Sleep    20s
	# CLICK HOME
	# Sleep    2s
	# CLICK HOME
	# ${Result}  Verify Crop Image  ${port}    HOME
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
	CLICK DOWN
	CLICK OK
	Log To Console    Verify On and Off Option is available for Auto Restart
    ${Result}  Verify Crop Image  ${port}  On
	Run Keyword If  '${Result}' == 'True'  Log To Console  On Is Displayed
	...  ELSE  Fail  On Is Not Displayed
    ${Result}  Verify Crop Image  ${port}  Off
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
    ${Result}  Verify Crop Image  ${port}  Off_Before_Reboot
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
	CLICK DOWN
	Log To Console    Verify Off Option is available for Auto Restart After Reboot
    ${Result}  Verify Crop Image  ${port}  Off_After_Reboot
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
    ${Result}  Verify Crop Image  ${port}  On_Before_Reboot
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
	CLICK DOWN
	Log To Console    Verify  On Option is available for Auto Restart After Reboot
    ${Result}  Verify Crop Image  ${port}  On_After_Reboot
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
	${Result}   Verify Crop Image  ${port}   Enabled
	Run Keyword If  '${Result}' == 'True'  Log To Console  Enabled Is Displayed
	...  ELSE  Fail  Enabled Is Not Displayed
	${Result}   Verify Crop Image  ${port}   Disabled
	Run Keyword If  '${Result}' == 'True'  Log To Console  Disabled Is Displayed
	...  ELSE  Fail  Disabled Is Not Displayed	
	CLICK MULTIPLE TIMES    3    UP
    CLICK MULTIPLE TIMES    2    OK
    Log To Console    Verify HDMI CEC is Enabled Before Reboot
    ${Result}  Verify Crop Image  ${port}  Enabled_Before_Reboot
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
    ${Result}  Verify Crop Image  ${port}  Enabled_After_Reboot
	Run Keyword If  '${Result}' == 'True'  Log To Console  Enabled_After_Reboot Is Displayed
	...  ELSE  Fail  Enabled_After_Reboot Is Not Displayed
    Sleep    2s
	CLICK OK
	CLICK MULTIPLE TIMES    3    DOWN
    CLICK MULTIPLE TIMES    2    OK
    Log To Console    Verify HDMI CEC is Disabled Before Reboot
    ${Result}  Verify Crop Image  ${port}  Disabled_Before_Reboot
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
    ${Result}  Verify Crop Image  ${port}  Disabled_After_Reboot
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_921_Summary
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_922_Services_Menu
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_923_Playback_Menu
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_924_Storage_Menu
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_925_System_Menu
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_926_WIFI_AP
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_927_WIFI_STA
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_928_OTT
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_929_HDMI
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_930_Ethernet
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_931_USB_Type
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
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_932_Broadcast_Enabled
	Run Keyword If  '${Result}' == 'True'  Log To Console  Broadcast_Enabled Is Displayed
	...  ELSE  Fail  Broadcast_Enabled Not Displayed
	CLICK LEFT
	CLICK BACK
	CLICK HOME
	Sleep	3s


TC_934_ANDROID_SPLASHSCREEN_AT_REBOOT
	[Tags]	 ENGINEERING MENU
	CLICK HOME
	CLICK BACK
	CLICK BACK
	Sleep	3s 
	CLICK MENU
	CLICK GREEN 
	CLICK YELLOW
	CLICK BLUE
	Sleep	1s 
	Splashscreen Validation
	CLICK OK
	CLICK OK 
	Sleep	20s 
	CLICK OK
	Sleep	1s
	CLICK HOME
	${Result}  Verify Crop Image  ${port}	TC_966_Home
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_966_Home Is Displayed
	...  ELSE  Fail  TC_966_Home Is Not Displayed
###########################################################################################
################################### NEW 150 SCRIPTS #######################################

TC_1001_VALIDATE_ETISALAT_LOGO_POWER_OFF_AND_ON
	CLICK HOME
	CLICK POWER
	CLICK POWER
	Sleep  20s
	#VALIDATE LOGO 
		${pin}  Verify Crop Image With Shorter Duration   ${port}  Power_On_Login_Page
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK OK
	...    AND		CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    Navigated to  Home Page
	Sleep	20s
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1001_Etisalat_Logo
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1001_Etisalat_Logo Is Displayed on screen
	...  ELSE  Fail  TC_1001_Etisalat_Logo Is Not Displayed on screen
    CLICK HOME

TC_1002_LOCKED_CONTENT_IN_ONDEMAND_FEED_STARZPLAY
    [Tags]    VOD
    [Documentation]    Locked Content In Ondemand Feed Starzplay
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK Ok
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	# VALIDATE THE LOCK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1002_Lock_In_OnDemand_Feed
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1002_Lock_In_OnDemand_Feed Is Displayed on screen
	...  ELSE  Fail  TC_1002_Lock_In_OnDemand_Feed Is Not Displayed on screen
    CLICK HOME
TC_1003_VALIDATE_HOMEPAGE_ICONS
    [Tags]    HOMEPAGE
    [Documentation]    Validate Homepage Icons
	CLICK HOME
	#CHCEK FOR THE ICONS IN THE HOMEPAGE
	CLICK ONE
    CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK HOME
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1003_Home_Page_Icons
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1003_Home_Page_Icons Is Displayed on screen
	...  ELSE  Fail  TC_1003_Home_Page_Icons Is Not Displayed on screen
	CLICK HOME

TC_1004_VALIDATE_HOMEPAGE_TEXT
    [Tags]    HOMEPAGE
    [Documentation]    Validate Homepage Text
	CLICK HOME
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK HOME

TC_1005_HARD_REBOOT_CHECK_LOGO
    [Tags]    ENGINEERING MENU
    [Documentation]    Hard Reboot Check Logo
	CLICK HOME
	Reboot STB device
	Sleep    10s
	#VALIADTE THE LOGO
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1001_Etisalat_Logo
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1001_Etisalat_Logo Is Displayed on screen
	...  ELSE  Fail  TC_1001_Etisalat_Logo Is Not Displayed on screen


TC_1006_PIN_ENTER_5_DIGITS
    [Tags]    ENGINEERING MENU
    [Documentation]    Pin Enter 5 Digits
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1006_wrong_pin
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1006_Wrong_Pin Is Displayed on screen
	...  ELSE  Fail  TC_1006_Wrong_Pin Is Not Displayed on screen
	CLICK HOME

TC_1007_RADIO_CHANNEL_RECORDING_RESTRICTION_VALIDATION
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
	#VALIADTE THAT RECORDIING  CANT BE DONE FOR RADIO CHANNEL
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1007_Recording_Radio_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1007_Recording_Radio Is Displayed on screen
	...  ELSE  Fail  TC_1007_Recording_Radio Is Not Displayed on screen
	CLICK OK
	CLICK HOME

TC_1008_GENRE_FILTER_BY_LANGUAGE
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	${pin}  Verify Crop Image With Shorter Duration   ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    Navigated to searched video
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK BACK
	#VALIDATE ARABIC TEXT IN SCREEN
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1008_Arabic_Lang
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1008_Arabic_Lang Is Displayed on screen
	...  ELSE  Fail  TC_1008_Arabic_Lang Is Not Displayed on screen
	CLICK HOME

TC_1009_MUTE_BUTTON_FUNCTIONALITY
    [Tags]    HOMEPAGE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	Sleep    3s
	CLICK MUTE
	Sleep	1s
	#VALIDATE THE MUTE BUTTON
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Android_Mute
	Run Keyword If  '${Result}' == 'True'  Log To Console  Mute_Remote_Button Is Displayed on screen
	...  ELSE  Fail  Mute_Remote_Button Is Not Displayed on screen
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK HOME
TC_1010_POWER_BUTTON_ON 
    [Tags]    ENGINEERING MENU
    [Documentation]  Power Button On  
	CLICK HOME
	CLICK POWER
	CLICK POWER
	Sleep	20s
	${pin}  Verify Crop Image With Shorter Duration   ${port}  Power_On_Login_Page
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK OK
	...    AND		CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    Navigated to Home Page
	Sleep	20s
	#VALIDATE THE HOME TEXT AFTER POWER ONN
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen

TC_1011_POWER_BUTTON_OFF
    [Tags]    HOMEPAGE
    [Documentation]    Power Button Off
	CLICK HOME
	CLICK POWER
	#VALIADTE THE BLACK SCREEEN
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1011_No_Signal
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1011_No_Signal Is Displayed on screen
	...  ELSE  Fail  TC_1011_No_Signal  Is Not Displayed on screen
	CLICK POWER
	Sleep	20s
	${pin}  Verify Crop Image With Shorter Duration   ${port}  Power_On_Login_Page
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK OK
	...    AND		CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    Navigated to Home Page
	Sleep	20s
	CLICK HOME

TC_1012_HOME_BUTTON_VALIDATION
    [Tags]    HOMEPAGE
    [Documentation]    Home Button Validation
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK HOME
	#VALIDATE THE HOME TEXT IN HOMEPAGE
	${Result}  Verify Crop Image  ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
    CLICK HOME

TC_1013_BACK_BUTTON_PREVIOUS_SCREEN
    [Tags]    HOMEPAGE
    [Documentation]    Back Button Previous Screen
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	${Result}  Verify Crop Image  ${port}  TC_1013_Channel_12
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
	#VALIDATE CHANNEL 12  AFTER CLICKING BACK BUTTON
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1013_Channel_12
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1013_Channel_12 Is Displayed on screen
	...  ELSE  Fail  TC_1013_Channel_12 Is Not Displayed on screen
    CLICK HOME
TC_1014_OK_BUTTON_VALIDATION
    [Tags]    HOMEPAGE
    [Documentation]    Ok Button Validation
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	#VALIDATE THE LIVE TV TO CHECK IF THE OK BUTTON IS WORKING 
	${Result}  Verify Crop Image  ${port}  TC_1014_Live_TV
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1014_Live_Tv Is Displayed on screen
	...  ELSE  Fail  TC_1014_Live_Tv Is Not Displayed on screen
    CLICK HOME
TC_1015_DIRECTIONAL_BUTTONS_UP_DOWN
    [Tags]    HOMEPAGE
    [Documentation]    Directional Buttons Up Down
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	#VALIADTE THE GENRE TO CHECK IF THE DOWN KEY IS WORKING 
	${Result}  Verify Crop Image  ${port}  TC_1015_Genre_BO
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1015_Genre_BO Is Displayed on screen
	...  ELSE  Fail  TC_1015_Genre_BO Is Not Displayed on screen
    CLICK HOME

TC_1016_MENU_BUTTON_MEMBER_VISIBILITY
    [Tags]    HOMEPAGE
    [Documentation]    Menu Button Member Visibility
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK MENU
	#VALIDATE THE HOME TEXT IN THE HOMEPAGE 
	${Result}  Verify Crop Image  ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
    CLICK HOME
TC_1017_VERIFY_ONDEMAND_SUBSCRIBE_BUTTON
	[Tags]    VOD
    [Documentation]    Browse ondemand and initiate playback
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK RIGHT
	CLICK Ok
	CLICK Right
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_1017_Subscribe_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1017_Subscribe_Button Is Displayed
	...  ELSE  Fail  TC_1017_Subscribe_Button Is Not Displayed
	CLICK HOME
TC_1018_VERIFY_ONDEMAND_SUBSCRIPTION_PANNEL_AVAILABILITY
	[Tags]    VOD
    [Documentation]    Browse ondemand and initiate playback
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK RIGHT
	CLICK Ok
	CLICK Right
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_1018_Subscription_Pannel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1018_Subscription_Pannel Is Displayed
	...  ELSE  Fail  TC_1018_Subscription_Pannel Is Not Displayed
	CLICK HOME


TC_1019_CHANNEL_UP_FUNCTIONALITY
    [Tags]    HOMEPAGE
    [Documentation]    Channel Up Functionality
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK BACK
	CLICK CHANNELUP
	#VALIADTE CHANNEL NUMBER 15
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1019_Channel_15
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1019_Channel_15 Is Displayed on screen
	...  ELSE  Fail  TC_1019_Channel_15 Is Not Displayed on screen
    CLICK HOME

TC_1020_CHANNEL_DOWN_FUNCTIONALITY
    [Tags]    HOMEPAGE
    [Documentation]    Channel Down Functionality
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK BACK
	CLICK CHANNELDWN
	#VALIDATE CHANNEL 11 TO KNOW THAT CHANNEL DOWN BUTTON IS WORKING FINE
	${Result}  Verify Crop Image  ${port}  TC_1020_Channel_11
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1020_Channel_11 Is Displayed on screen
	...  ELSE  Fail  TC_1020_Channel_11  Is Not Displayed on screen
    CLICK HOME

TC_1021_NUMERIC_KEYS_FUNCTIONALITY
    [Tags]    HOMEPAGE
    [Documentation]    Numeric Keys Functionality
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK SEVEN 
	CLICK TWO
	#VALIADTE THE CHANNEL NUMBER 72 
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_204_Channel_72
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_204_Channel_72 Is Displayed on screen
	...  ELSE  Fail  TC_204_Channel_72  Is Not Displayed on screen
    CLICK HOME

TC_1022_NON_EXISTING_CHANNEL_USING_NUMERIC_KEYS
    [Tags]    HOMEPAGE
    [Documentation]    Non Existing Channel Using Numeric Keys
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
	CLICK NINE
	CLICK EIGHT
	CLICK SEVEN
	CLICK SIX
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
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
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	#VALIDATE NO RESULT FOUND PAGE 
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1022_no_result
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1022_No_Result Is Displayed on screen
	...  ELSE  Fail  TC_1022_No_Result  Is Not Displayed on screen
    CLICK HOME
TC_1023_NUMERIC_KEYS_SEARCH_BAR
    [Tags]    STARTOVER
    [Documentation]    Numeric Keys Search Bar
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
	CLICK ONE
	CLICK TWO
	CLICK THREE
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
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
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	#VALIDATE THE CHANNEL 123 SEARCH RESULT
	${Result}  Verify Crop Image  ${port}  TC_1023_Channel_123
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1023_Channel_123 Is Displayed on screen
	...  ELSE  Fail  TC_1023_Channel_123  Is Not Displayed on screen
    CLICK HOME

	
TC_1024_MIC_BUTTON_PAIRING_SCREEN
    [Tags]    HOMEPAGE
    [Documentation]    Mic Button Pairing Screen
	CLICK HOME
	CLICK ONE
	CLICK TWO
	CLICK VOICE
	#VALIADTE THE PAIRING SCREEN VISIBILITY
	${Result}  Verify Crop Image  ${port}  TC_1024_Mic_Btn
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1024_Mic_Btn Is Displayed on screen
	...  ELSE  Fail  TC_1024_Mic_Btn  Is Not Displayed on screen
    CLICK HOME


TC_1025_RECORD_BUTTON_SETUP
    [Tags]    HOMEPAGE
    [Documentation]    Record Button Setup
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK RECORD
	#CHECK FOR THE RECORDING SETUP APPEARANCE
	${Result}  Verify Crop Image  ${port}  TC_1025_Recording_Setup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1025_Recording_Setup Is Displayed on screen
	...  ELSE  Fail  TC_1025_Recording_Setup  Is Not Displayed on screen
    CLICK HOME

TC_1026_VERIFY_ONDEMAND_BROWSE_CONTENT_SECTION
	[Tags]    VOD
    [Documentation]    Browse ondemand and initiate playback
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK Right
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	CLICK HOME

TC_1027_CONTINUOUS_VOLUME_BUTTON_HOLD_MUTE_CHECK
    [Tags]    HOMEPAGE
    [Documentation]    Continuous Down Volume Button Check
	CLICK Home
	CLICK One
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_PLUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	${Result}  Verify Crop Image With Shorter Duration    ${port}  Android_Mute
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1027_Mute_Button Is Displayed on screen
	...  ELSE  Fail  TC_1027_Mute_Button Is Not Displayed on screen
	CLICK Home

TC_1028_CONTINUOUS_UP_VOLUME_BUTTON_CHECK
    [Tags]    HOMEPAGE
    [Documentation]    Continuous Up Volume Button Check
	CLICK Home
	CLICK One
	CLICK TWO
	CLICK ZERO
	CLICK ONE
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Android_Full_Volume
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1028_Full_Volume Is Displayed on screen
	...  ELSE  Fail  TC_1028_Full_Volume Is Not Displayed on screen
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK VOLUME_MINUS
	CLICK Home

TC_1029_VERIFY_LIVE_CHANNEL_CHANGE
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
	CLICK SEVEN
	CLICK ONE
	CLICK ZERO
	CLICK FIVE
	Log To Console    Channel 7105 Is Pressed
	CLICK BACK
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1029_LIVE_CHANNEL_7105
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1013_Channel_7105 Is Displayed on screen
	...  ELSE  Fail  TC_1013_Channel_7105 Is Not Displayed on screen

TC_1030_PLAYBACK_BACK_BUTTON_PREVIOUS_CHANNEL
    [Tags]    TIMESHIFT
    [Documentation]    Playback Back Button Previous Channel
	CLICK Home
	CLICK Six
	CLICK Six
	CLICK Six
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1030_666_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1030_666_Channel Is Displayed on screen
	...  ELSE  Fail  TC_1030_666_Channel Is Not Displayed on screen
	Sleep    5s
	CLICK Six
	CLICK Seven
	CLICK Five
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1030_675_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1030_675_Channel Is Displayed on screen
	...  ELSE  Fail  TC_1030_675_Channel Is Not Displayed on screen
	
	CLICK Back
	CLICK Back
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1030_666_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1030_558_Channel Is Displayed on screen
	...  ELSE  Fail  TC_1030_558_Channel Is Not Displayed on screen
	CLICK Home

TC_1031_MYTV_RECORDER_REMINDER_SUBSCRIPTION_CHECK
    [Tags]    PROFILE & EDIT
    [Documentation]    Mytv Recorder Reminder Subscription Check
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1031_Recorder
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1031_Recorder Is Displayed on screen
	...  ELSE  Fail  TC_1031_Recorder Is Not Displayed on screen
	
	CLICK Down
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1031_Reminder
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1031_Reminder Is Displayed on screen
	...  ELSE  Fail  TC_1031_Reminder Is Not Displayed on screen
	
	CLICK Down
	${Result}   Verify Crop Image With Shorter Duration   ${port}  TC_1031_Subscriptions
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1031_Subscriptions Is Displayed on screen
	...  ELSE  Fail  TC_1031_Subscriptions Is Not Displayed on screen
	
	CLICK Home

TC_1032_LIVETV_CATCHUP_TVGUIDE_VALIDATION
    [Tags]    LIVE TV
    [Documentation]    Livetv Catchup Tvguide Validation
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1032_Live_TV
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1032_Live_TV Is Displayed on screen
	...  ELSE  Fail  TC_1032_Live_TV Is Not Displayed on screen
	
	CLICK Down
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1032_Catch_Up
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1032_Catch_Up Is Displayed on screen
	...  ELSE  Fail  TC_1032_Catch_Up Is Not Displayed on screen
	
	CLICK Down
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1032_TV_Guide
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1032_TV_Guide Is Displayed on screen
	...  ELSE  Fail  TC_1032_TV_Guide Is Not Displayed on screen
	CLICK Home
	
TC_1033_BOXOFFICE_LIBRARY_GENRE
    [Tags]    VOD
    [Documentation]    Boxoffice Library Genre
    CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1033_Library
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1033_Library Is Displayed on screen
	...  ELSE  Fail  TC_1033_Library Is Not Displayed on screen
	
	CLICK Down
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_1033_Genre
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1033_Genre Is Displayed on screen
	...  ELSE  Fail  TC_1033_Genre Is Not Displayed on screen
	CLICK Home

TC_1034_ONDEMAND_COLLECTIONS_STARZPLAY
    [Tags]    VOD
    [Documentation]    Ondemand Collections Starzplay
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1034_OnDemand
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1034_OnDemand Is Displayed on screen
	...  ELSE  Fail  TC_1034_OnDemand Is Not Displayed on screen
	
	CLICK Home

TC_1035_KIDS_KIDSCHANNELS
    [Tags]    PROFILE
    [Documentation]    Kids Kidschannels
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1035_Kids_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1035_Kids_Channel Is Displayed on screen
	...  ELSE  Fail  TC_1035_Kids_Channel Is Not Displayed on screen
	
	CLICK Home

TC_1036_INBOX_MSG_ICON_CLICK
    [Tags]    HOMEPAGE
    [Documentation]    Inbox Msg Icon Click
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1036_Inbox
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1036_Inbox Is Displayed on screen
	...  ELSE  Fail  TC_1036_Inbox Is Not Displayed on screen
	
	CLICK Home

TC_1037_GAMING_TILE_HOME_CHECK_MESSAGE
    [Tags]    PROFILE & EDIT
    [Documentation]    Gaming Tile Home Check Message
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
	CLICK OK
	Sleep    30s
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK HOME
	CLICK BACK
	CLICK BACK
	CLICK OK
	Sleep	20s
	# ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1036_Inbox
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1036_Inbox Is Displayed on screen
	# ...  ELSE  Fail  TC_1036_Inbox Is Not Displayed on screen
    #CHECK FOR THE MSG

TC_1038_VERIFY_PIN_ENTRY_VALIDATION
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
	CLICK Down
	CLICK Ok
	CLICK Ok
	${result}  Verify Crop Image With Shorter Duration   ${port}  TC_1038_Pin_Required
	run keyword if  '${result}' == 'true'  log to console  TC_1038_Pin_Required is displayed
	...  else  fail  TC_1038_Pin_Required is not displayed
	CLICK HOME

TC_1039_SEARCH_ICON_INPUT_VALIDATION
    [Tags]    STARTOVER
    [Documentation]    Search Icon Input Validation
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
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1039_Enter_Your_input
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1039_Enter_Your_input Is Displayed on screen
	...  ELSE  Fail  TC_1039_Enter_Your_input Is Not Displayed on screen
	
	CLICK Home
TC_1040_SEARCH_BY_POPUP
    [Tags]    STARTOVER
    [Documentation]    Search By Popup
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
	CLICK UP
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_1040_Search_By_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1040_Search_By_Popup Is Displayed on screen
	...  ELSE  Fail  TC_1040_Search_By_Popup Is Not Displayed on screen
	
	CLICK Home

TC_1041_SELECTED_TITLE_DISPLAY
    [Tags]    HOMEPAGE
    [Documentation]    Selected Title Display
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
	CLICK Ok
	CLICK Down
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_1041_Title
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1041_Title Is Displayed on screen
	...  ELSE  Fail  TC_1041_Title Is Not Displayed on screen
	CLICK Home

TC_1042_SEARCH_BACK_PANEL_GOES_OFF
    [Tags]    STARTOVER
    [Documentation]    Search Back Panel Goes Off
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
	CLICK BACK
	${Result}  Verify Crop Image With Shorter Duration    ${port}  TC_1039_Enter_Your_input
	Run Keyword If  '${Result}' == 'False'  Log To Console  TC_1039_Enter_Your_input Is Displayed on screen
	...  ELSE  Fail  TC_1039_Enter_Your_input Is Not Displayed on screen

    CLICK HOME

TC_1043_SETTINGS_POPUP_VALIDATION
    [Tags]    ENGINEERING MENU
    [Documentation]    Settings Popup Validation
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
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_1043_Settings
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1043_Settings Is Displayed on screen
	...  ELSE  Fail  TC_1043_Settings Is Not Displayed on screen

    CLICK HOME

TC_1044_SHOW_MORE_HOMEPAGE
    [Tags]    HOMEPAGE
    [Documentation]    Show More Homepage
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK HOME
	${Result}  Verify Crop Image  ${port}  TC_1044_Show_more
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1044_Show_more Is Displayed on screen
	...  ELSE  Fail  TC_1044_Show_more Is Not Displayed on screen
	CLICK HOME

TC_1045_LIBRARY_OK_UP_RIGHT_VALIDATE
    [Tags]    HOMEPAGE
    [Documentation]    Library Ok Up Right Validate
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK Up
	FOR    ${i}    IN RANGE    10
        CLICK Left
    END
	CLICK Right
	CLICK Right
	CLICK Ok
	Sleep    2s
    ${Result}  Verify Crop Image  ${port}  TC_1046_Letter
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1046_Letter Is Displayed on screen
	...  ELSE  Fail  TC_1046_Letter Is Not Displayed on screen
	CLICK Home

TC_1046_LIBRARY_CHECK_SIDE_PANEL
    [Tags]    HOMEPAGE
    [Documentation]    Library Check Previous Alphabetical
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	Sleep    2s
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	Sleep    2s
    ${Result}  Verify Crop Image  ${port}  TC_1046_Search_Icon_SP
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1046_Search_Icon_SP Is Displayed on screen
	...  ELSE  Fail  TC_1046_Search_Icon_SP Is Not Displayed on screen
	CLICK Home

TC_1047_SEARCH_IN_SIDE_PANEL
    [Tags]    STARTOVER
    [Documentation]    Search In Side Panel
	CLICK Home
	CLICK Five
	CLICK Two
	CLICK Two
	Sleep    1s
	CLICK Back
	CLICK Right
	CLICK Up
	CLICK Ok
	${Result}  Verify Crop Image  ${port}  TC_1039_Enter_Your_input
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1039_Enter_Your_input Is Displayed on screen
	...  ELSE  Fail  TC_1039_Enter_Your_input Is Not Displayed on screen
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Right
	CLICK Up
	CLICK Up
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
	Sleep    2s
	CLICK Home

TC_1048_SUBSCRIPTION_POPUP_VALIDATION
    [Tags]    PROFILE & EDIT
    [Documentation]    Subscription Popup Validation
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
    ${Result}  Verify Crop Image  ${port}  TC_1049_Subscription 
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1049_Subscription Is Displayed on screen
	...  ELSE  Fail  TC_1049_Subscription Is Not Displayed on screen	
    CLICK Home

TC_1049_MANAGE_DEVICE_SUBSCRIPTION_TRANSFER
    [Tags]    PROFILE & EDIT
    [Documentation]    Manage Device Subscription Transfer
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Right
	CLICK Right
	CLICK Down
	${Result}  Verify Crop Image  ${port}  TC_1050_Manage_Devices 
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1050_Manage_Devices Is Displayed on screen
	...  ELSE  Fail  TC_1050_Manage_Devices Is Not Displayed on screen
    CLICK Home

TC_1050_BOXOFFICE_BROWSE_BY_GENRE_CATEGORIES_DISPLAYED
    [Tags]    VOD
    [Documentation]    Boxoffice Browse By Genre Categories Displayed
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
	${Result}  Verify Crop Image  ${port}  TC_1052_Action 
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1052_Action Is Displayed on screen
	...  ELSE  Fail  TC_1052_Action Is Not Displayed on screen

	${Result}  Verify Crop Image  ${port}  TC_1052_Kids 
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1052_Kids Is Displayed on screen
	...  ELSE  Fail  TC_1052_Kids Is Not Displayed on screen
	...  
	${Result}  Verify Crop Image  ${port}  TC_1052_Drama 
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1052_Drama Is Displayed on screen
	...  ELSE  Fail  TC_1052_Drama Is Not Displayed on screen

    ${Result}  Verify Crop Image  ${port}  TC_1052_Family 
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1052_Family Is Displayed on screen
	...  ELSE  Fail  TC_1052_Family Is Not Displayed on screen
	CLICK Home

TC_1051_HOME_PAGE_DISPLAY_AFTER_RECORDING_VALIDATION
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK RECORD
	CLICK OK
	CLICK HOME
	#VALIADTE IF HOME PAGE IS DISPLAYED AFTER CLICKING HOME IN 1201
	${Result}  Verify Crop Image  ${port}  Home_Page 
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen

TC_1052_BUSINESS_HELP_FILTERED_CHANNEL_POPUP_CHECK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	#VALIDATE THE POP UP SHOWING CHANNEL IS BLOCKED DUE TO FILTER
	${Result}  Verify Crop Image  ${port}  TC_805_ok_button
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1052_Block_Popup Is Displayed on screen
	...  ELSE  Fail  TC_1052_Block_Popup Is Not Displayed on screen
	CLICK OK
    CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK HOME


TC_1053_LIFESTYLE_CHANNEL_ACCESS_CHECK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK DOWN
	CLICK OK
	CLICK BACK
	#VALIDATE
	# ${Result}  Verify Crop Image  ${port}  TC_1053_Lifestyle
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1053_Lifestyle Is Displayed on screen
	# ...  ELSE  Fail  TC_1053_Lifestyle Is Not Displayed on screen 
	# CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK HOME

TC_1054_BUSINESS_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	#VALIDATE - BUSINESS CHANNEL IF POSSIBLE
	${Result}  Verify Crop Image  ${port}  TC_1054_Business
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1054_Business Is Displayed on screen
	...  ELSE  Fail  TC_1054_Business Is Not Displayed on screen 
	# CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK HOME

TC_1055_DOCUMENTARY_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	#VALIDATE  THE DOCUMENTARY CHANNEL LISTED IN THE EPG
	${Result}  Verify Crop Image  ${port}  TC_1055_Documentary
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1055_Documentary Is Displayed on screen
	...  ELSE  Fail  TC_1055_Documentary Is Not Displayed on screen
	# CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK HOME

TC_1056_HD_CHANNELS_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	#VALIDATE  HD CHANNELS IN THE EPG 
	${Result}  Verify Crop Image  ${port}  TC_1056_HD_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1056_HD_Channel Is Displayed on screen
	...  ELSE  Fail  TC_1056_HD_Channel Is Not Displayed on screen
	# CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK HOME
TC_1057_INFORMATION_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	#VALIDATE  THE INFO CHANNEL DISPLAYED IN THE EPG
	${Result}  Verify Crop Image  ${port}  TC_1057_Information
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1057_Information Is Displayed on screen
	...  ELSE  Fail  TC_1057_Information Is Not Displayed on screen
	# CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK HOME

TC_1058_KIDS_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	#VALIDATE  KIDS CHANNEL
	${Result}  Verify Crop Image  ${port}  TC_1058_Kids
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1058_Kids Is Displayed on screen
	...  ELSE  Fail  TC_1058_Kids Is Not Displayed on screen
	# CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK HOME
TC_1059_MUSIC_CHANNEL_AVAILABILTY
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	#VALIDATE  KIDS CHANNEL
	${Result}  Verify Crop Image  ${port}  TC_1059_Music
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1059_Music Is Displayed on screen
	...  ELSE  Fail  TC_1059_Music Is Not Displayed on screen
	# CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME
	
TC_1060_ARABIC_KEYPAD_PRESENCE_CHECK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK UP
	CLICK OK
	#CHECK FOR THE ARABIC BUTTON IN THE KEYPAD 
	${Result}  Verify Crop Image  ${port}  TC_1060_Arabic_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1060_Arabic_Button Is Displayed on screen
	...  ELSE  Fail  TC_1060_Arabic_Button Is Not Displayed on screen
    CLICK HOME

TC_1061_ABCD_PIN_ENTRY_VALIDATION
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
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
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
	CLICK OK
	#WRONG PIN VALIDATION
    ${Result}  Verify Crop Image  ${port}  TC_1006_Wrong_Pin
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1006_Wrong_Pin Is Displayed on screen
	...  ELSE  Fail  TC_1006_Wrong_Pin Is Not Displayed on screen
	CLICK HOME
TC_1062_NEWS_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	#VALIDATE  KIDS CHANNEL
	${Result}  Verify Crop Image  ${port}  TC_1062_News
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1062_News Is Displayed on screen
	...  ELSE  Fail  TC_1062_News Is Not Displayed on screen
	CLICK OK
	CLICK HOME

TC_1063_SPORTS_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK BACK
	#VALIDATE  SPORTS CHANNEL
	${Result}  Verify Crop Image  ${port}  TC_1063_Sports
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1063_Sports Is Displayed on screen
	...  ELSE  Fail  TC_1063_Sports Is Not Displayed on screen
	CLICK OK
	CLICK HOME
TC_1064_GENRE_FILTER_BY_LANGUAGE_BUY_RENT_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
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
	...    ELSE
    ...        Run Keywords
    ...        Log To Console    ready to play VOD video
    ...        AND    CLICK OK
 	#VALIDATE BUY/RENT
	${Result}  Verify Crop Image  ${port}  TC_1064_Buy_Rent
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1064_Buy_Rent Is Displayed on screen
	...  ELSE  Fail  TC_1064_Buy_Rent Is Not Displayed on screen
	CLICK HOME


TC_1065_ACTION_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK BACK
	#VALIDATE  ACTION CHANNEL
	${Result}  Verify Crop Image  ${port}  TC_1065_Action_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1065_Action_Channel Is Displayed on screen
	...  ELSE  Fail  TC_1065_Action_Channel Is Not Displayed on screen
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

TC_1066_KIDS_MOVIE_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK BACK
	#VALIDATE  KIDS CHANNEL
	${Result}  Verify Crop Image  ${port}  TC_1066_Kids_Movie
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1066_Kids_Movie Is Displayed on screen
	...  ELSE  Fail  TC_1066_Kids_Movie Is Not Displayed on screen
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME
	

TC_1067_FAMILY_MOVIE_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK BACK
	#VALIDATE  FAMILY CHANNEL
	# ${Result}  Verify Crop Image  ${port}  TC_1067_Family
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1067_Family Is Displayed on screen
	# ...  ELSE  Fail  TC_1067_Family Is Not Displayed on screen
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME
	


TC_1068_NEWS_GENERAL_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK BACK
	#VALIDATE  NEWS GENERAL CHANNEL
	${Result}  Verify Crop Image  ${port}  TC_1068_News_General
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1068_News_General Is Displayed on screen
	...  ELSE  Fail  TC_1068_News_General Is Not Displayed on screen
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

TC_1069_NEWS_BUSINESS_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK OK
	CLICK BACK
	#VALIDATE  NEWS BUSINESS CHANNEL
	${Result}  Verify Crop Image  ${port}  TC_1069_News_Business
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1069_News_Business Is Displayed on screen
	...  ELSE  Fail  TC_1069_News_Business Is Not Displayed on screen
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME



TC_1070_SUBSCRIBED_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK OK
	CLICK BACK
	#VALIDATE  SUBSCRIBED CHANNEL
	# ${Result}  Verify Crop Image  ${port}  TC_1070_Subscribed_Channel
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1070_Subscribed_Channel Is Displayed on screen
	# ...  ELSE  Fail  TC_1070_Subscribed_Channel Is Not Displayed on screen
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

TC_1071_FAVORITE_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK OK
	CLICK BACK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	#VALIDATE  FAVORITE CHANNEL
	${Result}  Verify Crop Image  ${port}  TC_1071_Favorited_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1071_Favorited_Channel Is Displayed on screen
	...  ELSE  Fail  TC_1071_Favorited_Channel Is Not Displayed on screen
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME
TC_1072_CATCHUP_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK OK
	CLICK BACK
	CLICK BACK
	CLICK RIGHT
	#VALIDATE CATCHUP CHANNEL
	${Result}  Verify Crop Image  ${port}  Side_Pannel_Catchup_Option
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1072_Catchup_Channel Is Displayed on screen
	...  ELSE  Fail  TC_1072_Catchup_Channel Is Not Displayed on screen
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME
TC_1073_STARTOVER_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK OK
	CLICK BACK
	CLICK BACK
	CLICK RIGHT
	#VALIDATE STARTOVER CHANNEL
	${Result}  Verify Crop Image  ${port}  Start_Over
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1073_Startover_Channel Is Displayed on screen
	...  ELSE  Fail  TC_1073_Startover_Channel Is Not Displayed on screen
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME
TC_1074_ENTERTAINMENT_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	#VALIDATE ENTERTAINMENT CHANNEL
	# ${Result}  Verify Crop Image  ${port}  TC_1074_Entertainment
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1074_Entertainment Is Displayed on screen
	# ...  ELSE  Fail  TC_1074_Entertainment Is Not Displayed on screen
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME
TC_1075_GENERAL_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK BACK
	#VALIDATE GENERAL CHANNEL
    # ${Result}  Verify Crop Image  ${port}  TC_1075_General_Channel
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1075_General_Channel Is Displayed on screen
	# ...  ELSE  Fail  TC_1075_General_Channel Is Not Displayed on screen
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME

TC_1076_RELIGIOUS_CHANNEL_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	CLICK BACK
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
	CLICK BACK
	CLICK BACK
	CLICK RIGHT
	#VALIDATE RELIGIUOS CHANNEL
	${Result}  Verify Crop Image  ${port}  TC_1076_Religious_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1076_Religious_Channel Is Displayed on screen
	...  ELSE  Fail  TC_1076_Religious_Channel Is Not Displayed on screen
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK Up
	CLICK OK
	CLICK BACK
	CLICK HOME


TC_1077_RENT_IN_LIBRARY_RESTRICTED_CONTENT_POPUP
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK OK
	#VALIDATE THE CONTENT NOT SUITABLE POPUP
	${Result}  Verify Crop Image  ${port}  TC_1077_Rental_SP
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1077_Rental_SP Is Displayed on screen
	...  ELSE  Fail  TC_1077_Rental_SP Is Not Displayed on screen
	CLICK BACK
	CLICK HOME
TC_1078_BUY_IN_LIBRARY_RESTRICTED_CONTENT_POPUP
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK OK
	#VALIDATE THE CONTENT NOT SUITABLE POPUP
	${Result}  Verify Crop Image  ${port}  TC_1078_Buy_SP
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1078_Buy_SP Is Displayed on screen
	...  ELSE  Fail  TC_1078_Buy_SP Is Not Displayed on screen
	CLICK BACK
	CLICK HOME
TC_1079_TRAILER_IN_LIBRARY_VIDEO_PLAYBACK_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
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
	VALIDATE VIDEO PLAYBACK
	CLICK BACK
	CLICK HOME
TC_1080_ADD_TO_LIST_IN_LIBRARY_SUCCESS_POPUP_AVAILABILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	#VALIDATE SUCESS POPUP
	${Result}  Verify Crop Image  ${port}  TC_1080_Added_To_List
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1080_Added_To_List Is Displayed on screen
	...  ELSE  Fail  TC_1080_Added_To_List Is Not Displayed on screen
	CLICK OK
	CLICK BACK
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME

TC_1081_NICKNAME_MINIMUM_CHARACTER_VALIDATION
    [Tags]    PROFILE
    [Documentation]    Verify Nickname Minimum Character Validation
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
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	#vALIDATE THE ERROR
    ${Result}  Verify Crop Image  ${port}  TC_1083_Create_Profile_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1083_Create_Profile_Page Is Displayed on screen
	...  ELSE  Fail  TC_1083_Create_Profile_Page Is Not Displayed on screen
    CLICK HOME
TC_1082_CHECK_OK_BUTTON_IN_POPUP
    [Tags]    PROFILE
    [Documentation]    Verify OK Button Functionality While Creating New Profile
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
	CLICK DOWN
	#VALIDATE OK BUTTON IN POPUP
    ${Result}  Verify Crop Image  ${port}  TC_1082_Ok_Button 
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1082_Ok_Button Is Displayed on screen
	...  ELSE  Fail  TC_1082_Ok_Button Is Not Displayed on screen
    CLICK HOME

TC_1083_ERROR_VALIDATION_CHECKS
    [Tags]    PROFILE
    [Documentation]    Verify Error Validation Checks During Profile Creation
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
	CLICK ONE
	CLICK TWO
	CLICK THREE
	CLICK FOUR
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	#VALIDATE CREATE PROFILE PAGE IS PRESENT 
    ${Result}  Verify Crop Image  ${port}  TC_1083_Create_Profile_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1083_Create_Profile_Page Is Displayed on screen
	...  ELSE  Fail  TC_1083_Create_Profile_Page Is Not Displayed on screen
    CLICK HOME

TC_1084_VERIFY_SEARCH_ACCEPTS_NUMERIC_INPUT_PROFILE_PAGE

    [Tags]    PROFILE
    [Documentation]    Verify Error When Trying to Save Without Entering PIN
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
	CLICK ONE
	CLICK TWO
	CLICK THREE
	CLICK FOUR
	CLICK FIVE
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
	#VALIDATE 12345 IN THE SCREEN
	    ${Result}  Verify Crop Image  ${port}  TC_1084_Profile_12345
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1084_Profile_12345 Is Displayed on screen
	...  ELSE  Fail  TC_1084_Profile_12345 Is Not Displayed on screen
	#add delete profile
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

	

TC_1085_VALIDATE_WHETHER_SAVE_BUTTON_IS_HIGHLIGHTED
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
	CLICK ONE
	CLICK TWO
	CLICK THREE
	CLICK FOUR
	CLICK FIVE
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
	#VALIDATE WHETHER THE SAVE BUTTON IS HIGHLIGHTED
	${Result}  Verify Crop Image  ${port}  Save_Option
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1085_Save_Button Is Displayed on screen
	...  ELSE  Fail  TC_1085_Save_Button Is Not Displayed on screen
	CLICK HOME

TC_1086_NICKNAME_TAB_HIGHLIGHTED_WITHOUT_TEXT
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
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK ONE
	CLICK TWO
	CLICK THREE
	CLICK FOUR
	CLICK FIVE
	#VALIDATE THAT NICKNAME IS HIGHLIGHTED WITHOUT ANY LETTERS
	${Result}  Verify Crop Image  ${port}  TC_1086_Nickname_Tab
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1086_Nickname_Tab Is Displayed on screen
	...  ELSE  Fail  TC_1086_Nickname_Tab Is Not Displayed on screen
    CLICK HOME
TC_1087_VERIFY_PROFILE_BOX_IS_EMPTY
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
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	#VALIDATE PROFILE TYPE BOX IS EMPTY
	${Result}  Verify Crop Image  ${port}  TC_1087_Profile_Type
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1087_Profile_Type Is Displayed on screen
	...  ELSE  Fail  TC_1087_Profile_Type Is Not Displayed on screen
	CLICK HOME
TC_1088_VERIFY_SAVE_PROFILE_WITH_MISSING_DETAILS
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
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	#VALIDATE CREATE PROFILE PAGE
	${Result}  Verify Crop Image  ${port}   TC_1083_Create_Profile_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1083_Create_Profile_page Is Displayed on screen
	...  ELSE  Fail  TC_1083_Create_Profile_page Is Not Displayed on screen
	CLICK HOME
TC_1089_VALIDATE_WELCOME_WIZARD_ON_PROFILE_CREATION
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
	${Result}  Verify Crop Image  ${port}  TC_1089_Welcome_Wizard
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
	
TC_1090_VERIFY_MAYBE_LATER_OPTION_IN_SETUP_WIZARD
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK LEFT
	CLICK OK
	#VALIDATE WHOS WATCHING PAGE IS APPEARS
	${Result}  Verify Crop Image  ${port}  TC_1090_Who_watching_text
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1090_Who_watching_text Is Displayed on screen
	...  ELSE  Fail  TC_1090_Who_watching_text Is Not Displayed on screen
	CLICK RIGHT
    CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	
TC_1091_VERIFY_CREATED_PROFILE
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
	CLICK LEFT
	CLICK OK
	#VALIDATE NEW PROFILE CREATED IN THE WHO WATCHING PAGE
	${Result}  Verify Crop Image  ${port}  TC_1091_New_Profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1091_New_Profile Is Displayed on screen
	...  ELSE  Fail  TC_1091_New_Profile Is Not Displayed on screen
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

TC_1092_VERIFY_CANCEL_BUTTON_WITH_UNSAVED_DETAILS
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK RIGHT
	CLICK OK
	CLICK HOME
	#VALIDATE HOME TEXT IN HOME PAGE
	${Result}  Verify Crop Image  ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
TC_1093_VERIFY_SCREEN_LANGUAGE_IN_SETUP_WIZARD
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK OK
	#VALIDATE SCREEN LANGUAGE PAGE IS PRESENT
	${Result}  Verify Crop Image  ${port}  TC_1093_Screen_Language
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1093_Screen_Language Is Displayed on screen
	...  ELSE  Fail  TC_1093_Screen_Language Is Not Displayed on screen
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
	CLICK HOME

TC_1094_EXIT_SCREEN_LANGUAGE_IN_SETUP_WIZARD
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK OK
	CLICK LEFT
	CLICK OK
	#VALIDATE WHOS WATCHING PAGE IS PRESENT
	${Result}  Verify Crop Image  ${port}  TC_1090_Who_watching_text
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1090_Who_watching_text Is Displayed on screen
	...  ELSE  Fail  TC_1090_Who_watching_text Is Not Displayed on screen
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

TC_1095_VERIFY_CHOOSE_AVATAR_PAGE_IN_SETUP_WIZARD
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK OK
	CLICK OK
	#VALIDATE AVATAR PAGE
	${Result}  Verify Crop Image  ${port}  TC_1095_Avatar_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1095_Avatar_Page Is Displayed on screen
	...  ELSE  Fail  TC_1095_Avatar_Page Is Not Displayed on screen
	CLICK BACK
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
TC_1096_VERIFY_TIME_IN_CHOOSE_AVATAR_PAGE
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK OK
	CLICK OK
	#VALIDATE AM PM IN AVATAR PAGE
	${Result}  Verify Crop Image  ${port}  TC_1096_Avatar_Time_PM
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1096_Avatar_Time Is Displayed on screen
	...  ELSE  Fail  TC_1096_Avatar_Time Is Not Displayed on screen
	CLICK BACK
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

TC_1097_PROGRESS_TILE_IN_SETUP_WIZARD
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK OK
	CLICK OK
	CLICK OK
	#VALIDATE PROGRESS TILE IS IN 3RD
	${Result}  Verify Crop Image  ${port}  TC_1097_Progress_Tile
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1097_Progress_Tile Is Displayed on screen
	...  ELSE  Fail  TC_1097_Progress_Tile Is Not Displayed on screen
	CLICK BACK
	CLICK OK
	CLICK BACK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK

TC_1098_VERIFY_REMEMBER_ME_PAGE_IN_SETUP_WIZARD
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK LEFT
	CLICK OK
	#VALIDATE YES IS CHANGED TO RED
	${Result}  Verify Crop Image  ${port}  TC_1098_Yes_Option
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1098_Yes_Option Is Displayed on screen
	...  ELSE  Fail  TC_1098_Yes_Option Is Not Displayed on screen
	CLICK BACK
	CLICK OK
	CLICK BACK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK

TC_1099_EXIT_REMEMBER_ME_PAGE
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK OK
	#VALIDATE WHOS WATCHING
	${Result}  Verify Crop Image  ${port}  TC_1090_Who_watching_text
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1090_Who_watching_text Is Displayed on screen
	...  ELSE  Fail  TC_1090_Who_watching_text Is Not Displayed on screen
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
TC_1100_CHECK_SCREEN_LANGUAGE_HIGHLIGHTED
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK OK
	CLICK UP
	CLICK LEFT
	CLICK OK
	#VALIDATE HIGHLIGHTED ARABIC
	${Result}  Verify Crop Image  ${port}  TC_1100_Arabic_Option
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1100_Arabic_Option Is Displayed on screen
	...  ELSE  Fail  TC_1100_Arabic_Option Is Not Displayed on screen
	CLICK BACK
	CLICK OK
	CLICK BACK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK

TC_1101_VALIDATE_ERROR_POPUP_IN_SCREEN_LANGUAGE_SETUP_WIZARD
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK OK
	CLICK LEFT
	CLICK OK
	#VALIDATE ERROR POPUP
	${Result}  Verify Crop Image  ${port}  TC_1101_Error_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1101_Error_Popup Is Displayed on screen
	...  ELSE  Fail  TC_1101_Error_Popup Is Not Displayed on screen
	CLICK BACK
	CLICK OK
	CLICK BACK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK

TC_1102_CHECK_DISMISS_BUTTON_ERROR_POPUP
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK OK
	CLICK LEFT
	CLICK OK
	#VALIDATE DISMISS BUTTON IS PRESENT
	${Result}  Verify Crop Image  ${port}  TC_1102_Dismiss_Option
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1102_Dismiss_Option Is Displayed on screen
	...  ELSE  Fail  TC_1102_Dismiss_Option Is Not Displayed on screen
	CLICK BACK
	CLICK OK
	CLICK BACK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK

TC_1103_LAST_PAGE_PIN_POPUP_SETUP_WIZARD
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	#VALIDATE PIN POPUP
	${Result}  Verify Crop Image  ${port}  TC_1103_Content_Pin_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1103_Content_Pin_Popup Is Displayed on screen
	...  ELSE  Fail  TC_1103_Content_Pin_Popup Is Not Displayed on screen
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
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

TC_1104_PIN_POPUP_AFTER_COMPLETION_SETUP_WIZARD
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	#VALIDATE COMPLETED PAGE
	${Result}  Verify Crop Image  ${port}  TC_1104_Complete_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1104_Complete_Page Is Displayed on screen
	...  ELSE  Fail  TC_1104_Complete_Page Is Not Displayed on screen
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

TC_1105_FINISH_SETUP_IN_PROFILE
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK OK
	#VALIDATE WHO WATCHING PAGE
	${Result}  Verify Crop Image  ${port}  TC_1090_Who_watching_text
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1090_Who_watching_text Is Displayed on screen
	...  ELSE  Fail  TC_1090_Who_watching_text Is Not Displayed on screen
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK

TC_1106_GO_TO_SETTING_SETUP_WIZARD
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
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
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK LEFT
	CLICK OK
	#VALIDATE WHO WATCHING PAGE
	${Result}  Verify Crop Image  ${port}  TC_1090_Who_watching_text
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1090_Who_watching_text Is Displayed on screen
	...  ELSE  Fail  TC_1090_Who_watching_text Is Not Displayed on screen
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
TC_1107_ONDEMAND_BROWSE_TILE
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	#VALIDATE BROWSE BY GENRE,BROWSE BY ALL
	${Result}  Verify Crop Image  ${port}  TC_1107_Browse_Genre
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1107_Browse_Genre Is Displayed on screen
	...  ELSE  Fail  TC_1107_Browse_Genre Is Not Displayed on screen
	
	${Result}  Verify Crop Image  ${port}  TC_1107_Browse_By_All
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1107_Browse_By_All Is Displayed on screen
	...  ELSE  Fail  TC_1107_Browse_By_All Is Not Displayed on screen
	
TC_1108_CHECK_FOR_RETAINED_ICON_COLOUR
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
	Sleep    5s
	CLICK BACK
	#CHECK FOR RETAINED ICON COLOUR
	${Result}  Verify Crop Image  ${port}  TC_1108_Icon_Colour
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1108_Icon_Colour Is Displayed on screen
	...  ELSE  Fail  TC_1108_Icon_Colour Is Not Displayed on screen

TC_1109_CLEAR_BUTTON_FUNCTIONALITY_IN_KEYPAD
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
	CLICK LEFT
	#VALIADTE THE INPUT BOX IS EMPTY AFTER CLICKING THE CLEAR BUTTON IN THE KEYPAD
	${Result}  Verify Crop Image  ${port}  TC_1109_Search_Tab
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1109_Search_Tab Is Displayed on screen
	...  ELSE  Fail  TC_1109_Search_Tab Is Not Displayed on screen

TC_1110_ALPHABETICAL_SEARCH_IN_BOX_OFFICE
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	#VALIDATE D
	${Result}  Verify Crop Image  ${port}  TC_1110_Genre_D
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1110_Genre_D Is Displayed on screen
	...  ELSE  Fail  TC_1110_Genre_D Is Not Displayed on screen
    CLICK HOME
TC_1111_VALIDATE_PLAYBACK_AFTER_HOME_BUTTON_PRESS
	CLICK HOME
	CLICK TWO
	CLICK TWO
	CLICK HOME
	CLICK BACK
	#VALIDATE THE PLAYBACK OF CHANNEL 22
	${Result}  Verify Crop Image  ${port}  TC_1111_Channel_22
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1111_Channel_22 Is Displayed on screen
	...  ELSE  Fail  TC_1111_Channel_22 Is Not Displayed on screen
    CLICK HOME
TC_1112_CHECK_UNAVAILABLE_CHANNEL
	CLICK HOME
	CLICK ZERO
	#VALIDATE CHANNEL 1
	${Result}  Verify Crop Image  ${port}  TC_1112_Channel_1
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1112_Channel_1 Is Displayed on screen
	...  ELSE  Fail  TC_1112_Channel_1 Is Not Displayed on screen
    CLICK HOME
TC_1113_CHECK_CHANNEL_INFO
	CLICK HOME
	CLICK TWO
	CLICK FOUR
	CLICK SIX
	# CLICK BACK
	# Sleep    2s
	# CLICK UP
	#VALIDATE THE CHANNEL INFO
	${Result}  Verify Crop Image  ${port}  TC_1113_Channel_Info
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1113_Channel_Info Is Displayed on screen
	...  ELSE  Fail  TC_1113_Channel_Info Is Not Displayed on screen
	CLICK HOME
TC_1114_VERIFY_SIDE_PANEL_DISAPPEARANCE_AFTER_DELAY
	CLICK HOME
	CLICK SIX
	CLICK ZERO
	Sleep    2s
	CLICK BACK
	CLICK Right
	Sleep	10s
	#VALIDATE SIDE PANEL GOES OFF
	${Result}  Verify Crop Image  ${port}  TC_1114_Side_Panel
	Run Keyword If  '${Result}' == 'False'  Log To Console  TC_1114_Side_Panel Is Displayed on screen
	...  ELSE  Fail  TC_1114_Side_Panel Is Not Displayed on screen
	CLICK HOME
TC_1115_VERIFY_MENU_DISAPPEARANCE_AFTER_DELAY
	CLICK HOME
	CLICK SEVEN
	CLICK TWO
	Sleep	5s
	CLICK MENU
	Sleep    2s
	CLICK MENU
	#VALIDATE MENU GOES OFF
    ${Result}  Verify Crop Image  ${port}  Home_Page
	Run Keyword If  '${Result}' == 'False'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	CLICK HOME
TC_1116_VERIFY_SIDE_PANEL_DISAPPEARANCE_AFTER_BACK_PRESS
	CLICK HOME
	CLICK TWO
	CLICK FOUR
	CLICK SEVEN
	Sleep	2s
	CLICK BACK
	CLICK RIGHT
	CLICK BACK
	#VALIADTE THE SIDE PANEL GOES OFF ATER CLICKING THE BACK BUTTON
	${Result}  Verify Crop Image  ${port}  TC_1114_Side_Panel
	Run Keyword If  '${Result}' == 'False'  Log To Console  TC_1114_Side_Panel Is Displayed on screen
	...  ELSE  Fail  TC_1114_Side_Panel Is Not Displayed on screen
	CLICK HOME
TC_1117_SPORT_INFO_CHANNEL
	CLICK HOME
	CLICK SEVEN
	CLICK ZERO
	CLICK ZERO
	#VALIDATE THE CHANNEL INFO PAGE(701-799)
	${Result}  Verify Crop Image  ${port}  TC_1117_Sports_Info_Channel
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1117_Sports_Info_Channel Is Displayed on screen
	...  ELSE  Fail  TC_1117_Sports_Info_Channel Is Not Displayed on screen
	CLICK HOME
TC_1118_VOLUME_CHANGES
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
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
	CLICK MUTE
	CLICK MUTE
	#VALIDATE THE VOLUME FULL INDICATOR
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1028_Full_Volume
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1028_Full_Volume Is Displayed on screen
	...  ELSE  Fail  TC_1028_Full_Volume Is Not Displayed on screen
	CLICK HOME
TC_1119_CHANGE_GENRE_AVAILABILITY
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
    ${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
	${Result}  Verify Crop Image  ${port}  TC_1119_Change_Genre_SP
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1119_Change_Genre_SP Is Displayed on screen
	...  ELSE  Fail  TC_1119_Change_Genre_SP Is Not Displayed on screen
TC_1120_CHANGE_GENRE_POPUP
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	#VALIDATE THE POP UP OF GENRE
	${Result}  Verify Crop Image  ${port}  TC_1120_Genre_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1120_Genre_Popup Is Displayed on screen
	...  ELSE  Fail  TC_1120_Genre_Popup Is Not Displayed on screen
	CLICK HOME
TC_1121_LANGUAGE_POPUP_AVAILABILITY
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	#VALIDATE THE POP UP OF LANGUAGE
    ${Result}  Verify Crop Image  ${port}  TC_1121_Filter_Lang_Popup
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1121_Filter_Lang_Popup Is Displayed on screen
	...  ELSE  Fail  TC_1121_Filter_Lang_Popup Is Not Displayed on screen
TC_1122_FILTER_BY_LANGUAGE_AVAILABILITY
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	${pin}   Verify Crop Image With Shorter Duration   ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
	# CLICK OK 
	#VALIDATE THE PRESCENCE OF CHANGE LANGUAGE AVAILBILITY IN THE SIDE PANEL
	${Result}  Verify Crop Image With Shorter Duration  ${port}  TC_1122_Filter_Lang_SP
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1122_Filter_Lang_SP Is Displayed on screen
	...  ELSE  Fail  TC_1122_Filter_Lang_SP Is Not Displayed on screen
	CLICK HOME
TC_1123_CHECK_FOR_CAST
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	#VALIDATE THE CAST IN THE SCREEN AFTER SEARCH
	${Result}  Verify Crop Image  ${port}  TC_1123_Cast
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1123_Cast Is Displayed on screen
	...  ELSE  Fail  TC_1123_Cast Is Not Displayed on screen
	CLICK HOME

TC_1124_ACTION_GENRE
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
    ${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	#CHECK IF ACTION IS HIGHLIGHTED 
    ${Result}  Verify Crop Image  ${port}  TC_1124_Action
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1124_Action Is Displayed on screen
	...  ELSE  Fail  TC_1124_Action Is Not Displayed on screen
	CLICK HOME
TC_1125_GENRE_SORT
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
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video

	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK LEFT
	#CHECK IF Z IS THE THERE IN THE TILE/SHOWCARD
    ${Result}  Verify Crop Image  ${port}  TC_1125_Sort_Z
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1125_Sort_Z Is Displayed on screen
	...  ELSE  Fail  TC_1125_Sort_Z Is Not Displayed on screen
    # CLICK HOME
TC_1127_BOX_OFFICE_SORT
	CLICK HOME
 	CLICK UP
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK OK
 	CLICK DOWN
 	CLICK OK
 	CLICK OK
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
 	CLICK OK
 	CLICK OK
 	CLICK TWO
 	CLICK TWO
 	CLICK TWO
 	CLICK TWO
 	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	#CHECK IF SORT IS NOT HIGHLIGHTED
TC_1128_SORT_NEW_TO_OLD
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
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
 	CLICK OK
 	CLICK OK
 	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	#VALIDATE THAT SORTED AS NEW TO OLD 
TC_1129_ADVENTURE_FILTER_IN_CHANGE_GENRE	
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
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
	CLICK OK
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    1s
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK BACK
	#CHECK IN THE SCREEN IF BOXOFFICE>GENRE>ADVENTURE IS THERE 
    ${Result}  Verify Crop Image  ${port}  TC_1129_Adventure_BO
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1129_Adventure_BO Is Displayed on screen
	...  ELSE  Fail  TC_1130_Animation_BO Is Not Displayed on screen
	CLICK HOME	

TC_1130_CHECK_ANIMATION_IN_CHANGE_GENRE
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
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK DOWN
 	CLICK DOWN
	CLICK OK
 	CLICK OK
 	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
 	CLICK OK
 	CLICK DOWN
	CLICK DOWN
 	CLICK OK
 	CLICK BACK
 	#CHECK IN THE SCREEN IF BOXOFFICE>GENRE>ANIMATION IS THERE
    ${Result}  Verify Crop Image  ${port}  TC_1130_Animation_BO
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1130_Animation_BO Is Displayed on screen
	...  ELSE  Fail  TC_1130_Animation_BO Is Not Displayed on screen
	CLICK HOME
TC_1131_CHECK_COMEDY_IN_CHANGE_GENRE
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
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
 	CLICK OK
 	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
 	CLICK OK
 	CLICK DOWN
 	CLICK DOWN
	CLICK DOWN
 	CLICK OK
 	CLICK BACK
 	#CHECK IN THE SCREEN IF BOXOFFICE>GENRE>COMEDY IS THERE
	${Result}  Verify Crop Image  ${port}  TC_1131_Comedy_BO
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1131_Comedy_BO Is Displayed on screen
	...  ELSE  Fail  TC_1131_Comedy_BO Is Not Displayed on screen
	CLICK HOME
TC_1132_CHECK_DOCUMENTRY_IN_CHANGE_GENRE
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
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
 	CLICK OK
    CLICK OK
		${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
	Sleep    1s
 	CLICK OK
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
	CLICK DOWN
 	CLICK OK
 	CLICK BACK
 	#CHECK IN THE SCREEN IF BOXOFFICE>GENRE>DOCUMENTRY IS THERE
    ${Result}  Verify Crop Image  ${port}  TC_1132_Documentary_BO
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1132_Documentary_BO Is Displayed on screen
	...  ELSE  Fail  TC_1132_Documentary_BO Is Not Displayed on screen
	CLICK HOME
TC_1133_CHECK_DRAMA_IN_CHANGE_GENRE
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
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
 	CLICK OK
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
	Sleep    1s
 	CLICK OK
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
	CLICK DOWN
 	CLICK OK
 	CLICK BACK
 	#CHECK IN THE SCREEN IF BOXOFFICE>GENRE>DRAMA IS THERE
    ${Result}  Verify Crop Image  ${port}  TC_1133_Drama_BO
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1133_Drama_BO Is Displayed on screen
	...  ELSE  Fail  TC_1133_Drama_BO Is Not Displayed on screen
	CLICK HOME
TC_1134_CHECK_FAMILY_IN_CHANGE_GENRE
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
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
 	CLICK OK
 	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
	Sleep    1s
 	CLICK OK
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
	CLICK DOWN
 	CLICK OK
 	CLICK BACK
 	#CHECK IN THE SCREEN IF BOXOFFICE>GENRE>FAMILY IS THERE
    ${Result}  Verify Crop Image  ${port}  TC_1134_Family_BO
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1134_Family_BO Is Displayed on screen
	...  ELSE  Fail  TC_1134_Family_BO Is Not Displayed on screen
	CLICK HOME
TC_1135_CHECK_HORROR_IN_CHANGE_GENRE
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
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
 	CLICK OK
 	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
	Sleep    1s
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
 	#CHECK IN THE SCREEN IF BOXOFFICE>GENRE>HORROR IS THERE
	${Result}  Verify Crop Image  ${port}  TC_1135_Horror_BO
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1135_Horror_BO Is Displayed on screen
	...  ELSE  Fail  TC_1135_Horror_BO Is Not Displayed on screen
	CLICK HOME
TC_1136_CHECK_KIDS_IN_CHANGE_GENRE
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
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
 	CLICK OK
 	CLICK OK
		${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
	Sleep    1s
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
 	#CHECK IN THE SCREEN IF BOXOFFICE>GENRE>KIDS IS THERE
	${Result}  Verify Crop Image  ${port}  TC_1136_Kids_BO
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1136_Kids_BO Is Displayed on screen
	...  ELSE  Fail  TC_1136_Kids_BO Is Not Displayed on screen
	CLICK HOME
 
TC_1137_CHECK_MUSICAL_IN_CHANGE_GENRE
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
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
 	CLICK OK
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
	Sleep    1s
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
 	#CHECK IN THE SCREEN IF BOXOFFICE>GENRE>MUSICAL IS THERE
    ${Result}  Verify Crop Image  ${port}  TC_1137_Musical_BO
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1137_Musical_BO Is Displayed on screen
	...  ELSE  Fail  TC_1137_Musical_BO Is Not Displayed on screen
	CLICK HOME


TC_1138_CHECK_ROMANCE_IN_CHANGE_GENRE
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
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
 	CLICK OK
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
	Sleep    1s
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
 	#CHECK IN THE SCREEN IF BOXOFFICE>GENRE>ROMANCE IS THERE
	${Result}  Verify Crop Image  ${port}  TC_1138_Romance_BO
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1138_Romance_BO Is Displayed on screen
	...  ELSE  Fail  TC_1138_Romance_BO Is Not Displayed on screen
	CLICK HOME
TC_1139_CHECK_SCIENCE_FICTION_IN_CHANGE_GENRE
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
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
 	CLICK OK
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
	Sleep    1s
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
 	#CHECK IN THE SCREEN IF BOXOFFICE>GENRE>SCIENCE FICTION IS THERE
    ${Result}  Verify Crop Image  ${port}  TC_1139_SciFi_BO
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1139_SciFi_BO Is Displayed on screen
	...  ELSE  Fail  TC_1139_SciFi_BO Is Not Displayed on screen
	CLICK HOME
TC_1140_CHECK_THRILLER_IN_CHANGE_GENRE
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
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK RIGHT
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
 	CLICK OK
	CLICK OK
	${pin}  Verify Crop Image  ${port}  Pin_Block
	Run Keyword If    '${pin}'=='True'    
    ...    Run Keywords    CLICK TWO
    ...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK TWO
	...    AND    CLICK OK
	...    ELSE
    ...        Run Keyword
    ...        Log To Console    ready to play VOD video
    # ...        AND    CLICK OK
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK DOWN
 	CLICK OK
	Sleep    1s
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
 	#CHECK IN THE SCREEN IF BOXOFFICE>GENRE>THRILLER IS THERE
	${Result}  Verify Crop Image  ${port}  TC_1140_Thriller_BO
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1140_Thriller_BO Is Displayed on screen
	...  ELSE  Fail  TC_1140_Thriller_BO Is Not Displayed on screen
    CLICK HOME

TC_1141_VERIFY_START_OVER_AVAILABLILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	Sleep    2s
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image  ${port}  Start_over_icon
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	
TC_1142_VERIFY_REWIND_BUTTON_AVAILABLILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	Sleep    2s
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_1142_Rewind_Icon
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1142_Rewind_Icon Is Displayed
	...  ELSE  Fail  TC_1142_Rewind_Icon Is Not Displayed
TC_1126_VERIFY_PAUSE_AVAILABLILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	Sleep    2s
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed

TC_1143_VERIFY_PLAY_AVAILABLILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	Sleep    2s
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	Sleep    3s
	CLICK OK
	${Result}  Verify Crop Image  ${port}  Paly_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Paly_Button Is Displayed
	...  ELSE  Fail  Paly_Button Is Not Displayed
TC_1144_VERIFY_FAST_FORWARD_BUTTON_AVAILABLILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	Sleep    2s
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_1144_FF_Icon
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1144_FF_Icon Is Displayed
	...  ELSE  Fail  TC_1144_FF_Icon Is Not Displayed
TC_1145_VERIFY_NEXT_PROGRAM_AVAILABLILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	Sleep    2s
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_1145_Next_Icon
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1145_Next_Icon Is Displayed
	...  ELSE  Fail  TC_1145_Next_Icon Is Not Displayed
TC_1146_VERIFY_PREVIOUS_PROGRAM_AVAILABLILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	Sleep    2s
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_1146_Previous_Icon
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1146_Previous_Icon Is Displayed
	...  ELSE  Fail  TC_1146_Previous_Icon Is Not Displayed
TC_1147_VERIFY_AUDIO_LAUNGUAGE_ICON_AVAILABLILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	Sleep    2s
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_Audio_Icon
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_Audio_Icon Is Displayed
	...  ELSE  Fail  TC_Audio_Icon Is Not Displayed
TC_1148_VERIFY_SUBTITLE_TOGGLE_AVAILABLILITY
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# Sleep	2s
	# CLICK ONE
	# CLICK TWO
	Sleep	2s
	CLICK BACK
	Sleep    2s
	CLICK RIGHT
	#check for pause and play from side, and click it
	${STEP_COUNT}=    Move to Start Over On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
	# Sleep    3s	
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_1148_Subtitle_Icon
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1148_Subtitle_Icon Is Displayed
	...  ELSE  Fail  TC_1148_Subtitle_Icon Is Not Displayed

TC_1051_VERIFY_ONDEMAND_BROWSE_BUTTON
	[Tags]    VOD
    [Documentation]    Browse ondemand and initiate playback
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Right
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_1026_Browse_Button_Availability
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1026_Browse_Button_Availability Is Displayed
	...  ELSE  Fail  TC_1026_Browse_Button_Availability Is Not Displayed

##################################################################################################################


TC_401_RECORD_LIVE_CHANNEL_FOR_30_MINUTES
	[Tags]	RECORDING
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
	CLICK TWO
    Log To Console    Navigated To Channel 7102
	CLICK BACK
	CLICK RIGHT
	Sleep    1s
    ${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
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
    # ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_401_Rec_Start
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_401_Rec_Start Is Displayed
	# ...  ELSE  Fail  TC_401_Rec_Start Is Not Displayed	
	CLICK OK
	Sleep    180s
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
	Log To Console    Navigated to Recorder Section
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_215_Stopped_Recording
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Stopped Is Displayed
	...  ELSE  Fail  TC_215_Recording_Stopped Is Not Displayed	
	Log To Console    Recording Stopped
	CLICK OK
	CLICK HOME


TC_402_PLAY_COMPLETED_RECORDING_FROM_LOCAL_STORAGE
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
	CLICK TWO
    Log To Console    Navigated To Channel 7102
	CLICK BACK
	CLICK RIGHT
	Sleep    1s
    ${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
	CLICK OK
    Log To Console    Tapped Record Button
    CLICK DOWN 
    CLICK OK
	Log To Console    Record The Program Is Selected
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK
    Log To Console    Playback Recording Started
    #image validation required - verify the recording started popup
    ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_215_Recording_Started
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Started Is Displayed
	...  ELSE  Fail  TC_215_Recording_Started Is Not Displayed	
	CLICK OK
	Sleep    180s
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
	Log To Console    Navigated to Recorder Section
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_215_Recording_Stopped
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Stopped Is Displayed
	...  ELSE  Fail  TC_215_Recording_Stopped Is Not Displayed	
	Log To Console    Recording Stopped
	CLICK OK
	Sleep    1s
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Back
	CLICK Back
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	${Result}  Verify Crop Image With Shorter Duration   ${port}  Delete_Message
	Run Keyword If  '${Result}' == 'True'  Log To Console  Delete_Message
	...  ELSE  Fail  Delete_Message Is Not Displayed
	CLICK Ok
	CLICK Ok
	CLICK Home

TC_403_START_AND_PAUSE_RECORDING_SIMULTANEOUSLY
	CLICK RESET
	CLICK SEVEN
	CLICK ZERO
	CLICK FIVE
	CLICK OK
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
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK RESET
	CLICK SEVEN
	CLICK ZERO
	CLICK FIVE
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK



TC_404_SCHEDULE_FUTURE_RECORDING_USING_EPG
	CLICK Home
	Log To Console    Navigated To Home Page
	CLICK Up
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	Log To Console    Navigated To Tv Guide
	CLICK Ok
	
	
	CLICK Right
	CLICK Down
	CLICK Ok
	${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Tapped Record Button
    # CLICK DOWN 
    CLICK OK
	Log To Console    Record The Program Is Selected
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK OK
	CLICK DOWN
	CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK
	CLICK Ok
	CLICK Ok
	CLICK Back
	CLICK Back
	Sleep    180s
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
	Sleep    10s
	# ${Result}  Verify Crop Image  ${port}  Recorder_Feed
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Recorder_Feed Is Displayed
	# ...  ELSE  Fail  Recorder_Feed Is Not Displayed	
	Log To Console    Navigated to Recorder Section
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK

	# ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Stopped
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Stopped Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Stopped Is Not Displayed	
	# Log To Console    Recording Stopped
	CLICK OK
    CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  Delete_Message
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Delete_Message
	# ...  ELSE  Fail  Delete_Message Is Not Displayed
	CLICK OK
	CLICK OK
	CLICK OK
	Log To Console    Recording Deleted
	CLICK Home


TC_406_STOP_RECORDING_MANUALLY_AND_PLAY_BACK
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
	CLICK TWO
    Log To Console    Navigated To Channel 7102
	CLICK BACK
	CLICK RIGHT
	Sleep    1s
    ${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Tapped Record Button
    CLICK DOWN 
    CLICK OK
	Log To Console    Record The Program Is Selected
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK
    
    CLICK OK
    Log To Console    Playback Recording Started
    #image validation required - verify the recording started popup
    # ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Started
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Started Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Started Is Not Displayed	
	CLICK OK
	Sleep    5s
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
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Log To Console    Recording Stopped Successfully
    #Delete the Recorded Programs
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
	CLICK OK
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  Delete_Message
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Delete_Message
	# ...  ELSE  Fail  Delete_Message Is Not Displayed
	CLICK OK
	CLICK OK
	Log To Console    Recorded Program Deleted Successfully
	CLICK HOME


TC_407_RECORD_TWO_CHANNELS_SIMULTANEOUSLY
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
	CLICK TWO
    Log To Console    Navigated To Channel 7102
	CLICK BACK
	CLICK RIGHT
	Sleep    1s
    # ${STEP_COUNT}=    Move to Record On Side Pannel
	# CLICK RIGHT
    # FOR    ${i}    IN RANGE    ${STEP_COUNT}
    #     CLICK DOWN
    # END
    CLICK OK
    Log To Console    Tapped Record Button
    CLICK DOWN 
    CLICK OK
	Log To Console    Record The Program Is Selected
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK
   
    CLICK OK
    Log To Console    Playback Recording Started
    #image validation required - verify the recording started popup
    # ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Started
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Started Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Started Is Not Displayed	
	CLICK OK
	CLICK Seven
	CLICK Zero
	CLICK Two
	Log To Console    Navigated To Channel 7102
	CLICK BACK
	CLICK RIGHT
	Sleep    1s
    ${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Tapped Record Button
    CLICK DOWN 
    CLICK OK
	Log To Console    Record The Program Is Selected
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK
    
    CLICK OK
    Log To Console    Playback Recording Started
    #image validation required - verify the recording started popup
    # ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Started
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Started Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Started Is Not Displayed	
	CLICK OK
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	Sleep    10s
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Ok
	Log To Console    Recording stopped
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Back
	CLICK Back
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Back
	CLICK Back
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	# ${Result}  Verify Crop Image  ${port}  Delete_Message
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Delete_Message
	# ...  ELSE  Fail  Delete_Message Is Not Displayed
	CLICK Ok
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	${Result}  Verify Crop Image  ${port}  Delete_Message
	Run Keyword If  '${Result}' == 'True'  Log To Console  Delete_Message
	...  ELSE  Fail  Delete_Message Is Not Displayed
	CLICK Ok
	CLICK Ok
	CLICK Home


TC_408_DELETE_RECORDED_FILE_FROM_STORAGE_AND_CONFIRM_REMOVAL
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
	CLICK TWO
    Log To Console    Navigated To Channel 7102
	CLICK BACK
	CLICK RIGHT
	Sleep    1s
    ${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Tapped Record Button
    CLICK DOWN 
    CLICK OK
	Log To Console    Record The Program Is Selected
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK
   
    CLICK OK
    Log To Console    Playback Recording Started
    #image validation required - verify the recording started popup
    # ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Started
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Started Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Started Is Not Displayed	
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
	Sleep    10s
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  Delete_Message
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Delete_Message
	# ...  ELSE  Fail  Delete_Message Is Not Displayed	
	CLICK OK
	CLICK OK
	Log To Console    Recorded Program Deleted Successfully
	CLICK HOME

TC_410_PLAY_RECORDING_WHILE_ANOTHER_IS_IN_PROGRESS
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
	CLICK TWO
    Log To Console    Navigated To Channel 7102
	CLICK BACK
	CLICK RIGHT
	Sleep    1s
    ${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Tapped Record Button
    CLICK DOWN 
    CLICK OK
	Log To Console    Record The Program Is Selected
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK
    
    CLICK OK
    Log To Console    Playback Recording Started
    #image validation required - verify the recording started popup
    # ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Started
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Started Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Started Is Not Displayed	
	CLICK OK
	
	CLICK SEVEN
	CLICK ONE
	CLICK ONE
	
    Log To Console    Navigated To Channel 711
	CLICK BACK
	CLICK RIGHT
	Sleep    1s
    ${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Tapped Record Button
    CLICK DOWN 
    CLICK OK
	Log To Console    Record The Program Is Selected
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK
    
    CLICK OK
    Log To Console    Playback Recording Started
    #image validation required - verify the recording started popup
    # ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Started
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Started Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Started Is Not Displayed	
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
	Sleep    10s
	CLICK OK
	Log To Console    Navigated to Recorder Section
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Stopped
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Stopped Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Stopped Is Not Displayed	
	Log To Console    Recording Stopped
	CLICK OK
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	# ${Result}  Verify Crop Image  ${port}  Pause_Button
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	# ...  ELSE  Fail  Pause_Button Is Not Displayed
	
	# VALIDATE VIDEO PLAYBACK
	CLICK Back
	CLICK Back
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	# ${Result}  Verify Crop Image  ${port}  Delete_Message
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Delete_Message
	# ...  ELSE  Fail  Delete_Message Is Not Displayed
	CLICK Ok
	CLICK Ok
	CLICK Home

TC_414_RECORD_LIVE_STREAM_WITH_SUBTITLES_AND_PLAY_BACK
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Seven
	CLICK One
	CLICK Zero
	CLICK Five
	CLICK Right
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Back
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK OK
	CLICK DOWN
	CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK
	
	CLICK Up
	CLICK Ok
	CLICK Ok
	CLICK Up
	CLICK Up
	CLICK Up
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Up
	CLICK Ok
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok

TC_415_FAST_FORWARD_PROGRAM_AND_RESUME_PLAYBACK
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK Seven
	CLICK Zero
	CLICK Two
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK OK
	CLICK DOWN
	CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK

	CLICK Ok
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
	Log To Console    Navigated to Recorder Section
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Stopped
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Stopped Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Stopped Is Not Displayed	
	# Log To Console    Recording Stopped
	CLICK OK
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Right
	# ${Result}  Verify Crop Image  ${port}  x4_Forward
	# Run Keyword If  '${Result}' == 'True'  Log To Console  x4_Forward Is Displayed
	# ...  ELSE  Fail  x4_Forward Is Not Displayed
	Sleep    1s
	CLICK OK
	# validate 8x fastforward 
	Sleep    3s
	# ${Result}  Verify Crop Image  ${port}  x8_Forward
	# Run Keyword If  '${Result}' == 'True'  Log To Console  x8_Forward Is Displayed
	# ...  ELSE  Fail  x8_Forward Is Not Displayed
	Log To Console    8x fastforward 
    Sleep    1s
	CLICK OK
	# validate 16x fastforward 
	Sleep    3s
	# ${Result}  Verify Crop Image  ${port}  x16_Forward
	# Run Keyword If  '${Result}' == 'True'  Log To Console  x16_Forward Is Displayed
	# ...  ELSE  Fail  x16_Forward Is Not Displayed
    Log To Console    Playback Progressed Forward
    #check for 4x,8x,16x visibility in seekbar
    CLICK LEFT
    CLICK OK
    Log To Console    Video Playback Resumed
	# VALIDATE VIDEO PLAYBACK
	CLICK Back
	CLICK Back
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	# ${Result}  Verify Crop Image  ${port}  Delete_Message
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Delete_Message
	# ...  ELSE  Fail  Delete_Message Is Not Displayed
	CLICK Ok
	CLICK Ok
	CLICK Home

TC_416_REWIND_RECORDED_PROGRAM_AND_RESUME_PLAYBACK
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
	CLICK TWO
    Log To Console    Navigated To Channel 7102
	CLICK BACK
	CLICK RIGHT
	Sleep    1s
    ${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Tapped Record Button
    CLICK DOWN 
    CLICK OK
	Log To Console    Record The Program Is Selected
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK
    # CLICK DOWN
    CLICK OK
    Log To Console    Playback Recording Started
    #image validation required - verify the recording started popup
    # ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Started
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Started Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Started Is Not Displayed	
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
	Sleep    10s
	CLICK OK
	Log To Console    Navigated to Recorder Section
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Stopped
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Stopped Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Stopped Is Not Displayed	
	# Log To Console    Recording Stopped
	CLICK OK
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK LEFT
	CLICK Ok
    # ${Result}  Verify Crop Image  ${port}  REWIND_4X
	# Run Keyword If  '${Result}' == 'True'  Log To Console  REWIND_4X Is Displayed
	# ...  ELSE  Fail  REWIND_4X Is Not Displayed
	CLICK RIGHT
	CLICK OK
    Log To Console    Video Playback Resumed
	# VALIDATE VIDEO PLAYBACK	

	CLICK Back
	CLICK Back
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	# ${Result}  Verify Crop Image  ${port}  Delete_Message
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Delete_Message
	# ...  ELSE  Fail  Delete_Message Is Not Displayed
	CLICK Ok
	CLICK Ok
	Log To Console    Recorded program Deleted Successfully
	CLICK Home

TC_417_PAUSE_RECORDED_PROGRAM_AND_RESUME_PLAYBACK
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
	CLICK TWO
    Log To Console    Navigated To Channel 7102
	CLICK BACK
	CLICK RIGHT
	Sleep    1s
    ${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Tapped Record Button
    CLICK DOWN 
    CLICK OK
	Log To Console    Record The Program Is Selected
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK
  
    CLICK OK
    Log To Console    Playback Recording Started
    #image validation required - verify the recording started popup
    # ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Started
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Started Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Started Is Not Displayed	
	CLICK OK
	CLICK Home
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
	CLICK OK
	CLICK OK
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Stopped
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Stopped Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Stopped Is Not Displayed	
	Log To Console    Recording Stopped
	CLICK OK
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
    #Pause the playback
	CLICK Ok
	# ${Result}  Verify Crop Image  ${port}  Play_Button
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Play_Button Is Displayed
	# ...  ELSE  Fail  Play_Button Is Not Displayed
	CLICK Ok
	CLICK Back
	CLICK Back
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	# ${Result}  Verify Crop Image  ${port}  Delete_Message
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Delete_Message
	# ...  ELSE  Fail  Delete_Message Is Not Displayed
	CLICK Ok
	CLICK Ok
	CLICK Home


TC_419_SCHEDULE_RECORDING_THEN_CANCEL_BEFORE_START
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK SEVEN
	CLICK ONE
	CLICK ONE
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK BACK
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
	CLICK RIGHT
	CLICK LEFT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK HOME


TC_421_PLAY_RECORDING_AND_JUMP_TO_SPECIFIC_TIMESTAMP
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
	CLICK TWO
    Log To Console    Navigated To Channel 7102
	CLICK BACK
	CLICK RIGHT
	Sleep    1s
    ${STEP_COUNT}=    Move to Record On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Log To Console    Tapped Record Button
    CLICK DOWN 
    CLICK OK
	Log To Console    Record The Program Is Selected
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK
    # CLICK DOWN
    CLICK OK
    Log To Console    Playback Recording Started
    #image validation required - verify the recording started popup
    ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Started
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Started Is Displayed
	...  ELSE  Fail  TC_215_Recording_Started Is Not Displayed	
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
	CLICK OK
	CLICK OK
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Stopped
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Stopped Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Stopped Is Not Displayed	
	Log To Console    Recording Stopped
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    5s
	CLICK OK
	# VALIDATE VIDEO PLAYBACK
	CLICK BACK
	CLICK BACK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  Delete_Message
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Delete_Message
TC_422_RECORD_LIVE_SPORTS_EVENT_AND_PLAY_BACK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK SEVEN
	CLICK ZERO
	CLICK ONE
	CLICK OK
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
	CLICK OK
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
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	Sleep    5s
	CLICK BACK
	CLICK BACK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  Delete_Message
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Delete_Message
	# ...  ELSE  Fail  Delete_Message Is Not Displayed
	CLICK OK
	CLICK OK
	CLICK HOME


TC_423_SCHEDULE_RECURRING_RECORDING_AND_VERIFY_INSTANCES
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK Seven
	CLICK Zero
	CLICK Two
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
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
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Back
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	# ${Result}  Verify Crop Image  ${port}  Delete_Message
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Delete_Message
	# ...  ELSE  Fail  Delete_Message Is Not Displayed
	CLICK Ok
	CLICK Ok
	CLICK Home

TC_424_RECORD_CHANNEL_WHILE__WATCHING_DIFFERENT_LIVE_CHANNEL
	CLICK Home
	CLICK Up
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK Seven
	CLICK Zero
	CLICK Two
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK OK
	CLICK DOWN
	CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK
	# CLICK Down
	# CLICK Down
	# CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Seven
	CLICK One
	CLICK One
	CLICK Ok
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
	CLICK OK
	CLICK OK
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Stopped
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Stopped Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Stopped Is Not Displayed	
	# Log To Console    Recording Stopped
	CLICK OK
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Up
	CLICK Ok
	CLICK Home


TC_430_PLAY_RECORDED_PROGRAM_WITH_DIFFERENT_AUDIO_TRACK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK SEVEN
	CLICK TWO
	CLICK ONE
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK OK
	# CLICK DOWN
	# CLICK DOWN
	# CLICK OK
	CLICK OK
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
	CLICK OK
	CLICK OK
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  TC_215_Recording_Stopped
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_Recording_Stopped Is Displayed
	# ...  ELSE  Fail  TC_215_Recording_Stopped Is Not Displayed	
	# Log To Console    Recording Stopped
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK LEFT
	CLICK BACK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  Delete_Message
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Delete_Message
	# ...  ELSE  Fail  Delete_Message Is Not Displayed
	CLICK OK
	CLICK OK
	CLICK HOME

TC_433_RECORD_LIVE_STREAM_WHILE_SWITCHING_USER_PROFILES
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
	${Result}  Verify Crop Image  ${port}  TC_019_Whos_Watching
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_019_Whos_Watching Is Displayed
	...  ELSE  Fail  TC_019_Whos_Watching Is Not Displayed
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
	CLICK Ok
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
	# CLICK Right
	# CLICK Right
	# CLICK Right
	# CLICK Right
	# CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	# CLICK Ok
	CLICK Seven
	CLICK One
	CLICK Zero
	CLICK Five
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	Sleep    180s
	CLICK Home
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
	CLICK Right
	CLICK Ok
	# CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
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
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Home
	Log To Console    Navigated To Home Page
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Right
	CLICK Ok
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Ok
	Sleep    5s
	CLICK Back
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Down
	CLICK Ok
	CLICK Ok
	CLICK Ok
	CLICK Home
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
	CLICK Right
	CLICK Down
	CLICK Down
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Down
	CLICK Ok
	CLICK Home
	# ...  ELSE  Fail  Delete_Message Is Not Displayed
	CLICK OK
	CLICK OK
	Log To Console    Recorded Program Deleted Successfully
	CLICK HOME

################################## PROFILE NEW CASES ###########################

TC_2001_VERIFY_ALWAYS_LOGIN_WITH_THIS_PROFILE_FUNCTIONALITY_IN_PROFILE_SELECTION_PAGE_WITH_REBOOT
    [Tags]    PROFILE & EDIT
	[Teardown]    DELETE PROFILE
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
	${Result}  Verify Crop Image  ${port}  Logged_In_Subprofile
	Run Keyword If  '${Result}' == 'True'  Log To Console  Logged_In_Subprofile Is Displayed on screen
	...  ELSE  Fail  Logged_In_Subprofile Is Not Displayed on screen
	CLICK HOME
	Reboot STB Device
	${Result}  Verify Crop Image  ${port}  Home_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Home_Page Is Displayed on screen
	...  ELSE  Fail  Home_Page Is Not Displayed on screen
	Revert Always Login for subprofile
	

TC_2002_VERIFY_ALWAYS_LOGIN_WITH_THIS_PROFILE_FUNCTIONALITY_IN_PROFILE_SELECTION_PAGE_WITH_STANDBY
    [Tags]    PROFILE & EDIT
	[Teardown]    DELETE PROFILE
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
	${Result}  Verify Crop Image  ${port}  Logged_In_Subprofile
	Run Keyword If  '${Result}' == 'True'  Log To Console  Logged_In_Subprofile Is Displayed on screen
	...  ELSE  Fail  Logged_In_Subprofile Is Not Displayed on screen
	CLICK HOME
	CLICK POWER
	Sleep    5s
	CLICK POWER
	Sleep    20s
	${Result}  Verify Crop Image  ${port}  TC_1001_Etisalat_Logo
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_1001_Etisalat_Logo Is Displayed on screen
	...  ELSE  Fail  TC_1001_Etisalat_Logo Is Not Displayed on screen
	Revert Always Login for subprofile


TC_2003_VERIFY_AUDIO_LANGUAGE_IN_CHILD_PROFILE
    [Tags]    PROFILE & EDIT
	[Teardown]    DELETE PROFILE
    Create Kids Profile
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
	${Result}  Verify Crop Image  ${port}  AUDIO_ENGLISH
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
	Sleep    1s
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
	${Result}  Verify Crop Image  ${port}  CONFIRM_AUDIO_ENGLISH
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
	${Result}  Verify Crop Image  ${port}  Arabic_Language
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
	Sleep    1s
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
	${Result}  Verify Crop Image  ${port}  child_profile_urdu_lang
	Run Keyword If  '${Result}' == 'True'  Log To Console  CONFIRM_AUDIO_URDU Is Displayed on screen
	...  ELSE  Fail  CONFIRM_AUDIO_URDU Is Not Displayed on screen
	CLICK HOME

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
	# ${Result}  Verify Crop Image  ${port}  TC_010_ok
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_010_ok Is Displayed on screen
	# ...  ELSE  Fail  TC_010_ok Is Not Displayed on screen
	
	CLICK OK
	CLICK HOME
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
	CLICK TWO
	${Result}  Verify Crop Image  ${port}  TC_010_Rating_Confirmation_PopUp
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
	[Teardown]    DELETE PROFILE
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
	Reboot STB Device
	Navigate and Login to Kids profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# CLICK Three
	# CLICK TWO
	# CLICK SIX
	CLICK Three
	CLICK one
	CLICK SIX
	Sleep    2s 
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
	${Result}  Verify Crop Image  ${port}  TC_009_ARABIC
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
	Reboot STB Device
	Navigate and Login to Kids profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# CLICK Three
	# CLICK TWO
	# CLICK SIX
	CLICK Three
	CLICK one
	CLICK Six
	Sleep    2s
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
	${Result}  Verify Crop Image  ${port}  CONFIRM_AUDIO_ENGLISH
	Run Keyword If  '${Result}' == 'True'  Log To Console  CONFIRM_AUDIO_ENGLISH Is Displayed
	...  ELSE  Fail  CONFIRM_AUDIO_ENGLISH Is Not Displayed
	
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
	Reboot STB Device
	Navigate and Login to Kids profile
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	# CLICK Three
	# CLICK TWO
	# CLICK SIX
	CLICK Three
	CLICK one
	CLICK Nine
	Sleep    2s
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

	${Result}  Verify Crop Image  ${port}  None_Validation
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


TC_2006_VERIFY_CHANNEL_UNLOCK_INDIVIDUALLY_WITH_REBOOT
    [Tags]    PROFILE & EDIT
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
    ${Result}  Verify Crop Image  ${port}  5_Lock_Channels
	Run Keyword If  '${Result}' == 'True'  Log To Console  5_Lock_Channels Is Displayed on screen
	...  ELSE  Fail  5_Lock_Channels Is Not Displayed on screen
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
	Reboot STB Device
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
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK MULTIPLE TIMES    2    UP
	CLICK OK
	CLICK RIGHT
    ${Result}  Verify Crop Image  ${port}  5_Unlocked_Channels
	Run Keyword If  '${Result}' == 'True'  Log To Console  5_Unlocked_Channels Is Displayed on screen
	...  ELSE  Fail  5_Unlocked_Channels Is Not Displayed on screen
	CLICK MULTIPLE TIMES    2    UP
	CLICK MULTIPLE TIMES    3    RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK
	CLICK HOME


TC_2007_VERIFY_CHANNEL_UNLOCK_AT_ONCE_WITH_REBOOT
    [Tags]    PROFILE & EDIT
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
    ${Result}  Verify Crop Image  ${port}  5_Lock_Channels
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
	Reboot STB Device
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
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK MULTIPLE TIMES    2    UP
	CLICK OK
	CLICK RIGHT
    ${Result}  Verify Crop Image  ${port}  5_Unlocked_Channels
	Run Keyword If  '${Result}' == 'True'  Log To Console  5_Unlocked_Channels Is Displayed on screen
	...  ELSE  Fail  5_Unlocked_Channels Is Not Displayed on screen
	CLICK MULTIPLE TIMES    2    UP
	CLICK MULTIPLE TIMES    3    RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK
	CLICK HOME

TC_2008_VERIFY_CHANNEL_UNHIDE_INDIVIDUALLY_WITH_REBOOT
    [Tags]    PROFILE & EDIT
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
    ${Result}  Verify Crop Image  ${port}  5_Hidden_Channels
	Run Keyword If  '${Result}' == 'True'  Log To Console  5_Hidden_Channels Is Displayed on screen
	...  ELSE  Fail  5_Hidden_Channels Is Not Displayed on screen
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
	Reboot STB Device
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
    ${Result}  Verify Crop Image  ${port}  5_Unhidden_Channels
	Run Keyword If  '${Result}' == 'True'  Log To Console  Channels are unhidden
	...  ELSE  Fail  Channels are still Hidden
	CLICK MULTIPLE TIMES    2    UP
	CLICK MULTIPLE TIMES    3    RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK
	CLICK HOME

TC_2009_VERIFY_CHANNEL_UNHIDE_AT_ONCE_WITH_REBOOT
    [Tags]    PROFILE & EDIT
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
    ${Result}  Verify Crop Image  ${port}  5_Hidden_Channels
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
	Reboot STB Device
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
    ${Result}  Verify Crop Image  ${port}  5_Unhidden_Channels
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
	[Teardown]    Revert UI language
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
	CLICK UP
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
    Arabic Channel List Fix
	CLICK MULTIPLE TIMES    10    DOWN  
	CLICK LEFT
	CLICK LEFT
	${Result}  Verify Crop Image  ${port}  TC_822_ARABIC_TODAY
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_822_ARABIC_TODAY Is Displayed on screen
	...  ELSE  Fail  TC_822_ARABIC_TODAY Is Not Displayed on screen
	
	CLICK BACK
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
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# CLICK OK
    Guide Channel List
	CLICK MULTIPLE TIMES    10    DOWN  
	CLICK RIGHT
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}  Today_EPG
	Run Keyword If  '${Result}' == 'True'  Log To Console  Today_EPG Is Displayed on screen
	...  ELSE  Fail  Today_EPG Is Not Displayed on screen
	
	CLICK BACK
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
	# ${Result}  Verify Crop Image  ${port}  Interface_settings
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_settings Is Displayed
	# ...  ELSE  Fail  Interface_settings Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# ${Result}  Verify Crop Image  ${port}  Interface_timeout_10secs
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_timeout_10secs Is Displayed
	# ...  ELSE  Fail  Interface_timeout_10secs Is Not Displayed
	
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  Interface_timeout_success
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_timeout_success Is Displayed
	# ...  ELSE  Fail  Interface_timeout_success Is Not Displayed
	
	CLICK OK
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
	Sleep    7s 
	${Result}  Verify Crop Image  ${port}  TC_016_Dubai_TV_Channel
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
	# ${Result}  Verify Crop Image  ${port}  Interface_settings
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_settings Is Displayed
	# ...  ELSE  Fail  Interface_settings Is Not Displayed
	
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# ${Result}  Verify Crop Image  ${port}  Interface_timeout_10secs
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_timeout_10secs Is Displayed
	# ...  ELSE  Fail  Interface_timeout_10secs Is Not Displayed
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# ${Result}  Verify Crop Image  ${port}  Interface_timeout_success
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_timeout_success Is Displayed
	# ...  ELSE  Fail  Interface_timeout_success Is Not Displayed
	
	CLICK OK
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
	Sleep    12s 
	${Result}  Verify Crop Image  ${port}  TC_016_Dubai_TV_Channel
	Run Keyword If  '${Result}' == 'False'  Log To Console  Banner Timeout has been successfully validated
	...  ELSE  Fail  Banner is still visible after timeout
	CLICK HOME
	Login As Admin
	CLICK HOME

TC_2012_VERIFY_INTERFACE_CLOCK_WITH_STANDBY_MODE_IN_SUBPROFILE
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
	# ${Result}  Verify Crop Image  ${port}  Interface_settings
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_settings Is Displayed
	# ...  ELSE  Fail  Interface_settings Is Not Displayed
	Sleep    3s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# ${Result}  Verify Crop Image  ${port}  Interface_clock_off
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_clock_off Is Displayed
	# ...  ELSE  Fail  Interface_clock_off Is Not Displayed
	
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	# ${Result}  Verify Crop Image  ${port}  Interface_clock_success
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_clock_success Is Displayed
	# ...  ELSE  Fail  Interface_clock_success Is Not Displayed
	Sleep    3s 
	CLICK OK
	CLICK HOME
	Stand by mode
	Check Who's Watching login
	Sleep    3s 
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
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Sleep    4s 
	CLICK BACK

	 ${result}=  Verify Crop Image With Two Images   ${port}  TC_017_clock_pm  TC_017_clock_am
	IF    '${result}' != 'True'
		Log To Console    Interface clock is not visible on screen
		Fail              Interface clock is not visible on screen
	ELSE
		Log To Console    Interface clock is visible on screen
	END


    CLICK HOME
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
	# ${Result}  Verify Crop Image  ${port}  Interface_settings
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_settings Is Displayed
	# ...  ELSE  Fail  Interface_settings Is Not Displayed
	Sleep    3s 
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	# ${Result}  Verify Crop Image  ${port}  Interface_clock_off
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_clock_off Is Displayed
	# ...  ELSE  Fail  Interface_clock_off Is Not Displayed
	
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	# ${Result}  Verify Crop Image  ${port}  Interface_clock_success
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Interface_clock_success Is Displayed
	# ...  ELSE  Fail  Interface_clock_success Is Not Displayed
	Sleep    3s 
	CLICK OK
	CLICK HOME
	CLICK HOME
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
	CLICK ONE
	CLICK TWO
	CLICK ZERO
	CLICK ONE
	Sleep    4s 
	CLICK BACK

    ${result}=  Verify Crop Image With Two Images   ${port}  TC_017_clock_pm  TC_017_clock_am
    IF    '${result}' != 'True'
      Log To Console    Interface clock is visible on screen
      Fail              Interface clock is visible on screen
    ELSE
      Log To Console    Interface clock is not visible on screen
    END


	Login As Admin
	CLICK HOME
	DELETE PROFILE
	CLICK HOME

TC_2013_VERIFY_CHANNEL_STYLE_WITH_STANDBY_MODE_IN_SUBPROFILE
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
	Sleep     3s 
	CLICK DOWN
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}  TC_018_default_style
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
	# ${Result}  Verify Crop Image  ${port}  TC_018_ok
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_ok Is Displayed on screen
	# ...  ELSE  Fail  TC_018_ok Is Not Displayed on screen
	
	CLICK OK
	Sleep    3s 
	CLICK HOME
	CLICK HOME
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
	CLICK ONE
	Sleep    15s 
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_018_first_tile 
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_first_tile Is Displayed on screen
	...  ELSE  Fail  TC_018_first_tile Is Not Displayed on screen
	
	Sleep    3s 
	${Result}  Verify Crop Image  ${port}  TC_018_last_tile 
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_018_last_tile Is Displayed on screen
	...  ELSE  Fail  TC_018_last_tile Is Not Displayed on screen

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
	${Result}  Verify Crop Image  ${port}  TC_018_five_channel_style
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
	CLICK ONE
	Sleep    15s 
	CLICK OK
	${Result}  Verify Crop Image  ${port}  style9_chnl1 
	Run Keyword If  '${Result}' == 'True'  Log To Console  style9_chnl1 Is Displayed on screen
	...  ELSE  Fail  style9_chnl1 Is Not Displayed on screen
	
	Sleep    3s 
	${Result}  Verify Crop Image  ${port}  style9_chnl9 
	Run Keyword If  '${Result}' == 'True'  Log To Console  style9_chnl9 Is Displayed on screen
	...  ELSE  Fail  style9_chnl9 Is Not Displayed on screen

	CLICK HOME
	Login As Admin
	CLICK HOME
	
TC_2014_CREATE_PROFILE_WITH_CUSTOM_AVATAR_AND_VERIFY_DISPLAY_FROM_SUBPROFILE
    [Tags]    PROFILE & EDIT 
	[Teardown]    DELETE PROFILE
	Create New Profile
	CLICK HOME
	Navigate and Login to Sub profile
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
	CLICK RIGHT
	CLICK RIGHT
	Sleep    3s	
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
	${Result}  Verify Crop Image  ${port}  Avatar_Profile_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Avatar_Profile_Page Is Displayed on screen
	...  ELSE  Fail  Avatar_Profile_Page Is Not Displayed on screen
	CLICK HOME
	CLICK POWER
	Sleep    5s
	CLICK POWER
	Sleep    20s
	Check Who's Watching login with avatar profile validation
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
	${Result}  Verify Crop Image  ${port}  Avatar_Profile_Page
	Run Keyword If  '${Result}' == 'True'  Log To Console  Avatar_Profile_Page Is Displayed on screen
	...  ELSE  Fail  Avatar_Profile_Page Is Not Displayed on screen
	CLICK HOME
	DELETE PROFILE
	
TC_2015_VERIF_ALWAYS_LOGIN_WITH_THIS_PROFILE_FUNCTIONALITY_IN_PROFILE_SETTINGS_PAGE_WITH_STANDBY
    [Tags]    PROFILE & EDIT
	[Teardown]    Delete Profile
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
	# ${Result}  Verify Crop Image  ${port}  TC_006_New_Profile
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
	# ${Result}  Verify Crop Image  ${port}  TC_006_Personal_Details
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
	# ${Result}  Verify Crop Image  ${port}  TC_006_Security_Controls
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_006_Security_Controls Is Displayed
	# ...  ELSE  Fail  TC_006_Security_Controls Is Not Displayed
	
	CLICK DOWN
    CLICK DOWN
    # ${Result}  Verify Crop Image  ${port}  Disable_Login_Admin
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
    
    Stand by mode

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
	${Result}  Verify Crop Image  ${port}  Logged_In_Subprofile
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
	

TC_2016_CREATE_CHILD_PROFILE_WITH_AGE_BASED_RESTRICTIONS_WITH_STANDBY
	[Tags]    PROFILE & EDIT 
	[Teardown]    DELETE PROFILE
	Create Kids Profile
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
	# ${Result}  Verify Crop Image  ${port}  TC_010_ok
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_010_ok Is Displayed on screen
	# ...  ELSE  Fail  TC_010_ok Is Not Displayed on screen
	
	CLICK OK
	CLICK HOME
	Stand by mode
    Check Who's Watching login
	CLICK HOME
	Navigate and Login to Kids profile
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
	${Result}  Verify Crop Image  ${port}  TC_010_Rating_Confirmation_PopUp
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


    






















	










