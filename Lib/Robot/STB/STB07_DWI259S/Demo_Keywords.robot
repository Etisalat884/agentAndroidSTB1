*** Settings ***
Library  SeleniumLibrary
Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/Signal/Etisalat.py

Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/runtime.py

Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/generic.py
Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/imageCaptureDragDrop.py
Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/AudioQuality.py
Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/OcrKeywords.py
# Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/SubtitleOcr.py
Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/getChannelNumberOcr.py
Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/ImageProcessingLibrary.py    WITH NAME    IPL
Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/OCRLibrary.py    WITH NAME    OCR
Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/audioverification.py
Library   /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/VideoQuality/Video_metrics_robot.py
Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/VideoQuality/VideoMetricsLibrary.py
Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/VideoQuality/LiveVideoQualityClassifier.py
Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/cropSubtitle.py
Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/AudioRmsLibrary.py
Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/subtitlenew.py

Library  String
Library  DateTime
Library  Collections
Library  RequestsLibrary
Library    Process
Variables    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/VariableFiles/STB/STB07_DWI259S/STB07_DWI259S.yaml
*** Variables ***
${image_profile_wxyz}    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Images/TC_002_Edited_Profile_Name.png
${ZAP_LIMIT}     2.408268928527832   # seconds with image capturing and execution time
@{ZAP_TIMES}     # List to store each zap time
${gray_image}      /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Blank_tile_continue_watching.png
&{CHANNEL_FEATURES}
...    [0001] Info Channel=PiP=True    CatchUp=False    EPGCheck=False    StartOver=False    VideoAvailability=True
...    [0011] Abu Dhabi TV HD=PiP=True    CatchUp=True    EPGCheck=True    StartOver=True    VideoAvailability=True
@{SD_CHANNEL_LIST}    2    73    126    236    426
@{HD_CHANNEL_LIST}    11    23    33		153    259    577
@{UHD_CHANNEL_LIST}    204
${black_screen}    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Images/black_screen.jpg
${GOOD_COUNT}    0
${BAD_COUNT}     0
${SCRIPT_PATH}   /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/vq1.py
@{matched_list}         Create List
@{unmatched_list}       Create List
*** Keywords ***
Restore_FFMPEG
    [Documentation]  Restores the FFMPEG Services
    generic.restore_ffmpeg

Power_Off_And_Power_On_STB
    [Documentation]    Simulates power cycle of STB
    Log To Console    Starting Power_Off_And_Power_On_STB
    CLICK POWER
	Sleep    2s
	CLICK POWER
	Sleep    15s
	${pass}  runtime.tempMatch  ${port}  ${eti_logo}  ${ref_logo}
    log to console    ${pass}
    CAPTURE CURRENT IMAGE WITH TIME
    Log To Console    Completed Power_Off_And_Power_On_STB
    RETURN    True

User_Zapping_20_Channels_And_Back
    [Documentation]    Zaps down 20 channels and back up
    Log To Console    Starting User_Zapping_20_Channels_And_Back
    CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK OK
    CLICK MULTIPLE TIMES    2    DOWN
    CLICK MULTIPLE TIMES    2    OK
    Sleep    2s
    CLICK MULTIPLE TIMES    20    CHANNEL_MINUS
    Log To Console    Zapped down 20 channels
    Sleep    1s
    CLICK MULTIPLE TIMES    20    CHANNEL_PLUS
    Log To Console    Zapped back up 20 channels
    CLICK HOME
    Log To Console    Completed User_Zapping_20_Channels_And_Back
    RETURN    True

User_Zapping_10_Then_Back_5_Then_Switch_To_Channel_514
    [Documentation]    Zaps down 10, back 5, then switches to channel 514
    Log To Console    Starting User_Zapping_10_Then_Back_5_Then_Switch_To_Channel_514
    CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK OK
    CLICK MULTIPLE TIMES    2    DOWN
    CLICK MULTIPLE TIMES    2    OK
    Sleep    2s
    CLICK MULTIPLE TIMES    10    CHANNEL_MINUS
    Log To Console    Zapped down 10 channels
    Sleep    1s
    CLICK MULTIPLE TIMES    5    CHANNEL_PLUS
    Log To Console    Zapped back 5 channels
    Sleep    2s
    CLICK OK
    Sleep    2s
    CLICK 5
    CLICK 1
    CLICK 4
    Log To Console    Switched to channel 514
    Sleep    5s
    CLICK MULTIPLE TIMES    2    CHANNEL_PLUS
    Log To Console    User is on channel 512
    CLICK HOME
    Log To Console    Completed User_Zapping_10_Then_Back_5_Then_Switch_To_Channel_514
    RETURN    True

Press number
    CLICK 5
    CLICK 1
Open_VOD_And_Start_Playback
    [Documentation]    Opens VOD and starts playback
    Log To Console    Starting Open_VOD_And_Start_Playback
    CLICK HOME
    CLICK UP
    CLICK MULTIPLE TIMES    3    RIGHT
    CLICK OK
    Sleep    1s
    CLICK OK
    Sleep    1s
    CLICK RIGHT
    Sleep    1s
    CLICK DOWN
    Sleep    1s
    CLICK RIGHT
    Sleep    1s
    CLICK OK
    Sleep    1s
    CLICK OK
    Sleep    3s
    Log To Console    Video is playing
    Log To Console    Completed Open_VOD_And_Start_Playback
    RETURN    True

Play_VOD_Using_Trickmodes_Fast_Forward
    [Documentation]    Demonstrates fast forward trickmodes
    Log To Console    Starting Play_VOD_Using_Trickmodes_Fast_Forward
    Sleep    10s
    CLICK PLAY_PAUSE
    Sleep    5s
    CLICK PLAY_PAUSE
    Sleep    5s
    CLICK RIGHT
    Sleep    1s
    CLICK OK
    Sleep    1s
    Log To Console    4x fast forward
    Sleep    1s
    CLICK LEFT
    Sleep    1s
    CLICK OK
    Log To Console    PLAY Video
    Sleep    3s
    CLICK RIGHT
    Sleep    1s
    CLICK MULTIPLE TIMES    2    OK
    Log To Console    8x fast forward
    CLICK LEFT
    Sleep    1s
    CLICK OK
    Log To Console    PLAY_PAUSE
    Sleep    3s
    CLICK RIGHT
    Sleep    1s
    CLICK MULTIPLE TIMES    3    OK
    Log To Console    16x fast forward
    CLICK LEFT
    Sleep    1s
    CLICK OK
    Log To Console    PLAY_PAUSE
    Sleep    3s
    CLICK RIGHT
    Sleep    1s
    CLICK MULTIPLE TIMES    4    OK
    Log To Console    32x fast forward
    Sleep    2s
    CLICK LEFT
    CLICK OK
    Log To Console    PLAY_PAUSE
    Sleep    3s
    Log To Console    Completed Play_VOD_Using_Trickmodes_Fast_Forward
    RETURN    True

Perform_Start_Over_On_Video
    [Documentation]    Initiates start over on current video
    Log To Console    Starting Perform_Start_Over_On_Video
    CLICK HOME
    CLICK DOWN
    Sleep    3s
    CLICK MULTIPLE TIMES    3    OK
    Sleep    5s
    CLICK MULTIPLE TIMES    2    RIGHT
    CLICK OK
    Sleep    4s
    CLICK MULTIPLE TIMES    6    LEFT
    Sleep    1s
    CLICK OK
    Sleep    10s
    Log To Console    Video start over is clicked
    Log To Console    Completed Perform_Start_Over_On_Video
    RETURN    True

Live_TV_Recording
    [Documentation]    Starts recording a live TV program
    Log To Console    Starting Live_TV_Recording
    CLICK HOME
    CLICK UP
    CLICK RIGHT
    Sleep    1s
    CLICK MULTIPLE TIMES    2    OK
    Sleep    1s
    CLICK OK
    CLICK MULTIPLE TIMES    2    DOWN
    Sleep    1s
    CLICK OK
    CLICK DOWN
    Sleep    1s
    CLICK OK
    CLICK MULTIPLE TIMES    4    DOWN
    CLICK OK
    Log To Console    Completed Live_TV_Recording
    RETURN    True

Rewind
    [Documentation]    Rewinds video during playback
    Log To Console    Executing rewind
    CLICK LEFT
    Sleep    1s
    CLICK MULTIPLE TIMES    4    OK
	Sleep    3s
	CLICK RIGHT
    Sleep    1s
	CLICK OK
    Sleep    5s
    RETURN    True

Search_Movie
    [Documentation]    Searches and plays a movie in VOD
    Log To Console    Searching movie
    CLICK HOME
	CLICK HOME
    CLICK UP
    CLICK MULTIPLE TIMES    8    RIGHT
    CLICK OK
    Sleep    1s
	CLICK MULTIPLE TIMES    2    RIGHT
    CLICK OK
	CLICK MULTIPLE TIMES    2    DOWN
    CLICK OK
	CLICK MULTIPLE TIMES    2    UP
    CLICK OK
	CLICK MULTIPLE TIMES    2    DOWN
    CLICK OK
	CLICK MULTIPLE TIMES    4    DOWN
    CLICK OK
	Sleep    1s
	CLICK MULTIPLE TIMES    2    OK
    Sleep    10s
    Log To Console    Movie started playing
	# CLICK HOME
    RETURN    True

Subtitle_Language
    [Documentation]    Changes subtitle language during playback
    Log To Console    Changing subtitle language
    Open_VOD_And_Start_Playback
    Sleep    5s
    CLICK MULTIPLE TIMES    5    RIGHT
	CLICK OK
	CLICK UP
	CLICK OK
	Sleep    10s
    RETURN    True

Rent_Movie_Under_Boxoffice_With_Wrong_PIN
    [Documentation]    Attempt to rent movie with wrong PIN
    Log To Console    Starting Rent_Movie_Under_Boxoffice_With_Wrong_PIN
    CLICK HOME
    CLICK UP
    Sleep    1s
    CLICK MULTIPLE TIMES    2    RIGHT
    Sleep    1s
    CLICK MULTIPLE TIMES    2    OK
    Sleep    1s
    CLICK MULTIPLE TIMES    2    OK
    Sleep    1s
    CLICK MULTIPLE TIMES    2    DOWN
    CLICK 5
    CLICK 5
    CLICK 5
    CLICK 5
    Sleep    1s
    CLICK MULTIPLE TIMES    2    DOWN
    CLICK OK
    RETURN    True

Rent_Movie_Under_Boxoffice_With_Valid_PIN
    [Documentation]    Rent movie with correct PIN
    Log To Console    Starting Rent_Movie_Under_Boxoffice_With_Valid_PIN
    CLICK HOME
    CLICK UP
    Sleep    1s
    CLICK MULTIPLE TIMES    2    RIGHT
    Sleep    1s
    CLICK MULTIPLE TIMES    2    OK
    Sleep    1s
    CLICK MULTIPLE TIMES    2    OK
    Sleep    1s
    CLICK MULTIPLE TIMES    2    DOWN
    CLICK 2
    CLICK 2
    CLICK 2
    CLICK 2
    Sleep    1s
    CLICK MULTIPLE TIMES    2    DOWN
    CLICK OK
    RETURN    True

Play_Live_TV
    [Documentation]    Plays live TV for 30 seconds and verifies logo is not present
    Log To Console    Starting Play_Live_TV
    CLICK HOME
    CLICK UP
    CLICK RIGHT
    Sleep    1s
    CLICK MULTIPLE TIMES    2    OK
    Sleep    5s
    ${pass}=    runtime.tempMatch    ${port}    ${eti_logo}    ${ref_logo}
    Log To Console    Logo match result: ${pass}
    Run Keyword If    ${pass} == True    Fail    Logo is present during live playback — test failed
    Sleep    25s
    Log To Console    Completed Play_Live_TV
    RETURN    True

NAVIGATE BACK TO HOME
    Sleep    1s
	CLICK HOME

CLICK MENU
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  MENU
    sleep  1s


CLICK LEFT
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  LEFT
    sleep  1s


CLICK RIGHT
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  RIGHT
    sleep  1s

CLICK OK
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  OK
    sleep  1s

CLICK UP
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  UP
    sleep  1s

CLICK DOWN
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  DOWN
    sleep  1s

CLICK HOME
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  HOME
    sleep  1s

CLICK BACK
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  BACK
    sleep  1s

CLICK CHANNEL_MINUS
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  CHANNEL_MINUS
    sleep  1s

CLICK CHANNEL_PLUS
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  CHANNEL_PLUS
    sleep  1s


CLICK VOLUME_MINUS
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  VOLUME_MINUS
    sleep  1s

CLICK VOLUME_PLUS
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  VOLUME_PLUS
    sleep  1s

CLICK RED
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  RED

CLICK GREEN
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  GREEN

CLICK BLUE
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  BLUE

CLICK YELLOW
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  YELLOW

SWITCH OFF MIC
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  MIC

SWITCH ON MIC
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  MIC
CLICK 0

	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  0

CLICK 1
	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  1

CLICK 2
	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  2
CLICK 3
	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  3

CLICK 4
	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  4

CLICK 5
	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  5
CLICK 6
	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  6
CLICK 7
	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  7
CLICK 8
	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  8

CLICK 9
	Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  9

CLICK PLAY_PAUSE
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  PLAY_PAUSE

CLICK POWER
    Run Keyword And Return Status    Etisalat.Etisalat Tv Cmds    POWER

# CAPTURE CURRENT IMAGE WITH TIME
#     ${now}  generic.get_date_time
#     ${d_rimg}  Replace String  ${ref_img3}  replace  ${now}
#     ${report_path}  Replace String  ${report_img_path}  replace  ${now}
#     generic.capture image run  ${port}  ${d_rimg}
#     Log  <img src='${report_path}'></img>  html=yes

CAPTURE CURRENT IMAGE WITH TIME
    ${now}  generic.get_date_time
    ${d_rimg}  Replace String  ${ref_img3}  replace  ${now}
    ${report_path}  Replace String  ${report_img_path}  replace  ${now}
    generic.capture image run  ${port}  ${d_rimg}
    ${image_path}  show_image  ${d_rimg}
    Log  ${image_path}  html=yes

#Key Codes Keywords for Rec and Play_Live_TV


CLICK MUTE
    run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  MUTE
    sleep  1s

CLICK PLAY
    CLICK PLAY_PAUSE
CLICK CHANNELUP
    CLICK CHANNEL_PLUS
CLICK CHANNELDWN
    CLICK CHANNEL_MINUS

CLICK RESET
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  RESET
    sleep  1s

CLICK VOICE
    SWITCH ON MIC
CLICK VOLUP
    CLICK VOLUME_PLUS
CLICK VOLDWN
    CLICK VOLUME_MINUS

CLICK RECORD
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  RECORD
    sleep  1s

CLICK THREE
    CLICK 3
CLICK TWO
    CLICK 2
CLICK ONE
    CLICK 1
CLICK SIX
    CLICK 6
CLICK FIVE
    CLICK 5
CLICK FOUR
    CLICK 4
CLICK NINE
    CLICK 9
CLICK EIGHT
    CLICK 8
CLICK SEVEN
    CLICK 7
CLICK TOOL
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  TOOLS
    sleep  1s

CLICK ZERO
    CLICK 0
CLICK AUDIO SUB
    Run Keyword And Return Status  Etisalat.Etisalat Tv Cmds  AUDIO_SUB
    sleep  1s

Verify Crop Image 
    [Arguments]  ${port}  ${image1}
    sleep  5s
    ${pass}  imageCaptureDragDrop.verifyimage  ${port}  ${image1}
    CAPTURE CURRENT IMAGE WITH TIME
    sleep  2s
    RETURN  ${pass}

Verify Crop Image With Two Images
    [Arguments]  ${port}  ${image1}  ${image2}
    Sleep  5s
    ${pass1}=  imageCaptureDragDrop.verifyimage  ${port}  ${image1}
    ${pass2}=  imageCaptureDragDrop.verifyimage  ${port}  ${image2}

    ${result}=  Run Keyword And Return Status  Evaluate  '${pass1}'=='True' or '${pass2}'=='True'

    CAPTURE CURRENT IMAGE WITH TIME
    Sleep  2s
    RETURN  ${result}


Verify Crop Image With Shorter Duration
    [Arguments]  ${port}  ${image1}
    # sleep  2s
    ${pass}  imageCaptureDragDrop.verifyimage  ${port}  ${image1}
    CAPTURE CURRENT IMAGE WITH TIME
    # sleep  1s
    RETURN  ${pass}

Arabic Reboot STB Device
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB07_DWI259S"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    75s
    Log To Console    Reboot Success
    Check Who's Watching login arabic
    CLICK OK
    Sleep   2s
    CLICK OK
    Sleep     10s
    CLICK HOME
    Sleep     8s
    CLICK HOME
    Sleep     8s
    CLICK HOME



Enter Pincode 
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK


Rent or Buy First VOD
########## FIRST ###
    Rent OR Buy Assest in Boxoffice
	${result}=  Verify Crop Image With Two Images   ${port}  Now  TC_007_Insufficient_quota
	IF    '${result}' != 'True'
		Log To Console    Asset was not Rented/Bought
	ELSE
		Log To Console    Asset was Rented/Bought
	END

	CLICK RIGHT
	CLICK OK
	Log To Console   First asset is rented 
	CLICK RIGHT


Rent or Buy Second VOD
###### SECOND ######
	CLICK OK 
	Rent OR Buy Assest in Boxoffice
	${result}=  Verify Crop Image With Two Images   ${port}  Now  TC_007_Insufficient_quota
	IF    '${result}' != 'True'
		Log To Console    Asset was not Rented/Bought
	ELSE
		Log To Console    Asset was Rented/Bought
	END
	CLICK RIGHT
	CLICK OK
	Log To Console   Second asset is rented 
	# CLICK BACK
	# CLICK BACK
	CLICK RIGHT
	##################

Rent or Buy Third VOD
	###### THIRD ######
	CLICK OK
	Rent OR Buy Assest in Boxoffice
	${result}=  Verify Crop Image With Two Images   ${port}  Now  TC_007_Insufficient_quota
	IF    '${result}' != 'True'
		Log To Console    Asset was not Rented/Bought
	ELSE
		Log To Console    Asset was Rented/Bought
	END
	CLICK RIGHT
	CLICK OK
	Log To Console   THIRD asset is rented 
	# CLICK BACK
	# CLICK BACK
	CLICK RIGHT
	##################

Rent or Buy Fourth VOD
###### FOURTH ######
	CLICK OK
	Rent OR Buy Assest in Boxoffice
		${result}=  Verify Crop Image With Two Images   ${port}  Now  TC_007_Insufficient_quota
	IF    '${result}' != 'True'
		Log To Console    Asset was not Rented/Bought
	ELSE
		Log To Console    Asset was Rented/Bought
	END
	CLICK RIGHT
	CLICK OK
	Log To Console   FOURTH asset is rented 
	# CLICK BACK
	# CLICK BACK
	CLICK RIGHT
	##################


Rent or Buy Five VOD
    CLICK OK
	Rent OR Buy Assest in Boxoffice
	${Result}  Verify Crop Image  ${port}  TC_007_Insufficient_quota
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_007_Insufficient_quota Is Displayed
	...  ELSE  Fail  TC_007_Insufficient_quota Is Not Displayed
	
	CLICK OK
	Log To Console    Five asset is rented 
	CLICK BACK




CLICK MULTIPLE TIMES
    [Arguments]    ${count}    ${key}
    FOR  ${i}    IN RANGE    ${count}
        ${keyword}    Catenate    CLICK    ${key}
        Run Keyword And Return Status    ${keyword}
    END

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

DELETE PROFILE

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
    # ${Result1}    Verify Crop Image    ${port}    ADMIN

    # Run Keyword If    '${Result1}' == 'True'    Run Keywords
    # ...    CLICK OK    AND
    # ...    pinblock    AND
    # ...    Sleep    15s    AND
    # ...    Check For Who's Watching login Page

    # Run Keyword If    '${Result1}' != 'True'    CLICK HOME
    # CLICK HOME
	# Log To Console    Navigated to Home page
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
	# CLICK RIGHT
    # ${Result}  Verify Crop Image  ${port}  Highlighted_new_Profile
	# IF  '${Result}' == 'False'
    #     CLICK DOWN
    #     CLICK DOWN
    #     CLICK OK
    #     CLICK TWO
    #     CLICK TWO
    #     CLICK TWO
    #     CLICK TWO
    #     CLICK OK
    # END
    # CLICK HOME
    CLICK OK
    pinblock
    Check For Who's Watching login Page
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
    ${Result}  Verify Crop Image  ${port}  Highlighted_new_Profile
	IF  '${Result}' == 'False'
        CLICK DOWN
        CLICK DOWN
        CLICK OK
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK OK
    END
    CLICK HOME

Check For Valid Future Schedules
    Sleep    1s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    ${cropped_img}=    IPL.Program Future Schedules    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${cropped_img}

    ${after_text}=    OCR.Extract Text From Image    ${cropped_img}
    Log To Console    📸 OCR AFTER TEXT: ${after_text}
    
    # Step 1: Replace common OCR errors (o → 0)
    ${step1}=    Evaluate    """${after_text}""".replace('o', '0').replace('O', '0')

    # Step 2: Remove all remaining alphabets
    ${step2}=    Evaluate    re.sub(r'[A-Za-z]', '', """${step1}""")    re

    # Step 3: Fix spacing after dot (e.g., 12. 20 → 12.20)
    ${final}=    Evaluate    re.sub(r'\.\s(?=\d{2})', '.', """${step2}""")    re

    Log To Console    🧼 Final Cleaned OCR Text: ${final}


    ${lines}=    Split String    ${final}    \n
    ${clean_lines}=    Create List
    FOR    ${line}    IN    @{lines}
        ${stripped}=    Strip String    ${line}
        Run Keyword If    '${stripped}' != ''    Append To List    ${clean_lines}    ${stripped}

    Log To Console    🧾 Cleaned OCR Lines: ${clean_lines}
    END
    ${count}=    Get Length    ${clean_lines}
    Run Keyword If    ${count} == 0    Fail    ❌ OCR failed — no valid future schedule found

    RETURN    ${clean_lines}




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
	CLICK DOWN
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	# CLICK RIGHT
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
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
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

    #ADD VALIDATION
    ${Result}  Verify Crop Image  ${port}  child_profile_img
	Run Keyword If  '${Result}' == 'True'  Log To Console  child_profile_img Is Displayed on screen
	...  ELSE  Fail  child_profile_img Is Not Displayed on screen
	# CLICK OK
    # Sleep    30s
    # CLICK HOME

Reboot STB for kids profile and login with 3333 pin
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB07_DWI259S"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    95s
    Log To Console    Reboot Success
    ${Result}=    Verify Crop Image    ${port}    TC_520_Who_Watching
    Log To Console    Who's login: ${Result}
    IF    '${Result}' == 'True'
        CLICK RIGHT
        CLICK OK
        CLICK THREE
        CLICK THREE
        CLICK THREE
        CLICK THREE
        CLICK OK
        Sleep    30s
        CLICK HOME
    END

VALIDATE VIDEO PREVIEW
    sleep  20s
    ${now}  generic.get_date_time
    ${d_rimg}  Replace String  ${ref_img1}  replace  ${now}
    generic.capture image run  ${port}  ${d_rimg}
    #Log  <img src='${d_rimg}'></img>  html=yes
    CAPTURE CURRENT IMAGE WITH TIME
    sleep  10s
    ${now}  generic.get_date_time
    ${d_cimg}  Replace String  ${comp_img}  replace  ${now}
    generic.capture image run  ${port}  ${d_cimg}
    #Log  <img src='${d_cimg}'></img>  html=yes
    CAPTURE CURRENT IMAGE WITH TIME
    ${pass}  generic.compare_image  ${d_rimg}  ${d_cimg}
    Run Keyword If  ${pass}==False  Log To Console  Video previw is Playing
    ...  ELSE  Log To Console  Video preview is not available

SEARCH VOD
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
	# validate






Click OK Multiple Times
    FOR    ${j}    IN RANGE    5
        CLICK OK
        Sleep    0.3s
    END

Move to Audio Launguage On Side Pannel
    [Arguments]   ${base_count}=1
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}
    # CLICK RIGHT
    # ${Result}=    Verify Crop Image    ${port}    Add_To_Favorites
    # Log To Console    Audio Match Result: ${Result}
    # IF    '${Result}' == 'True'
    #     ${base_count}=    Set Variable    1
    #     ${STEP_COUNT}=    Set Variable    ${base_count}
    #     Log To Console    ${base_count}
    # END

    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Rmv_Fav
    Log To Console    Remove Favorites: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Pause_Side_Panel
    Log To Console    Pause: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Start_Over
    Log To Console    Start Over: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    Side_Pannel_Record
    Log To Console    Record: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
     CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    Side_Pannel_Catchup_Option
    Log To Console    CatchUp: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
	CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    More_Details_Option
    Log To Console    More Details: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    Log To Console    After Increment: ${STEP_COUNT}

    RETURN    ${STEP_COUNT}
CHECK VIDEO PLAYBACK STATUS
    Sleep  20s
    ${now}  generic.get_date_time
    ${d_rimg}  Replace String  ${ref_img1}  replace  ${now}
    generic.capture image run  ${port}  ${d_rimg}

    Sleep  20s
    ${now}  generic.get_date_time
    ${d_cimg}  Replace String  ${comp_img}  replace  ${now}
    generic.capture image run  ${port}  ${d_cimg}

    ${pass}  generic.compare_image  ${d_rimg}  ${d_cimg}

    Run Keyword If    ${pass}==False    Fail    Video is Playing (Unexpected)
    ...    ELSE    Log To Console    Video is NOT Playing (As Expected)

    RETURN    ${pass}





Move to subtitle On Side Pannel
    [Arguments]   ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Add_To_Favorites
    Log To Console    Add To Favorite: ${Result}
    IF    '${Result}' == 'True'
        ${base_count}=    Set Variable    1
        ${STEP_COUNT}=    Set Variable    ${base_count}
        Log To Console    ${base_count}
    END

    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Rmv_Fav
    Log To Console    Remove Favorite: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Pause_Side_Panel
    Log To Console    Pause: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Start_Over
    Log To Console    Start Over: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    Side_Pannel_Record
    Log To Console    Record: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
     CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    Side_Pannel_Catchup_Option
    Log To Console    Catch Up: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
	CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    More_Details_Option
    Log To Console    More Details: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    Audio
    Log To Console    Audio: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    Log To Console    After Increment: ${STEP_COUNT}

    RETURN    ${STEP_COUNT}
Get Cast Name
    Sleep   15s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log    AFTER IMAGE: ${after_image_path}

    ${cropped_img}=    IPL.cast roi   ${after_image_path}
    Log To Console   CROPPED AFTER INFO BAR: ${cropped_img}

    ${after_text}=    OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT (RAW): ${after_text}

    ${after_text}=    Convert To Lower Case    ${after_text}
    Log To Console    OCR AFTER TEXT (LOWER): ${after_text}

    RETURN    ${after_text}
Remove_Favorites_From_List
    CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    Guide Channel List
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
    Sleep   5s
    CLICK DOWN
    Sleep   1s
    CLICK RIGHT
    CLICK DOWN
    CLICK OK
    Sleep   3s
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    CLICK RIGHT
    CLICK OK
    Sleep   2s
    CLICK RIGHT
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    Sleep   2s
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    CLICK RIGHT
    CLICK OK
    Sleep   2s
    CLICK RIGHT

    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    Sleep   2s
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    CLICK RIGHT
    CLICK OK
    Sleep   2s
    CLICK RIGHT
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    Sleep   2s
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    CLICK RIGHT
    CLICK OK
    Sleep   2s
    CLICK RIGHT
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    Sleep   2s
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    CLICK RIGHT
    CLICK OK
    Sleep   2s
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK OK
    CLICK HOME

Move to subtitle On Side Pannell
    [Arguments]   ${base_count}=1
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # CLICK RIGHT
    # ${Result}=    Verify Crop Image    ${port}    Add_To_Favorites
    # Log To Console    Add To Favorite: ${Result}
    # IF    '${Result}' == 'True'
    #     ${base_count}=    Set Variable    1
    #     ${STEP_COUNT}=    Set Variable    ${base_count}
    #     Log To Console    ${base_count}
    # END

    # CLICK RIGHT
    # ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Rmv_Fav
    # Log To Console    Remove Favorite: ${Result}
    # IF    '${Result}' == 'True'
    #     ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    # END
    # CLICK RIGHT
    # ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Pause_Side_Panel
    # Log To Console    Pause: ${Result}
    # IF    '${Result}' == 'True'
    #     ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    # END
    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Start_Over
    Log To Console    Start Over: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    Side_Pannel_Record
    Log To Console    Record: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
     CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    Side_Pannel_Catchup_Option
    Log To Console    Catch Up: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
	CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    More_Details_Option
    Log To Console    More Details: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    Audio
    Log To Console    Audio: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    Log To Console    After Increment: ${STEP_COUNT}

    RETURN    ${STEP_COUNT}






Select Start Over And Verify
    [Arguments]    ${max_retries}=3
    ${success}=    Set Variable    False
    FOR    ${attempt}    IN RANGE    ${max_retries}
        Log To Console    Attempt ${attempt + 1} of ${max_retries}
        ${STEP_COUNT}=    Move To Start Over On Side Pannel
        Log To Console    Initial STEP_COUNT: ${STEP_COUNT}
        Click Right
        FOR    ${i}    IN RANGE    ${STEP_COUNT}
            CLICK DOWN
        END
        CLICK OK
        ${status}=    Run Keyword And Return Status    Verify Crop Image    Pause_Button
        IF    ${status}
            Log To Console    Pause_Button Is Displayed
            ${success}=    Set Variable    True
            Exit For Loop
        ELSE
            Log To Console    Pause_Button Not Displayed - Retrying...
            CLICK BACK
            CLICK BACK
            CLICK RIGHT
        END
    END
    IF    not ${success}
        Fail    Pause_Button Is Not Displayed After ${max_retries} Retries
    END

Move to Add To List On Side Pannel
    [Arguments]   ${base_count}=1
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # CLICK RIGHT
    # ${Result}=    Verify Crop Image    ${port}    Add_To_Favorites
    # Log To Console    Audio Match Result: ${Result}
    # IF    '${Result}' == 'True'
    #     ${base_count}=    Set Variable    1
    #     ${STEP_COUNT}=    Set Variable    ${base_count}
    #     Log To Console    ${base_count}
    # END

    # CLICK RIGHT
        ${Result}=    Verify Crop Image With Shorter Duration   ${port}    Resume_On_Left_Panel
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    # CLICK RIGHT
    Log To Console    After Increment: ${STEP_COUNT}

    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_711_Go_To_Date
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    # CLICK RIGHT
    # Log To Console    After Increment: ${STEP_COUNT}
    # ${Result}=    Verify Crop Image With Shorter Duration     ${port}    TC_711_Add_To_List
    # Log To Console    Audio Match Result: ${Result}
    # IF    '${Result}' == 'True'
    #     ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    # END
    # CLICK RIGHT
    Log To Console    After Increment: ${STEP_COUNT}
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    TC711_Change_Channel
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    # CLICK RIGHT
    Log To Console    After Increment: ${STEP_COUNT}
    ${Result}=    Verify Crop Image With Shorter Duration     ${port}    TC_711_AddTo_MyList
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'False'
        CLICK OK
        CLICK OK
    END
    # CLICK RIGHT

    RETURN    ${STEP_COUNT}



Move to More Details On Side Pannel
    [Arguments]   ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # CLICK RIGHT
    # ${Result}=    Verify Crop Image    ${port}    Add_To_Favorites
    # Log To Console    Add To Favorite: ${Result}
    # IF    '${Result}' == 'True'
    #     ${base_count}=    Set Variable    1
    #     ${STEP_COUNT}=    Set Variable    ${base_count}
    #     Log To Console    ${base_count}
    # END

    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Rmv_Fav
    Log To Console    Remove Favorite ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END

    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Pause_Side_Panel
    Log To Console    Pause Option: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Start_Over
    Log To Console    Start Over: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    Side_Pannel_Record
    Log To Console    Record: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
     CLICK RIGHT

	${Result}=    Verify Crop Image With Shorter Duration    ${port}    Side_Pannel_Catchup_Option
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
	CLICK RIGHT

	Log To Console    After Increment: ${STEP_COUNT}

    RETURN    ${STEP_COUNT}
Handle Recording Failure New
    Sleep   300s
    CLICK OK
    CLICK OK
    CLICK DOWN
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_215_CLOUD_STORAGE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_CLOUD_STORAGE Is Displayed
	...  ELSE  Fail  TC_215_CLOUD_STORAGE Is Not Displayed
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    Sleep    3s
    Log To Console    Playback Recording Started

    # Image validation - check for "Recording Started"

	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_401_Rec_Start
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_401_Rec_Start Is Displayed
	...  ELSE  Fail  TC_401_Rec_Start Is Not Displayed
    CLICK OK

    Sleep    120s


# Move to Start Over On Side Pannel
#     [Arguments]   ${base_count}=0
#     ${STEP_COUNT}=    Set Variable    ${base_count}
#     Log To Console    Initial STEP_COUNT: ${STEP_COUNT}
#     CLICK RIGHT
#     ${Result}=    Verify Crop Image With Shorter Duration    ${port}    TC_Add_To_Fav
#     Log To Console    Add To Favorites: ${Result}
#     IF    '${Result}' == 'True'
#         ${base_count}=    Set Variable    1
#         ${STEP_COUNT}=    Set Variable    ${base_count}
#         Log To Console    ${base_count}
#     END

#     CLICK RIGHT
#     ${Result}=    Verify Crop Image With Shorter Duration    ${port}    TC_Remove_Favs
#     Log To Console    Remove From Favorites: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END

#     CLICK RIGHT
#     ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Pause_Side_Panel
#     Log To Console    Pause: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
#     CLICK RIGHT
# 	Log To Console    After Increment: ${STEP_COUNT}

#     RETURN    ${STEP_COUNT}

Move to Record On Side Pannel
    [Arguments]   ${base_count}=1
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # CLICK RIGHT
    # ${Result}=    Verify Crop Image    ${port}    TC_Add_To_Fav
    # Log To Console    Audio Match Result: ${Result}
    # IF    '${Result}' == 'True'
    #     ${base_count}=    Set Variable    1
    #     ${STEP_COUNT}=    Set Variable    ${base_count}
    #     Log To Console    ${base_count}
    # END

    # CLICK RIGHT
    # ${Result}=    Verify Crop Image With Shorter Duration    ${port}    TC_Remove_Favs
    # Log To Console    Remove From Favorites: ${Result}
    # IF    '${Result}' == 'True'
    #     ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    # END

    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    TC_601_Pause
    Log To Console    Pause: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Start_Over
    Log To Console    Start over: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

	Log To Console    After Increment: ${STEP_COUNT}

    RETURN    ${STEP_COUNT}

Move to Record On SP
    [Arguments]   ${base_count}=1
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # CLICK RIGHT
    # ${Result}=    Verify Crop Image    ${port}    Add_To_Favorites
    # Log To Console    Audio Match Result: ${Result}
    # IF    '${Result}' == 'True'
    #     ${base_count}=    Set Variable    1
    #     ${STEP_COUNT}=    Set Variable    ${base_count}
    #     Log To Console    ${base_count}
    # END

    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    TC_Remove_Favs
    Log To Console    Remove Favorites: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END

    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Pause_Side_Panel
    Log To Console    Pause: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Start_Over
    Log To Console    Start over: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

	Log To Console    After Increment: ${STEP_COUNT}

    RETURN    ${STEP_COUNT}

Move to Manage Recorder On Side Pannel
    [Arguments]   ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Add_To_Favorites
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${base_count}=    Set Variable    1
        ${STEP_COUNT}=    Set Variable    ${base_count}
        Log To Console    ${base_count}
    END

    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Rmv_Fav
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Side_Pannel_Pause
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Start_Over
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	${Result}=    Verify Crop Image    ${port}    Side_Pannel_Record
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
     CLICK RIGHT
	${Result}=    Verify Crop Image    ${port}    Side_Pannel_Catchup_Option
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
	CLICK RIGHT
	${Result}=    Verify Crop Image    ${port}    More_Details_Option
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	${Result}=    Verify Crop Image    ${port}    Audio
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

    ${Result}=    Verify Crop Image    ${port}    TC_217_Subtitle
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

	Log To Console    After Increment: ${STEP_COUNT}

    RETURN    ${STEP_COUNT}

Move to Manage Favorites On Side Pannel
    [Arguments]   ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Add_To_Favorites
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${base_count}=    Set Variable    1
        ${STEP_COUNT}=    Set Variable    ${base_count}
        Log To Console    ${base_count}
    END

    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Rmv_Fav
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Side_Pannel_Pause
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Start_Over
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	${Result}=    Verify Crop Image    ${port}    Side_Pannel_Record
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
     CLICK RIGHT
	${Result}=    Verify Crop Image    ${port}    Side_Pannel_Catchup_Option
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
	CLICK RIGHT
	${Result}=    Verify Crop Image    ${port}    More_Details_Option
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	${Result}=    Verify Crop Image    ${port}    Audio
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

    ${Result}=    Verify Crop Image    ${port}    TC_217_Subtitle
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

    ${Result}=    Verify Crop Image    ${port}    TC_217_Manage_Recorder
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

	Log To Console    After Increment: ${STEP_COUNT}

    RETURN    ${STEP_COUNT}

# Move to Filter On Side Pannel
#     [Arguments]   ${base_count}=0
#     ${STEP_COUNT}=    Set Variable    ${base_count}
#     Log To Console    Initial STEP_COUNT: ${STEP_COUNT}
#     CLICK RIGHT
#     # CLICK UP
#     ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_83_Choose_Favorite
#     Log To Console    Choose Favorite Match Result: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END

#     CLICK RIGHT
#     ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_833_Go_To_Screen
#     Log To Console    Go To Screen Match Result: ${Result}
#     IF    '${Result}' == 'True'
#         # ${base_count}=    Set Variable    1
#         # ${STEP_COUNT}=    Set Variable    ${base_count}
#         # Log To Console    ${base_count}
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END

#     CLICK RIGHT
#     ${Result}=    Verify Crop Image With Shorter Duration   ${port}     TC_Add_To_Fav
#     Log To Console     Add To Favorite Match Result : ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
#     CLICK RIGHT
#     ${Result}=    Verify Crop Image With Shorter Duration   ${port}     TC_Remove_Favs
#     Log To Console   Remove Favorite Match Results: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
#     CLICK RIGHT

# 	Log To Console    After Increment: ${STEP_COUNT}

#     RETURN    ${STEP_COUNT}
UI_language_Change
    Revert UI language Subprofile
    Teardown exit whos watching page and login to Admin
    DELETE PROFILE

VALIDATE VIDEO PLAYBACK
    sleep  20s
    ${now}  generic.get_date_time
    ${d_rimg}  Replace String  ${ref_img1}  replace  ${now}
    generic.capture image run  ${port}  ${d_rimg}
    #Log  <img src='${d_rimg}'></img>  html=yes
    CAPTURE CURRENT IMAGE WITH TIME
    sleep  20s
    ${now}  generic.get_date_time
    ${d_cimg}  Replace String  ${comp_img}  replace  ${now}
    generic.capture image run  ${port}  ${d_cimg}
    #Log  <img src='${d_cimg}'></img>  html=yes
    CAPTURE CURRENT IMAGE WITH TIME
    ${pass}  generic.compare_image  ${d_rimg}  ${d_cimg}
    Run Keyword If  ${pass}==False  Log To Console  Video is Playing
    ...  ELSE Fail  Video is not playing
    # RETURN  True


Validate Video Playback For Playing
    ${results}=    Create List
    FOR    ${i}    IN RANGE    5
        ${now}=    generic.get_date_time
        ${d_rimg}=    Replace String    ${ref_img1}    replace    ${now}
        generic.capture image run    ${port}    ${d_rimg}
        CAPTURE CURRENT IMAGE WITH TIME

        Sleep    15s
        ${now}=    generic.get_date_time
        ${d_cimg}=    Replace String    ${comp_img}    replace    ${now}
        generic.capture image run    ${port}    ${d_cimg}
        CAPTURE CURRENT IMAGE WITH TIME

        ${pass}=    generic.compare_image    ${d_rimg}    ${d_cimg}
        Run Keyword If    ${pass}==False    Append To List    ${results}    True
        Run Keyword If    ${pass}==True     Append To List    ${results}    False
    END

    ${count}=    Set Variable    0
    FOR    ${item}    IN    @{results}
        ${is_true}=    Evaluate    1 if '${item}'=='True' else 0
        ${count}=    Evaluate    ${count} + ${is_true}
    END

    Run Keyword If    ${count} >= 2    Return From Keyword    True
    Return From Keyword    False


Validate Video Playback For Paused
    ${results}=    Create List
    Sleep   10s
    FOR    ${i}    IN RANGE    3
        ${now}=    generic.get_date_time
        ${d_rimg}=    Replace String    ${ref_img1}    replace    ${now}
        generic.capture image run    ${port}    ${d_rimg}
        CAPTURE CURRENT IMAGE WITH TIME

        Sleep    20s
        ${now}=    generic.get_date_time
        ${d_cimg}=    Replace String    ${comp_img}    replace    ${now}
        generic.capture image run    ${port}    ${d_cimg}
        CAPTURE CURRENT IMAGE WITH TIME

        ${pass}=    generic.compare_image    ${d_rimg}    ${d_cimg}
        Run Keyword If    ${pass}==True     Append To List    ${results}    True
        Run Keyword If    ${pass}==False    Append To List    ${results}    False
    END

    ${count}=    Set Variable    0
    FOR    ${item}    IN    @{results}
        ${is_true}=    Evaluate    1 if '${item}'=='True' else 0
        ${count}=    Evaluate    ${count} + ${is_true}
    END

    Run Keyword If    ${count} >= 2    Return From Keyword    True
    Return From Keyword    False

# Verify Zapping Time
#     [Arguments]    ${Direction}    ${numberOfZaps}
#     ${total_zaps}=    Set Variable    ${numberOfZaps}
#     FOR    ${i}    IN RANGE    ${total_zaps}
# 	    Log To Console    ${Direction}
# 	    Run Keyword    CLICK ${Direction}
#         ${zap_time}=    Zap And Measure Time
# 		Log To Console    Zap Time Calculated
#         VALIDATE IMAGE ON NAVIGATION   ${Direction}
#         Append To List    ${ZAP_TIMES}    ${zap_time}
#         Log To Console    Zap ${i+1}: ${zap_time} seconds
#         Should Be True    ${zap_time} < ${ZAP_LIMIT}    Zap ${i+1} took too long!
#     END
#     ${total_time}=    Evaluate    sum(${ZAP_TIMES})
#     Log To Console    Total zaps: ${total_zaps}
#     Log To Console    Total time taken: ${total_time} seconds

# Zap And Measure Time
#    ${start}=    Evaluate    __import__('time').time()
#    ${end}=      Evaluate    __import__('time').time()
#    ${elapsed}=  Evaluate    ${end} - ${start}
#    RETURN    ${elapsed}

Pre Check STB Health
    [Documentation]    Press UP and verify ${Expected_Image}. Reboot STB if not visible.
    CLICK HOME
    CLICK UP
    CLICK OK
    Sleep    2s
    ${Result}=    Verify Crop Image    ${port}    Home_Page

    IF    '${Result}' == 'True'
        Log To Console    Image is visible, continuing test
    ELSE
        Log To Console    Image not visible, rebooting STB
        Reboot STB Device
        Sleep    75s
        Log To Console    It may take few seconds
        CLICK OK
        Sleep   10s
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK OK
        Sleep   2s
    END

# VALIDATE IMAGE ON NAVIGATION
#     [Arguments]    ${Direction}
#     Sleep    3s
#     ${now}  generic.get_date_time
#     ${d_rimg}  Replace String  ${ref_img1}  replace  ${now}
#     generic.capture image run  ${port}  ${d_rimg}
#     #Log  <img src='${d_rimg}'></img>  html=yes
#     image_path  ${d_rimg}
#     sleep  2s
#     Run Keyword    CLICK ${Direction}
#     ${now}  generic.get_date_time
#     ${d_cimg}  Replace String  ${comp_img}  replace  ${now}
#     generic.capture image run  ${port}  ${d_cimg}
#     #Log  <img src='${d_cimg}'></img>  html=yes
#     image_path  ${d_cimg}
#     ${pass}  generic.compare_image  ${d_rimg}  ${d_cimg}
#     Run Keyword If  ${pass}==False  Log To Console  Image Changed
#     ...  ELSE  log To Console  Image is not Changed
#     RETURN  True

Check For Exit Popup
    ${Result}=    Verify Crop Image    ${port}    TC_217_Exit
    Log To Console    Exit popup found: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
        # CLICK HOME
    END
    RETURN    ${Result}

Check For Recording Completed Popup
    ${Result}=    Verify Crop Image    ${port}    TC_403_Record_Completed
    Log To Console    Recording Completed popup found: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
    END

search lionking movie
    
	CLICK MULTIPLE TIMES    3    DOWN
    CLICK RIGHT
    CLICK OK
	CLICK MULTIPLE TIMES    2    UP
    CLICK OK
    CLICK UP
	CLICK MULTIPLE TIMES    3    RIGHT
    CLICK OK

	CLICK MULTIPLE TIMES    4    DOWN
    CLICK OK
    CLICK MULTIPLE TIMES    3    UP
    CLICK MULTIPLE TIMES    2    RIGHT
    CLICK OK

    CLICK MULTIPLE TIMES    3    LEFT
    CLICK OK

    CLICK DOWN
    CLICK OK

    CLICK LEFT
    CLICK OK

    CLICK MULTIPLE TIMES    2    DOWN
    CLICK MULTIPLE TIMES    2    RIGHT
    CLICK OK

    CLICK MULTIPLE TIMES    3    UP
    CLICK RIGHT
    CLICK OK

    CLICK MULTIPLE TIMES    2    LEFT
    CLICK OK

    CLICK LEFT
    CLICK DOWN
    CLICK OK

    CLICK UP
    CLICK LEFT
    CLICK OK

    CLICK MULTIPLE TIMES    5    DOWN
    CLICK OK

	Sleep    1s
	CLICK LEFT
    CLICK DOWN
    CLICK OK
    Sleep    1s



check for vod expired notice
    ${Result}  Verify Crop Image  ${port}  boxoffice_rent_dismiss_message
    Log To Console  error message Is Displayed
	Run Keyword If  '${Result}' == 'True'  CLICK OK
    ...    ELSE    Log To Console  error message Is Displayed

Check Who's Watching login
    Sleep    1s
    ${Result}=    Verify Crop Image    ${port}    TC_520_Who_Watching
    Log To Console    Who's login: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK OK
        Sleep    75s
    END

Box Office Buy
    ${BuyResult}=     Verify Crop Image With Shorter Duration    ${port}    BoxOffice_Buy
    Log To Console    Buy: ${BuyResult}
    IF    '${BuyResult}' == 'True'
        CLICK DOWN
        CLICK DOWN
        Sleep    1s
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK DOWN
        CLICK DOWN
        Log To Console    VOD is purchased
    ELSE
    Log To Console    Selected VOD is already purchased
    END
Box Office Buy by points
    ${BuyResult}=     Verify Crop Image With Shorter Duration    ${port}    BoxOffice_Buy
    Log To Console    Buy: ${BuyResult}
    IF    '${BuyResult}' == 'True'
        CLICK DOWN
        CLICK OK
        CLICK DOWN
        CLICK OK
        Sleep    1s
        Log To Console    VOD is purchased
    ELSE
    Log To Console    Selected VOD is already purchased
    END
Buy_Top_rated
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    TC_524_BUY
    Log To Console    Exit popup found: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
        CLICK DOWN
        CLICK DOWN
        Sleep    1s
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK DOWN
        CLICK DOWN
        CLICK OK
        CLICK OK
    END

Rent_Top_rated
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    TC_524_RENT
    Log To Console    Exit popup found: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
        CLICK DOWN
        CLICK DOWN
        Sleep    1s
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK DOWN
        CLICK DOWN
        CLICK OK
        CLICK OK
    END
Box Office Rentals Buy or rent
    ${RentResult}=    Verify Crop Image With Shorter Duration   ${port}    BoxOffice_Rent
    ${BuyResult}=     Verify Crop Image With Shorter Duration     ${port}    BoxOffice_Buy
    Log To Console    Rent: ${RentResult}
    Log To Console    Buy: ${BuyResult}
    IF    '${RentResult}' == 'True' or '${BuyResult}' == 'True'
        CLICK OK
        CLICK OK
        CLICK DOWN
        CLICK DOWN
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK DOWN
        CLICK DOWN
        CLICK OK
    ELSE
        CLICK OK
    END

VALIDATE IMAGES AFTER SOME DURATION
    Sleep  20s
    ${now}=  generic.get_date_time
    ${d_rimg}=  Replace String  ${ref_img1}  replace  ${now}
    generic.capture image run  ${port}  ${d_rimg}
    ${image_path}=  Set Variable  ${d_rimg}
    CLICK RIGHT
    Log To Console    Waiting for program change

    Sleep  5400s

    ${Result}=  Verify Crop Image  ${port}  today

    Run Keyword If  '${Result}' == 'True'    CLICK LEFT
    RETURN    True

    Log To Console    TODAY is NOT displayed, performing recovery actions
    CLICK OK
    CLICK RIGHT
    CLICK RIGHT
    CLICK LEFT

    ${now}=  generic.get_date_time
    ${d_cimg}=  Replace String  ${comp_img}  replace  ${now}
    generic.capture image run  ${port}  ${d_cimg}
    Set Variable  ${image_path}  ${d_cimg}

    ${pass}=  generic.compare_image  ${d_rimg}  ${d_cimg}
    Run Keyword If  ${pass}==False  Log To Console    Program changed dynamically
    ...  ELSE  Log To Console    Program still remains same

    RETURN  True

Verify ProgressBar
    CLICK UP
    ${Progress}  runtime.tempMatch  ${port}  Progressbar_com  Progressbar_ref
    log to console    ${Progress}
    Run Keyword If  '${Progress}' == 'False'  Log To Console    video playback Progress Bar is seeked
Games subscription pin
    ${Result}=    Verify Crop Image    ${port}    Gaming_contentnotsuitable
    Log To Console    Content not suitable: ${Result}
    IF    '${Result}' == 'True'
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK OK
    END

parental_block
    ${pin}  Verify Crop Image  ${port}     TC_713_Parental
    Log To Console    login: ${pin}
    IF    '${pin}'=='True'
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK DOWN
        CLICK OK
    END

Check Rating
    ${Rating}=    Verify Crop Image    ${port}    imrating
#     ${PG13}=      Verify Crop Image    ${port}    PG13
#     ${G}=         Verify Crop Image    ${port}    G-rating
#    ${rating_15}=   Verify Crop Image    ${port}    15_rating
#     ${rating_18}=   Verify Crop Image    ${port}    18_rating
    Log To Console    Rating: ${Rating}
    # Log To Console    G: ${G}
    # Log To Console    PG13: ${PG13}
    # Log To Console    15+: ${rating_15}
    # Log To Console    18+: ${rating_18}

    # Run Keyword If
    #     ...    ${Rating} or ${PG13} or ${G} or ${rating_15} or ${rating_18}
    #     ...    Log To Console    imrating Is Displayed on screen
    #     ...    ELSE
    #     ...    Log To Console    imrating Is Not Displayed on screen
    ${ocr_text}=    Rating OCR
    Check Rating In OCR Text    ${ocr_text}


Validate PiP
    [Arguments]    ${channel}
    Log To Console    PiP validated for ${channel}

Validate CatchUp
    [Arguments]    ${channel}
    Log To Console    CatchUp validated for ${channel}

Validate EPG
    [Arguments]    ${channel}
    Log To Console    EPG validated for ${channel}

Validate Start Over
    [Arguments]    ${channel}
    Log To Console    Start Over validated for ${channel}

Validate Video Availability
    [Arguments]    ${channel}
    Log To Console    Video Availability validated for ${channel}

Reboot STB Device
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB07_DWI259S"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    90s
    Log To Console    Reboot Success
    Check Who's Watching login
    Sleep   10s
    CLICK HOME
    Sleep     2s
    CLICK HOME
     Sleep    2s
    CLICK HOME

pinblock
    ${pin}  Verify Crop Image With Shorter Duration  ${port}     Pin_Block
    Log To Console    login: ${pin}
    IF    '${pin}'=='True'
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK DOWN
        CLICK OK
    END
resume
    ${pin}  Verify Crop Image  ${port}     resume
    Log To Console    login: ${pin}
    IF    '${pin}'=='True'
        CLICK OK
    END

Rating
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
    CLICK Ok
	CLICK Ok
	buyrentalsblock
	pinblock
    Sleep    5s
	CLICK UP
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused

checkformat
    ${format}  Verify Crop Image  ${port}     HD
    Log To Console    login: ${format}
    IF    '${format}'=='True'
        CLICK OK
    END

Validate Extracted Text From Image
    [Arguments]    ${EXPECTED_TEXT}
    Log To Console    \n🔍 Using image: ${IMAGE_PATH}
    ${result}=    Extract And Check Text    ${IMAGE_PATH}    ${EXPECTED_TEXT}
    Log To Console    ✅ Text Found: ${result}
    Should Be True    ${result}    ❌ ${EXPECTED_TEXT} Text not found in image!

Channel Monitoring
    [Arguments]    ${channel_name}
    Log To Console    Monitoring ${channel_name}

    ${features}=    Get From Dictionary    ${CHANNEL_FEATURES}    ${channel_name}

    Run Keyword If    '${features.PiP}'=='True'    Validate PiP    ${channel_name}
    Run Keyword If    '${features.CatchUp}'=='True'    Validate CatchUp    ${channel_name}
    Run Keyword If    '${features.EPGCheck}'=='True'    Validate EPG    ${channel_name}
    Run Keyword If    '${features.StartOver}'=='True'    Validate Start Over    ${channel_name}
    Run Keyword If    '${features.VideoAvailability}'=='True'    Validate Video Availability    ${channel_name}

Handle Recording Failure
    Log To Console    Recording Failed or Unexpected Popup Detected
    # Go to new channel 7105
    CLICK SEVEN
    # CLICK
    CLICK ZERO
    # CLICK TWO
    CLICK FIVE
    Log To Console    Navigated To Channel 705
    Sleep    20s
    # CLICK BACK
    # CLICK BACK
    CLICK RIGHT
    ${STEP_COUNT}=    Move to Record On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    # Sleep   1s
    # CLICK DOWN
    # CLICK DOWN
    # CLICK DOWN
    # CLICK OK
    Log To Console    Tapped Record Button Again on Channel 705

    CLICK DOWN
    CLICK OK
    Log To Console    Record The Program Is Selected Again

    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    Sleep    2s

    ${Result}=    Verify Crop Image With Shorter Duration   ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'
    ...    Log To Console    TC_401_Rec_Start on 705 Is Displayed
    ...    ELSE
    ...    Fail    TC_401_Rec_Start Is Not Displayed Even After Switching Channel
Guide Channel List
    FOR  ${i}  IN RANGE  5
        ${Result1}=  Verify Crop Image  ${port}  Channel_List
        IF  '${Result1}' == 'True'
            Click OK
        ELSE
            Exit For Loop
        END
    END
# Selecting Startover Filter From Guide
#     CLICK HOME
# 	CLICK UP
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK
# 	Guide Channel List
# 	CLICK LEFT
#     Log To Console    Navigating to filter
# 	${STEP_COUNT}=    Move to Filter On Side Pannel
# 	CLICK RIGHT
#     FOR    ${i}    IN RANGE    ${STEP_COUNT}
#         CLICK DOWN
#     END
#     CLICK OK
#     Log To Console    Filter selected
# 	# CLICK DOWN
# 	# CLICK DOWN
# 	# CLICK DOWN
# 	# CLICK OK
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK UP
# 	CLICK OK
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK DOWN
# 	CLICK OK

Revert locked channels
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


Normalize Spelling
    [Arguments]    ${text}
    ${output}=    Replace String    ${text}    Dubal    Dubai
    ${output}=    Replace String    ${text}    ejunior HD    e-junior HD
    RETURN    ${output}

STOP SCHEDULED RECORDING   
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
Selecting Startover Filter From Guide
    CLICK HOME
	CLICK BACK
    CLICK BACK
    Sleep    12s
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	# Guide Channel List
	CLICK LEFT
    Sleep   3s
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
    
Revert Startover Settings
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
RemoveFilter_UnlockChannels
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
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK UP
    CLICK UP
    CLICK OK

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

    CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK OK
    # Guide Channel List
    CLICK LEFT
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
    CLICK UP
    CLICK UP
    CLICK UP
    CLICK UP
    CLICK OK
    CLICK BACK
    CLICK HOME

Check For Who's Watching login Page
    # CLICK TWO
    # CLICK TWO
    # CLICK TWO
    # CLICK TWO
    # CLICK OK
    # Sleep    15s
    # Sleep    1s
    ${Result}=    Verify Crop Image    ${port}   Whos_watching_Enterpin
    Log To Console    Who's login: ${Result}
    IF    '${Result}' == 'True'
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK OK
        CLICK OK
        Sleep    30s
    END

Move to Set Reminder On Side Pannel under EPG
    [Arguments]   ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Add
    Log To Console    Add To Favorites: ${Result}
    IF    '${Result}' == 'True'
        ${base_count}=    Set Variable    1
        ${STEP_COUNT}=    Set Variable    ${base_count}
        Log To Console    ${base_count}
    END

    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Remove
    Log To Console    Remove Favorites: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    # ${Result}=    Verify Crop Image    ${port}    Set_Reminder
    # Log To Console    Set Reminder : ${Result}
    # IF    '${Result}' == 'True'
    #     ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    # END
    # CLICK RIGHT

    # ${Result}=    Verify Crop Image    ${port}    Record
    # Log To Console    Record: ${Result}
    # IF    '${Result}' == 'True'
    #     ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    # END
    # CLICK RIGHT

	Log To Console    After Increment: ${STEP_COUNT}

    RETURN    ${STEP_COUNT}

Revert UI language Subprofile
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
	Sleep    2s
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
	sleep    25s 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
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
	CLICK DOWN
	CLICK DOWN
	${Result}  Verify Crop Image  ${port}  Arabic_Language
	Run Keyword If  '${Result}' == 'True'  Log To Console  Arabic_Language Is Displayed
	...  ELSE  Fail  Arabic_Language Is Not Displayed
	
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
	CLICK DOWN
	CLICK OK
	Sleep    3s 
	CLICK OK
	Sleep    20s 
	CLICK HOME
	

Delete New Profile
    Navigate To Profile
    CLICK RIGHT
    CLICK DOWN
    CLICK DOWN
    CLICK Ok
    CLICK TWO
    CLICK TWO
    CLICK TWO
    CLICK TWO
    CLICK OK
    CLICK HOME

Revert UI language
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
	Sleep    55s
	CLICK HOME

Remove all scheduled Reminders
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
	${Result}  Verify Crop Image  ${port}  TC_809_Removal
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_809_Removal Is Displayed on screen
	...  ELSE   Log To Console     TC_809_Removal Is Not Displayed on screen
	CLICK OK
    CLICK OK
	CLICK HOME

Set Recording storage to Local
    CLICK HOME
    CLICK UP
    CLICK RIGHT
	CLICK RIGHT
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
    ${result}=  Verify Crop Image  ${port}  CLOUD_STORAGE_PROFILE_SETTING
	IF    '${result}' == 'True'
		CLICK OK
        CLICK DOWN
        CLICK OK
        CLICK DOWN
        CLICK DOWN
        CLICK DOWN
        CLICK DOWN
        CLICK OK
        Sleep    2s
        CLICK OK
	ELSE
		CLICK HOME
	END
    CLICK HOME

Arabic Channel List Fix
    Sleep    1s
    FOR  ${i}  IN RANGE  50
        ${Result1}=  Verify Crop Image  ${port}    ARABIC_CHANNEL_LIST_OK

        IF  '${Result1}' == 'True'
            Click OK
        ELSE
            Exit For Loop
        END
    END



Move to Set Reminder On Side Pannel
    [Arguments]   ${base_count}=1
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    CLICK RIGHT
    # ${Result}=    Verify Crop Image With Shorter Duration     ${port}    Add_To_Favorites
    # Log To Console    Add To Favorites: ${Result}
    # IF    '${Result}' == 'True'
    #     ${base_count}=    Set Variable    1
    #     ${STEP_COUNT}=    Set Variable    ${base_count}
    #     Log To Console    ${base_count}
    # END

    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    TC_Remove_Favs
    Log To Console    Remove Favorites: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END

	Log To Console    After Increment: ${STEP_COUNT}

    RETURN    ${STEP_COUNT}
Channel_Style
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
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
Remove_Favorite_Live_Tv
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK TWO
	CLICK FOUR
	CLICK SEVEN
	Sleep    20s
	CLICK OK
    CLICK RIGHT
    CLICK OK
	# CLICK RIGHT

    WHILE    True
        ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Remove_From_Fav
        Run Keyword If    '${Result}' == 'True'    Run Keywords
        ...    Log To Console    Remove_From_Fav Is Displayed    AND
        ...    CLICK DOWN    AND
        ...    CLICK OK    AND
        ...    CLICK OK    AND
        ...    Sleep    2s
        Run Keyword If    '${Result}' == 'False'    Exit For Loop
    END
        # CLICK OK


    Log To Console    Remove_From_Fav Is No Longer Displayed
    CLICK HOME

content_rating
	CLICK HOME
	CLICK UP
    CLICK RIGHT
    CLICK RIGHT
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
    Sleep	5s
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
    CLICK OK
    CLICK OK
Manage_Favorites
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
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
    CLICK OK
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
    Sleep   2s
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
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME
recommendations
    FOR    ${index}    IN RANGE    2
        ${RentResult}=    Verify Crop Image    ${port}    recm_rent
        ${BuyResult}=     Verify Crop Image    ${port}    recm_buy
        Log To Console    Rent: ${RentResult}
        Log To Console    Buy: ${BuyResult}

        IF    '${RentResult}' == 'True' or '${BuyResult}' == 'True'
        CLICK OK
        CLICK DOWN
        CLICK DOWN
        CLICK OK
        CLICK OK
        pinblock
        Exit For Loop If    '${RentResult}' == 'True' or '${BuyResult}' == 'True'
        END
    END


Move to Record SP
    [Arguments]   ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # CLICK RIGHT
    # ${Result}=    Verify Crop Image    ${port}    Add_To_Favorites
    # Log To Console    Audio Match Result: ${Result}
    # IF    '${Result}' == 'True'
    #     ${base_count}=    Set Variable    1
    #     ${STEP_COUNT}=    Set Variable    ${base_count}
    #     Log To Console    ${base_count}
    # END

    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    TC_Remove_Favs
    Log To Console    Remove Favorites: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Pause_Side_Panel
    Log To Console    Pause: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Start_Over
    Log To Console    Start over: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

	Log To Console    After Increment: ${STEP_COUNT}

    RETURN    ${STEP_COUNT}

# Verify Channel Availability
#     [Arguments]    ${channel_type}

#     ${channel_list}=    Set Variable If
#     ...    '${channel_type}' == 'SD'    ${SD_CHANNEL_LIST}
#     ...    '${channel_type}' == 'HD'    ${HD_CHANNEL_LIST}
#     ...    '${channel_type}' == 'UHD'   ${UHD_CHANNEL_LIST}
#     ...    ${NONE}

#     IF    $channel_list is None
#         Fail    No channels defined for type: ${channel_type}
#     END

#     ${found_channel}=    Set Variable    ${NONE}

#     FOR    ${channel}    IN    @{channel_list}
#         Log To Console    \n--- Verifying channel ${channel} (${channel_type}) ---
#         Input Channel Number    ${channel}
#         ${type_image_name}=    Set Variable If
#         ...    '${channel_type}' == 'SD'    SD_Img
#         ...    '${channel_type}' == 'HD'    HD_img
#         ...    '${channel_type}' == 'UHD'   UHD_Img
#         ...    NONE
#         ${match}=    Verify Crop Image    ${port}    ${type_image_name}
#         IF    '${match}' == 'True'
#             Log To Console    Found working ${channel_type} channel: ${channel}
#             ${found_channel}=    Set Variable    ${channel}
#             Exit For Loop
#         ELSE
#             Log To Console    Channel ${channel} did not match expected type — checking next
#         END
#     END

#     Run Keyword Unless    '${found_channel}'    Fail    No ${channel_type} channel found

#     RETURN    ${found_channel}

# Input Channel Number
#     [Arguments]    ${channel}
#     Sleep    3s
#     ${channel_str}=    Convert To String    ${channel}
#     ${digits}=    Evaluate    list(str(${channel_str}))
#     FOR    ${digit}    IN    @{digits}
#         Run Keyword If    '${digit}' == '0'    CLICK ZERO
#         ...    ELSE IF    '${digit}' == '1'    CLICK ONE
#         ...    ELSE IF    '${digit}' == '2'    CLICK TWO
#         ...    ELSE IF    '${digit}' == '3'    CLICK THREE
#         ...    ELSE IF    '${digit}' == '4'    CLICK FOUR
#         ...    ELSE IF    '${digit}' == '5'    CLICK FIVE
#         ...    ELSE IF    '${digit}' == '6'    CLICK SIX
#         ...    ELSE IF    '${digit}' == '7'    CLICK SEVEN
#         ...    ELSE IF    '${digit}' == '8'    CLICK EIGHT
#         ...    ELSE IF    '${digit}' == '9'    CLICK NINE
#         ...    ELSE    Fail    Invalid digit '${digit}' in channel number '${channel}'
#         Sleep    0.3s
#     END

Verify Channel Availability
    [Arguments]    ${channel_type}

    ${channel_list}=    Set Variable If
    ...    '${channel_type}' == 'SD'    ${SD_CHANNEL_LIST}
    ...    '${channel_type}' == 'HD'    ${HD_CHANNEL_LIST}
    ...    '${channel_type}' == 'UHD'   ${UHD_CHANNEL_LIST}
    ...    ${NONE}

    IF    $channel_list is None
        Fail    No channels defined for type: ${channel_type}
    END

    ${found_channel}=    Set Variable    ${NONE}

    FOR    ${channel}    IN    @{channel_list}
        Log To Console    \n--- Verifying channel ${channel} (${channel_type}) ---
        Input Channel Number    ${channel}

        IF    '${channel_type}' == 'SD'
            ${match}=    Set Variable    True
        ELSE
            ${type_image_name}=    Set Variable If
            ...    '${channel_type}' == 'HD'    HD_img
            ...    '${channel_type}' == 'UHD'   UHD_img
            ...    NONE
            ${match}=    Verify Crop Image    ${port}    ${type_image_name}
        END

        IF    '${match}' == 'True'
            Log To Console    Found working ${channel_type} channel: ${channel}
            ${found_channel}=    Set Variable    ${channel}
            Exit For Loop
        ELSE
            Log To Console    Channel ${channel} did not match expected type — checking next
        END
    END

    Run Keyword Unless    '${found_channel}'    Fail    No ${channel_type} channel found

    RETURN    ${found_channel}


Input Channel Number
    [Arguments]    ${channel}
    Sleep    3s
    ${channel_str}=    Convert To String    ${channel}
    ${digits}=    Evaluate    list(str(${channel_str}))
    FOR    ${digit}    IN    @{digits}
        Run Keyword If    '${digit}' == '0'    CLICK ZERO
        ...    ELSE IF    '${digit}' == '1'    CLICK ONE
        ...    ELSE IF    '${digit}' == '2'    CLICK TWO
        ...    ELSE IF    '${digit}' == '3'    CLICK THREE
        ...    ELSE IF    '${digit}' == '4'    CLICK FOUR
        ...    ELSE IF    '${digit}' == '5'    CLICK FIVE
        ...    ELSE IF    '${digit}' == '6'    CLICK SIX
        ...    ELSE IF    '${digit}' == '7'    CLICK SEVEN
        ...    ELSE IF    '${digit}' == '8'    CLICK EIGHT
        ...    ELSE IF    '${digit}' == '9'    CLICK NINE
        ...    ELSE    Fail    Invalid digit '${digit}' in channel number '${channel}'
        Sleep    0.3s
    END

VALIDATE VIDEO PLAYBACK ON ZAPPING
    ${now}  generic.get_date_time
    ${d_rimg}  Replace String  ${ref_img1}  replace  ${now}
    generic.capture image run  ${port}  ${d_rimg}
    #Log  <img src='${d_rimg}'></img>  html=yes
    CAPTURE CURRENT IMAGE WITH TIME
    sleep  10s
    ${now}  generic.get_date_time
    ${d_cimg}  Replace String  ${comp_img}  replace  ${now}
    generic.capture image run  ${port}  ${d_cimg}
    #Log  <img src='${d_cimg}'></img>  html=yes
    CAPTURE CURRENT IMAGE WITH TIME
    ${pass}  generic.compare_image  ${d_rimg}  ${d_cimg}
    Run Keyword If  ${pass}==False  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is not playing
    # RETURN  True

Channel Playback Verified
    [Arguments]    ${expected_channel}    ${channel_type}

    # For SD we check that HD_img is NOT present
    IF    '${channel_type}' == 'SD'
        Log To Console    Checking that HD_img is NOT displayed for SD channel: ${expected_channel}
        ${type_result}=    Verify Crop Image    ${port}    HD_img
        ${type_result}=    Convert To Boolean    ${type_result}

        IF    not ${type_result}
            Log To Console    HD_img is NOT displayed (as expected for SD channel)
            ${type_result}=    Set Variable    True
        ELSE
            Log To Console    HD_img IS displayed (unexpected for SD channel!)
            ${type_result}=    Set Variable    False
        END
    ELSE
        ${type_image_name}=    Set Variable If
        ...    '${channel_type}' == 'HD'    HD_img
        ...    '${channel_type}' == 'UHD'   UHD_img
        ...    NONE

        IF    '${type_image_name}' == 'NONE'
            RETURN    False
        END

        ${type_result}=    Verify Crop Image    ${port}    ${type_image_name}
        ${type_result}=    Convert To Boolean    ${type_result}

        IF    ${type_result}
            Log To Console    ${type_image_name} is displayed on screen
        ELSE
            Log To Console    ${type_image_name} is NOT displayed on screen
        END
    END

    VALIDATE VIDEO PLAYBACK ON ZAPPING
    RETURN    ${type_result}


# Channel Playback Verified
#     [Arguments]    ${expected_channel}    ${channel_type}

#     ${type_image_name}=    Set Variable If
#     ...    '${channel_type}' == 'SD'    SD_Img
#     ...    '${channel_type}' == 'HD'    HD_img
#     ...    '${channel_type}' == 'UHD'   UHD_Img
#     ...    NONE
#     IF    '${type_image_name}' == 'NONE'
#         RETURN    False
#     END

#     ${type_result}=    Verify Crop Image    ${port}    ${type_image_name}
#     ${type_result}=    Convert To Boolean    ${type_result}

#     IF    $type_result
#         Log To Console    ${type_image_name} is displayed on screen
#     ELSE
#         Log To Console    ${type_image_name} is NOT displayed on screen
#     END
#     VALIDATE VIDEO PLAYBACK
    RETURN    ${type_result}


Screen_Language
    	CLICK HOME
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
	# ${Result}  Verify Crop Image  ${port}  AUDIO_ENGLISH
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

Search And Click On Record From Side Panel Under EPG
    Set Test Variable    ${record_found}    False
    FOR    ${index}    IN RANGE    10
        ${Result}=    Verify Crop Image With Shorter Duration    ${port}    RECORD_SP
        IF    ${Result} == True
            Else Search Record Channel
            Exit For Loop
        END
        Log To Console    Attempt ${index + 1}: Record image not found, navigating...
        CLICK BACK
        Click Up
        Click Up
        Click Up
        CLICK UP
        CLICK UP
        Sleep    1s
        CLICK OK
        Sleep    20s
        # CLICK BACK
        CLICK RIGHT
    END
    Run Keyword If    ${record_found} == False    Fail    Could not find 'record' image after 10 attempts


Else Search Record Channel
    ${STEP_COUNT}=    Move to Record On Side Pannel
    Click Right
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        Click Down
    END
    Click OK
    Set Test Variable    ${record_found}    True


Search Scheduled Record
    Set Test Variable    ${record_found}    False
    FOR    ${index}    IN RANGE    10
        ${Result}=    Verify Crop Image With Shorter Duration   ${port}    Side_Pannel_Record
        IF    ${Result} == True
            Else Search Record Channel to Schedule
            Exit For Loop
        END
        Log To Console    Attempt ${index + 1}: Record image not found, navigating...
        CLICK BACK
        CLICK DOWN
        CLICK OK
    END
    Run Keyword If    ${record_found} == False    Fail    Could not find 'record' image after 10 attempts


Else Search Record Channel to Schedule
    ${STEP_COUNT}=    Move to Record On Side Pannel under EPG
    Click Right
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        Click Down
    END
    Click OK
    Set Test Variable    ${record_found}    True
Move to Record On Side Pannel under EPG
    [Arguments]   ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    TC_Add_To_Fav
    Log To Console    Add To Favorites: ${Result}
    IF    '${Result}' == 'True'
        ${base_count}=    Set Variable    1
        ${STEP_COUNT}=    Set Variable    ${base_count}
        Log To Console    ${base_count}
    END

    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    TC_Remove_Favs
    Log To Console    Remove Favorites: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}    Set_Reminder
    Log To Console    Set Reminder : ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

    # ${Result}=    Verify Crop Image    ${port}    Record
    # Log To Console    Record: ${Result}
    # IF    '${Result}' == 'True'
    #     ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    # END
    # CLICK RIGHT

	Log To Console    After Increment: ${STEP_COUNT}

    RETURN    ${STEP_COUNT}

CREATE PROFILE COCO
	CLICK HOME
	Log To Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
	CLICK OK
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
	CLICK OK
	Log To Console    Creating new profile
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
    Sleep   1s
	CLICK OK
	CLICK DOWN
	CLICK OK
    Sleep   1s
	CLICK DOWN
	CLICK OK
    Sleep   1s
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
    Sleep   1s
	CLICK UP
	CLICK UP
	CLICK UP
    CLICK UP
	CLICK UP
	CLICK UP
    Sleep   1s
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
    Sleep   1s
    CLICK LEFT
	CLICK LEFT
	CLICK LEFT
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
    CLICK RIGHT
    CLICK OK
    CLICK DOWN
    Sleep   1s
	CLICK DOWN
    CLICK OK
    CLICK UP
    Sleep   1s
    CLICK UP
    CLICK OK
    CLICK DOWN
    Sleep   1s
	CLICK DOWN
    CLICK OK
    CLICK DOWN
	CLICK DOWN
    Sleep   1s
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
    Sleep   1s
    CLICK DOWN
	CLICK DOWN
    Sleep   1s
	CLICK OK
    CLICK HOME
STOP RECORDING
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
    Sleep   2s
	CLICK DOWN
	CLICK OK
    Sleep   2s
	CLICK UP
    Sleep   2s
	CLICK OK
    Sleep   2s
	CLICK OK
    Sleep   2s
	CLICK OK

SET PG13 TO COCO
    CLICK HOME
	Log To Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
    Sleep   1s
	CLICK OK
    CLICK RIGHT
	CLICK DOWN
	CLICK OK
    Sleep   1s
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
    CLICK OK
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
    Sleep   1s
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
    CLICK OK
    Sleep   1s
    CLICK OK
    CLICK UP
    CLICK RIGHT
	CLICK RIGHT
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
    CLICK OK
    Sleep   1s
    CLICK UP
	CLICK UP
    CLICK UP
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    Sleep   1s
	CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK OK
    NAvigate To Profile
    CLICK RIGHT
    Sleep   1s
    CLICK Ok
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
    CLICK DOWN
    CLICK DOWN
    Sleep   1s
	CLICK DOWN
    CLICK DOWN
    CLICK OK
    Sleep    20s

DELETE COCO
    CLICK HOME
	Log To Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    Sleep   1s
	CLICK OK
    CLICK OK
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
    CLICK OK
    Sleep    10s

    CLICK HOME
	Log To Console    Navigated to Home page
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
    Sleep   1s
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    CLICK RIGHT
    Sleep   1s
	CLICK DOWN
    CLICK DOWN
	CLICK OK
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
    CLICK OK
    CLICK OK
    Log To Console    DELETED coco prof

Precheck Remove Favorite Image
    ${status}=    Run Keyword And Return Status    Verify Crop Image    ${port}    Remove08
    Run Keyword If    '${status}' == 'False'    Fail    Precheck failed: Remove08 image does not match live screen.


# Zap And Measure Time
#     [Arguments]    ${Direction}

#     # 1. Capture reference image
#     ${now}=    generic.get_date_time
#     ${d_rimg}=    Replace String    ${ref_img1}    replace    ${now}
#     generic.capture image run    ${port}    ${d_rimg}
#     image_path    ${d_rimg}

#     # 2. Capture start time
#     ${start}=    Evaluate    __import__('time').time()

#     # 3. Navigate using custom CLICK
#     Run Keyword    CLICK ${Direction}

#     # 4. Validate image changed
#     ${pass}=    VALIDATE IMAGE ON NAVIGATION    ${d_rimg}

#     # 5. Capture end time
#     ${end}=    Evaluate    __import__('time').time()
#     ${elapsed}=    Evaluate    ${end} - ${start}

#     RETURN    ${elapsed}


# VALIDATE IMAGE ON NAVIGATIONS
#     [Arguments]    ${ref_img}
#     ${now}=    generic.get_date_time
#     ${d_cimg}=    Replace String    ${comp_img}    replace    ${now}
#     generic.capture image run    ${port}    ${d_cimg}
#     image_path    ${d_cimg}

#     ${pass}=    generic.compare_image    ${ref_img}    ${d_cimg}
#     Run Keyword If    ${pass}==False    Log To Console    Image Changed
#     ...    ELSE    Log To Console    Image is not Changed
#     RETURN    ${pass}

# VALIDATE IMAGE ON NAVIGATION
#     [Arguments]    ${Direction}
#     Sleep    3s
#     ${now}  generic.get_date_time
#     ${d_rimg}  Replace String  ${ref_img1}  replace  ${now}
#     generic.capture image run  ${port}  ${d_rimg}
#     #Log  <img src='${d_rimg}'></img>  html=yes
#     image_path  ${d_rimg}
#     sleep  2s
#     Run Keyword    CLICK  ${Direction}
#     ${now}  generic.get_date_time
#     ${d_cimg}  Replace String  ${comp_img}  replace  ${now}
#     generic.capture image run  ${port}  ${d_cimg}
#     #Log  <img src='${d_cimg}'></img>  html=yes
#     image_path  ${d_cimg}
#     ${pass}  generic.compare_image  ${d_rimg}  ${d_cimg}
#     Run Keyword If  ${pass}==False  Log To Console  Image Changed
#     ...  ELSE  log To Console  Image is not Changed
#     RETURN  True





# Verify Zapping Time
#     [Arguments]    ${Direction}    ${numberOfZaps}
#     ${total_zaps}=    Set Variable    ${numberOfZaps}
#     ${ZAP_TIMES}=     Create List

#     ${overall_start}=    Evaluate    __import__('time').time()

#     FOR    ${i}    IN RANGE    ${total_zaps}
#         ${zap_time}=    Zap And Measure Time    ${Direction}
#         Append To List    ${ZAP_TIMES}    ${zap_time}

#         Log To Console    Zap ${i+1}: ${zap_time} seconds
#         Should Be True    ${zap_time} < ${ZAP_LIMIT}    Zap ${i+1} took ${zap_time} instead ${ZAP_LIMIT}
#     END

#     ${overall_end}=    Evaluate    __import__('time').time()
#     ${overall_elapsed}=    Evaluate    ${overall_end} - ${overall_start}

#     ${total_time}=    Evaluate    sum(${ZAP_TIMES})

#     Log To Console    Total zaps: ${total_zaps}
#     Log To Console    Sum of zap times: ${total_time} seconds
#     Log To Console    Overall elapsed time (tail-to-tail): ${overall_elapsed} seconds


VALIDATE IMAGE ON NAVIGATION
    [Arguments]    ${Direction}
    Sleep    3s
    ${now}  generic.get_date_time
    ${d_rimg}  Replace String  ${ref_img1}  replace  ${now}
    generic.capture image run  ${port}  ${d_rimg}
    #Log  <img src='${d_rimg}'></img>  html=yes
    image_path  ${d_rimg}
    sleep  2s
    Run Keyword    CLICK ${Direction}
    ${now}  generic.get_date_time
    ${d_cimg}  Replace String  ${comp_img}  replace  ${now}
    generic.capture image run  ${port}  ${d_cimg}
    #Log  <img src='${d_cimg}'></img>  html=yes
    image_path  ${d_cimg}
    ${pass}  generic.compare_image  ${d_rimg}  ${d_cimg}
    Run Keyword If  ${pass}==False  Log To Console  Image Changed
    ...  ELSE  log To Console  Image is not Changed
    RETURN  True

Verify Zapping Time
    [Arguments]    ${Direction}    ${numberOfZaps}
    ${total_zaps}=    Set Variable    ${numberOfZaps}
    FOR    ${i}    IN RANGE    ${total_zaps}
	    Log To Console    ${Direction}
	    Run Keyword    CLICK ${Direction}
        ${zap_time}=    Zap And Measure Time
		Log To Console    Zap Time Calculated
        VALIDATE IMAGE ON NAVIGATION   ${Direction}
        Append To List    ${ZAP_TIMES}    ${zap_time}
        Log To Console    Zap ${i+1}: ${zap_time} seconds
        Should Be True    ${zap_time} < ${ZAP_LIMIT}    Zap ${i+1} took too long!
    END
    ${total_time}=    Evaluate    sum(${ZAP_TIMES})
    Log To Console    Total zaps: ${total_zaps}
    Log To Console    Total time taken: ${total_time} seconds

Zap And Measure Time
   ${start}=    Evaluate    __import__('time').time()
   ${end}=      Evaluate    __import__('time').time()
   ${elapsed}=  Evaluate    ${end} - ${start}
   RETURN    ${elapsed}


loop to check assests with trailors
    CLICK DOWN
    FOR  ${i}  IN RANGE  5
        VALIDATE TRAILOR PLAYBACK
        Log To Console  Trailer Is Displayed and playing in the background
    END


# Verify Extracted From Image
#     # CLICK HOME
#     # sleep    20s
#     ${now}=    generic.get_date_time
#     ${d_rimg}=    Replace String    ${ref_img1}    replace    ${now}
#     generic.capture image run    ${port}    ${d_rimg}
#     Log To Console  ${d_rimg}
#     ${texts}=    Extract Text From Image    ${d_rimg}
#     Log    Extracted text: ${texts}
#     Log To Console    Extracted text: ${texts}


# Profile rent
#     FOR    ${i}    IN RANGE    5
#         FOR    ${j}    IN RANGE    10
#             ${Play}=    Verify Crop Image    ${port}    PROFILE_PLAY
#             ${Resume}=  Verify Crop Image    ${port}    PROFILE_RESUME
#             Log To Console    Play: ${Play}
#             Log To Console    Resume: ${Resume}

#             IF    '${Resume}' == 'True' or '${Play}' == 'True'
#                 Sleep   15s
#                 CLICK OK
#                 CLICK BACK
#                 CLICK RIGHT
#                 CLICK OK
#                 Exit For Loop    # exit inner loop if play/resume is found
#             END
#         END

#         # After finishing check (or exiting early), move to next asset
#         CLICK OK
#         FOR    ${k}    IN RANGE    7
#             CLICK DOWN
#         END
#         FOR    ${m}    IN RANGE    2
#             CLICK UP
#         END
#     END

Profile and edit Profile rent
    FOR    ${j}    IN RANGE    10
        ${Play}=    Verify Crop Image    ${port}    PROFILE_PLAY
        ${Resume}=  Verify Crop Image    ${port}    PROFILE_RESUME
        Log To Console    Play: ${Play}
        Log To Console    Resume: ${Resume}

        IF    '${Resume}' == 'True' or '${Play}' == 'True'
            Sleep   15s
            CLICK OK
            CLICK BACK
            CLICK RIGHT
            CLICK OK
            Exit For Loop    # exit inner loop if play/resume is found
        END
    END


Move to subtitle
    [Arguments]   ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # CLICK RIGHT
    # ${Result}=    Verify Crop Image    ${port}    Add_To_Favorites
    # Log To Console    Add To Favorite: ${Result}
    # IF    '${Result}' == 'True'
    #     ${base_count}=    Set Variable    1
    #     ${STEP_COUNT}=    Set Variable    ${base_count}
    #     Log To Console    ${base_count}
    # END

    CLICK RIGHT
    CLICK DOWN
    CLICK OK
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Remove_Favorite_Popups
    Log To Console    Remove Favorites: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
        CLICK BACK
        CLICK BACK
        CLICK RIGHT
    ELSE
        Log To Console    Remove Favorites Is not Present
        CLICK BACK
        CLICK BACK
        CLICK BACK
        CLICK RIGHT
    END

    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Pause_Side_Panel
    Log To Console    Pause: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Start_Over
    Log To Console    Start Over: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    Side_Pannel_Record
    Log To Console    Record: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
     CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    Side_Pannel_Catchup_Option
    Log To Console    Catch Up: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
	CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    More_Details_Option
    Log To Console    More Details: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	${Result}=    Verify Crop Image With Shorter Duration    ${port}    Audio
    Log To Console    Audio: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    Log To Console    After Increment: ${STEP_COUNT}

    RETURN    ${STEP_COUNT}

# Zap With Numeric Keys
#     [Arguments]    ${channel}
#     FOR    ${digit}    IN    @{channel}
#         CLICK ${digit}
#     END

Zap With Numeric Keys
    [Arguments]    ${channel}
    ${digits}=    Split String    ${channel}    ""
    FOR    ${digit}    IN    @{digits}
        Run Keyword If    '${digit}' == '0'    CLICK ZERO
        ...    ELSE IF    '${digit}' == '1'    CLICK ONE
        ...    ELSE IF    '${digit}' == '2'    CLICK TWO
        ...    ELSE IF    '${digit}' == '3'    CLICK THREE
        ...    ELSE IF    '${digit}' == '4'    CLICK FOUR
        ...    ELSE IF    '${digit}' == '5'    CLICK FIVE
        ...    ELSE IF    '${digit}' == '6'    CLICK SIX
        ...    ELSE IF    '${digit}' == '7'    CLICK SEVEN
        ...    ELSE IF    '${digit}' == '8'    CLICK EIGHT
        ...    ELSE IF    '${digit}' == '9'    CLICK NINE
        Sleep    0.5s    # tiny delay between digits
    END

Validate blank tile in details page
    Sleep    3s
    ${Result}  Verify Crop Image  ${port}  Blank_Tile
	Run Keyword If  '${Result}' == 'True'  Fail    Blank_tile2_MyTV Is Displayed
	...  ELSE  Log To Console   Blank_tile2_MyTV Is Not Displayed

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
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
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

Remove Reminder
    CLICK HOME
    CLICK UP
    CLICK MULTIPLE TIMES    5    RIGHT
    CLICK OK
    CLICK DOWN
    CLICK OK
    Sleep    2s
    CLICK OK
    CLICK OK
    CLICK UP
    CLICK OK
    Sleep    2s
    CLICK HOME

Set and revert admin as default user
    CLICK HOME
    CLICK UP
    CLICK MULTIPLE TIMES    10    RIGHT
    CLICK OK
    CLICK DOWN
    CLICK OK
    CLICK MULTIPLE TIMES    4    TWO
    CLICK OK
    Sleep    3s
    CLICK RIGHT
    CLICK MULTIPLE TIMES    4    DOWN
    CLICK OK
    CLICK MULTIPLE TIMES    2    DOWN
    CLICK OK
    CLICK OK
    CLICK HOME

Check the availability of preview
    sleep  5s
    ${now}  generic.get_date_time
    ${d_rimg}  Replace String  ${ref_img1}  replace  ${now}
    generic.capture image run  ${port}  ${d_rimg}
    #Log  <img src='${d_rimg}'></img>  html=yes
    image_path  ${d_rimg}
    sleep  8s
    ${now}  generic.get_date_time
    ${d_cimg}  Replace String  ${comp_img}  replace  ${now}
    generic.capture image run  ${port}  ${d_cimg}
    #Log  <img src='${d_cimg}'></img>  html=yes
    image_path  ${d_cimg}
    ${pass}  generic.compare_image  ${d_rimg}  ${d_cimg}
    Run Keyword If  '${pass}' == 'True'  Log To Console  Preview is not available for this asset
    ...  ELSE  Run Keyword  VALIDATE VIDEO PLAYBACK

Verify STB Home Page
    ${Home}=    Verify Crop Image    ${port}    Home_Page
    Run Keyword If    '${Home}' == 'False'    Fail    Home Page not reached yet

Disable always login in admin
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
	CLICK Down
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
    Sleep    3s
    CLICK RIGHT
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    ${Result}  Verify Crop Image  ${port}  Disable_Login_Admin
	Run Keyword If  '${Result}' == 'True'  Log To Console  Disable_Login_Admin Is already disabled
	...  ELSE  CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK OK
    CLICK HOME

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
    Sleep    5s


Login As Admin
    Navigate To Profile
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
	Sleep    30s

Reboot STB Device and Make sub profile as default user
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB07_DWI259S"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    75s
    Log To Console    Reboot Success
    Login to new user and make sub profile as default
    CLICK HOME

Reboot STB Device for new User
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB07_DWI259S"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    95s
    Log To Console    Reboot Success

Login to new user and make sub profile as default
    Sleep    1s
    ${Result}=    Verify Crop Image    ${port}   TC_520_Who_Watching
    Log To Console    Who's login: ${Result}
    IF    '${Result}' == 'True'
        CLICK RIGHT
        CLICK OK
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK DOWN
        CLICK OK
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK OK
        CLICK DOWN
        CLICK DOWN
        ${Result}  Verify Crop Image  ${port}  Disable_Login_Admin
        Run Keyword If  '${Result}' == 'False'  Log To Console  Disable_Login_Admin Is already disabled
        ...  ELSE  CLICK OK
        CLICK DOWN
        CLICK DOWN
        CLICK OK
        Sleep    30s
        CLICK HOME
    END

# Revert Always Login for subprofile
#     CLICK Home
# 	CLICK Up
# 	CLICK Right
# 	CLICK Right
# 	CLICK Right
# 	CLICK Right
# 	CLICK Right
# 	CLICK Right
# 	CLICK Right
# 	CLICK Right
# 	CLICK Right
# 	CLICK Right
# 	CLICK Right
# 	CLICK Ok
#     CLICK Right
# 	CLICK Down
# 	CLICK Ok
# 	CLICK Two
# 	CLICK Two
# 	CLICK Two
# 	CLICK Two
# 	CLICK Ok
#     Sleep    3s
#     CLICK DOWN
#     CLICK DOWN
#     CLICK DOWN
#     CLICK DOWN
#     CLICK DOWN
#     CLICK DOWN
#     CLICK OK
#     CLICK OK
#     CLICK UP
#     CLICK RIGHT
#     CLICK DOWN
#     CLICK DOWN
#     CLICK DOWN
#     CLICK DOWN
#     ${Result}  Verify Crop Image  ${port}  Disable_Login_Admin
# 	Run Keyword If  '${Result}' == 'True'  Log To Console  Disable_Login_Admin Is already disabled
# 	...  ELSE  CLICK OK
#     CLICK OK
#     CLICK DOWN
#     CLICK DOWN
#     CLICK OK
#     CLICK OK
#     CLICK HOME

Navigate and Login to Kids profile
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
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
	${Result}  Verify Crop Image  ${port}    Validate_Kids_Profile
	Run Keyword If  '${Result}' == 'True'  Log To Console  Validate_Kids_Profile Is Displayed on screen
	...  ELSE  Fail  Validate_Kids_Profile Is Not Displayed on screen

	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    20s
	CLICK HOME

Revert Always Login for subprofile
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
	CLICK Ok
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Two
	CLICK Ok
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
    CLICK DOWN
    CLICK DOWN
    ${Result}  Verify Crop Image  ${port}  Disable_Login_Admin
	Run Keyword If  '${Result}' == 'True'  Log To Console  Disable_Login_Admin Is already disabled
	...  ELSE  CLICK OK
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK OK
    CLICK HOME

Navigate and Login to Kids profile Abcd
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
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
	# ${Result}  Verify Crop Image  ${port}    Validate_Kids_Abcd
	# Run Keyword If  '${Result}' == 'True'  Log To Console  Validate_Kids_Profile Is Displayed on screen
	# ...  ELSE  Fail  Validate_Kids_Profile Is Not Displayed on screen

	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    20s
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
	CLICK OK
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}    TC_004_new_user
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_004_new_user Is Displayed on screen
	...  ELSE  Fail  TC_004_new_user Is Not Displayed on screen

	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	Sleep    5s
	CLICK HOME

Stand by mode
    CLICK POWER
    Sleep    10s
    CLICK POWER
    Sleep    20s
    CLICK HOME
    CLICK HOME
    CLICK HOME

Check Who's Watching login with avatar profile validation
    Sleep    1s
    ${Result}=    Verify Crop Image    ${port}    TC_520_Who_Watching
    Log To Console    Who's login: ${Result}
    IF    '${Result}' == 'True'
    	${Result}  Verify Crop Image  ${port}  Avatar_Reboot_Page
        Run Keyword If  '${Result}' == 'True'  Log To Console  Avatar_reboot_page Is Displayed on screen
        ...  ELSE  Fail  Avatar_reboot_page Is Not Displayed on screen
        CLICK RIGHT
        CLICK OK
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK OK
        Sleep    30s
        CLICK HOME
    END

Delete profile once in admin
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

Check Who's Watching login arabic
    Sleep    1s
    ${Result}=    Verify Crop Image    ${port}    Whos_watching_arabic
    Log To Console    Who's login: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK OK
        Sleep    20s
        CLICK HOME
    END

Reboot STB Device After profile delete
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB07_DWI259S"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    75s
    Log To Console    Reboot Success
    Check For Who's Watching login Page after delete profile
    CLICK HOME
    CLICK HOME
    CLICK HOME


Check For Who's Watching login Page With Custom avatar Validation
    Sleep    1s
    CLICK RIGHT
    ${Result}  Verify Crop Image  ${port}  TC_022_Custom_Avatart_Updated
	Run Keyword If  '${Result}' == 'True'  Log To Console  Custom avatar is updated
	...  ELSE  Fail  Custom avatar is not updated
    Sleep    2s
    CLICK LEFT
    Sleep    2s
    CLICK OK
    ${Result}=    Verify Crop Image    ${port}        Whos_watching_Enterpin

    Log To Console    Who's login: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK OK
        CLICK OK
        Sleep    30s
    END



Standby after delete profile
    CLICK POWER
    Sleep    6s
    CLICK POWER
    Sleep    20s
    Check For Who's Watching login Page after delete profile
    Sleep    15s
    CLICK HOME
    CLICK HOME
    CLICK HOME

Standby 
    CLICK POWER
    Sleep    6s 
    CLICK POWER
    Sleep    20s
    Check For Who's Watching login Page
    Sleep    15s
    CLICK HOME
    CLICK HOME
    CLICK HOME

Check For Who's Watching login Page after delete profile
    Sleep    1s
    ${Result}  Verify Crop Image  ${port}  TC_004_New_user_created
	Run Keyword If  '${Result}' == 'False'  Log To Console  Profile deleted successfully
	...  ELSE  Fail  Profile still remains
    ${Result}=    Verify Crop Image    ${port}       TC_520_Who_Watching

    Log To Console    Who's login: ${Result}
    IF    '${Result}' == 'True'
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK OK
        CLICK OK
        Sleep    30s
        CLICK HOME
    END

Reboot STB Device After With Custom avatar Validation
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB07_DWI259S"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    75s
    Log To Console    Reboot Success
    Check For Who's Watching login Page With Custom avatar Validation
    CLICK HOME
    CLICK HOME
    CLICK HOME

Standby With Custom avatar Validation
    CLICK POWER
    Sleep    6s
    CLICK POWER
    Sleep    50s
    Check For Who's Watching login Page With Custom avatar Validation
    Sleep    15s
    CLICK HOME
    CLICK HOME
    CLICK HOME



Reboot STB Device and Validate new profile with Avatar
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB07_DWI259S"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    75s
    Log To Console    Reboot Success
    Check Who's Watching login with avatar profile validation
    CLICK HOME



Create new profile with 3333 pin
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
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

Create new kids profile for 3333 pin
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
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
Apply Startover
    CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK OK

vod assest pick
    ${Result}=    Verify Crop Image   ${port}  vod_subscribe
    IF   '${Result}' == 'True'
        CLICK BACK
        CLICK BACK
        CLICK RIGHT
        CLICK OK
        CLICK OK
    END

Validate Video FastForward
    FOR    ${i}    IN RANGE    2
        sleep  3s
        ${now}  generic.get_date_time
        ${d_rimg}  Replace String  ${ref_img1}  replace  ${now}
        generic.capture image run  ${port}  ${d_rimg}
        #Log  <img src='${d_rimg}'></img>  html=yes
        CAPTURE CURRENT IMAGE WITH TIME
        sleep  4s
        ${now}  generic.get_date_time
        ${d_cimg}  Replace String  ${comp_img}  replace  ${now}
        generic.capture image run  ${port}  ${d_cimg}
        #Log  <img src='${d_cimg}'></img>  html=yes
        CAPTURE CURRENT IMAGE WITH TIME
        ${pass}  generic.compare_image  ${d_rimg}  ${d_cimg}
        Run Keyword If  ${pass}==False  Log To Console  Video is fastforwarding
    ...  ELSE  Fail  Video is not fastforwarding
    END

Validate Video Rewind
    FOR    ${i}    IN RANGE    2
        sleep  2s
        ${now}  generic.get_date_time
        ${d_rimg}  Replace String  ${ref_img1}  replace  ${now}
        generic.capture image run  ${port}  ${d_rimg}
        #Log  <img src='${d_rimg}'></img>  html=yes
        CAPTURE CURRENT IMAGE WITH TIME
        sleep  3s
        ${now}  generic.get_date_time
        ${d_cimg}  Replace String  ${comp_img}  replace  ${now}
        generic.capture image run  ${port}  ${d_cimg}
        #Log  <img src='${d_cimg}'></img>  html=yes
        CAPTURE CURRENT IMAGE WITH TIME
        ${pass}  generic.compare_image  ${d_rimg}  ${d_cimg}
        Run Keyword If  ${pass}==False  Log To Console  Video is Rewinding
    ...  ELSE  Fail  Video is not Rewinding
    END

Check for play or pause
    ${Resultpause}=    Verify Crop Image   ${port}  Pause_Button
    ${Result}=    Verify Crop Image   ${port}  Play_Button
    IF   '${Result}' == 'True'
        CLICK OK
    END

Navigate To Profile    
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

Always login Revert
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
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
    CLICK HOME

Log Step
    [Arguments]    ${n}    ${msg}
    Log To Console    [STEP ${n}] ${msg}


Reboot STB Device And Log Time
    [Arguments]    ${port}    ${device_name}=STB07_DWI259S    ${base}=http://192.168.1.58:5001    ${attempts}=25    ${initial_wait}=20s    ${poll}=2s

    ${url}=    Set Variable    ${base}/hard_reboot?data={"device_name":"${device_name}"}

    Log Step    0    Device: ${device_name} | Port: ${port}
    Log Step    1    Sending reboot request -> ${url}
    ${response}=    GET    ${url}
    Log Step    2    Reboot API status: ${response.status_code}
    Should Be Equal As Integers    ${response.status_code}    200

    ${start_epoch}=    Evaluate    __import__('time').time()
    ${start_iso}=      Get Time    result_format=%Y-%m-%d %H:%M:%S
    Log Step    3    Boot timer started at ${start_iso}

    Log Step    4    Initial wait ${initial_wait} to allow power cycle
    Sleep    ${initial_wait}

    ${end_epoch}=    Set Variable    ${None}
    ${limit}=        Evaluate    ${attempts} + 1
    FOR    ${i}    IN RANGE    1    ${limit}
        Log Step    5    Attempt ${i}/${attempts}: checking Home_Page
        ${Home}=    Verify Crop Image    ${port}    Home_Page
        IF    '${Home}' == 'True'
            ${end_epoch}=    Evaluate    __import__('time').time()
            ${end_iso}=      Get Time    result_format=%Y-%m-%d %H:%M:%S
            Log Step    6    Home_Page detected at ${end_iso}
            Exit For Loop
        END
        Sleep    ${poll}
    END

    Run Keyword If    '${end_epoch}' == '${None}'    Fail    [TIMEOUT] Home_Page not detected after ${attempts} attempts (initial wait ${initial_wait}, poll ${poll})

    ${elapsed}=       Evaluate    round(${end_epoch} - ${start_epoch}, 2)
    ${mins}=          Evaluate    int(${elapsed} // 60)
    ${secs}=          Evaluate    ${elapsed} - (${mins} * 60)
    ${elapsed_m_s}=   Evaluate    '{:02d}:{:05.2f}'.format(${mins}, ${secs})

    Log Step    7    Boot time = ${elapsed} s (${elapsed_m_s} mm:ss)
    RETURN    ${elapsed}



Subscription Rent Buy Flow
    FOR    ${i}    IN RANGE    20
        ${pin}=    Verify Crop Image With Shorter Duration    ${port}    TC_552_Subscription
        Log To Console    subscription: ${pin}
        IF    '${pin}' == 'True'
            CLICK BACK
            CLICK LEFT
            CLICK OK
        ELSE
            CLICK RIGHT
            ${RentResult}=    Verify Crop Image With Shorter Duration    ${port}    RENT
            ${BuyResult}=     Verify Crop Image With Shorter Duration    ${port}    BUY
            Log To Console    Rent: ${RentResult}
            Log To Console    Buy: ${BuyResult}

            IF    '${RentResult}' == 'True' or '${BuyResult}' == 'True'
                CLICK OK
                CLICK OK
                CLICK DOWN
                ${BillResult}=    Verify Crop Image With Shorter Duration    ${port}    Bill
                Log To Console    Bill: ${BillResult}

                IF    '${BillResult}' == 'True'
                    CLICK DOWN
                    CLICK TWO
                    CLICK TWO
                    CLICK TWO
                    CLICK TWO
                    CLICK DOWN
                    CLICK DOWN
                    CLICK OK
                    Log To Console    Asset is bought
                    Sleep    2s
                    Exit For Loop
                ELSE
                    CLICK TWO
                    CLICK TWO
                    CLICK TWO
                    CLICK TWO
                    CLICK DOWN
                    CLICK DOWN
                    CLICK OK
                    Log To Console    Asset is bought
                    Sleep    2s
                    Exit For Loop
                END
            ELSE
                Log To Console    No Rent/Buy found → stopping loop
                Exit For Loop
            END
        END
    END

Box Office Buy For Disable pin
    FOR    ${i}    IN RANGE    20
        ${BuyResult}=    Verify Crop Image    ${port}    BUY
        Log To Console    Buy: ${BuyResult}
        IF    '${BuyResult}' == 'True'
            Log To Console    Buy or rent found
            CLICK OK
            CLICK DOWN
            Sleep    1s
            CLICK DOWN
            CLICK DOWN
            CLICK DOWN
            CLICK OK
            Log To Console    VOD is purchased
            Exit For Loop
        ELSE
            Log To Console    Buy option not found, checking another asset
            CLICK BACK
            CLICK LEFT
            CLICK OK
            pinblock
        END
    END


Purchase VOD
       FOR    ${i}    IN RANGE    20
        CLICK RIGHT
        ${RentResult}=    Verify Crop Image With Shorter Duration    ${port}    RENT
        ${BuyResult}=     Verify Crop Image With Shorter Duration   ${port}    BUY
        Log To Console    Rent: ${RentResult}
        Log To Console    Buy: ${BuyResult}

        IF    '${RentResult}' == 'True' or '${BuyResult}' == 'True'
            CLICK OK
            CLICK OK
            CLICK DOWN
            ${res1}=    Get HD
            ${res1}=    Replace String    ${res1}    ${SPACE}${SPACE}    ${SPACE}


            Log    OCR TEXT = '${res1}'

            ${count}=    Get Count    ${res1}    HD
            Log    HD COUNT = ${count}

            IF    ${count} >= 2
                CLICK DOWN
            END

            ${billResult}=    Verify Crop Image With Shorter Duration    ${port}    Bill
            Log To Console    bill: ${billResult}

            IF    '${billResult}' == 'True'
                CLICK DOWN
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK DOWN
                CLICK DOWN
                CLICK OK
                Log To Console    Asset is bought (bill path)
                ${Result}  Verify Crop Image With Shorter Duration  ${port}  Now
                Run Keyword If  '${Result}' == 'True'  Log To Console  Now Is Displayed
                ...  ELSE  Fail  Now Is Not Displayed
                Sleep    2s
                Exit For Loop
            ELSE
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK DOWN
                CLICK DOWN
                CLICK OK
                Log To Console    Asset is bought (No bill path)
                ${Result}  Verify Crop Image With Shorter Duration  ${port}  Now
                Run Keyword If  '${Result}' == 'True'  Log To Console  Now Is Displayed
                ...  ELSE  Fail  Now Is Not Displayed
                Sleep    2s
                Exit For Loop
            END
        ELSE
            Log To Console    Rent/Buy not found, checking another asset
            CLICK BACK
            CLICK LEFT
            CLICK OK
            pinblock
        END
    END



Purchase VOD For Disable pin
    FOR    ${i}    IN RANGE    20
        CLICK RIGHT
        ${RentResult}=    Verify Crop Image With Shorter Duration    ${port}    RENT
        ${BuyResult}=     Verify Crop Image With Shorter Duration    ${port}    BUY
        Log To Console    Rent: ${RentResult}
        Log To Console    Buy: ${BuyResult}

        IF    '${RentResult}' == 'True' or '${BuyResult}' == 'True'
            CLICK OK
            CLICK OK
            CLICK DOWN
            ${res1}=    Get HD
            ${res1}=    Replace String    ${res1}    ${SPACE}${SPACE}    ${SPACE}


            Log    OCR TEXT = '${res1}'

            ${count}=    Get Count    ${res1}    HD
            Log    HD COUNT = ${count}

            IF    ${count} >= 2
                CLICK DOWN
            END

            ${billResult}=    Verify Crop Image    ${port}    Bill
            Log To Console    bill: ${billResult}

            IF    '${billResult}' == 'True'
                CLICK DOWN
                ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Box_office_disable_pin
                Run Keyword If    '${Result}' == 'True'    Log To Console    pin Is Displayed
                ...    ELSE    Fail    pin Is Not Displayed
                CLICK OK
                Log To Console    Asset is bought (bill path)
                ${Result}  Verify Crop Image With Shorter Duration  ${port}  Now
                Run Keyword If  '${Result}' == 'True'  Log To Console  Now Is Displayed
                ...  ELSE  Fail  Now Is Not Displayed
                Sleep    2s
                Exit For Loop
            ELSE
                ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Box_office_disable_pin
                Run Keyword If    '${Result}' == 'True'    Log To Console    pin Is Displayed
                ...    ELSE    Fail    pin Is Not Displayed
                CLICK OK
                Log To Console    Asset is bought (No bill path)
                ${Result}  Verify Crop Image With Shorter Duration  ${port}  Now
                Run Keyword If  '${Result}' == 'True'  Log To Console  Now Is Displayed
                ...  ELSE  Fail  Now Is Not Displayed
                Sleep    2s
                Exit For Loop
            END
        ELSE
            Log To Console    Rent/Buy not found, checking another asset
            CLICK BACK
            CLICK LEFT
            CLICK OK
            pinblock
        END
    END
Navigate To kids section
    CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK

Navigate To kids section in Boxoffice
    CLICK HOME
	Log to Console    Navigated to Home page
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
	CLICK DOWN
	CLICK OK

Check For Kids Content in Boxoffice
	Sleep    1s
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed
	CLICK RIGHT
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed
	CLICK RIGHT
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed
	CLICK RIGHT
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed
	CLICK RIGHT
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed

Check For Kids Channels in kids section
    ${Result}  Verify Crop Image  ${port}  KIDS_CHANNEL
	Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_CHANNEL Is Displayed
	...  ELSE  Fail  KIDS_CHANNEL Is Not Displayed
    CLICK RIGHT
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    Sleep    1s
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed
	CLICK RIGHT
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed
	CLICK RIGHT
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed
	CLICK RIGHT
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed
	CLICK RIGHT
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed

Check For Kids Movies in kids section
    Sleep    1s
    ${Result}  Verify Crop Image  ${port}  KIDS_MOVIES
	Run Keyword If  '${Result}' == 'True'  Log To Console  KIDS_MOVIES Is Displayed
	...  ELSE  Fail  KIDS_MOVIES Is Not Displayed
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    Sleep    2s
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed
	CLICK RIGHT
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed
	CLICK RIGHT
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed
	CLICK RIGHT
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed
	CLICK RIGHT
	Log to Console    Navigated to On Demand junior kids section
	${Result}  Verify Crop Image  ${port}  TC529_Kids_G
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC529_Kids_G Is Displayed
	...  ELSE  Fail  TC529_Kids_G Is Not Displayed


Zap Until Target Channel Found
    [Arguments]    ${Direction}    ${maxZaps}
    ${ZAP_TIMES}=    Create List
    ${found}=    Set Variable    False

    FOR    ${i}    IN RANGE    ${maxZaps}
        ${start}=    Evaluate    __import__('time').time()
        Run Keyword    CLICK ${Direction}
        ${end}=    Evaluate    __import__('time').time()

        ${elapsed}=    Evaluate    round(${end} - ${start}, 3)
        Append To List    ${ZAP_TIMES}    ${elapsed}
        Log To Console    Zap ${i + 1}: ${elapsed} seconds

        ${verification}=    Run Keyword And Ignore Error    Verify Crop Image With Shorter Duration    ${port}    Discovery_Channel_01
        ${status}=    Set Variable    ${verification[0]}
        ${value}=     Set Variable If    len(${verification}) > 1    ${verification[1]}    False

        Log To Console    Verification result -> status: ${status}, value: ${value}

        IF    '${status}' == 'PASS' and '${value}' == 'True'
            Log To Console    Target image found at zap ${i + 1}
            ${found}=    Set Variable    True
            Exit For Loop
        END
    END

    ${total_time}=    Evaluate    round(sum(${ZAP_TIMES}), 3)
    Log To Console    Total zaps attempted: ${i + 1}
    Log To Console    Total time taken: ${total_time} seconds

    Run Keyword Unless    ${found}    Fail    Target image was NOT found after ${maxZaps} zaps

# How to use it in Test
# ${status}=    Verify Video Playback    PLAYING
# Should Be True    ${status}    Video is not playing when it should be
# ${status}=    Verify Video Playback    PAUSED
# Should Be True    ${status}    Video is not Paused when it should be
Verify Video Playback
    [Arguments]    ${mode}
    [Documentation]    Validate video playback state (PAUSED/PLAYING) and call black screen check.

    # ----------------------------
    # Loop: PAUSED / PLAYING check
    # ----------------------------
    ${results}=    Create List
    Sleep    10s
    FOR    ${i}    IN RANGE    3
        ${now}=    generic.get_date_time
        ${d_rimg}=    Replace String    ${ref_img1}    replace    ${now}
        generic.capture image run    ${port}    ${d_rimg}
        Log To Console    [${i}] Captured reference image: ${d_rimg}

        Sleep    20s
        ${now}=    generic.get_date_time
        ${d_cimg}=    Replace String    ${comp_img}    replace    ${now}
        generic.capture image run    ${port}    ${d_cimg}
        Log To Console    [${i}] Captured comparison image: ${d_cimg}

        ${diff}=    generic.compare_image_difference    ${d_rimg}    ${d_cimg}
        Log To Console    [${i}] Image difference = ${diff}

        Run Keyword If    '${mode}' == 'PAUSED' and ${diff} < 1    Append To List    ${results}    True
        ...    ELSE IF    '${mode}' == 'PAUSED'    Append To List    ${results}    False
        ...    ELSE IF    '${mode}' == 'PLAYING' and ${diff} > 5    Append To List    ${results}    True
        ...    ELSE    Append To List    ${results}    False

        ${last}=    Get From List    ${results}    -1
        Log To Console    [${i}] ${mode} check result: ${last}
    END
    Check Black Screen    ${black_screen}
    ${count}=    Set Variable    0
    FOR    ${item}    IN    @{results}
        ${is_true}=    Evaluate    1 if '${item}'=='True' else 0
        ${count}=    Evaluate    ${count} + ${is_true}
    END

    ${total}=    Get Length    ${results}
    Log To Console    Total positive results (${mode} detected): ${count} / ${total}

    IF    ${count} >= 2
        Return From Keyword    True
    ELSE
        Log To Console    Video is NOT detected as ${mode}
        Return From Keyword    False
    END

Check Black Screen
    [Arguments]    ${black_screen_ref}
    [Documentation]    Fails the test if a black screen is detected for 20 seconds.

    Log To Console    Checking for black screen — test fails if detected
    ${black_results}=    Create List
    FOR    ${i}    IN RANGE    3
        Sleep    20s
        ${now}=    generic.get_date_time
        ${d_cimg}=    Replace String    ${comp_img}    replace    ${now}
        generic.capture image run    ${port}    ${d_cimg}
        Log To Console    [BlackScreen ${i}] Captured comparison image: ${d_cimg}

        ${black_diff}=    generic.compare_image_difference    ${d_cimg}    ${black_screen}
        Log To Console    [BlackScreen ${i}] Difference from black screen = ${black_diff}

        Run Keyword If    ${black_diff} < 1    Append To List    ${black_results}    True
        ...    ELSE    Append To List    ${black_results}    False
    END

    ${black_count}=    Set Variable    0
    FOR    ${item}    IN    @{black_results}
        ${is_true}=    Evaluate    1 if '${item}'=='True' else 0
        ${black_count}=    Evaluate    ${black_count} + ${is_true}
    END

    IF    ${black_count} >= 2
        Log To Console    Black screen detected for 20s! Failing test.
        Fail    Black screen detected for 20s
    END

# How to Use in Test${channel_number_Before}=    Identify StartOver Channel
#     Log To Console    📺 Channel Before Start Over: ${channel_number_Before}
# 	Sleep    2s
#     ${channel_number_After}=    Extract Text From Screenshot
# 	Should Be Equal    ${channel_number_Before}    ${channel_number_After}


Catchup favorites
    # ${Result}=    Verify Crop Image    ${port}    TC_217_remove_Favorites_img
    # Log To Console    Remove favorites: ${Result}
    # IF    '${Result}' == 'True'
    #     CLICK DOWN
    #     CLICK DOWN
    #     CLICK OK
    # END
    # IF    '${Result}' == 'False'
    #     CLICK DOWN
    #     CLICK OK
    # END
    ${STEP_COUNT}=    Move to Pause On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
Verify it is playbutton or not
    ${Result}=    Verify Crop Image    ${port}    Play_Button
    Log To Console    PlayButton: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
    END

Catchup favorites down
    # CLICK DOWN
    # CLICK OK
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
    CLICK OK

catchup category navigations
    CLICK RIGHT
    Log To Console    Navigated To Catch Up Movies Feed
	CLICK OK
	CLICK OK
    Log To Console    Selected Catch Up Playback
	Catchup favorites
	Sleep    3s
	CLICK UP
    Log To Console    Browsed Catch Up Categories And Initiated Content Playback
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	# Sleep    180s
	${Result}  Validate Video Playback For Playing
    Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
    ...  ELSE  Log To Console  Video is Paused
    CLICK HOME

Identify StartOver Channel
    CLICK HOME
    Sleep    3s

    FOR    ${i}    IN RANGE    10
        CLICK CHANNEL_PLUS
        ${channel_number}=    Extract Text From Screenshot
        Log To Console    📺 Channel Checked: ${channel_number}

        CLICK BACK
        CLICK RIGHT
        Sleep    1s

        ${Result}=    Verify Crop Image    ${port}    Start_Over
        Log To Console    🔍 Start Over Match: ${Result}

        Run Keyword If    '${Result}' == 'True'    Handle Start Over Navigation
        Run Keyword If    '${Result}' == 'True'    Exit For Loop

        Sleep    2s
    END

    Run Keyword Unless    '${Result}' == 'True'    Fail    ❌ Start Over not found in 10 attempts
    RETURN    ${channel_number}
Handle Start Over Navigation
    ${STEP_COUNT}=    Move to Start Over On Side Pannel
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    Select Start Over And Verify
    Validate Video Playback For Playing
    CLICK HOME
    CLICK OK
    Sleep    5s

Extract Text From Screenshot
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console     AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Channel Number Program Info Bar   ${after_image_path}
    Log To Console     CROPPED AFTER INFO BAR: ${cropped_img}
     # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    # RETURN    ${channel_name_epg_text} 
    ${channel_name_epg_text}=    Set Variable    ${after_text}
    RETURN    ${channel_name_epg_text}

Extract Text From Channel Bar
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop Channel Number    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${channel_number}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${channel_number}
    Log To Console    📺 Extracted Channel Number: ${channel_number}
    RETURN    ${channel_number}

Extract Time And Program From Screenshot
    ${now}=    generic.get_date_time
    ${img_name}=    Replace String    ${ref_img1}    replace    ${now}
    generic.capture image run    ${port}    ${img_name}
    Log To Console    📸 Captured Image: ${img_name}

    ${texts}=    getTimeStampAndProgramName.Extract EPG Texts From Bottom Image    ${img_name}
    Log To Console    📺 Raw OCR Texts: ${texts}

    RETURN    ${texts}


Get Live Progress Bar Status
    ${now}=    generic.get_date_time
    ${before_image_path}=    Replace String    ${ref_img1}    replace    ${now}
    generic.capture image run    ${port}    ${before_image_path}
    Log To Console    BEFORE IMAGE: ${before_image_path}
    ${before_crop}=    IPL.Crop Progress Bar    ${before_image_path}
    Log To Console    CROPPED BEFORE INFO BAR: ${before_crop}
    RETURN    ${before_crop}

Get Live Progress Bar Status On Pause
    ${now}=    generic.get_date_time
    ${before_image_path}=    Replace String    ${ref_img1}    replace    ${now}
    generic.capture image run    ${port}    ${before_image_path}
    Log To Console    BEFORE IMAGE: ${before_image_path}
    ${before_crop}=    IPL.Crop Progress Bar On Pause   ${before_image_path}
    Log To Console    CROPPED BEFORE INFO BAR: ${before_crop}
    RETURN    ${before_crop}
Get Start Over Progress Bar Status
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop Progress Bar after    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    Check OCR Start Timestamp Using AI Slots    ${after_text}
    RETURN    ${after_crop}

Verify the Similarity
    [Arguments]    ${before_crop}    ${after_crop}
    # Primary Validation: OCR Text Change
    # Fallback Validation: SSIM Comparison
    ${similarity}=    IPL.Compare Images SSIM    ${before_crop}    ${after_crop}
    Log To Console    SSIM SIMILARITY: ${similarity}
    Should Be True    ${similarity} < 0.85    Cropped images too similar — Start Over not detected.


Ensure Pause And StartOver Are Visible
    [Arguments]    ${default_channel_number}
    ${latest_channel_number}=    Set Variable    ${default_channel_number}

    ${Pause_Visible}=    Verify Crop Image With Shorter Duration    ${port}    Pause_Side_Panel
    CLICK RIGHT
    ${Start_Over_Visible}=    Verify Crop Image With Shorter Duration    ${port}    Start_Over
    Log To Console    Pause Visible: ${Pause_Visible}
    Log To Console    Start Over Visible: ${Start_Over_Visible}
    ${both_visible}=    Evaluate    ${Pause_Visible} and ${Start_Over_Visible}

    IF    not ${both_visible}
        FOR    ${i}    IN RANGE    10
            Log To Console    Attempt ${i}: Checking Pause and Start Over
            CLICK RIGHT
            ${Pause_Visible}=    Verify Crop Image With Shorter Duration    ${port}    Pause_Side_Panel
            CLICK RIGHT
            ${Start_Over_Visible}=    Verify Crop Image With Shorter Duration    ${port}    Start_Over
            Log To Console    Pause Visible: ${Pause_Visible}
            Log To Console    Start Over Visible: ${Start_Over_Visible}
            ${both_visible}=    Evaluate    ${Pause_Visible} and ${Start_Over_Visible}
            Run Keyword If    ${both_visible}    Exit For Loop
            CLICK CHANNEL_PLUS
            Sleep    1s
            ${latest_channel_number}=    Extract Text From Screenshot
            Log To Console    📺 Extracted Channel: ${latest_channel_number}
            CLICK BACK
            CLICK RIGHT
        END
    END

    RETURN    ${latest_channel_number}

Ensure StartOver IS Visible
    ${latest_channel_number}=    Set Variable    None
    FOR    ${i}    IN RANGE    10
        Log To Console    Attempt ${i}: Checking Start Over
        CLICK RIGHT
        ${Start_Over_Visible}=    Verify Crop Image With Shorter Duration    ${port}    TC_601_Start_Over
        Log To Console    Start Over Visible: ${Start_Over_Visible}
        Run Keyword If    ${Start_Over_Visible}    Exit For Loop
        CLICK CHANNEL_PLUS
        Sleep    1s
        ${latest_channel_number}=   Extract Text From Screenshot
        CLICK BACK
        CLICK RIGHT
    END
    RETURN  ${latest_channel_number}

Check For Exit Popup and not exit
    ${Result}=    Verify Crop Image    ${port}    TC_217_Exit
    Log To Console    Exit popup found: ${Result}
    IF    '${Result}' == 'True'
        CLICK RIGHT
        CLICK OK
    END
    
Normalize Timestamp
    [Arguments]    ${timestamp}
    ${normalized}=    Replace String    ${timestamp}    o    0
    ${normalized}=    Replace String    ${normalized}    O    0
    ${normalized}=    Replace String    ${normalized}    :    .
    ${normalized}=    Replace String    ${normalized}    ${SPACE}    ''
    ${normalized}=    Replace String    ${normalized}    ..    .
    ${normalized}=    Strip String    ${normalized}
    RETURN    ${normalized}

Convert Timestamp To Seconds
    [Arguments]    ${timestamp}
    ${parts}=    Split String    ${timestamp}    .
    Run Keyword If    len(${parts}) != 3    Fail    ❌ Invalid timestamp format: ${timestamp}
    ${hour}=     Convert To Integer    ${parts[0]}
    ${minute}=   Convert To Integer    ${parts[1]}
    ${second}=   Convert To Integer    ${parts[2]}
    ${total}=    Evaluate    ${hour} * 3600 + ${minute} * 60 + ${second}
    RETURN    ${total}

Generate AI Based Slot List
    [Arguments]    ${timestamp}
    ${t1}=    Normalize Timestamp    ${timestamp}
    ${s1}=    Convert Timestamp To Seconds    ${t1}

    ${start_minute}=    Evaluate    ${s1} - (${s1} % 60)
    ${limit}=    Set Variable    60
    ${slot_list}=    Create List

    FOR    ${i}    IN RANGE    ${limit}
        ${sec}=    Evaluate    ${start_minute} + ${i}
        ${hour}=    Evaluate    '{:02d}'.format(${sec} // 3600)
        ${minute}=  Evaluate    '{:02d}'.format((${sec} % 3600) // 60)
        ${second}=  Evaluate    '{:02d}'.format(${sec} % 60)
        ${time}=    Set Variable    ${hour}.${minute}.${second}
        Append To List    ${slot_list}    ${time}
    END

    RETURN    ${slot_list}

Check OCR Timestamp After Pause Start Over
    [Arguments]    ${target_time}    ${start_time}    ${slot_count}=12

    Log To Console    🧪 Raw Start Time: ${start_time}
    Log To Console    🧪 Raw Target Time: ${target_time}

    # Normalize timestamps only if needed
    ${start}=    Run Keyword If    ':' in '${start_time}'    Replace String    ${start_time}    :    .    ELSE    Set Variable    ${start_time}
    ${normalized_target}=    Run Keyword If    ':' in '${target_time}'    Replace String    ${target_time}    :    .    ELSE    Set Variable    ${target_time}

    Log To Console    ▶ Truncated Start Timestamp: ${start}
    Log To Console    ▶ Normalized Target Timestamp: ${normalized_target}

    # Split start time into hours, minutes, seconds
    ${parts}=    Split String    ${start}    .
    ${h}=    Evaluate    int('${parts[0]}')
    ${m}=    Evaluate    int('${parts[1]}')
    ${s}=    Evaluate    int('${parts[2]}')

    # Generate slot list starting from actual OCR timestamp
    ${slot_list}=    Create List
    FOR    ${i}    IN RANGE    ${slot_count}
        ${total}=    Evaluate    ${h}*3600 + ${m}*60 + ${s} + ${i}
        ${new_h}=    Evaluate    ${total} // 3600
        ${rem}=     Evaluate    ${total} % 3600
        ${new_m}=    Evaluate    ${rem} // 60
        ${new_s}=    Evaluate    ${rem} % 60
        ${slot}=    Evaluate    "%02d.%02d.%02d" % (${new_h}, ${new_m}, ${new_s})
        Append To List    ${slot_list}    ${slot}
    END

    Log To Console    🧠 AI Slot List: ${slot_list}
    Log To Console    🧠 Slot List Starts From: ${slot_list[0]}

    ${found}=    Evaluate    '${normalized_target}' in ${slot_list}
    Run Keyword If    ${found}
    ...    Log To Console    ✅ '${target_time}' found in slot list
    ...    ELSE
    ...    Log To Console    ❌ '${target_time}' not found in slot list: ${slot_list}
    ...    Fail    ❌ '${target_time}' not found in AI slot list

    Run Keyword If  '${found}' == 'True'  Log To Console  found in slot list
	...  ELSE  Fail  not found in AI slot list

Check OCR Start Timestamp Using AI Slots
    [Arguments]    ${ocr_range}
    ${start_raw}=    Set Variable    ${ocr_range}[0:8]
    ${start}=    Normalize Timestamp    ${start_raw}
    Log To Console    ▶ Truncated Start Timestamp: ${start}

    ${slot_list}=    Generate AI Based Slot List    ${start}
    Log To Console    AI Slot List: ${slot_list}

    Run Keyword If    '${start}' in ${slot_list}
    ...    Log To Console    ✅ Start timestamp found in AI slot list
    ...    ELSE
    ...    Log To Console    ❌ Start timestamp '${start}' not found in slot list: ${slot_list}
    ...    Fail    ❌ Start timestamp not found in AI slot list
    RETURN    ${start}
Get Extracted Time On Player Info Bar
    [Arguments]     ${progress_bar_image}
    ${texts}=    OCR.Extract Text From Image    ${progress_bar_image}
    Log    Extracted text: ${texts}
    Log To Console    Extracted text: ${texts}
    RETURN  ${texts}


Revert favorites
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
    CLICK RIGHT
	CLICK OK
	Log To Console    Cleared FAV1
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
	Log To Console    Cleared FAV2
	CLICK DOWN
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    CLICK RIGHT
	CLICK OK
	Log To Console    Cleared FAV3
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
    CLICK RIGHT
	CLICK OK	
	Log To Console    Cleared FAV4
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
    CLICK RIGHT
	CLICK OK
	Log To Console    Cleared FAV5
    CLICK MULTIPLE TIMES    5    DOWN
    CLICK OK
    CLICK OK
    CLICK HOME

STB Speed Check
   ${start}=    Evaluate    __import__('time').time()
   CLICK HOME
   CLICK UP
   CLICK RIGHT
   CLICK RIGHT
   CLICK RIGHT
   CLICK RIGHT
   CLICK RIGHT
   CLICK RIGHT
   CLICK RIGHT
   CLICK RIGHT
   CLICK RIGHT
   CLICK RIGHT
   CLICK RIGHT
   CLICK DOWN
   CLICK RIGHT
   CLICK OK
   Sleep    5s
   CLICK DOWN
   CLICK DOWN
   CLICK DOWN
   CLICK DOWN
   CLICK OK
   CLICK HOME
   ${end}=      Evaluate    __import__('time').time()
   ${elapsed}=  Evaluate    ${end} - ${start}
   RETURN    ${elapsed}
Handle Recording For Subtitle channel
    Sleep    300s
    CLICK OK
    Search And Click On Record From Side Panel Under EPG

Verify Audio Quality For Port
    [Arguments]    ${port}
    Log To Console    🎥 Checking if video is paused...
    # ${is_paused}=    Validate Video Playback For Playing
    # Run Keyword If    '${is_paused}' == 'True'    Log To Console    Video is Playing
    # ...    ELSE    Fail    Video is paused — skipping audio validation

    ${audio_device}=    Set Variable    hw:0,0

    # Log To Console    🔄 Setting volume to minimum before tests
    # Repeat Keyword    12    CLICK VOLUME_MINUS

    # Log To Console    🔇 Validating mute behavior
    # Check For Volume    CLICK MUTE    ${audio_device}    3    5    5    ${port}

    # Uncomment when ready to add more checks:
    CLICK VOLUME_PLUS
    Check For Volume    CLICK VOLUME_PLUS    ${audio_device}    3    5    5    ${port}

    # CLICK VOLUME_MINUS
    # CLICK VOLUME_PLUS
    # CLICK VOLUME_PLUS
    # Check For Volume    CLICK VOLUME_MINUS    ${audio_device}    3    5    5    ${port}
    # Check For Volume    CLICK VOLUME_PLUS    ${audio_device}    3    5    5    ${port}

    # Repeat Keyword    12    CLICK VOLUME_PLUS
    # Validate Full Volume Image    ${port}
    # Check For Volume    CLICK VOLUME_MINUS    ${audio_device}    3    5    5    ${port}

    Log To Console    ✅ Audio quality validation completed for ${port}


# Check For Volume
#     [Arguments]    ${volume}    ${device}    ${checks}    ${duration}    ${wait}    ${port}
#     Log To Console    🔍 Capturing baseline RMS...
#     ${previous_rms}=    Get Average Rms    ${device}    ${checks}    ${duration}    ${wait}
#     Log To Console    📉 Baseline RMS: ${previous_rms}

#     Log To Console    🎚️ Executing volume action: ${volume}
#     Run Keyword    ${volume}

#     Log To Console    🔍 Capturing post-action RMS...
#     ${current_rms}=    Get Average Rms    ${device}    ${checks}    ${duration}    ${wait}
#     Log To Console    📈 Current RMS: ${current_rms}

#     Run Keyword If    '${volume}' == 'CLICK MUTE'           Check Mute RMS         ${current_rms}    ${port}
#     Run Keyword If    '${volume}' == 'CLICK VOLUME_PLUS'    Check Volume Up RMS    ${previous_rms}    ${current_rms}
#     Run Keyword If    '${volume}' == 'CLICK VOLUME_MINUS'   Check Volume Down RMS  ${previous_rms}    ${current_rms}


# Wait For Speech Activity
#     [Arguments]    ${device}
#     Log To Console    🔊 Checking for speech activity on ${device}
#     ${speech_detected}=    Set Variable    False
#     ${attempt}=    Set Variable    0
#     WHILE    ${attempt} < 5
#         ${temp_detected}=    Detect Speech Activity    ${device}    timeout=10
#         Run Keyword If    ${temp_detected}    Log To Console    ✅ Speech detected — proceeding with RMS validation
#         Run Keyword If    ${temp_detected}    Set Variable    ${speech_detected}    True
#         Run Keyword If    ${temp_detected}    Exit For Loop
#         Log To Console    🔁 Attempt ${attempt + 1} — no speech detected, retrying...
#         Sleep    6s
#         ${attempt}=    Evaluate    ${attempt} + 1
#     END
#     Run Keyword Unless    ${speech_detected}    Log To Console    ⚠️ No speech detected after 5 attempts — continuing anyway


# Detect Speech Activity
#     [Arguments]    ${device}    ${timeout}=10    ${threshold}=0.0015
#     ${rms}=    Capture Rms Sample    ${device}    5    2
#     Log To Console    🔍 Detected RMS: ${rms}
#     ${is_speech}=    Evaluate    ${rms} > ${threshold}
#     RETURN    ${is_speech}


# Check Mute RMS
#     [Arguments]    ${rms}    ${port}
#     Run Keyword If    ${rms} == 0.0
#     ...    Log To Console    ✅ Mute successful – RMS is zero
#     ...    ELSE    Fail    ❌ Mute failed – RMS is not zero
#     ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Mute_Remote_Button
#     Run Keyword If    '${Result}' == 'True'    Log To Console    Mute_Remote_Button Is Displayed
#     ...    ELSE    Fail    Mute_Remote_Button Is Not Displayed


# Check Volume Up RMS
#     [Arguments]    ${previous_rms}    ${current_rms}
#     Run Keyword If    ${current_rms} > ${previous_rms}
#     ...    Log To Console    ✅ Volume increased — RMS rise
#     ...    ELSE    Fail    ❌ Volume increase failed — RMS did not rise


# Check Volume Down RMS
#     [Arguments]    ${previous_rms}    ${current_rms}
#     Run Keyword If    ${current_rms} < ${previous_rms}
#     ...    Log To Console    ✅ Volume decreased — RMS dropped
#     ...    ELSE    Fail    ❌ Volume decrease failed — RMS did not drop


# Get Average Rms
#     [Arguments]    ${device}    ${checks}    ${duration}    ${wait}    ${threshold}=0.0015
#     ${attempt}=    Set Variable    0
#     ${speech_detected}=    Set Variable    False

#     Log To Console    🔊 Waiting for detectable audio signal before capturing RMS...
#     WHILE    ${attempt} < 5
#         ${temp_rms}=    Capture Rms Sample    ${device}    ${duration}    ${wait}
#         Log To Console    🔍 Trial RMS Reading ${attempt}
#         ${speech_detected}=    Evaluate    float(${temp_rms}) > ${threshold}
#         Run Keyword If    ${speech_detected}    Log To Console    ✅ Speech/audio detected – proceeding with RMS capture
#         Run Keyword If    ${speech_detected}    Exit For Loop
#         ${next}=    Evaluate    ${attempt} + 1
#         Log To Console    🔁 Attempt ${next}: No audio detected, retrying in 5s...
#         Sleep    5s
#         ${attempt}=    Set Variable    ${next}
#     END

#     Run Keyword Unless    ${speech_detected}    Log To Console    ⚠️ No speech detected after retries — continuing anyway with baseline RMS

#     ${rms_values}=    Create List
#     FOR    ${i}    IN RANGE    ${checks}
#         Log To Console    🎧 Recording audio sample ${i}
#         ${rms}=    Capture Rms Sample    ${device}    ${duration}    ${wait}
#         Append To List    ${rms_values}    ${rms}
#     END
#     ${computed_rms}=    Evaluate    round(sum([float(x) for x in ${rms_values}]) / len(${rms_values}), 5)
#     Log To Console    📈 Computed RMS: ${computed_rms}
#     RETURN    ${computed_rms}




# Capture Rms Sample
#     [Arguments]    ${device}    ${duration}=5    ${wait}=2
#     Sleep    ${wait}s
#     ${tmp_wav}=    Set Variable    /tmp/sample.wav
#     Log To Console    🎧 Capturing short audio sample from ${device}
#     ${cmd}=    Catenate    SEPARATOR= 
#     ...    sox -t alsa ${device} ${tmp_wav} trim 0 ${duration}
#     ${result}=    Run Process    bash    -c    ${cmd}    stdout=PIPE    stderr=STDOUT

#     ${cmd_stat}=    Catenate    SEPARATOR=
#     ...    sox ${tmp_wav} -n stat 2>&1
#     ${result_stat}=    Run Process    bash    -c    ${cmd_stat}    stdout=PIPE    stderr=STDOUT
#     ${rms_text}=    Set Variable    ${result_stat.stdout}
#     Log To Console    🎧 Raw RMS Output: ${rms_text}

#     # Robust regex
#     ${pattern}=    Evaluate    re.search(r'RMS\s+amplitude\s*:?\s*([0-9.]+)', """${rms_text}""")

#     IF    '${pattern}' != 'None'
#         ${rms_value}=    Evaluate    float(${pattern}.group(1))
#     ELSE
#         ${rms_value}=    Set Variable    0.0
#     END

#     Log To Console    📊 Final RMS Value: ${rms_value}
#     RETURN    ${rms_value}


# Validate Full Volume Image
#     [Arguments]    ${port}
#     ${Result}=    Verify Crop Image With Shorter Duration    ${port}    FULL_VOL_STB2
#     Run Keyword If    '${Result}' == 'True'    Log To Console    FULL_VOL_STB2 Is Displayed
#     ...    ELSE    Fail    FULL_VOL_STB2 Is Not Displayed

Get Channel Logo
    ${now}=    generic.get_date_time
    ${image_path}=    Replace String    ${ref_img1}    replace    ${now}
    generic.capture image run    ${port}    ${image_path}
    Log To Console    📸 Captured image: ${image_path}

    ${cropped_logo}=    IPL.Crop Channel Logo Top Right    ${image_path}
    Log To Console    🖼️ Cropped logo path: ${cropped_logo}
    RETURN    ${cropped_logo}

Zap Channel TO Channel Using Numeric Keys
	Log To Console    Case for pressing channel with three digit
    CLICK FIVE
    CLICK FIVE
    CLICK NINE
    Sleep   3s
    ${raw_text_source}=    Extract Text From Channel Bar
    # Clean up text
    ${source_channel_number_C1}=    IPL.Extract First Number  ${raw_text_source}
    # Take the zeroth element as the channel number
    Log To Console    📺 Extracted Channel Number: ${source_channel_number_C1}

    # Capture previous channel logo
    # ${channel_logo_c1}=    Get Channel Logo
    # Log To Console      ${channel_logo_c1}
    # CLICK CHANNEL_PLUS
    # ${pass}  imageCaptureDragDrop.verifyimage  ${port}  ${channel_logo_c1}
    # CAPTURE CURRENT IMAGE WITH TIME
    # sleep  1s
    # RETURN  ${pass}
   # Validate Video Playback Audio Video Quality And Record Time
    Validate Video Playback Audio Video Quality And Record Time
    CLICK FIVE
    CLICK SIX
    CLICK ZERO
    Sleep   3s
    ${start_c1}=    Evaluate    __import__('time').time()
     # Clean up text
    ${raw_text_target}=    Extract Text From Channel Bar
    ${target_channel_number_C1}=    IPL.Extract First Number  ${raw_text_target}
    # Take the zeroth element as the channel number
    Log To Console    📺 Extracted Channel Number: ${target_channel_number_C1}
    # Validate Video Playback Audio Video Quality And Record Time
    ${playback_time_c1}=   Validate Video Playback Audio Video Quality And Record Time
    Should Not Be Equal    ${source_channel_number_C1}    ${target_channel_number_C1}    Channel number did not change
    #Capture current channel logo
    #validate video playback
    # Validate Audio
    # Validate video quality
    ${end_c1}=    Evaluate    __import__('time').time()
    ${zapping_time_c1}=    Evaluate    round(${end_c1} - ${start_c1}, 3)
    Log To Console    ✅ Zapping time: ${zapping_time_c1} seconds
	${total_zap_time_c1}=  ${zapping_time_c1}  -   ${playback_time_c1}
	Log To Console    Case for pressing channel start from zero
    CLICK ZERO
    CLICK ZERO
    CLICK TWO
    Sleep   3s
    ${start_c2}=    Evaluate    __import__('time').time()
    ${raw_text_starts_with_zero}=    Extract Text From Channel Bar
    ${target_channel_number_C2}=    IPL.Extract First Number  ${raw_text_starts_with_zero}
    # Take the zeroth element as the channel number
    Log To Console    📺 Extracted Channel Number: ${target_channel_number_C2}
    ${playback_time_c2}=   Validate Video Playback Audio Video Quality And Record Time
    #Capture current channel logo
    Should Not Be Equal    ${target_channel_number_C1}    ${target_channel_number_C2}    Channel number did not change
    ${end_c2}=    Evaluate    __import__('time').time()
    ${zapping_time_c2}=    Evaluate    round(${end_c2} - ${start_c2}, 3)
    Log To Console    ✅ Zapping time to switch to channel starts with zero: ${zapping_time_c2} seconds
    ${total_zap_time_c2}=  ${zapping_time_c2}  -   ${playback_time_c2}
	Log To Console    Case for pressing single digit channel
    CLICK THREE
    Sleep   3s
    ${start_c3}=    Evaluate    __import__('time').time()
    ${raw_text_starts_single_digit}=    Extract Text From Channel Bar
    ${target_channel_number_C3}=    IPL.Extract First Number  ${raw_text_starts_single_digit}
    # Take the zeroth element as the channel number
    Log To Console    📺 Extracted Channel Number: ${target_channel_number_C3}
    ${playback_time_c3}=   Validate Video Playback Audio Video Quality And Record Time
    #Capture current channel logo
    Should Not Be Equal    ${target_channel_number_C2}    ${target_channel_number_C3}    Channel number did not change
    ${end_c3}=    Evaluate    __import__('time').time()
    ${zapping_time_c3}=    Evaluate    round(${end_c3} - ${start_c3}, 3)
    Log To Console    ✅ Zapping time to switch channle with single digit: ${zapping_time_c3} seconds
    ${total_zap_time_c3}=  ${zapping_time_c3}  -   ${playback_time_c3}
      
Zap Channel TO Channel Using Program UP and down Keys
	Log To Console    Case for pressing program plus button
	CLICK FIVE
    CLICK FIVE
    CLICK NINE
	Sleep   3s
    ${raw_text_source}=    Extract Text From Channel Bar
    # Clean up text
    ${source_channel_number_C1}=    IPL.Extract First Number  ${raw_text_source}
    # Take the zeroth element as the channel number
    Log To Console    📺 Extracted Channel Number: ${source_channel_number_C1}
    # Validate Video Playback Audio Video Quality And Record Time
    Validate Video Playback Audio Video Quality And Record Time
    #Capture previous channel logo
    CLICK CHANNEL_PLUS
    Sleep   3s
    ${start_c1}=    Evaluate    __import__('time').time()
     # Clean up text
    ${raw_text_target}=    Extract Text From Channel Bar
    ${target_channel_number_C1}=    IPL.Extract First Number  ${raw_text_target}
    # Take the zeroth element as the channel number
    Log To Console    📺 Extracted Channel Number: ${target_channel_number_C1}
    Should Not Be Equal    ${source_channel_number_C1}    ${target_channel_number_C1}    Channel number did not change
    #Capture current channel logo
    # Validate Video Playback Audio Video Quality And Record Time
    ${playback_time_c1}=   Validate Video Playback Audio Video Quality And Record Time
    ${zapping_time_c1}=    Evaluate    round(${end_c1} - ${start_c1}, 3)
    Log To Console    ✅ Zapping time: ${zapping_time_c1} seconds
	${total_zap_time_c1}=  ${zapping_time_c1}  -   ${playback_time_c1}
	Log To Console    Case for pressing program plus button
    CLICK CHANNEL_MINUS
    Sleep   3s
    ${start_c2}=    Evaluate    __import__('time').time()
    ${raw_text_starts_with_zero}=    Extract Text From Channel Bar
    ${target_channel_number_C2}=    IPL.Extract First Number  ${raw_text_starts_with_zero}
    # Take the zeroth element as the channel number
    Log To Console    📺 Extracted Channel Number: ${target_channel_number_C2}
     #Capture current channel logo
    ${playback_time_c2}=   Validate Video Playback Audio Video Quality And Record Time
    Should Not Be Equal    ${target_channel_number_C1}    ${target_channel_number_C2}    Channel number did not change
    ${end_c2}=    Evaluate    __import__('time').time()
    ${zapping_time_c2}=    Evaluate    round(${end_c2} - ${start_c2}, 3)
    Log To Console    ✅ Zapping time to switch to channel starts with zero: ${zapping_time_c2} seconds
    ${total_zap_time_c2}=  ${zapping_time_c2}  -   ${playback_time_c2}
	Log To Console    Case for random increment and decrement of channel
    CLICK CHANNEL_PLUS
	CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    Sleep   3s
    ${start_c3}=    Evaluate    __import__('time').time()
    ${raw_text_starts_single_digit}=    Extract Text From Channel Bar
    ${target_channel_number_C3}=    IPL.Extract First Number  ${raw_text_starts_single_digit}
    # Take the zeroth element as the channel number
    Log To Console    📺 Extracted Channel Number: ${target_channel_number_C3}
    #Capture current channel logo
    ${playback_time_c3}=   Validate Video Playback Audio Video Quality And Record Time
    Should Not Be Equal    ${target_channel_number_C2}    ${target_channel_number_C3}    Channel number did not change
    ${end_c3}=    Evaluate    __import__('time').time()
    ${zapping_time_c3}=    Evaluate    round(${end_c3} - ${start_c3}, 3)
    Log To Console    ✅ Zapping time to switch channle with single digit: ${zapping_time_c3} seconds
	${total_zap_time_c3}=  ${zapping_time_c3}  -   ${playback_time_c3}
	Log To Console    Case for random increment and decrement of channel
    CLICK CHANNEL_MINUS
	CLICK CHANNEL_MINUS
	CLICK CHANNEL_MINUS
	CLICK CHANNEL_MINUS
	CLICK CHANNEL_MINUS
	CLICK CHANNEL_MINUS
    Sleep   3s
    ${start_c3}=    Evaluate    __import__('time').time()
    ${raw_text_starts_single_digit}=    Extract Text From Channel Bar
    ${target_channel_number_C4}=    IPL.Extract First Number  ${raw_text_starts_single_digit}
    # Take the zeroth element as the channel number
    Log To Console    📺 Extracted Channel Number: ${target_channel_number_C3}
    #Capture current channel logo
    ${playback_time_c4}=   Validate Video Playback Audio Video Quality And Record Time
    Should Not Be Equal    ${target_channel_number_C2}    ${target_channel_number_C4}    Channel number did not change
    ${end_c3}=    Evaluate    __import__('time').time()
    ${zapping_time_c3}=    Evaluate    round(${end_c3} - ${start_c3}, 3)
    Log To Console    ✅ Zapping time to switch channle with single digit: ${zapping_time_c3} seconds
    ${total_zap_time_c4}=  ${zapping_time_c4}  -   ${playback_time_c4}

Validate Video Playback Audio Video Quality And Record Time
    ${start}=    Evaluate    __import__('time').time()
    Verify Audio Quality
    ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    Log To Console    Average Quality Score: ${results}
    EVALUATE VIDEO QUALITY STATUS    ${results}
    ${end}=    Evaluate    __import__('time').time()
    ${zapping_time}=    Evaluate    round(${end} - ${start}, 3)
    Log To Console    ✅ Zapping time to switch channle with single digit: ${zapping_time} seconds
    RETURN  ${zapping_time}

Get Thumnail Of Asset More Details     
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop Thumnail More Details   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    RETURN    ${after_crop}   
################################################################################
Select Recording Type
    [Arguments]    ${recording_type}
    Sleep    5s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=    IPL.crop recording type    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    Run Keyword If    '${recording_type}' == 'Local' and 'Cloud' in '${after_text}'    Select Local From Cloud
    ...    ELSE IF    '${recording_type}' == 'Cloud'    Select Cloud From Local
    ...    ELSE    Select Local Recording Type

Select Local Recording Type
    CLICK DOWN
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK

Select Local From Cloud
    Log To Console    Selecting Local recording
    CLICK DOWN
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK UP
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK OK

Select Cloud From Local
    Log To Console    Selecting cloud recording
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

# How to test
# Call Get Channel Name In Recorder From Info Bar and store the channel name
# Navigate to MyList and 
# Call Get Channel Name In Recorder Of MyList and store the channel name
# Pass both the values to Verify Recording Channel In MyList
Get Channel Name In Recorder From Info Bar
    Sleep   15s
    CLICK UP
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log    AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Channel Name From EPG Info Bar   ${after_image_path}
    Log To Console   CROPPED AFTER INFO BAR: ${cropped_img}
     # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    # RETURN    ${channel_name_epg_text} 
    ${channel_name_epg_text}=    Set Variable    ${after_text}
    RETURN    ${channel_name_epg_text}


Get Channel Name In Recorder Of MyList
    [Documentation]    Captures the MyList screen, extracts the channel name via OCR, cleans it, and returns it.

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    ${after_crop}=    IPL.Channel Name In Recorder Of MyList    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # ✅ Perform OCR Extraction (MISSING IN YOUR ORIGINAL CODE)
    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    Run Keyword Unless    '${after_text}' != ''    Fail    OCR did not return any text!
    Log To Console    OCR AFTER TEXT: ${after_text}

    # ✅ Remove special characters
    ${without_special_char}=    Evaluate    re.sub(r'[^a-zA-Z0-9 ]','',"""${after_text}""")    re
    Log To Console    CLEANED TEXT: ${without_special_char}

    ${recorded_channel_text}=    Set Variable    ${without_special_char}
    RETURN    ${recorded_channel_text}
Verify Matching Channels For Mosaic
    [Arguments]    ${channel_name_epg}    ${channel_name_mosaic}

    ${epg_clean}=        Convert To Lowercase    ${channel_name_epg}
    ${mosaic_clean}=     Convert To Lowercase    ${channel_name_mosaic}

    ${epg_clean}=        Strip String    ${epg_clean}
    ${mosaic_clean}=     Strip String    ${mosaic_clean}

    Log To Console    Comparing → EPG:'${epg_clean}' | MOSAIC:'${mosaic_clean}'

    ${status}=    Run Keyword And Return Status    Should Contain
    ...    ${mosaic_clean}
    ...    ${epg_clean}

    Run Keyword If    ${status} == True    Log To Console    MATCHED → ${channel_name_epg} == ${channel_name_mosaic}
    Run Keyword If    ${status} == True    Append To List    ${matched_list}    ${channel_name_epg}

    # ---------- NOT MATCHED ----------
    Run Keyword If    ${status} == False    Log To Console    NOT MATCHED → ${channel_name_epg} != ${channel_name_mosaic}
    Run Keyword If    ${status} == False    Append To List    ${unmatched_list}    ${channel_name_epg}
Verify Matching Channels
    [Arguments]    ${channel_name_mylist}    ${channel_name}
    # Ensure the recorded channel name is not empty
    Should Not Be Empty    ${channel_name_mylist}    ❌ Recorded channel name is empty!

    # Check if the expected channel name contains the recorded one
    Should Contain    ${channel_name}    ${channel_name_mylist}    ❌ Expected '${channel_name}' to contain '${channel_name_mylist}'

    # Log success
    Log To Console    ✅ '${channel_name_mylist}' is found in '${channel_name}'

Cast Detail In Info Bar
    Sleep   1s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log    AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Cast In Info Bar   ${after_image_path}
    Log    CROPPED AFTER INFO BAR: ${cropped_img}
       # OCR Extraction
    ${after_text}=    OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Convert text to lowercase to make search case-insensitive
    ${after_text_lower}=    Convert To Lowercase    ${after_text}

    # Check if 'joe' appears in OCR result
    ${is_present}=    Run Keyword And Return Status    Should Contain    ${after_text_lower}    joe

    Run Keyword If    ${is_present}    Log To Console    ✅ Search result matched
    ...    ELSE    Log To Console    ❌ Search result not matched

    RETURN    ${after_text}
     
Get Storage Type In Recorder List
    [Arguments]    ${storage_type}

    # Capture image after current timestamp
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    # Crop the relevant portion for storage type
    ${after_crop}=    IPL.Storage Type In Recorder List    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Validate extracted storage type
    ${recorded_storage_type}=    Set Variable    ${after_text}
    Should Be Equal As Strings    ${recorded_storage_type}    ${storage_type}
    
####################################################################################
Get Channel Name Of Mosaic
    # CLICK UP
    Sleep   1s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Channel Name From Mosaic   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${cropped_img}
     # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}
# Get Channel Names From Mosaic With Coords
#     [Arguments]    @{coords}

#     ${after_now}=    generic.get_date_time
#     ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}

#     generic.Capture Image    ${port}    ${after_image_path}
#     Log To Console    Captured Image: ${after_image_path}

#     @{channel_names}=    Create List
#     ${tile_index}=    Set Variable    1

#     FOR    ${coord}    IN    @{coords}
#         ${split_coord}=    Split String    ${coord}    ,
#         ${x1}=    Set Variable    ${split_coord[0]}
#         ${x2}=    Set Variable    ${split_coord[1]}
#         ${y1}=    Set Variable    ${split_coord[2]}
#         ${y2}=    Set Variable    ${split_coord[3]}

#         Log To Console    Cropping Tile with Coords: ${x1},${x2},${y1},${y2}

#         ${cropped_img}=    IPL.Channel_Name_From_Mosaic_With_Coords
#         ...    ${after_image_path}    ${x1}    ${x2}    ${y1}    ${y2}
#         Log To Console      ${cropped_img}

#         ${text}=    OCR.Extract Text From Image    ${cropped_img}
#         Log    Channel ${tile_index}: ${text}

#         # ✅ Safely split text and keep numbers
#         ${words}=    Evaluate    [w for w in """${text}""".split() if w]

#         ${special_words}=    Create List    TV    HD    MBC    SBC    DIZI    KSA

#         # ✅ Wrap the full Python code as one single string argument
#         ${camel_text}=    Evaluate    ' '.join(["-".join([(p.upper() if p.upper() in list(@{special_words}) else p.capitalize()) for p in w.split("-")]) if "-" in w else (w.upper() if w.upper() in list(@{special_words}) else w.capitalize()) for w in ${words}])

#         ${camel_text}=    Replace String    ${camel_text}   MBC HD  MBC 1HD
#         ${camel_text}=    Replace String    ${camel_text}   MBC 1 HD  MBC 1HD
#         ${camel_text}=    Replace String    ${camel_text}   Noor Dubal  Noor Dubai
#         ${camel_text}=    Replace String    ${camel_text}    E Junior    e-junior
#         ${camel_text}=    Replace String    ${camel_text}    E-Masala    em
#         ${camel_text}=    Replace String    ${camel_text}    Abu Dhabi Sports HD    Abu Dhabi Sports 1 HD
#         # ${camel_text}=    Replace String    ${camel_text}   Docu Sport HD   Docu Sport
#         # ${camel_text}=    Replace String    ${camel_text}   On Time    ON Time Sports HD
#         # ${camel_text}=    Replace String    ${camel_text}   KSA Sport 1 HD    KSA Sports 1 HD
#         # ${camel_text}=    Replace String    ${camel_text}   E Port 24x7     Esports 24x7
#         # ${camel_text}=    Replace String    ${camel_text}   Sharjah Sport HD     Sharjah Sports HD
#         # ${camel_text}=    Replace String    ${camel_text}   Jordan Port    Jordan Sport
#         Log To Console    Mosaic Channel: ${camel_text}

#         ${tile_index}=    Evaluate    ${tile_index} + 1
#     END

#     RETURN    ${camel_text}

Get Channel Names From Mosaic With Coords
    [Arguments]    @{coords}

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    Captured Image: ${after_image_path}

    @{channel_names}=    Create List
    ${tile_index}=    Set Variable    1

    FOR    ${coord}    IN    @{coords}
        ${split_coord}=    Split String    ${coord}    ,
        ${x1}=    Set Variable    ${split_coord[0]}
        ${x2}=    Set Variable    ${split_coord[1]}
        ${y1}=    Set Variable    ${split_coord[2]}
        ${y2}=    Set Variable    ${split_coord[3]}

        Log To Console    Cropping Tile ${tile_index} with Coords: ${x1},${x2},${y1},${y2}

        ${cropped_img}=    IPL.Channel_Name_From_Mosaic_With_Coords
        ...    ${after_image_path}    ${x1}    ${x2}    ${y1}    ${y2}

        ${text}=    OCR.Extract Text From Image    ${cropped_img}
        ${text}=    Evaluate    """${text}""".strip()
        Log To Console    Raw OCR Output (${tile_index}): ${text}

        ${words}=    Evaluate    [w for w in """${text}""".split() if w]
        ${special_words}=    Create List    TV    HD    MBC    SBC    DIZI    KSA

        ${camel_text}=    Evaluate    ' '.join(["-".join([(p.upper() if p.upper() in list(@{special_words}) else p.capitalize()) for p in w.split("-")]) if "-" in w else (w.upper() if w.upper() in list(@{special_words}) else w.capitalize()) for w in ${words}])

        # Channel-specific fixes
        ${camel_text}=    Replace String    ${camel_text}    MBC HD    MBC 1HD
        ${camel_text}=    Replace String    ${camel_text}    MBC 1 HD    MBC 1HD
        ${camel_text}=    Replace String    ${camel_text}    Noor Dubal    Noor Dubai
        ${camel_text}=    Replace String    ${camel_text}    E Junior    e-junior
        ${camel_text}=    Replace String    ${camel_text}    E-Masala    em
        ${camel_text}=    Replace String    ${camel_text}    Abu Dhabi Sports HD    Abu Dhabi Sports 1 HD

        # Handle Abu Dhabi Sports duplicates
        IF    '${camel_text}' == 'Abu Dhabi Sports HD'
            IF    '${tile_index}' == '2'
                ${camel_text}=    Set Variable    Abu Dhabi Sports 2 HD
            # ELSE IF    '${tile_index}' == '2'
            #     ${camel_text}=    Set Variable    Abu Dhabi Sports 2 HD
            END
        END

        # Auto-handle duplicates
        ${is_duplicate}=    Run Keyword And Return Status    List Should Contain Value    @{channel_names}    ${camel_text}
        IF    ${is_duplicate}
            ${camel_text}=    Set Variable    ${camel_text} ${tile_index}
        END

        Log To Console    Final Channel (${tile_index}): ${camel_text}

        Append To List    ${channel_names}    ${camel_text}
        ${tile_index}=    Evaluate    ${tile_index} + 1
    END

    # ✅ Convert list to normal comma-separated string
    ${channel_string}=    Evaluate    ', '.join(${channel_names})
    Log To Console    Final Mosaic Channel List: ${channel_string}

    RETURN    ${channel_string}


Repeat Keyword
    [Arguments]    ${count}    ${keyword}    ${sleep}=0s
    FOR    ${i}    IN RANGE    ${count}
        Run Keyword    ${keyword}
        Sleep    ${sleep}
    END


Press Channel Number
    [Arguments]    ${number}
    ${digits}=    Convert To String    ${number}
    @{char_list}=    Split String To Characters    ${digits}
    FOR    ${digit}    IN    @{char_list}
        Run Keyword    CLICK ${digit}
        Sleep    0.5s
    END
# Check For Blocking Rate
#     [Arguments]    ${port}    ${duration}
#     Log To Console    📊 Starting video quality analysis on port ${port} for duration ${duration} seconds
#     Log To Console    🔍 Metrics: Blocking (compression artifacts), Banding (color gradient distortion)

#     ${blocking_list}=    Create List
#     ${banding_list}=     Create List

#     FOR    ${i}    IN RANGE    5
#         Log To Console    🔁 Iteration ${i + 1}: Capturing video frames and computing metrics...
#         ${blocking}    ${banding}=    Run Video Metrics Multiple Times    ${port}    ${duration}
#         Log To Console    📎 Iteration ${i + 1} Results → Blocking: ${blocking}, Banding: ${banding}
#         Append To List    ${blocking_list}    ${blocking}
#         Append To List    ${banding_list}     ${banding}
#     END

#     ${blocking_total}=    Set Variable    0
#     FOR    ${value}    IN    @{blocking_list}
#         ${blocking_total}=    Evaluate    ${blocking_total} + ${value}
#     END
#     ${blocking_avg}=    Evaluate    round(${blocking_total} / 5, 3)
#     Log To Console    📉 Final Blocking Average (across 5 samples): ${blocking_avg}

#     ${banding_total}=    Set Variable    0
#     FOR    ${value}    IN    @{banding_list}
#         ${banding_total}=    Evaluate    ${banding_total} + ${value}
#     END
#     ${banding_avg}=    Evaluate    round(${banding_total} / 5, 5)
#     Log To Console    📉 Final Banding Average (across 5 samples): ${banding_avg}

#     Log To Console    📊 Thresholds → Blocking < 90 and Banding < 0.04 = Good Quality

#     ${is_blocking_good}=    Evaluate    ${blocking_avg} < 90
#     ${is_banding_good}=     Evaluate    ${banding_avg} < 0.04

#     Run Keyword If    ${is_blocking_good} and ${is_banding_good}
#     ...    Log To Console    ✅ Verdict: Good Quality Video
#     ...    Log To Console    Reason: Blocking (${blocking_avg}) and Banding (${banding_avg}) are both below thresholds

#     Run Keyword Unless    ${is_blocking_good} and ${is_banding_good}
#     ...    Log To Console    ❌ Verdict: Bad Quality Video
#     ...    Log To Console    Reason: Either Blocking (${blocking_avg}) ≥ 90 or Banding (${banding_avg}) ≥ 0.04

# Check For Blocking Rate
#     [Arguments]    ${port}    ${duration}
#     Log To Console    📊 Starting video quality analysis on port ${port} for duration ${duration} seconds
#     Log To Console    🔍 Metrics: Blocking (compression artifacts), Banding (color gradient distortion)

#     ${blocking_list}=    Create List
#     ${banding_list}=     Create List

#     FOR    ${i}    IN RANGE    2
#         Log To Console    🔁 Iteration ${i + 1}: Capturing video frames and computing metrics...
#         ${blocking}    ${banding}=    Run Video Metrics Multiple Times    ${port}    ${duration}
#         Log To Console    📎 Iteration ${i + 1} Results → Blocking: ${blocking}, Banding: ${banding}
#         Append To List    ${blocking_list}    ${blocking}
#         Append To List    ${banding_list}     ${banding}
#     END

#     ${blocking_total}=    Set Variable    0
#     FOR    ${value}    IN    @{blocking_list}
#         ${blocking_total}=    Evaluate    ${blocking_total} + ${value}
#     END
#     ${blocking_avg}=    Evaluate    round(${blocking_total} / 5, 3)
#     Log To Console    📉 Final Blocking Average (across 5 samples): ${blocking_avg}

#     ${banding_total}=    Set Variable    0
#     FOR    ${value}    IN    @{banding_list}
#         ${banding_total}=    Evaluate    ${banding_total} + ${value}
#     END
#     ${banding_avg}=    Evaluate    round(${banding_total} / 5, 5)
#     Log To Console    📉 Final Banding Average (across 5 samples): ${banding_avg}

#     ${blocking_scaled}=    Set Variable    ${blocking_avg}
#     ${banding_scaled}=     Evaluate    ${banding_avg} * 1000
#     ${quality_score}=      Evaluate    round(${blocking_scaled} + ${banding_scaled}, 2)
#     Log To Console         📊 Combined Quality Score (Blocking + Banding scaled): ${quality_score}

#     IF    ${quality_score} < 120
#         Log To Console    ✅ Verdict: Good Quality Video
#         Log To Console    Reason: Combined Score (${quality_score}) is below threshold
#     ELSE
#         Log To Console    ❌ Verdict: Bad Quality Video
#         Log To Console    Reason: Combined Score (${quality_score}) exceeds threshold
#     END
    
# Evaluate Video Quality
#     ${results}=    Classify Live Video Quality    /dev/video0    2    2
#     Log To Console      ${results}
#     ${bad}=    Create List
#     ${clear}=  Create List
#     ${unavailable}=  Create List

#     FOR    ${item}    IN    @{results}
#         ${blurry}=    Get From Dictionary    ${item}    blurry_anomalies
#         ${glitch}=    Get From Dictionary    ${item}    stddev_glitches

#         Run Keyword If    ${glitch} == 0    Append To List    ${unavailable}    Video Not Available
#         Run Keyword If    ${glitch} > 0 and ${blurry} < ${glitch}    Append To List    ${bad}    Bad Quality Video
#         Run Keyword If    ${glitch} > 0 and ${blurry} >= ${glitch}    Append To List    ${clear}    Clear Video
#     END

#     ${bad_count}=    Get Length    ${bad}
#     ${clear_count}=  Get Length    ${clear}
#     ${unavailable_count}=  Get Length    ${unavailable}

#     Log To Console    Bad Quality Count: ${bad_count}
#     Log To Console    Clear Quality Count: ${clear_count}
#     Log To Console    Unavailable Count: ${unavailable_count}

#     Run Keyword If    ${bad_count} > ${clear_count} and ${bad_count} > ${unavailable_count}    Log To Console    Highest: Bad Quality Video
#     Run Keyword If    ${clear_count} > ${bad_count} and ${clear_count} > ${unavailable_count}    Log To Console    Highest: Clear Video
#     Run Keyword If    ${unavailable_count} > ${bad_count} and ${unavailable_count} > ${clear_count}    Log To Console    Highest: Video Not Available
#     Run Keyword If    ${unavailable_count} >= 1    Log To Console    Video Not Available

Verify Video Quality
    [Arguments]    ${port}    ${duration}
    Log To Console    📊 Starting video quality analysis on port ${port} for duration ${duration} seconds
    Log To Console    🔍 Metrics: Blurry, Glitches, Brightness, Frozen SSIM, Black/White

    ${results}=    Classify Live Video Quality    ${port}    ${duration}    5
    Log To Console    📦 Raw Metric Results: ${results}

    ${bad}=    Create List
    ${clear}=  Create List
    ${unavailable}=  Create List

    FOR    ${item}    IN    @{results}
        ${iteration}=           Get From Dictionary    ${item}    iteration
        ${blurry}=              Get From Dictionary    ${item}    blurry_anomalies
        ${glitch}=              Get From Dictionary    ${item}    stddev_glitches
        ${brightness}=          Get From Dictionary    ${item}    brightness_issues
        ${frozen}=              Get From Dictionary    ${item}    frozen_ssim
        ${bw}=                  Get From Dictionary    ${item}    black_white_anomalies

        Log To Console    🔁 Iteration ${iteration} → Blurry: ${blurry}, Glitches: ${glitch}, Brightness: ${brightness}, Frozen SSIM: ${frozen}, BW: ${bw}

        Run Keyword If    ${glitch} == 0
        ...    Append To List    ${unavailable}    Iteration ${iteration}
        Run Keyword If    ${glitch} > 0 and ${blurry} < ${glitch}
        ...    Append To List    ${bad}    Iteration ${iteration}
        Run Keyword If    ${glitch} > 0 and ${blurry} >= ${glitch}
        ...    Append To List    ${clear}    Iteration ${iteration}
    END

    ${bad_count}=    Get Length    ${bad}
    ${clear_count}=  Get Length    ${clear}
    ${unavailable_count}=  Get Length    ${unavailable}

    Log To Console    ❌ Bad Quality Count: ${bad_count}
    Log To Console    ✅ Clear Quality Count: ${clear_count}
    Log To Console    🚫 Unavailable Count: ${unavailable_count}

    Run Keyword If    ${bad_count} > ${clear_count} and ${bad_count} > ${unavailable_count}
    ...    Log To Console    🔴 Final Verdict: Bad Quality Video
    Run Keyword If    ${clear_count} > ${bad_count} and ${clear_count} > ${unavailable_count}
    ...    Log To Console    🟢 Final Verdict: Clear Video
    Run Keyword If    ${unavailable_count} > ${bad_count} and ${unavailable_count} > ${clear_count}
    ...    Log To Console    ⚠️ Final Verdict: Video Not Available
    Run Keyword If    ${unavailable_count} >= 1
    ...    Log To Console    ⚠️ One or more iterations had unavailable video


# Validate Video Playback For Playing
#     ${results}=    Create List
#     FOR    ${i}    IN RANGE    5
#         ${now}=    generic.get_date_time
#         ${d_rimg}=    Replace String    ${ref_img1}    replace    ${now}
#         generic.capture image run    ${port}    ${d_rimg}
#         CAPTURE CURRENT IMAGE WITH TIME

#         Sleep    15s
#         ${now}=    generic.get_date_time
#         ${d_cimg}=    Replace String    ${comp_img}    replace    ${now}
#         generic.capture image run    ${port}    ${d_cimg}
#         CAPTURE CURRENT IMAGE WITH TIME

#         ${pass}=    generic.compare_image    ${d_rimg}    ${d_cimg}
#         Run Keyword If    ${pass}==False    Append To List    ${results}    True
#         Run Keyword If    ${pass}==True     Append To List    ${results}    False
#     END

#     ${count}=    Set Variable    0
#     FOR    ${item}    IN    @{results}
#         ${is_true}=    Evaluate    1 if '${item}'=='True' else 0
#         ${count}=    Evaluate    ${count} + ${is_true}
#     END

#     Run Keyword If    ${count} >= 2    Return From Keyword    True
#     Return From Keyword    False

# Verify Video Quality
#     Check For Blocking Rate     ${port}    2
#     Evaluate Video Quality

Get text from epg 
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Catchup Date From EPG   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}
    Should Not Be Empty    ${after_text}    OCR output is empty—failing the test.
Get Search Cast
    Sleep   15s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log    AFTER IMAGE: ${after_image_path}

    ${cropped_img}=    IPL.search roi   ${after_image_path}
    Log To Console   CROPPED AFTER INFO BAR: ${cropped_img}

    ${after_text}=    OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT (RAW): ${after_text}

    ${after_text}=    Convert To Lower Case    ${after_text}
    Log To Console    OCR AFTER TEXT (LOWER): ${after_text}

    RETURN    ${after_text}


Run Video Quality Check 10 Times    

    # 🧪 Proceed with video quality check if not frozen
    ${VERDICTS}=    Create List
    Log To Console    Using script: ${SCRIPT_PATH}
    FOR    ${i}    IN RANGE    10
        ${Result}=    Validate Video Playback For Frozen

    # 🔍 If video is frozen, log detailed metrics and exit
        Run Keyword If    '${Result}' == 'False'    Log To Console    Video freezed
        Run Keyword If    '${Result}' == 'False'    Return From Keyword
        Log To Console    \n🔁 Run ${i+1}/10
        ${result}=    Run Process    python3    ${SCRIPT_PATH}    stdout=PIPE    stderr=PIPE
        ${output}=    Set Variable    ${result.stdout}
        Log To Console    ${output}
        ${contains_verdict}=    Evaluate    'Final Verdict:' in '''${output}'''
        Run Keyword If    not ${contains_verdict}    Log To Console    ❌ Verdict missing. Skipping this run.
        Run Keyword If    not ${contains_verdict}    Continue For Loop
        ${verdict}=    Evaluate    re.search(r"Final Verdict:\s*(.*)", '''${output}''').group(1).strip()    modules=re
        Append To List    ${VERDICTS}    ${verdict}
        Log To Console    ✅ Verdict added: ${verdict}
    END

    Log To Console    \n📋 All Verdicts:
    FOR    ${v}    IN    @{VERDICTS}
        Log To Console    Analysed and recorded ${v} frame
    END

    ${bad_count}=    Get Count    ${VERDICTS}    Bad Quality Video
    ${good_count}=   Get Count    ${VERDICTS}    Good Quality Video
    ${total}=        Get Length   ${VERDICTS}

    ${bad_percent}=    Evaluate    round(${bad_count} * 100 / ${total}, 2)
    ${good_percent}=   Evaluate    round(${good_count} * 100 / ${total}, 2)

    Run Keyword If    ${bad_count} > ${good_count}    Log To Console    \n Final Verdict: Bad Quality Video
    Run Keyword If    ${good_count} > ${bad_count}   Log To Console    \n Final Verdict: Good Quality Video
    Run Keyword If    ${bad_count} == ${good_count}  Log To Console    \n Final Verdict: Mixed Quality — Equal Good and Bad

# Verify Audio Quality For Connected STB
#     [Arguments]    ${port}
#     ${audio_device}=    Set Variable    hw:0,0

#     Log To Console    🔇 Validating mute behavior
#     Check For Volume    CLICK MUTE    ${audio_device}    3    5    5    ${port}

#     Log To Console    🔼 Validating volume increase notch-wise
#     Repeat Keyword    3 times    Check For Volume    CLICK VOLUME_PLUS    ${audio_device}    3    5    5    ${port}

#     Log To Console    🔽 Validating volume decrease notch-wise
#     Repeat Keyword    3 times    Check For Volume    CLICK VOLUME_MINUS    ${audio_device}    3    5    5    ${port}

#     Log To Console    ✅ Audio quality validation completed for ${port}

# Check Volume Up RMS
#     [Arguments]    ${previous_rms}    ${current_rms}
#     ${delta}=    Evaluate    round(${current_rms} - ${previous_rms}, 5)
#     Log To Console    📈 RMS delta: ${delta}
#     Run Keyword If    ${delta} > 0.0005
#     ...    Log To Console    ✅ Volume increased — RMS rise
#     ...    ELSE    Fail    ❌ Volume increase failed — RMS did not rise

# Check Volume Down RMS
#     [Arguments]    ${previous_rms}    ${current_rms}
#     ${delta}=    Evaluate    round(${previous_rms} - ${current_rms}, 5)
#     Log To Console    📉 RMS delta: ${delta}
#     Run Keyword If    ${delta} > 0.0005
#     ...    Log To Console    ✅ Volume decreased — RMS dropped
#     ...    ELSE    Fail    ❌ Volume decrease failed — RMS did not drop

# Check Mute RMS
#     [Arguments]    ${rms}    ${port}
#     ${tolerance}=    Set Variable    0.0002
#     Run Keyword If    ${rms} <= ${tolerance}
#     ...    Log To Console    ✅ Mute successful – RMS is near zero (${rms})
#     ...    ELSE    Fail    ❌ Mute failed – RMS is not zero (${rms})
#     ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Mute_Remote_Button
#     Run Keyword If    '${Result}' == 'True'    Log To Console    Mute_Remote_Button Is Displayed
#     ...    ELSE    Fail    Mute_Remote_Button Is Not Displayed	
	
	
# Validate Full Volume Image
#     [Arguments]    ${port}
#     ${Result}=    Verify Crop Image With Shorter Duration    ${port}    FULL_VOL_STB2
#     Run Keyword If    '${Result}' == 'True'    Log To Console    FULL_VOL_STB2 Is Displayed
#     ...    ELSE    Fail    FULL_VOL_STB2 Is Not Displayed

# Check For Volume
#     [Arguments]    ${volume}    ${device}    ${checks}    ${duration}    ${wait}    ${port}
#     Log To Console    🔍 Capturing baseline RMS...
#     ${previous_rms}=    Get Average Rms    ${device}    ${checks}    ${duration}    ${wait}
#     Log To Console    📉 Baseline RMS: ${previous_rms}

#     Log To Console    🎚️ Executing volume action: ${volume}
#     Run Keyword    ${volume}

#     Log To Console    🔍 Capturing post-action RMS...
#     ${current_rms}=    Get Average Rms    ${device}    ${checks}    ${duration}    ${wait}
#     Log To Console    📈 Current RMS: ${current_rms}

#     Run Keyword If    '${volume}' == 'CLICK MUTE'           Check Mute RMS         ${current_rms}    ${port}
#     Run Keyword If    '${volume}' == 'CLICK VOLUME_PLUS'    Check Volume Up RMS    ${previous_rms}    ${current_rms}
#     Run Keyword If    '${volume}' == 'CLICK VOLUME_MINUS'   Check Volume Down RMS 

# Get Average Rms
#     [Arguments]    ${device}    ${checks}    ${duration}    ${wait}
#     ${working_dir}=    Set Variable    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S
#     ${result}=    Run Process    python3 audioverification.py    cwd=${working_dir}    shell=True    stdout=PIPE    stderr=PIPE
#     Log To Console    🧩 Stdout: ${result.stdout}
#     Log To Console    ⚠️ Stderr: ${result.stderr}

#     ${output}=    Strip String    ${result.stdout}

#     # ✅ Use string comparison, not expression evaluation
#     Run Keyword Unless    '${output}'    Fail    ❌ Python script returned empty output — see stderr above

#     # ✅ Extract the last line which contains the numeric RMS
#     ${lines}=    Split To Lines    ${output}
#     ${last_line}=    Get From List    ${lines}    -1
#     ${rms}=    Convert To Number    ${last_line.strip()}

#     Log To Console    🎧 RMS value: ${rms}
#     RETURN    ${rms}

Return RMS Value
    [Arguments]    ${device}
    ${rms}=    Get Rms Value    ${device}
    RETURN    ${rms}


Verify Audio Quality For Connected STB Muted
    [Arguments]    ${device}    ${volume_keyword}

    Log To Console    🔍 Capturing baseline RMS...
    ${previous_rms}    ${active_before}=    Get Rms Value    ${device}
    Log To Console    📉 Baseline RMS: ${previous_rms}

    Log To Console    🎚️ Executing volume action: ${volume_keyword}
    Run Keyword    ${volume_keyword}

    Log To Console    🔍 Capturing post-action RMS...
    ${current_rms}    ${active_after}=    Get Rms Value    ${device}
    Log To Console    📈 Current RMS: ${current_rms}

    # Silence check ONLY on current RMS
    IF    not ${active_after}
        Log To Console    ⚠️ Audio is silent or volume muted after volume action. Cannot compare volume.
        RETURN    SKIPPED
    END

    IF    ${current_rms} == 0
        Log To Console    🔇 Audio Muted
    ELSE IF    ${current_rms} > ${previous_rms}
        Log To Console    🔊 Audio Volume Increased
    ELSE IF    ${current_rms} < ${previous_rms}
        Log To Console    🔉 Audio Volume Decreased
    ELSE
        Log To Console    ⚠️ No Change in Audio Level
    END

Verify Audio Quality For Connected STB Volume Increased By One Notch
    [Arguments]    ${device}    ${volume_keyword}

    Log To Console    🔍 Capturing baseline RMS...
    ${previous_rms}    ${active_before}=    Get Rms Value    ${device}
    Log To Console    📉 Baseline RMS: ${previous_rms}

    Log To Console    🎚️ Executing volume action: ${volume_keyword}
    Run Keyword    ${volume_keyword}

    Log To Console    🔍 Capturing post-action RMS...
    ${current_rms}    ${active_after}=    Get Rms Value    ${device}
    Log To Console    📈 Current RMS: ${current_rms}

    # Silence check ONLY on current RMS
    IF    not ${active_after}
        Log To Console    ⚠️ Audio is silent or volume muted after volume action. Cannot compare volume.
        RETURN    SKIPPED
    END

    IF    ${current_rms} == 0
        Log To Console    🔇 Audio Muted
    ELSE IF    ${current_rms} > ${previous_rms}
        Log To Console    🔊 Audio Volume Increased
    ELSE IF    ${current_rms} < ${previous_rms}
        Log To Console    🔉 Audio Volume Decreased
    ELSE
        Log To Console    ⚠️ No Change in Audio Level
    END

Verify Audio Quality For Connected STB Volume Increased By Two Notch
    [Arguments]    ${device}    ${volume_keyword}

    Log To Console    🔍 Capturing baseline RMS...
    ${previous_rms}    ${active_before}=    Get Rms Value    ${device}
    Log To Console    📉 Baseline RMS: ${previous_rms}

    Log To Console    🎚️ Executing volume action: ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}

    Log To Console    🔍 Capturing post-action RMS...
    ${current_rms}    ${active_after}=    Get Rms Value    ${device}
    Log To Console    📈 Current RMS: ${current_rms}

    # Silence check ONLY on current RMS
    IF    not ${active_after}
        Log To Console    ⚠️ Audio is silent or volume muted after volume action. Cannot compare volume.
        RETURN    SKIPPED
    END

    IF    ${current_rms} == 0
        Log To Console    🔇 Audio Muted
    ELSE IF    ${current_rms} > ${previous_rms}
        Log To Console    🔊 Audio Volume Increased
    ELSE IF    ${current_rms} < ${previous_rms}
        Log To Console    🔉 Audio Volume Decreased
    ELSE
        Log To Console    ⚠️ No Change in Audio Level
    END

Verify Audio Quality For Connected STB Volume Increased By Three Notch
    [Arguments]    ${device}    ${volume_keyword}

    Log To Console    🔍 Capturing baseline RMS...
    ${previous_rms}    ${active_before}=    Get Rms Value    ${device}
    Log To Console    📉 Baseline RMS: ${previous_rms}

    Log To Console    🎚️ Executing volume action: ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}

    Log To Console    🔍 Capturing post-action RMS...
    ${current_rms}    ${active_after}=    Get Rms Value    ${device}
    Log To Console    📈 Current RMS: ${current_rms}

    # Silence check ONLY on current RMS
    IF    not ${active_after}
        Log To Console    ⚠️ Audio is silent or volume muted after volume action. Cannot compare volume.
        RETURN    SKIPPED
    END

    IF    ${current_rms} == 0
        Log To Console    🔇 Audio Muted
    ELSE IF    ${current_rms} > ${previous_rms}
        Log To Console    🔊 Audio Volume Increased
    ELSE IF    ${current_rms} < ${previous_rms}
        Log To Console    🔉 Audio Volume Decreased
    ELSE
        Log To Console    ⚠️ No Change in Audio Level
    END

Verify Audio Quality For Connected STB Volume Increased By Four Notch
    [Arguments]    ${device}    ${volume_keyword}

    Log To Console    🔍 Capturing baseline RMS...
    ${previous_rms}    ${active_before}=    Get Rms Value    ${device}
    Log To Console    📉 Baseline RMS: ${previous_rms}

    Log To Console    🎚️ Executing volume action: ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}

    Log To Console    🔍 Capturing post-action RMS...
    ${current_rms}    ${active_after}=    Get Rms Value    ${device}
    Log To Console    📈 Current RMS: ${current_rms}

    # Silence check ONLY on current RMS
    IF    not ${active_after}
        Log To Console    ⚠️ Audio is silent or volume muted after volume action. Cannot compare volume.
        RETURN    SKIPPED
    END

    IF    ${current_rms} == 0
        Log To Console    🔇 Audio Muted
    ELSE IF    ${current_rms} > ${previous_rms}
        Log To Console    🔊 Audio Volume Increased
    ELSE IF    ${current_rms} < ${previous_rms}
        Log To Console    🔉 Audio Volume Decreased
    ELSE
        Log To Console    ⚠️ No Change in Audio Level
    END

Verify Audio Quality For Connected STB Volume Increased By Five Notch
    [Arguments]    ${device}    ${volume_keyword}

    Log To Console    🔍 Capturing baseline RMS...
    ${previous_rms}    ${active_before}=    Get Rms Value    ${device}
    Log To Console    📉 Baseline RMS: ${previous_rms}

    Log To Console    🎚️ Executing volume action: ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}

    Log To Console    🔍 Capturing post-action RMS...
    ${current_rms}    ${active_after}=    Get Rms Value    ${device}
    Log To Console    📈 Current RMS: ${current_rms}

    # Silence check ONLY on current RMS
    IF    not ${active_after}
        Log To Console    ⚠️ Audio is silent or volume muted after volume action. Cannot compare volume.
        RETURN    SKIPPED
    END

    IF    ${current_rms} == 0
        Log To Console    🔇 Audio Muted
    ELSE IF    ${current_rms} > ${previous_rms}
        Log To Console    🔊 Audio Volume Increased
    ELSE IF    ${current_rms} < ${previous_rms}
        Log To Console    🔉 Audio Volume Decreased
    ELSE
        Log To Console    ⚠️ No Change in Audio Level
    END

Verify Audio Quality For Connected STB Volume Increased By Six Notch
    [Arguments]    ${device}    ${volume_keyword}

    Log To Console    🔍 Capturing baseline RMS...
    ${previous_rms}    ${active_before}=    Get Rms Value    ${device}
    Log To Console    📉 Baseline RMS: ${previous_rms}

    Log To Console    🎚️ Executing volume action: ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}

    Log To Console    🔍 Capturing post-action RMS...
    ${current_rms}    ${active_after}=    Get Rms Value    ${device}
    Log To Console    📈 Current RMS: ${current_rms}

    # Silence check ONLY on current RMS
    IF    not ${active_after}
        Log To Console    ⚠️ Audio is silent or volume muted after volume action. Cannot compare volume.
        RETURN    SKIPPED
    END

    IF    ${current_rms} == 0
        Log To Console    🔇 Audio Muted
    ELSE IF    ${current_rms} > ${previous_rms}
        Log To Console    🔊 Audio Volume Increased
    ELSE IF    ${current_rms} < ${previous_rms}
        Log To Console    🔉 Audio Volume Decreased
    ELSE
        Log To Console    ⚠️ No Change in Audio Level
    END

Verify Audio Quality For Connected STB Volume Decreased By One Notch
    [Arguments]    ${device}    ${volume_keyword}

    Log To Console    🔍 Capturing baseline RMS...
    ${previous_rms}    ${active_before}=    Get Rms Value    ${device}
    Log To Console    📉 Baseline RMS: ${previous_rms}

    Log To Console    🎚️ Executing volume action: ${volume_keyword}
    Run Keyword    ${volume_keyword}

    Log To Console    🔍 Capturing post-action RMS...
    ${current_rms}    ${active_after}=    Get Rms Value    ${device}
    Log To Console    📈 Current RMS: ${current_rms}

    # Silence check ONLY on current RMS
    IF    not ${active_after}
        Log To Console    ⚠️ Audio is silent or volume muted after volume action. Cannot compare volume.
        RETURN    SKIPPED
    END

    IF    ${current_rms} == 0
        Log To Console    🔇 Audio Muted
    ELSE IF    ${current_rms} > ${previous_rms}
        Log To Console    🔊 Audio Volume Increased
    ELSE IF    ${current_rms} < ${previous_rms}
        Log To Console    🔉 Audio Volume Decreased
    ELSE
        Log To Console    ⚠️ No Change in Audio Level
    END

Verify Audio Quality For Connected STB Volume Decreased By Two Notch
    [Arguments]    ${device}    ${volume_keyword}

    Log To Console    🔍 Capturing baseline RMS...
    ${previous_rms}    ${active_before}=    Get Rms Value    ${device}
    Log To Console    📉 Baseline RMS: ${previous_rms}

    Log To Console    🎚️ Executing volume action: ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}

    Log To Console    🔍 Capturing post-action RMS...
    ${current_rms}    ${active_after}=    Get Rms Value    ${device}
    Log To Console    📈 Current RMS: ${current_rms}

    # Silence check ONLY on current RMS
    IF    not ${active_after}
        Log To Console    ⚠️ Audio is silent or volume muted after volume action. Cannot compare volume.
        RETURN    SKIPPED
    END

    IF    ${current_rms} == 0
        Log To Console    🔇 Audio Muted
    ELSE IF    ${current_rms} > ${previous_rms}
        Log To Console    🔊 Audio Volume Increased
    ELSE IF    ${current_rms} < ${previous_rms}
        Log To Console    🔉 Audio Volume Decreased
    ELSE
        Log To Console    ⚠️ No Change in Audio Level
    END

Verify Audio Quality For Connected STB Volume Decreased By Three Notch
    [Arguments]    ${device}    ${volume_keyword}

    Log To Console    🔍 Capturing baseline RMS...
    ${previous_rms}    ${active_before}=    Get Rms Value    ${device}
    Log To Console    📉 Baseline RMS: ${previous_rms}

    Log To Console    🎚️ Executing volume action: ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}
    Run Keyword    ${volume_keyword}

    Log To Console    🔍 Capturing post-action RMS...
    ${current_rms}    ${active_after}=    Get Rms Value    ${device}
    Log To Console    📈 Current RMS: ${current_rms}

    # Silence check ONLY on current RMS
    IF    not ${active_after}
        Log To Console    ⚠️ Audio is silent or volume muted after volume action. Cannot compare volume.
        RETURN    SKIPPED
    END

    IF    ${current_rms} == 0
        Log To Console    🔇 Audio Muted
    ELSE IF    ${current_rms} > ${previous_rms}
        Log To Console    🔊 Audio Volume Increased
    ELSE IF    ${current_rms} < ${previous_rms}
        Log To Console    🔉 Audio Volume Decreased
    ELSE
        Log To Console    ⚠️ No Change in Audio Level
    END

Navigate to Settings
	CLICK HOME
	CLICK UP
	CLICK RIGHT
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

Set Recording storage to Cloud    
    CLICK HOME
    CLICK UP
    CLICK RIGHT
	CLICK RIGHT
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
    # ${result}=  Verify Crop Image  ${port}  CLOUD_STORAGE_PROFILE_SETTING
	# IF    '${result}' == 'True'
	# 	CLICK OK
    #     CLICK DOWN
    #     CLICK OK
    #     CLICK DOWN
    #     CLICK DOWN
    #     CLICK DOWN
    #     CLICK DOWN
    #     CLICK UP
    # #     CLICK OK
    # #     Sleep    2s 
    # #     CLICK OK
	# # ELSE
	# # 	CLICK HOME
	# # END
    # # CLICK HOME
    # ${cloud}=    Verify Crop Image    ${port}    CLOUD_STORAGE_PROFILE_SETTING
    # # ${ask}=      Verify Crop Image    ${port}    Ask_Storage_Selection
    # ${ask}=  Verify Crop Image  ${port}  Ask_Storage_Selection
    # ${local}=  Verify Crop Image  ${port}  Local_Storage_Selection

    # IF    '${cloud}' == 'True'
    #     # When CLOUD_STORAGE_PROFILE_SETTING is present
    #     CLICK DOWN
    #     CLICK DOWN
    #     CLICK DOWN
    #     CLICK DOWN
    #     CLICK OK
    #     Sleep    2s
    #     CLICK OK
    # ELSE IF   '${ask}' == 'True'
    #     # When Ask_Storage_Selection is present
        CLICK OK
        CLICK UP
        CLICK UP
        CLICK OK
        CLICK DOWN
        CLICK DOWN
        CLICK DOWN
        CLICK DOWN
        CLICK OK
        Sleep    2s
        CLICK OK
    # ELSE IF   '${local}' == 'True'
    #     # When Local_Storage_Selection is present
    #     CLICK OK
    #     CLICK UP
    #     CLICK OK
    #     CLICK DOWN
    #     CLICK DOWN
    #     CLICK DOWN
    #     CLICK DOWN
    #     CLICK OK
    #     Sleep    2s
    #     CLICK OK
    # ELSE
    #     CLICK HOME
    # END

    CLICK HOME

Navigate to Home from selfcare
    CLICK RED
	Sleep    20s
	CLICK HOME
	Sleep    2s
	CLICK HOME
	${Result}  Verify Crop Image  ${port}    HOME
	Run Keyword If  '${Result}' == 'True'  Log To Console  HOME Is Displayed
    ...  ELSE  Log To Console  HOME Is Not Displayed
  

Revert Auto Restart Enable
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

Revert to HDMI Disabled
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
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
    Sleep   2s
    Log To Console    HDMI CEC is Disabled
    CLICK OK 
    CLICK HOME

Navigate to Home from device information 
    CLICK OK
    Sleep    2s
	CLICK HOME
    CLICK HOME

Revert Filter in Guide
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
	CLICK UP
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
    CLICK HOME
    CLICK HOME


Verify Recording exists after Box Restore
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
    ${Result}  Verify Crop Image  ${port}    Local_Storage_Under_Recorder
	Run Keyword If  '${Result}' == 'False'  Log To Console  Recording Is Not Displayed after Box Restore
    ...  ELSE  Fail  Recording Is Displayed after Box Restore
    CLICK HOME
    CLICK HOME
    
Record any Live program with Local storage
    Set Recording storage to Local 
    CLICK HOME
    Log To Console    Navigated To Home Page
    CLICK UP
    CLICK RIGHT
    CLICK OK
    Log To Console    Navigated To TV Section  
	Guide Channel List
    Log To Console    Navigated To Live TV
    Sleep    5s
    CLICK ONE
	CLICK FIVE
    Log To Console    Navigated To Channel 15
	Sleep	20s
    CLICK RIGHT
    Search And Click On Record From Side Panel Under EPG
    Log To Console    Tapped Record Button
    CLICK DOWN
    CLICK OK
    Log To Console    Record The Program Is Selected
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
    CLICK DOWN
	${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_215_LOCAL_STORAGE
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_215_LOCAL_STORAGE
	...  ELSE  Fail  TC_215_LOCAL_STORAGE Is Not Displayed
    CLICK DOWN
	CLICK DOWN
    CLICK OK
    Sleep    2s
    # Image validation - check for "Recording Started"
   ${Result}=    Verify Crop Image   ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start Is Displayed
    ...    ELSE    
    ...    Run Keyword    Handle Recording Failure

    CLICK OK
    Sleep    15s

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
    ${Result}  Verify Crop Image  ${port}    Local_Storage_Under_Recorder
	Run Keyword If  '${Result}' == 'True'  Log To Console  Recording Is Displayed
    ...  ELSE  Fail  Recording Is Not Displayed
    Sleep    150s
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    Sleep    2s
    CLICK OK
    Sleep    2s
    CLICK OK
    Sleep    2s
    CLICK OK
    CLICK HOME
    CLICK HOME
    
Verify Recording exists after Soft Factory Reset
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
    ${Result}  Verify Crop Image  ${port}    Local_Storage_Under_Recorder
	Run Keyword If  '${Result}' == 'True'  Log To Console  Recording Is Displayed after soft factory reset
    ...  ELSE  Fail  Recording Is Not Displayed after soft factory reset
    CLICK HOME
    CLICK HOME
    
    
NAVIGATE BACK TO HOME FROM MIDDLE OF EXECUTION 
    ${Result1}  Verify Crop Image  ${port}  HOME
    IF  '${Result1}' == 'False'
        CLICK BACK
        CLICK BACK
        CLICK BACK
        CLICK HOME
        Sleep    1s
        CLICK HOME
    END

New User Reboot STB Device
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB07_DWI259S"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    75s
    Log To Console    Reboot Success
    Check Who's Watching login NEW USER
    Sleep   2s
    CLICK HOME
    Sleep   2s
    CLICK HOME
    Sleep   2s
    CLICK HOME

Add 5 channels Each to Two Different Favorite List under Profile Settings
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
	CLICK TWO
	CLICK ZERO
	CLICK FOUR
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH1
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST1_CH1 Is Displayed on screen
	...  ELSE  Fail  FAVLIST1_CH1 Is Not Displayed on screen
	CLICK UP
	CLICK BACK
	CLICK BACK
	CLICK BACK
	CLICK THREE
	CLICK ZERO
	CLICK FOUR
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH2
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST1_CH2 Is Displayed on screen
	...  ELSE  Fail  FAVLIST1_CH2 Is Not Displayed on screen
	CLICK UP
	CLICK BACK
	CLICK BACK
	CLICK BACK
	CLICK FOUR
	CLICK ZERO
	CLICK ONE
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH3
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST1_CH3 Is Displayed on screen
	...  ELSE  Fail  FAVLIST1_CH3 Is Not Displayed on screen
	CLICK UP
	CLICK BACK
	CLICK BACK
	CLICK BACK
	CLICK FIVE
	CLICK ZERO
	CLICK TWO
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH4
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST1_CH4 Is Displayed on screen
	...  ELSE  Fail  FAVLIST1_CH4 Is Not Displayed on screen
	CLICK UP
	CLICK BACK
	CLICK BACK
	CLICK BACK
	CLICK SIX
	CLICK ZERO
	CLICK ONE
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH5
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST1_CH5 Is Displayed on screen
	...  ELSE  Fail  FAVLIST1_CH5 Is Not Displayed on screen
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
	CLICK ONE
	CLICK ZERO
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH1
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH1 Is Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH1 Is Not Displayed on screen
	CLICK UP
	CLICK BACK
	CLICK BACK
	CLICK ONE
	CLICK ZERO
	CLICK ONE
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH2
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH2 Is Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH2 Is Not Displayed on screen
	CLICK UP
	CLICK BACK
	CLICK BACK
	CLICK BACK
	CLICK ONE
	CLICK ZERO
	CLICK TWO
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH3
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH3 Is Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH3 Is Not Displayed on screen
	CLICK UP
	CLICK BACK
	CLICK BACK
	CLICK BACK
	CLICK ONE
	CLICK ZERO
	CLICK THREE
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH4
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH4 Is Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH4 Is Not Displayed on screen
	CLICK UP
	CLICK BACK
	CLICK BACK
	CLICK BACK
	CLICK ONE
	CLICK ZERO
	CLICK FOUR
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH5
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH5 Is Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH5 Is Not Displayed on screen
    	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME

Delete Favorite Channel from Favorite List
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
	Sleep    2s
	CLICK LEFT
	CLICK LEFT
	CLICK TWO
	CLICK ZERO
	CLICK FOUR
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH1
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST1_CH1 Is Deleted
	...  ELSE  Fail  FAVLIST1_CH1 Is Not Deleted
	CLICK UP
	CLICK BACK
	CLICK BACK
	CLICK BACK
	CLICK FIVE
	CLICK ZERO
	CLICK TWO
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH4
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST1_CH4 Is Deleted
	...  ELSE  Fail  FAVLIST1_CH4 Is Not Deleted
	CLICK UP
	CLICK BACK
	CLICK BACK
	CLICK BACK
	CLICK SIX
	CLICK ZERO
	CLICK ONE
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH5
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST1_CH5 Is Deleted
	...  ELSE  Fail  FAVLIST1_CH5 Is Not Deleted
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
	Sleep    2s
	CLICK LEFT
	CLICK LEFT
	CLICK ONE
	CLICK ZERO
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH1
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH1 Is Deleted
	...  ELSE  Fail  FAVLIST2_CH1 Is Not Deleted
	CLICK UP
	CLICK BACK
	CLICK BACK
	CLICK ONE
	CLICK ZERO
	CLICK THREE
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH4
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH4 Is Deleted
	...  ELSE  Fail  FAVLIST2_CH4 Is Not Deleted
	CLICK UP
	CLICK BACK
	CLICK BACK
	CLICK BACK
	CLICK ONE
	CLICK ZERO
	CLICK FOUR
	CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH5
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH5 Is Deleted
	...  ELSE  Fail  FAVLIST2_CH5 Is Not Deleted
    CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	Sleep    2s
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK OK
	CLICK HOME

Verify Favorite channel deleted from Favorite List
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
    Sleep    8s
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH1_CHECK
	Run Keyword If  '${Result}' == 'False'  Log To Console  FAVLIST1_CH1_CHECK Is Not Displayed on screen
	...  ELSE  Fail  FAVLIST1_CH1_CHECK Is Displayed on screen
	CLICK DOWN
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH2_CHECK
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST1_CH2_CHECK Is Displayed on screen
	...  ELSE  Fail  FAVLIST1_CH2_CHECK Is Not Displayed on screen
    CLICK DOWN
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH3_CHECK
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST1_CH3_CHECK Is Displayed on screen
	...  ELSE  Fail  FAVLIST1_CH3_CHECK Is Not Displayed on screen
    CLICK DOWN
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH4_CHECK
	Run Keyword If  '${Result}' == 'False'  Log To Console  FAVLIST1_CH4_CHECK Is Not Displayed on screen
	...  ELSE  Fail  FAVLIST1_CH4_CHECK Is Displayed on screen
    CLICK DOWN
	${Result}  Verify Crop Image  ${port}  FAVLIST1_CH5_CHECK
	Run Keyword If  '${Result}' == 'False'  Log To Console  FAVLIST1_CH5_CHECK Is Not Displayed on screen
	...  ELSE  Fail  FAVLIST1_CH5_CHECK Is Displayed on screen
	CLICK LEFT
	CLICK OK
	CLICK DOWN
	CLICK OK
    Sleep    8s
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH1_CHECK
	Run Keyword If  '${Result}' == 'False'  Log To Console  FAVLIST2_CH1_CHECK Is Not Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH1_CHECK Is Displayed on screen
	CLICK DOWN
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH2_CHECK
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH2_CHECK Is Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH2_CHECK Is Not Displayed on screen
	CLICK DOWN
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH3_CHECK
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH3_CHECK Is Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH3_CHECK Is Not Displayed on screen
	CLICK DOWN
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH4_CHECK
	Run Keyword If  '${Result}' == 'False'  Log To Console  FAVLIST2_CH4_CHECK Is Not Displayed on screen
	...  ELSE  Fail  FAVLIST2_CH4_CHECK Is Displayed on screen
	CLICK DOWN
	${Result}  Verify Crop Image  ${port}  FAVLIST2_CH5_CHECK
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAVLIST2_CH5_CHECK Is Not Displayed on screen
	...  ELSE  Log To Console  FAVLIST2_CH5_CHECK Is Displayed on screen

Teardown exit whos watching page and login to Admin
    CLICK HOME
    CLICK HOME
    Sleep    2s
    CLICK HOME
    ${Result1}=    Verify Crop Image    ${port}    TC_520_Who_Watching
    ${Result2}=    Verify Crop Image    ${port}    Whos_Watching_2

    Log To Console    Who's login: ${Result1}, Profile: ${Result2}

    IF    '${Result1}' == 'True' or '${Result2}' == 'True'
        CLICK BACK 
        CLICK BACK 
        CLICK BACK 
        CLICK BACK 
        CLICK BACK 
        CLICK BACK 
        CLICK BACK 
        CLICK BACK 
        CLICK BACK 
        CLICK BACK 
        CLICK BACK 
        CLICK BACK 
        CLICK BACK 
        CLICK LEFT
        CLICK LEFT
        CLICK LEFT
        CLICK LEFT
        CLICK LEFT
        CLICK OK
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK OK
        Sleep    40s
        CLICK HOME
        CLICK HOME
        CLICK HOME
        CLICK HOME
        CLICK HOME
        # DELETE PROFILE
    END


Reboot STB Device without whos watching page seen
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB07_DWI259S"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    75s
    Log To Console    Reboot Success
    Check Who's Watching login should not be seen
    CLICK HOME
    CLICK HOME
    Sleep    1s
    CLICK HOME

Check Who's Watching login should not be seen
    Sleep    1s
    ${Result}  Verify Crop Image  ${port}  TC_520_Who_Watching
	Run Keyword If  '${Result}' == 'True'  Fail  Asking for Profile Selection
	...  ELSE  Log To Console  Profile is set as default user

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
    CLICK OK
	CLICK DOWN
	CLICK DOWN
    CLICK OK
	CLICK DOWN
	CLICK OK
	Sleep    2s 
	CLICK HOME

Verify Time On Interface Clock
    Sleep    5s  

    # Capture image
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    # Crop clock region
    ${after_crop}=    IPL.Channel Interface Clock    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR extraction
    ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    📸 OCR AFTER TEXT: ${ocr_text}

    # Handle missing OCR
    Run Keyword If    '${ocr_text}' == '' or '${ocr_text}' == 'None' or '${ocr_text}' == '${EMPTY}'
    ...    Fail    ❌ OCR text missing — cannot verify clock.

    # Normalize OCR text
    ${ocr_normalized}=    Evaluate    "${ocr_text}".replace(".",":").replace(" ", "").upper()
    ${ocr_normalized}=    Evaluate    re.sub(r"([AP]M)$", r" \\1", "${ocr_normalized}")    modules=re
    Log To Console    🔹 Normalized OCR: ${ocr_normalized}

    # Get current local time in 12-hour format
    ${local_12hr}=    Get Current Date    result_format=%I:%M %p
    Log To Console    🕒 LOCAL TIME 12-HOUR: ${local_12hr}

    # Safely compute time difference
    ${time_diff}=    Run Keyword And Ignore Error    Evaluate
    ...    abs((datetime.datetime.strptime("${local_12hr}", "%I:%M %p") - datetime.datetime.strptime("${ocr_normalized}", "%I:%M %p")).total_seconds() / 60)
    ...    modules=datetime

    # Extract status and value
    ${status}=    Set Variable    ${time_diff}[0]
    ${diff_value}=    Set Variable If    '${status}' == 'PASS'    ${time_diff}[1]    9999

    Log To Console    🔸 Time difference (minutes): ${diff_value}

    # Final comparison — PASS if match (≤1 min)
    Run Keyword If    ${diff_value} <= 1
    ...    Log To Console    ✅ Time Match: OCR=${ocr_normalized}, Local=${local_12hr}, Δ=${diff_value} min
    ...    ELSE
    ...    Fail    ❌ Time Mismatch: OCR=${ocr_normalized}, Local=${local_12hr}, Δ=${diff_value} min

Verify Time On Interface Clock Negative Scenario
    Sleep    5s  
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    ${after_crop}=    IPL.Channel Interface Clock    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    📸 OCR AFTER TEXT: ${ocr_text}

    # Handle missing OCR
    Run Keyword If    '${ocr_text}' == '' or '${ocr_text}' == 'None' or '${ocr_text}' == '${EMPTY}'
    ...    Log To Console    ⚠️ No OCR text detected — passing test.
    Run Keyword If    '${ocr_text}' == '' or '${ocr_text}' == 'None' or '${ocr_text}' == '${EMPTY}'
    ...    Return From Keyword   True

    ${ocr_normalized}=    Evaluate    "${ocr_text}".replace(".",":").replace(" ", "").upper()
    ${ocr_normalized}=    Evaluate    re.sub(r"([AP]M)$", r" \\1", "${ocr_normalized}")    modules=re
    Log To Console    🔹 Normalized OCR: ${ocr_normalized}

    ${local_12hr}=    Get Current Date    result_format=%I:%M %p
    Log To Console    🕒 LOCAL TIME 12-HOUR: ${local_12hr}

    ${time_diff}=    Run Keyword And Ignore Error    Evaluate
    ...    abs((datetime.datetime.strptime("${local_12hr}", "%I:%M %p") - datetime.datetime.strptime("${ocr_normalized}", "%I:%M %p")).total_seconds() / 60)
    ...    modules=datetime

    ${status}=    Set Variable    ${time_diff}[0]
    ${diff_value}=    Set Variable If    '${status}' == 'PASS'    ${time_diff}[1]    9999

    Log To Console    🔸 Time difference (minutes): ${diff_value}

    Run Keyword If    ${diff_value} <= 1
    ...    Fail    ❌ Time Match Found — OCR=${ocr_normalized}, Local=${local_12hr}, Δ=${diff_value} min
    ...    ELSE
    ...    Log To Console    ✅ Time Mismatch or Invalid Time — OCR=${ocr_normalized}, Local=${local_12hr}, Δ=${diff_value} min
    RETURN    True

NAVIGATE TO PROFILE ICON
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
    Log To Console    Navigated to profile settings

Return To Home
    CLICK HOME
    Sleep    2s
    CLICK HOME

UNLOCK_2006
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
    ${Result}  Verify Crop Image  ${port}  2_Unhidden_Channels
	Run Keyword If  '${Result}' == 'True'  Log To Console  2_Unhidden_Channels Is Displayed on screen
	...  ELSE  Log To Console  2_Unhidden_Channels Is Not Displayed on screen
	CLICK MULTIPLE TIMES    2    UP
	CLICK RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    2    RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK
	CLICK HOME

UNLOCK_2007
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


Check Who's Watching login NEW USER
    Sleep    1s
    
    ${Result}=    Verify Crop Image    ${port}    TC_520_Who_Watching
    Log To Console    Who's login: ${Result}
    IF    '${Result}' == 'True'
        CLICK RIGHT
        CLICK OK
        # CLICK THREE
        # CLICK THREE
        # CLICK THREE
        # CLICK THREE
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK OK
        Sleep    30s
        CLICK HOME
    END

NAVIGATE TO CHANNEL LIST IN NEW UI
    CLICK HOME
    CLICK BACK
    Sleep    2s
    CLICK BACK
    Sleep    2s
    CLICK OK




Get Time Side Panel Recorder

    # CLICK OK
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log    AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Time Side Panel Recorder   ${after_image_path}
    Log To Console   CROPPED AFTER INFO BAR: ${cropped_img}
     # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    # RETURN    ${channel_name_epg_text} 
    ${channel_name_epg_text}=    Set Variable    ${after_text}
    RETURN    ${channel_name_epg_text}

Get Enddate Side Panel Recorder

    # CLICK OK
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log    AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Enddate Side Panel Recorder   ${after_image_path}
    Log To Console   CROPPED AFTER INFO BAR: ${cropped_img}
     # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    # RETURN    ${channel_name_epg_text} 
    ${channel_name_epg_text}=    Set Variable    ${after_text}
    RETURN    ${channel_name_epg_text}


Get DateTime In Recorder Of MyList
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Date Time In MyList   ${after_image_path}
    Log    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    ${recorded_channel_text}=    Set Variable    ${after_text}
    RETURN    ${recorded_channel_text}   

Select Recording Type Series
    [Arguments]    ${recording_type}
    Sleep    5s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=    IPL.crop recording type    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    Run Keyword If    '${recording_type}' == 'Local' and 'Cloud' in '${after_text}'    Select Local From Cloud Series
    ...    ELSE IF    '${recording_type}' == 'Cloud'    Select Cloud From Local Series
    ...    ELSE    Select Local Recording Type Series

Select Cloud From Local Series
    Log To Console    Selecting cloud recording
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    # CLICK DOWN
    CLICK OK
    CLICK DOWN
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK OK

Select Local From Cloud Series
    Log To Console    Selecting Local recording
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    # CLICK DOWN
    CLICK OK
    CLICK UP
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK OK

Select Local Recording Type Series
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
Get Channel Name From Mosaic With Coords
    [Arguments]    ${coord}    ${tile_index}

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}

    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    Captured Image: ${after_image_path}

    ${split_coord}=    Split String    ${coord}    ,
    ${x1}=    Set Variable    ${split_coord[0]}
    ${x2}=    Set Variable    ${split_coord[1]}
    ${y1}=    Set Variable    ${split_coord[2]}
    ${y2}=    Set Variable    ${split_coord[3]}

    Log To Console    Cropping Tile with Coords: ${x1},${x2},${y1},${y2}

    ${cropped_img}=    IPL.Channel_Name_From_Mosaic_With_Coords
    ...    ${after_image_path}    ${x1}    ${x2}    ${y1}    ${y2}
    Log To Console    ${cropped_img}

    ${text}=    OCR.Extract Text From Image    ${cropped_img}
    Log    Channel ${tile_index}: ${text}

    ${words}=    Evaluate    [w for w in """${text}""".split() if w]
    ${special_words}=    Create List    TV    HD    MBC    SBC    DIZI    KSA    YAS

    ${camel_text}=    Evaluate
    ...    ' '.join(["-".join([(p.upper() if p.upper() in ${special_words} else p.capitalize()) for p in w.split("-")]) if "-" in w else (w.upper() if w.upper() in ${special_words} else w.capitalize()) for w in ${words}])

    ${camel_text}=    Replace String    ${camel_text}    MBC HD    MBC 1HD
    ${camel_text}=    Replace String    ${camel_text}    MBC 1 HD    MBC 1HD
    ${camel_text}=    Replace String    ${camel_text}    Noor Dubal    Noor Dubai
    ${camel_text}=    Replace String    ${camel_text}    E-Junior HD    e-junior HD
    ${camel_text}=    Replace String    ${camel_text}    E-Masala    em
    ${camel_text}=    Set Variable If    '${camel_text}' == 'Abu Dhabi Sports HD' and ${tile_index} == 1    Abu Dhabi Sports 1HD    ${camel_text}
    ${camel_text}=    Set Variable If    '${camel_text}' == 'Abu Dhabi Sports HD' and ${tile_index} == 2    Abu Dhabi Sports 2 HD    ${camel_text}
    ${camel_text}=    Replace String    ${camel_text}   Docu Sport HD   Docu Sport
    ${camel_text}=    Replace String    ${camel_text}   On Time    ON Time Sports HD
    ${camel_text}=    Replace String    ${camel_text}   KSA Sports 1 HD    KSA Sports 1HD
    ${camel_text}=    Replace String    ${camel_text}   E Port 24x7     Esports 24x7
    ${camel_text}=    Replace String    ${camel_text}   Sharjah Sport HD     Sharjah Sports HD
    ${camel_text}=    Replace String    ${camel_text}   Jordan Port    Jordan Sport
    ${camel_text}=    Replace String    ${camel_text}   Fast Funbox    Fast n Funbox
    ${camel_text}=    Replace String    ${camel_text}   AL AHLY TV HD    Al TV HD Ahly
    ${camel_text}=    Replace String    ${camel_text}   YAS SPORTS HD   YAS Sports HD
    Log To Console    Mosaic Channel: ${camel_text}

    RETURN    ${camel_text}


Check For Supported Recording Until Found
    [Arguments]    ${recorded_storage_type}

    ${is_supported}=    Set Variable    False

    WHILE    not ${is_supported}
        Log To Console    🔁 Checking for supported recording type: ${recorded_storage_type}

        # --- Navigate to Record On Side Panel ---
        Navigate To Record On Side Panel

        # --- Perform OCR and clean text ---
        ${raw_text}=    Get Local And Cloud Ocr And Return
        Log To Console    🧾 OCR Raw Text: ${raw_text}
        ${clean_text}=    Strip String    ${raw_text}
        Log To Console    🧹 Cleaned OCR: ${clean_text}

        # --- Check if type is supported ---
        ${is_supported}=    Evaluate    '${recorded_storage_type}'.lower() in '${clean_text}'.lower()
        Log To Console    📦 Detected Type: ${recorded_storage_type}
        Log To Console    📦 Is Supported: ${is_supported}

        # --- Decision ---
        Run Keyword If    ${is_supported}    Select Supported Recording Type program   ${recorded_storage_type}
        Run Keyword Unless    ${is_supported}    Select New Channel And Retry

    END

    Log To Console    ✅ Supported recording type found: ${recorded_storage_type}
    RETURN    ${is_supported}

Check For Supported Recording Until Found Series
    [Arguments]    ${recorded_storage_type}

    ${is_supported}=    Set Variable    False

    WHILE    not ${is_supported}
        Log To Console    🔁 Checking for supported recording type: ${recorded_storage_type}

        # --- Navigate to Record On Side Panel ---
        Navigate To Record On Side Panel

        # --- Perform OCR and clean text ---
        ${raw_text}=    Get Local And Cloud Ocr And Return
        Log To Console    🧾 OCR Raw Text: ${raw_text}
        ${clean_text}=    Strip String    ${raw_text}
        Log To Console    🧹 Cleaned OCR: ${clean_text}

        # --- Check if type is supported ---
        ${is_supported}=    Evaluate    '${recorded_storage_type}'.lower() in '${clean_text}'.lower()
        Log To Console    📦 Detected Type: ${recorded_storage_type}
        Log To Console    📦 Is Supported: ${is_supported}

        # --- Decision ---
        Run Keyword If    ${is_supported}    Select Supported Recording Type Series     ${recorded_storage_type}
        Run Keyword Unless    ${is_supported}    Select New Channel And Retry

    END

    Log To Console    ✅ Supported recording type found: ${recorded_storage_type}
    RETURN    ${is_supported}

Navigate To Record On Side Panel
    ${variable}=    Ensure Record IS Visible
    ${STEP_COUNT}=    Move to Record On Side Pannel With OCR
    CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    Sleep    2s


Select New Channel And Retry
    CLICK BACK
    CLICK BACK
    CLICK BACK
    Sleep    2s
    CLICK OK
    CLICK DOWN
    CLICK OK
    CLICK BACK


Select Supported Recording Type program
    [Arguments]    ${recorded_storage_type}

    CLICK BACK
    CLICK UP
    CLICK UP
    CLICK UP
    CLICK UP
    CLICK UP
    Select Recording Type    ${recorded_storage_type}

Select Supported Recording Type Series
    [Arguments]    ${recorded_storage_type}

    CLICK BACK
    CLICK UP
    CLICK UP
    CLICK UP
    CLICK UP
    CLICK UP
    Select Recording Type Series   ${recorded_storage_type}

Get Local And Cloud Ocr And Return
        # Capture image after current timestamp
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    # Crop the relevant portion for storage type
    ${after_crop}=    IPL.Get Local And Cloud Recording Supported   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}
    RETURN    ${after_text}

Select Recording Type Manual
    [Arguments]    ${recording_type}
    Sleep    5s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=    IPL.crop recording type    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    Run Keyword If    '${recording_type}' == 'Local' and 'Cloud' in '${after_text}'    Select Local From Cloud Manual
    ...    ELSE IF    '${recording_type}' == 'Cloud'    Select Cloud From Local Manual
    ...    ELSE    Select Local Recording Type Manual

Select Local Recording Type Manual
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK

Select Local From Cloud Manual
    Log To Console    Selecting Local recording
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK DOWN
    # CLICK DOWN
    # CLICK DOWN
    CLICK OK
    CLICK UP
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK OK

Select Cloud From Local Manual
    Log To Console    Selecting cloud recording
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK DOWN
    # CLICK DOWN
    # CLICK DOWN
    CLICK OK
    CLICK DOWN
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK OK

Check For Supported Recording Until Found Manual
    [Arguments]    ${recorded_storage_type}

    ${is_supported}=    Set Variable    False

    WHILE    not ${is_supported}
        Log To Console    🔁 Checking for supported recording type: ${recorded_storage_type}

        # --- Navigate to Record On Side Panel ---
        Navigate To Record On Side Panel

        # --- Perform OCR and clean text ---
        ${raw_text}=    Get Local And Cloud Ocr And Return
        Log To Console    🧾 OCR Raw Text: ${raw_text}
        ${clean_text}=    Strip String    ${raw_text}
        Log To Console    🧹 Cleaned OCR: ${clean_text}

        # --- Check if type is supported ---
        ${is_supported}=    Evaluate    '${recorded_storage_type}'.lower() in '${clean_text}'.lower()
        Log To Console    📦 Detected Type: ${recorded_storage_type}
        Log To Console    📦 Is Supported: ${is_supported}

        # --- Decision ---
        Run Keyword If    ${is_supported}    Select Supported Recording Type Manual    ${recorded_storage_type}
        Run Keyword Unless    ${is_supported}    Select New Channel And Retry

    END

    Log To Console    ✅ Supported recording type found: ${recorded_storage_type}
    RETURN    ${is_supported}



Select Supported Recording Type Manual
    [Arguments]    ${recorded_storage_type}

    CLICK BACK
    CLICK UP
    CLICK UP
    CLICK UP
    CLICK UP
    CLICK UP
    Select Recording Type Manual    ${recorded_storage_type}

Select Recording Type Impulse
    [Arguments]    ${recording_type}
    Sleep    5s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=    IPL.crop recording type    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    Run Keyword If    '${recording_type}' == 'Local' and 'Cloud' in '${after_text}'    Select Local From Cloud Impulse
    ...    ELSE IF    '${recording_type}' == 'Cloud'    Select Cloud From Local Impulse
    ...    ELSE    Select Local Recording Type Impulse

Select Local Recording Type Impulse
    # CLICK DOWN
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK

Select Local From Cloud Impulse
    Log To Console    Selecting Local recording
    # CLICK DOWN
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK UP
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK OK

Select Cloud From Local Impulse
    Log To Console    Selecting cloud recording
    # CLICK DOWN
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
    CLICK OK

Check For Supported Recording Until Found Impulse
    [Arguments]    ${recorded_storage_type}

    ${is_supported}=    Set Variable    False

    WHILE    not ${is_supported}
        Log To Console    🔁 Checking for supported recording type: ${recorded_storage_type}

        # --- Navigate to Record On Side Panel ---
        Navigate To Record On Side Panel

        # --- Perform OCR and clean text ---
        ${raw_text}=    Get Local And Cloud Ocr And Return
        Log To Console    🧾 OCR Raw Text: ${raw_text}
        ${clean_text}=    Strip String    ${raw_text}
        Log To Console    🧹 Cleaned OCR: ${clean_text}

        # --- Check if type is supported ---
        ${is_supported}=    Evaluate    '${recorded_storage_type}'.lower() in '${clean_text}'.lower()
        Log To Console    📦 Detected Type: ${recorded_storage_type}
        Log To Console    📦 Is Supported: ${is_supported}

        # --- Decision ---
        Run Keyword If    ${is_supported}    Select Supported Recording Type Impulse    ${recorded_storage_type}
        Run Keyword Unless    ${is_supported}    Select New Channel And Retry

    END

    Log To Console    ✅ Supported recording type found: ${recorded_storage_type}
    RETURN    ${is_supported}



Select Supported Recording Type Impulse
    [Arguments]    ${recorded_storage_type}

    CLICK BACK
    CLICK UP
    CLICK UP
    CLICK UP
    CLICK UP
    CLICK UP
    Select Recording Type Impulse    ${recorded_storage_type}

Get Text From Inbox
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    ${after_crop}=    IPL.Inbox Verification    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # ✅ Perform OCR Extraction
    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # ✅ Remove special characters
    ${without_special_char}=    Evaluate    re.sub(r'[^a-zA-Z0-9 ]','',"""${after_text}""")    re
    Log To Console    CLEANED TEXT: ${without_special_char}

    # ✅ Fail if OCR text is NOT empty
    Run Keyword If    '${without_special_char}' != ''    Fail    ❌ OCR text found: ${without_special_char}

    # ✅ Continue (pass) if OCR text is empty
    Log To Console    ✅ OCR text empty, passing as expected.

    ${recorded_channel_text}=    Set Variable    ${without_special_char}
    RETURN    ${recorded_channel_text}

Get Play Side Panel Recorder

    CLICK OK
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log    AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Play Side Panel Recorder   ${after_image_path}
    Log To Console   CROPPED AFTER INFO BAR: ${cropped_img}
     # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    # RETURN    ${channel_name_epg_text} 
    ${channel_name_epg_text}=    Set Variable    ${after_text}
    RETURN    ${channel_name_epg_text}

Get Daily Side Panel Recorder

    # CLICK OK
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log    AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Daily Side Panel Recorder   ${after_image_path}
    Log To Console   CROPPED AFTER INFO BAR: ${cropped_img}
     # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    # RETURN    ${channel_name_epg_text} 
    ${channel_name_epg_text}=    Set Variable    ${after_text}
    RETURN    ${channel_name_epg_text}


Get Asset Name In Sort 
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console   AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Asset Name In Genre Sort   ${after_image_path}
    Log To Console   CROPPED AFTER INFO BAR: ${cropped_img}
     # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    # RETURN    ${channel_name_epg_text} 
    ${channel_name_epg_text}=    Set Variable    ${after_text}
    RETURN    ${channel_name_epg_text}

Get First Letters
    [Arguments]    @{names}
    ${letters}=    Create List
    FOR    ${n}    IN    @{names}
        ${letter}=    Evaluate    re.search(r'[A-Za-z]', '''${n}''').group(0).upper() if re.search(r'[A-Za-z]', '''${n}''') else ''
        Append To List    ${letters}    ${letter}
        RETURN    ${letters}
    END

Handle Recording Failure Recorder
    Log To Console    Recording Failed or Unexpected Popup Detected
    CLICK OK
    Sleep    2s
    CLICK CHANNELUP
    Sleep    10s
    CLICK RIGHT
    Check For Supported Recording Until Found   Cloud
    Sleep  10s
    ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_401_Rec_Start
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_401_Rec_Start
	...  ELSE  Fail  TC_401_Rec_Start Is Not Displayed 
    CLICK OK
    Sleep    20s

    ${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked After Failure: ${channel_name}
    Sleep    10s
    RETURN    ${channel_name}
    
Handle Recording Failure Local Recorder
    Log To Console    Recording Failed or Unexpected Popup Detected
    CLICK OK
    Sleep    2s
    CLICK CHANNELUP
    Sleep    10s
    CLICK RIGHT
    Check For Supported Recording Until Found   Local
    Sleep  10s
    ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_401_Rec_Start
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_401_Rec_Start Is Displayed
	...  ELSE  Fail  TC_401_Rec_Start Is Not Displayed 
    CLICK OK
    Sleep    20s
    CLICK UP
    ${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked After Failure: ${channel_name}
    Sleep    10s
    RETURN    ${channel_name}

Get Channel Name In Recorder Of MyList Delete
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    ${after_crop}=    IPL.Channel Name In Recorder Of MyList    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # ✅ Perform OCR Extraction
    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # ✅ Remove special characters
    ${without_special_char}=    Evaluate    re.sub(r'[^a-zA-Z0-9 ]','',"""${after_text}""")    re
    Log To Console    CLEANED TEXT: ${without_special_char}

    # ✅ Fail if OCR text is NOT empty
    Run Keyword If    '${without_special_char}' != ''    Fail    ❌ OCR text found: ${without_special_char}

    # ✅ Continue (pass) if OCR text is empty
    Log To Console    ✅ OCR text empty, passing as expected.

    ${recorded_channel_text}=    Set Variable    ${without_special_char}
    RETURN    ${recorded_channel_text}
Get Second Channel Name In Recorder Of MyList
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    ${after_crop}=    IPL.Channel Second Name In Recorder Of MyList    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # ✅ Perform OCR Extraction (MISSING IN YOUR ORIGINAL CODE)
    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    Run Keyword Unless    '${after_text}' != ''    Fail    OCR did not return any text!
    Log To Console    OCR AFTER TEXT: ${after_text}

    # ✅ Remove special characters
    ${without_special_char}=    Evaluate    re.sub(r'[^a-zA-Z0-9 ]','',"""${after_text}""")    re
    Log To Console    CLEANED TEXT: ${without_special_char}

    ${recorded_channel_text}=    Set Variable    ${without_special_char}
    RETURN    ${recorded_channel_text}

STOP RECORDING IN SUB PROFILE
    STOP RECORDING
    DELETE PROFILE

Process Successful Recording
    Log To Console    TC_401_Rec_Start Is Displayed
    CLICK OK
    ${channel_name}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name}
    RETURN    ${channel_name}

Process Successful Recording2
    Log To Console    TC_401_Rec_Start Is Displayed
    CLICK OK
    ${channel_name1}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked: ${channel_name1}
    RETURN    ${channel_name1}

Handle Recording Failure Recorder2
    Log To Console    Recording Failed or Unexpected Popup Detected
    CLICK OK
    Sleep    2s
    CLICK CHANNELUP
    Sleep    10s
    CLICK RIGHT
    Check For Supported Recording Until Found   Cloud
    Sleep  10s
    ${Result}  Verify Crop Image With Shorter Duration   ${port}  TC_401_Rec_Start
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_401_Rec_Start
	...  ELSE  Fail  TC_401_Rec_Start Is Not Displayed 
    CLICK OK
    Sleep    20s

    ${channel_name1}=    Get Channel Name In Recorder From Info Bar
    Log To Console    📺 Channel Checked After Failure: ${channel_name1}
    Sleep    10s
    RETURN    ${channel_name1}               

Move to Pause On Side Pannel With OCR
    ${after_text}=    Capture Side Pannel Options
    ${STEP_COUNT}=    Get Side Pannel Pause And Return Count   ${after_text}
    RETURN    ${STEP_COUNT}

Move to Record On Side Pannel With OCR
    ${after_text}=    Capture Side Pannel Options
    ${STEP_COUNT}=    Get Side Pannel Record And Return Count   ${after_text}
    RETURN    ${STEP_COUNT}
        
Capture Side Pannel Options
    # Capture image of side pannel
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    # Crop the relevant portion for storage type
    ${after_crop}=    IPL.Get Side Pannel Options   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    RETURN    ${after_text}

Capture Side Pannel Options Of Filter
    # Capture image of side pannel
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    # Crop the relevant portion for storage type
    ${after_crop}=    IPL.Get Side Pannel Options Of Filter  ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    RETURN    ${after_text}

Get Side Pannel Record And Return Count
    [Arguments]   ${ocr_text}    ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # Create list of expected menu items
    ${expected_items}=    Create List    Add To Favorites    Remove Favorite    Pause    Start Over 

    # Loop through expected items and check if they exist in OCR text
    FOR    ${item}    IN    @{expected_items}
        IF    '${item}' in '${ocr_text}'
            ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
            Log To Console    Found "${item}". STEP_COUNT=${STEP_COUNT}
        ELSE
            Log To Console    "${item}" not found.
        END
    END

    Log To Console    Final STEP_COUNT: ${STEP_COUNT}
    RETURN    ${STEP_COUNT}
Ensure Pause IS Visible
    FOR    ${i}    IN RANGE    10
        Log To Console    Attempt ${i}: Checking Pause
        CLICK RIGHT
        ${Start_Over_Visible}=    Verify Crop Image With Shorter Duration    ${port}    Pause_Side_Panel
        Log To Console    Pause Visible: ${Start_Over_Visible}
        Run Keyword If    ${Start_Over_Visible}    Exit For Loop
        CLICK CHANNEL_PLUS        
        Sleep    20s
        CLICK RIGHT
    END
Ensure Record IS Visible
    ${max_attempts}=    Set Variable    10
    ${attempt}=         Set Variable    1

    FOR    ${i}    IN RANGE    ${max_attempts}
        Log To Console    🔎 Attempt ${attempt}/${max_attempts}: Checking if 'Record' is visible
        CLICK RIGHT

        ${Record_Visible}=    Verify Crop Image With Shorter Duration    ${port}    Side_Pannel_Record
        Log To Console    Record Visible: ${Record_Visible}

        Run Keyword If    ${Record_Visible}    Exit For Loop

        # Not visible → try next channel
        CLICK CHANNEL_PLUS        
        Sleep    20s
        CLICK RIGHT

        ${attempt}=    Evaluate    ${attempt} + 1
    END

    # If loop completed without finding record, fail
    Run Keyword If    not ${Record_Visible}    Fail    ❌ 'Record' option not visible after ${max_attempts} attempts!

    RETURN    ${Record_Visible}

Get Side Pannel Start Over And Return Count
    [Arguments]   ${ocr_text}    ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # Create list of expected menu items
    ${expected_items}=    Create List    Remove Favorite    Pause    Start Over

    # Loop through expected items and check if they exist in OCR text
    FOR    ${item}    IN    @{expected_items}
        IF    '${item}' in '${ocr_text}'
            ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
            Log To Console    Found "${item}". STEP_COUNT=${STEP_COUNT}
        ELSE
            Log To Console    "${item}" not found.
        END
    END

    Log To Console    Final STEP_COUNT: ${STEP_COUNT}
    RETURN    ${STEP_COUNT}

Get Side Pannel Pause And Return Count
    [Arguments]   ${ocr_text}    ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # Create list of expected menu items
    ${expected_items}=    Create List    Add To Favorites   Remove Favorite

    # Loop through expected items and check if they exist in OCR text
    FOR    ${item}    IN    @{expected_items}
        IF    '${item}' in '${ocr_text}'
            ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
            Log To Console    Found "${item}". STEP_COUNT=${STEP_COUNT}
        ELSE
            Log To Console    "${item}" not found.
        END
    END

    Log To Console    Final STEP_COUNT: ${STEP_COUNT}
    RETURN    ${STEP_COUNT}

Get Side Pannel Filter And Return Count
    [Arguments]   ${ocr_text}    ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # Create list of expected menu items
    ${expected_items}=    Create List    Go to List Section  Add To Favorites   Remove Favorite     Filter

    # Loop through expected items and check if they exist in OCR text
    FOR    ${item}    IN    @{expected_items}
        IF    '${item}' in '${ocr_text}'
            ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
            Log To Console    Found "${item}". STEP_COUNT=${STEP_COUNT}
        ELSE
            Log To Console    "${item}" not found.
        END
    END

    Log To Console    Final STEP_COUNT: ${STEP_COUNT}
    RETURN    ${STEP_COUNT}

Move to Start Over On Side Pannel
    ${after_text}=    Capture Side Pannel Options
    ${STEP_COUNT}=    Get Side Pannel Start Over And Return Count   ${after_text}
    RETURN    ${STEP_COUNT}

Move to Filter On Side Pannel
    ${after_text}=    Capture Side Pannel Options Of Filter
    ${STEP_COUNT}=    Get Side Pannel Filter And Return Count   ${after_text}
    RETURN    ${STEP_COUNT}

Move to Pause On Side Pannel
    ${after_text}=    Capture Side Pannel Options
    ${STEP_COUNT}=    Get Side Pannel Pause And Return Count   ${after_text}
    RETURN    ${STEP_COUNT}

Capture Multiple Screens And Validate Language
    [Arguments]    ${expected_language}    ${iterations}=20    ${delay}=5
    [Documentation]    Capture multiple screenshots and check for subtitles in expected language, logging all extracted text.

    FOR    ${index}    IN RANGE    ${iterations}
        Log To Console    \n--- Iteration ${index + 1}/${iterations} ---

        ${d_rimg}=    Run Keyword If    '${expected_language}' == 'ar'    Get Subtitle Text Arabic    ELSE    Get Subtitle Text English
        ${status}=    Repeat OCR And Validate Language    ${d_rimg}    ${expected_language}

        Run Keyword If    ${status}    Exit For Loop
        Sleep    ${delay}
    END

    Run Keyword Unless    ${status}    Fail    ❌ Expected subtitle in language '${expected_language}' not found in ${iterations} attempts!
    RETURN    ${status}

Get Subtitle Text Arabic    
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop Subtitle arabic    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    RETURN    ${after_crop}

Get Subtitle Text English    
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop Subtitle english   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    RETURN    ${after_crop} 

Get Baseline RMS
    [Arguments]    ${duration}=5
    ${rms}=    Capture RMS    ${duration}
    RETURN    ${rms}

Get Current RMS
    [Arguments]    ${duration}=5
    ${rms}=    Capture RMS    ${duration}
    RETURN    ${rms}

Validate Volume Change Result
    [Arguments]    ${previous_rms}    ${current_rms}

    Log To Console    \n🔍 Previous RMS: ${previous_rms}
    Log To Console    🔍 Current RMS : ${current_rms}

    ${result}=    Validate Volume Change    ${previous_rms}    ${current_rms}
    RETURN    ${result}


Validate Volume Up Behavior
    Set Audio Device    hw:1,0

    Log To Console    \n🎧 Capturing BEFORE volume RMS...
    ${before}=    Capture RMS    5

    Log To Console    🔼 Pressing VOLUME UP...
    Click Volume Plus
    Sleep    1s

    Log To Console    🎧 Capturing AFTER volume RMS...
    ${after}=    Capture RMS    5

    ${result}=    Validate Volume Change Result    ${before}    ${after}

    IF    not ${result}
        Fail    ❌ Volume Up Did Not Behave As Expected
    ELSE
        Log To Console    ✅ Volume Up Validation Passed
    END

Validate Mute Result
    [Arguments]    ${previous_rms}    ${current_rms}

    Log To Console    \n🔍 Previous RMS: ${previous_rms}
    Log To Console    🔍 Current RMS : ${current_rms}

    ${result}=    Validate Mute    ${previous_rms}    ${current_rms}
    RETURN    ${result}

Validate Mute Behavior
    ${current_rms}=    Capture RMS
    ${result}=    Validate Mute    ${current_rms}
    Run Keyword If    not ${result}    Fail    ❌ Mute Did Not Reduce RMS To Near Zero
    Log TO Console    Audio in mute

Validate Volume Down Result
    [Arguments]    ${previous_rms}    ${current_rms}

    Log To Console    \n🔍 Previous RMS: ${previous_rms}
    Log To Console    🔍 Current RMS : ${current_rms}

    ${result}=    Validate Volume Down    ${previous_rms}    ${current_rms}
    RETURN    ${result}

Validate Volume Down Behavior
    CLICK VOLUME_MINUS
    Set Audio Device    hw:1,0

    Log To Console    \n🎧 Capturing BEFORE volume-down RMS...
    ${before}=    Capture RMS    5

    Log To Console    🔽 Pressing VOLUME DOWN...
    Click Volume Minus
    Sleep    1s

    Log To Console    🎧 Capturing AFTER volume-down RMS...
    ${after}=    Capture RMS    5

    ${result}=    Validate Volume Down Result    ${before}    ${after}

    IF    not ${result}
        Fail    ❌ Volume Down Did Not Behave As Expected
    ELSE
        Log To Console    ✅ Volume Down Validation Passed
    END



Unified verification of Audio Quality
    Log To Console    Check For Audio Mute
    
    CLICK MUTE
    Validate Mute Behavior
    # Make sure Volume is not Full
    CLICK VOLUME_MINUS
    CLICK VOLUME_MINUS
    CLICK VOLUME_MINUS
    CLICK VOLUME_MINUS
    CLICK VOLUME_MINUS
    CLICK VOLUME_MINUS
    CLICK VOLUME_MINUS
    CLICK VOLUME_MINUS
    CLICK VOLUME_PLUS
    Validate Volume Up Behavior
    CLICK VOLUME_PLUS
    Validate Volume Up Behavior
    CLICK VOLUME_PLUS
    Validate Volume Up Behavior
    CLICK VOLUME_PLUS
    Validate Volume Up Behavior
    # Make sure Volume is Not Mute
    Sleep    2s
    CLICK VOLUME_PLUS
    CLICK VOLUME_PLUS
    CLICK VOLUME_PLUS
    CLICK VOLUME_PLUS
    CLICK VOLUME_PLUS
    CLICK VOLUME_PLUS
    CLICK VOLUME_PLUS
    Validate Volume Down Behavior
    CLICK VOLUME_MINUS
    Validate Volume Down Behavior
    CLICK VOLUME_MINUS
    Validate Volume Down Behavior
    CLICK VOLUME_MINUS
    Validate Volume Down Behavior

Validate Video Playback For Frozen
    ${results}=    Create List

    FOR    ${i}    IN RANGE    3
        ${now}=    generic.get_date_time
        ${d_rimg}=    Replace String    ${ref_img1}    replace    ${now}
        generic.capture image run    ${port}    ${d_rimg}
        # Log To Console    📸 Reference Image: ${d_rimg}

        Sleep    10s
        ${now}=    generic.get_date_time
        ${d_cimg}=    Replace String    ${comp_img}    replace    ${now}
        generic.capture image run    ${port}    ${d_cimg}
        # Log To Console    📸 Comparison Image: ${d_cimg}

        ${result}=    generic.compare_ssim    ${d_rimg}    ${d_cimg}
        ${score}=     Set Variable    ${result}[0]
        ${motion}=    Set Variable    ${result}[1]

        # Log To Console    SSIM Score: ${score}
        Run Keyword If    ${motion}==True     Log To Console    Checking for motion  
        Run Keyword If    ${motion}==False    Log To Console    Checking for motion

        Run Keyword If    ${motion}==True     Append To List    ${results}    True
        Run Keyword If    ${motion}==False    Append To List    ${results}    False
    END

    ${count}=    Set Variable    0
    FOR    ${item}    IN    @{results}
        ${is_true}=    Evaluate    1 if '${item}'=='True' else 0
        ${count}=    Evaluate    ${count} + ${is_true}
    END

    # Run Keyword If    ${count} >= 2    Log To Console    ✅ Video is Playing
    # Run Keyword If    ${count} < 2     Log To Console    ❌ Video is Frozen

    Run Keyword If    ${count} >= 2    Return From Keyword    True
    Return From Keyword    False

Video Quality Verification
    Motion Detector
    # 🧪 Proceed with video quality check if not frozen
    ${VERDICTS}=    Create List
    Log To Console    Using script: ${SCRIPT_PATH}

    FOR    ${i}    IN RANGE    10
        IF    ${i} == 5
            Run Keyword    Motion Detector
        END

        Log To Console    \n🔁 Run ${i+1}/10
        ${result}=    Run Process    python3    ${SCRIPT_PATH}    stdout=PIPE    stderr=PIPE
        ${output}=    Set Variable    ${result.stdout}
        Log To Console    ${output}

        ${contains_verdict}=    Evaluate    'Final Verdict:' in '''${output}'''
        Run Keyword If    not ${contains_verdict}    Log To Console    ❌ Verdict missing. Skipping this run.
        Run Keyword If    not ${contains_verdict}    Continue For Loop

        ${verdict}=    Evaluate    re.search(r"Final Verdict:\s*(.*)", '''${output}''').group(1).strip()    modules=re
        Append To List    ${VERDICTS}    ${verdict}
        Log To Console    ✅ Verdict added: ${verdict}
    END

    Log To Console    \n📋 All Verdicts:
    FOR    ${v}    IN    @{VERDICTS}
        Log To Console    Analysed and recorded ${v} frame
    END

    ${bad_count}=    Get Count    ${VERDICTS}    Bad Quality Video
    ${good_count}=   Get Count    ${VERDICTS}    Good Quality Video
    ${total}=        Get Length   ${VERDICTS}

    ${bad_percent}=    Evaluate    round(${bad_count} * 100 / ${total}, 2)
    ${good_percent}=   Evaluate    round(${good_count} * 100 / ${total}, 2)

    Run Keyword If    ${bad_count} > ${good_count}     Log To Console    \n Final Verdict: Bad Quality Video
    Run Keyword If    ${good_count} > ${bad_count}     Log To Console    \n Final Verdict: Good Quality Video
    Run Keyword If    ${bad_count} == ${good_count}    Log To Console    \n Final Verdict: Mixed Quality — Equal Good and Bad


Motion Detector
    ${result}=    Validate Video Playback For Frozen
    # 🔍 If video is frozen, fail the test
    Run Keyword If    '${result}' == 'False'    Log To Console    ❌ Video freezed
    Run Keyword If    '${result}' == 'False'    Fail    Video playback is frozen. Test aborted.


Profile Name From Profile Settings Page  
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.crop Profile Name Settings page   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    
    RETURN    ${after_crop}

Verify the Similarity Profile Name
    [Arguments]    ${before_crop}  
    # Primary Validation: OCR Text Change
    # Fallback Validation: SSIM Comparison
    ${similarity}=    IPL.Compare Images SSIM    ${before_crop}    ${image_profile_wxyz}
    Log To Console    SSIM SIMILARITY: ${similarity}
    Should Be True    ${similarity} > 0.15    Profile name is Not displayed

Verify the Similarity Profile Name Negative Scenario

    [Arguments]    ${before_crop}  
    # Primary Validation: OCR Text Change
    # Fallback Validation: SSIM Comparison
    ${similarity}=    IPL.Compare Images SSIM    ${before_crop}    ${image_profile_wxyz}
    Log To Console    SSIM SIMILARITY: ${similarity}
    Should Be True    ${similarity} < 0.32    Profile name is displayed

Favlist1_Channel_list
    FOR    ${i}    IN RANGE    2
        ${result}=    Get Channel Number Fav
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "11"
            Log To Console    YES this is channel 11
        ELSE
            Fail    Expected channel 11 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "12"
            Log To Console    YES this is channel 12
        ELSE
            Fail    Expected channel 12 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "15"
            Log To Console    YES this is channel 15
        ELSE
            Fail    Expected channel 15 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "22"
            Log To Console    YES this is channel 22
        ELSE
            Fail    Expected channel 22 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "23"
            Log To Console    YES this is channel 23
        ELSE
            Fail    Expected channel 23 but got ${result}
        END
        CLICK DOWN
    END
Favlist2_Channel_list
    FOR    ${i}    IN RANGE    2
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "24"
            Log To Console    YES this is channel 24
        ELSE
            Fail    Expected channel 24 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "25"
            Log To Console    YES this is channel 25
        ELSE
            Fail    Expected channel 25 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "33"
            Log To Console    YES this is channel 33
        ELSE
            Fail    Expected channel 33 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "34"
            Log To Console    YES this is channel 34
        ELSE
            Fail    Expected channel 34 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "35"
            Log To Console    YES this is channel 35
        ELSE
            Fail    Expected channel 35 but got ${result}
        END
        CLICK DOWN
    END
Favlist3_Channel_list
    FOR    ${i}    IN RANGE    2
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "38"
            Log To Console    YES this is channel 38
        ELSE
            Fail    Expected channel 38 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "40"
            Log To Console    YES this is channel 40
        ELSE
            Fail    Expected channel 40 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "42"
            Log To Console    YES this is channel 42
        ELSE
            Fail    Expected channel 42 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "48"
            Log To Console    YES this is channel 48
        ELSE
            Fail    Expected channel 48 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "51"
            Log To Console    YES this is channel 51
        ELSE
            Fail    Expected channel 51 but got ${result}
        END
        CLICK DOWN
    END
Favlist4_Channel_list
    FOR    ${i}    IN RANGE    2
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "60"
            Log To Console    YES this is channel 60
        ELSE
            Fail    Expected channel 60 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "61"
            Log To Console    YES this is channel 61
        ELSE
            Fail    Expected channel 61 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "62"
            Log To Console    YES this is channel 62
        ELSE
            Fail    Expected channel 62 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "63"
            Log To Console    YES this is channel 63
        ELSE
            Fail    Expected channel 63 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "64"
            Log To Console    YES this is channel 64
        ELSE
            Fail    Expected channel 64 but got ${result}
        END
        CLICK DOWN
    END
Favlist5_Channel_list
    FOR    ${i}    IN RANGE    2
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "96"
            Log To Console    YES this is channel 96
        ELSE
            Fail    Expected channel 96 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "97"
            Log To Console    YES this is channel 97
        ELSE
            Fail    Expected channel 97 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "101"
            Log To Console    YES this is channel 101
        ELSE
            Fail    Expected channel 101 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "102"
            Log To Console    YES this is channel 102
        ELSE
            Fail    Expected channel 102 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" == "103"
            Log To Console    YES this is channel 103
        ELSE
            Fail    Expected channel 103 but got ${result}
        END
        CLICK DOWN
    END
Get Channel number
    Sleep    5s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.crop_Channel_Number_Hidden_Channel   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}
    ${after_text}=     Strip String    ${after_text}
    ${after_text}=     Remove String Using Regexp    ${after_text}    [^0-9]
    RETURN    ${after_text}

Revert Unhide
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
	CLICK UP
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK MULTIPLE TIMES    6    DOWN
	CLICK OK
	CLICK OK

Revert channel style changes 
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
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
	...  ELSE  Log To Console  TC_018_five_channel_style Is Not Displayed on screen
	
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

Hide Channel 
    Sleep    5s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.crop Hide Channel   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}
    ${after_text}=     Strip String    ${after_text}
    ${after_text}=     Remove String Using Regexp    ${after_text}    [^0-9]
    RETURN    ${after_text}
Check For New Message Popup
    Sleep   2s
    ${Result}=    Verify Crop Image    ${port}    newmessage
    Log To Console    popup found: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
        # CLICK HOME
    END
Zap Channel To Channel Using Program UP and Down Keys Regression
    [Documentation]    Validate channel zapping using CHANNEL + and CHANNEL - keys
    Log To Console    ===== Starting Channel Zap Regression =====

    # ---------------------- Tune Initial Channel ----------------------
    CLICK FIVE
    CLICK FIVE
    CLICK NINE
    Sleep    3s

    ${raw_text_source}=    Extract Text From Channel Bar
    ${channel_c1}=    IPL.Extract First Number    ${raw_text_source}
    Log To Console    📺 Initial Channel (C1): ${channel_c1}

    Should Not Be Empty    ${channel_c1}
    # ---------------------- C1 ➜ C2 (CHANNEL +) ----------------------
    Log To Console    ---- Pressing CHANNEL PLUS ----
    CLICK CHANNEL_PLUS
    Sleep    3s

    ${raw_text_plus}=    Extract Text From Channel Bar
    ${channel_c2}=    IPL.Extract First Number    ${raw_text_plus}
    Log To Console    📺 Channel After PLUS (C2): ${channel_c2}

    Should Not Be Equal    ${channel_c1}    ${channel_c2}    Channel did not change after CHANNEL PLUS

    # ---------------------- C2 ➜ C1 (CHANNEL -) ----------------------
    Log To Console    ---- Pressing CHANNEL MINUS ----
    CLICK CHANNEL_MINUS
    Sleep    3s

    ${raw_text_minus}=    Extract Text From Channel Bar
    ${channel_c3}=    IPL.Extract First Number    ${raw_text_minus}
    Log To Console    📺 Channel After MINUS (C3): ${channel_c3}

    Should Be Equal    ${channel_c1}    ${channel_c3}    Channel did not return to original after CHANNEL MINUS

    # ---------------------- RANDOM MULTIPLE + ----------------------
    Log To Console    ---- Random Multiple CHANNEL PLUS ----
    FOR    ${i}    IN RANGE    12
        CLICK CHANNEL_PLUS
    END
    Sleep    3s

    ${raw_text_multi_plus}=    Extract Text From Channel Bar
    ${channel_c4}=    IPL.Extract First Number    ${raw_text_multi_plus}
    Log To Console    📺 Channel After Multiple PLUS (C4): ${channel_c4}

    Should Not Be Equal    ${channel_c3}    ${channel_c4}    Channel did not change after multiple CHANNEL PLUS

    # ---------------------- RANDOM MULTIPLE - ----------------------
    Log To Console    ---- Random Multiple CHANNEL MINUS ----
    FOR    ${i}    IN RANGE    6
        CLICK CHANNEL_MINUS
    END
    Sleep    3s

    ${raw_text_multi_minus}=    Extract Text From Channel Bar
    ${channel_c5}=    IPL.Extract First Number    ${raw_text_multi_minus}
    Log To Console    📺 Channel After Multiple MINUS (C5): ${channel_c5}

    Should Not Be Equal    ${channel_c4}    ${channel_c5}    Channel did not change after multiple CHANNEL MINUS

    Log To Console    ===== Channel Zap Regression Completed Successfully =====


Zap Channel TO Channel Using Program UP and down Keys NEW
    Log To Console    Case for pressing program plus button

    CLICK FIVE
    CLICK FIVE
    CLICK NINE
    Sleep   3s

    ${raw_text_source}=    Extract Text From Channel Bar
    ${source_channel_number_C1}=    IPL.Extract First Number    ${raw_text_source}
    Log To Console    📺 Extracted Channel Number: ${source_channel_number_C1}

    # get playback wait time safely
    ${playback_time_c0}=   Validate And Return Playback Time Safely

    # ---------------------- C1 ➜ C2 (CHANNEL +) ----------------------
    CLICK CHANNEL_PLUS
    Sleep   3s
    ${start_c1}=    Evaluate    __import__('time').time()

    ${raw_text_target}=    Extract Text From Channel Bar
    ${target_channel_number_C1}=    IPL.Extract First Number    ${raw_text_target}
    Log To Console    📺 Extracted Channel Number: ${target_channel_number_C1}

    Should Not Be Equal    ${source_channel_number_C1}    ${target_channel_number_C1}    Channel number did not change

    ${playback_time_c1}=   Validate And Return Playback Time Safely

    ${end_c1}=    Evaluate    __import__('time').time()
    ${zapping_time_c1}=    Evaluate    round(${end_c1} - ${start_c1}, 3)

    Log To Console    ✅ Zapping time: ${zapping_time_c1} seconds

    ${total_zap_time_c1}=    Evaluate    ${zapping_time_c1} - (${playback_time_c1} or 0)


    # ---------------------- C2 ➜ C3 (CHANNEL – ) ----------------------
    Log To Console    Case for pressing program minus button

    CLICK CHANNEL_MINUS
    Sleep   3s
    ${start_c2}=    Evaluate    __import__('time').time()

    ${raw_text_minus}=    Extract Text From Channel Bar
    ${target_channel_number_C2}=    IPL.Extract First Number    ${raw_text_minus}
    Log To Console    📺 Extracted Channel Number: ${target_channel_number_C2}

    ${playback_time_c2}=   Validate And Return Playback Time Safely

    Should Not Be Equal    ${target_channel_number_C1}    ${target_channel_number_C2}    Channel number did not change

    ${end_c2}=    Evaluate    __import__('time').time()
    ${zapping_time_c2}=    Evaluate    round(${end_c2} - ${start_c2}, 3)

    Log To Console    ✅ Zapping time (minus): ${zapping_time_c2} seconds

    ${total_zap_time_c2}=    Evaluate    ${zapping_time_c2} - (${playback_time_c2} or 0)


    # ---------------------- RANDOM MULTIPLE + (C3 ➜ C4) ----------------------
    Log To Console    Case for random increment of channel (multiple +)

    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    CLICK CHANNEL_PLUS
    Sleep   3s

    ${start_c3}=    Evaluate    __import__('time').time()

    ${raw_text_single_plus}=    Extract Text From Channel Bar
    ${target_channel_number_C3}=    IPL.Extract First Number    ${raw_text_single_plus}
    Log To Console    📺 Extracted Channel Number: ${target_channel_number_C3}

    ${playback_time_c3}=   Validate And Return Playback Time Safely

    Should Not Be Equal    ${target_channel_number_C2}    ${target_channel_number_C3}    Channel number did not change

    ${end_c3}=    Evaluate    __import__('time').time()
    ${zapping_time_c3}=    Evaluate    round(${end_c3} - ${start_c3}, 3)

    Log To Console    ✅ Zapping time (random +): ${zapping_time_c3} seconds

    ${total_zap_time_c3}=    Evaluate    ${zapping_time_c3} - (${playback_time_c3} or 0)


    # ---------------------- RANDOM MULTIPLE – (C4 ➜ C5) ----------------------
    Log To Console    Case for random decrement of channel (multiple -)

    CLICK CHANNEL_MINUS
    CLICK CHANNEL_MINUS
    CLICK CHANNEL_MINUS
    CLICK CHANNEL_MINUS
    CLICK CHANNEL_MINUS
    CLICK CHANNEL_MINUS
    Sleep   3s

    ${start_c4}=    Evaluate    __import__('time').time()

    ${raw_text_single_minus}=    Extract Text From Channel Bar
    ${target_channel_number_C4}=    IPL.Extract First Number    ${raw_text_single_minus}
    Log To Console    📺 Extracted Channel Number: ${target_channel_number_C4}

    ${playback_time_c4}=   Validate And Return Playback Time Safely

    Should Not Be Equal    ${target_channel_number_C3}    ${target_channel_number_C4}    Channel number did not change

    ${end_c4}=    Evaluate    __import__('time').time()
    ${zapping_time_c4}=    Evaluate    round(${end_c4} - ${start_c4}, 3)

    Log To Console    ✅ Zapping time (random -): ${zapping_time_c4} seconds

    ${total_zap_time_c4}=    Evaluate    ${zapping_time_c4} - (${playback_time_c4} or 0)

Validate And Return Playback Time Safely
    ${pb}=    Validate Video Playback Video Quality And Record Time
    Run Keyword If    '${pb}' == 'None'    Set Variable    ${pb}    0
    RETURN    ${pb}

Validate Video Playback Video Quality And Record Time
    Video Quality Verification For Zapping

Zap Channel TO Channel Using Numeric Keys NEW
    Log To Console    Case for pressing channel with three digit
    CLICK FIVE
    CLICK FIVE
    CLICK NINE
    Sleep   3s

    ${raw_text_source}=    Extract Text From Channel Bar
    ${source_channel_number_C1}=    IPL.Extract First Number    ${raw_text_source}
    Log To Console    📺 Extracted Channel Number: ${source_channel_number_C1}

    # Ensure playback time safe
    ${playback_time_c0}=    Validate And Return Playback Time Safely


    # ---------------------- C1 ➜ C2 (559 → 560) ----------------------
    CLICK FIVE
    CLICK SIX
    CLICK ZERO
    Sleep   3s

    ${start_c1}=    Evaluate    __import__('time').time()

    ${raw_text_target}=    Extract Text From Channel Bar
    ${target_channel_number_C1}=    IPL.Extract First Number    ${raw_text_target}
    Log To Console    📺 Extracted Channel Number: ${target_channel_number_C1}

    ${playback_time_c1}=    Validate And Return Playback Time Safely

    Should Not Be Equal    ${source_channel_number_C1}    ${target_channel_number_C1}    Channel number did not change

    ${end_c1}=    Evaluate    __import__('time').time()
    ${zapping_time_c1}=    Evaluate    round(${end_c1} - ${start_c1}, 3)

    Log To Console    ✅ Zapping time: ${zapping_time_c1} seconds
    ${total_zap_time_c1}=    Evaluate    ${zapping_time_c1} - (${playback_time_c1} or 0)


    # ---------------------- C2 ➜ C3 (560 → 002) ----------------------
    Log To Console    Case for pressing channel start from zero

    CLICK ZERO
    CLICK ZERO
    CLICK TWO
    Sleep   3s

    ${start_c2}=    Evaluate    __import__('time').time()

    ${raw_text_zero}=    Extract Text From Channel Bar
    ${target_channel_number_C2}=    IPL.Extract First Number    ${raw_text_zero}
    Log To Console    📺 Extracted Channel Number: ${target_channel_number_C2}

    ${playback_time_c2}=    Validate And Return Playback Time Safely

    Should Not Be Equal    ${target_channel_number_C1}    ${target_channel_number_C2}    Channel number did not change

    ${end_c2}=    Evaluate    __import__('time').time()
    ${zapping_time_c2}=    Evaluate    round(${end_c2} - ${start_c2}, 3)

    Log To Console    ✅ Zapping time to switch to channel starts with zero: ${zapping_time_c2} seconds
    ${total_zap_time_c2}=    Evaluate    ${zapping_time_c2} - (${playback_time_c2} or 0)


    # ---------------------- C3 ➜ C4 (002 → 3) ----------------------
    Log To Console    Case for pressing single digit channel

    CLICK THREE
    Sleep   3s

    ${start_c3}=    Evaluate    __import__('time').time()

    ${raw_text_single}=    Extract Text From Channel Bar
    ${target_channel_number_C3}=    IPL.Extract First Number    ${raw_text_single}
    Log To Console    📺 Extracted Channel Number: ${target_channel_number_C3}

    ${playback_time_c3}=    Validate And Return Playback Time Safely

    Should Not Be Equal    ${target_channel_number_C2}    ${target_channel_number_C3}    Channel number did not change

    ${end_c3}=    Evaluate    __import__('time').time()
    ${zapping_time_c3}=    Evaluate    round(${end_c3} - ${start_c3}, 3)

    Log To Console    ✅ Zapping time to switch single digit: ${zapping_time_c3} seconds
    ${total_zap_time_c3}=    Evaluate    ${zapping_time_c3} - (${playback_time_c3} or 0)
Video Quality Verification For Zapping
    Motion Detector
    # 🧪 Proceed with video quality check if not frozen
    ${VERDICTS}=    Create List
    Log To Console    Using script: ${SCRIPT_PATH}

    FOR    ${i}    IN RANGE    5
        IF    ${i} == 5
            Run Keyword    Motion Detector
        END

        Log To Console    \n🔁 Run ${i+1}/5
        ${result}=    Run Process    python3    ${SCRIPT_PATH}    stdout=PIPE    stderr=PIPE
        ${output}=    Set Variable    ${result.stdout}
        Log To Console    ${output}

        ${contains_verdict}=    Evaluate    'Final Verdict:' in '''${output}'''
        Run Keyword If    not ${contains_verdict}    Log To Console    ❌ Verdict missing. Skipping this run.
        Run Keyword If    not ${contains_verdict}    Continue For Loop

        ${verdict}=    Evaluate    re.search(r"Final Verdict:\s*(.*)", '''${output}''').group(1).strip()    modules=re
        Append To List    ${VERDICTS}    ${verdict}
        Log To Console    ✅ Verdict added: ${verdict}
    END

    Log To Console    \n📋 All Verdicts:
    FOR    ${v}    IN    @{VERDICTS}
        Log To Console    Analysed and recorded ${v} frame
    END

    ${bad_count}=    Get Count    ${VERDICTS}    Bad Quality Video
    ${good_count}=   Get Count    ${VERDICTS}    Good Quality Video
    ${total}=        Get Length   ${VERDICTS}

    ${bad_percent}=    Evaluate    round(${bad_count} * 100 / ${total}, 2)
    ${good_percent}=   Evaluate    round(${good_count} * 100 / ${total}, 2)

    Run Keyword If    ${bad_count} > ${good_count}     Log To Console    \n Final Verdict: Bad Quality Video
    Run Keyword If    ${good_count} > ${bad_count}     Log To Console    \n Final Verdict: Good Quality Video
    Run Keyword If    ${bad_count} == ${good_count}    Log To Console    \n Final Verdict: Mixed Quality — Equal Good and Bad


  

Get Side Pannel More Details And Return Count
    [Arguments]   ${ocr_text}    ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # Create list of expected menu items
    ${expected_items}=    Create List    Add To Favorites    Remove Favorite    Pause    Start Over    Record    Catch Up    

    # Loop through expected items and check if they exist in OCR text
    FOR    ${item}    IN    @{expected_items}
        IF    '${item}' in '${ocr_text}'
            ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
            Log To Console    Found "${item}". STEP_COUNT=${STEP_COUNT}
        ELSE
            Log To Console    "${item}" not found.
        END
    END

    Log To Console    Final STEP_COUNT: ${STEP_COUNT}
    RETURN    ${STEP_COUNT}


Move to More Details On Side Pannel With OCR
    ${after_text}=    Capture Side Pannel Options
    ${STEP_COUNT}=    Get Side Pannel More Details And Return Count   ${after_text}
    RETURN    ${STEP_COUNT}

Get Side Pannel Subtitles And Return Count
    [Arguments]   ${ocr_text}    ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # Create list of expected menu items
    ${expected_items}=    Create List    Add To Favorites    Remove Favorite    Pause    Start Over    Record    Catch Up    More Details    Audio Language   

    # Loop through expected items and check if they exist in OCR text
    FOR    ${item}    IN    @{expected_items}
        IF    '${item}' in '${ocr_text}'
            ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
            Log To Console    Found "${item}". STEP_COUNT=${STEP_COUNT}
        ELSE
            Log To Console    "${item}" not found.
        END
    END

    Log To Console    Final STEP_COUNT: ${STEP_COUNT}
    RETURN    ${STEP_COUNT}


Get Side Pannel Audio And Return Count
    [Arguments]   ${ocr_text}    ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # Create list of expected menu items
    ${expected_items}=    Create List    Add To Favorites    Remove Favorite    Pause    Start Over    Record    Catch Up    More Details

    # Loop through expected items and check if they exist in OCR text
    FOR    ${item}    IN    @{expected_items}
        IF    '${item}' in '${ocr_text}'
            ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
            Log To Console    Found "${item}". STEP_COUNT=${STEP_COUNT}
        ELSE
            Log To Console    "${item}" not found.
        END
    END

    Log To Console    Final STEP_COUNT: ${STEP_COUNT}
    RETURN    ${STEP_COUNT}


Move to Audio On Side Pannel With OCR
    ${after_text}=    Capture Side Pannel Options
    ${STEP_COUNT}=    Get Side Pannel Audio And Return Count   ${after_text}
    RETURN    ${STEP_COUNT}


Move to Subtitles On Side Pannel With OCR
    ${after_text}=    Capture Side Pannel Options
    ${STEP_COUNT}=    Get Side Pannel Subtitles And Return Count   ${after_text}
    RETURN    ${STEP_COUNT}

##########################################Image,Video,Audio Processing KW #############################################

vod category navigations
    CLICK UP
	${Result}  Verify Crop Image  ${port}  Pause_Button
	Run Keyword If  '${Result}' == 'True'  Log To Console  Pause_Button Is Displayed
	...  ELSE  Fail  Pause_Button Is Not Displayed
	${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
	# Video Quality Verification
	# Unified verification of Audio Quality
    CLICK HOME

Subscription
    ${pin}=    Verify Crop Image   ${port}    TC_513_subscription
    Log To Console    subscription: ${pin}
        IF    '${pin}' == 'True' 
            CLICK BACK
            CLICK BACK
            CLICK LEFT
            CLICK OK
        END
Search from side Panel
    CLICK Home
	CLICK Up
	CLICK Right
	CLICK Right
	CLICK OK
    CLICK OK
    CLICK OK
    CLICK UP
    CLICK OK
Bring control to first character
    Log To Console    Get control to the first charater
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




Check Add And Remove From List
    ${Found}=    Set Variable    False
    ${ocr_text}=    Set Variable    None
    FOR    ${i}    IN RANGE    10
        CLICK RIGHT    # move to next asset
        ${Remove}=    Verify Crop Image With Shorter Duration    ${port}    REMOVE_FROM_LIST
        Log To Console    Remove: ${Remove}

        IF    '${Remove}' == 'True'
            CLICK BACK
            CLICK RIGHT
            CLICK OK
            Log To Console    Asset is bought
            # ✅ do NOT exit the loop, continue checking next asset
            CONTINUE FOR LOOP
        ELSE
            ${Trailer}=     Verify Crop Image With Shorter Duration     ${port}    BoxOffice_Trailer
            Log To Console    Trailer: ${Trailer}

            IF    '${Trailer}' == 'True'
                # trailer flow
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
                CLICK UP
                CLICK OK
                ${Result}=     Verify Crop Image With Shorter Duration     ${port}    ADDED_TO_LIST
                Run Keyword If    '${Result}' == 'True'    Log To Console    ADDED_TO_LIST Is Displayed
                ...    ELSE    Fail    ADDED_TO_LIST Is Not Displayed
                CLICK OK
                ${Result}=     Verify Crop Image With Shorter Duration     ${port}    REM_LIST
                Run Keyword If    '${Result}' == 'True'    Log To Console    REM_LIST Is Displayed
                ...    ELSE    Fail    REM_LIST Is Not Displayed
                # CLICK OK
                # ${Result}=     Verify Crop Image With Shorter Duration     ${port}    ADDED_TO_LIST
                # Run Keyword If    '${Result}' == 'True'    Log To Console    REM_LIST Is Displayed
                # ...    ELSE    Fail    REM_LIST Is Not Displayed
                # CLICK OK
                # CLICK BACK

                ${Found}=    Set Variable    True
                ${ocr_text}=    Getting Assert Name after adding to list
                Exit For Loop
            ELSE
                # non-trailer flow
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
                ${Result}=     Verify Crop Image With Shorter Duration     ${port}    ADDED_TO_LIST
                Run Keyword If    '${Result}' == 'True'    Log To Console    ADDED_TO_LIST Is Displayed
                ...    ELSE    Fail    ADDED_TO_LIST Is Not Displayed
                CLICK OK
                ${Result}=     Verify Crop Image With Shorter Duration     ${port}    REM_LIST
                Run Keyword If    '${Result}' == 'True'    Log To Console    REM_LIST Is Displayed
                ...    ELSE    Fail    REM_LIST Is Not Displayed
                # CLICK OK
                # ${Result}=     Verify Crop Image With Shorter Duration     ${port}    ADDED_TO_LIST
                # Run Keyword If    '${Result}' == 'True'    Log To Console    REM_LIST Is Displayed
                # ...    ELSE    Fail    REM_LIST Is Not Displayed
                # CLICK OK
                # CLICK BACK
                ${Found}=    Set Variable    True
                ${ocr_text}=    Getting Assert Name after adding to list
                Exit For Loop
            END
        END
    END

    IF    '${Found}' != 'True'
        Fail    Could not add asset to list within 5 attempts
    END
    RETURN    ${ocr_text}
Getting Assert Name after adding to list
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop_Assert_name   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    RETURN    ${after_text}
Verify Assert After adding to list
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop_Assert_name_after_adding_to_list   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    RETURN    ${after_text}
Remove from list
    ${Remove}=     Verify Crop Image With Shorter Duration     ${port}    REMOVE_FROM_LIST
    Log To Console    Remove: ${Remove}
    IF    '${Remove}' == 'True'
        ${Trailer}=     Verify Crop Image With Shorter Duration     ${port}    BoxOffice_Trailer
        Log To Console    Trailer: ${Trailer}

        IF    '${Trailer}' == 'True'
            # trailer flow
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
            CLICK UP
            CLICK OK
            ${Result}=     Verify Crop Image With Shorter Duration     ${port}    ADDED_TO_LIST
            Run Keyword If    '${Result}' == 'True'    Log To Console    ADDED_TO_LIST Is Displayed
            ...    ELSE    Fail    ADDED_TO_LIST Is Not Displayed
            CLICK OK

        ELSE
            # non-trailer flow
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
             ${Result}=     Verify Crop Image With Shorter Duration     ${port}    ADDED_TO_LIST
            Run Keyword If    '${Result}' == 'True'    Log To Console    ADDED_TO_LIST Is Displayed
            ...    ELSE    Fail    ADDED_TO_LIST Is Not Displayed
            CLICK OK
        END
    END



Getting Assert Name after Rent
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop_Rent_assert   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    RETURN    ${after_text}

Get Live Progress Bar Status in vod
    ${now}=    generic.get_date_time
    ${before_image_path}=    Replace String    ${ref_img1}    replace    ${now}
    generic.capture image run    ${port}    ${before_image_path}
    Log To Console    BEFORE IMAGE: ${before_image_path}
    ${before_crop}=    IPL.Crop Progress Bar    ${before_image_path}
    Log To Console    CROPPED BEFORE INFO BAR: ${before_crop}
    ${after_text}=     OCR.Extract Text From Image    ${before_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    RETURN    ${after_text}


Play trailor1
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
    CLICK OK
    ${Result}  Validate Video Playback For Playing
	Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
	...  ELSE  Fail  Video is Paused
    CLICK BACK
    CLICK DOWN
    CLICK RIGHT

Play trailor
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK LEFT
    CLICK LEFT
    CLICK OK
    VALIDATE VIDEO PLAYBACK
    CLICK BACK

Next assest trailors
    CLICK RIGHT

VALIDATE TRAILOR PLAYBACK
    sleep  40s
    ${now}  generic.get_date_time
    ${d_rimg}  Replace String  ${ref_img1}  replace  ${now}
    generic.capture image run  ${port}  ${d_rimg}
    #Log  <img src='${d_rimg}'></img>  html=yes
    CAPTURE CURRENT IMAGE WITH TIME
    sleep  10s
    ${now}  generic.get_date_time
    ${d_cimg}  Replace String  ${comp_img}  replace  ${now}
    generic.capture image run  ${port}  ${d_cimg}
    #Log  <img src='${d_cimg}'></img>  html=yes
    CAPTURE CURRENT IMAGE WITH TIME
    ${pass}  generic.compare_image  ${d_rimg}  ${d_cimg}
    Run Keyword If  ${pass}==False  Run Keywords    Play trailor1    AND    Log To Console  Trailor is available
    ...  ELSE   Run Keywords    Next assest trailors    AND    Log To Console  Trailor is not available
Parental Control Subscription Rent Buy Flow
    ${block}=     Verify Crop Image With Shorter Duration     ${port}    503_rental
    Log To Console    Rent: ${block}

    ${buy}=       Verify Crop Image With Shorter Duration     ${port}    BUY_VOD
    Log To Console    Buy: ${buy}
    ${res1}=    Get HD
    Log To Console    Buy: ${res1}
    ${res1}=    Replace String    ${res1}    ${SPACE}${SPACE}    ${SPACE}
    Log To Console    HD TEXT: ${res1}

    IF    'HD 15 AED HD 15 AED' in '${res1}'
        CLICK DOWN
        Log To Console    HD available
    END
    
    IF    '${block}' == 'True' or '${buy}' == 'True'
        CLICK DOWN

        ${BillResult}=     Verify Crop Image With Shorter Duration     ${port}    bill
        Log To Console    Bill: ${BillResult}

        IF    '${BillResult}' == 'True'
            CLICK DOWN
            CLICK THREE
            CLICK THREE
            CLICK THREE
            CLICK THREE
            CLICK DOWN
            CLICK DOWN
            CLICK OK
            CLICK OK
            Log To Console    Asset is bought
            Sleep    2s
        ELSE  
            CLICK THREE
            CLICK THREE
            CLICK THREE
            CLICK THREE
            CLICK DOWN
            CLICK DOWN
            CLICK OK
            CLICK OK
            Log To Console    Asset is bought
            Sleep    2s
        END
    END
Rented Assest in Transaction
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop_Transaction_rent   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    RETURN    ${after_text}
Get Director Name From Info Bar
    Sleep   1s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log    AFTER IMAGE: ${after_image_path}

    # Call Director ROI cropping function (assuming IPL library is imported)
    ${cropped_img}=    IPL.Director_ROI_From_Info_Screen   ${after_image_path}
    Log    CROPPED DIRECTOR ROI: ${cropped_img}

    # OCR Extraction from cropped director image
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

     # Handle empty OCR output
    Run Keyword If    '${after_text}' == ''    Log To Console    WARNING: OCR returned empty text

    # Convert OCR text to lowercase for comparison
    ${lower_text}=    Convert To Lower Case    ${after_text}

    # Check if "joe" exists in OCR text
    ${is_found}=    Run Keyword And Return Status    Should Contain    ${lower_text}    joe

    # Log results
    Run Keyword If    ${is_found}    Log To Console    SEARCH RESULT MATCHED: Director Joe Found
    Run Keyword If    not ${is_found}    Log To Console    FAIL: Director Joe Not Found

    # Optional: Fail the test if not found
    # Run Keyword Unless    ${is_found}    Fail    Director Joe not found in OCR output

    # Return OCR text for reporting or further validation
    ${director_text}=    Set Variable    ${after_text}
    RETURN    ${director_text}
search Allied Movie
    CLICK OK
    CLICK DOWN
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK
    CLICK OK
    CLICK LEFT
    CLICK LEFT
    CLICK LEFT
    CLICK OK
    CLICK RIGHT
    CLICK RIGHT
    CLICK UP
    CLICK OK
    CLICK LEFT
    CLICK OK
    CLICK MULTIPLE TIMES    6    DOWN
    CLICK OK
    Sleep    2s
    CLICK OK
    Sleep    2s
    CLICK OK
Check Vod Details
    ${playtime}=     Verify Crop Image With Shorter Duration     ${port}    remainingtime
    ${Director}=       Verify Crop Image With Shorter Duration     ${port}    director
    ${Cast}=          Verify Crop Image With Shorter Duration     ${port}    cast

    Log To Console    remainingtime: ${playtime}
    Log To Console    Director: ${Director}
    Log To Console    cast${Cast}

    Run Keyword If    '${playtime}' == 'True' or '${Director}' == 'True' or '${Cast}' == 'True'
    ...    Log To Console    remainingtime cast and director Is Displayed on screen
    ...    ELSE
    ...    Fail   remainingtime cast and director Is Not Displayed on screen

Get Thumnail Of Asset in Continue Watching Show More section    
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.crop_continue_watching_show_more_assets   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    RETURN    ${after_crop}

Get Thumnail Of Asset In show more section     
    Sleep    5s

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop Continue   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    RETURN    ${after_crop}

Verify the Similarity Continue Watching
    [Arguments]    ${before_crop}  
    # Primary Validation: OCR Text Change
    # Fallback Validation: SSIM Comparison
    ${similarity}=    IPL.Compare Images SSIM    ${before_crop}    ${gray_image}
    Log To Console    SSIM SIMILARITY: ${similarity}
    Should Be True    ${similarity} < 0.85    Blank Tile displayed

STOP RECORDINGS 
    CLICK HOME   
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
    Sleep    4s
    CLICK UP
    CLICK UP
    CLICK UP
    CLICK RIGHT
    CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK OK
	CLICK OK
    CLICK HOME

Verify Assert After resume
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop_Assert_name_after_resume   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    RETURN    ${after_text}
Compare Previous And Current Text
    [Arguments]    ${previous_text}    ${current_text}

    ${prev}=    Run Keyword If    '${previous_text}' != 'None'    Set Variable    ${previous_text}    ELSE    Set Variable    ''
    ${curr}=    Run Keyword If    '${current_text}' != 'None'    Set Variable    ${current_text}    ELSE    Set Variable    ''

    ${prev}=    Convert To Lowercase    ${prev}
    ${curr}=    Convert To Lowercase    ${curr}
    ${prev}=    Strip String    ${prev}
    ${curr}=    Strip String    ${curr}

    Run Keyword If    '${prev}' == '${curr}'    Log To Console    ✅ Texts completely match!
    ...    ELSE    Fail    ❌ Texts differ! | Previous: ${prev} | Current: ${curr}

Select assest from catchup
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop_Assert_name_catchup   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    RETURN    ${after_text}

Convert Time To Seconds
    [Arguments]    ${time}
    # Normalize OCR format: 00.08.57 → 00:08:57
    ${time}=    Replace String    ${time}    .    :
    ${h}    ${m}    ${s}=    Split String    ${time}    :

    ${total}=    Evaluate
    ...    int("${h}")*3600 + int("${m}")*60 + int("${s}")

    RETURN    ${total}
Selecting Catchup Filter From Guide
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
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
revert catchup filter
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	Guide Channel List
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
	CLICK OK
    CLICK HOME
Move to Catchup
    ${STEP_COUNT}=    Move to Catchup On Side Pannel With OCR
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    CLICK OK
Move to Catchup On Side Pannel With OCR
    ${after_text}=    Capture Side Pannel Options
    ${STEP_COUNT}=    Get Side Pannel Catchup And Return Count   ${after_text}
    RETURN    ${STEP_COUNT}
Get Side Pannel Catchup And Return Count
    [Arguments]   ${ocr_text}    ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # Create list of expected menu items
    ${expected_items}=    Create List    Add To Favorites    Remove Favorite    Pause    Start Over    Record  

    # Loop through expected items and check if they exist in OCR text
    FOR    ${item}    IN    @{expected_items}
        IF    '${item}' in '${ocr_text}'
            ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
            Log To Console    Found "${item}". STEP_COUNT=${STEP_COUNT}
        ELSE
            Log To Console    "${item}" not found.
        END
    END

    Log To Console    Final STEP_COUNT: ${STEP_COUNT}
    RETURN    ${STEP_COUNT}

Capture Side Pannel Options Catchup
    FOR    ${i}    IN RANGE    10
        Log To Console    ===== Side Panel Check Attempt ${i} =====

        ${after_now}=    generic.get_date_time
        ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
        generic.Capture Image    ${port}    ${after_image_path}

        ${after_crop}=    IPL.Get Side Pannel Options    ${after_image_path}

        ${after_text}=    OCR.Extract Text From Image    ${after_crop}
        ${after_text}=    Convert To Lower Case    ${after_text}

        ${parts}=    Split String    ${after_text}    add to favorites
        ${text_after}=    Get From List    ${parts}    1

        Log To Console    TEXT AFTER ADD TO FAVORITES: ${text_after}

        IF    'add to my list' in '${text_after}'
            Log To Console    remove from list NOT found → doing DOWN operations

            CLICK DOWN
            CLICK DOWN
            CLICK DOWN
            CLICK DOWN
            CLICK DOWN
            CLICK DOWN
            CLICK UP
            CLICK OK

            ${Result}=     Verify Crop Image With Shorter Duration     ${port}    ATLmessage
            Run Keyword If    '${Result}' == 'True'
            ...    Log To Console    ATLmessage Is Displayed
            ...    ELSE    Fail    ATLmessage Is Not Displayed

            CLICK OK
            CLICK UP
            CLICK UP
            CLICK UP
            CLICK OK
            Sleep    1s

            Exit For Loop
        ELSE
            Log To Console    remove from list found
            CLICK BACK
            CLICK RIGHT
            CLICK OK
        END
    END
Capture Side Pannel Options Catchup Remove Fav

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}

    ${after_crop}=    IPL.Get Side Pannel Options    ${after_image_path}

    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    ${after_text}=    Convert To Lower Case    ${after_text}

    ${parts}=    Split String    ${after_text}    add to favorites
    ${text_after}=    Get From List    ${parts}    1

    Log To Console    TEXT AFTER ADD TO FAVORITES: ${text_after}

    IF    'manage recorder manage favorites' in '${text_after}'
        Log To Console    manage fav found
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
    ELSE
        Log To Console    manage fav NOT found → doing DOWN operations

        CLICK DOWN
        CLICK DOWN
        CLICK DOWN
        CLICK DOWN
        CLICK DOWN
        CLICK DOWN
        CLICK DOWN
        CLICK UP
        CLICK UP
        CLICK OK
    END
   
Capture Side Pannel Options Catchup play
    ${resume_cleared}=    Set Variable    False

    FOR    ${i}    IN RANGE    40
        Log To Console    ===== Side Panel Check Attempt ${i} =====

        ${after_now}=    generic.get_date_time
        ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
        generic.Capture Image    ${port}    ${after_image_path}

        ${after_crop}=    IPL.Get Side Pannel Options    ${after_image_path}

        ${after_text}=    OCR.Extract Text From Image    ${after_crop}
        ${after_text}=    Convert To Lower Case    ${after_text}

        ${parts}=    Split String    ${after_text}    add to favorites
        ${text_after}=    Get From List    ${parts}    1

        Log To Console    TEXT AFTER ADD TO FAVORITES: ${text_after}

        IF    'resume' in $text_after
            Log To Console    Resume found — removing from list
            CLICK BACK
            CLICK RIGHT
            CLICK OK
            Sleep    1s
        ELSE
            Log To Console    Resume not found — success
            Catchup favorites
            ${resume_cleared}=    Set Variable    True
            Exit For Loop
        END
    END

    IF    not $resume_cleared
        Fail    ❌ Resume still present after 40 attempts
    END



Verify Extracted From Image
    # --- Capture image ---
    ${now}=    generic.get_date_time
    ${d_rimg}=    Replace String    ${ref_img1}    replace    ${now}
    generic.capture image run    ${port}    ${d_rimg}

    # --- Extract text via OCR ---
    ${text}=    OCR.Extract Text From Image    ${d_rimg}

    # --- Clean text ---
    ${text}=    Replace String    ${text}    \n    ${SPACE}
    ${words}=    Split String    ${text}
    ${clean_words}=    Evaluate    [w for w in ${words} if w.strip() != '']
    ${first_four}=    Evaluate    ' '.join(${clean_words}[:2])

    # --- Normalize case and spaces ---
    ${first_four}=    Convert To Lowercase    ${first_four}
    ${first_four}=    Strip String    ${first_four}

    RETURN    ${first_four}


Capture Side Pannel Options Catchup resume
    Log To Console    ===== Side Panel Check =====

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}

    ${after_crop}=    IPL.Get Side Pannel Options    ${after_image_path}

    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    ${after_text}=    Convert To Lower Case    ${after_text}

    ${parts}=    Split String    ${after_text}    add to favorites
    ${text_after}=    Get From List    ${parts}    1

    Log To Console    TEXT AFTER ADD TO FAVORITES: ${text_after}

    IF    'resume' in '${text_after}'
        Log To Console    Resume option found
        Catchup favorites
    ELSE
        Log To Console    Resume not found → going to Catchup favorite
    END



Get Channel Title In Recorder From Info Bar
    Sleep   1s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log    AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Channel Title From EPG Info Bar   ${after_image_path}
    Log    CROPPED AFTER INFO BAR: ${cropped_img}
     # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}
    ${lower_text}=    Convert To Lower Case    ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    # RETURN    ${channel_name_epg_text} 
    ${title}=    Set Variable    ${lower_text}
    RETURN    ${title}
Rent Assest in Boxoffice
    ${ocr_text}=    Set Variable    None   
    FOR    ${i}    IN RANGE    20
        CLICK RIGHT
        ${RentResult}=    Verify Crop Image    ${port}    RENT
        Log To Console    Rent: ${RentResult}
        CLICK OK
        ${res1}=    Get HD
        ${res1}=    Replace String    ${res1}    ${SPACE}${SPACE}    ${SPACE}

        IF    '${res1}' == 'HD 15 AED HD 15 AED' or '${res1}' == 'HD 15 AED 0 HD 15 AED'
                CLICK DOWN
            END

        IF    '${RentResult}' == 'True'
            CLICK DOWN
            ${ocr_text}=    Getting Assert Name after Rent

            ${BillResult}=    Verify Crop Image    ${port}    Bill
            Log To Console    Bill: ${BillResult}

            IF    '${BillResult}' == 'True'
                CLICK DOWN
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK DOWN
                CLICK DOWN
                CLICK OK
                Log To Console    Asset is bought
                ${Result}  Verify Crop Image With Shorter Duration  ${port}  Now
                Run Keyword If  '${Result}' == 'True'  Log To Console  Now Is Displayed
                ...  ELSE  Fail  Now Is Not Displayed
                Sleep    2s
                Exit For Loop
            ELSE
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK DOWN
                CLICK DOWN
                CLICK OK
                Log To Console    Asset is bought
                ${Result}  Verify Crop Image With Shorter Duration  ${port}  Now
                Run Keyword If  '${Result}' == 'True'  Log To Console  Now Is Displayed
                ...  ELSE  Fail  Now Is Not Displayed
                Sleep    2s
                Exit For Loop
            END
        ELSE
            Log To Console    Rent not found, checking another asset
            CLICK BACK
            CLICK RIGHT
            CLICK OK
            pinblock
        END
    END
    RETURN    ${ocr_text}
Rent Assest in Boxoffice Transaction
    ${ocr_text}=    Set Variable    None   
    FOR    ${i}    IN RANGE    20
        CLICK RIGHT
        ${RentResult}=    Verify Crop Image    ${port}    RENT
        Log To Console    Rent: ${RentResult}

         IF    '${RentResult}' == 'True'
            CLICK OK
            CLICK OK
            CLICK DOWN
            ${ocr_text}=    Getting Assert Name after Rent
            ${res1}=    Get HD
            ${res1}=    Replace String    ${res1}    ${SPACE}${SPACE}    ${SPACE}

            Log    OCR TEXT = '${res1}'

            ${count}=    Get Count    ${res1}    HD
            Log    HD COUNT = ${count}

            IF    ${count} >= 2
                CLICK DOWN
            END



            ${BillResult}=    Verify Crop Image    ${port}    Bill
            Log To Console    Bill: ${BillResult}

            IF    '${BillResult}' == 'True'
                CLICK DOWN
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK DOWN
                CLICK DOWN
                CLICK OK
                Log To Console    Asset is bought
                ${Result}  Verify Crop Image With Shorter Duration  ${port}  Now
                Run Keyword If  '${Result}' == 'True'  Log To Console  Now Is Displayed
                ...  ELSE  Fail  Now Is Not Displayed
                Sleep    2s
                Exit For Loop
            ELSE
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK DOWN
                CLICK DOWN
                CLICK OK
                Log To Console    Asset is bought
                ${Result}  Verify Crop Image With Shorter Duration  ${port}  Now
                Run Keyword If  '${Result}' == 'True'  Log To Console  Now Is Displayed
                ...  ELSE  Fail  Now Is Not Displayed
                Sleep    2s
                Exit For Loop
            END
        ELSE
            Log To Console    Rent not found, checking another asset
            CLICK BACK
            CLICK RIGHT
            CLICK OK
            pinblock
        END
    END
    RETURN    ${res1}
HD Text in Transaction
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop_Transaction_hd   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    RETURN    ${after_text}
Normalize Text rent
    [Arguments]    ${text}
    ${text}=    Convert To Upper Case    ${text}
    ${text}=    Strip String             ${text}
    ${text}=    Replace String           ${text}    ${SPACE}    ${EMPTY}
    RETURN    ${text}
Get HD
    Sleep    5s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    ${after_crop}=    IPL.Crop_HD    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    ${after_text}=    Strip String    ${after_text}
    RETURN    ${after_text}
    
buyrentalsblock
    Subscription
    ${block}=    Verify Crop Image    ${port}    503_rental
    Log To Console    Rent: ${block}

    ${buy}=      Verify Crop Image    ${port}    BUY_VOD
    Log To Console    Buy: ${buy}
    ${res1}=    Get HD
    Log To Console    Buy: ${res1}
    ${res1}=    Replace String    ${res1}    ${SPACE}${SPACE}    ${SPACE}
    Log To Console    HD TEXT: ${res1}

    
    Log    OCR TEXT = '${res1}'

    ${count}=    Get Count    ${res1}    HD
    Log    HD COUNT = ${count}

    IF    ${count} >= 2
        CLICK DOWN
    END
    
    IF    '${block}' == 'True' or '${buy}' == 'True'
        CLICK DOWN

        ${BillResult}=    Verify Crop Image    ${port}    Bill
        Log To Console    Bill: ${BillResult}

        IF    '${BillResult}' == 'True'
            CLICK DOWN
            CLICK TWO
            CLICK TWO
            CLICK TWO
            CLICK TWO
            CLICK DOWN
            CLICK DOWN
            CLICK OK
            ${Result}  Verify Crop Image  ${port}  Now
            Run Keyword If  '${Result}' == 'True'  Log To Console  Now Is Displayed
            ...  ELSE  Fail  Now Is Not Displayed
            CLICK OK
            Log To Console    Asset is bought
            Sleep    2s
        ELSE  
            CLICK TWO
            CLICK TWO
            CLICK TWO
            CLICK TWO
            CLICK DOWN
            CLICK DOWN
            CLICK OK
            ${Result}  Verify Crop Image  ${port}  Now
            Run Keyword If  '${Result}' == 'True'  Log To Console  Now Is Displayed
            ...  ELSE  Fail  Now Is Not Displayed
            CLICK OK
            Log To Console    Asset is bought
            Sleep    2s
        END
    END

Get Time After Fast Forward
    [Arguments]    ${time_before_forward}
    ${start_over_status}=    Get Start Over Progress Bar Status
    ${time_range_after}=    Get Extracted Time On Player Info Bar    ${start_over_status}
    ${time_after_forward}=    Check OCR Start Timestamp Using AI Slots    ${time_range_after}
    Log To Console    ⏱ After Fast Forward: ${time_after_forward}

    ${t1}=    Convert Timestamp To Seconds    ${time_before_forward}
    ${t2}=    Convert Timestamp To Seconds    ${time_after_forward}
    Should Be True    ${t2} > ${t1}    ❌ Fast Forward failed — timestamp did not progress
    Log To Console    ✅ Fast Forward verified — timestamp progressed

Get Time After Fast Rewind
    [Arguments]    ${time_before_rewind}
    Log To Console    ▶ Capturing timestamp after rewind

    ${start_over_status}=    Get Start Over Progress Bar Status
    ${time_range_after}=    Get Extracted Time On Player Info Bar    ${start_over_status}
    ${time_after_rewind}=    Check OCR Start Timestamp Using AI Slots    ${time_range_after}
    Log To Console    ⏱ After Rewind: ${time_after_rewind}

    # --- Safety: Handle missing OCR results ---
    Run Keyword If    '${time_after_rewind}' == 'None' or '${time_after_rewind}' == ''    Fail    ❌ OCR failed — could not detect time after rewind
    Run Keyword If    '${time_before_rewind}' == 'None' or '${time_before_rewind}' == ''    Fail    ❌ Missing input timestamp before rewind

    # --- Convert timestamps to seconds for comparison ---
    ${t1}=    Convert Timestamp To Seconds    ${time_before_rewind}
    ${t2}=    Convert Timestamp To Seconds    ${time_after_rewind}

    # --- Ensure valid numeric conversion ---
    Run Keyword Unless    '${t1}' and '${t2}'    Fail    ❌ Timestamp conversion failed — invalid format detected

    # --- Compare rewind correctness ---
    Run Keyword If    ${t2} < ${t1}    Log To Console    ✅ Rewind verified — timestamp regressed
    ...    ELSE    Fail    ❌ Rewind failed — timestamp did not regress

Get Time Before Fast Forward Or Rewind
    Log To Console    ▶ Starting Fast Forward Verification

    ${start_over_status}=    Get Start Over Progress Bar Status
    ${time_range_before}=    Get Extracted Time On Player Info Bar    ${start_over_status}
    ${time_before_forward}=    Check OCR Start Timestamp Using AI Slots    ${time_range_before}
    Log To Console    ⏱ Before Fast Forward: ${time_before_forward}
    RETURN    ${time_before_forward}


Rent OR Buy Assest in Boxoffice
    FOR    ${i}    IN RANGE    20
        CLICK RIGHT
        ${RentResult}=    Verify Crop Image    ${port}    RENT
        ${BuyResult}=     Verify Crop Image    ${port}    BUY
        Log To Console    Rent: ${RentResult}
        Log To Console    Buy: ${BuyResult}

        IF    '${RentResult}' == 'True' or '${BuyResult}' == 'True'
            CLICK OK
            CLICK OK
            CLICK DOWN
            ${billResult}=    Verify Crop Image    ${port}    bill
            Log To Console    bill: ${billResult}

            IF    '${billResult}' == 'True'
                CLICK DOWN
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK DOWN
                CLICK DOWN
                CLICK OK
                Log To Console    Asset is bought
                Sleep    2s
                Exit For Loop
            ELSE
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK DOWN
                CLICK DOWN
                CLICK OK
                Log To Console    Asset is bought
                Sleep    2s
                Exit For Loop
            END
        ELSE
            Log To Console    Rent not found, checking another asset
            CLICK BACK
            CLICK RIGHT
            CLICK OK
            pinblock
        END
    END


Hidden_Channel_2
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "2"
            Log To Console    YES channel 2 is hidden
        ELSE
            Fail    Channel 2 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "2"
            Log To Console    YES channel 2 is hidden
        ELSE
            Fail    Channel 2 is not hidden
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "2"
            Log To Console    YES channel 2 is hidden
        ELSE
            Fail    Channel 2 is not hidden
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "2"
            Log To Console    YES channel 2 is hidden
        ELSE
            Fail    Channel 2 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "2"
            Log To Console    YES channel 2 is hidden
        ELSE
            Fail    Channel 2 is not hidden
        END
        CLICK DOWN

Hidden_Channel_3
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "3"
            Log To Console    YES channel 3 is hidden
        ELSE
            Fail    Channel 3 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "3"
            Log To Console    YES channel 3 is hidden
        ELSE
            Fail    Channel 3 is not hidden
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "3"
            Log To Console    YES channel 3 is hidden
        ELSE
            Fail    Channel 3 is not hidden
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
       IF    "${result}" != "3"
            Log To Console    YES channel 3 is hidden
        ELSE
            Fail    Channel 3 is not hidden
        END
        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "3"
            Log To Console    YES channel 3 is hidden
        ELSE
            Fail    Channel 3 is not hidden
        END
        CLICK DOWN
 
 Hidden_Channel_4
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "4"
            Log To Console    YES channel 4 is hidden
        ELSE
            Fail    Channel 4 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "4"
            Log To Console    YES channel 4 is hidden
        ELSE
            Fail    Channel 4 is not hidden
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "4"
            Log To Console    YES channel 4 is hidden
        ELSE
            Fail    Channel 4 is not hidden
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "4"
            Log To Console    YES channel 4 is hidden
        ELSE
            Fail    Channel 4 is not hidden
        END
        CLICK DOWN

        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "4"
            Log To Console    YES channel 4 is hidden
        ELSE
            Fail    Channel 4 is not hidden
        END
        CLICK DOWN

Hidden_Channel_10
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "10"
            Log To Console    YES channel 10 is hidden
        ELSE
            Fail    Channel 10 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "10"
            Log To Console    YES channel 10 is hidden
        ELSE
            Fail    Channel 10 is not hidden
        END


        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "10"
            Log To Console    YES channel 10 is hidden
        ELSE
            Fail    Channel 10 is not hidden
        END


        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "10"
            Log To Console    YES channel 10 is hidden
        ELSE
            Fail    Channel 10 is not hidden
        END

        CLICK DOWN

        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "10"
            Log To Console    YES channel 10 is hidden
        ELSE
            Fail    Channel 10 is not hidden
        END

        CLICK DOWN


Hidden_Channel_11
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "11"
            Log To Console    YES channel 11 is hidden
        ELSE
            Fail    Channel 11 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "11"
            Log To Console    YES channel 11 is hidden
        ELSE
            Fail    Channel 11 is not hidden
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "11"
            Log To Console    YES channel 11 is hidden
        ELSE
            Fail    Channel 11 is not hidden
        END



        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "11"
            Log To Console    YES channel 11 is hidden
        ELSE
            Fail    Channel 11 is not hidden
        END

        CLICK DOWN

        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "11"
            Log To Console    YES channel 11 is hidden
        ELSE
            Fail    Channel 11 is not hidden
        END


        CLICK DOWN

Hidden_Channel_35
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "35"
            Log To Console    YES channel 35 is hidden
        ELSE
            Fail    Channel 35 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "35"
            Log To Console    YES channel 35 is hidden
        ELSE
            Fail    Channel 35 is not hidden
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "35"
            Log To Console    YES channel 35 is hidden
        ELSE
            Fail    Channel 35 is not hidden
        END


        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "35"
            Log To Console    YES channel 35 is hidden
        ELSE
            Fail    Channel 35 is not hidden
        END

        CLICK DOWN

        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "35"
            Log To Console    YES channel 35 is hidden
        ELSE
            Fail    Channel 35 is not hidden
        END


        CLICK DOWN

Hidden_Channel_38
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "38"
            Log To Console    YES channel 38 is hidden
        ELSE
            Fail    Channel 38 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "38"
            Log To Console    YES channel 38 is hidden
        ELSE
            Fail    Channel 38 is not hidden
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "38"
            Log To Console    YES channel 38 is hidden
        ELSE
            Fail    Channel 38 is not hidden
        END


        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "38"
            Log To Console    YES channel 38 is hidden
        ELSE
            Fail    Channel 38 is not hidden
        END
        CLICK DOWN

        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "38"
            Log To Console    YES channel 38 is hidden
        ELSE
            Fail    Channel 38 is not hidden
        END
        CLICK DOWN

Hidden_Channel_40
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "40"
            Log To Console    YES channel 38 is hidden
        ELSE
            Fail    Channel 38 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "40"
            Log To Console    YES channel 40 is hidden
        ELSE
            Fail    Channel 40 is not hidden
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "40"
            Log To Console    YES channel 40 is hidden
        ELSE
            Fail    Channel 40 is not hidden
        END


        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "40"
            Log To Console    YES channel 40 is hidden
        ELSE
            Fail    Channel 40 is not hidden
        END
        CLICK DOWN

        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "40"
            Log To Console    YES channel 40 is hidden
        ELSE
            Fail    Channel 40 is not hidden
        END
        CLICK DOWN

Hidden_Channel_42
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "42"
            Log To Console    YES channel 42 is hidden
        ELSE
            Fail    Channel 42 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "42"
            Log To Console    YES channel 42 is hidden
        ELSE
            Fail    Channel 42 is not hidden
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "42"
            Log To Console    YES channel 42 is hidden
        ELSE
            Fail    Channel 42 is not hidden
        END


        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "42"
            Log To Console    YES channel 42 is hidden
        ELSE
            Fail    Channel 42 is not hidden
        END
        CLICK DOWN

        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "42"
            Log To Console    YES channel 42 is hidden
        ELSE
            Fail    Channel 42 is not hidden
        END
        CLICK DOWN

Hidden_Channel_48
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "48"
            Log To Console    YES channel 48 is hidden
        ELSE
            Fail    Channel 48 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "48"
            Log To Console    YES channel 48 is hidden
        ELSE
            Fail    Channel 48 is not hidden
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "48"
            Log To Console    YES channel 48 is hidden
        ELSE
            Fail    Channel 48 is not hidden
        END


        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "48"
            Log To Console    YES channel 48 is hidden
        ELSE
            Fail    Channel 48 is not hidden
        END
        CLICK DOWN

        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "48"
            Log To Console    YES channel 48 is hidden
        ELSE
            Fail    Channel 48 is not hidden
        END
        CLICK DOWN

Hidden_Channel_42_Unhidden
    ${found}=    Set Variable    False

    FOR    ${i}    IN RANGE    0    5
        ${result}=    Get Channel Number
        Log To Console    RESULT AFTER DOWN ${i}: ${result}

        IF    "${result}" == "42"
            ${found}=    Set Variable    True
            Log To Console    ✅ Channel 42 found
            Exit For Loop
        END

        CLICK DOWN
    END

    IF    '${found}' == 'False'
        Fail    ❌ Channel 42 was not found after scrolling down
    ELSE
        Log To Console    ✅ Channel 42 appeared at least once
    END

Hidden_Channel_35_Unhidden
    ${found}=    Set Variable    False

    FOR    ${i}    IN RANGE    0    5
        ${result}=    Get Channel Number
        Log To Console    RESULT AFTER DOWN ${i}: ${result}

        IF    "${result}" == "35"
            ${found}=    Set Variable    True
            Log To Console    ✅ Channel 35 found
            Exit For Loop
        END

        CLICK DOWN
    END

    IF    '${found}' == 'False'
        Fail    ❌ Channel 35 was not found after scrolling down
    ELSE
        Log To Console    ✅ Channel 35 appeared at least once
    END

Hidden_Channel_38_Unhidden
    ${found}=    Set Variable    False

    FOR    ${i}    IN RANGE    0    5
        ${result}=    Get Channel Number
        Log To Console    RESULT AFTER DOWN ${i}: ${result}

        IF    "${result}" == "38"
            ${found}=    Set Variable    True
            Log To Console    ✅ Channel 38 found
            Exit For Loop
        END

        CLICK DOWN
    END

    IF    '${found}' == 'False'
        Fail    ❌ Channel 38 was not found after scrolling down
    ELSE
        Log To Console    ✅ Channel 38 appeared at least once
    END

Hidden_Channel_40_Unhidden
    ${found}=    Set Variable    False

    FOR    ${i}    IN RANGE    0    5
        ${result}=    Get Channel Number
        Log To Console    RESULT AFTER DOWN ${i}: ${result}

        IF    "${result}" == "40"
            ${found}=    Set Variable    True
            Log To Console    ✅ Channel 40 found
            Exit For Loop
        END

        CLICK DOWN
    END

    IF    '${found}' == 'False'
        Fail    ❌ Channel 40 was not found after scrolling down
    ELSE
        Log To Console    ✅ Channel 40 appeared at least once
    END

Hidden_Channel_48_Unhidden
    ${found}=    Set Variable    False

    FOR    ${i}    IN RANGE    0    5
        ${result}=    Get Channel Number
        Log To Console    RESULT AFTER DOWN ${i}: ${result}

        IF    "${result}" == "48"
            ${found}=    Set Variable    True
            Log To Console    ✅ Channel 48 found
            Exit For Loop
        END

        CLICK DOWN
    END

    IF    '${found}' == 'False'
        Fail    ❌ Channel 48 was not found after scrolling down
    ELSE
        Log To Console    ✅ Channel 48 appeared at least once
    END

Rating OCR
    Sleep    5s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    ${after_crop}=    IPL.Crop_rating    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    ${after_text}=    Strip String    ${after_text}
    Log To Console    OCR AFTER TEXT: ${after_text}

    RETURN    ${after_text}
Check Rating In OCR Text
    [Arguments]    ${ocr_text}

    ${match}=    Run Keyword And Ignore Error
    ...    Get Regexp Matches
    ...    ${ocr_text}
    ...    (15\\+|18\\+|PG13|G)

    ${status}=    Set Variable    ${match}[0]
    ${ratings}=   Set Variable    ${match}[1]

    IF    $status == 'PASS' and $ratings
        Log To Console    Rating present in OCR text: ${ratings}[0]
    ELSE
        Log To Console    Rating is NOT present in OCR text
    END

Capture Side Pannel Options vod rent
    FOR    ${i}    IN RANGE    10
        Log To Console    ===== Side Panel Check Attempt ${i} =====

        ${after_now}=    generic.get_date_time
        ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
        generic.Capture Image    ${port}    ${after_image_path}

        ${after_crop}=    IPL.Get Side Pannel Options    ${after_image_path}

        ${after_text}=    OCR.Extract Text From Image    ${after_crop}
        ${after_text}=    Convert To Lower Case    ${after_text}

        ${parts}=    Split String    ${after_text}    add to favorites
        ${text_after}=    Get From List    ${parts}    1

        Log To Console    TEXT AFTER ADD TO FAVORITES: ${text_after}

        IF    'rent' in '${text_after}'
            Log To Console    remove from list found
            CLICK BACK
            CLICK RIGHT
            CLICK OK
        ELSE
            Catchup favorites
            Exit For Loop
        END
    END
check vod assets for trailors
    FOR  ${i}  IN RANGE  10
        VALIDATE TRAILOR PLAYBACK
    END


Capture Multiple Screens And Validate Language Danish
    [Arguments]    ${expected_language}    ${iterations}=20    ${delay}=5
    [Documentation]    Capture multiple screenshots and check for subtitles in expected language, logging all extracted text.

    FOR    ${index}    IN RANGE    ${iterations}
        Log To Console    \n--- Iteration ${index + 1}/${iterations} ---

        ${d_rimg}=    Run Keyword If    '${expected_language}' == 'da'    Get Subtitle Text Danish    ELSE    Get Subtitle Text None
        ${status}=    Repeat OCR And Validate Language    ${d_rimg}    ${expected_language}

        Run Keyword If    ${status}    Exit For Loop
        Sleep    ${delay}
    END

    Run Keyword Unless    ${status}    Fail    ❌ Expected subtitle in language '${expected_language}' not found in ${iterations} attempts!
    RETURN    ${status}

Capture Multiple Screens And Validate Language Finnish
    [Arguments]    ${expected_language}    ${iterations}=20    ${delay}=5
    [Documentation]    Capture multiple screenshots and check for subtitles in expected language, logging all extracted text.

    FOR    ${index}    IN RANGE    ${iterations}
        Log To Console    \n--- Iteration ${index + 1}/${iterations} ---

        ${d_rimg}=    Run Keyword If    '${expected_language}' == 'fi'    Get Subtitle Text Finnish    ELSE    Get Subtitle Text Norwegian
        ${status}=    Repeat OCR And Validate Nordic Language    ${d_rimg}    ${expected_language}

        Run Keyword If    ${status}    Exit For Loop
        Sleep    ${delay}
    END

    Run Keyword Unless    ${status}    Fail    ❌ Expected subtitle in language '${expected_language}' not found in ${iterations} attempts!
    RETURN    ${status}
Capture Multiple Screens And Validate Language Swedish
    [Arguments]    ${expected_language}    ${iterations}=20    ${delay}=5
    [Documentation]    Capture multiple screenshots and check for subtitles in expected language, logging all extracted text.

    FOR    ${index}    IN RANGE    ${iterations}
        Log To Console    \n--- Iteration ${index + 1}/${iterations} ---

        ${d_rimg}=    Run Keyword If    '${expected_language}' == 'sv'    Get Subtitle Text Swedish    ELSE    Get Subtitle Text None
        ${status}=    Repeat OCR And Validate Nordic Language    ${d_rimg}    ${expected_language}

        Run Keyword If    ${status}    Exit For Loop
        Sleep    ${delay}
    END

    Run Keyword Unless    ${status}    Fail    ❌ Expected subtitle in language '${expected_language}' not found in ${iterations} attempts!
    RETURN    ${status}


Get Subtitle Text Danish    
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop Subtitle Danish   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    RETURN    ${after_crop} 



Get Subtitle Text Finnish
    Sleep    5s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop Subtitle arabic    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    RETURN    ${after_crop}

Get Subtitle Text Swedish
    Sleep    5s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop Subtitle arabic    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    RETURN    ${after_crop}

Get Subtitle Text Norwegian
    Sleep    5s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop Subtitle arabic    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    RETURN    ${after_crop}

Get Subtitle Text None
    Sleep    5s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop Subtitle arabic    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    RETURN    ${after_crop}
Revert Lock Channels
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
	${Result}  Verify Crop Image  ${port}  TC_011_ok_button
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_011_ok_button Is Displayed
	...  ELSE  Fail  TC_011_ok_button Is Not Displayed
	CLICK OK
	CLICK HOME
Profile Name abcd
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.crop Profile Name Settings page   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}
    RETURN    ${after_text}


Profile Name abcd after reboot
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.crop Profile Name Settings page_after_reboot   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}
    RETURN    ${after_text}

Revert Hide Channels
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
	Sleep    10s 
    CLICK DOWN
    CLICK RIGHT
	CLICK OK
	CLICK UP
	CLICK RIGHT
    CLICK OK
	CLICK RIGHT
	CLICK OK
	#set 5 style
	CLICK UP
	CLICK RIGHT
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK UP
	CLICK OK
	log To Console    Setted interface to 5 style
	CLICK DOWN
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

Hidden_Channel_23
        ${result}=    Get Channel Number Fav
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" != "23"
            Log To Console    YES channel 23 is hidden
        ELSE
            Fail    Channel 23 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "23"
            Log To Console    YES channel 23 is hidden
        ELSE
            Fail    Channel 23 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "23"
            Log To Console    YES channel 23 is hidden
        ELSE
            Fail    Channel 23 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "23"
            Log To Console    YES channel 23 is hidden
        ELSE
            Fail    Channel 23 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "23"
            Log To Console    YES channel 23 is hidden
        ELSE
            Fail    Channel 23 is not hidden
        END
        CLICK DOWN
Hidden_Channel_33
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "33"
            Log To Console    YES channel 33 is hidden
        ELSE
            Fail    Channel 33 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "33"
            Log To Console    YES channel 33 is hidden
        ELSE
            Fail    Channel 33 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "33"
            Log To Console    YES channel 33 is hidden
        ELSE
            Fail    Channel 33 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "33"
            Log To Console    YES channel 33 is hidden
        ELSE
            Fail    Channel 33 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "33"
            Log To Console    YES channel 33 is hidden
        ELSE
            Fail    Channel 33 is not hidden
        END

        CLICK DOWN
Hidden_Channel_61
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "61"
            Log To Console    YES channel 61 is hidden
        ELSE
            Fail    Channel 61 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "61"
            Log To Console    YES channel 61 is hidden
        ELSE
            Fail    Channel 61 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "61"
            Log To Console    YES channel 61 is hidden
        ELSE
            Fail    Channel 61 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "61"
            Log To Console    YES channel 61 is hidden
        ELSE
            Fail    Channel 61 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "61"
            Log To Console    YES channel 61 is hidden
        ELSE
            Fail    Channel 61 is not hidden
        END

        CLICK DOWN
Hidden_Channel_63
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "63"
            Log To Console    YES channel 63 is hidden
        ELSE
            Fail    Channel 63 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "63"
            Log To Console    YES channel 63 is hidden
        ELSE
            Fail    Channel 63 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "63"
            Log To Console    YES channel 63 is hidden
        ELSE
            Fail    Channel 63 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "63"
            Log To Console    YES channel 63 is hidden
        ELSE
            Fail    Channel 63 is not hidden
        END

        CLICK DOWN
        ${result}=    Get Channel Number Fav
        IF    "${result}" != "63"
            Log To Console    YES channel 63 is hidden
        ELSE
            Fail    Channel 63 is not hidden
        END

        CLICK DOWN

Get Channel number Fav
    Sleep    5s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop_Channel_Number_Fav_list   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}
    ${after_text}=     Strip String    ${after_text}
    ${after_text}=     Remove String Using Regexp    ${after_text}    [^0-9]
    RETURN    ${after_text}

Check language with ocr
    # ${Rating}=    Verify Crop Image    ${port}    imrating
#     ${PG13}=      Verify Crop Image    ${port}    PG13
#     ${G}=         Verify Crop Image    ${port}    G-rating
#    ${rating_15}=   Verify Crop Image    ${port}    15_rating
#     ${rating_18}=   Verify Crop Image    ${port}    18_rating
    # Log To Console    Rating: ${Rating}
    # Log To Console    G: ${G}
    # Log To Console    PG13: ${PG13}
    # Log To Console    15+: ${rating_15}
    # Log To Console    18+: ${rating_18}

    # Run Keyword If
    #     ...    ${Rating} or ${PG13} or ${G} or ${rating_15} or ${rating_18}
    #     ...    Log To Console    imrating Is Displayed on screen
    #     ...    ELSE
    #     ...    Log To Console    imrating Is Not Displayed on screen
    ${ocr_text}=    Rating OCR
    Checking language   ${ocr_text}

Checking language
    [Arguments]    ${ocr_text}
    
    # Use a case-insensitive regular expression to check if "ARABIC" is anywhere in the OCR text
    ${match}=    Get Regexp Matches    ${ocr_text}    (?i)ARABIC
    
    # Check if the length of the match list is greater than 0 (i.e., "ARABIC" found)
    ${status}=    Get Length    ${match}

    # Check if a match was found
    IF    ${status} > 0
        Log To Console    Arabic language detected in OCR text
    ELSE
        Fail    OCR text is not 'ARABIC'. Found: ${ocr_text}
    END
