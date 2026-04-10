
test_android_2
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image  ${port}  Admin_test
	Run Keyword If  '${Result}' == 'True'  Log To Console  Admin_test Is Displayed
	...  ELSE  Fail  Admin_test Is Not Displayed
	
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image  ${port}  test_new_profile_pin
	Run Keyword If  '${Result}' == 'True'  Log To Console  test_new_profile_pin Is Displayed
	...  ELSE  Fail  test_new_profile_pin Is Not Displayed
	
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	CLICK OK
	${Result}  Verify Crop Image  ${port}  Profile_type_test
	Run Keyword If  '${Result}' == 'True'  Log To Console  Profile_type_test Is Displayed
	...  ELSE  Fail  Profile_type_test Is Not Displayed
	
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK UP
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK LEFT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK RIGHT
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK DOWN
	CLICK OK
	CLICK DOWN
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image  ${port}  test_new_proifle
	Run Keyword If  '${Result}' == 'True'  Log To Console  test_new_proifle Is Displayed
	...  ELSE  Fail  test_new_proifle Is Not Displayed
	
	CLICK RIGHT
	CLICK DOWN
	CLICK DOWN
	CLICK OK
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK TWO
	CLICK OK
	${Result}  Verify Crop Image  ${port}  profile_deleted_test
	Run Keyword If  '${Result}' == 'True'  Log To Console  profile_deleted_test Is Displayed
	...  ELSE  Fail  profile_deleted_test Is Not Displayed
	
	CLICK HOME
