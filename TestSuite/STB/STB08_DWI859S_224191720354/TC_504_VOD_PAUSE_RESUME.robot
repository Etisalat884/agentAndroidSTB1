
TC_504_VOD_PAUSE_RESUME
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
	CLICK OK
	${Result}  Verify Crop Image  ${port}  ${IMG_name}
	Run Keyword If  '${Result}' == 'True'  Log To Console  ${IMG_name} Is Displayed
	...  ELSE  Fail  ${IMG_name} Is Not Displayed
	
	CLICK OK
	CLICK OK
