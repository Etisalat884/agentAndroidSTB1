
TC_506_VOD_REWIND_RESUME
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
	CLICK LEFT
	CLICK OK
	${Result}  Verify Crop Image  ${port}  ${IMG_name}
	Run Keyword If  '${Result}' == 'True'  Log To Console  ${IMG_name} Is Displayed
	...  ELSE  Fail  ${IMG_name} Is Not Displayed
	
	CLICK OK
	${Result}  Verify Crop Image  ${port}  ${IMG_name}
	Run Keyword If  '${Result}' == 'True'  Log To Console  ${IMG_name} Is Displayed
	...  ELSE  Fail  ${IMG_name} Is Not Displayed
	
	CLICK OK
	${Result}  Verify Crop Image  ${port}  ${IMG_name}
	Run Keyword If  '${Result}' == 'True'  Log To Console  ${IMG_name} Is Displayed
	...  ELSE  Fail  ${IMG_name} Is Not Displayed
	
	CLICK OK
	${Result}  Verify Crop Image  ${port}  ${IMG_name}
	Run Keyword If  '${Result}' == 'True'  Log To Console  ${IMG_name} Is Displayed
	...  ELSE  Fail  ${IMG_name} Is Not Displayed
	
	CLICK RIGHT
	CLICK OK
	CLICK OK
