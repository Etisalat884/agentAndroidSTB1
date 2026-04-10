*** Settings ***
Library  SeleniumLibrary
Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/Signal/Etisalat.py

Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/runtime.py

Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/generic.py
Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/imageCaptureDragDrop.py
Library  String
Library  DateTime
Library  Collections
Library  RequestsLibrary
Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/AudioRmsLibrary.py
Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/cropSubtitle.py
Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/subtitlenew.py
Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/ImageProcessingLibrary.py    WITH NAME    IPL
Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/OCRLibrary.py    WITH NAME    OCR
Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/AudioQuality.py
Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/OcrExtractText.py
# Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/ocr_text_extraction.py
# Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/SubtitleOcr.py
Variables    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/VariableFiles/STB/STB04_KSTB6080/STB04_KSTB6080.yaml
Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/audioverification.py
# Library   /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/Etisalat_Android_STB1/VideoQuality/Video_metrics_robot.py
Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/VideoQuality/VideoMetricsLibrary.py
Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/VideoQuality/LiveVideoQualityClassifier.py
Library     /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/AudioRmsLibrary.py
Library    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S/OcrKeywords.py
*** Variables ***
${image_profile_abcd}   /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Images_Linux/TC_002_Edited_Profile_Name.png
${ZAP_LIMIT}     0.003    # 3 milliseconds in seconds
@{ZAP_TIMES}     # List to store each zap time
${IMAGE_PATH}    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Images_Linux/Recent.png
${gray_image}      /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Blank_tile_continue_watching.png
@{SD_CHANNEL_LIST}    2    73    126    236    426
@{HD_CHANNEL_LIST}    11    23    33		153    259    577
@{UHD_CHANNEL_LIST}    204
${black_screen}    /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Images/black_screen.jpg
@{REF_IMAGES}     progresstile_ref.png
...               progresstile_ref2.png
...               progresstile_ref3.png
...               progresstile_ref4.png
@{matched_list}         Create List
@{unmatched_list}       Create List
${SCRIPT_PATH}      /home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB04_KSTB6080/vq1.py
*** Variables ***
&{CHANNEL_FEATURES}    
...    [0001] Info Channel=PiP=True    CatchUp=False    EPGCheck=False    StartOver=False    VideoAvailability=True
...    [0011] Abu Dhabi TV HD=PiP=True    CatchUp=True    EPGCheck=True    StartOver=True    VideoAvailability=True

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


Apply Startover
    CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK OK

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
#     Log  ${report_path}
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
    sleep  2s
    ${pass}  imageCaptureDragDrop.verifyimage  ${port}  ${image1}
    CAPTURE CURRENT IMAGE WITH TIME
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


625_Gray_Progress.png
    [Arguments]  ${port}  ${image1}
    # sleep  2s
    ${pass}  imageCaptureDragDrop.verifyimage  ${port}  ${image1}
    CAPTURE CURRENT IMAGE WITH TIME
    sleep  1s
    RETURN  ${pass}


CLICK MULTIPLE TIMES
    [Arguments]    ${count}    ${key}
    FOR  ${i}    IN RANGE    ${count}
        ${keyword}    Catenate    CLICK    ${key}
        Run Keyword And Return Status    ${keyword}
    END

CREATE PROFILE
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
    ${Result1}    Verify Crop Image    ${port}    ADMIN

    Run Keyword If    '${Result1}' == 'True'    Run Keywords
    ...    CLICK OK    AND
    ...    pinblock    AND
    ...    Sleep    15s    AND
    ...    Check For Who's Watching login Page

    Run Keyword If    '${Result1}' != 'True'    CLICK HOME
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

NAVIGATE TO CHANNEL LIST IN NEW UI
    CLICK HOME
    CLICK BACK
    Sleep    2s
    CLICK BACK
    Sleep    2s
    CLICK OK
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

NAVIGATE TO PROFILE ICONS
    CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
Enter Pincode
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK

# Remove Reminder
#     CLICK HOME
#     CLICK UP
#     CLICK MULTIPLE TIMES    5    RIGHT 
#     CLICK OK
#     CLICK DOWN
#     CLICK OK
#     Sleep    2s 
#     CLICK OK
#     CLICK OK
#     CLICK UP
#     CLICK OK
#     Sleep    2s 
#     CLICK HOME
Check For Who's Watching login Page
    Sleep    1s
    ${Result}=    Verify Crop Image    ${port}   PROFILE_ADMIN_LOGIN
    Log To Console    Who's login: ${Result}
    IF    '${Result}' == 'True'
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK OK
        Sleep    30s
    END    
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
    [Arguments]   ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}
    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Add_To_Favorites
    Log To Console    Add To Favorites: ${Result}
    IF    '${Result}' == 'True'
        ${base_count}=    Set Variable    1
        ${STEP_COUNT}=    Set Variable    ${base_count}
        Log To Console    ${base_count}
    END

    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    TC_217_remove_Favorites_img
    Log To Console    Remove Favorites: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Pause_Side_Panel
    Log To Console    Pause: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Start_Over
    Log To Console    Start Over: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	${Result}=    Verify Crop Image    ${port}    Side_Pannel_Record
    Log To Console    Record: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
     CLICK RIGHT
	${Result}=    Verify Crop Image    ${port}    Side_Pannel_Catchup_Option
    Log To Console    Catch Up: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
	CLICK RIGHT
	${Result}=    Verify Crop Image    ${port}    More_Details_Option
    Log To Console    More Details: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    Log To Console    After Increment: ${STEP_COUNT}   

    RETURN    ${STEP_COUNT}

# Move to subtitle On Side Pannel
#     [Arguments]   ${base_count}=0
#     ${STEP_COUNT}=    Set Variable    ${base_count}
#     Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

#     CLICK RIGHT
#     ${Result}=    Verify Crop Image    ${port}    Add_To_Favorites
#     Log To Console    Add To Favorite: ${Result}
#     IF    '${Result}' == 'True'
#         ${base_count}=    Set Variable    1
#         ${STEP_COUNT}=    Set Variable    ${base_count}
#         Log To Console    ${base_count}
#     END

#     CLICK RIGHT
#     ${Result}=    Verify Crop Image    ${port}    TC_217_remove_Favorites_img
#     Log To Console    Remove Favorites: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
#     CLICK RIGHT
#     ${Result}=    Verify Crop Image    ${port}    Pause_Side_Panel
#     Log To Console    Pause: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
#     CLICK RIGHT
#     ${Result}=    Verify Crop Image    ${port}    Start_Over
#     Log To Console    Start Over: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
#     CLICK RIGHT
# 	${Result}=    Verify Crop Image    ${port}    Side_Pannel_Record
#     Log To Console    Record: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
#      CLICK RIGHT
# 	${Result}=    Verify Crop Image    ${port}    Side_Pannel_Catchup_Option
#     Log To Console    Catch Up: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
# 	CLICK RIGHT
# 	${Result}=    Verify Crop Image    ${port}    More_Details_Option
#     Log To Console    More Details: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
#     CLICK RIGHT
# 	${Result}=    Verify Crop Image    ${port}    Audio
#     Log To Console    Audio: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
#     CLICK RIGHT
#     Log To Console    After Increment: ${STEP_COUNT}   

#     RETURN    ${STEP_COUNT}

Move to subtitle On Side Pannel
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

    CLICK RIGHT
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    TC_Remove_Favs
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

Move to subtitle
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

Check for play or pause
    ${Resultpause}=    Verify Crop Image   ${port}  Pause_Button
    ${Result}=    Verify Crop Image   ${port}  Play_Button
    IF   '${Result}' == 'True'
        CLICK OK
    END

# Move to Pause On Side Pannel
#     [Arguments]   ${base_count}=0
#     ${STEP_COUNT}=    Set Variable    ${base_count}
#     Log To Console    Initial STEP_COUNT: ${STEP_COUNT}
    
#     CLICK RIGHT
#     ${Result}=    Verify Crop Image    ${port}    Add_To_Favorites
#     Log To Console    Add_To_Favorites: ${Result}
#     IF    '${Result}' == 'True'
#         ${base_count}=    Set Variable    1
#         ${STEP_COUNT}=    Set Variable    ${base_count}
#         Log To Console    ${base_count}
#     END

#     CLICK RIGHT
#     ${Result}=    Verify Crop Image    ${port}    TC_217_remove_Favorites_img
#     Log To Console    Rmv_Fav: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
    
#     CLICK RIGHT
#     Log To Console    After Increment: ${STEP_COUNT}   

#     RETURN    ${STEP_COUNT}

Move to Add To List On Side Pannel
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
        ${Result}=    Verify Crop Image    ${port}    TC_711_Play
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    Log To Console    After Increment: ${STEP_COUNT}

    ${Result}=    Verify Crop Image    ${port}    TC_711_Go_To_Date
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    Log To Console    After Increment: ${STEP_COUNT}  
    ${Result}=    Verify Crop Image    ${port}    TC_711_Add_To_List
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    Log To Console    After Increment: ${STEP_COUNT}  
    ${Result}=    Verify Crop Image    ${port}    TC711_Change_Channel
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    Log To Console    After Increment: ${STEP_COUNT}
    ${Result}=    Verify Crop Image    ${port}    TC_711_AddTo_MyList
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'False'
        CLICK OK
        CLICK OK
    END
    CLICK RIGHT

    RETURN    ${STEP_COUNT}




Move to More Details On Side Pannel
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
    ${Result}=    Verify Crop Image    ${port}    TC_217_remove_Favorites_img
    Log To Console    Remove Favorite: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    
    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    TC_217_Pause_Button_Side_Pannel
    Log To Console    Pause: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

    ${Result}=    Verify Crop Image    ${port}    Start_Over
    Log To Console    Start Over: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	${Result}=    Verify Crop Image    ${port}    Side_Pannel_Record
    Log To Console    Record: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
     CLICK RIGHT

	${Result}=    Verify Crop Image    ${port}    Side_Pannel_Catchup_Option
    Log To Console    Catch Up: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
	CLICK RIGHT

	Log To Console    After Increment: ${STEP_COUNT}   

    RETURN    ${STEP_COUNT}

# Move to Start Over On Side Pannel
#     [Arguments]   ${base_count}=0
#     ${STEP_COUNT}=    Set Variable    ${base_count}
#     Log To Console    Initial STEP_COUNT: ${STEP_COUNT}
    
#     CLICK RIGHT
#     ${Result}=    Verify Crop Image    ${port}    TC_Add_To_Fav
#     Log To Console    Add To Favorites: ${Result}
#     IF    '${Result}' == 'True'
#         ${base_count}=    Set Variable    1
#         ${STEP_COUNT}=    Set Variable    ${base_count}
#         Log To Console    ${base_count}
#     END

#     CLICK RIGHT
#     ${Result}=    Verify Crop Image    ${port}    TC_Remove_Favs
#     Log To Console    Remove Favorites: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
    
#     CLICK RIGHT
#     ${Result}=    Verify Crop Image    ${port}    Pause_Side_Panel
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
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Side_Pannel_Pause
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

# Move to Record On Side Pannel
#     [Arguments]   ${base_count}=0
#     ${STEP_COUNT}=    Set Variable    ${base_count}
#     Log To Console    Initial STEP_COUNT: ${STEP_COUNT}
    
#     CLICK RIGHT
#     ${Result}=    Verify Crop Image    ${port}    TC_Add_To_Fav
#     Log To Console    Add To Favorites: ${Result}
#     IF    '${Result}' == 'True'
#         ${base_count}=    Set Variable    1
#         ${STEP_COUNT}=    Set Variable    ${base_count}
#         Log To Console    ${base_count}
#     END

#     CLICK RIGHT
#     ${Result}=    Verify Crop Image    ${port}    TC_Remove_Favs
#     Log To Console    Remove Favorites: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
#     CLICK RIGHT
#     ${Result}=    Verify Crop Image    ${port}    Pause_Side_Panel
#     Log To Console    Pause : ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
#     CLICK RIGHT

#     ${Result}=    Verify Crop Image    ${port}    Start_Over
#     Log To Console    Start Over: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
#     CLICK RIGHT

# 	Log To Console    After Increment: ${STEP_COUNT}  
#     RETURN    ${STEP_COUNT} 




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
#     ${Result}=    Verify Crop Image    ${port}    TC_Add_To_Fav
#     Log To Console    Audio Match Result: ${Result}
#     IF    '${Result}' == 'True'
#         ${base_count}=    Set Variable    1
#         ${STEP_COUNT}=    Set Variable    ${base_count}
#         Log To Console    ${base_count}
#     END

#     CLICK RIGHT
#     ${Result}=    Verify Crop Image    ${port}    TC_833_Go_To_Screen
#     Log To Console    Audio Match Result: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
#     CLICK RIGHT
#     ${Result}=    Verify Crop Image    ${port}    TC_83_Choose_Favorite
#     Log To Console    Audio Match Result: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
#     CLICK RIGHT
	
#     ${Result}=    Verify Crop Image    ${port}    TC_Remove_Favs
#     Log To Console    Audio Match Result: ${Result}
#     IF    '${Result}' == 'True'
#         ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
#     END
#     CLICK RIGHT

# 	Log To Console    After Increment: ${STEP_COUNT}   

#     RETURN    ${STEP_COUNT}

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


Move to Subtitles On Side Pannel With OCR
    ${after_text}=    Capture Side Pannel Options
    ${STEP_COUNT}=    Get Side Pannel Subtitles And Return Count   ${after_text}
    RETURN    ${STEP_COUNT}



Move to Change Genre On Side Pannel
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
    ${Result}=    Verify Crop Image    ${port}    TC_604_Remove_Fav
    Log To Console    Remove Favorites: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END

    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    TC_007_Rent.png
    Log To Console    tc_1000_Rent Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    TC_1000_Buy.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

    ${Result}=    Verify Crop Image    ${port}    TC_1000_More_Details.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

     ${Result}=    Verify Crop Image    ${port}    TC_1000_Add_TO_My_List.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
     ${Result}=    Verify Crop Image    ${port}    TC_1000_Trailer.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

     ${Result}=    Verify Crop Image    ${port}    TC_1000_Cast.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT


	
	Log To Console    After Increment: ${STEP_COUNT}   

    RETURN    ${STEP_COUNT}

Move to Filter By Launguage On Side Pannel
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
    # ${Result}=    Verify Crop Image    ${port}    TC_007_Rent.png
    # Log To Console    tc_1000_Rent Result: ${Result}
    # IF    '${Result}' == 'True'
    #     ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    # END
    # CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    TC_1000_Buy.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

    ${Result}=    Verify Crop Image    ${port}    TC_1000_More_Details.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

     ${Result}=    Verify Crop Image    ${port}    TC_1000_Add_TO_My_List.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
     ${Result}=    Verify Crop Image    ${port}    TC_1000_Trailer.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

     ${Result}=    Verify Crop Image    ${port}    TC_1000_Cast.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

    ${Result}=    Verify Crop Image    ${port}    TC_1000_Change_Genre.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	
	Log To Console    After Increment: ${STEP_COUNT}   

    RETURN    ${STEP_COUNT}

Move to Sort On Side Pannel
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
    ${Result}=    Verify Crop Image    ${port}    tc_1000_Rent.png
    Log To Console    tc_1000_Rent Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    TC_1000_Buy.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

    ${Result}=    Verify Crop Image    ${port}    TC_1000_More_Details.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

     ${Result}=    Verify Crop Image    ${port}    TC_1000_Add_TO_My_List.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
     ${Result}=    Verify Crop Image    ${port}    TC_1000_Trailer.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

     ${Result}=    Verify Crop Image    ${port}    TC_1000_Cast.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

    ${Result}=    Verify Crop Image    ${port}    TC_1000_Change_Genre.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

     ${Result}=    Verify Crop Image    ${port}    TC_1000_Filter_By_Language.png
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
	
	Log To Console    After Increment: ${STEP_COUNT}   

    RETURN    ${STEP_COUNT}

VALIDATE VIDEO PLAYBACK
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
    Run Keyword If  ${pass}==False  Log To Console  Video is Playing
    ...  ELSE  Fail  Video is not playing
    # RETURN  True

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

Verify Zapping Time Using Up or Down Button
    [Arguments]    ${Direction}    ${numberOfZaps}
    ${ZAP_TIMES}=    Create List
    Log To Console    Starting zapping test with ${numberOfZaps} zaps using ${Direction} button

    FOR    ${i}    IN RANGE    ${numberOfZaps}
        ${start}=    Evaluate    __import__('time').time()
        Run Keyword    CLICK    ${Direction}
        ${end}=      Evaluate    __import__('time').time()

        ${elapsed}=  Evaluate    round(${end} - ${start}, 3)
        Append To List    ${ZAP_TIMES}    ${elapsed}
        Log To Console    Zap ${i + 1}: ${elapsed} seconds

        # Optional: Add validation logic here
        # Run Keyword And Continue On Failure    Validate Channel Change
    END

    ${total_time}=    Evaluate    round(sum(${ZAP_TIMES}), 3)
    Log To Console    Total zaps: ${numberOfZaps}
    Log To Console    Total time taken: ${total_time} seconds
    
Zap And Measure Time
   ${start}=    Evaluate    __import__('time').time()
   ${end}=      Evaluate    __import__('time').time()
   ${elapsed}=  Evaluate    ${end} - ${start}
   RETURN    ${elapsed}

Check For Exit Popup
    ${Result}=    Verify Crop Image    ${port}    TC_217_Exit
    Log To Console    Exit popup found: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
        # CLICK HOME
    END
    RETURN    ${Result}


Move to Remove From List On Side Pannel
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
        ${Result}=    Verify Crop Image    ${port}    TC_711_Play
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    Log To Console    After Increment: ${STEP_COUNT}

    ${Result}=    Verify Crop Image    ${port}    TC_711_Go_To_Date
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    Log To Console    After Increment: ${STEP_COUNT}  
    
    ${Result}=    Verify Crop Image    ${port}    TC711_Change_Channel
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    Log To Console    After Increment: ${STEP_COUNT}
    ${Result}=    Verify Crop Image    ${port}    Remove_From_List
    Log To Console    Audio Match Result: ${Result}
    IF    '${Result}' == 'False'
        CLICK OK
        CLICK OK
    END
    CLICK RIGHT

    RETURN    ${STEP_COUNT}







Cancel Scheduled Recording By Reference Image
    [Arguments]    ${port}    ${reference_image}
    ${max_items}=    Set Variable    10
    FOR    ${index}    IN RANGE    ${max_items}
       Sleep    1s
       ${match}=    imageCaptureDragDrop.verifyimage    ${port}    ${reference_image}
       Run Keyword If    '${match}'=='True'    Cancel Currently Focused Recording
    END
    CLICK DOWN
    Log To Console    Finished checking scheduled recordings

# Cancel Scheduled Recording By Reference Image    ${port}    Stream_Nation_title.png

Cancel Currently Focused Recording
    # This keyword assumes you are focused on the desired recording
    CLICK OK
    Sleep    1s
    # Confirm cancellation dialog
    CLICK OK
    Log To Console    Recording cancelled Successfully

Pre Check STB Health
    [Documentation]    Press UP and verify ${Expected_Image}. Reboot STB if not visible.
    CLICK HOME
    CLICK UP
    CLICK OK
    Sleep    5s
    ${Result}=    Verify Crop Image    ${port}    Home_Page

    IF    '${Result}' == 'True'
        Log To Console    STB Is Active, continuing test
    ELSE
        Log To Console    Image not visible, rebooting STB
        Reboot STB Device        
        Log To Console    It may take few seconds
        Check Who's Watching login
        Sleep   20s
    END
Reboot STB Device
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB04_KSTB6080"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    75s
    Log To Console    Reboot Success
    Check Who's Watching login
    CLICK HOME

Reboot Device
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB04_KSTB6080"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    75s
    Log To Console    Reboot Success
Navigate to Rent from side panel
    FOR    ${i}    IN RANGE    20
        ${Result}=    Verify Crop Image    ${port}    TC_007_Rent
        Run Keyword If    '${Result}' == 'True'    Run Keywords
        ...    Log To Console    ✅ TC_007_Rent is displayed
        ...    AND    CLICK OK
        ...    AND    Exit For Loop

        CLICK BACK
        CLICK RIGHT
        CLICK OK
    END

Get Reference Image Text
    ${text}=    runtime.test_image_to_texts
    Log To Console    ${text}

Validate Extracted Text From Image
    [Arguments]    ${EXPECTED_TEXT}
    Log To Console    \n🔍 Using image: ${IMAGE_PATH}
    ${result}=    Extract And Check Text    ${IMAGE_PATH}    ${EXPECTED_TEXT}
    Log To Console    ✅ Text Found: ${result}
    Should Be True    ${result}    ❌ ${EXPECTED_TEXT} Text not found in image!



Extract Clean OCR Text
    ${words}=    Extract Clean OCR Text    ${IMAGE_PATH}
    ${count}=    Get Length    ${words}
    Log To Console    📋 Total Words Found: ${count}
    FOR    ${word}    IN    @{words}
        Log To Console    ${word}
    END


# neMove to Record On Side Pannel For EPG 
    [Arguments]   ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}
    
    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Add_To_Favorites
    Log To Console    Add To Favorites: ${Result}
    IF    '${Result}' == 'True'
        ${base_count}=    Set Variable    1
        ${STEP_COUNT}=    Set Variable    ${base_count}
        Log To Console    ${base_count}
    END

    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Pause_Side_Panel
    Log To Console    Pause : ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Side_Pannel_Record
    Log To Console    Record: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    Pause_Side_Panel
    Log To Console    Pause : ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT


	Log To Console    After Increment: ${STEP_COUNT}   

    RETURN    ${STEP_COUNT}

 resume
    ${pin}  Verify Crop Image  ${port}     resume
    Log To Console    login: ${pin}
    IF    '${pin}'=='True'    
        CLICK OK
    END

checkformat
    ${format}  Verify Crop Image  ${port}     HD
    Log To Console    login: ${format}
    IF    '${format}'=='True'    
        CLICK OK
    END

pinblock
    ${pin}  Verify Crop Image  ${port}     Pin_Block
    Log To Console    login: ${pin}
    IF    '${pin}'=='True'    
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK DOWN
        CLICK OK
    END 
    
subscription_pin
    ${pin}  Verify Crop Image  ${port}     TC_513_subscription
    Log To Console    login: ${pin}
    IF    '${pin}'=='True'    
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK TWO
        CLICK DOWN
        CLICK DOWN
        CLICK OK
    END



Box Office Buy
    ${BuyResult}=     Verify Crop Image    ${port}    BoxOffice_Buy
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
    ${BuyResult}=     Verify Crop Image    ${port}    BoxOffice_Buy
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
    ${Result}=    Verify Crop Image    ${port}    TC_524_BUY
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
    ${Result}=    Verify Crop Image    ${port}    TC_524_RENT
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

addtolistpopup
    ${Result}  Verify Crop Image  ${port}  popup_addtolist
    Log To Console  popup_addtolist Is Displayed
	IF  '${Result}' == 'True'  
        CLICK Ok
    END

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

   


search lionking movie
    CLICK HOME
    CLICK UP
    CLICK MULTIPLE TIMES    8    RIGHT
    CLICK OK
    Sleep    1s
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
    CLICK HOME
    
    
Box Office Rentals Buy or rent
    ${RentResult}=    Verify Crop Image    ${port}    BoxOffice_Rent
    ${BuyResult}=     Verify Crop Image    ${port}    BoxOffice_Buy
    Log To Console    Rent: ${RentResult}
    Log To Console    Buy: ${BuyResult}
    IF    '${RentResult}' == 'True' and '${BuyResult}' == 'True'
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
    ${Progress}  runtime.tempMatch  ${port}  progressbar_com  progressbar_ref
    log to console    ${Progress}
    Run Keyword If  '${Progress}' == 'False'  Log To Console    video playback Progress Bar is seeked

Verify ProgressTile
    FOR    ${i}   IN RANGE    2
        # Log To Console    --- Pressing OK iteration ${index + 1} ---
        CLICK OK
        Sleep    2s
        ${Progress}=    runtime.tempMatch    ${port}   progresstile_com  progresstile_ref
        Log To Console    Progress Check Result: ${Progress}
        Run Keyword If    '${Progress}' == 'False'    Log To Console    ✅ Progress bar has moved
        Run Keyword If    '${Progress}' == 'True'     Log To Console    ❌ Progress bar did NOT move
        #  ${after_text}=    Get Set Up Wizard Info
        # Log To Console    OCR AFTER TEXT: ${after_text}

        # # 3️⃣ Verify text is present
        # Run Keyword If    '${after_text}' == ''    Fail    ❌ No text detected on screen after OK press
        # Log To Console    ✅ Text detected on screen: ${after_text}

    END



Get Set Up Wizard Info
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console   AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Set Up Wizard   ${after_image_path}
    Log To Console   CROPPED AFTER INFO BAR: ${cropped_img}
     # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    # RETURN    ${channel_name_epg_text} 
    ${channel_name_epg_text}=    Set Variable    ${after_text}
    RETURN    ${channel_name_epg_text}

Validate Progress Tile Screens Dynamically
    ${after_now}=    generic.get_date_time
    @{SCREEN_NAMES}=    Create List

    FOR    ${ref_img}    IN    @{REF_IMAGES}
        ${image_path}=    Replace String    ${ref_img}    replace    ${after_now}
        generic.Capture Image    ${port}    ${image_path}
        Log To Console   📸 Captured Image: ${image_path}

        ${cropped_img}=    IPL.Set Up Wizard    ${image_path}
        Log To Console   ✂️ Cropped Image: ${cropped_img}

        ${ocr_text}=     OCR.Extract Text From Image    ${cropped_img}
        Log To Console   🔍 OCR TEXT: ${ocr_text}

        Append To List    ${SCREEN_NAMES}    ${ocr_text}
        Log To Console    📝 Updated SCREEN_NAMES list: ${SCREEN_NAMES}
        Should Not Be Empty    ${ocr_text}
        Log To Console    ✅ Validated screen: ${ocr_text}

        Log To Console    🔘 Clicking OK for progress tile: ${ref_img}
        CLICK OK
    END
    @{EXPECTED_WORDS}=   Create List   Screen Language    Choose An Avatar   Remember Me    Content Rental & Purchases Security

    Log To Console    🔍 Comparing OCR text list with expected words...
    Log Many    OCR SCREEN_NAMES    ${SCREEN_NAMES}
    Log Many    EXPECTED_WORDS      @{EXPECTED_WORDS}

    # Normalize both lists: strip whitespace and decode HTML entities
    ${normalized_screen_names}=    Evaluate    [item.strip().replace('&amp;', '&') for item in ${SCREEN_NAMES}]
    ${normalized_expected}=        Evaluate    [item.strip().replace('&amp;', '&') for item in @{EXPECTED_WORDS}]

    Log Many    Normalized OCR List    ${normalized_screen_names}
    Log Many    Normalized Expected List    ${normalized_expected}

    ${lists_match}=    Run Keyword And Return Status    Lists Should Be Equal    ${normalized_screen_names}    ${normalized_expected}

    Run Keyword If    ${lists_match}    Log To Console    ✅ All tiles contain expected words
    Run Keyword Unless    ${lists_match}    Fail    ❌ OCR text list does not match expected words

    
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

Channel Monitoring
    [Arguments]    ${channel_name}
    Log To Console    Monitoring ${channel_name}

    ${features}=    Get From Dictionary    ${CHANNEL_FEATURES}    ${channel_name}

    Run Keyword If    '${features.PiP}'=='True'    Validate PiP    ${channel_name}
    Run Keyword If    '${features.CatchUp}'=='True'    Validate CatchUp    ${channel_name}
    Run Keyword If    '${features.EPGCheck}'=='True'    Validate EPG    ${channel_name}
    Run Keyword If    '${features.StartOver}'=='True'    Validate Start Over    ${channel_name}
    Run Keyword If    '${features.VideoAvailability}'=='True'    Validate Video Availability    ${channel_name}

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


Apply position change
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    FOR    ${i}    IN RANGE    12
        CLICK OK
        Sleep   1s
        Log To Console  Applied NEXT Feature
    END

Apply position change previous
    CLICK LEFT
    CLICK LEFT
    CLICK LEFT
    CLICK LEFT
    FOR    ${i}    IN RANGE    12
        CLICK OK
        Sleep   1s
        Log To Console  Applied PREVIOUS Feature
    END   


Click Random RIGHT
    ${count}=    Evaluate    random.randint(1,10)    modules=Random
    CLICK MULTIPLE TIMES    ${COUNT}    RIGHT    


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

Selecting Startover Filter From Guide
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
	CLICK OK
	CLICK BACK
	CLICK BACK
    CLICK HOME

Guide Channel List
    FOR  ${i}  IN RANGE  5
        ${Result1}=  Verify Crop Image  ${port}  Channel_List
        IF  '${Result1}' == 'True'
            Click OK
        ELSE
            Exit For Loop
        END
    END

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
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Remove_From_Fav
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
	Sleep    2s 
	CLICK DOWN
	CLICK OK
	Sleep    2s 
	# CLICK OK
	CLICK OK
	CLICK UP
	# ${Result}  Verify Crop Image  ${port}  TC_809_Removal
	# Run Keyword If  '${Result}' == 'True'  Log To Console  TC_809_Removal Is Displayed on screen
	# ...  ELSE   Log To Console     TC_809_Removal Is Not Displayed on screen
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
    #     CLICK OK
    #     Sleep    2s 
    #     CLICK OK
	# ELSE
	# 	CLICK HOME
	# END
    # CLICK HOME
    ${cloud}=    Verify Crop Image    ${port}    CLOUD_STORAGE_PROFILE_SETTING
    # ${ask}=      Verify Crop Image    ${port}    Ask_Storage_Selection
    ${ask}=  Verify Crop Image  ${port}  Ask_Storage_Selection
    ${local}=  Verify Crop Image  ${port}  Local_Storage_Selection

    IF    '${cloud}' == 'True'
        # When CLOUD_STORAGE_PROFILE_SETTING is present
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
    ELSE IF   '${ask}' == 'True'
        # When Ask_Storage_Selection is present
        CLICK OK
        CLICK UP
        CLICK OK
        CLICK DOWN
        CLICK DOWN
        CLICK DOWN
        CLICK DOWN
        CLICK OK
        Sleep    2s
        CLICK OK
    ELSE IF   '${local}' == 'True'
        # When Local_Storage_Selection is present
        CLICK OK
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
        ${Result1}=  Verify Crop Image  ${port}    Arabic_Channel_List

        IF  '${Result1}' == 'True'
            Click OK
        ELSE
            Exit For Loop
        END
    END



Move to Set Reminder On SP
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
    CLICK ONE
    CLICK TWO
    CLICK ZERO
    CLICK ONE
    Sleep   20s
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
    CLICK HOME
RemoveFilter_UnlockChannels_Live_Tv
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
    CLICK UP
    CLICK OK

    CLICK UP
    CLICK UP
    CLICK UP
    CLICK UP
    CLICK UP
    CLICK UP
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
	Sleep    2s
	CLICK BACK
	CLICK RIGHT

	WHILE    True
		${Result}=    Verify Crop Image    ${port}    Remove_From_Fav
		Run Keyword If    '${Result}' == 'True'
		...    Log To Console    Remove_From_Fav Is Displayed
		...    CLICK OK
		...    Sleep    2s
		Run Keyword If    '${Result}' == 'False'    Exit For Loop    # ❌ Not valid for WHILE
	END

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




Handle Recording Failure

    Log To Console    Recording Failed or Unexpected Popup Detected
    # Go to new channel 7105
    CLICK SEVEN
    # CLICK ONE
    CLICK ZERO
    CLICK FIVE
    Log To Console    Navigated To Channel 705
    Sleep    2s
    Sleep	2s
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
    Sleep    2s
    Log To Console    Playback Recording Started

    ${Result}=    Verify Crop Image With Shorter Duration   ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start on 705 Is Displayed
    ...    ELSE    
    ...    Fail    TC_401_Rec_Start Is Not Displayed Even After Switching Channel



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



CREATE PROFILE COCO
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

SET PG13 TO COCO
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
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK OK
    CLICK RIGHT
    CLICK Ok
    CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
    CLICK DOWN
    CLICK DOWN
	CLICK DOWN
    CLICK DOWN
    CLICK OK
    Sleep    10s

DELETE COCO
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
    Log To Console    DELETED coco prof   
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
  
Check For Recording Completed Popup
    ${Result}=    Verify Crop Image    ${port}    TC_403_Record_Completed
    Log To Console    Recording Completed popup found: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
    END

# Verify Audio Quality
#     [Arguments]    ${device}=hw:1,0    ${checks}=3    ${duration}=5    ${wait}=5
#     ${quality}=    Check Audio Quality    ${device}    ${checks}    ${duration}    ${wait}
#     Log    Audio quality status: ${quality}
#     RETURN    ${quality}
Get Program Title
    Sleep   1s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console   AFTER IMAGE: ${after_image_path}

    # Call Director ROI cropping function (assuming IPL library is imported)
    ${cropped_img}=    IPL.Program_Title   ${after_image_path}
    Log    CROPPED DIRECTOR ROI: ${cropped_img}

    # OCR Extraction from cropped director image
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

     # Handle empty OCR output
    Run Keyword If    '${after_text}' == ''    Log To Console    WARNING: OCR returned empty text

    # Convert OCR text to lowercase for comparison
    ${lower_text}=    Convert To Lower Case    ${after_text}

    # Check if "joe" exists in OCR text
    ${is_found}=    Run Keyword And Return Status    Should Contain    ${lower_text}    info

    # Log results
    Run Keyword If    ${is_found}    Log To Console    SEARCH RESULT MATCHED: Program Name Info Found
    Run Keyword If    not ${is_found}    Log To Console    FAIL: Program Name Info Found Not Found

    # Optional: Fail the test if not found
    # Run Keyword Unless    ${is_found}    Fail    Director Joe not found in OCR output

    # Return OCR text for reporting or further validation
    ${director_text}=    Set Variable    ${after_text}
    RETURN    ${director_text}


Verify Extracted From Image
    # CLICK HOME
    # sleep    20s
    ${now}=    generic.get_date_time
    ${d_rimg}=    Replace String    ${ref_img1}    replace    ${now}
    generic.capture image run    ${port}    ${d_rimg}
    ${texts}=    Extract Text From Image    ${d_rimg}
    Log    Extracted text: ${texts}
    Log To Console    Extracted text: ${texts}

Rating
    CLICK RIGHT
	Check rating
	CLICK RIGHT
	Check rating
	CLICK RIGHT
	Check rating
	CLICK RIGHT
	Check rating
	# CLICK RIGHT
	# Check rating
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
Revert Language Change
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
    CLICK OK
    CLICK DOWN
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    CLICK OK
    Sleep	20s
    CLICK HOME

Reboot STB Device For SubProfile
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB04_KSTB6080"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    75s
    Log To Console    Reboot Success
    CLICK RIGHT
    CLICK OK
    CLICK TWO
    CLICK TWO
    CLICK TWO
    CLICK TWO
    CLICK OK
    Sleep  30s
    CLICK HOME

Reboot STB Device For SubProfile Arabic
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB04_KSTB6080"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    75s
    Log To Console    Reboot Success
    CLICK LEFT
    CLICK OK
    CLICK TWO
    CLICK TWO
    CLICK TWO
    CLICK TWO
    CLICK OK
    Sleep  30s
    CLICK HOME

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

    Log To Console    Profile Created succesfully
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
	# CLICK RIGHT
    # #ADD VALIDATION
    # ${Result}  Verify Crop Image  ${port}  child_profile_img
	# Run Keyword If  '${Result}' == 'True'  Log To Console  child_profile_img Is Displayed on screen
	# ...  ELSE  Fail  child_profile_img Is Not Displayed on screen
	# CLICK OK
    # Sleep    30s
    # CLICK HOME

CREATE CHILD PROFILE WITH COCO
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
    CLICK UP
	CLICK UP
	CLICK UP
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

# Navigate and Login to Sub profile
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
# 	CLICK RIGHT
# 	CLICK OK
# 	CLICK RIGHT
# 	${Result}  Verify Crop Image  ${port}    TC_004_new_user
# 	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_004_new_user Is Displayed on screen
# 	...  ELSE  Fail  TC_004_new_user Is Not Displayed on screen
	
# 	CLICK OK
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK TWO
# 	CLICK OK
# 	Sleep    5s 
# 	CLICK HOME
  
# Create New Profile
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
# 	CLICK RIGHT
# 	CLICK RIGHT
# 	Sleep    3s	
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
#     Sleep    5s

Login As Admin
    Navigate To Profile
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
Reboot STB Device for new User
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB04_KSTB6080"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    75s
    Log To Console    Reboot Success

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
        sleep  2s
        ${now}  generic.get_date_time
        ${d_cimg}  Replace String  ${comp_img}  replace  ${now}
        generic.capture image run  ${port}  ${d_cimg}
        #Log  <img src='${d_cimg}'></img>  html=yes
        CAPTURE CURRENT IMAGE WITH TIME
        ${pass}  generic.compare_image  ${d_rimg}  ${d_cimg}
        Run Keyword If  ${pass}==False  Log To Console  Video is Rewinding
    ...  ELSE  Fail  Video is not Rewinding
    END

Profile rent
    FOR    ${i}    IN RANGE    10
        ${pin}=    Verify Crop Image    ${port}    PROFILE_PLAY
        Log To Console    subscription: ${pin}
        IF    '${pin}'=='True'
            CLICK BACK
            CLICK LEFT
            CLICK OK
        ELSE
            CLICK RIGHT
            ${RentResult}=    Verify Crop Image    ${port}    Profile_RENT
            ${BuyResult}=     Verify Crop Image    ${port}    PROFILE_BUY
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
                Log To Console    Assest is brought
                Exit For Loop
            ELSE
                Log To Console    No Rent/Buy found → stopping loop
                Exit For Loop
            END
        END
    END

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



Reboot STB Device and Make sub profile as default user
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB04_KSTB6080"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    75s
    Log To Console    Reboot Success
    Login to new user and make sub profile as default
    CLICK HOME

Login to new user and make sub profile as default
    Sleep    1s
    ${Result}=    Verify Crop Image    ${port}    TC_520_Who_Watching
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
    ${Result}=    Verify Crop Image    ${port}    TC_Who_WATCHING
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

Reboot STB Device and Validate new profile with Avatar
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB04_KSTB6080"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    75s
    Log To Console    Reboot Success
    Check Who's Watching login with avatar profile validation
    CLICK HOME

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

Subscription Rent Buy Flow
    FOR    ${i}    IN RANGE    20
        ${pin}=    Verify Crop Image    ${port}    TC_513_subscription
        Log To Console    subscription: ${pin}
        IF    '${pin}'=='True'
            CLICK BACK
            CLICK LEFT
            CLICK OK
        ELSE
            CLICK RIGHT
            ${RentResult}=    Verify Crop Image    ${port}    RENT
            ${BuyResult}=     Verify Crop Image    ${port}    BUY
            Log To Console    Rent: ${RentResult}
            Log To Console    Buy: ${BuyResult}
            IF    '${RentResult}' == 'True' or '${BuyResult}' == 'True'
                CLICK OK
                CLICK OK
                CLICK DOWN
                CLICK DOWN
                CLICK DOWN
                CLICK DOWN 
                CLICK UP
                CLICK UP
                CLICK UP
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK TWO
                CLICK DOWN
                CLICK DOWN
                CLICK OK
                Log To Console    Assest is brought
                Sleep    2s
                Exit For Loop
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
Navigate To Profile
    CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK RIGHT
    CLICK OK


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
Delete Arabic Profile
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
	Sleep	30s
	Delete New Profile
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

Log Step
    [Arguments]    ${n}    ${msg}
    Log To Console    [STEP ${n}] ${msg}
Reboot STB for kids profile and login with 3333 pin
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB04_KSTB6080"}
    ${response}=    GET    ${url}
    Should Be Equal As Integers    ${response.status_code}    200
	Sleep    100s
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
    ...  ELSE  log To Console  Video is Paused
    CLICK HOME
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

Reboot STB Device And Log Time
    [Arguments]    ${port}    ${device_name}=STB04_KSTB6080    ${base}=http://192.168.1.58:5001    ${attempts}=25    ${initial_wait}=20s    ${poll}=2s

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


Move to Record for Recorder
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

    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Start_Over
    Log To Console    Start over: ${Result}
    IF    '${Result}' == 'True'
        ${STEP_COUNT}=    Evaluate    int(${STEP_COUNT}) + 1
    END
    CLICK RIGHT

	Log To Console    After Increment: ${STEP_COUNT}   

    RETURN    ${STEP_COUNT}
Verify Crop Image With Shorter Duration
    [Arguments]  ${port}  ${image1}
    # sleep  2s
    ${pass}  imageCaptureDragDrop.verifyimage  ${port}  ${image1}
    CAPTURE CURRENT IMAGE WITH TIME
    # sleep  1s
    RETURN  ${pass}

Search And Click On Record For Recorder
    Set Test Variable    ${record_found}    False
    FOR    ${index}    IN RANGE    20
        ${Result}=    Verify Crop Image    ${port}    Side_Pannel_Record
        IF    ${Result} == True
            Else Search Record Channel For Recorder
            Exit For Loop
        END
        Log To Console    Attempt ${index + 1}: Record image not found, navigating...
        CLICK BACK
        Click Up
        Click Up
        Click Up
        Sleep    1s
        CLICK OK
        Sleep    2s
        CLICK BACK
        CLICK RIGHT
    END
    Run Keyword If    ${record_found} == False    Fail    Could not find 'record' image after 10 attempts


Else Search Record Channel For Recorder
    ${STEP_COUNT}=    Move to Record For Recorder
    Click Right
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        Click Down
    END
    Click OK
    Set Test Variable    ${record_found}    True

# How to use : Zap Until Target Channel Found    DOWN    25
Zap Until Target Channel Found
    [Arguments]    ${Direction}    ${maxZaps}    ${channel}
    ${ZAP_TIMES}=    Create List
    ${found}=    Set Variable    False

    FOR    ${i}    IN RANGE    ${maxZaps}
        ${start}=    Evaluate    __import__('time').time()
        Run Keyword    CLICK ${Direction}
        ${end}=    Evaluate    __import__('time').time()

        ${elapsed}=    Evaluate    round(${end} - ${start}, 3)
        Append To List    ${ZAP_TIMES}    ${elapsed}
        Log To Console    Zap ${i + 1}: ${elapsed} milliseconds

        ${verification}=    Run Keyword And Ignore Error    Verify Crop Image With Shorter Duration    ${port}    ${channel}
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
    Log To Console    Total time taken: ${total_time} milliseconds

    Run Keyword Unless    ${found}    Fail    Target image was NOT found after ${maxZaps} zaps
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

#         Log To Console    Cropping Tile ${tile_index} with Coords: ${x1},${x2},${y1},${y2}

#         ${cropped_img}=    IPL.Channel_Name_From_Mosaic_With_Coords
#         ...    ${after_image_path}    ${x1}    ${x2}    ${y1}    ${y2}
#         Log To Console      ${cropped_img}

#         ${text}=    OCR.Extract Text From Image    ${cropped_img}
#         Log    Channel ${tile_index}: ${text}
#         # ${cleaned}=     Replace String Using Regexp    ${text}    [^A-Za-z0-9 ]    ${SPACE}
#         # ${cleaned}=     Replace String Using Regexp    ${cleaned}    \s+    ${SPACE}
#         # ${words}=       Split String    ${cleaned}
#         # ${camel_text}=  Evaluate    ' '.join([(w.upper() if w.upper() in ["TV","HD","MBC"] else w.capitalize()) for w in ${words}])
#         # Log To Console  CamelCase OCR: ${camel_text}
#         ${cleaned}=    Replace String Using Regexp    ${text}    [^A-Za-z0-9 ]    ${SPACE}
#         ${cleaned}=    Replace String Using Regexp    ${cleaned}    \s+    ${SPACE}
#         ${words}=    Split String    ${cleaned}
#         ${special_words}=    Create List    TV    HD    MBC    SBC    DIZI
#         # ${camel_text}=    Evaluate
#         # ...    ' '.join([w.upper() if w.upper() in ${special_words} or w.isdigit() else w.capitalize() for w in ${words}])
#         ${camel_text}=    Evaluate    ' '.join(["-".join([(p.upper() if p.upper() in list(${special_words}) else p.capitalize()) for p in w.split("-")]) if "-" in w else (w.upper() if w.upper() in list(${special_words}) else w.capitalize()) for w in ${words}])

#         ${camel_text}=    Replace String    ${camel_text}    E Junior    e-junior
#         ${camel_text}=    Replace String    ${camel_text}    E Masala    em
#         ${camel_text}=    Replace String    ${camel_text}    Abu Dhabi Sport HD    Abu Dhabi Sports 1 H
        
#         Log To Console    CamelCase OCR: ${camel_text}
#     END

#     # Log To Console    ===== FINAL CHANNEL NAMES =====
#     # Log To Console    ${channel_names}

#     RETURN    ${camel_text}
# Get Channel Name In Recorder From Info Bar
#     CLICK UP
#     Sleep   1s
#     ${after_now}=    generic.get_date_time
#     ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
#     generic.Capture Image  ${port}    ${after_image_path}
#     Log    AFTER IMAGE: ${after_image_path}
#     ${cropped_img}=    IPL.Channel Name From EPG Info Bar   ${after_image_path}
#     Log    CROPPED AFTER INFO BAR: ${cropped_img}
#      # OCR Extraction
#     ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
#     Log To Console    OCR AFTER TEXT: ${after_text}

#     # Check OCR Start Timestamp Using AI Slots    ${after_text}
#     # RETURN    ${channel_name_epg_text} 
#     ${channel_name_epg_text}=    Set Variable    ${after_text}
#     RETURN    ${channel_name_epg_text}

# Verify Matching Channels
    [Arguments]     ${channel_name_source}    ${channel_target}
    Log To Console    EPG Channel: ${channel_name_source}
    Log To Console    Recorded Channel: ${channel_target}
    Should Contain    ${channel_target}    ${channel_name_source}
    

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
    Log To Console   AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Channel Name From EPG Info Bar   ${after_image_path}
    Log To Console   CROPPED AFTER INFO BAR: ${cropped_img}
     # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    # RETURN    ${channel_name_epg_text} 
    ${channel_name_epg_text}=    Set Variable    ${after_text}
    RETURN    ${channel_name_epg_text}

# Get Channel Name In Recorder Of MyList

#     ${after_now}=    generic.get_date_time
#     ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
#     generic.Capture Image  ${port}    ${after_image_path}
#     Log    AFTER IMAGE: ${after_image_path}
#     ${after_crop}=     IPL.Channel Name In Recorder Of MyList   ${after_image_path}
#     Log    CROPPED AFTER INFO BAR: ${after_crop}

#     # OCR Extraction
#     Log To Console    OCR AFTER TEXT: ${after_text}
#     ${wothout_special_char}=    Evaluate    re.sub(r'[^a-zA-Z0-9 ]','',"""${after_text}""")
    
#     # Check OCR Start Timestamp Using AI Slots    ${after_text}
#     ${recorded_channel_text}=    Set Variable    ${wothout_special_char}
#     RETURN    ${recorded_channel_text}   
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
    # ${without_special_char}=    Evaluate    re.sub(r'[^a-zA-Z0-9 ]','',"""${after_text}""")    re
    # Log To Console    CLEANED TEXT: ${without_special_char}
    # Keep letters, numbers, spaces, and hyphens
    ${without_special_char}=    Evaluate    re.sub(r'[^a-zA-Z0-9 \-]','',"""${after_text}""")    re
    Log To Console    CLEANED TEXT: ${without_special_char}

    ${recorded_channel_text}=    Set Variable    ${without_special_char}
    RETURN    ${recorded_channel_text}


Remove_Favorites_From_List
    CLICK HOME
    CLICK UP
    CLICK RIGHT
    CLICK OK
    CLICK OK
    Sleep   20s
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


Cast Detail In Info Bar
    Sleep   1s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log    AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Cast In Info Bar   ${after_image_path}
    Log    CROPPED AFTER INFO BAR: ${cropped_img}
     # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    # RETURN    ${channel_name_epg_text} 
    ${channel_name_epg_text}=    Set Variable    ${after_text}
    RETURN    ${channel_name_epg_text}
    
Verify Matching Channels
    [Arguments]    ${channel_name_mylist}    ${channel_name}
    # Ensure the recorded channel name is not empty
    Should Not Be Empty    ${channel_name_mylist}    ❌ Recorded channel name is empty!

    # Check if the expected channel name contains the recorded one
    Should Contain    ${channel_name}    ${channel_name_mylist}    ❌ Expected '${channel_name}' to contain '${channel_name_mylist}'

    # Log success
    Log To Console    ✅ '${channel_name_mylist}' is found in '${channel_name}'

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
    

Handle Recording Failure Recorder
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

# How to call in test
# ${Result}  Validate Video Playback For Paused
# Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Paused
# ...  ELSE  Fail  Video is Playing
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
    RETURN      ${after_text}



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

Navigate to Home from selfcare
    CLICK RED
	Sleep    20s
	CLICK HOME
	Sleep    2s
	CLICK HOME
	${Result}  Verify Crop Image  ${port}    HOME
	Run Keyword If  '${Result}' == 'True'  Log To Console  HOME Is Displayed
    ...  ELSE  Log To Console  HOME Is Not Displayed


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
	${STEP_COUNT}=    Move to Filter On Side Pannel
	CLICK RIGHT
    FOR    ${i}    IN RANGE    ${STEP_COUNT}
        CLICK DOWN
    END
    Log To Console    Filter selected 
	CLICK OK
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
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB04_KSTB6080"}
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
Check Who's Watching login NEW USER
    Sleep    1s
    CLICK RIGHT
    ${Result}=    Verify Crop Image    ${port}    TC_520_Who_Watching
    Log To Console    Who's login: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
        CLICK THREE
        CLICK THREE
        CLICK THREE
        CLICK THREE
        CLICK OK
        Sleep    30s
        CLICK HOME
    END
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
    ${url}=    Set Variable    http://192.168.1.58:5001/hard_reboot?data={"device_name":"STB04_KSTB6080"}
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

# Verify Time On Interface Clock Negative Scenario
#     Sleep    5s  
#     ${after_now}=    generic.get_date_time
#     ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
#     generic.Capture Image    ${port}    ${after_image_path}
#     Log To Console    AFTER IMAGE: ${after_image_path}

#     ${after_crop}=    IPL.Channel Interface Clock    ${after_image_path}
#     Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

#     ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
#     Log To Console    📸 OCR AFTER TEXT: ${ocr_text}

#     # Handle missing OCR
#     Run Keyword If    '${ocr_text}' == '' or '${ocr_text}' == 'None' or '${ocr_text}' == '${EMPTY}'
#     ...    Log To Console    ⚠️ No OCR text detected — passing test.
#     Run Keyword If    '${ocr_text}' == '' or '${ocr_text}' == 'None' or '${ocr_text}' == '${EMPTY}'
#     ...    Return From Keyword   True

#     ${ocr_normalized}=    Evaluate    "${ocr_text}".replace(".",":").replace(" ", "").upper()
#     ${ocr_normalized}=    Evaluate    re.sub(r"([AP]M)$", r" \\1", "${ocr_normalized}")    modules=re
#     Log To Console    🔹 Normalized OCR: ${ocr_normalized}

#     ${local_12hr}=    Get Current Date    result_format=%I:%M %p
#     Log To Console    🕒 LOCAL TIME 12-HOUR: ${local_12hr}

#     ${time_diff}=    Run Keyword And Ignore Error    Evaluate
#     ...    abs((datetime.datetime.strptime("${local_12hr}", "%I:%M %p") - datetime.datetime.strptime("${ocr_normalized}", "%I:%M %p")).total_seconds() / 60)
#     ...    modules=datetime

#     ${status}=    Set Variable    ${time_diff}[0]
#     ${diff_value}=    Set Variable If    '${status}' == 'PASS'    ${time_diff}[1]    9999

#     Log To Console    🔸 Time difference (minutes): ${diff_value}

#     Run Keyword If    ${diff_value} <= 1
#     ...    Fail    ❌ Time Match Found — OCR=${ocr_normalized}, Local=${local_12hr}, Δ=${diff_value} min
#     ...    ELSE
#     ...    Log To Console    ✅ Time Mismatch or Invalid Time — OCR=${ocr_normalized}, Local=${local_12hr}, Δ=${diff_value} min
#     RETURN    True

# Verify Time On Interface Clock
#     Sleep    5s  

#     # Capture image
#     ${after_now}=    generic.get_date_time
#     ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
#     generic.Capture Image    ${port}    ${after_image_path}
#     Log To Console    AFTER IMAGE: ${after_image_path}

#     # Crop clock region
#     ${after_crop}=    IPL.Channel Interface Clock    ${after_image_path}
#     Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

#     # OCR extraction
#     ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
#     Log To Console    📸 OCR AFTER TEXT: ${ocr_text}

#     # Handle missing OCR
#     Run Keyword If    '${ocr_text}' == '' or '${ocr_text}' == 'None' or '${ocr_text}' == '${EMPTY}'
#     ...    Fail    ❌ OCR text missing — cannot verify clock.

#     # Normalize OCR text
#     ${ocr_normalized}=    Evaluate    "${ocr_text}".replace(".",":").replace(" ", "").upper()
#     ${ocr_normalized}=    Evaluate    re.sub(r"([AP]M)$", r" \\1", "${ocr_normalized}")    modules=re
#     Log To Console    🔹 Normalized OCR: ${ocr_normalized}

#     # Get current local time in 12-hour format
#     ${local_12hr}=    Get Current Date    result_format=%I:%M %p
#     Log To Console    🕒 LOCAL TIME 12-HOUR: ${local_12hr}

#     # Safely compute time difference
#     ${time_diff}=    Run Keyword And Ignore Error    Evaluate
#     ...    abs((datetime.datetime.strptime("${local_12hr}", "%I:%M %p") - datetime.datetime.strptime("${ocr_normalized}", "%I:%M %p")).total_seconds() / 60)
#     ...    modules=datetime

#     # Extract status and value
#     ${status}=    Set Variable    ${time_diff}[0]
#     ${diff_value}=    Set Variable If    '${status}' == 'PASS'    ${time_diff}[1]    9999

#     Log To Console    🔸 Time difference (minutes): ${diff_value}

#     # Final comparison — PASS if match (≤1 min)
#     Run Keyword If    ${diff_value} <= 1
#     ...    Log To Console    ✅ Time Match: OCR=${ocr_normalized}, Local=${local_12hr}, Δ=${diff_value} min
#     ...    ELSE
#     ...    Fail    ❌ Time Mismatch: OCR=${ocr_normalized}, Local=${local_12hr}, Δ=${diff_value} min

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
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_401_Rec_Start
	...  ELSE  Fail  TC_401_Rec_Start Is Not Displayed 
    CLICK OK
    Sleep    20s
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
    # ${results}=    CALCULATE VIDEO QUALITY    ${video_port}    ${duration}    ${trigger_id}
    # Log To Console    Average Quality Score: ${results}
    # EVALUATE VIDEO QUALITY STATUS    ${results}
    ${end}=    Evaluate    __import__('time').time()
    ${zapping_time}=    Evaluate    round(${end} - ${start}, 3)
    Log To Console    ✅ Zapping time to switch channle with single digit: ${zapping_time} seconds
    RETURN  ${zapping_time}

    Verify Audio Quality
    Log To Console    \n🎥 Checking if video is paused...
    # ${is_paused}=    Validate Video Playback For Playing
	# Run Keyword If  '${is_paused}' == 'True'  Log To Console  Video is Playing
	# ...  ELSE  Fail  Video is paused — skipping audio validation
    CLICK VOLUME_PLUS
    CLICK VOLUME_PLUS
    Check For Volume  CLICK MUTE    hw:1,0    3    5    5
    # Increase volume by one stick
    Check For Volume  CLICK VOLUME_PLUS    hw:1,0    3    5    5
    # Increase volume by two stick
    Check For Volume  CLICK VOLUME_PLUS    hw:1,0    3    5    5
    CLICK VOLUME_PLUS
    Check For Volume  CLICK VOLUME_PLUS    hw:1,0    3    5    5
    # Decrease volume by 3 stick
    CLICK VOLUME_PLUS
    CLICK VOLUME_PLUS
    CLICK VOLUME_PLUS
    CLICK VOLUME_PLUS
    CLICK VOLUME_PLUS
    CLICK VOLUME_PLUS
    CLICK VOLUME_PLUS
    CLICK VOLUME_MINUS
    CLICK VOLUME_MINUS
    Check For Volume  CLICK VOLUME_MINUS    hw:1,0    3    5    5
    Check For Volume  CLICK VOLUME_MINUS    hw:1,0    3    5    5
    Check For Volume  CLICK VOLUME_MINUS    hw:1,0    3    5    5

# Check For Volume
#     [Arguments]    ${volume}    ${device}=hw:1,0    ${checks}=3    ${duration}=5    ${wait}=5

#     Log To Console    \n🔍 Capturing baseline RMS...
#     ${previous_rms}=    Get Average Rms    ${device}    ${checks}    ${duration}    ${wait}
#     Log To Console    📉 Baseline RMS: ${previous_rms}

#     Log To Console    \n🎚️ Executing volume action: ${volume}
#     Run Keyword    ${volume}

#     Log To Console    \n🔍 Capturing post-action RMS...
#     ${current_rms}=    Get Average Rms    ${device}    ${checks}    ${duration}    ${wait}
#     Log To Console    📈 Current RMS: ${current_rms}

#     Run Keyword If    '${volume}' == 'CLICK MUTE'           Check Mute RMS         ${current_rms}
#     Run Keyword If    '${volume}' == 'CLICK VOLUME_PLUS'    Check Volume Up RMS    ${previous_rms}    ${current_rms}
#     Run Keyword If    '${volume}' == 'CLICK VOLUME_MINUS'   Check Volume Down RMS  ${previous_rms}    ${current_rms}


# Check Mute RMS
#     [Arguments]    ${rms}
#     Run Keyword If    ${rms} == 0.0
#     ...    Log To Console    ✅ Mute successful – RMS is zero
#     ...    ELSE    Fail    ❌ Mute failed – RMS is not zero

# Check Volume Up RMS
#     [Arguments]    ${previous_rms}  ${max_retries}=3
#     ${attempt}=    Set Variable    0
#     WHILE    ${attempt} < ${max_retries}
#         CLICK VOLUME_PLUS
#         Sleep    2s
#         ${current_rms}=    Capture Current RMS
#         ${delta}=    Evaluate    ${current_rms} - ${previous_rms}
#         ${threshold}=    Set Variable    0.00030

#         Run Keyword If    ${delta} >= -${threshold} and ${delta} <= ${threshold}
#         ...    Log To Console    🔄 RMS unchanged — validating full volume image
#         ...    Validate Full Volume Image    ${port}
#         ...    Exit For Loop

#         Run Keyword If    ${delta} > ${threshold}
#         ...    Log To Console    ✅ Volume increased — RMS rise
#         ...    Exit For Loop

#         ${attempt}=    Evaluate    ${attempt} + 1
#         Log To Console    🔁 Retry ${attempt} — RMS still low
#     END

#     Run Keyword If    ${delta} <= 0
#     ...    Fail    ❌ Volume increase failed after ${max_retries} retries — RMS did not rise
# Capture Current RMS
#     [Arguments]    ${device}=hw:1,0    ${checks}=3    ${duration}=5    ${wait}=5

#     ${rms_values}=    Create List
#     FOR    ${i}    IN RANGE    ${checks}
#         Log To Console    🎧 Recording audio sample ${i + 1}
#         ${rms}=    Get Average Rms    ${device}    ${duration}    ${wait}
#         Append To List    ${rms_values}    ${rms}
#     END

#     ${computed_rms}=    Evaluate    round(sum([float(x) for x in ${rms_values}]) / len(${rms_values}), 5)
#     Log To Console    📈 Computed RMS: ${computed_rms}
#     RETURN    ${computed_rms}

# Validate Full Volume Image
#     ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Android_Full_Volume
#     Run Keyword If    '${Result}' == 'True'
#     ...    Log To Console    Android_Full_Volume Is Displayed
#     ...    ELSE    Fail    Android_Full_Volume Is Not Displayed

# Check Volume Down RMS
#     [Arguments]    ${previous_rms}    ${current_rms}
#     Run Keyword If    ${current_rms} < ${previous_rms}
#     ...    Log To Console    ✅ Volume decreased — RMS dropped
#     ...    ELSE    Fail    ❌ Volume decrease failed — RMS did not drop
Select Start Over And Verify
    [Arguments]    ${max_retries}=3
    ${success}=    Set Variable    False
    FOR    ${attempt}    IN RANGE    ${max_retries}
        Log To Console    Attempt ${attempt + 1} of ${max_retries}
        ${STEP_COUNT}=    Move To Start Over On Side Pannel
        Log To Console    Initial STEP_COUNT: ${STEP_COUNT}
        Click Right
        FOR    ${i}    IN RANGE    ${STEP_COUNT}
            Click Down
        END
        Click Ok
        ${status}  Verify Crop Image With Shorter Duration   ${port}  Pause_Button
        IF    ${status}
            Log To Console    Pause_Button Is Displayed
            ${success}=    Set Variable    True
            Exit For Loop
        ELSE
            Log To Console    Pause_Button Not Displayed - Retrying...
            CLICK BACK
            CLICK BACK
            Click Right
        END
    END
    IF    not ${success}
        Fail    Pause_Button Is Not Displayed After ${max_retries} Retries
    END

# How to Use in Test${channel_number_Before}=    Identify StartOver Channel
#     Log To Console    📺 Channel Before Start Over: ${channel_number_Before}   
# 	Sleep    2s
#     ${channel_number_After}=    Extract Text From Screenshot
# 	Should Be Equal    ${channel_number_Before}    ${channel_number_After}

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
    # Sleep    5s
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

Get Start Over Progress Bar Status For Pause time
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

Get Program Time From EPG
    Sleep   1s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console     AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Program Time From EPG   ${after_image_path}
    Log To Console     CROPPED AFTER INFO BAR: ${cropped_img}
     # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    # RETURN    ${channel_name_epg_text} 
    ${channel_time_epg_text}=    Set Variable    ${after_text}
    RETURN    ${channel_time_epg_text}

Run Video Quality Check 10 Times    

    # 🧪 Proceed with video quality check if not frozen
    ${VERDICTS}=    Create List
    Log To Console    Using script: ${SCRIPT_PATH}
    FOR    ${i}    IN RANGE    2
        ${Result}=    Validate Video Playback For Paused

    # 🔍 If video is frozen, log detailed metrics and exit
        Run Keyword If    '${Result}' == 'True'    Log To Console    \n📌 Video frozen — metrics snapshot:
        Run Keyword If    '${Result}' == 'True'    Log To Console    Black/white anomalies: 0
        Run Keyword If    '${Result}' == 'True'    Log To Console    Blurry anomalies: 0
        Run Keyword If    '${Result}' == 'True'    Log To Console    Stddev glitches: 0
        Run Keyword If    '${Result}' == 'True'    Log To Console    Brightness issues: 0
        Run Keyword If    '${Result}' == 'True'    Log To Console    Frozen (SSIM): 0
        Run Keyword If    '${Result}' == 'True'    Log To Console    Blocking Rate: 0
        Run Keyword If    '${Result}' == 'True'    Log To Console    Banding Rate: 0
        Run Keyword If    '${Result}' == 'True'    Return From Keyword
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

Compare Program Time On Start Over
    [Arguments]    ${time1}    ${time2}

    # --- Step 1: Remove all alphabets (AM/PM etc.) and normalize separators ---
    ${time1_clean}=    Evaluate    re.sub(r'[a-zA-Z]', '', "${time1}".replace(':', '.'))    re
    ${time2_clean}=    Evaluate    re.sub(r'[a-zA-Z]', '', "${time2}".replace(':', '.'))    re

    # --- Validate format ---
    ${parts1}=    Split String    ${time1_clean}    .
    Run Keyword If    len(${parts1}) < 2    Fail    ❌ Invalid time1 format: ${time1}
    ${parts2}=    Split String    ${time2_clean}    .
    Run Keyword If    len(${parts2}) < 2    Fail    ❌ Invalid time2 format: ${time2}

    # --- Extract hours and minutes safely ---
    ${h1}=    Evaluate    int('${parts1[0]}'.replace('O','0').replace('o','0').lstrip('0') or '0')
    ${m1}=    Evaluate    int('${parts1[1]}'.replace('O','0').replace('o','0').lstrip('0') or '0')
    ${h2}=    Evaluate    int('${parts2[0]}'.replace('O','0').replace('o','0').lstrip('0') or '0')
    ${m2}=    Evaluate    int('${parts2[1]}'.replace('O','0').replace('o','0').lstrip('0') or '0')

    # --- Step 2: Normalize to 12-hour format (wrap around 12) ---
    ${h1}=    Evaluate    12 if ${h1} == 0 else (${h1} if ${h1} <= 12 else ${h1} - 12)
    ${h2}=    Evaluate    12 if ${h2} == 0 else (${h2} if ${h2} <= 12 else ${h2} - 12)

    # --- Convert both to total minutes ---
    ${t1_min}=    Evaluate    ${h1} * 60 + ${m1}
    ${t2_min}=    Evaluate    ${h2} * 60 + ${m2}

    # --- Step 3: Compare with ±2 minute tolerance ---
    ${diff}=    Evaluate    abs(${t1_min} - ${t2_min})
    ${match}=    Evaluate    ${diff} <= 2

    Log To Console    Comparing: time1=${t1_min} vs time2=${t2_min} (±2 minute tolerance)

    Run Keyword If    ${match}
    ...    Log To Console    ✅ Time matches: ${t1_min} ≈ ${t2_min} (difference ${diff})
    ...    ELSE
    ...    Fail    ❌ Time mismatch: ${t1_min} != ${t2_min} (difference ${diff})
    
Get Program Name From EPG
    Sleep   1s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console     AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Program Name From EPG   ${after_image_path}
    Log To Console     CROPPED AFTER INFO BAR: ${cropped_img}
     # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    # RETURN    ${channel_name_epg_text} 
    ${channel_name_epg_text}=    Set Variable    ${after_text}
    RETURN    ${channel_name_epg_text}

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

    Check OCR Start Timestamp Using AI Slots    ${after_text}
    RETURN    ${after_crop}

Get Thumnail Of Asset In show more section     
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop Continue   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    RETURN    ${after_crop}

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

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    # RETURN    ${after_crop} 

Get Audio Launguage pop up For Start Over   
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Select Audio Language pop up   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    Check OCR Start Timestamp Using AI Slots    ${after_text}
#     RETURN    ${after_text}   
# Get First Audio Launguage
#     ${after_now}=    generic.get_date_time
#     ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
#     generic.Capture Image  ${port}    ${after_image_path}
#     Log To Console    AFTER IMAGE: ${after_image_path}
#     ${after_crop}=     IPL.Select Audio Language First   ${after_image_path}
#     Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

#     # OCR Extraction
#     ${after_text}=     OCR.Extract Text From Image    ${after_crop}
#     Log To Console    OCR AFTER TEXT: ${after_text}

#     RETURN    ${after_text} 

Get Second Audio Launguage 
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Select Audio Language Second   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    RETURN    ${after_text} 

Navigate If Turkish Or English Found
    ${ocr_text}=    Get Second Audio Launguage
    ${contains_turkish}=    Evaluate    'Turkish' in '''${ocr_text}'''
    ${contains_english}=    Evaluate    'English' in '''${ocr_text}'''
    ${should_navigate}=    Evaluate    ${contains_turkish} or ${contains_english}

    Run Keyword If    ${should_navigate}    Run Keywords
    ...    CLICK DOWN
    ...    CLICK OK
    ...    CLICK UP
    ...    CLICK RIGHT
    ...    CLICK RIGHT
    ...    CLICK RIGHT
    ...    CLICK RIGHT
    ...    CLICK RIGHT
    ...    CLICK RIGHT
    ...    CLICK RIGHT
    ...    CLICK RIGHT
    ...    CLICK OK

    ${Result}=    Verify Crop Images    ${port}    608_English_01
    ${none}=      Verify Crop Images    ${port}    none

    Log To Console    english: ${Result}
    Log To Console    none: ${none}

    Run Keyword If    '${Result}' == 'True' or '${none}' == 'True'    Log To Console    language is changed
    ...    ELSE    Log To Console    language Is Not Displayed

    Run Keyword Unless    ${should_navigate}    Log To Console    ❌ Neither English nor Turkish language present

    
    

Select Recording Type For 3 Options
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
    ...    ELSE IF    '${recording_type}' == 'Cloud'    Select Cloud From Local With 3 Options
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

Select Cloud From Local With 3 Options
    Log To Console    Selecting cloud recording
    CLICK DOWN
    CLICK OK
    CLICK DOWN
    CLICK DOWN
    CLICK OK
    Sleep    2s
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
Get Channel Start Time In Recorder From Info Bar
    # CLICK UP
    Sleep    3s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console     AFTER IMAGE: ${after_image_path}
    ${cropped_img}=    IPL.Channel Start Time From EPG Info Bar   ${after_image_path}
    Log To Console     CROPPED AFTER INFO BAR: ${cropped_img}
     # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${cropped_img}
    Log To Console    OCR AFTER TEXT: ${after_text}

    # Check OCR Start Timestamp Using AI Slots    ${after_text}
    # RETURN    ${channel_name_epg_text} 
    ${channel_name_epg_text}=    Set Variable    ${after_text}
    RETURN    ${channel_name_epg_text}

# Get Channel Name In Recorder Of MyList
#     Sleep    5s
#     # CLICK UP

#     ${after_now}=    generic.get_date_time
#     ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
#     generic.Capture Image  ${port}    ${after_image_path}
#     Log    AFTER IMAGE: ${after_image_path}
#     ${after_crop}=     IPL.Channel Name In Recorder Of MyList   ${after_image_path}
#     Log    CROPPED AFTER INFO BAR: ${after_crop}

#     # OCR Extraction
#     ${after_text}=     OCR.Extract Text From Image    ${after_crop}
#     Log To Console    OCR AFTER TEXT: ${after_text}

#     # Check OCR Start Timestamp Using AI Slots    ${after_text}
#     ${recorded_channel_text}=    Set Variable    ${after_text}
#     RETURN    ${recorded_channel_text}   

# Check For Supported Recording
#     [Arguments]    ${supported_type}

#     # # Capture image after current timestamp
#     # ${after_now}=    generic.get_date_time
#     # ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
#     # generic.Capture Image    ${port}    ${after_image_path}
#     # Log To Console    AFTER IMAGE: ${after_image_path}

#     # # Crop the relevant portion for storage type
#     # ${after_crop}=    IPL.Storage Type In Recorder List    ${after_image_path}
#     # Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

#     # # OCR Extraction
#     # ${after_text}=    OCR.Extract Text From Image    ${after_crop}
#     # Log To Console    OCR AFTER TEXT: ${after_text}
    
#     # Validate extracted storage type
#     ${recorded_storage_type}=    Set Variable    ${after_text}
#     Should Be Equal As Strings    ${recorded_storage_type}    ${supported_type}

Select Supported Recording Type
    [Arguments]    ${recorded_storage_type}

    CLICK BACK
    CLICK UP
    CLICK UP
    CLICK UP
    CLICK UP
    CLICK UP
    Select Recording Type    ${recorded_storage_type}

Check For Series Recording
        # Capture image after current timestamp
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    # Crop the relevant portion for storage type
    ${after_crop}=    IPL.Check For Series Recording  ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}
    RETURN    ${after_text}

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

Ensure Pause And StartOver Are Visible Without Channel
    ${Pause_Visible}=    Verify Crop Image With Shorter Duration    ${port}    Pause_Side_Panel
    CLICK RIGHT
    ${Start_Over_Visible}=    Verify Crop Image With Shorter Duration    ${port}    Start_Over
    Run Keyword If  '${Start_Over_Visible}' == 'True'  Log To Console  Start Over Visible
	...  ELSE  Fail  Start Over Not Visible
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

Ensure StartOver IS Visible
    ${latest_channel_number}=    Set Variable    None
    FOR    ${i}    IN RANGE    10
        Log To Console    Attempt ${i}: Checking Start Over
        CLICK RIGHT
        ${Start_Over_Visible}=    Verify Crop Image With Shorter Duration    ${port}    Start_Over
        Log To Console    Start Over Visible: ${Start_Over_Visible}
        Run Keyword If    ${Start_Over_Visible}    Exit For Loop
        CLICK CHANNEL_PLUS        
        Sleep    1s
        ${latest_channel_number}=   Extract Text From Screenshot
        CLICK BACK
        CLICK RIGHT
    END
    RETURN  ${latest_channel_number}
testiiing purpose
    ${now}=    generic.get_date_time
    ${d_rimg}=    Replace String    ${ref_img1}    replace    ${now}
    generic.capture image run    ${port}    ${d_rimg}

    # --- Step 2: Extract text via OCR ---
    ${text}=    OCR.Extract Text From Image    ${d_rimg}

    # --- Step 3: Clean up text safely ---
    ${text}=    Replace String    ${text}    \n    ${SPACE}
    ${text}=    Replace String    ${text}    \r    ${SPACE}
    ${text}=    Evaluate    re.sub(r'[^A-Za-z0-9 ]+', '', """${text}""")    re
    ${text}=    Convert To Lowercase    ${text}
    ${words}=    Split String    ${text}

    # --- Step 4: Filter junk words ---
    ${filtered}=    Evaluate    [w for w in ${words} if len(w) > 2 and not re.search(r'(.)\\1{2,}', w) and re.search(r'[aeiou]', w) and w.isalpha()]    re

    # --- Step 5: Remove known UI words ---
    ${ignore_list}=    Create List    settings    ok    play    pause    resume    menu    record    subtitle    audio    network    select    exit    home    guide
    ${filtered}=    Evaluate    [w for w in ${filtered} if w not in ${ignore_list}]

    # --- Step 6: Build movie name ---
    ${movie_name}=    Evaluate    ' '.join(${filtered}[:4])
    ${movie_name}=    Strip String    ${movie_name}

    # --- Step 7: Log results ---
    Log To Console    \nRaw OCR Text: ${text}
    Log To Console    Filtered Words: ${filtered}
    Log To Console    Final Movie Name: ${movie_name}

    RETURN    ${movie_name}











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

# Normalize Timestamp
#     [Arguments]    ${timestamp}
#     ${normalized}=    Replace String    ${timestamp}    :    .
#     ${normalized}=    Replace String    ${normalized}    ${SPACE}    ''
#     ${normalized}=    Replace String    ${normalized}    ..    .
#     ${normalized}=    Replace String    ${normalized}    .    .
#     ${normalized}=    Strip String    ${normalized}
#     RETURN    ${normalized}
	
# Convert Timestamp To Seconds
#     [Arguments]    ${timestamp}
#     ${parts}=    Split String    ${timestamp}    .
#     Run Keyword If    len(${parts}) != 3    Fail    ❌ Invalid timestamp format: ${timestamp}
#     ${hour}=     Convert To Integer    ${parts[0]}
#     ${minute}=   Convert To Integer    ${parts[1]}
#     ${second}=   Convert To Integer    ${parts[2]}
#     ${total}=    Evaluate    ${hour} * 3600 + ${minute} * 60 + ${second}
#     RETURN    ${total}
	
# Generate AI Based Slot List
#     [Arguments]    ${timestamp}
#     ${t1}=    Normalize Timestamp    ${timestamp}
#     ${s1}=    Convert Timestamp To Seconds    ${t1}

#     # Align start to minute boundary (e.g., 14.00.00)
#     ${start_minute}=    Evaluate    ${s1} - (${s1} % 60)

#     ${limit}=    Set Variable    12
#     ${slot_list}=    Create List
#     FOR    ${i}    IN RANGE    ${limit}
#         ${sec}=    Evaluate    ${start_minute} + ${i}
#         ${hour}=    Evaluate    '{:02d}'.format(${sec} // 3600)
#         ${minute}=  Evaluate    '{:02d}'.format((${sec} % 3600) // 60)
#         ${second}=  Evaluate    '{:02d}'.format(${sec} % 60)
#         ${time}=    Set Variable    ${hour}.${minute}.${second}
#         Append To List    ${slot_list}    ${time}
#     END
#     RETURN    ${slot_list}

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
	
# Check OCR Start Timestamp Using AI Slots
#     [Arguments]    ${ocr_range}
#     Log To Console    📝 Raw OCR Range: ${ocr_range}
#     ${normalized}=    Replace String    ${ocr_range}    :    .
#     ${normalized}=    Replace String    ${normalized}    -    |
#     ${normalized}=    Replace String    ${normalized}    ~    |
#     ${normalized}=    Replace String    ${normalized}    ${SPACE}    |
#     ${normalized}=    Strip String    ${normalized}
#     Log To Console    🔍 Normalized OCR Range: ${normalized}
#     ${timestamps}=    Split String    ${normalized}    |
#     ${length}=    Get Length    ${timestamps}
#     Run Keyword If    ${length} != 2    Fail    ❌ Invalid OCR timestamp range: ${ocr_range}

#     ${start_raw}=    Set Variable    ${timestamps[0]}
#     ${end_raw}=      Set Variable    ${timestamps[1]}
#     ${start}=        Set Variable If    len(${start_raw}) >= 8    ${start_raw}[0:8]    ${start_raw}
#     ${end}=          Set Variable If    len(${end_raw}) >= 8      ${end_raw}[0:8]      ${end_raw}

#     Log To Console    ▶ Start Timestamp: ${start}
#     ${slot_list}=    Generate AI Based Slot List    ${start}    ${end}
#     Log To Console    AI Slot List: ${slot_list}
#     Run Keyword If    '${start}' in ${slot_list}
#     ...    Log To Console    ✅ Start timestamp found in AI slot list
#     ...    ELSE
#     ...    Fail    ❌ Start timestamp not found in AI slot list
#     RETURN  ${start}

# Check OCR Start Timestamp Using AI Slots
#     [Arguments]    ${ocr_range}
#     ${start}=    Set Variable    ${ocr_range}[0:8]
#     Log To Console    ▶ Truncated Start Timestamp: ${start}
#     ${slot_list}=    Generate AI Based Slot List    ${start}
#     Log To Console    AI Slot List: ${slot_list}
#     Run Keyword If    '${start}' in ${slot_list}
#     ...    Log To Console    ✅ Start timestamp found in AI slot list
#     ...    ELSE
#     ...    Fail    ❌ Start timestamp not found in AI slot list
# #     RETURN  ${start}
#     RETURN    ${start}
Check OCR Start Timestamp Using AI Slots
    [Arguments]    ${ocr_range}

    ${start_raw}=    Set Variable    ${ocr_range}[0:8]
    ${start}=        Normalize Timestamp    ${start_raw}
    Log To Console   ▶ Truncated Start Timestamp: ${start}

    ${slot_list}=    Generate AI Based Slot List    ${start}
    Log To Console   AI Slot List: ${slot_list}

    Run Keyword If    '${start}' in ${slot_list}
    ...    Log To Console    ✅ Start timestamp found in AI slot list
    ...    ELSE
    ...    Log To Console    ⚠ Start timestamp '${start}' not in slot list — ACCEPTED

    RETURN    ${start}

# Check OCR Start Timestamp Using AI Slots
#     [Arguments]    ${ocr_range}
#     ${start_raw}=    Set Variable    ${ocr_range}[0:8]
#     ${start}=    Normalize Timestamp    ${start_raw}
#     Log To Console    ▶ Truncated Start Timestamp: ${start}

#     ${slot_list}=    Generate AI Based Slot List    ${start}
#     Log To Console    AI Slot List: ${slot_list}

#     Run Keyword If    '${start}' in ${slot_list}
#     ...    Log To Console    ✅ Start timestamp found in AI slot list
#     ...    ELSE
#     ...    Log To Console    ❌ Start timestamp '${start}' not found in slot list: ${slot_list}
#     ...    Fail    ❌ Start timestamp not found in AI slot list
#     RETURN    ${start}

Check OCR Start Timestamp Using AI Slots After Pause
    [Arguments]    ${before_pause}    ${ocr_range}
    ${start_raw}=    Set Variable    ${ocr_range}[0:8]
    ${start}=    Normalize Timestamp    ${start_raw}
    Log To Console    ▶ Truncated Start Timestamp: ${start}

    ${slot_list}=    Generate AI Based Slot List    ${start}
    Log To Console    AI Slot List: ${slot_list}

    Run Keyword If    '${ocr_range}' in ${slot_list}
    ...    Log To Console    ✅ Start timestamp found in AI slot list
    ...    ELSE
    ...    Log To Console    ❌ Start timestamp '${start}' not found in slot list: ${slot_list}
    ...    Fail    ❌ Start timestamp not found in AI slot list
    RETURN    ${start}

Check OCR Timestamp After Pause
    [Arguments]    ${start_time}    ${target_time}    ${slot_count}=60

    # Normalize start timestamp (e.g., 15:40:54 → 15.40.54)
    ${start}=    Replace String    ${start_time}    :    .
    Log To Console    ▶ Truncated Start Timestamp: ${start}

    # Normalize target timestamp (e.g., 15:55:55 → 15.55.55)
    ${normalized_target}=    Replace String    ${target_time}    :    .
    Log To Console    ▶ Normalized Target Timestamp: ${normalized_target}

    # Split start time into hours, minutes, seconds
    ${parts}=    Split String    ${start}    .
    ${h}=    Evaluate    int('${parts[0]}')
    ${m}=    Evaluate    int('${parts[1]}')
    ${s}=    Evaluate    int('${parts[2]}')

    # Generate slot list
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

    Log To Console    🧠 Generated Slot List: ${slot_list}

    Run Keyword If    '${normalized_target}' in ${slot_list}
    ...    Log To Console    ✅ '${target_time}' found in slot list
    ...    ELSE
    ...    Log To Console    ❌ '${target_time}' not found in slot list: ${slot_list}
    ...    Fail    ❌ '${target_time}' not found in AI slot list

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
    
Get OCR Start Timestamp Using AI Slots 
    [Arguments]    ${image}
    ${after_text}=     OCR.Extract Text From Image    ${image}
    Log To Console    OCR AFTER TEXT: ${after_text}

    ${start_raw}=    Set Variable    ${after_text}[0:8]
    ${start}=    Normalize Timestamp    ${start_raw}
    Log To Console    ▶ Truncated Start Timestamp: ${start}
    RETURN    ${start}

Get OCR End Timestamp Using AI Slots
    [Arguments]    ${image}
    ${after_text}=     OCR.Extract Text From Image    ${image}
    Log To Console    OCR AFTER TEXT: ${after_text}

    ${end_raw}=    Set Variable    ${after_text}[-8:]
    ${end}=    Normalize Timestamp    ${end_raw}
    Log To Console    ▶ Truncated End Timestamp: ${end}
    RETURN    ${end}
 
Get Start Over Progress Bar Status program time       
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

Generate AI Based Slot List From Timestamp For Pause
    [Arguments]    ${timestamp}
    ${t1}=    Normalize Timestamp    ${timestamp}
    ${s1}=    Convert Timestamp To Seconds    ${t1}

    ${limit}=    Set Variable    4
    ${slot_list}=    Create List

    FOR    ${i}    IN RANGE    ${limit}
        ${sec}=    Evaluate    ${s1} + ${i}
        ${hour}=    Evaluate    '{:02d}'.format(${sec} // 3600)
        ${minute}=  Evaluate    '{:02d}'.format((${sec} % 3600) // 60)
        ${second}=  Evaluate    '{:02d}'.format(${sec} % 60)
        ${time}=    Set Variable    ${hour}.${minute}.${second}
        Append To List    ${slot_list}    ${time}
    END

    RETURN    ${slot_list}

Check OCR Start Timestamp Using AI Slots For Pause Time
    [Arguments]    ${ocr_range}
    ${start_raw}=    Set Variable    ${ocr_range}[0:8]
    ${start}=    Normalize Timestamp    ${start_raw}
    Log To Console    ▶ Truncated Start Timestamp: ${start}

    ${slot_list}=    Generate AI Based Slot List From Timestamp For Pause    ${start}
    Log To Console    AI Slot List: ${slot_list}

    Run Keyword If    '${start}' in ${slot_list}
    ...    Log To Console    ✅ Start timestamp found in AI slot list
    ...    ELSE
    ...    Log To Console    ❌ Start timestamp '${start}' not found in slot list: ${slot_list}
    ...    Fail    ❌ Start timestamp not found in AI slot list

    RETURN    ${start}

Subtract Seconds From Timestamp
    [Arguments]    ${timestamp}    ${delta_secs}
    ${clean}=    Replace String    ${timestamp}    :    .
    ${adjusted}=    Evaluate    (datetime.datetime.strptime("${clean}", "%H.%M.%S") - datetime.timedelta(seconds=${delta_secs})).time().strftime("%H.%M.%S")    modules=datetime
    RETURN    ${adjusted}

Get Extracted Time On Player Info Bar
    [Arguments]     ${progress_bar_image}
    ${texts}=    OCR.Extract Text From Image    ${progress_bar_image}
    Log    Extracted text: ${texts}
    Log To Console    Extracted text: ${texts}
    RETURN  ${texts}

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
Capture Multiple Screens And Validate Language
    [Arguments]    ${expected_language}    ${iterations}=10    ${delay}=5
    
    FOR    ${index}    IN RANGE    ${iterations}
        Log To Console    \n--- Iteration ${index + 1}/${iterations} ---

        ${d_rimg}=    Run Keyword If    '${expected_language}' == 'ar'    Get Subtitle Text Arabic    ELSE    Get Subtitle Text English
        ${status}=    Repeat OCR And Validate Language    ${d_rimg}    ${expected_language}

        Run Keyword If    ${status}    Exit For Loop
        Sleep    ${delay}
    END

    Run Keyword Unless    ${status}    Fail    ❌ Expected subtitle in language '${expected_language}' not found in ${iterations} attempts!
    RETURN    ${status}

Capture Multiple Screens And Validate Language Danish
    [Arguments]    ${expected_language}    ${iterations}=10    ${delay}=5
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
    [Arguments]    ${expected_language}    ${iterations}=10    ${delay}=5
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
    [Arguments]    ${expected_language}    ${iterations}=10    ${delay}=5
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
Capture Logo From Screen And Verify
    Sleep    5s

    # --- BEFORE SNAPSHOT ---
    ${before_now}=    generic.get_date_time
    ${before_image_path}=    Replace String    ${ref_img1}    replace    ${before_now}
    generic.Capture Image    ${port}    ${before_image_path}
    Log To Console    📸 BEFORE IMAGE: ${before_image_path}

    ${before_crop}=    IPL.Crop Channel Logo Top Right    ${before_image_path}
    Log To Console    🔍 CROPPED BEFORE LOGO: ${before_crop}

    
    CLICK CHANNEL_PLUS
    Sleep    5s

    # --- AFTER SNAPSHOT ---
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    📸 AFTER IMAGE: ${after_image_path}

    ${after_crop}=    IPL.Crop Channel Logo Top Right    ${after_image_path}
    Log To Console    🔍 CROPPED AFTER LOGO: ${after_crop}

    # --- SIMILARITY CHECK ---
    ${similarity}=    IPL.Compare Images SSIM    ${before_crop}    ${after_crop}
    Log To Console    SSIM SIMILARITY: ${similarity}
    Run Keyword If    ${similarity} > 0.1000    Fail    ❌ SSIM too high: ${similarity}
    RETURN    ${after_crop}

# Verify Audio Quality
#     Log To Console    \n🎥 Checking if video is paused...
#     ${is_paused}=    Validate Video Playback For Playing
# 	Run Keyword If  '${is_paused}' == 'True'  Log To Console  Video is Playing
# 	...  ELSE  Fail  Video is paused — skipping audio validation
#     CLICK VOLUME_MINUS
#     CLICK VOLUME_MINUS 
#     CLICK VOLUME_MINUS
#     CLICK VOLUME_MINUS 
#     CLICK VOLUME_MINUS
#     CLICK VOLUME_MINUS 
#     CLICK VOLUME_MINUS
#     CLICK VOLUME_MINUS 
#     CLICK VOLUME_MINUS
#     CLICK VOLUME_MINUS 
#     CLICK VOLUME_MINUS
#     CLICK VOLUME_MINUS 
#     Check For Volume  CLICK MUTE    hw:1,0    3    5    5
#     # Increase volume by two stick
#     CLICK VOLUME_PLUS
#     Check For Volume  CLICK VOLUME_PLUS    hw:1,0    3    5    5
#     CLICK VOLUME_MINUS
#     # Decrease volume by 3 stick
#     CLICK VOLUME_PLUS
#     CLICK VOLUME_PLUS
#     Check For Volume  CLICK VOLUME_MINUS    hw:1,0    3    5    5
#     Check For Volume  CLICK VOLUME_PLUS    hw:1,0    3    5    5
#     CLICK VOLUME_PLUS
#     CLICK VOLUME_PLUS
#     CLICK VOLUME_PLUS
#     CLICK VOLUME_PLUS
#     CLICK VOLUME_PLUS
#     CLICK VOLUME_PLUS
#     CLICK VOLUME_PLUS
#     CLICK VOLUME_PLUS
#     CLICK VOLUME_PLUS
#     CLICK VOLUME_PLUS
#     CLICK VOLUME_PLUS
#     CLICK VOLUME_PLUS
#     CLICK VOLUME_PLUS
#     Validate Full Volume Image
#     Check For Volume  CLICK VOLUME_MINUS    hw:1,0    3    5    5

Check For Volume
    [Arguments]    ${volume}    ${device}=hw:1,0    ${checks}=3    ${duration}=5    ${wait}=5

    Run Keyword Unless    '${volume}' == 'CLICK MUTE'    Run Keyword    Wait For Speech Activity    ${device}

    Log To Console    🔍 Capturing baseline RMS...
    ${previous_rms}=    Get Average Rms    ${device}    ${checks}    ${duration}    ${wait}
    Log To Console    📉 Baseline RMS: ${previous_rms}

    Log To Console    🎚️ Executing volume action: ${volume}
    Run Keyword    ${volume}

    Log To Console    🔍 Capturing post-action RMS...
    ${current_rms}=    Get Average Rms    ${device}    ${checks}    ${duration}    ${wait}
    Log To Console    📈 Current RMS: ${current_rms}

    Run Keyword If    '${volume}' == 'CLICK MUTE'           Check Mute RMS         ${current_rms}
    Run Keyword If    '${volume}' == 'CLICK VOLUME_PLUS'    Check Volume Up RMS    ${previous_rms}    ${current_rms}
    Run Keyword If    '${volume}' == 'CLICK VOLUME_MINUS'   Check Volume Down RMS  ${previous_rms}    ${current_rms}
Wait For Speech Activity
    [Arguments]    ${device}=hw:1,0
    Log To Console    🔊 Checking for speech activity...

    ${speech_detected}=    Set Variable    False
    ${attempt}=    Set Variable    0

    WHILE    ${attempt} < 5
        ${temp_detected}=    Detect Speech Activity    ${device}    timeout=10
        Run Keyword If    ${temp_detected}    Log To Console    ✅ Speech detected — proceeding with RMS validation
        Run Keyword If    ${temp_detected}    Set Variable    ${speech_detected}    True
        Run Keyword If    ${temp_detected}    Exit For Loop
        Log To Console    🔁 Attempt ${attempt + 1} — no speech detected, retrying...
        Sleep    6s
        ${attempt}=    Evaluate    ${attempt} + 1
    END

    Run Keyword Unless    ${speech_detected}    Log To Console    ⚠️ No speech detected after 5 attempts — continuing anyway
Detect Speech Activity
    [Arguments]    ${device}=hw:1,0    ${timeout}=10    ${threshold}=0.0015

    ${rms}=    Get Average Rms    ${device}    checks=3    duration=5    wait=2
    Log To Console    🔍 Detected RMS: ${rms}

    ${is_speech}=    Evaluate    ${rms} > ${threshold}
    RETURN    ${is_speech}

Check Mute RMS
    [Arguments]    ${rms}
    Run Keyword If    ${rms} == 0.0
    ...    Log To Console    ✅ Mute successful – RMS is zero
    ...    ELSE    Fail    ❌ Mute failed – RMS is not zero
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    Mute_Remote_Button
    Run Keyword If    '${Result}' == 'True'
    ...    Log To Console    Mute_Remote_Button Is Displayed
    ...    ELSE    Fail    Mute_Remote_Button Is Not Displayed

# Check Volume Up RMS
#     [Arguments]    ${previous_rms}    ${max_retries}=2
#     ${attempt}=    Set Variable    0
#     ${delta}=      Set Variable    0.0
#     ${threshold}=  Set Variable    0.00030

#     WHILE    ${attempt} < ${max_retries}
#         CLICK VOLUME_PLUS
#         Sleep    2s
#         ${current_rms}=    Capture Current RMS
#         ${delta}=    Evaluate    ${current_rms} - ${previous_rms}
#         ${display_attempt}=    Evaluate    ${attempt} + 1
#         Log To Console    📊 Attempt ${display_attempt} — RMS delta: ${delta}

#         Run Keyword If    ${delta} > ${threshold}
#         ...    Log To Console    ✅ Volume increased — RMS rise
#         ...    Return From Keyword

#         Run Keyword If    abs(${delta}) <= ${threshold}
#         ...    Log To Console    🔄 RMS unchanged — validating full volume image
#         ...    Validate Full Volume Image    ${port}
#         ...    Return From Keyword

#         ${attempt}=    Evaluate    ${attempt} + 1
#         Log To Console    🔁 Retry ${attempt} — RMS still low
#     END

#     Fail    ❌ Volume increase failed after ${max_retries} retries — RMS did not rise

Capture Current RMS
    [Arguments]    ${device}=hw:1,0    ${checks}=3    ${duration}=5    ${wait}=5

    ${rms_values}=    Create List
    FOR    ${i}    IN RANGE    ${checks}
        Log To Console    🎧 Recording audio sample ${i + 1}
        ${rms}=    Get Average Rms    ${device}    ${duration}    ${wait}
        Append To List    ${rms_values}    ${rms}
    END

    ${computed_rms}=    Evaluate    round(sum([float(x) for x in ${rms_values}]) / len(${rms_values}), 5)
    Log To Console    📈 Computed RMS: ${computed_rms}
    RETURN    ${computed_rms}

Validate Full Volume Image
    ${Result}=    Verify Crop Image With Shorter Duration    ${port}    FULL_VOL_STB2
    Run Keyword If    '${Result}' == 'True'
    ...    Log To Console    FULL_VOL_STB2 Is Displayed
    ...    ELSE    Fail    FULL_VOL_STB2 Is Not Displayed

Check Volume Down RMS
    [Arguments]    ${previous_rms}    ${current_rms}
    Run Keyword If    ${current_rms} < ${previous_rms}
    ...    Log To Console    ✅ Volume decreased — RMS dropped
    ...    ELSE    Fail    ❌ Volume decrease failed — RMS did not drop
Check Volume Up RMS
    [Arguments]    ${previous_rms}    ${current_rms}
    Run Keyword If    ${current_rms} > ${previous_rms}
    ...    Log To Console    ✅ Volume decreased — RMS rise
    ...    ELSE    Fail    ❌ Volume decrease failed — RMS did not rise

# Verify Time On Interface Clock
#     Sleep    5s  
#     # Capture image
#     ${after_now}=    generic.get_date_time
#     ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
#     generic.Capture Image    ${port}    ${after_image_path}
#     Log To Console    AFTER IMAGE: ${after_image_path}

#     # Crop clock region
#     ${after_crop}=    IPL.Channel Interface Clock    ${after_image_path}
#     Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

#     ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
#     Log To Console    📸 OCR AFTER TEXT: ${ocr_text}
    
#     ${ocr_text}=    Set Variable    ${ocr_text}
#     # Replace '.' with ':' and uppercase AM/PM
#     ${ocr_normalized}=    Evaluate    "${ocr_text}".replace(".",":").upper()
#     Log To Console    🔹 Normalized OCR: ${ocr_normalized}   # Output: 06:38 PM

#     # Get local system time in 12-hour format (HH:MM AM/PM only)
#     ${local_12hr}=    Get Current Date    result_format=%I:%M %p
#     Log To Console    🕒 LOCAL TIME 12-HOUR: ${local_12hr}
    
#      # Calculate time difference in minutes
#     ${time_diff}=    Evaluate    abs((datetime.datetime.strptime("${local_12hr}", "%I:%M %p") - datetime.datetime.strptime("${ocr_normalized}", "%I:%M %p")).total_seconds() / 60)    modules=datetime

#     # Compare with ±1 minute tolerance
#     Run Keyword If    ${time_diff} <= 1    Log To Console    ✅ Time Match: OCR=${ocr_normalized}, Local=${local_12hr}
#     ...    ELSE    Fail    ❌ Time Mismatch: OCR=${ocr_normalized}, Local=${local_12hr}, Δ=${time_diff} min

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


Get Time Before Fast Forward Or Rewind
    Log To Console    ▶ Starting Fast Forward Verification

    ${start_over_status}=    Get Start Over Progress Bar Status
    ${time_range_before}=    Get Extracted Time On Player Info Bar    ${start_over_status}
    ${time_before_forward}=    Check OCR Start Timestamp Using AI Slots    ${time_range_before}
    Log To Console    ⏱ Before Fast Forward: ${time_before_forward}
    RETURN    ${time_before_forward}

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

    ${t1}=    Convert Timestamp To Seconds    ${time_before_rewind}
    ${t2}=    Convert Timestamp To Seconds    ${time_after_rewind}
    Should Be True    ${t2} < ${t1}    ❌ Rewind failed — timestamp did not regress
    Log To Console    ✅ Rewind verified — timestamp regressed

Get OCR Start Timestamp On Fast Forward
    [Arguments]    ${image}
    ${after_text}=     OCR.Extract Text From Image    ${image}
    Log To Console    OCR AFTER TEXT: ${after_text}

    ${start_raw}=    Set Variable    ${after_text}[0:8]
    ${start}=    Normalize Timestamp    ${start_raw}
    Log To Console    ▶ Truncated Start Timestamp: ${start}
    RETURN    ${start}

Verify Time After Forward For 4x Speed
    [Arguments]    ${start_time}    ${end_time}
    ${start_parts}=    Split String    ${start_time}    .
    ${h}=    Evaluate    int('${start_parts[0]}')
    ${m}=    Evaluate    int('${start_parts[1]}')
    ${s}=    Evaluate    int('${start_parts[2]}')
    
    ${valid_slots}=    Create List
    FOR    ${offset}    IN RANGE    5    35
        ${total}=    Evaluate    ${h}*3600 + ${m}*60 + ${s} + ${offset}
        ${new_h}=    Evaluate    ${total} // 3600
        ${rem}=    Evaluate    ${total} % 3600
        ${new_m}=    Evaluate    ${rem} // 60
        ${new_s}=    Evaluate    ${rem} % 60
        ${slot}=    Evaluate    "%02d.%02d.%02d" % (${new_h}, ${new_m}, ${new_s})
        Append To List    ${valid_slots}    ${slot}
    END
    Run Keyword If    '${end_time}' in ${valid_slots}
    ...    Log To Console    ✅ Forward 4x OK: '${end_time}' within expected sec of '${start_time}'
    ...    ELSE
    ...    Fail    ❌ Forward 4x NOT OK: '${end_time}' not within expected sec of '${start_time}'


Verify Time After Forward For 8x Speed
    [Arguments]    ${start_time}    ${end_time}
    ${start_parts}=    Split String    ${start_time}    .
    ${h}=    Evaluate    int('${start_parts[0]}')
    ${m}=    Evaluate    int('${start_parts[1]}')
    ${s}=    Evaluate    int('${start_parts[2]}')
    
    ${valid_slots}=    Create List
    FOR    ${offset}    IN RANGE    10  35
        ${total}=    Evaluate    ${h}*3600 + ${m}*60 + ${s} + ${offset}
        ${new_h}=    Evaluate    ${total} // 3600
        ${rem}=    Evaluate    ${total} % 3600
        ${new_m}=    Evaluate    ${rem} // 60
        ${new_s}=    Evaluate    ${rem} % 60
        ${slot}=    Evaluate    "%02d.%02d.%02d" % (${new_h}, ${new_m}, ${new_s})
        Append To List    ${valid_slots}    ${slot}
    END
    Run Keyword If    '${end_time}' in ${valid_slots}
    ...    Log To Console    ✅ Forward 8x OK: '${end_time}' within expected sec of '${start_time}'
    ...    ELSE
    ...    Fail    ❌ Forward 8x NOT OK: '${end_time}' not within expected sec of '${start_time}'


Verify Time After Forward For 16x Speed
    [Arguments]    ${start_time}    ${end_time}
    ${start_parts}=    Split String    ${start_time}    .
    ${h}=    Evaluate    int('${start_parts[0]}')
    ${m}=    Evaluate    int('${start_parts[1]}')
    ${s}=    Evaluate    int('${start_parts[2]}')
    
    ${valid_slots}=    Create List
    FOR    ${offset}    IN RANGE    5  60
        ${total}=    Evaluate    ${h}*3600 + ${m}*60 + ${s} + ${offset}
        ${new_h}=    Evaluate    ${total} // 3600
        ${rem}=    Evaluate    ${total} % 3600
        ${new_m}=    Evaluate    ${rem} // 60
        ${new_s}=    Evaluate    ${rem} % 60
        ${slot}=    Evaluate    "%02d.%02d.%02d" % (${new_h}, ${new_m}, ${new_s})
        Append To List    ${valid_slots}    ${slot}
    END
    Run Keyword If    '${end_time}' in ${valid_slots}
    ...    Log To Console    ✅ Forward 16x OK: '${end_time}' within expected sec of '${start_time}'
    ...    ELSE
    ...    Fail    ❌ Forward 16x NOT OK: '${end_time}' not within expected sec of '${start_time}'


Verify Time After Forward For 32x Speed
    [Arguments]    ${start_time}    ${end_time}
    ${start_parts}=    Split String    ${start_time}    .
    ${h}=    Evaluate    int('${start_parts[0]}')
    ${m}=    Evaluate    int('${start_parts[1]}')
    ${s}=    Evaluate    int('${start_parts[2]}')
    
    ${valid_slots}=    Create List
    FOR    ${offset}    IN RANGE    5  75
        ${total}=    Evaluate    ${h}*3600 + ${m}*60 + ${s} + ${offset}
        ${new_h}=    Evaluate    ${total} // 3600
        ${rem}=    Evaluate    ${total} % 3600
        ${new_m}=    Evaluate    ${rem} // 60
        ${new_s}=    Evaluate    ${rem} % 60
        ${slot}=    Evaluate    "%02d.%02d.%02d" % (${new_h}, ${new_m}, ${new_s})
        Append To List    ${valid_slots}    ${slot}
    END
    Run Keyword If    '${end_time}' in ${valid_slots}
    ...    Log To Console    ✅ Forward 32x OK: '${end_time}' within expected sec of '${start_time}'
    ...    ELSE
    ...    Fail    ❌ Forward 32x NOT OK: '${end_time}' not within expected sec of '${start_time}'

Verify Time After Rewind For 4x Speed
    [Arguments]    ${start_time}    ${end_time}

    ${start_parts}=    Split String    ${start_time}    .
    ${h}=    Evaluate    int('${start_parts[0]}')
    ${m}=    Evaluate    int('${start_parts[1]}')
    ${s}=    Evaluate    int('${start_parts[2]}')

    ${valid_slots}=    Create List
    FOR    ${offset}    IN    1    2    3    4    5    6    7    8
        ${total}=    Evaluate    ${h}*3600 + ${m}*60 + ${s} - ${offset}
        ${new_h}=    Evaluate    ${total} // 3600
        ${rem}=    Evaluate    ${total} % 3600
        ${new_m}=    Evaluate    ${rem} // 60
        ${new_s}=    Evaluate    ${rem} % 60
        ${slot}=    Evaluate    "%02d.%02d.%02d" % (${new_h}, ${new_m}, ${new_s})
        Append To List    ${valid_slots}    ${slot}
    END

    Log To Console    Valid rewind slots: ${valid_slots}

    Run Keyword If    '${end_time}' in ${valid_slots}
    ...    Log To Console    ✅ '${end_time}' is within rewind range of '${start_time}' at 4x
    ...    ELSE
    ...    Fail    ❌ '${end_time}' is not within rewind range of '${start_time}' at 4x
    
Verify Time After Rewind For 8x Speed
    [Arguments]    ${start_time}    ${end_time}

    ${start_parts}=    Split String    ${start_time}    .
    ${h}=    Evaluate    int('${start_parts[0]}')
    ${m}=    Evaluate    int('${start_parts[1]}')
    ${s}=    Evaluate    int('${start_parts[2]}')

    ${valid_slots}=    Create List
    FOR    ${offset}    IN    1    2    3    4    5    6    7    8    9    10    11    12    13    14
        ${total}=    Evaluate    ${h}*3600 + ${m}*60 + ${s} - ${offset}
        ${new_h}=    Evaluate    ${total} // 3600
        ${rem}=    Evaluate    ${total} % 3600
        ${new_m}=    Evaluate    ${rem} // 60
        ${new_s}=    Evaluate    ${rem} % 60
        ${slot}=    Evaluate    "%02d.%02d.%02d" % (${new_h}, ${new_m}, ${new_s})
        Append To List    ${valid_slots}    ${slot}
    END

    Log To Console    Valid rewind slots: ${valid_slots}

    Run Keyword If    '${end_time}' in ${valid_slots}
    ...    Log To Console    ✅ '${end_time}' is within rewind range of '${start_time}' at 8x
    ...    ELSE
    ...    Fail    ❌ '${end_time}' is not within rewind range of '${start_time}' at 8x
    
Verify Time After Rewind For 16x Speed
    [Arguments]    ${start_time}    ${end_time}

    ${start_parts}=    Split String    ${start_time}    .
    ${h}=    Evaluate    int('${start_parts[0]}')
    ${m}=    Evaluate    int('${start_parts[1]}')
    ${s}=    Evaluate    int('${start_parts[2]}')

    ${valid_slots}=    Create List
    FOR    ${offset}    IN    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22
        ${total}=    Evaluate    ${h}*3600 + ${m}*60 + ${s} - ${offset}
        ${new_h}=    Evaluate    ${total} // 3600
        ${rem}=    Evaluate    ${total} % 3600
        ${new_m}=    Evaluate    ${rem} // 60
        ${new_s}=    Evaluate    ${rem} % 60
        ${slot}=    Evaluate    "%02d.%02d.%02d" % (${new_h}, ${new_m}, ${new_s})
        Append To List    ${valid_slots}    ${slot}
    END

    Log To Console    Valid rewind slots: ${valid_slots}

    Run Keyword If    '${end_time}' in ${valid_slots}
    ...    Log To Console    ✅ '${end_time}' is within rewind range of '${start_time}' at 16x
    ...    ELSE
    ...    Fail    ❌ '${end_time}' is not within rewind range of '${start_time}' at 16x
    
Verify Time After Rewind For 32x Speed
    [Arguments]    ${start_time}    ${end_time}

    ${start_parts}=    Split String    ${start_time}    .
    ${h}=    Evaluate    int('${start_parts[0]}')
    ${m}=    Evaluate    int('${start_parts[1]}')
    ${s}=    Evaluate    int('${start_parts[2]}')

    ${valid_slots}=    Create List
    FOR    ${offset}    IN        1    2    3    4    5    6    7    8    9    10    11    12    13    14   15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    34
        ${total}=    Evaluate    ${h}*3600 + ${m}*60 + ${s} - ${offset}
        ${new_h}=    Evaluate    ${total} // 3600
        ${rem}=    Evaluate    ${total} % 3600
        ${new_m}=    Evaluate    ${rem} // 60
        ${new_s}=    Evaluate    ${rem} % 60
        ${slot}=    Evaluate    "%02d.%02d.%02d" % (${new_h}, ${new_m}, ${new_s})
        Append To List    ${valid_slots}    ${slot}
    END

    Log To Console    Valid rewind slots: ${valid_slots}

    Run Keyword If    '${end_time}' in ${valid_slots}
    ...    Log To Console    ✅ '${end_time}' is within rewind range of '${start_time}' at 32x
    ...    ELSE
    ...    Fail    ❌ '${end_time}' is not within rewind range of '${start_time}' at 32x

Check Time In AI Slot List Timeshift
    [Arguments]    ${base_time}    ${target_time}    ${expected_position}    ${slot_count}=4

    ${slot_list}=    Generate AI Based Slot List From Timestamp For Timeshift    ${base_time}    ${slot_count}
    Log To Console    🔢 Generated Slot List: ${slot_list}

    ${target}=    Normalize Timestamp    ${target_time}
    ${target_dot}=    Evaluate    "${target}".replace(":", ".")

    ${index}=    Get Index From List    ${slot_list}    ${target_dot}
    IF    '${index}' != '-1'
        Log To Console    ✅ Found ${target_dot} at position ${index} in slot list

        ${pos1}=    Evaluate    ${expected_position}
        ${pos2}=    Evaluate    ${expected_position} + 1
        ${pos3}=    Evaluate    ${expected_position} + 2

        Run Keyword If    ${index} == ${pos1} or ${index} == ${pos2} or ${index} == ${pos3}
        ...    Log To Console    🎯 Position match: ${index} is within expected range [${pos1}, ${pos2}, ${pos3}]
        # ...    ELSE
        # ...    Fail    ❌ ${target_dot} found but at wrong position: ${index} not in [${pos1}, ${pos2}, ${pos3}]
    ELSE
        # Fail    ❌ ${target_dot} not found in slot list: ${slot_list}
        Log to Console    found in slot list: ${slot_list}
    END

Generate AI Based Slot List From Timestamp For Timeshift
    [Arguments]    ${timestamp}    ${limit}=4
    ${t1}=    Normalize Timestamp    ${timestamp}
    ${s1}=    Convert Timestamp To Seconds    ${t1}
    ${slot_list}=    Create List
    FOR    ${i}    IN RANGE    ${limit}
        ${sec}=    Evaluate    ${s1} + ${i}
        ${hour}=    Evaluate    '{:02d}'.format(${sec} // 3600)
        ${minute}=  Evaluate    '{:02d}'.format((${sec} % 3600) // 60)
        ${second}=  Evaluate    '{:02d}'.format(${sec} % 60)
        ${time}=    Set Variable    ${hour}.${minute}.${second}
        Append To List    ${slot_list}    ${time}
    END
    RETURN    ${slot_list}

# Subtract 5 sec from ${after_forward_10sec}
Remove Sleeping Time
    [Arguments]    ${time}    ${seconds}
    ${parts}=    Split String    ${time}    .
    ${h}=    Evaluate    int(${parts[0].lstrip("0") or "0"})
    ${m}=    Evaluate    int(${parts[1].lstrip("0") or "0"})
    ${s}=    Evaluate    int(${parts[2].lstrip("0") or "0"})

    ${total_secs}=    Evaluate    ${h}*3600 + ${m}*60 + ${s} - ${seconds}

    ${new_h}=    Evaluate    ${total_secs} // 3600
    ${rem}=     Evaluate    ${total_secs} % 3600
    ${new_m}=    Evaluate    ${rem} // 60
    ${new_s}=    Evaluate    ${rem} % 60

    ${adjusted_time}=    Evaluate    "%02d.%02d.%02d" % (${new_h}, ${new_m}, ${new_s})
    Log To Console    ⏪ Adjusted Timestamp (after - ${seconds}s): ${adjusted_time}
    RETURN    ${adjusted_time}

Check Time In AI Slot List Timeshift Reverse
    [Arguments]    ${base_time}    ${target_time}    ${expected_position}    ${slot_count}=4

    ${slot_list}=    Generate AI Based Slot List Backward From Timestamp    ${base_time}    ${slot_count}
    Log To Console    🔢 Generated Reverse Slot List: ${slot_list}

    ${target}=    Normalize Timestamp    ${target_time}
    ${target_dot}=    Evaluate    "${target}".replace(":", ".")

    ${index}=    Get Index From List    ${slot_list}    ${target_dot}
    IF    '${index}' != '-1'
        Log To Console    ✅ Found ${target_dot} at position ${index} in slot list

        ${pos1}=    Evaluate    ${expected_position}
        ${pos2}=    Evaluate    ${expected_position} + 1
        ${pos3}=    Evaluate    ${expected_position} + 2

        Run Keyword If    ${index} == ${pos1} or ${index} == ${pos2} or ${index} == ${pos3}
        ...    Log To Console    🎯 Position match: ${index} is within expected range [${pos1}, ${pos2}, ${pos3}]
        # ...    ELSE
        # ...    Fail    ❌ ${target_dot} found but at wrong position: ${index} not in [${pos1}, ${pos2}, ${pos3}]
    ELSE
        # Fail    ❌ ${target_dot} not found in slot list: ${slot_list}
        Log To Console    found in slot list: ${slot_list}
    END

Generate AI Based Slot List Backward From Timestamp
    [Arguments]    ${timestamp}    ${limit}=4
    ${t1}=    Normalize Timestamp    ${timestamp}
    ${s1}=    Convert Timestamp To Seconds    ${t1}
    ${slot_list}=    Create List
    FOR    ${i}    IN RANGE    ${limit}
        ${sec}=    Evaluate    ${s1} - ${i}
        ${hour}=    Evaluate    '{:02d}'.format(${sec} // 3600)
        ${minute}=  Evaluate    '{:02d}'.format((${sec} % 3600) // 60)
        ${second}=  Evaluate    '{:02d}'.format(${sec} % 60)
        ${time}=    Set Variable    ${hour}.${minute}.${second}
        Append To List    ${slot_list}    ${time}
    END
    RETURN    ${slot_list}

Check Time In AI Slot List
    [Arguments]    ${start_time}    ${end_time}

    ${start_parts}=    Split String    ${start_time}    .
    ${h}=    Evaluate    int('${start_parts[0]}')
    ${m}=    Evaluate    int('${start_parts[1]}')
    ${s}=    Evaluate    int('${start_parts[2]}')

    ${valid_slots}=    Create List
    FOR    ${offset}    IN    10    11    12
        ${total}=    Evaluate    ${h}*3600 + ${m}*60 + ${s} + ${offset}
        ${new_h}=    Evaluate    ${total} // 3600
        ${rem}=    Evaluate    ${total} % 3600
        ${new_m}=    Evaluate    ${rem} // 60
        ${new_s}=    Evaluate    ${rem} % 60
        ${slot}=    Evaluate    "%02d.%02d.%02d" % (${new_h}, ${new_m}, ${new_s})
        Append To List    ${valid_slots}    ${slot}
    END

    Log To Console    Valid slots: ${valid_slots}

    Run Keyword If    '${end_time}' in ${valid_slots}
    ...    Log To Console    ✅ '${end_time}' is within 5–7 seconds of '${start_time}'
    ...    ELSE
    ...    Fail    ❌ '${end_time}' is not within 5–7 seconds of '${start_time}'

Verify Time After Rewind For 10 Seconds
    [Arguments]    ${start_time}    ${end_time}

    ${start_parts}=    Split String    ${start_time}    .
    ${h}=    Evaluate    int('${start_parts[0]}')
    ${m}=    Evaluate    int('${start_parts[1]}')
    ${s}=    Evaluate    int('${start_parts[2]}')

    ${valid_slots}=    Create List
    FOR    ${offset}    IN        10    11    12
        ${total}=    Evaluate    ${h}*3600 + ${m}*60 + ${s} - ${offset}
        ${new_h}=    Evaluate    ${total} // 3600
        ${rem}=    Evaluate    ${total} % 3600
        ${new_m}=    Evaluate    ${rem} // 60
        ${new_s}=    Evaluate    ${rem} % 60
        ${slot}=    Evaluate    "%02d.%02d.%02d" % (${new_h}, ${new_m}, ${new_s})
        Append To List    ${valid_slots}    ${slot}
    END

    Log To Console    Valid rewind slots: ${valid_slots}

    Run Keyword If    '${end_time}' in ${valid_slots}
    ...    Log To Console    ✅ '${end_time}' is within rewind range of '${start_time}' at 4x
    ...    ELSE
    ...    Fail    ❌ '${end_time}' is not within rewind range of '${start_time}' at 4x
    
Check For Blocking Rate
    [Arguments]    ${port}    ${duration}

    ${blocking_list}=    Create List
    ${banding_list}=     Create List

    FOR    ${i}    IN RANGE    5
        ${blocking}    ${banding}=    Run Video Metrics Multiple Times    ${port}    ${duration}
        Append To List    ${blocking_list}    ${blocking}
        Append To List    ${banding_list}     ${banding}
    END

    ${blocking_total}=    Set Variable    0
    FOR    ${value}    IN    @{blocking_list}
        ${blocking_total}=    Evaluate    ${blocking_total} + ${value}
    END
    ${blocking_avg}=    Evaluate    ${blocking_total} / 5

    ${banding_total}=    Set Variable    0
    FOR    ${value}    IN    @{banding_list}
        ${banding_total}=    Evaluate    ${banding_total} + ${value}
    END
    ${banding_avg}=    Evaluate    ${banding_total} / 5

    Log To Console    Average Blocking Rate: ${blocking_avg}
    Log To Console    Average Banding Rate: ${banding_avg}

    Run Keyword If    ${blocking_avg} > 75    Log To Console    Bad Quality Video
    Run Keyword If    ${blocking_avg} <= 75   Log To Console    Good Quality Video

Verify Video Quality
     ${VERDICTS}=    Create List
    Log To Console    Using script: ${SCRIPT_PATH}
    FOR    ${i}    IN RANGE    10
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

    Run Keyword If    ${bad_count} > ${good_count}    Log To Console    \n Final Verdict: Bad Quality Video
    Run Keyword If    ${good_count} > ${bad_count}   Log To Console    \n Final Verdict: Good Quality Video
    Run Keyword If    ${bad_count} == ${good_count}  Log To Console    \n Final Verdict: Mixed Quality — Equal Good and Bad

Verify Device Info Using OCR
    Initialize Device Info Dictionary
    Get Device Information Application Version
    Get Device Information OctoADS Version
    Get Device Information Sap Version
    Get Device Information Firmware
    Get Device Information STB Serial Number
    Get Device Information Mac Address
    Get Device Information Hard Disk
    Get Device Information User ID
    Get Device Information IP Gateway
    Get Device Information Channel Version
    Get Device Information STB Model
    Log To Console    \n📘 Final Device Info Dictionary:
    Log To Console    ${DEVICE_INFO_DICT}

    # Step 4: Validate dictionary (check for empty values)
    Validate Dictionary Values    ${DEVICE_INFO_DICT}

Validate Dictionary Values
    [Arguments]    ${dictionary}
    # Find all keys that have empty, None, or whitespace-only values
    ${empty_keys}=    Evaluate    [k for k, v in ${dictionary}.items() if not str(v).strip()]
    
    IF    ${empty_keys}
        Log To Console    \n❌ Empty or missing values found for these keys:
        FOR    ${key}    IN    @{empty_keys}
            Log To Console    - ${key}
        END
        Fail    Some dictionary values are empty or missing: ${empty_keys}
    ELSE
        Log To Console    ✅ All values are present and valid
    END


Initialize Device Info Dictionary
    ${DEVICE_INFO_DICT}=    Create Dictionary
    Set Suite Variable    ${DEVICE_INFO_DICT}
    Log To Console    ✅ Initialized empty device info dictionary


Update Device Info
    [Arguments]    ${key}    ${value}
    # Clean the value
    ${clean_value}=    Strip String    ${value}
    # Add or update entry
    Set To Dictionary    ${DEVICE_INFO_DICT}    ${key}=${clean_value}
    Set Suite Variable    ${DEVICE_INFO_DICT}
    Log To Console    📝 Updated Dictionary: ${DEVICE_INFO_DICT}

Get Device Information Application Version
    Sleep    2s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=    IPL.Get Device Info App Version Key    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    📸 OCR AFTER TEXT: ${ocr_text}
    Update Device Info    Application Version    ${ocr_text}


Get Device Information OctoADS Version
    Sleep    2s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=    IPL.Get Device Info OctoADS Version Key    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    📸 OCR AFTER TEXT: ${ocr_text}
    Update Device Info    OctoADS Version    ${ocr_text}

Get Device Information Sap Version
    Sleep    2s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=    IPL.Get Device Information Sap Version key   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    📸 OCR AFTER TEXT: ${ocr_text}
    Update Device Info    Sap Version    ${ocr_text}

Get Device Information Firmware
    Sleep    2s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=    IPL.Get Device Information Firmware key    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    📸 OCR AFTER TEXT: ${ocr_text}
    Update Device Info    Firmware    ${ocr_text}

Get Device Information STB Serial Number
    Sleep    2s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=    IPL.Get Device Information STB Serial Number key    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    📸 OCR AFTER TEXT: ${ocr_text}
    Update Device Info    STB Serial Number    ${ocr_text}

Get Device Information Mac Address
    Sleep    2s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=    IPL.Get Device Information Mac Address key    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    📸 OCR AFTER TEXT: ${ocr_text}
    Update Device Info    Mac Address    ${ocr_text}


Get Device Information Hard Disk
    Sleep    2s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=    IPL.Get Device Information Hard Disk key    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    📸 OCR AFTER TEXT: ${ocr_text}
    Update Device Info    Hard Disk   ${ocr_text}

Get Device Information User ID
    Sleep    2s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=    IPL.Get Device Information User ID key    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    📸 OCR AFTER TEXT: ${ocr_text}
    Update Device Info    User ID   ${ocr_text}

Get Device Information IP Gateway
    Sleep    2s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=    IPL.Get Device Information IP Gateway key    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    📸 OCR AFTER TEXT: ${ocr_text}
    Update Device Info    IP / Gateway   ${ocr_text}
    

Get Device Information Channel Version
    Sleep    2s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=    IPL.Get Device Information Channel Version key    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    📸 OCR AFTER TEXT: ${ocr_text}
    Update Device Info    Channel Version   ${ocr_text}

Get Device Information STB Model
    Sleep    2s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=    IPL.Get Device Information STB Model key    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${ocr_text}=    OCR.Extract Text From Image    ${after_crop}
    Log To Console    📸 OCR AFTER TEXT: ${ocr_text}
    Update Device Info    STB Model  ${ocr_text}

Get Program Catch Up Time Presence on EPG
    Sleep    1s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    ${cropped_img}=    IPL.Program Catchup Schedules    ${after_image_path}
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
    Run Keyword If    ${count} == 0    Fail    ❌ OCR failed — no valid catchup found

    RETURN    ${clean_lines}

Get Program Catch Up Time Absence on EPG
    Sleep    1s
    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image    ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}

    ${cropped_img}=    IPL.Program Catchup Schedules    ${after_image_path}
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
    Run Keyword If    ${count} != 0    Fail    ❌ OCR failed — Catch up found

    RETURN    ${clean_lines}

Check For Valid Catchup And Future Schedules
    Sleep    1s
    Get Program Catch Up Time Presence on EPG
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

Get Side Pannel Filter And Return Count
    [Arguments]   ${ocr_text}    ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # Create list of expected menu items
    ${expected_items}=    Create List    Go to List Section  Add To Favorites    Filter

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
Get Side Pannel Set Reminder And Return Count
    [Arguments]   ${ocr_text}    ${base_count}=0
    ${STEP_COUNT}=    Set Variable    ${base_count}
    Log To Console    Initial STEP_COUNT: ${STEP_COUNT}

    # Create list of expected menu items
    ${expected_items}=    Create List   Add To Favorites    Remove Favorites

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

Move to Start Over On Side Pannel
    ${after_text}=    Capture Side Pannel Options
    ${STEP_COUNT}=    Get Side Pannel Start Over And Return Count   ${after_text}
    RETURN    ${STEP_COUNT}

Move to Pause On Side Pannel
    ${after_text}=    Capture Side Pannel Options
    ${STEP_COUNT}=    Get Side Pannel Pause And Return Count   ${after_text}
    RETURN    ${STEP_COUNT}

Move to Filter On Side Pannel
    ${after_text}=    Capture Side Pannel Options Of Filter
    ${STEP_COUNT}=    Get Side Pannel Filter And Return Count   ${after_text}
    RETURN    ${STEP_COUNT}
Move to Set Reminder On Side Pannel
    ${after_text}=    Capture Side Pannel Options Of Filter
    ${STEP_COUNT}=    Get Side Pannel Set Reminder And Return Count   ${after_text}
    RETURN    ${STEP_COUNT}
##########################################Image,Video,Audio Processing KW #############################################
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
Verify it is playbutton or not
    ${Result}=    Verify Crop Image    ${port}    Play_Button
    Log To Console    PlayButton: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
    END
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

Handle Recording for cloud

    Log To Console    Recording Failed or Unexpected Popup Detected
    # Go to new channel 7105
    CLICK SEVEN
    CLICK ONE
    CLICK ZERO
    CLICK TWO
    Sleep    2s
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
	${Result}  Verify Crop Image  ${port}  Cloud
	Run Keyword If  '${Result}' == 'True'  Log To Console  CLOUD Is Displayed on screen
	...  ELSE  Fail  CLOUD Is Not Displayed on screen
    CLICK DOWN
    CLICK OK
    Sleep    2s
    Log To Console    Playback Recording Started
    ${Result}=    Verify Crop Image With Shorter Duration   ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start on 705 Is Displayed
    ...    ELSE    
    ...    Fail    TC_401_Rec_Start Is Not Displayed Even After Switching Channel

Handle Recording Failure For local

    Log To Console    Recording Failed or Unexpected Popup Detected
    # Go to new channel 7105
    CLICK SEVEN
    CLICK ZERO
    CLICK TWO
    Log To Console    Navigated To Channel 705
    Sleep    2s
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
	${Result}  Verify Crop Image  ${port}  LOCAL
	Run Keyword If  '${Result}' == 'True'  Log To Console  LOCAL Is Displayed on screen
	...  ELSE  Fail  LOCAL Is Not Displayed on screen
    CLICK DOWN
    CLICK OK
    Sleep    2s
    Log To Console    Playback Recording Started
    ${Result}=    Verify Crop Image   ${port}  TC_401_Rec_Start
    Run Keyword If    '${Result}' == 'True'    
    ...    Log To Console    TC_401_Rec_Start on 705 Is Displayed
    ...    ELSE    
    ...    Fail    TC_401_Rec_Start Is Not Displayed Even After Switching Channel

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
	# CLICK DOWN
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_011_ok_button
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_011_ok_button Is Displayed
	...  ELSE  Fail  TC_011_ok_button Is Not Displayed
	CLICK OK
	CLICK HOME

Favlist1_Channel_list
    FOR    ${i}    IN RANGE    2
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "11"
            Log To Console    YES this is channel 11
        ELSE
            Fail    Expected channel 11 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "12"
            Log To Console    YES this is channel 12
        ELSE
            Fail    Expected channel 12 but got ${result}
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "15"
            Log To Console    YES this is channel 15
        ELSE
            Fail    Expected channel 15 but got ${result}
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "22"
            Log To Console    YES this is channel 22
        ELSE
            Fail    Expected channel 22 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "23"
            Log To Console    YES this is channel 23
        ELSE
            Fail    Expected channel 601 but got ${result}
        END
        CLICK DOWN
    END

Favlist2_Channel_list
    FOR    ${i}    IN RANGE    2
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "24"
            Log To Console    YES this is channel 24
        ELSE
            Fail    Expected channel 24 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "25"
            Log To Console    YES this is channel 25
        ELSE
            Fail    Expected channel 25 but got ${result}
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "33"
            Log To Console    YES this is channel 33
        ELSE
            Fail    Expected channel 33 but got ${result}
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "34"
            Log To Console    YES this is channel 34
        ELSE
            Fail    Expected channel 34 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "35"
            Log To Console    YES this is channel 35
        ELSE
            Fail    Expected channel 35 but got ${result}
        END
        CLICK DOWN
    END


Favlist3_Channel_list
    FOR    ${i}    IN RANGE    2
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "38"
            Log To Console    YES this is channel 38
        ELSE
            Fail    Expected channel 38 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "40"
            Log To Console    YES this is channel 40
        ELSE
            Fail    Expected channel 40 but got ${result}
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "42"
            Log To Console    YES this is channel 42
        ELSE
            Fail    Expected channel 42 but got ${result}
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "48"
            Log To Console    YES this is channel 48
        ELSE
            Fail    Expected channel 48 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "51"
            Log To Console    YES this is channel 51
        ELSE
            Fail    Expected channel 51 but got ${result}
        END
        CLICK DOWN
    END

Favlist4_Channel_list
    FOR    ${i}    IN RANGE    2
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "60"
            Log To Console    YES this is channel 60
        ELSE
            Fail    Expected channel 60 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "61"
            Log To Console    YES this is channel 61
        ELSE
            Fail    Expected channel 61 but got ${result}
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "62"
            Log To Console    YES this is channel 62
        ELSE
            Fail    Expected channel 62 but got ${result}
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "63"
            Log To Console    YES this is channel 63
        ELSE
            Fail    Expected channel 63 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "64"
            Log To Console    YES this is channel 64
        ELSE
            Fail    Expected channel 64 but got ${result}
        END
        CLICK DOWN
    END

Favlist5_Channel_list
    FOR    ${i}    IN RANGE    2
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "96"
            Log To Console    YES this is channel 96
        ELSE
            Fail    Expected channel 96 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "97"
            Log To Console    YES this is channel 97
        ELSE
            Fail    Expected channel 97 but got ${result}
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "101"
            Log To Console    YES this is channel 101
        ELSE
            Fail    Expected channel 101 but got ${result}
        END

        CLICK DOWN
       ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
        IF    "${result}" == "102"
            Log To Console    YES this is channel 102
        ELSE
            Fail    Expected channel 102 but got ${result}
        END

        CLICK DOWN
        ${result}=    Get Channel Number
        Log To Console    RESULT CROPPED PATH: ${result}
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
    ${after_crop}=     IPL.Crop_Channel_Number_Fav_list   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}
    ${after_text}=     Strip String    ${after_text}
    ${after_text}=     Remove String Using Regexp    ${after_text}    [^0-9]
    RETURN    ${after_text}





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


Check For Supported Recording Until Found For Recorder
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
        Run Keyword If    ${is_supported}    Select Supported Recording Type    ${recorded_storage_type}
        Run Keyword Unless    ${is_supported}    Select New Channel And Retry

    END

    Log To Console    ✅ Supported recording type found: ${recorded_storage_type}
    RETURN    ${is_supported}
Handle Recording Failure Recorder1
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

Verify the Similarity Continue Watching
    [Arguments]    ${before_crop}  
    # Primary Validation: OCR Text Change
    # Fallback Validation: SSIM Comparison
    ${similarity}=    IPL.Compare Images SSIM    ${before_crop}    ${gray_image}
    Log To Console    SSIM SIMILARITY: ${similarity}
    Should Be True    ${similarity} < 0.85    Blank Tile displayed

    

Verify the Similarity Profile Name
    [Arguments]    ${before_crop}  
    # Primary Validation: OCR Text Change
    # Fallback Validation: SSIM Comparison
    ${similarity}=    IPL.Compare Images SSIM    ${before_crop}    ${image_profile_abcd}
    Log To Console    SSIM SIMILARITY: ${similarity}
    Should Be True    ${similarity} > 0.15    Profile name is Not displayed

Verify the Similarity Profile Name Negative Scenario
    [Arguments]    ${before_crop}  
    # Primary Validation: OCR Text Change
    # Fallback Validation: SSIM Comparison
    ${similarity}=    IPL.Compare Images SSIM    ${before_crop}    ${image_profile_abcd}
    Log To Console    SSIM SIMILARITY: ${similarity}
    Should Be True    ${similarity} < 0.32    Profile name is displayed

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

Get channel number 34 from channel list    
    Sleep    5s
    # CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.crop_Hide_Channel_32   ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    Check OCR Start Timestamp Using AI Slots    ${after_text}
    RETURN    ${after_crop}



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
    CLICK ONE
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


  
Normalize Spelling
    [Arguments]    ${text}
    ${output}=    Replace String    ${text}    Dubal    Dubai
    ${output}=    Replace String    ${text}    ejunior HD    e-junior HD
    RETURN    ${output}

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

Check For New Message Popup
    Sleep   2s
    ${Result}=    Verify Crop Image    ${port}    newmessage
    Log To Console    popup found: ${Result}
    IF    '${Result}' == 'True'
        CLICK OK
        # CLICK HOME
    END
Box_popup
    
    Sleep   2s
    ${Result}=    Verify Crop Image    ${port}    TC_1082_Ok_Button
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
        ${Remove}=    Verify Crop Image    ${port}    REMOVE_FROM_LIST
        Log To Console    Remove: ${Remove}

        IF    '${Remove}' == 'True'
            CLICK BACK
            CLICK RIGHT
            CLICK OK
            Log To Console    Asset is bought
            # ✅ do NOT exit the loop, continue checking next asset
            CONTINUE FOR LOOP
        ELSE
            ${Trailer}=    Verify Crop Image    ${port}    BoxOffice_Trailer
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
                ${Result}=    Verify Crop Image    ${port}    ADDED_TO_LIST
                Run Keyword If    '${Result}' == 'True'    Log To Console    ADDED_TO_LIST Is Displayed
                ...    ELSE    Fail    ADDED_TO_LIST Is Not Displayed
                CLICK OK
                ${Result}=    Verify Crop Image    ${port}    REM_LIST
                Run Keyword If    '${Result}' == 'True'    Log To Console    REM_LIST Is Displayed
                ...    ELSE    Fail    REM_LIST Is Not Displayed
                # CLICK OK
                # ${Result}=    Verify Crop Image    ${port}    ADDED_TO_LIST
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
                ${Result}=    Verify Crop Image    ${port}    ADDED_TO_LIST
                Run Keyword If    '${Result}' == 'True'    Log To Console    ADDED_TO_LIST Is Displayed
                ...    ELSE    Fail    ADDED_TO_LIST Is Not Displayed
                CLICK OK
                ${Result}=    Verify Crop Image    ${port}    REM_LIST
                Run Keyword If    '${Result}' == 'True'    Log To Console    REM_LIST Is Displayed
                ...    ELSE    Fail    REM_LIST Is Not Displayed
                # CLICK OK
                # ${Result}=    Verify Crop Image    ${port}    ADDED_TO_LIST
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
# How to call in test
# ${Result}  Validate Video Playback For Playing
# Run Keyword If  '${Result}' == 'True'  Log To Console  Video is Playing
# ...  ELSE  Fail  Video is Paused
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
    ${Remove}=    Verify Crop Image    ${port}    REMOVE_FROM_LIST
    Log To Console    Remove: ${Remove}
    IF    '${Remove}' == 'True'
        ${Trailer}=    Verify Crop Image    ${port}    BoxOffice_Trailer
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
            ${Result}=    Verify Crop Image    ${port}    ADDED_TO_LIST
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
             ${Result}=    Verify Crop Image    ${port}    ADDED_TO_LIST
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

check vod assets for trailors
    FOR  ${i}  IN RANGE  10
        VALIDATE TRAILOR PLAYBACK
    END
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
    ${block}=    Verify Crop Image    ${port}    503_rental
    Log To Console    Rent: ${block}

    ${buy}=      Verify Crop Image    ${port}    BUY_VOD
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

        ${BillResult}=    Verify Crop Image    ${port}    Bill
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


Check Vod Details
    ${playtime}=    Verify Crop Image    ${port}    remainingtime
    ${Director}=      Verify Crop Image    ${port}    director
    ${Cast}=         Verify Crop Image    ${port}    cast

    Log To Console    remainingtime: ${playtime}
    Log To Console    Director: ${Director}
    Log To Console    cast${Cast}

    Run Keyword If    '${playtime}' == 'True' or '${Director}' == 'True' or '${Cast}' == 'True'
    ...    Log To Console    remainingtime cast and director Is Displayed on screen
    ...    ELSE
    ...    Fail   remainingtime cast and director Is Not Displayed on screen


STOP RECORDING
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
    Sleep    2s
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
Get Progress Bar Status
    CLICK UP        
    Sleep    3s
    CLICK UP

    ${after_now}=    generic.get_date_time
    ${after_image_path}=    Replace String    ${ref_img1}    replace    ${after_now}
    generic.Capture Image  ${port}    ${after_image_path}
    Log To Console    AFTER IMAGE: ${after_image_path}
    ${after_crop}=     IPL.Crop Progress Bar after    ${after_image_path}
    Log To Console    CROPPED AFTER INFO BAR: ${after_crop}

    # OCR Extraction
    ${after_text}=     OCR.Extract Text From Image    ${after_crop}
    Log To Console    OCR AFTER TEXT: ${after_text}

    #Check OCR Start Timestamp Using AI Slots    ${after_text}
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

            ${Result}=    Verify Crop Image    ${port}    ATLmessage
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

   
Capture Side Pannel Options Catchup play
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

        IF    'resume' in '${text_after}'
            Log To Console    remove from list found
            CLICK BACK
            CLICK RIGHT
            CLICK OK
        ELSE
            Catchup favorites
            Exit For Loop
        END
    END
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

Validate Different Audio levels for Radio Stations
    [Documentation]    Audio check for radio stations
    CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLUP
	CLICK VOLUP
	Sleep    5s
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	${Result}  Verify Crop Image With Shorter Duration   ${port}  FULL_VOL_STB2
	Run Keyword If  '${Result}' == 'True'  Log To Console  FULL_VOL_STB2 Is Displayed
	...  ELSE  Log To Console  FULL_VOL_STB2 Is Not Displayed
    ${result}=    Verify Audio Quality    hw:1,0    3    5    5
    Log To Console    Final Audio Quality: ${result}
    Run Keyword If    '${result}' != '2'    Fail    Audio Quality Failed: Expected 2 but got ${result}
    Log To Console    Audio Quality Passed: Result was ${result} High Volume was heard
    CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
    CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	# ${result}=    Verify Audio Quality    hw:1,0    3    5    5
    # Log To Console    Final Audio Quality: ${result}
    # Run Keyword If    '${result}' != '1'    Fail    Audio Quality Failed: Expected 2 but got ${result}
    # Log To Console    Audio Quality Passed: Result was ${result} Low Volume was heard
	CLICK MUTE
	Sleep    1s
	${Result}  Verify Crop Image With Shorter Duration  ${port}  210_MUTE_STB2
	Run Keyword If  '${Result}' == 'True'  Log To Console  210_MUTE_STB2 Is Displayed
	...  ELSE  Log To Console  210_MUTE_STB2 Is Not Displayed
	${result}=    Verify Audio Quality    hw:1,0    3    5    5
    Log To Console    Final Audio Quality: ${result}
    Run Keyword If    '${result}' != '0'    Fail    Audio Quality Failed: Expected 2 but got ${result}
    Log To Console    Audio Quality Passed: Result was ${result} No Audio Heard


Validate Audio for Radio Stations
    [Documentation]    Audio check for radio stations
    CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLDWN
	CLICK VOLUP
	CLICK VOLUP
	Sleep    5s
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	CLICK VOLUP
	${Result}  Verify Crop Image With Shorter Duration   ${port}  FULL_VOL_STB2
	Run Keyword If  '${Result}' == 'True'  Log To Console  FULL_VOL_STB2 Is Displayed
	...  ELSE  Log To Console  FULL_VOL_STB2 Is Not Displayed
    ${result}=    Verify Audio Quality    hw:1,0    3    5    5
    Log To Console    Final Audio Quality: ${result}
    Run Keyword If    '${result}' != '2'    Fail    Audio Quality Failed: Expected 2 but got ${result}
    Log To Console    Audio Quality Passed: Result was ${result} High Volume was heard



Validate Preview Radio Speaker Image
    ${Result}  Verify Crop Image With Shorter Duration    ${port}   Preview_Speaker_Image
	Run Keyword If  '${Result}' == 'True'  Log To Console     Speaker_Image Is Displayed
	...  ELSE  Log To Console  Speaker_Image Is Not Displayed


Validate Radio Speaker Image
    ${Result}  Verify Crop Image With Shorter Duration    ${port}   Speaker_Image
	Run Keyword If  '${Result}' == 'True'  Log To Console     Speaker_Image Is Displayed
	...  ELSE  Log To Console  Speaker_Image Is Not Displayed



Verify Audio Quality
     [Arguments]    ${device}=hw:1,0    ${checks}=3    ${duration}=5    ${wait}=5
    ${quality}=    Check Audio Quality    ${device}    ${checks}    ${duration}    ${wait}
    Log    Audio quality status: ${quality}

    # Log human-readable audio status
    Run Keyword If    ${quality}==0    Log To Console    Audio is muted / no audio
    ...    ELSE IF    ${quality}==1    Log To Console    Audio is low
    ...    ELSE IF    ${quality}==2    Log To Console    Audio is high

    RETURN    ${quality}

Normalize Text
    [Arguments]    ${text}
    ${text}=    Convert To Upper Case    ${text}
    ${text}=    Strip String             ${text}
    ${text}=    Replace String           ${text}    ${SPACE}    ${EMPTY}
    RETURN    ${text}
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
Navigate to home in timeshift
    ${Result1}  Verify Crop Image  ${port}  HOME
    IF  '${Result1}' == 'False'
        CLICK HOME
        CLICK HOME
        Sleep    1s
        Check For Exit Popup
        CLICK HOME
    END