#ReadMe.txt

TORAL (The Old Republic Automatic Login)


==Simple Mode==
Unzip to any location
Edit the information in the settings.txt file with your information.
	Requires password. Rest is optional.
Run TORAL.exe as an Administrator.
Start SWTOR


==Untzbot Mode==
Unzip to Untzbot directory.
	Be sure to have run Untzbot and saved your settings prior as well as be on the ship at the map, etc...
Edit the information in the settings.txt file with your information.
	Requires untzon set to 1 as well as password and untzpass if applicable. Rest is optional.
Run TORAL.exe as an Administrator.
Start SWTOR


==Advanced Mode==
Unzip to Untzbot directory.
	Be sure to have run Untzbot and saved your settings prior as well as be on the ship at the map, etc...
Edit the information in the settings.txt file with your information.
	Requires untzon set to 1 as well as password and untzpass. Rest is optional.
Run PowerShell as Administrator
CD to directory
Run Restart-SWTOR.ps1


==Uber Advanced Mode aka Fully Automatic Mode==
Unzip to Untzbot directory.
	Be sure to have run Untzbot and saved your settings prior as well as be on the ship at the map, etc...
Edit the information in the settings.txt file with your information.
	Requires untzon set to 1 as well as password and untzpass. Rest is optional.
If you have a Security Key on your account call Support and disable it.
Disable UAC (HINT: Google it)
Enable Windows Auto Login (HINT: Google it)
Make a shortcut to PSH_Restart-SWTOR.bat in yout "Start Up" folder
Restart computer.




_Release Notes_

v3.2 - 2012-09-04
Function add: Added support for private build of UntzBot by requiring untzon

Function add: Starts ClickInv.exe which clicks through your inventory. (Good for clicking on cases/chests)
	ClickInv uses the following settings
	invrows,7		<-- Number of rows to click
	invsleep,10800000	<-- Time in milliseconds to wait/sleep
	NOTE: If you don't want to run ClickInv remove invrows from the settings file.

Function add: Added checks for launcer.exe total run time in Restart-SWTOR.ps1
	If launcher.exe is running for longer than 30 minutes then it is killed restarted.
	==WARNING==
	If you typically take longer than 30 minutes to patch or 
	 if there is a rather large patch you should edit the time. Default is 28.


v3 - 2012-05-20
Function add: Kills swtor.exe at startup if it is already running.
Function add: Kills Untzbot and Deathcheck at startup if they are already running.
Function add: Added check to insure that Launcher was not being patched before continuing.
Function add: Check if Play button is ready before checking if Secret questions are needed.
Function add: Start DeathCheck and Untzbot, log into Untzbot, load settings and start bot.
Addon Included: Restart-SWTOR.ps1
Esthetics: Changed name to TORAL (chagned from SWTOR_Login). Added comments for sections in source code.

v2.3 - 2012-05-14
Removed Function: Lauch SWTOR automatically
	NOTE: It just isn't working. Shoot it!

v2.2 - 2012-05-14
Function add: Now auto detects Windows UAC setting. If off, launch SWTOR
	NOTE: To disable this, if you want to (why I dont know), you can edit the path setting.
	AlSO NOTE: No error is returned or logged for the path being wrong.
		So make sure the path setting is correct if you want this to work.
Function add: Will now quick exit app if username and password are not provided


v2.1 - 2012-05-10
Bug fix: Re-added functionality for SecKey. 
Changed icon to KOTR II icon.
Additions to Read Me file.

v2 - 2012-05-09
Public release.


About:
Written by: jgoines, http://www.elitepvpers.com (PMs checked often)  
this app was inspired by thephilz's work on Untzbot (http://www.elitepvpers.com). Thank you thephilz.
Code from the addon script Restart-SWTOR.ps1 was included from Aaron Wurthmann (http://irl33t.com). Thank you Aaron.
This app is merely a compiled script however I refer to it as an app, yeah yeah I know, shut it!
This app does not make any network connections to anywhere, it meerly moves the mouse and types for you.

For the paranoid:
Please feel free to install AutoIt and re-compile the Exe. - http://www.autoitscript.com or Google: AutoIt


More Information:
Remember that this app will need to be started with Administrative rights if UAC is enabled.
If you are not comfortable with the secret questions being filled out leave them blank or remove the line.
All you need to do in that case is login to the system manually once in a while (might be once a day or longer).


Future Versions:
I believe there are more than the 5 questions I picked for the secret questions. I need screenshots.
I am thinking about including instructions and a script on how to edit the SecKey file from the interwebs
	or another addon to post and read a Twitter feed with the SecKey in it.
 

Files:
Untzbot [OPTIONAL]
   TORAL_v3.2
	│   ClickInv.au3		<- Source code for the paranoid
	│   ClickInv.exe		<- [Optional] Clicks items in inventory
	│   ImageSearchDLL.dll		<- DLL used to search for images
	│   PSH_Restart-SWTOR.bat	<- Batch script used in Uber Advanced Mode
	│   Restart-SWTOR.ps1		<- Run this script under PowerShell running as Administrator
	│   seckey.txt			<- Optional security key file.
	│   settings.txt		<- Edit this file with your information (at least password)
	│   TORAL_ReadMe.txt		<- This file
	│   TORAL.au3			<- Source code for the paranoid
	│   TORAL.exe			<- Program to run with Administrative Rights
	│
	└───images
        	arrow.bmp		<- Arrow image (the arrow to click on the select character screen)
		arrow2.bmp		<- Arrow image (the arrow to click on the select character screen)
		enviroment.bmp		<- Image to answer the enviroment question.
        	friend.bmp		<- Image to answer the friend question.
        	login.bmp		<- Image to click onto login after entering username and password.
        	pet.bmp			<- Image to answer the pet question.
        	play.bmp		<- Image to click on after logging in and patching.
		restaurant.bmp		<- Image to answer the school question.
        	school.bmp		<- Image to answer the school question.
        	teacher.bmp		<- Image to answer the teacher question.
		untzload.bmp		<- Untzbot Load button
		untzlogin.bmp		<- Untzbot Login button
        	welcome.bmp		<- Image to look for to begin.


|||||EXAMPLES|||||

==settings.txt==
username,you@webs.ext	<- Your username/email address
password,9455w0rd	<- Your password
teacher,goines		<- Answer to secret question about teacher
friend,jeff		<- Answer to secret question about friend
restaurant,hooters	<- Answer to secret question about restaurant
pet,bubbles		<- Answer to secret question about pet
school,hard knocks	<- Answer to secret question about school
wait,300		<- Max time to wait, in seconds, for patching
untzon,1		<- Enables UntzBot to launch automatically
untzpass,666		<- Untzbot Password
server,darth maul	<- Server name (used in advanced mode only)
invrows,7		<- Number of rows to click in inventory
invsleep,10800000	<- Milliseconds to wait till next inventory check
sktoggle,0		<- Security Token Toggle 0 = off 1 = on
			   ^ This means seckey.txt will be checked

==seckey.txt==
			<- Blank by default.
			You need to add your security key here via some other method.
			I recommend deleting or blanking out the file once SWTOR has started.
			Both the method for adding this key and the deleting is up to you.
