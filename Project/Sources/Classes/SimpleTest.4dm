Class constructor
	var $1 : Text
	
	If (Count parameters:C259>0)
		This:C1470.textValue:=$1
	End if 
	
	
Function setValue
	var $1 : Text
	
	This:C1470.textValue:=$1
	
	var $0 : cs:C1710.SimpleTest
	$0:=This:C1470
	
Function setMonth
	var $1 : Text
	
	This:C1470.monthName:=$1
	
	var $0 : cs:C1710.SimpleTest
	$0:=This:C1470
	