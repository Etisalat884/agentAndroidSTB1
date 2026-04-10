
TC_502_BROWSE_ONDEMAND_PLAYBACK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image  ${port}  PLAY_BUTTON
	Run Keyword If  '${Result}' == 'True'  Log To Console  PLAY_BUTTON Is Displayed
	...  ELSE  Fail  PLAY_BUTTON Is Not Displayed
	
	CLICK DOWN
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image  ${port}  FAST_FORWARD_BUTTON
	Run Keyword If  '${Result}' == 'True'  Log To Console  FAST_FORWARD_BUTTON Is Displayed
	...  ELSE  Fail  FAST_FORWARD_BUTTON Is Not Displayed
	
