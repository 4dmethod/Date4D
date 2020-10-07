//See Documentation for more info. 
//Created by: Tim Nevels, Innovative Solutions ©2020

Class constructor  // --------------------------------------------------------------------------------------------------------------------------
/* follow JavaScript parameter layout and accept 5 possible initialization methods with everything specified in local time:
	
1. no parameters(currentDateTime)
return current date and time
	
2. longint date and time components individually specified and everything is opt
year, month, day, hours, minutes, seconds milliseconds
(year)
(yearMonth)
(yearMonthDay)
(yearMonthDayHours)
(yearMonthDayHoursMinutes)
(yearMonthDayHoursMinutesSeconds)
(yearMonthDayHoursMinutesSecondsMillliseconds)
	
3. DTS string(DTS)
example:"1980-01-31T12:30:15.666"for local time or"1980-01-31T12:30:15.666Z for UTC time"
	
4. date string(dateString)%%%%%%not implemented yet%%%%%%%
example:"January 31 1980 12:30:15.666"
	
5. numeric timestamp value in milliseconds since January 1, 1970 00:00:00(numericTimestamp)
%%%%%%not implemented yet%%%%%%%
*/
	
	// parameter declaration - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	var $1 : Variant
	var $2 : Variant
	var $3 : Variant
	var $4 : Variant
	var $5 : Variant
	var $6 : Variant
	var $7 : Variant
	
	// declare local variables - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	var $initMethodType_t;$DTS_t : Text
	var $year_l;$month_l;$day_l;$hours_l;$minutes_l;$seconds_l;$milliseconds_l : Integer
	var $localDate_d : Date
	var $localTime_h : Time
	
	// determine what parameter method is being used - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	Case of 
		: (Count parameters:C259=0)  // doing the current date and time option
			$initMethodType_t:="currentDateTime"
			
		: (Count parameters:C259=1)  // check if numeric for timestamp value, or text 
			Case of 
				: ((Value type:C1509($1)=Is longint:K8:6) | (Value type:C1509($1)=Is real:K8:4) | (Value type:C1509($1)=Is integer:K8:5) | (Value type:C1509($1)=Is integer 64 bits:K8:25))
					If (($1>0) | ($1<=9999))  // assume this is year value
						$initMethodType_t:="year"
						$year_l:=$1
					Else   // assume it is a numeric time stamp %%%%%%%% not implemented
						$initMethodType_t:="numericTimestamp"
					End if 
					
				: ((Value type:C1509($1)=Is text:K8:3) | (Value type:C1509($1)=Is alpha field:K8:1))  // could be date string or DTS
					$initMethodType_t:="DTS"
					$DTS_t:=$1
					If ((Position:C15("-";$DTS_t)=5) & (Position:C15("-";$DTS_t;6)=8) & \
						(Position:C15("T";$DTS_t)=11) & (Position:C15(":";$DTS_t)=14) & (Position:C15(":";$DTS_t;15)=17))
						// assume a DTS, didn't feel like building a nasty Regex expression 🤓
						
						// get milliseconds, if provided
						If (Position:C15(".";$DTS_t)=20)
							$milliseconds_l:=Num:C11(Substring:C12($DTS_t;21;3))
							$DTS_t:=Substring:C12($DTS_t;1;19)
						End if 
						
					Else   // assume date string %%%%%%%% not implemented
						$initMethodType_t:="dateString"
					End if 
					
				Else   // unrecognized parameter usage
					TRACE:C157
			End case 
			
		Else   // 2 or more parameters, so assume they are all longint date and time components
			$year_l:=$1
			$month_l:=$2
			If (Count parameters:C259>=3)
				$day_l:=$3
			End if 
			If (Count parameters:C259>=4)
				$hours_l:=$4
			End if 
			If (Count parameters:C259>=5)
				$minutes_l:=$5
			End if 
			If (Count parameters:C259>=6)
				$seconds_l:=$6
			End if 
			If (Count parameters:C259>=7)
				$milliseconds_l:=$7
			End if 
	End case 
	
	// handle init method type
	Case of 
		: ($initMethodType_t="currentDateTime")  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
			// use 4D Timestamp to automatically include milliseconds
			$utcDTS_t:=Timestamp:C1445
			$localDate_d:=Date:C102($utcDTS_t)
			$localTime_h:=Time:C179($utcDTS_t)
			$milliseconds_l:=Num:C11(Substring:C12($utcDTS_t;21;3))
			
		: ($initMethodType_t="year")  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
			// use Jan 1 of year for date and 00:00:00 local time
			$localDate_d:=Add to date:C393($localDate_d;$year_l;1;1)
			
		: ($initMethodType_t="numericTimestamp")  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			TRACE:C157  // notimplemented %%%%%%%%%%%%%%%%%%%
			
		: ($initMethodType_t="dateString")  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			TRACE:C157  // notimplemented %%%%%%%%%%%%%%%%%%%
			
		: ($initMethodType_t="DTS")  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			// convert local DTS to local date and time
			$localDate_d:=Date:C102($DTS_t)  // 4D knows how to handle DTS with and without "Z"
			$localTime_h:=Time:C179($DTS_t)  // 4D knows how to handle DTS with and without "Z"
			
		: (Count parameters:C259=2)  // year and month provided - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			// use 1st day of month and year for date and 00:00:00 local time
			$localDate_d:=Add to date:C393($localDate_d;$year_l;$month_l;1)
			
		: (Count parameters:C259=3)  // year, month and day provided
			// use date provided and 00:00:00 local time
			$localDate_d:=Add to date:C393($localDate_d;$year_l;$month_l;$day_l)
			
		: (Count parameters:C259=4)  // year, month, day and hours provided
			// use date provided and hours with 00:00 local time
			$localDate_d:=Add to date:C393($localDate_d;$year_l;$month_l;$day_l)
			$localTime_h:=Time:C179(String:C10($hours_l;"#00")+":00:00")
			
		: (Count parameters:C259=5)  // year, month, day, hours minutes provided
			$localDate_d:=Add to date:C393($localDate_d;$year_l;$month_l;$day_l)
			$localTime_h:=Time:C179(String:C10($hours_l;"#00")+":"+String:C10($minutes_l;"00")+":00")
			
		: (Count parameters:C259>=6)  // year, month, day, hours minutes, seconds and maybe milliseconds provided
			$localDate_d:=Add to date:C393($localDate_d;$year_l;$month_l;$day_l)
			$localTime_h:=Time:C179(String:C10($hours_l;"#00")+":"+String:C10($minutes_l;"00")+":"+String:C10($seconds_l;"00"))
			
			// set milliseconds, if provided
			If (Count parameters:C259=7)
				$milliseconds_l:=$7
			End if 
	End case 
	
	// return new object
	This:C1470.setDate4D($localDate_d;$localTime_h;$milliseconds_l)
	
Function setJSCompatibility  // -------------------------------------------------------------------------------------------------------------
	// this is a utility method that can be called to set JavaScript compatibility. It turns on zero based value for methods
	// getMonth and getDay
	
	// parameter declaration
	var $1;$enableCompatibility_b : Boolean
	$enableCompatibility_b:=$1
	
	// check if static property has already been declared, if not define it
	If (OB Is defined:C1231(cs:C1710.Date4D;"compatibilitySettings"))  // it has been defined
		// set the value
		Use (cs:C1710.Date4D.compatibilitySettings)
			cs:C1710.Date4D.compatibilitySettings.JSCompatibility:=$enableCompatibility_b
		End use 
	Else   // define and set value
		Use (cs:C1710.Date4D)
			cs:C1710.Date4D.compatibilitySettings:=New shared object:C1526("JSCompatibility";$enableCompatibility_b)
		End use 
	End if 
	
Function getJSCompatibility  // -------------------------------------------------------------------------------------------------------------
	// this is a utility method to return the JavaScript compatibility setting. 
	
	// parameter declaration
	var $0 : Boolean
	
	// return result
	$0:=cs:C1710.Date4D.compatibilitySettings.JSCompatibility
	
Function getDate4D  // -----------------------------------------------------------------------------------------------------------------------
	// this is a utility method called by other class methods to return an object with properties of a Date4D class object
	
	// parameter declaration
	var $0 : cs:C1710.Date4D
	
	// declare local variables
	var $localTime_h;$utcTime_h : Time
	var $localTime_t;$utcTime_t : Text
	var $localDate_d;$utcDate_d : Date
	var $milliseconds_l : Integer
	
	// 4D does the conversion back to local time
	$localTime_h:=Time:C179(This:C1470.utcDTS)
	$localTime_t:=String:C10($localTime_h;HH MM SS:K7:1)
	$localDate_d:=Date:C102(This:C1470.utcDTS)
	
	// get UTC properties (force no conversion to local time)
	$utcTime_h:=Time:C179(Substring:C12(This:C1470.utcDTS;12;8))
	$utcTime_t:=String:C10($utcTime_h;HH MM SS:K7:1)
	$utcDate_d:=Date:C102(Substring:C12(This:C1470.utcDTS;1;10)+"T00:00:00")  // no "Z" at end, so no local time conversion is done
	
	$milliseconds_l:=Num:C11(Substring:C12(This:C1470.utcDTS;21;3))
	
	// return object
	$0:=New object:C1471(\
		"localDate";$localDate_d;\
		"localTimeSeconds";$localTime_h;\
		"localTimeString";$localTime_t;\
		"utcDate";$utcDate_d;\
		"utcTimeSeconds";$utcTime_h;\
		"utcTimeString";$utcTime_t;\
		"milliseconds";$milliseconds_l)
	
Function setDate4D  // -----------------------------------------------------------------------------------------------------------------------
	// utility method to convert a local date, time and milliseconds to UTC and set all the Date4D object properties
	// every calls method that makes changes to a Date4D object needs to call the method at the end
	
	// parameter declaration
	var $1;$localDate_d : Date
	var $2;$localTime_h : Time
	var $3;$milliseconds_l : Integer
	$localDate_d:=$1
	$localTime_h:=$2
	If (Count parameters:C259>=3)
		$milliseconds_l:=$3
	End if 
	
	// declare local variables
	var $utcDate_d : Date
	var $utcTime_h : Time
	var $utcTimeSeconds_l;$localTimeSeconds_l : Integer
	var $utcTimeString_t;$localTimeString_t;$localDTS_t : Text
	
	// let 4D do the conversion from local time to UTC
	$utcDTS_t:=String:C10($localDate_d;ISO date GMT:K1:10;$localTime_h)
	
	// add milliseconds to DTS, if necessary
	If ($milliseconds_l>0)
		$utcDTS_t:=Substring:C12($utcDTS_t;1;19)+"."+String:C10($milliseconds_l;"000")+"Z"
	End if 
	
	// generate UTC properties - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	// get date value
	$utcDate_d:=Date:C102(Substring:C12($utcDTS_t;1;10)+"T00:00:00")  // no "Z" at end, so no local time conversion is done
	
	// get time values
	$utcTime_h:=Time:C179(Substring:C12($utcDTS_t;12;8))
	$utcTimeSeconds_l:=$utcTime_h+0
	$utcTimeString_t:=String:C10($utcTime_h;HH MM SS:K7:1)
	
	// build UTC object
	$utc_o:=New object:C1471(\
		"DTS";$utcDTS_t;\
		"date";$utcDate_d;\
		"timeString";$utcTimeString_t;\
		"timeSeconds";$utcTimeSeconds_l;\
		"hours";Num:C11(Substring:C12($utcTimeString_t;1;2));\
		"minutes";Num:C11(Substring:C12($utcTimeString_t;4;2));\
		"seconds";Num:C11(Substring:C12($utcTimeString_t;7));\
		"milliseconds";$milliseconds_l)
	
	// generate local properties - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	// build local DTS
	$localDTS_t:=String:C10($localDate_d;ISO date:K1:8;$localTime_h)  // not conversion of time, just formatting
	
	// add milliseconds to DTS, if necessary
	If ($milliseconds_l>0)
		$localDTS_t:=$localDTS_t+"."+String:C10($milliseconds_l;"000")
	End if 
	
	// get time values
	$localTimeSeconds_l:=$localTime_h+0
	$localTimeString_t:=String:C10($localTime_h;HH MM SS:K7:1)
	
	// build local object
	$local_o:=New object:C1471(\
		"DTS";$localDTS_t;\
		"date";$localDate_d;\
		"timeString";$localTimeString_t;\
		"timeSeconds";$localTimeSeconds_l;\
		"hours";Num:C11(Substring:C12($localTimeString_t;1;2));\
		"minutes";Num:C11(Substring:C12($localTimeString_t;4;2));\
		"seconds";Num:C11(Substring:C12($localTimeString_t;7));\
		"milliseconds";$milliseconds_l)
	
	// return update object - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	This:C1470.utcDTS:=$utcDTS_t
	This:C1470.utc:=$utc_o
	This:C1470.local:=$local_o
	
Function setTimeComponents  // ----------------------------------------------------------------------------------------------------------
	// utility method to add time components to a date
	// handles overflow of any time component to update time and date correctly
	// every component is optional
	
	// parameter declaration
	var $1;$updateValues_o : Object
	$updateValues_o:=$1
	
	// declare local variables
	var $localDate_d : Date
	var $localTime_h : Time
	var $milliseconds_l;$pos;$currentHours_l;$currentMinutes_l;$currentSeconds_l;$totalSeconds_l : Integer
	var $secondsLeftOver_l;$numDays_l;$numSeconds_l : Integer
	var $localTime_t : Text
	
	var $date4D_o : cs:C1710.Date4D
	
	// get Date4D properties
	$date4D_o:=This:C1470.getDate4D()
	$localTime_h:=Time:C179($date4D_o.localTimeSeconds)
	$localTime_t:=$date4D_o.localTimeString
	$localDate_d:=$date4D_o.localDate
	
	// update hours (OK to go over 23 hours, 4D can handle it)
	If (OB Is defined:C1231($updateValues_o;"hours"))
		$hours_l:=$updateValues_o.hours
		// recalc time value
		$localTime_t:=String:C10($hours_l;"#00")+Substring:C12($localTime_t;3)
		$localTime_h:=Time:C179($localTime_t)
	End if 
	
	// update minutes
	If (OB Is defined:C1231($updateValues_o;"minutes"))
		$minutes_l:=$updateValues_o.minutes
		// get hours ending position (could be over 99 hours)
		$pos:=Position:C15(":";$localTime_t)
		If ($minutes_l<=59)  // just update minutes
			$localTime_t:=Substring:C12($localTime_t;1;$pos)+String:C10($minutes_l;"00")+Substring:C12($localTime_t;$pos+3)
		Else   // need to calc total time seconds
			$currentHours_l:=Num:C11(Substring:C12($localTime_t;1;$pos-1))
			$currentSeconds_l:=Num:C11(Substring:C12($localTime_t;$pos+4))
			$totalSeconds_l:=($currentHours_l*3600)+($minutes_l*60)+$currentSeconds_l
			$localTime_t:=Time string:C180($totalSeconds_l)
		End if 
		// recalc time value
		$localTime_h:=Time:C179($localTime_t)
	End if 
	
	// update seconds
	If (OB Is defined:C1231($updateValues_o;"seconds"))
		$seconds_l:=$updateValues_o.seconds
		// get hours ending position (could be over 99 hours)
		$pos:=Position:C15(":";$localTime_t)
		If ($seconds_l<=59)  // just update seconds
			$localTime_t:=Substring:C12($localTime_t;1;$pos+3)+String:C10($seconds_l;"00")
		Else   // need to calc total time seconds
			$currentHours_l:=Num:C11(Substring:C12($localTime_t;1;$pos-1))
			$currentMinutes_l:=Num:C11(Substring:C12($localTime_t;$pos+1;2))
			$totalSeconds_l:=($currentHours_l*3600)+($currentMinutes_l*60)+$seconds_l
			$localTime_t:=Time string:C180($totalSeconds_l)
		End if 
		// recalc time value
		$localTime_h:=Time:C179($localTime_t)
	End if 
	
	// update milliseconds
	If (OB Is defined:C1231($updateValues_o;"milliseconds"))
		$milliseconds_l:=$updateValues_o.milliseconds
		If ($milliseconds_l>999)  // need to update time value with overflow
			// get hours ending position (could be over 99 hours)
			$pos:=Position:C15(":";$localTime_t)
			
			// get time components
			$currentHours_l:=Num:C11(Substring:C12($localTime_t;1;$pos-1))
			$currentMinutes_l:=Num:C11(Substring:C12($localTime_t;$pos+1;2))
			$currentSeconds_l:=Num:C11(Substring:C12($localTime_t;$pos+4))
			
			// calc how many seconds of milliseconds and milliseconds left over
			$numSeconds_l:=Int:C8($milliseconds_l/1000)
			$milliseconds_l:=$milliseconds_l-($numSeconds_l*1000)
			
			// recalc time value
			$totalSeconds_l:=($currentHours_l*3600)+($currentMinutes_l*60)+($currentSeconds_l+$numSeconds_l)
			$localTime_h:=Time:C179($totalSeconds_l)
			$localTime_t:=Time string:C180($totalSeconds_l)
		End if 
	Else   // use existing milliseconds
		$milliseconds_l:=$date4D_o.milliseconds
	End if 
	
	// handle time of 24+ hours (add days to date)
	$totalSeconds_l:=$localTime_h+0
	If ($totalSeconds_l>=86400)  // 24:00:00 or more
		$numDays_l:=$totalSeconds_l\86400  // integer division
		$secondsLeftOver_l:=$totalSeconds_l-($numDays_l*86400)
		
		// update local date
		$localDate_d:=Add to date:C393($localDate_d;0;0;$numDays_l)
		
		// update local time from seconds left over
		$localTime_h:=Time:C179($secondsLeftOver_l)
		$localTime_t:=Time string:C180($secondsLeftOver_l)
	End if 
	
	// return update object
	This:C1470.setDate4D($localDate_d;$localTime_h;$milliseconds_l)
	
Function getDate  // -------------------------------------------------------------------------------------------------------------------------
	// get day number of the month
	
	// parameter declaration
	var $0 : Integer
	
	$0:=Day of:C23(This:C1470.local.date)
	
Function getDay  // -------------------------------------------------------------------------------------------------------------------------
	// get day number of the week (Sun = 1, Mon 2, etc. Sat = 7)
	// if JSCompatibility is on, return zero based result (Sun = 0, Mon 1, etc. Sat = 6)
	
	// parameter declaration
	var $0;$dayNumber_l : Integer
	
	// get value
	$dayNumber_l:=Day number:C114(This:C1470.local.date)
	
	// check compatibility setitng
	If (This:C1470.getJSCompatibility()=True:C214)
		$dayNumber_l:=$dayNumber_l-1
	End if 
	
	// return result
	$0:=$dayNumber_l
	
Function getFullYear  // --------------------------------------------------------------------------------------------------------------------
	// get year (4 digit for 4 digit years)
	
	// parameter declaration
	var $0 : Integer
	
	$0:=Year of:C25(This:C1470.local.date)
	
Function getHours  // -----------------------------------------------------------------------------------------------------------------------
	// get hours
	
	// parameter declaration
	var $0 : Integer
	
	$0:=Num:C11(Substring:C12(This:C1470.local.timeString;1;2))
	
Function getMilliseconds  // ---------------------------------------------------------------------------------------------------------------
	// get milliseconds
	
	// parameter declaration
	var $0 : Integer
	
	$0:=This:C1470.local.milliseconds
	
Function getMinutes  // --------------------------------------------------------------------------------------------------------------------
	// get minutes
	
	// parameter declaration
	var $0 : Integer
	
	$0:=Num:C11(Substring:C12(This:C1470.local.timeString;4;2))
	
Function getMonth  // ----------------------------------------------------------------------------------------------------------------------
	// get month number
	// if JSCompatibility is on, return zero based result (January = 0, February = 1, etc.)
	
	// parameter declaration
	var $0;$monthNumber_l : Integer
	
	// get value
	$monthNumber_l:=Month of:C24(This:C1470.local.date)
	
	// check compatibility setitng
	If (This:C1470.getJSCompatibility())
		$monthNumber_l:=$monthNumber_l-1
	End if 
	
	// return result
	$0:=$monthNumber_l
	
Function getSeconds  // -------------------------------------------------------------------------------------------------------------------
	// get seconds
	
	// parameter declaration
	var $0 : Integer
	
	$0:=Num:C11(Substring:C12(This:C1470.local.timeString;7;2))
	
Function getTime  // ------------------------------------------------------------------------------------------------------------------------
	// returns number of milliseconds since January 1, 1970 00:00:00 UTC for the date
	
	// parameter declaration
	var $0 : Real
	
	// declare local variables
	var $numDays_l : Integer
	var $numSeconds_r;$milliseconds_r : Real
	
	// calc milliseconds since UNIX epoch
	$numDays_l:=This:C1470.local.date-!1970-01-01!
	$numSeconds_r:=$numDays_l*86400
	$milliseconds_r:=($numSeconds_r+This:C1470.local.timeSeconds)*1000
	
	// return total milliseconds
	$0:=$milliseconds_r+This:C1470.utc.milliseconds
	
Function getTimezoneOffset  // ----------------------------------------------------------------------------------------------------------
	// get time zone difference in minutes from local time
	
	// parameter declaration
	var $0 : Integer
	
	// declare local variables
	var $localTimeSeconds_r;$utcTimeSeconds_r : Real
	var $numDays_l : Integer
	
	// calc seconds since UNIX epoch for local date and time
	$numDays_l:=This:C1470.local.date-!1970-01-01!
	$localTimeSeconds_r:=($numDays_l*86400)+This:C1470.local.timeSeconds
	
	// calc seconds since UNIX epoch for UTC date and time
	$numDays_l:=This:C1470.utc.date-!1970-01-01!
	$utcTimeSeconds_r:=($numDays_l*86400)+This:C1470.utc.timeSeconds
	
	// return difference in minutes between UTC time and local  time
	$0:=($utcTimeSeconds_r-$localTimeSeconds_r)/60
	
Function getUTCDate  // -------------------------------------------------------------------------------------------------------------------
	// get day number of the month at UTC
	
	// parameter declaration
	var $0 : Integer
	
	$0:=Num:C11(Substring:C12(This:C1470.utc.DTS;9;2))
	
Function getUTCFullYear  // ---------------------------------------------------------------------------------------------------------------
	// get year (4 digit for 4 digit years) at UTC
	
	// parameter declaration
	var $0 : Integer
	
	$0:=Num:C11(Substring:C12(This:C1470.utc.DTS;1;4))
	
Function getUTCHours  // ------------------------------------------------------------------------------------------------------------------
	// get hours at UTC
	
	// parameter declaration
	var $0 : Integer
	
	$0:=Num:C11(Substring:C12(This:C1470.utc.timeString;1;2))
	
Function getUTCMilliseconds  // ----------------------------------------------------------------------------------------------------------
	// get milliseconds at UTC
	
	// parameter declaration
	var $0 : Integer
	
	$0:=This:C1470.utc.milliseconds
	
Function getUTCMinutes  // ---------------------------------------------------------------------------------------------------------------
	// get minutes at UTC
	
	// parameter declaration
	C_LONGINT:C283($0)
	
	$0:=Num:C11(Substring:C12(This:C1470.utc.timeString;4;2))
	
Function getUTCMonth  // ------------------------------------------------------------------------------------------------------------------
	// get month number at UTC
	// if JSCompatibility is on, return zero based result (January = 0, February = 1, etc.)
	
	// parameter declaration
	var $0;$monthNumber_l : Integer
	
	// get value
	$monthNumber_l:=Month of:C24(This:C1470.utc.date)
	
	// check compatibility setitng
	If (This:C1470.getJSCompatibility())
		$monthNumber_l:=$monthNumber_l-1
	End if 
	
	// return result
	$0:=$monthNumber_l
	
Function getUTCSeconds  // ---------------------------------------------------------------------------------------------------------------
	// get seconds at UTC
	
	// parameter declaration
	var $0 : Integer
	
	$0:=Num:C11(Substring:C12(This:C1470.utc.timeString;7;2))
	
Function getYear  // -------------------------------------------------------------------------------------------------------------------------
	// get 2 digit year (deprecated but I support it for conveniece)
	// if JSCompatibility is on, return 2 digit year, else return 4 digit year by calling getFullYear method
	
	// parameter declaration
	var $0;$year_l : Integer
	
	// get value
	$year_l:=This:C1470.getFullYear()
	
	// check compatibility setitng
	If (This:C1470.getJSCompatibility())
		$year_l:=Num:C11(Substring:C12(String:C10($year_l;"0000");3))
	End if 
	
	// return result
	$0:=$year_l
	
Function now  // -----------------------------------------------------------------------------------------------------------------------------
	// returns number of milliseconds since January 1, 1970 00:00:00 UTC for the current date and time
	
	// parameter declaration
	var $0 : Real
	
	// return value
	$0:=cs:C1710.Date4D.new().getTime()
	
Function setDate  // -------------------------------------------------------------------------------------------------------------------------
	// set day of the month of the date
	
	// parameter declaration
	var $1;$day_l : Integer
	$day_l:=$1
	
	// declare local variables
	var $localDate_d;$monthStartDate_d;$monthEndDate_d : Date
	var $localTime_h : Time
	var $milliseconds_l;$currentDay_l;$dayChange_l;$numDays_l : Integer
	
	var $date4D_o : cs:C1710.Date4D
	
	// get Date4D properties
	$date4D_o:=This:C1470.getDate4D()
	$localTime_h:=Time:C179($date4D_o.localTimeSeconds)
	$localDate_d:=$date4D_o.localDate
	$milliseconds_l:=$date4D_o.milliseconds
	
	// get number of days in the month
	$monthStartDate_d:=Add to date:C393($localDate_d;0;0;-(Day of:C23($localDate_d)-1))
	$monthEndDate_d:=Add to date:C393($monthStartDate_d;0;1;-1)
	$numDays_l:=$monthEndDate_d-$monthStartDate_d+1
	
	// check if the day value is within the number of days in the month and set local date accordingly
	Case of 
		: ($day_l=0)  // set date to last day of previous month
			$localDate_d:=Add to date:C393($monthStartDate_d;0;0;-1)
			
		: ($day_l>$numDays_l)  // move into future months
			$localDate_d:=Add to date:C393($monthEndDate_d;0;0;($day_l-$numDays_l))
			
		: ($day_l<0)  // move backward starting in last day of previous month
			$localDate_d:=Add to date:C393($monthStartDate_d;0;0;($day_l-1))
			
		Else   // day in the same month
			// set new day
			$currentDay_l:=Day of:C23($localDate_d)
			$dayChange_l:=$day_l-$currentDay_l
			If ($dayChange_l#0)  // different day so change it
				$localDate_d:=Add to date:C393($localDate_d;0;0;$dayChange_l)
			End if 
	End case 
	
	// return update object
	This:C1470.setDate4D($localDate_d;$localTime_h;$milliseconds_l)
	
Function setFullYear  // ---------------------------------------------------------------------------------------------------------------------
	// set year of the date
	
	// parameter declaration
	var $1;$year_l : Integer
	var $2;$month_l : Integer
	var $3;$day_l : Integer
	$year_l:=$1
	If (Count parameters:C259>=2)
		$month_l:=$2
	End if 
	If (Count parameters:C259>=3)
		$day_l:=$3
	End if 
	
	// declare local variables
	var $localDate_d : Date
	var $localTime_h : Time
	var $milliseconds_l;$currentYear_l;$yearChange_l;$currentMonth_l;$monthChange_l;$currentDay_l;$dayChange_l : Integer
	var $utcDTS_t : Text
	
	var $date4D_o : cs:C1710.Date4D
	
	// get Date4D properties
	$date4D_o:=This:C1470.getDate4D()
	$localTime_h:=Time:C179($date4D_o.localTimeSeconds)
	$localDate_d:=$date4D_o.localDate
	$milliseconds_l:=$date4D_o.milliseconds
	
	// set new year
	$currentYear_l:=Year of:C25($localDate_d)
	$yearChange_l:=$year_l-$currentYear_l
	$localDate_d:=Add to date:C393($localDate_d;$yearChange_l;0;0)
	
	// check if changing the month
	If ($month_l>0)
		$currentMonth_l:=Month of:C24($localDate_d)
		$monthChange_l:=$month_l-$currentMonth_l
		If ($monthChange_l#0)  // different month so change it
			$localDate_d:=Add to date:C393($localDate_d;0;$monthChange_l;0)
		End if 
	End if 
	
	// check if changing the day of the month
	If ($day_l>0)
		$currentDay_l:=Day of:C23($localDate_d)
		$dayChange_l:=$day_l-$currentDay_l
		If ($dayChange_l#0)  // different day so change it
			$localDate_d:=Add to date:C393($localDate_d;0;0;$dayChange_l)
		End if 
	End if 
	
	// return update object
	This:C1470.setDate4D($localDate_d;$localTime_h;$milliseconds_l)
	
Function setHours  // ------------------------------------------------------------------------------------------------------------------------
	// set hours of the date
	
	// parameter declaration
	var $1;$hours_l : Integer
	var $2;$minutes_l : Integer
	var $3;$seconds_l : Integer
	var $4;$milliseconds_l : Integer
	
	// declare local variables
	var $updateValues_o : Object
	
	$updateValues_o:=New object:C1471
	
	If (Count parameters:C259>=1)
		$hours_l:=$1
		$updateValues_o.hours:=$hours_l
	End if 
	
	If (Count parameters:C259>=2)
		$minutes_l:=$2
		$updateValues_o.minutes:=$minutes_l
	End if 
	
	If (Count parameters:C259>=3)
		$seconds_l:=$3
		$updateValues_o.seconds:=$seconds_l
	End if 
	
	If (Count parameters:C259>=4)
		$milliseconds_l:=$4
		$updateValues_o.milliseconds:=$milliseconds_l
	End if 
	
	// do the work
	This:C1470.setTimeComponents($updateValues_o)
	
Function setMilliseconds  // ----------------------------------------------------------------------------------------------------------------
	// set milliseconds for the date
	
	// parameter declaration
	var $1;$milliseconds_l : Integer
	$milliseconds_l:=$1
	
	// do the work
	This:C1470.setTimeComponents(New object:C1471("milliseconds";$milliseconds_l))
	
Function setMinutes  // ----------------------------------------------------------------------------------------------------------------------
	// set minutes of the date
	
	// parameter declaration
	var $1;$minutes_l : Integer
	var $2;$seconds_l : Integer
	var $3;$milliseconds_l : Integer
	
	// declare local variables
	var $updateValues_o : Object
	
	$updateValues_o:=New object:C1471
	
	If (Count parameters:C259>=1)
		$minutes_l:=$1
		$updateValues_o.minutes:=$minutes_l
	End if 
	
	If (Count parameters:C259>=2)
		$seconds_l:=$2
		$updateValues_o.seconds:=$seconds_l
	End if 
	
	If (Count parameters:C259>=3)
		$milliseconds_l:=$3
		$updateValues_o.milliseconds:=$milliseconds_l
	End if 
	
	// do the work
	This:C1470.setTimeComponents($updateValues_o)
	
Function setMonth  // -------------------------------------------------------------------------------------------------------------------------
	// set month of the date
	// JavaScript has a very funky way of dealing with months
	// It was challenging to write this algorithm using the Add to date command 🤯
	
	// parameter declaration
	var $1;$month_l : Integer
	var $2;$day_l : Integer
	$month_l:=$1
	If (Count parameters:C259>=2)
		$day_l:=$2
	End if 
	
	// declare local variables
	var $localDate_d : Date
	var $localTime_h : Time
	var $milliseconds_l;$currentMonth_l;$monthChange_l : Integer
	var $date4D_o : cs:C1710.Date4D
	
	// get Date4D properties
	$date4D_o:=This:C1470.getDate4D()
	$localTime_h:=Time:C179($date4D_o.localTimeSeconds)
	$localDate_d:=$date4D_o.localDate
	$milliseconds_l:=$date4D_o.milliseconds
	
	// handle compatibility setting
	If (Not:C34(This:C1470.getJSCompatibility()))  // not JS compatible mode, so make it act that way because algorithm only works zero based
		// make it 0 based month
		If ($month_l>=0)
			$month_l:=$month_l-1
		Else   // negative value
			// no need to modify month
		End if 
	End if 
	
	// calc month change from current month
	$currentMonth_l:=Month of:C24($localDate_d)
	Case of 
		: ($month_l>11)  // month in future year
			$monthChange_l:=($month_l-11)+(12-$currentMonth_l)
			
		: ($month_l<0)  // negative value, so month in previous year(s)
			$monthChange_l:=($month_l-12)+(13-$currentMonth_l)
			
		Else   // January to December this year
			$monthChange_l:=$month_l-$currentMonth_l
	End case 
	
	// adjust local date
	$localDate_d:=Add to date:C393($localDate_d;0;$monthChange_l;0)
	
	// update object with new month value
	This:C1470.setDate4D($localDate_d;$localTime_h;$milliseconds_l)
	
	// update object with new day value if provided
	If ($day_l#0)
		This:C1470.setDate($day_l)
	End if 
	
Function setSeconds  // ----------------------------------------------------------------------------------------------------------------------
	// set seconds of the date
	
	// parameter declaration
	var $1;$seconds_l : Integer
	var $2;$milliseconds_l : Integer
	
	// declare local variables
	var $updateValues_o : Object
	
	$updateValues_o:=New object:C1471
	
	If (Count parameters:C259>=1)
		$seconds_l:=$1
		$updateValues_o.seconds:=$seconds_l
	End if 
	
	If (Count parameters:C259>=2)
		$milliseconds_l:=$2
		$updateValues_o.milliseconds:=$milliseconds_l
	End if 
	
	// do the work
	This:C1470.setTimeComponents($updateValues_o)
	
Function setUTCDate  // ---------------------------------------------------------------------------------------------------------------------
	// set day of the month of the date for a UTC date
	// works the same as setDate method so use that
	
	// parameter declaration
	var $1 : Integer
	
	This:C1470.setDate($1)
	
Function setUTCFullYear  // -----------------------------------------------------------------------------------------------------------------
	// set year of the date for a UTC date
	// works the same as setFullYear method so use that
	
	// parameter declaration
	var $1 : Integer
	var $2 : Integer
	var $3 : Integer
	
	Case of 
		: (Count parameters:C259=1)
			This:C1470.setFullYear($1)
			
		: (Count parameters:C259=2)
			This:C1470.setFullYear($1;$2)
			
		: (Count parameters:C259=3)
			This:C1470.setFullYear($1;$2;$3)
	End case 
	
Function setUTCHours  // -------------------------------------------------------------------------------------------------------------------
	// set hours of the date for a UTC date
	// works same as setHours so use that
	
	// parameter declaration
	var $1 : Integer
	var $2 : Integer
	var $3 : Integer
	var $4 : Integer
	
	Case of 
		: (Count parameters:C259=1)
			This:C1470.setHours($1)
			
		: (Count parameters:C259=2)
			This:C1470.setHours($1;$2)
			
		: (Count parameters:C259=3)
			This:C1470.setHours($1;$2;$3)
			
		: (Count parameters:C259=4)
			This:C1470.setHours($1;$2;$3;$4)
	End case 
	
Function setUTCMilliseconds  // -----------------------------------------------------------------------------------------------------------
	// set milliseconds for the date for a UTC date
	// works same as setMilliseconds so use that
	
	// parameter declaration
	var $1 : Integer
	
	// works the same as setMilliseconds, so use that
	This:C1470.setMilliseconds($1)
	
Function setUTCMinutes  // -----------------------------------------------------------------------------------------------------------------
	// set minutes of the date for a UTC date
	// works the same as setMinutes so use that
	
	// parameter declaration
	var $1 : Integer
	var $2 : Integer
	var $3 : Integer
	
	Case of 
		: (Count parameters:C259=1)
			This:C1470.setMinutes($1)
			
		: (Count parameters:C259=2)
			This:C1470.setMinutes($1;$2)
			
		: (Count parameters:C259=3)
			This:C1470.setMinutes($1;$2;$3)
	End case 
	
Function setUTCMonth  // -------------------------------------------------------------------------------------------------------------------
	// set month of the date on a UTC date
	// works the same as setMonth so use that
	
	// parameter declaration
	var $1 : Integer
	var $2 : Integer
	
	Case of 
		: (Count parameters:C259=1)
			This:C1470.setMonth($1)
			
		: (Count parameters:C259=2)
			This:C1470.setMonth($1;$2)
	End case 
	
Function setUTCSeconds  // ----------------------------------------------------------------------------------------------------------------
	// set seconds of the date on a UTC date
	// works the same as setSeconds so use that
	
	// parameter declaration
	var $1 : Integer
	var $2 : Integer
	
	Case of 
		: (Count parameters:C259=1)
			This:C1470.setSeconds($1)
			
		: (Count parameters:C259=2)
			This:C1470.setSeconds($1;$2)
	End case 
	
Function setYear  // --------------------------------------------------------------------------------------------------------------------------
	// set year of the date (old, deprecated method designed for 2 digit years)
	// use setFullYear after adjusting 2 digit year to 4 digit
	
	// parameter declaration
	var $1;$year_l : Integer
	$year_l:=$1
	
	// if year is 0 - 99 then use 1900 + year for the value
	If ($year_l>=0) & ($year_l<=99)
		$year_l:=1900+$year_l
	End if 
	
	This:C1470.setFullYear($year_l)
	
Function toDateString  // ---------------------------------------------------------------------------------------------------------------------
	// returns a string representing the date portion of the given Date object in human readable form in the current
	// operation system language. Example: Wed Jul 28 1993. Could be different in different countries or if user
	// changes the system settings of the machine.
	// Default is to use local date, but you can request the UTC date by passing "*" in $1
	
	// parameter declaration
	var $0 : Text
	var $1 : Text
	If (Count parameters:C259>=1)
		$useUTCdate_b:=True:C214
	End if 
	
	// declare local variables
	var $date_t : Text
	var $date_d : Date
	var $useUTCdate_b : Boolean
	
	// get date to use
	If ($useUTCdate_b)
		$date_d:=This:C1470.utc.date
	Else 
		$date_d:=This:C1470.local.date
	End if 
	// format text value
	$date_t:=String:C10($date_d;System date abbreviated:K1:2)
	$date_t:=Replace string:C233($date_t;",";"")  // remove the comma
	
	// return value
	$0:=$date_t
	
Function toISOString  // ---------------------------------------------------------------------------------------------------------------------
	// returns a string in simplified extended ISO format (ISO 8601) at UTC time and includes milliseconds, if any.
	// Just so happens that's exactly how a date is stored internally.
	
	// parameter declaration
	var $0 : Text
	
	$0:=This:C1470.utc.DTS
	
Function toJSON  // --------------------------------------------------------------------------------------------------------------------------
	// returns the same value as toISOString, so use that
	
	// parameter declaration
	var $0 : Text
	
	$0:=This:C1470.toISOString()
	
Function UTC  // --------------------------------------------------------------------------------------------------------------------------
	// works just like the "new" Date4D object constructor. Accepts the same parameters, so just call "new".
	// this is the JavaScript UTC version of the date constructor, but since we already are storing everything in UTC
	// format, it works the same way as "new"
	
	// parameter declaration
	var $0;$date4D_o : cs:C1710.Date4D
	var $1 : Variant
	var $2 : Variant
	var $3 : Variant
	var $4 : Variant
	var $5 : Variant
	var $6 : Variant
	var $7 : Variant
	
	// create a temp Date4D object to allow running constructor
	Case of 
		: (Count parameters:C259=0)
			$date4D_o:=cs:C1710.Date4D.new()
			
		: (Count parameters:C259=1)
			$date4D_o:=cs:C1710.Date4D.new($1)
			
		: (Count parameters:C259=2)
			$date4D_o:=cs:C1710.Date4D.new($1;$2)
			
		: (Count parameters:C259=3)
			$date4D_o:=cs:C1710.Date4D.new($1;$2;$3)
			
		: (Count parameters:C259=4)
			$date4D_o:=cs:C1710.Date4D.new($1;$2;$3;$4)
			
		: (Count parameters:C259=5)
			$date4D_o:=cs:C1710.Date4D.new($1;$2;$3;$4;$5)
			
		: (Count parameters:C259=6)
			$date4D_o:=cs:C1710.Date4D.new($1;$2;$3;$4;$5;$6)
			
		: (Count parameters:C259=7)
			$date4D_o:=cs:C1710.Date4D.new($1;$2;$3;$4;$5;$6;$7)
	End case 
	
	// set object value
	$0:=$date4D_o
	
	
	