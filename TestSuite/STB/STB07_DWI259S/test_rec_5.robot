
test_rec_5
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image  ${port}  
	Run Keyword If  '${Result}' == 'True'  Log To Console  ${IMG_name} Is Displayed on screen
	...  ELSE  Fail  ${IMG_name} Is Not Displayed on screen
	
	CLICK OK
	CLICK HOME
