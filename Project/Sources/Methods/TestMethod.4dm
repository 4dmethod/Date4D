//%attributes = {}
// Test Constructor parameter formats

// declare local variables
var $theDate_o;$theDate2_o : cs:C1710.Date4D

var $folder2_o : 4D:C1709.Folder

// currentDateTime
$theDate_o:=cs:C1710.Date4D.new()

// date components
$theDate_o:=cs:C1710.Date4D.new(2020;7;12;8;42;38;666)
ASSERT:C1129($theDate_o.utcDTS="2020-07-12T13:42:38.666Z")

// localDTS (moon landing)
$theDate_o:=cs:C1710.Date4D.new("1969-07-20T20:17:00Z")
ASSERT:C1129($theDate_o.utcDTS="1969-07-20T20:17:00Z")

$isEnabled_b:=cs:C1710.Date4D.compatibilitySettings.JSCompatibility

// test setMonth zero based
If (True:C214)
	cs:C1710.Date4D.new().setJSCompatibility(True:C214)
	
	$theDate_o:=cs:C1710.Date4D.new(2020;1;1)
	$theDate_o.setMonth(12)
	ASSERT:C1129($theDate_o.utcDTS="2021-01-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;2;1)
	$theDate_o.setMonth(12)
	ASSERT:C1129($theDate_o.utcDTS="2021-01-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;1;1)
	$theDate_o.setMonth(12)
	ASSERT:C1129($theDate_o.utcDTS="2021-01-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;11;1)
	$theDate_o.setMonth(12)
	ASSERT:C1129($theDate_o.utcDTS="2021-01-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;12;1)
	$theDate_o.setMonth(12)
	ASSERT:C1129($theDate_o.utcDTS="2021-01-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;1;1)
	$theDate_o.setMonth(13)
	ASSERT:C1129($theDate_o.utcDTS="2021-02-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;2;1)
	$theDate_o.setMonth(13)
	ASSERT:C1129($theDate_o.utcDTS="2021-02-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;4;1)
	$theDate_o.setMonth(14)
	ASSERT:C1129($theDate_o.utcDTS="2021-03-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;12;1)
	$theDate_o.setMonth(14)
	ASSERT:C1129($theDate_o.utcDTS="2021-03-01@")
	
	// this does not work (unless you assign $0 in setMonth class function)
	$theDate_o:=cs:C1710.Date4D.new().setMonth(14)
End if 


// test setMonth 1 based
If (True:C214)
	cs:C1710.Date4D.new().setJSCompatibility(False:C215)
	
	$theDate_o:=cs:C1710.Date4D.new(2020;1;1)
	$theDate_o.setMonth(13)
	ASSERT:C1129($theDate_o.utcDTS="2021-01-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;2;1)
	$theDate_o.setMonth(13)
	ASSERT:C1129($theDate_o.utcDTS="2021-01-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;1;1)
	$theDate_o.setMonth(13)
	ASSERT:C1129($theDate_o.utcDTS="2021-01-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;11;1)
	$theDate_o.setMonth(13)
	ASSERT:C1129($theDate_o.utcDTS="2021-01-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;12;1)
	$theDate_o.setMonth(13)
	ASSERT:C1129($theDate_o.utcDTS="2021-01-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;1;1)
	$theDate_o.setMonth(14)
	ASSERT:C1129($theDate_o.utcDTS="2021-02-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;2;1)
	$theDate_o.setMonth(14)
	ASSERT:C1129($theDate_o.utcDTS="2021-02-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;4;1)
	$theDate_o.setMonth(15)
	ASSERT:C1129($theDate_o.utcDTS="2021-03-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;12;1)
	$theDate_o.setMonth(15)
	ASSERT:C1129($theDate_o.utcDTS="2021-03-01@")
End if 


// test setMonth zero based negative values
If (True:C214)
	cs:C1710.Date4D.new().setJSCompatibility(True:C214)
	
	$theDate_o:=cs:C1710.Date4D.new(2020;1;1)
	$theDate_o.setMonth(-1)
	ASSERT:C1129($theDate_o.utcDTS="2019-12-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;2;1)
	$theDate_o.setMonth(-2)
	ASSERT:C1129($theDate_o.utcDTS="2019-11-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;4;1)
	$theDate_o.setMonth(-3)
	ASSERT:C1129($theDate_o.utcDTS="2019-10-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;10;1)
	$theDate_o.setMonth(-1)
	ASSERT:C1129($theDate_o.utcDTS="2019-12-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;12;1)
	$theDate_o.setMonth(-2)
	ASSERT:C1129($theDate_o.utcDTS="2019-11-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;11;1)
	$theDate_o.setMonth(-3)
	ASSERT:C1129($theDate_o.utcDTS="2019-10-01@")
End if 


// test setMonth 1 based negative values
If (True:C214)
	cs:C1710.Date4D.new().setJSCompatibility(False:C215)
	
	$theDate_o:=cs:C1710.Date4D.new(2020;1;1)
	$theDate_o.setMonth(-1)
	ASSERT:C1129($theDate_o.utcDTS="2019-12-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;2;1)
	$theDate_o.setMonth(-2)
	ASSERT:C1129($theDate_o.utcDTS="2019-11-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;4;1)
	$theDate_o.setMonth(-3)
	ASSERT:C1129($theDate_o.utcDTS="2019-10-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;10;1)
	$theDate_o.setMonth(-1)
	ASSERT:C1129($theDate_o.utcDTS="2019-12-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;12;1)
	$theDate_o.setMonth(-2)
	ASSERT:C1129($theDate_o.utcDTS="2019-11-01@")
	
	$theDate_o:=cs:C1710.Date4D.new(2020;11;1)
	$theDate_o.setMonth(-3)
	ASSERT:C1129($theDate_o.utcDTS="2019-10-01@")
End if 


// test setDate
If (True:C214)
	// set day in this month
	$theDate_o:=cs:C1710.Date4D.new()
	$theDate_o.setDate(3)
	ASSERT:C1129(Day of:C23($theDate_o.local.date)=3)
	
	// last day of previous month
	$theDate_o:=cs:C1710.Date4D.new()
	$lastDayPreviousMonth_d:=Add to date:C393($theDate_o.local.date;0;0;-Day of:C23($theDate_o.local.date))
	$theDate_o.setDate(0)
	ASSERT:C1129($theDate_o.local.date=$lastDayPreviousMonth_d)
	
	// first day of next month
	$theDate_o:=cs:C1710.Date4D.new()
	$lastDateThisMonth_d:=Add to date:C393(!00-00-00!;Year of:C25($theDate_o.local.date);Month of:C24($theDate_o.local.date)+1;1)-1
	$lastDayThisMonth_l:=Day of:C23($lastDateThisMonth_d)
	$theDate_o.setDate($lastDayThisMonth_l+1)
	ASSERT:C1129($theDate_o.local.date=Add to date:C393($lastDateThisMonth_d;0;0;1))
	
	// 2 days before end of previous month (6/28/20)
	$theDate_o:=cs:C1710.Date4D.new()
	$lastDayPreviousMonth_d:=Add to date:C393($theDate_o.local.date;0;0;-Day of:C23($theDate_o.local.date))
	$theDate_o.setDate(-2)
	ASSERT:C1129($theDate_o.local.date=Add to date:C393($lastDayPreviousMonth_d;0;0;-2))
End if 


// test setFullYear
If (True:C214)
	$theDate_o:=cs:C1710.Date4D.new()
	$theDate_o.setFullYear(1970)
	ASSERT:C1129(Year of:C25($theDate_o.local.date)=1970)
	
	$theDate_o:=cs:C1710.Date4D.new()
	$theDate_o.setFullYear(1970;5)
	ASSERT:C1129((Year of:C25($theDate_o.local.date)=1970) & (Month of:C24($theDate_o.local.date)=5))
	
	$theDate_o:=cs:C1710.Date4D.new()
	$theDate_o.setFullYear(1970;6;22)
	ASSERT:C1129((Year of:C25($theDate_o.local.date)=1970) & (Month of:C24($theDate_o.local.date)=6) & (Day of:C23($theDate_o.local.date)=22))
	
	$theDate_o:=cs:C1710.Date4D.new()
	$theDate_o.setFullYear(1970;15;38)
	
	$theDate_o:=cs:C1710.Date4D.new("1980-01-31T12:30:15.666Z")
	$theDate_o.setHours(140;100;80;3333)
	
	$theDate_o:=cs:C1710.Date4D.new("1980-01-31T12:30:15.666Z")
	$theDate_o.setMilliseconds(3333)
	
	$theDate_o:=cs:C1710.Date4D.new("1980-01-31T12:30:15.666Z")
	$theDate_o.setMinutes(25)
	
	$theDate_o:=cs:C1710.Date4D.new("1980-01-31T12:30:15.666Z")
	$theDate_o.setMonth(8;40)
End if 


// more tests
If (True:C214)
	$theDate_o:=cs:C1710.Date4D.new()
	$theDate2_o:=$theDate_o.UTC()
	
	cs:C1710.Date4D.new().setJSCompatibility(True:C214)
	
	$value_b:=cs:C1710.Date4D.new().getJSCompatibility()
	$value_b:=JScompatibilityIsEnabled
	
	cs:C1710.Date4D.new().setJSCompatibility(False:C215)  // turn it off
	
	$dayNumber_l:=$theDate_o.getDay()
	
	$millseconds_r:=cs:C1710.Date4D.new().now()
	
	// dateString
	// %%%%%% not implemented %%%%%%%
	//$theDate_o:=cs.Date4D.new("January 31 1980 12:30:15.666")
	
	// numericTimestamp
	// %%%%%% not implemented %%%%%%%
	//$theDate_o:=cs.Date4D.new(12345678987)
	
	// get day number of the month
	$day_l:=$theDate_o.getDate()
	
	// get day number of the week (Sun = 1, Mon 2, etc. Sat = 7)
	$dayOfWeek_l:=$theDate_o.getDay()
	
	// get year (4 digit for 4 digit years)
	$year_l:=$theDate_o.getFullYear()
	
	// get hours
	$hours_l:=$theDate_o.getHours()
	
	// get milliseconds
	$milliseconds_l:=$theDate_o.getMilliseconds()
	
	// get minutes
	$minutes_l:=$theDate_o.getMinutes()
	
	// get month number
	$month_l:=$theDate_o.getMonth()
	
	// get seconds
	$seconds_l:=$theDate_o.getSeconds()
	
	// get time (in milliseconds since 1/1/1970
	$millisecondsSinceEpoch_r:=$theDate_o.getTime()
	
	// get time zone difference in minutes from local time
	$minutes_l:=cs:C1710.Date4D.new().getTimezoneOffset()
	
	// get day number of the month at UTC
	$day_l:=$theDate_o.getUTCDate()
	
	// get year (4 digit for 4 digit years) at UTC
	$year_l:=$theDate_o.getUTCFullYear()
	
	// get hours at UTC
	$hours_l:=$theDate_o.getUTCHours()
	
	// get milliseconds at UTC
	$milliseconds_l:=$theDate_o.getUTCMilliseconds()
	
	// get minutes at UTC
	$minutes_l:=$theDate_o.getUTCMinutes()
	
	// get month number at UTC
	$month_l:=$theDate_o.getUTCMonth()
	
	// get seconds at UTC
	$seconds_l:=$theDate_o.getUTCSeconds()
	
	// get 2 digit year 
	$year_l:=$theDate_o.getYear()
End if 

