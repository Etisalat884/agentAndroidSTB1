
test_rec_2
	CLICK Home
	CLICK Menu
	CLICK LEFT
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Down
	CLICK Ok
	${Result}  Verify Crop Image  ${port}  ${IMG_name}
	Run Keyword If  '${Result}' == 'True'  Log To Console  ${IMG_name} Is Displayed on screen
	...  ELSE  Fail  ${IMG_name} Is Not Displayed on screen
	
	CLICK Home
