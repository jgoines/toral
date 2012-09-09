#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\..\icons\swtor.ico
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; TORAL (The Old Republic Automatic Login)
; Version: 3.2
; Author: jgoines, http://www.elitepvpers.com (PMs checked often)
;
;#AutoIt3Wrapper_run_obfuscator=y
;#Obfuscator_parameters=/striponly


$settingusername = ""
$settingpassword = ""
$settingteacher = ""
$settingfriend = ""
$settingrestaurant = ""
$settingpet = ""
$settingschool=""
$settingwait=300
$settinguntzon=""
$settinguntzpass=""
$settingrows=""
$settingsktoggle=""
$settingseckey=""
$imgStart="images\welcome.bmp"
$imgEnv="images\enviroment.bmp"
$imgNext="images\next.bmp"
$imgPlay="images\play.bmp"
$imgTeacher="images\teacher.bmp"
$imgFriend="images\friend.bmp"
$imgRestaurant="images\restaurant.bmp"
$imgPet="images\pet.bmp"
$imgSchool="images\school.bmp"
$imgPlay2="images\play2.bmp"
$imgLightsaber="images\lightsaber.bmp"
$imgUntzLogin="images\untzlogin.bmp"
$imgUntzLoad="images\untzload.bmp"
$imgUntzDefault="images\untzdefault.bmp"
$ProcName="UntzBot"
$launcher=0
$searchPass=0
$x1=0
$y1=0

$settingstxt="settings.txt"
$seckeytxt="seckey.txt"


Func _ImageSearch($findImage,$resultPosition,ByRef $x, ByRef $y,$tolerance)
   return _ImageSearchArea($findImage,$resultPosition,0,0,@DesktopWidth,@DesktopHeight,$x,$y,$tolerance)
EndFunc

Func _ImageSearchArea($findImage,$resultPosition,$x1,$y1,$right,$bottom,ByRef $x, ByRef $y, $tolerance)
	;MsgBox(0,"asd","" & $x1 & " " & $y1 & " " & $right & " " & $bottom)
	if $tolerance>0 then $findImage = "*" & $tolerance & " " & $findImage
	$result = DllCall("ImageSearchDLL.dll","str","ImageSearch","int",$x1,"int",$y1,"int",$right,"int",$bottom,"str",$findImage)

	; If error exit
    if $result[0]="0" then return 0

	; Otherwise get the x,y location of the match and the size of the image to
	; compute the centre of search
	$array = StringSplit($result[0],"|")

   $x=Int(Number($array[2]))
   $y=Int(Number($array[3]))
   if $resultPosition=1 then
      $x=$x + Int(Number($array[4])/2)
      $y=$y + Int(Number($array[5])/2)
   endif
   return 1
EndFunc

Func _WaitForImageSearch($findImage,$waitSecs,$resultPosition,ByRef $x, ByRef $y,$tolerance)
	$waitSecs = $waitSecs * 1000
	$startTime=TimerInit()
	While TimerDiff($startTime) < $waitSecs
		sleep(100)
		$result=_ImageSearch($findImage,$resultPosition,$x, $y,$tolerance)
		if $result > 0 Then
			return 1
		EndIf
	WEnd
	return 0
EndFunc

Func _WaitForImagesSearch($findImage,$waitSecs,$resultPosition,ByRef $x, ByRef $y,$tolerance)
	$waitSecs = $waitSecs * 1000
	$startTime=TimerInit()
	While TimerDiff($startTime) < $waitSecs
		for $i = 1 to $findImage[0]
		    sleep(100)
		    $result=_ImageSearch($findImage[$i],$resultPosition,$x, $y,$tolerance)
		    if $result > 0 Then
			    return $i
		    EndIf
		Next
	WEnd
	return 0
EndFunc

Func _stringexplode($sstring, $sdelimiter, $ilimit = 0)
	If $ilimit > 0 Then
		$sstring = StringReplace($sstring, $sdelimiter, Chr(0), $ilimit)
		$sdelimiter = Chr(0)
	ElseIf $ilimit < 0 Then
		Local $iindex = StringInStr($sstring, $sdelimiter, 0, $ilimit)
		If $iindex Then
			$sstring = StringLeft($sstring, $iindex - 1)
		EndIf
	EndIf
	Return StringSplit($sstring, $sdelimiter, 3)
EndFunc

Func _arraypop(ByRef $avarray)
	If (NOT IsArray($avarray)) Then Return SetError(1, 0, "")
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, "")
	Local $iubound = UBound($avarray) - 1, $slastval = $avarray[$iubound]
	If NOT $iubound Then
		$avarray = ""
	Else
		ReDim $avarray[$iubound]
	EndIf
	Return $slastval
EndFunc

Func asize($aarray)
	SetError(0)
	$index = 0
	Do
		$pop = _arraypop($aarray)
		$index = $index + 1
	Until @error = 1
	Return $index - 1
EndFunc

Func _LoadSettings()
	$filesetting = FileOpen($settingstxt, 0)
	If ($filesetting == -1) Then
	Else
		While 1
			$curline = FileReadLine($filesetting)
			If @error = -1 Then ExitLoop
			$stringarray = _stringexplode($curline, ",")
			If ($stringarray[0] = "username") Then
				If (asize($stringarray) > 1) Then $settingusername = $stringarray[1]
			EndIf
			If ($stringarray[0] = "password") Then
				If (asize($stringarray) > 1) Then $settingpassword = $stringarray[1]
			EndIf
			If ($stringarray[0] = "teacher") Then
				If (asize($stringarray) > 1) Then $settingteacher = $stringarray[1]
			EndIf
			If ($stringarray[0] = "friend") Then
				If (asize($stringarray) > 1) Then $settingfriend = $stringarray[1]
			EndIf
			If ($stringarray[0] = "restaurant") Then
				If (asize($stringarray) > 1) Then $settingrestaurant = $stringarray[1]
			EndIf
			If ($stringarray[0] = "pet") Then
				If (asize($stringarray) > 1) Then $settingpet = $stringarray[1]
			EndIf
			If ($stringarray[0] = "school") Then
				If (asize($stringarray) > 1) Then $settingschool = $stringarray[1]
			EndIf
			If ($stringarray[0] = "wait") Then
				If (asize($stringarray) > 1) Then $settingwait = $stringarray[1]
			EndIf
			If ($stringarray[0] = "untzon") Then
				If (asize($stringarray) > 1) Then $settinguntzon = $stringarray[1]
			EndIf
			If ($stringarray[0] = "untzuser") Then
				If (asize($stringarray) > 1) Then $settinguntzuser = $stringarray[1]
			EndIf
			If ($stringarray[0] = "untzpass") Then
				If (asize($stringarray) > 1) Then $settinguntzpass = $stringarray[1]
			EndIf
			If ($stringarray[0] = "invrows") Then
				If (asize($stringarray) > 1) Then $settingrows = $stringarray[1]
			EndIf
			If ($stringarray[0] = "sktoggle") Then
				If (asize($stringarray) > 1) Then $settingsktoggle = $stringarray[1]
				If $settingsktoggle = 1 Then
					$fileseckey = FileOpen($seckeytxt, 0)
					If ($fileseckey == -1) Then Exit
					$settingseckey = FileReadLine($fileseckey,1)
					If @error = -1 Then Exit
					If $settingseckey == "" Then Exit
					FileClose($seckeytxt)
				EndIf
			EndIf
		WEnd
		FileClose($settingstxt)
	EndIf
EndFunc

Func _CloseBots()
	Local $clist = StringSplit('DeathCheck,UntzBot,UntzCrewBot,ClickInv',',')
	Local $plist = ProcessList()
	For $i = 1 To $plist[0][0]
		$psname = $plist[$i][0]
		For $j = 1 To $clist[0]
			If StringInStr($psname, $clist[$j]) <> 0 Then ProcessClose($psname)
		Next
	Next
EndFunc

Func _LoginBot()
	WinWaitActive("UntzBot", "", 60)
	Sleep(500)
	Send("{TAB}")
	Sleep(500)
	if $settinguntzpass <> "" Then
		ClipPut($settinguntzpass)
		Send("^v")
		Sleep(500)
	EndIf
	Send("{TAB}")
	Sleep(100)
	Send("{Enter}")
	Sleep(500)
EndFunc

Func _LoadBot()
	WinActivate($ProcName)
	Send("e")
	Sleep(100)
	$result = _WaitForImageSearch($imgUntzLoad,60,1,$x1,$y1,0)
	if $result=1 Then
		Sleep(500)
		MouseMove($x1,$y1,3)
		MouseClick("left")
		Sleep(1000)
		MouseClick("left")
	EndIf
	Sleep(30000)
EndFunc

Func _LoadCheck()
	WinActivate($ProcName)
	$result = _WaitForImageSearch($imgUntzDefault,10,1,$x1,$y1,0)
	if $result=1 Then
		return 1
	EndIf
	return 0
EndFunc

Func _InitializeBot()
	Send("q")
	Sleep(100)
	Send("e")
	Sleep(500)


	WinActivate($ProcName)
	For $i = 1 To 8 Step +1
		Sleep(100)
		Send("{TAB}")
	Next
	Send("{Space}")
	Sleep(2000)
EndFunc

; Load settings from settings.txt
_LoadSettings()

; If no password has been entered exit
If $settingpassword = "" Then Exit

; If swtor is running close it
$launcher=ProcessExists("launcher.exe")
If $launcher = 0 Then
	If ProcessExists("swtor.exe") Then ProcessClose("swtor.exe")
EndIf

; If any version of DeathCheck or UntzBot or CrewBot is running close them
_CloseBots()

; Wait for launcher screen, once it appears make sure it is still there and ready for input a second later.
;	The one second wait is for when launcher isn't being patched. Wait time is settable.
$result = _WaitForImageSearch($imgStart,$settingwait,1,$x1,$y1,0)
if $result=1 Then
	Sleep(1000)
	$result = _WaitForImageSearch($imgStart,$settingwait,1,$x1,$y1,0)
	if $result=1 Then
		MouseMove($x1,$y1,3)
		; Reset mouse buttons
		MouseUp("left")
		MouseUp("right")
		Sleep(100)
		MouseClick("left")
		Sleep(100)
		if $settingusername <> "" Then
			Send("{TAB}")
			Sleep(500)
			ClipPut($settingusername)
			Send("^v")
		EndIf
		Send("{TAB}")
		Sleep(500)
		ClipPut($settingpassword)
		Send("^v")
		If $settingsktoggle = 1 Then
			Send("{TAB}")
			Sleep(500)
			ClipPut($settingseckey)
			Send("^v")
		EndIf
		Sleep(500)
		Send("{Enter}")
	EndIf
Else
	Exit
EndIf

; If the play button is ready skip secret questions, if not look for them (do two passes just in case)
$result = _WaitForImageSearch($imgPlay,5,1,$x1,$y1,0)
if $result <> 1 Then
	While $searchPass < 2
		if $settingteacher <> "" Then
			$result = _WaitForImageSearch($imgTeacher,1,1,$x1,$y1,0)
			if $result=1 Then
				ClipPut($settingteacher)
				Send("^v")
				Send("{Enter}")
				ExitLoop
			EndIf
		EndIf

		if $settingfriend <> "" Then
			$result = _WaitForImageSearch($imgFriend,1,1,$x1,$y1,0)
			if $result=1 Then
				ClipPut($settingfriend)
				Send("^v")
				Send("{Enter}")
				ExitLoop
			EndIf
		EndIf

		if $settingrestaurant <> "" Then
			$result = _WaitForImageSearch($imgRestaurant,1,1,$x1,$y1,0)
			if $result=1 Then
				ClipPut($settingrestaurant)
				Send("^v")
				Send("{Enter}")
				ExitLoop
			EndIf
		EndIf

		if $settingpet <> "" Then
			$result = _WaitForImageSearch($imgPet,1,1,$x1,$y1,0)
			if $result=1 Then
				ClipPut($settingpet)
				Send("^v")
				Send("{Enter}")
				ExitLoop
			EndIf
		EndIf

		if $settingpet <> "" Then
			$result = _WaitForImageSearch($imgSchool,1,1,$x1,$y1,0)
			if $result=1 Then
				ClipPut($settingschool)
				Send("^v")
				Send("{Enter}")
				ExitLoop
			EndIf
		EndIf

		$searchPass = $searchPass + 1
	WEnd
EndIf
Sleep(500)

$result = _WaitForImageSearch($imgEnv,10,1,$x1,$y1,0)
if $result=1 Then
	MouseMove($x1,$y1,3)
	MouseClick("left")
EndIf

$result = _WaitForImageSearch($imgNext,10,1,$x1,$y1,0)
if $result=1 Then
	MouseMove($x1,$y1,3)
	MouseClick("left")
	MouseMove(0,0,3)
EndIf

; Wait for play button to be active while patching (wait time is settable)
$result = _WaitForImageSearch($imgPlay,$settingwait,1,$x1,$y1,0)
if $result=1 Then
	MouseMove($x1,$y1,3)
	MouseClick("left")
EndIf

; Wait for play arrow (wait time is settable)
$result = _WaitForImageSearch($imgPlay2,$settingwait,1,$x1,$y1,0)
if $result=1 Then
	MouseMove($x1,$y1,3)
	MouseClick("left")
Else
	Exit
EndIf

; If UntzOn is not set then exit
If $settinguntzon <> 1 Then Exit

; Wait 10 seconds for loading screem to finish
Sleep(10000)

; Start current version of Deathcheck and Untzbot in the directory below this directory.
Local $untz = StringSplit('DeathCheck,UntzBot',',')
For $i = 1 To $untz[0]
	Local $search = FileFindFirstFile(@WorkingDir & "\..\"& $untz[$i] & "*.exe")
	While 1
		Local $file = FileFindNextFile($search)
		If @error Then ExitLoop
	Run(@WorkingDir & "\..\"& $file, @WorkingDir & "\..\")
	WEnd
Next
FileClose($search)

; Wait for Untzbot to start and once it has enter the password
_LoginBot()

; Loads bot (twice), Start and stop bot, Start bot
_InitializeBot()

; Loads bot, makes sure that bot is indeed loaded before preceding.
; Note that the default mission of Republic10Fondor cannot be used as a viable mission, sorry.
_LoadBot()
$Ready=_LoadCheck()
While $Ready=1
	_LoadBot()
	_LoadCheck()
WEnd

if $settingrows <> "" Then
	Local $search = FileFindFirstFile(@WorkingDir & "\ClickInv*.exe")
	While 1
		Local $file = FileFindNextFile($search)
		If @error Then ExitLoop
		Run(@WorkingDir & "\"& $file, @WorkingDir)
	WEnd
	FileClose($search)
EndIf

WinActivate("Star Wars")
Sleep(500)
Send("q")