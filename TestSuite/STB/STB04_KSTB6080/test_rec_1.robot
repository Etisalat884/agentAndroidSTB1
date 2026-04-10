
test_rec_1
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
	${Result}  Verify Crop Image  ${port}  test_search
	Run Keyword If  '${Result}' == 'True'  Log To Console  test_search Is Displayed on screen
	...  ELSE  Fail  test_search Is Not Displayed on screen
	
	CLICK Home
