
test_rec_6
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image  ${port}  library_test_1
	Run Keyword If  '${Result}' == 'True'  Log To Console  library_test_1 Is Displayed on screen
	...  ELSE  Fail  library_test_1 Is Not Displayed on screen
	
	CLICK OK
	CLICK HOME
