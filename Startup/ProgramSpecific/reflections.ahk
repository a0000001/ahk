#ifWinActive, ahk_class r2Window

^i::
	; Block and buffer input until {ENTER} is pressed.
	Input, textIn, , {Enter}
	
	; Get the length of the string we're going to add.
	inputLength := StrLen(textIn)
	
	; Insert that many spaces.
	Send, {Insert %inputLength%}
	
	; Actually send our input text.
	SendRaw, % textIn
return

^v::
	; Get the length of the string we're going to add.
	inputLength := StrLen(clipboard)
	
	; Insert that many spaces.
	Send, {Insert %inputLength%}
	
	; Actually send our input text.
	SendRaw, % clipboard
return

; TLG Hotkey.
^t::Send, 14457

^l::
^+l::
	Send, !el{Enter}
return

#ifWinActive






; Quick TLG Reference Popup.
^#!t::
	tlgQuickRefText = 
(
==================================================================================================================================================================================================================================
Log Time to Epic (Customer #0)				|
==================================================================================================================================================================================================================================
TLP	Name						|	When do I use it?
--------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
11265	New Employee Orientation			|	Can be used for all time during your first month at Epic.
							|
1	Vacation					|	Log 8 hours for full-day && 4 hours for half-day vacation days.  Please do this in advance of taking time off.
2	Holiday						|	Log 8 hours for full-day && 4 hours for half-day paid holidays.
3	Sick						|	Log 8 hours for full-day && 4 hours for half-day paid sick days.
8940	Recovery Time	 				|	Use for time off earned by working 2 full weekend days supporting a go-live. Subject to Team Lead approval.
10921	Unpaid Leave					|	Log 8 hours for full-day && 4 hours for half-day unpaid leave.  Please do this in advance of taking time off.
							|
4	General && Administrative			|	Use for miscellaneous administrative tasks such as reading email, organizing office, completing paperwork, updating monthly calendar, etc.
119	Work Plans - Create/Logging Time 		|	Use for logging your time in TLG && creating weekly work plans.
154	Education (Internal) 				|	Use for general education (seminars, training classes, reading, etc.).  DO NOT use TLP 154 for customer edu.
7091	Meetings - General (Internal) 			|	Use for general Epic meetings (monthly staff meeting, team meetings, etc.).  DO NOT use for customer mtgs.
10	Internal Support 				|	Use for general support of other Epic employees. Can be logged to customer if you aren’t on customer team.
12	Design Specifications - General			|	Use for general design time. Can be used for customers on maintenance if for approved NB work.
13	Development - General				|	Use for general development. Can be used for customers on maintenance if for approved NB work.
14	Programmer QA - General				|	Use for general Programmer QA. Can be used for customers on maintenance if for approved NB work.
15	QA - General					|	Use for general QA. Can be used for customers on maintenance if for approved NB work.
733	Celebration					|	Use for time spent celebrating with your team.  DO NOT use TLP 733 for customer related social time.
3048	Travel Time					|	Use to log time spent traveling between Epic sites. Use “Epic” in the customer field.
11625	Training - Customer Test Administration, 	|	Use for test administration such as compiling tests, working with proctors, grading tests, etc.
			NVT worksheets, Grade/Review	|		If you are proctoring a test && completing other tasks while proctoring, use the appropriate task TLP. 
							|	Use for time spent grading && administering New Version Training worksheets.
20239	Immersion Trips (On-site)			|	Use for logging on-site time for immersion trips.
							|
==================================================================================================================================================================================================================================
Log Time to Customer (use appropriate Customer #)	|
==================================================================================================================================================================================================================================
TLP		Name					|	When do I use it?
--------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2191	Review Accounting Reports			|	Use for time spent reviewing the monthly customer hours reports emailed by Accounting during the 1st week of the month. 
6	Customer General Support			|	For customers who are on Maintenance.  For general support of "live" applications at "live" customer sites.
							|		DO NOT use for installing customers or rollout related support.  
8	On Site Customer Support Covered by Maintenance	|	This is the "on-site" version of TLP 6.  A nonbillable travel request must be approved prior to each trip.
9	Customer Release Support			|	For time preparing to upgrade to a new version (checksums, etc.) && questions related to new functionality in upcoming releases.  
							|		Only use for customers who are on our Maintenance Program.  DO NOT use for installing customers or rollout related support.  
7	Customer Bug Support				|	For support && research related to a bug in our software.  Use for all customers (installing && on Maintenance).
							|		DO NOT use this TLP for a bug found during the development process (before the code is released).
							|		That time is logged in the same way as the development time.
11	Non-Working Customer Related Social Time	|	Use for meals && other social time spent with customers.
3048	Travel Time					|	Time spent in planes, trains && automobiles. If completing other tasks while in transit, use the TLP for the task && reduce travel time accordingly.
13489	QA - New Employees				|	Use to log customer QA time that should be non-billable while completing the 100 QA hours requirement.
							|		Change the code to EDU or BUG. Detailed instructions are available from the IS team web-site.
384	Sales - General					|	Use for Sales Support.  Log your time against the Appropriate customer or sales project.
*	Training - Reviewing Exams With Customer	|	Use for any one-on-one exam or project review time with a customer.  *Use current  phase Install TLP && if on maintenance, use TLP 30653.
24	After Hours Non-Billable Maintenance		|	Use for any after-hours non-billable customer calls related to maintenance.
6912	Unplanned After Hours Support - To Be Resolved	|	Use for After Hours support calls. This is a "holding" TLP until Accounting determines whether the call is billable or not.
							|		Email "Accounting-Billing" to alert Accounting of the call.
==================================================================================================================================================================================================================================
)

	; Gui, +Left
	Gui, Font,, Courier New
	Gui, Add, Text,, %tlgQuickRefText%
	Gui, Add, Button, Default, OK
	Gui, Show,, TLG Codes	
return

ButtonOK:
	Gui, Hide
return