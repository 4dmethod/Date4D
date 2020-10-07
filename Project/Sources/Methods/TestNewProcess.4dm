//%attributes = {}
// test if Date4D Class storage works in all processes

// declare local variables
var $theDate_o : cs:C1710.Date4D
var $processID_l : Integer

cs:C1710.Date4D.new().setJSCompatibility(True:C214)

$processID_l:=New process:C317("TestNewProcess2";0)
