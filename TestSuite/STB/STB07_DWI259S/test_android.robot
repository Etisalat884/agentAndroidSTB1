
test_android
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image  ${port}  PAUSE
	Run Keyword If  '${Result}' == 'True'  Log To Console  PAUSE Is Displayed
	...  ELSE  Fail  PAUSE Is Not Displayed
	
	CLICK OK
	CLICK HOME
