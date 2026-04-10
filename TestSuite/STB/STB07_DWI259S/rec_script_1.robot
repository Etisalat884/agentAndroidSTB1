
rec_script_1
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image  ${port}  TC_OTT_006_TV_Trending
	Run Keyword If  '${Result}' == 'True'  Log To Console  TC_OTT_006_TV_Trending Is Displayed on screen
	...  ELSE  Fail  TC_OTT_006_TV_Trending Is Not Displayed on screen
	
	CLICK RIGHT
	CLICK HOME
