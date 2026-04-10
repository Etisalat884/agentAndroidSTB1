
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
	
	CLICK RIGHT
	${Result}  Verify Crop Image  ${port}  Live_Background_Pause
	Run Keyword If  '${Result}' == 'True'  Log To Console  Live_Background_Pause Is Displayed
	...  ELSE  Fail  Live_Background_Pause Is Not Displayed
	
