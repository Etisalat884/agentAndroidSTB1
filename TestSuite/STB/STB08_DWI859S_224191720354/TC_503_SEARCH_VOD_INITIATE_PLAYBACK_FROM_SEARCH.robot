
TC_503_SEARCH_VOD_INITIATE_PLAYBACK_FROM_SEARCH
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	CLICK OK
	CLICK OK
	CLICK UP
	CLICK OK
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
	${Result}  Verify Crop Image  ${port}  ${IMG_name}
	Run Keyword If  '${Result}' == 'True'  Log To Console  ${IMG_name} Is Displayed
	...  ELSE  Fail  ${IMG_name} Is Not Displayed
	
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image  ${port}  ${IMG_name}
	Run Keyword If  '${Result}' == 'True'  Log To Console  ${IMG_name} Is Displayed
	...  ELSE  Fail  ${IMG_name} Is Not Displayed
	
