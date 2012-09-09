#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\..\icons\inventory.ico
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Global Const $tagpoint = "long X;long Y"
Global Const $hgdi_error = Ptr(-1)
Global Const $invalid_handle_value = Ptr(-1)
Global Const $kf_extended = 256
Global Const $kf_altdown = 8192
Global Const $kf_up = 32768
Global Const $llkhf_extended = BitShift($kf_extended, 8)
Global Const $llkhf_altdown = BitShift($kf_altdown, 8)
Global Const $llkhf_up = BitShift($kf_up, 8)
Global Const $cbs_autohscroll = 64
Global Const $cbs_dropdown = 2
Global Const $__comboboxconstant_ws_vscroll = 2097152
Global Const $gui_ss_default_combo = BitOR($cbs_dropdown, $cbs_autohscroll, $__comboboxconstant_ws_vscroll)
Global Const $es_autovscroll = 64
Global Const $es_autohscroll = 128
Global Const $es_wantreturn = 4096
Global Const $__editconstant_ws_vscroll = 2097152
Global Const $__editconstant_ws_hscroll = 1048576
Global Const $gui_ss_default_edit = BitOR($es_wantreturn, $__editconstant_ws_vscroll, $__editconstant_ws_hscroll, $es_autovscroll, $es_autohscroll)
$rows=0
$bigsleep=3600000
$go = 0
$x1=0
$y1=0
$hgui = GUICreate("ClickInv v1.3", 400, 330)
Global $array1[8][10]
Global $array2[8]
Global $states[8]
$hlabel1 = GUICtrlCreateLabel("Select", 10, 5, 50, 15)
$hlabel2 = GUICtrlCreateLabel("Row", 15, 25, 50, 15)
;$hlabel3 = GUICtrlCreateLabel("T: Start", 100, 300, 50, 20)
$hlabel4 = GUICtrlCreateLabel("Y: Exit", 100, 300, 50, 20)
$hlabel5 = GUICtrlCreateLabel("Stopped", 200, 300, 200, 20)
;$hlabel7 = GUICtrlCreateLabel("STOPPED", 300, 310, 50, 20)
$hlabel6 = GUICtrlCreateLabel("Clicks on boxes in inventory.", 100, 10, 300, 20)
$hlabel8 = GUICtrlCreateLabel("", 200, 30, 400, 20)
$settingstxt="settings.txt"
$imgWorldmap="images\worldmap.bmp"
$settingwait=600

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
	If ($filesetting <> -1) Then
		While 1
			$curline = FileReadLine($filesetting)
			If @error = -1 Then ExitLoop
			$stringarray = _stringexplode($curline, ",")
			If ($stringarray[0] = "invrows") Then
				If (asize($stringarray) > 1) Then $rows = $stringarray[1]
			EndIf
			If ($stringarray[0] = "invsleep") Then
				If (asize($stringarray) > 1) Then $bigsleep = $stringarray[1]
			EndIf
		WEnd
		FileClose($settingstxt)
	Else
		Exit
	EndIf
EndFunc

Func fstart()
	$windowname = "Star Wars: The Old Republic"
	WinMove($windowname, "", 0, 0, 800, 600)
	$checkRow = 0
	$checkColumn = 0
	$go = 1
	GUICtrlSetData($hlabel5, "Running")
	While($go)
		If(GUICtrlRead($array1[$checkRow][$checkColumn]) = 1) Then
			MouseMove(64 + $checkColumn * 28, 214 + $checkRow * 28, 5)
			Sleep(400)
			MouseClick("right")
			Sleep(400)
			;GUICtrlSetState($array1[$checkRow][$checkColumn], 4)
			$sleepcount = 1
			Sleep(100)
			$sleepcount = $sleepcount + 1
			;GUICtrlSetData($hlabel7, "Sleep: " & $sleepcount)
		EndIf
		$checkColumn = $checkColumn + 1
		If($checkColumn = 10) Then
			$checkColumn = 0
			$checkRow = $checkRow + 1
			If($checkRow > 7) Then
				$go = 0
				GUICtrlSetData($hlabel5, "Done")
				;GUICtrlSetData($hlabel7, "DONE")
			EndIf
		EndIf
	WEnd
EndFunc

Func fquit()
	$go = 0
	;GUICtrlSetData($hlabel5, "STOPPED")
	Exit
EndFunc


;HotKeySet("t", "FStart")
HotKeySet("y", "FQuit")

_LoadSettings()
if $rows = "" Then Exit
if $rows <= 0 Then Exit
if $rows > 8 Then $Rows=8


$checkRow = 0
While($checkRow < 8)
	$checkColumn = 0
	While($checkColumn < 10)
		$array1[$checkRow][$checkColumn] = GUICtrlCreateCheckbox("", $checkColumn * 30 + 100, $checkRow * 30 + 50, 20, 20)
		$checkColumn = $checkColumn + 1
	WEnd
	$checkRow = $checkRow + 1
WEnd

$checkRow = 0
While($checkRow < 8)
	$array2[$checkRow] = GUICtrlCreateCheckbox("", 20, $checkRow * 30 + 50, 20, 20)
	$checkRow = $checkRow + 1
WEnd

$checkRow = 0
While($checkRow < $Rows)
	GUICtrlSetState($array2[$checkRow], 1)
	$checkRow = $checkRow + 1
Wend

GUISetState(@SW_SHOW)

Sleep(100)
$rowState = 0
While($rowState < 8)
	$curr = GUICtrlRead($array2[$rowState])
	If($curr <> $states[$rowState]) Then
		$columnState = 0
		While($columnState < 10)
			GUICtrlSetState($array1[$rowState][$columnState], $curr)
			$columnState = $columnState + 1
		WEnd
	EndIf
	$states[$rowState] = $curr
	$rowState = $rowState + 1
WEnd

GUICtrlSetData($hlabel5, "Initial Sleep")
Sleep(45000)

While(1)
GUICtrlSetData($hlabel5, "Waiting for Worldmap")
$result = _WaitForImageSearch($imgWorldmap,$settingwait,1,$x1,$y1,0)
	if $result=1 Then
		GUICtrlSetData($hlabel5, "Worldmap found")
		Sleep(2000)
		WinActivate("Star Wars")
		GUICtrlSetData($hlabel5, "Stopping UntzBot")
		Send("e")
		Sleep(2000)
		GUICtrlSetData($hlabel5, "Running")
		Sleep(100)
		Send("i")
		Sleep(100)
		fstart()
		Send("q")
		GUICtrlSetData($hlabel5, "Sleeping")
		Sleep($bigsleep)
	EndIf
WEnd
