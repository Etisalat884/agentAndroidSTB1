
TC_505_VOD_FAST_FORWARD_RESUME
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK DOWN
	CLICK RIGHT
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image  ${port}  ${IMG_name}
	Run Keyword If  '${Result}' == 'True'  Log To Console  ${IMG_name} Is Displayed
	...  ELSE  Fail  ${IMG_name} Is Not Displayed
	
	CLICK OK
	CLICK RIGHT
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
	
	CLICK LEFT
	CLICK OK
