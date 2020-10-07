//%attributes = {}
var $test_o;$test2_o;$test3_o : cs:C1710.SimpleTest

$test_o:=cs:C1710.SimpleTest.new()

$test2_o:=cs:C1710.SimpleTest.new("something")

// set values
$test3_o:=cs:C1710.SimpleTest.new()

$test3_o.setValue("another thing")

$test3_o.textValue:="last thing"
$test3_o.setMonth:="October"

If (False:C215)
	// this does not work
	$test3_o:=cs:C1710.SimpleTest.new().setValue("something")
	
	$test3_o.setValue("another thing").setMonth("October")
	
	$test3_o:=cs:C1710.SimpleTest.new().setValue("something").setMonth("October")
	
	// code that makes it work
	If (False:C215)
		var $0 : cs:C1710.SimpleTest
		$0:=This:C1470
	End if 
	
End if 

If (False:C215)
	// getting a value does work
	$month_l:=cs:C1710.Date4D.new().getMonth()
End if 

