
test_android_1
	CLICK HOME
	CLICK UP
	CLICK RIGHT
	CLICK RIGHT
	CLICK RIGHT
	CLICK OK
	${Result}  Verify Crop Image  ${port}  on_demand_android
	Run Keyword If  '${Result}' == 'True'  Log To Console  on_demand_android Is Displayed
	...  ELSE  Fail  on_demand_android Is Not Displayed
	
	CLICK OK
	CLICK HOME
	CLICK HOME
