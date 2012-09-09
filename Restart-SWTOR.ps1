#
# Restart-SWTOR.ps1
#
# Edited by jgoines, http://www.elitepvpers.com (PMs checked often)
# -Editing to launch SWTOR and my app TORAL if SWTOR is offline (after doing a server status check)
#
# Originally Written by Aaron Wurthmann (aaron (AT) wurthmann (DOT) com) as Watch-Swtor.ps1
#
# If you edit please keep my name as an original author and
# keep me apprised of the changes, see email address above.
# This code may not be used for commercial purposes.
# You the executor, runner, user accept all liability.
# This code comes with ABSOLUTELY NO WARRANTY.
# You may redistribute copies of the code under the terms of the GPL v2.
# -----------------------------------------------------------------------
# 2012.05.21 ver 4
#
# Summary:
# Checks number of connections swtor.exe has established.
# Write connection status to console screen.
# If not connected, see if servers are online, if servers are online launch SWTOR and TORAL.
#
# -----------------------------------------------------------------------
# General Usage:
#	Edit your server in the settings.txt file, This is optional and recommended but not required.
#    Start Star Wars The Old Republic, start the script from the PowerShell console Running as Administrator
#	

function Get-NetworkStatistics
{
    # From Shay Levy, PowerShell MVP
    $properties = 'Protocol','LocalAddress','LocalPort'
    $properties += 'RemoteAddress','RemotePort','State','ProcessName','PID' 

    netstat -ano | Select-String -Pattern '\s+(TCP|UDP)' | ForEach-Object { 

        $item = $_.line.split(" ",[System.StringSplitOptions]::RemoveEmptyEntries) 

        if($item[1] -notmatch '^\[::')
        {
            if (($la = $item[1] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6')
            {
               $localAddress = $la.IPAddressToString
               $localPort = $item[1].split('\]:')[-1]
            }
            else
            {
                $localAddress = $item[1].split(':')[0]
                $localPort = $item[1].split(':')[-1]
            }  

            if (($ra = $item[2] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6')
            {
               $remoteAddress = $ra.IPAddressToString
               $remotePort = $item[2].split('\]:')[-1]
            }
            else
            {
               $remoteAddress = $item[2].split(':')[0]
               $remotePort = $item[2].split(':')[-1]
            }  

            New-Object PSObject -Property @{
                PID = $item[-1]
                ProcessName = (Get-Process -Id $item[-1] -ErrorAction SilentlyContinue).Name
                Protocol = $item[0]
                LocalAddress = $localAddress
                LocalPort = $localPort
                RemoteAddress =$remoteAddress
                RemotePort = $remotePort
                State = if($item[0] -eq 'tcp') {$item[3]} else {$null}
            } | Select-Object -Property $properties
        }
    }
}

[string]$server=Get-Content .\settings.txt | Select-String "server,"
[string]$server=$server.Split(",")[1]

if (!($server)) {
	[string]$server="Mandalore the Indomitable"
}

[string]$allusersprofile=$env:ALLUSERSPROFILE
[int]$answer=42
[string]$swtorApp=""
[string]$TORALapp=".\TORAL.exe"
[string]$TORBSapp="..\UntzBot50x4.exe"
[string]$TORALproc=$TORALapp.Split("\"".")[-2]
[string]$TORBSproc=$TORBSapp.Split("\"".")[-2]

[string]$forswor="http://www.forswor.com/forswor_services/prod/serverwidget/getSWTORStatusxml.php?server="
[string]$server_name=$server.Replace(" ","%20")
[string]$url=$forswor+$server_name
$wc = (new-object System.Net.WebClient)

if (Test-Path ($allusersprofile + "\Start Menu\Programs\EA\BioWare\Star Wars - The Old Republic\Star Wars - The Old Republic.lnk") ) {
	$swtorApp=$allusersprofile + "\Start Menu\Programs\EA\BioWare\Star Wars - The Old Republic\Star Wars - The Old Republic.lnk"
}

if (Test-Path ($allusersprofile + "\Microsoft\Windows\Start Menu\Programs\EA\BioWare\Star Wars - The Old Republic\Star Wars - The Old Republic.lnk") ) {
	$swtorApp=$allusersprofile + "\Microsoft\Windows\Start Menu\Programs\EA\BioWare\Star Wars - The Old Republic\Star Wars - The Old Republic.lnk"
}
# Why that method to launch instead of a reg key check? On the two systems I checked (Windows 7 64bit and Windows XP 32Bit) the reg key moved around.


do {
	if ($content) { Remove-Variable content }
    $date=Get-Date
    Start-Sleep -s 60
    $count=0
	if (Get-Process swtor -ErrorAction SilentlyContinue) {
		$swtorNetStat=Get-NetworkStatistics | Where-Object {$_.ProcessName -eq 'swtor'} | Where-Object {$_.State -eq 'ESTABLISHED'} | Format-Table
		$count=$swtorNetStat.count
	}
    if ($count -ge 6) {
		$result="Connected"
		$status="SWTOR client status at " +$date +": "+$result
		write-host $status
		
		if (-not (Get-Process $TORALproc -ErrorAction SilentlyContinue) ) {
			if (-not (Get-Process $TORBSproc -ErrorAction SilentlyContinue) ) {
				$result=$TORBSproc +" is not running."
				$status="SWTOR client status at " +$date +": "+$result
				write-host $status
				if (Get-Process swtor -ErrorAction SilentlyContinue) { Stop-Process -name swtor }
				if (Get-Process clickinv -ErrorAction SilentlyContinue) { Stop-Process -name clickinv}
			}
		}
	}
	ELSE {
		$result="Disconnected"
		$status="SWTOR client status at " +$date +": "+$result
		write-host $status
		if (-not (Get-Process launcher -ErrorAction SilentlyContinue) ) {
			[xml]$content=$wc.DownloadString($url)
			if ($content) {
			$server_state=$content.SWTORServerState.server_state
			if ($server_state -eq "UP") {
				if (Get-Process swtor -ea 0) { Stop-Process -processname swtor }
					Start-Process $swtorApp
					Start-Process $TORALapp
				}
				Start-Sleep -s 120
			}
		}
		ELSE {
			$result="Launcher is Running"
			$status="SWTOR client status at " +$date +": "+$result
			write-host $status
			
			if (Get-Process launcher -ErrorAction SilentlyContinue) {
				[int]$launcherTime=((get-date) - (Get-Process launcher).StartTime).TotalMinutes
			}
			if ($launcherTime -gt 28) {
				$result="Launcher Hung for " +$launcherTime +"Minutes"
				$status="SWTOR client status at " +$date +": "+$result
				write-host $status
				if (Get-Process launcher -ErrorAction SilentlyContinue) { Stop-Process -Name launcher }
				if (Get-Process swtor -ErrorAction SilentlyContinue) { Stop-Process -Name swtor }
				if (Get-Process TORAL -ErrorAction SilentlyContinue) { Stop-Process -Name TORAL }
			}
		}
	}
	# check for total running, check for 
	
	
}
while ($answer -eq 42)
