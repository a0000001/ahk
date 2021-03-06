; note to self: this must be in UTF-8 encoding.

; Emails.
:*:emaila::
	Send, % emailAddress
return
:*:gemaila::
	Send, % emailAddressGDB
return
:*:eemaila::
	Send, % epicEmailAddress
return

; Addresses
:*:waddr::
	Send, % madisonAddress
return
:*:fwaddr::
	Send, % madisonAddressFill
return
:*:eaddr::
	Send, % epicAddress
return
:*:feaddr::
	Send, % epicAddressFill
return
::ezip::
	Send, % epicAddressZip
return

; Usernames
:*:uname::
	Send, % userName
return
:*:.unixpass::
	Send, % epicDefaultUnixPass
return

; ::sig::
	; Send, %fullName%`n%wfuEmailAddress%`n%phoneNumberFormatted%`n
; return

:*:phoneno::
	Send, % phoneNumber
return
:*:fphoneno::
	Send, % phoneNumberFormatted
return

; ; WFU
; :*:wfusid::
; :*:wfuidn::
; :*:wsid::
; :*:studid::
	; Send, % wfuSID
; return
; :*:wuname::
	; Send, % wfuUserName
; return
; :*:wemaila::
	; Send, % wfuEmailAddress
; return
; :*:wiaddr::
	; Send, % wfuAddress
; return
; :*:wfiaddr::
	; Send, % wfuAddressFull
; return

; uSyd
; :*:suname::
	; Send, % sydneyUserName
; return
; :*:sydemaila::
	; Send, % sydneyEmailAddress
; return
; :*:sphone::
	; Send, % sydneyPhoneNumber
; return
; :*:sydid::
	; Send, % sydneySID
; return
; :*:lemaila::
	; Send, % langoorEmailAddress
; return

; ; Shodor
; :*:semaila::
	; Send, % shodorEmailAddress
; return

;Skype
:*:ssquirrel::(heidy)

;Portal
; #ifWinActive, ahk_class Valve001
; :*:pp::sv_portal_placement_never_fail{Space}
; :*:pc::sv_cheats{Space}
; :*:im::impulse 101
; :*:cube::ent_create_portal_weight_box
; #ifWinActive

; typos
::,3::<3
:*:<#::<3
:*:<43::<3
:*::0:::)
:*:;)_::;)
:*::)_:::)
:*::)(:::)
:*:O<o::O,o
:*:o<O::o,O
:*:O<O::O,O
:*R:^<^::^,^
:*R:6,6::^,^
:*R:6,^::^,^
:*R:^,6::^,^
:*:*shurgs*::*shrugs*
:*:mmgm::mmhm
:*:fwere::fewer
:*:aew::awe
:*:teh::the
:*:tteh::teh
:*:nayone::anyone
:*:idneed::indeed
:*:seriuosly::seriously
:*:.ocm::.com

; url extensions
; ; :*:treetab::about:treestyletab-group?
; :*:shome::
	; Send, % shodorHomeURL
; return
:*:lpv::chrome-extension://hdokiejnpimakedhajhdlcegeplioahd/homelocal2.html

; extensions
:*:btw::by the way
; :*:wful::Wake Forest University
:*:gov't::government
:*:eq'm::equilibrium
:*:f'n::function
:*:tech'l::technological
:*:eq'n::equation
:*:pop'n::population
:*:def'n::definition
:*:int'l::international
:*:ppt'::powerpoint
:*:conv'l::conventional
:*:Au'::Australia
:*:char'c::characteristic
:*:intro'd::introduced
:*:dev't::development
:*:civ'd::civilized
:*:ep'n::European
:*:uni'::university
:*:sol'n::solution
:*:sync'd::synchronized
:*:pos'n::position
:*:pos'd::positioned
:*:imp't::implement
:*:imp'n::implementation
:*:add'l::additional

; Healthcare-specific expansions.
:*:Med'c::Medicare
:*:Med'a::Medicaid
:*:Medi'c::Medicare
:*:Medi'a::Medicaid

; Billing-specific expansions.
:*:col'n::collection
:*:coll'n::collection
:*:pmt'::payment
:*:pospp'::POS Payment Posting

; date, time, both, and address
::idate::
	FormatTime, date, , M/d/yy
	Send %date%
	if(WinActive("ahk_class XLMAIN")) {
		Send, {Tab}
	}
return
:*:idashdate::
:*:dashidate::
	FormatTime, date, , M-d-yy
	Send, %date%
return
:*:itime::
	FormatTime, time, , h:mm tt
	Send %time%
return
:*:idatetime::
:*:itimedate::
	FormatTime, datetime, , h:mm M/d/yy
	Send %datetime%
return

:*:didate::
	FormatTime, date, , dddd`, M/d/yy
	Send %date%
return
:*:iddate::
	FormatTime, date, , M/d/yy`, dddd
	Send %date%
return

:*:dyidate::
	FormatTime, date, , dddd`, M/d/yy`, yyyy
	Send, %date%
return

:*:iaddr::
	Send, % homeAddress
return
:*:fiaddr::
	Send, % homeAddressFull
return

; KOCR extensions
; :*:ind's::indigenous
; :*:Ind's::Indigenous


; Folders

; Script related
:*:aef::A:\Experiments\
:*:asf::A:\Startup\
:*:acif::A:\Startup\CommonIncludes\
:*:apsf::A:\Startup\ProgramSpecific\
:*:asyf::A:\Startup\System\
:*:astf::A:\Startup\Standalone\

; Others
:*:dlf::
	Send, G:\Downloads\
return

:*:wallpaperf::
:*:backgroundf::
	Send, G:\Wallpapers\
return

; :*:exfolder::C:\Program Files\Executor\

:*:dsf::G:\Desktop\
:*:ddsf::G:\Desktop\Dev\

:*:pff::C:\Program Files\
:*:xpff::C:\Program Files (x86)\
:*:.x8:: (x86)

; Epic
:*:2esf::
:*:82esf::
:*:esf::
	Send, % epicSourceAppQA82
return
:*:1esf::
:*:81esf::
	Send, % epicSourceAppQA81
return
:*:9esf::
:*:79esf::
	Send, % epicSourceAppQA79
return
:*:8esf::
:*:78esf::
	Send, % epicSourceAppQA78
return

; Multiple Copays
:*:mcf::G:\Desktop\MultiplePreCopays\

:*:hesf::
	Send, % epicSourceAppQA82 epicHBFolder
return
:*:eesf::
	Send, % epicSourceAppQA82 epicEBFolder
return
:*:efsf::
	Send, % epicSourceAppQA82 epicFoundationProject
return

:*:.ecid::
	Send, % epicComputerName
return

; :*:tsf::
; :*:testf::
	; Send, G:\TestStuff
; return

:*:npsf::G:\Various Texts\notepadSessions
; :*:dnpsf::G:\Various Texts\notepadSessions\default.sess
; :*:cnpsf::G:\Various Texts\notepadSessions\Classes\
; :*:snpsf::G:\Various Texts\notepadSessions\Shodor\
; :*:funnyf::G:\Pictures\Funny

; Shodor
; :*:shodorfolder::G:\Programming\Shodor
; :*:ews::G:\workspace
; :*:igwt::G:\workspace\interactivateGWT
; :*:appc::apprentice

; ; Udacity
; :*:udacityf::G:\WFU Work\CSC 253 (Udacity)
; :*:udacityp::recmzfshjuhmmaaj

; Heart hotkey
; Pause::Send <3{Space}

:*:ex.::explorer.exe

:*:chf::
	Send, % cygwinHomePath
return

; ; URLs

; Epic
:O:gup::http://guru/Staff/EmployeeProfile.aspx?id=

; ; Wordpress programming
; :*:wppe::/wp-admin/post.php?action=edit&post=
; :*:wswppe::http://wakestudent.com/wp-admin/post.php?action=edit&post=

; Meta-AHK stuff.
:*:.ahkhead::
	SendRaw, %ahkHeaderCode%
return
:*:.ahkdefault::
	sendRawWithTabs(ahkDefaultHotkeys)
return
:*:.ahkm::
	SendRaw, MsgBox, `% ""
	Send, {Left}
return
:*:dbpop::
	SendRaw, DEBUG.popup(
	;)
return