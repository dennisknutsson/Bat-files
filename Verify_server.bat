@ECHO OFF
REM ======================================================================
REM
REM NAME: Verify_server.bat 
REM
REM AUTHOR  : Dennis Knutsson Qbranch Väst AB 
REM AUTHOR  : dennis.knutsson@qbranch.se
REM AUTHOR  : 0732-312637
REM Created : 2013-08-23
REM
REM COMMENT: Check status of servers for costumer
REM USAGE1: Scriptname only = search for computers in list if list exist else prompt for computername
REM USAGE2: Scriptname computername = Checks only computername
REM TODO: settings file include user and password for schtask, domain.
REM ======================================================================
CLS
SETLOCAL ENABLEDELAYEDEXPANSION

::Features to enable/disable
IF NOT EXIST "settings.cfg" ECHO.>settings.cfg
::show_systeminfo ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "show_systeminfo" "settings.cfg"') DO IF %%A==0 (ECHO show_systeminfo^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "show_systeminfo" "settings.cfg"') DO (SET _check_systeminfo=%%A)
::check_antivirus_ver ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_antivirus_ver" "settings.cfg"') DO IF %%A==0 (ECHO check_antivirus_ver^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_antivirus_ver" "settings.cfg"') DO (SET _check_antivirus_ver=%%A)
:: check_Antivirusdate ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_antivirus_date" "settings.cfg"') DO IF %%A==0 (ECHO check_antivirus_date^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_antivirus_date" "settings.cfg"') DO (SET _check_antivirus_date=%%A)
::check_legato_ver ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_legato_ver" "settings.cfg"') DO IF %%A==0 (ECHO check_legato_ver^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_legato_ver" "settings.cfg"') DO (SET _check_legato_ver=%%A)
::check_access ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_access" "settings.cfg"') DO IF %%A==0 (ECHO check_access^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_access" "settings.cfg"') DO (SET _check_access=%%A)
::check_bbwin_ver ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_bbwin_ver" "settings.cfg"') DO IF %%A==0 (ECHO check_bbwin_ver^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_bbwin_ver" "settings.cfg"') DO (SET _check_bbwin_ver=%%A)
::check_profiles ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_profiles" "settings.cfg"') DO IF %%A==0 (ECHO check_profiles^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_profiles" "settings.cfg"') DO (SET _check_profiles=%%A)
::check_scom ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_scom_ver" "settings.cfg"') DO IF %%A==0 (ECHO check_scom_ver^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_scom_ver" "settings.cfg"') DO (SET _check_scom_ver=%%A)
::check_loggedon ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_loggedon" "settings.cfg"') DO IF %%A==0 (ECHO check_loggedon^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_loggedon" "settings.cfg"') DO (SET _check_loggedon=%%A)
:: check_net ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_net" "settings.cfg"') DO IF %%A==0 (ECHO check_net^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_net" "settings.cfg"') DO (SET _check_net=%%A)
:: check_ilo ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_ilo" "settings.cfg"') DO IF %%A==0 (ECHO check_ilo^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_ilo" "settings.cfg"') DO (SET _check_ilo=%%A)

::run_ipconfig ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "run_ipconfig" "settings.cfg"') DO IF %%A==0 (ECHO run_ipconfig^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "run_ipconfig" "settings.cfg"') DO (SET _run_ipconfig=%%A)
::Upgrade antivirus ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "upgrade_antivirus" "settings.cfg"') DO IF %%A==0 (ECHO upgrade_antivirus^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "upgrade_antivirus" "settings.cfg"') DO (SET _upgrade_antivirus=%%A)
::Upgrade legato ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "upgrade_legato" "settings.cfg"') DO IF %%A==0 (ECHO upgrade_legato^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "upgrade_legato" "settings.cfg"') DO (SET _upgrade_legato=%%A)
::Upgrade SCOM ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "upgrade_scom" "settings.cfg"') DO IF %%A==0 (ECHO upgrade_scom^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "upgrade_scom" "settings.cfg"') DO (SET _upgrade_scom=%%A)


REM Prereq
IF NOT EXIST ..\Script_software\*.* ECHO ..\Script_software\*.* not found &PAUSE& GOTO EOF
IF EXIST ..\Script_software\psexec.exe (SET _psexec="..\Script_software\psexec.exe")ELSE (ECHO ..\Script_software\psexec.exe not found &PAUSE& GOTO EOF)

REM IF NOT EXIST ..\Script_software\psexec.exe ECHO Psexec not found &PAUSE& GOTO EOF
IF EXIST ..\Script_software\psloggedon.exe (SET _psloggedon="..\Script_software\psloggedon.exe")ELSE (ECHO ..\Script_software\psloggedon.exe not found &PAUSE& GOTO EOF)
REM IF NOT EXIST ..\Script_software\psloggedon.exe ECHO Psloogedon not found &PAUSE& GOTO EOF


SET SCRIPTDIR=%~dp0
SET _colspan=2

IF "%Computername%"=="SNJMP2A4449" SET _dnssuffix=rab.local
IF "%Computername%"=="SNJMP2B4452" SET _dnssuffix=rab.local
IF "%Computername%"=="SNJMP3A4450" SET _dnssuffix=eur.corp.vattenfall.com
IF "%Computername%"=="SNJMP3B4453" SET _dnssuffix=eur.corp.vattenfall.com
IF "%Computername%"=="SNJMP4A4453" SET _dnssuffix=eur.corp.vattenfall.com
IF "%Computername%"=="SNJMP4B4454" SET _dnssuffix=eur.corp.vattenfall.com


CLS
IF X%1 NEQ X SET _computer=%1
IF X%1 EQU X SET /p _computer=Computer ? 

SET _header=Computername
SET _result=!_computer!

SET _separator=***** Pinging !_computer! ************************************************************
ECHO !_separator:~0,70!
SET _mode=NA
ECHO. 
FOR /F "tokens=1 delims= " %%A IN ('PING -n 1 !_computer!.!_dnssuffix!^|FIND /I "Reply from"^|FIND /C /I "bytes"') DO IF %%A==1 (SET _mode=up&ECHO !_computer! is Up) ELSE (SET _mode=down&ECHO !_computer! is Down)
ECHO. 
IF !_mode!==down ECHO !_computer!>>Files\offline.log
IF !_mode!==up ECHO !_computer!>>Files\online.log
SET _header=!_header!,Mode
SET _result=!_result! !_mode!
SET _separator=***** End pinging !_computer! ************************************************************
ECHO !_separator:~0,70!
ECHO.

IF !_mode! == up (

REM Running systeminfo on remote computer
SET _OSName=NA
SET _OSVersion=NA
SET _Manufacturer=NA
SET _Model=NA
SET _Type=NA
SET _PageFileLocation=NA
IF !_check_systeminfo!==yes (
SET /A _colspan+=6
SET _separator=***** Checking systeminfo on !_computer! ******************************************************
ECHO !_separator:~0,70!
ECHO.

IF NOT EXIST "%~dp0Files\systeminfo" MD "%~dp0Files\systeminfo"


REM IF EXIST !_psexec! !_psexec! \\!_computer! systeminfo>systeminfo\!_computer!.txt
IF "%Computername%"=="!_computer!" IF NOT EXIST Files\systeminfo\!_computer!.txt systeminfo>Files\systeminfo\%Computername%.txt
REM IF "%Computername%"=="SNJMP2A4449" IF NOT EXIST systeminfo\!_computer!.txt systeminfo>systeminfo\%Computername%.txt
REM IF "%Computername%"=="SNJMP2B4452" IF NOT EXIST systeminfo\!_computer!.txt systeminfo>systeminfo\%Computername%.txt
REM IF "%Computername%"=="SNJMP3A4450" IF NOT EXIST systeminfo\!_computer!.txt systeminfo>systeminfo\%Computername%.txt
REM IF "%Computername%"=="SNJMP3B4453" IF NOT EXIST systeminfo\!_computer!.txt systeminfo>systeminfo\%Computername%.txt
REM IF "%Computername%"=="SNJMP4A4453" IF NOT EXIST systeminfo\!_computer!.txt systeminfo>systeminfo\%Computername%.txt
REM IF "%Computername%"=="SNJMP4B4454" IF NOT EXIST systeminfo\!_computer!.txt systeminfo>systeminfo\%Computername%.txt
IF NOT EXIST Files\systeminfo\!_computer!.txt !_psexec! \\!_computer! Files\systeminfo>systeminfo\!_computer!.txt

FOR /F %%A IN ("Files\systeminfo\!_computer!.txt") DO IF %%~zA==0 (ECHO !_computer!>>Files\Missing_systeminfo.log&DEL /Q Files\systeminfo\!_computer!.txt)
IF EXIST Files\systeminfo\!_computer!.txt (
FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "OS Name" "Files\systeminfo\!_computer!.txt"') DO (SET _OSName=%%A)
FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "OS Version" "Files\systeminfo\!_computer!.txt"^|FIND /I /V "BIOS"') DO (SET _OSVersion=%%A)
FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "Manufacturer" "Files\systeminfo\!_computer!.txt"') DO (SET _Manufacturer=%%A)
FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "System Model" "Files\systeminfo\!_computer!.txt"') DO (SET _Model=%%A)
FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "Type" "Files\systeminfo\!_computer!.txt"') DO (SET _Type=%%A)
FOR /F "tokens=4 delims= " %%A IN ('FIND /I "Page File Location" "Files\systeminfo\!_computer!.txt"') DO (SET _PageFileLocation=%%A)
REM FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "IP" "systeminfo\!_computer!.txt"') DO (SET _OSName=%%A)

SET _OSName=!_OSName:~19!
SET _OSVersion=!_OSVersion:~16!
SET _Manufacturer=!_Manufacturer:~7!
SET _Model=!_Model:~14!
SET _Type=!_Type:~15,3!

ECHO OSName=			!_OSName!
ECHO OSVersion=		!_OSVersion!
ECHO Manufacturer=		!_Manufacturer!
ECHO Model=			!_Model!
ECHO Type=			!_Type!


REM >>Files\windows_2003.log
REM >>Files\windows_2008.log
REM >>Files\windows_2012.log

ECHO PageFileLocation=	!_PageFileLocation!
ECHO !_computer!>>"Files\!_Type!.log"
ECHO !_computer!>>"Files\!_Manufacturer!.log"
ECHO !_computer!>>"Files\!_OSName!.log"
ECHO !_computer!>>"Files\!_Model!.log"

)
ECHO.
SET _separator=***** End checking systeminfo ver on !_computer! *******************************
ECHO !_separator:~0,70!
ECHO.
)

REM BBWin check
IF !_check_bbwin_ver!==yes (
IF !_check_bbwin_ver! == yes SET /A _colspan+=1
SET _separator=***** Checking bbwin ver on !_computer! *******************************
ECHO !_separator:~0,70!
SET _bbwin_ver=NA
SET _bbwin_ver_current=0.13.0.237
ECHO.
IF NOT EXIST "%~dp0Files\bbwin_FILES_exe" MD "%~dp0Files\bbwin_FILES_exe"

IF EXIST "\\!_computer!\c$\Program Files (x86)\BBWin\bin\BBWin.exe" COPY "\\!_computer!\c$\Program Files (x86)\BBWin\bin\BBWin.exe" "%~dp0Files\bbwin_FILES_exe\!_computer!.exe"
IF EXIST "\\!_computer!\c$\Program Files\BBWin\bin\BBWin.exe" COPY "\\!_computer!\c$\Program Files\BBWin\bin\BBWin.exe" "%~dp0Files\bbwin_FILES_exe\!_computer!.exe"

IF NOT EXIST "%~dp0Files\bbwin_FILES_exe\!_computer!.exe" (ECHO !_computer!>>"%~dp0Files\bbwin_not_found.log") ELSE (
FOR /F %%A IN ("Files\bbwin_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 251392 SET _bbwin_ver=0.13.0.237
FOR /F %%A IN ("Files\bbwin_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 307200 SET _bbwin_ver=0.9.0.0
FOR /F %%A IN ("Files\bbwin_FILES_exe\!_computer!.exe") DO IF !_bbwin_ver! == NA ECHO Filesize %%~zA 

ECHO BBwin_ver=!_bbwin_ver!
IF "!_bbwin_ver!" EQU "!_bbwin_ver_current!" ECHO !_computer!>>Files\BBWin_current.log
IF "!_bbwin_ver!" NEQ "!_bbwin_ver_current!" ECHO !_computer!>>Files\BBWin_NOT_current.log
)
IF EXIST "%~dp0Files\bbwin_FILES_exe\!_computer!.exe" DEL /Q "%~dp0Files\bbwin_FILES_exe\!_computer!.exe"
ECHO.
SET _header=!_header!,BBwin_ver
SET _result=!_result! !_bbwin_ver!
SET _separator=***** End checking bbwin ver on !_computer! *******************************
ECHO !_separator:~0,70!
ECHO.
)


REM Check Network Vlan
IF !_check_net!==yes (
SET /A _colspan+=2
SET _separator=***** Checking net on !_computer! ************************************************
ECHO !_separator:~0,70!
SET _network=Unknown
SET _A=NA
SET _B=NA
SET _C=NA
SET _D=NA
ECHO.

ECHO Getting IP of !_computer!
FOR /F "tokens=2 delims=[]" %%j in ('PING !_computer!^|FINDSTR "Pinging"') do SET _string=%%j
FOR /F "tokens=1,2,3,4 delims=." %%j in ("!_string!") do SET _A=%%j& SET _B=%%k& SET _C=%%l& SET _D=%%m
ECHO Got ip=!_A!.!_B!.!_C!.!_D!

REM Setting _network
REM Z2
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 200 IF /I !_D! GEQ 192 SET _network=Z2V-RH-KR2 vlan 3351
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 201 IF /I !_D! GEQ 0 SET _network=Z2V-RH-KR1 vlan 3350
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 203 IF /I !_D! GEQ 0 SET _network=Z2_Saknas_ipplan
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 204 IF /I !_D! GEQ 32 SET _network=Z2V-Int-Serv vlan 3301
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 204 IF /I !_D! GEQ 64 SET _network=Z2P-Mgmt vlan 3305
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 204 IF /I !_D! GEQ 128 SET _network=Z2V-Infra-W vlan 3321
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 204 IF /I !_D! GEQ 192 SET _network=Z2V-Infra-U vlan 3325
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 205 IF /I !_D! GEQ 0 SET _network=Z2P-Adm-N vlan 3460
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 205 IF /I !_D! GEQ 32 SET _network=Z2P-Adm-W vlan 3461
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 205 IF /I !_D! GEQ 64 SET _network=Z2P-Adm-U vlan 3462
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 205 IF /I !_D! GEQ 128 SET _network=Z2V-Access1-Serv vlan 3471
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 206 IF /I !_D! GEQ 0 SET _network=Z2V-RH-Serv-W1 vlan 3335
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 206 IF /I !_D! GEQ 64 SET _network=Z2V-RH-Serv-U1 vlan 3340
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 207 IF /I !_D! GEQ 48 SET _network=Z2V-Access3-Serv vlan 3481
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 207 IF /I !_D! GEQ 144 SET _network=Z2V-Access2-Serv vlan 3351

		
REM Z3
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 208 IF /I !_D! GEQ 32 SET _network=Z3V-Int-Serv vlan 3006
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 208 IF /I !_D! GEQ 64 SET _network=Z3P-Mgmt vlan 3010
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 208 IF /I !_D! GEQ 128 SET _network=Z3V-Infra-W1 vlan 3021
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 208 IF /I !_D! GEQ 192 SET _network=Z3V-Infra-U1 vlan 3025
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 209 IF /I !_D! GEQ 0 SET _network=Z3V-Unsec-W1 vlan 3031
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 209 IF /I !_D! GEQ 64 SET _network=Z3V-Unsec-U1 vlan 3035
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 210 IF /I !_D! GEQ 0 SET _network=Z3P-Adm-W vlan 3050
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 211 IF /I !_D! GEQ 0 SET _network=Z3P-Adm-N vlan 3051
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 211 IF /I !_D! GEQ 64 SET _network=Z3P-Adm-N2 vlan 3053
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 211 IF /I !_D! GEQ 128 SET _network=Z3P-Adm-U vlan 3052
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 212 IF /I !_D! GEQ 0 SET _network=Z3V-RH-Serv-W1 vlan 3100
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 212 IF /I !_D! GEQ 64 SET _network=Z3V-RH-Serv-W2 vlan 3101
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 212 IF /I !_D! GEQ 128 SET _network=Z3V-RH-Serv-W3 vlan 3102
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 213 IF /I !_D! GEQ 0 SET _network=Z3V-RH-Serv-U1 vlan 3110
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 213 IF /I !_D! GEQ 64 SET _network=Z3V-RH-Serv-U2 vlan 3111
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 213 IF /I !_D! GEQ 128 SET _network=Z3V-RH-Serv-U3 vlan 3112
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 216 IF /I !_D! GEQ 0 SET _network=Z3V-Test-Dev-W1 vlan 3201
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 216 IF /I !_D! GEQ 64 SET _network=Z3V-Test-Dev-W2 vlan 3202
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 217 IF /I !_D! GEQ 0 SET _network=Z3V-Test-Dev-U1 vlan 3205
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 217 IF /I !_D! GEQ 64 SET _network=Z3V-Test-Dev-U2 vlan 3206
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 218 IF /I !_D! GEQ 0 SET _network=Z3V-TechIT-Serv vlan 3211
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 218 IF /I !_D! GEQ 128 SET _network=Z3V-TechIT-TestDev vlan 3215
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 219 IF /I !_D! GEQ 64 SET _network=Z3V-SAP-P-Serv vlan 3061
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 220 IF /I !_D! GEQ 0 SET _network=Z3V-Except-W1 vlan 3041
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 220 IF /I !_D! GEQ 64 SET _network=Z3V-Except-U1 vlan 3045
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 221 IF /I !_D! GEQ 0 SET _network=Z3V-Infra-W2 vlan 3022
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 221 IF /I !_D! GEQ 64 SET _network=Z3V-Infra-U2 vlan 3026
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 222 IF /I !_D! GEQ 0 SET _network=Z3V-TechIT-T-W1 vlan 3076
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 222 IF /I !_D! GEQ 64 SET _network=Z3V-TechIT-T-U1 vlan 3077
	
REM Z4
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 224 IF /I !_D! GEQ 32 SET _network=Z4V-Int-Serv vlan 1606
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 224 IF /I !_D! GEQ 64 SET _network=Z4P-Mgmt vlan 1610
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 224 IF /I !_D! GEQ 128 SET _network=Z4V-Infra-W1 vlan 1621
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 224 IF /I !_D! GEQ 192 SET _network=Z4V-Infra-U1 vlan 1625
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 225 IF /I !_D! GEQ 0 SET _network=Z4P-Adm-N vlan 1630
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 225 IF /I !_D! GEQ 64 SET _network=Z4P-Adm-U vlan 1631
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 225 IF /I !_D! GEQ 128 SET _network=Z4P-Adm-W vlan 1632
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 226 IF /I !_D! GEQ 0 SET _network=Z4P-XCon1 vlan 1641
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 227 IF /I !_D! GEQ 0 SET _network=Z4PHA-AD1 vlan 1600
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 227 IF /I !_D! GEQ 16 SET _network=Z4PHA-AD2 vlan 1601
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 228 IF /I !_D! GEQ 0 SET _network=Z4V-RH-Serv-W1 vlan 1700
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 228 IF /I !_D! GEQ 128 SET _network=Z4V-RH-Serv-U1 vlan 1710
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 229 IF /I !_D! GEQ 0 SET _network=Z4V-RH-TestDev-W vlan 1720
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 229 IF /I !_D! GEQ 128 SET _network=Z4V-RH-TestDev-U vlan 1730
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 231 IF /I !_D! GEQ 0 SET _network=Z4V-RH-TestDev-C vlan 1735
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 232 IF /I !_D! GEQ 0 SET _network=Net_Z4V-Serv-W1 vlan 2561
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 232 IF /I !_D! GEQ 128 SET _network=Net_Z4V-Serv-U1 vlan 2566
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 233 IF /I !_D! GEQ 0 SET _network=Net_Z4V-Test-Dev-W1 vlan 2571
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 233 IF /I !_D! GEQ 128 SET _network=Net_z4v-Test-Dev-U1 vlan 2576
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 234 IF /I !_D! GEQ 0 SET _network=Net_Z4V-Lic-W1 vlan 2591
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 234 IF /I !_D! GEQ 128 SET _network=Net_Z4V-Lic-U1 vlan 2596
IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 235 IF /I !_D! GEQ 192 SET _network=Net_Z4V-Cli-Mgmt-W1 vlan 2581

REM Z4 install
IF /I !_A! EQU 151 IF /I !_B! EQU 156 IF /I !_C! EQU 75 IF /I !_D! GEQ 128 SET _Net_Z4V-Cli-Install vlan 318

REM Z5
IF /I !_A! EQU 151 IF /I !_B! EQU 156 IF /I !_C! EQU 115 IF /I !_D! GEQ 0 SET _network=Z5V-RH-Serv vlan 1027
IF /I !_A! EQU 151 IF /I !_B! EQU 156 IF /I !_C! EQU 115 IF /I !_D! GEQ 64 SET _network=Z5V-RH-Adm vlan 1028

REM Barse
IF /I !_A! EQU 151 IF /I !_B! EQU 156 IF /I !_C! EQU 197 IF /I !_D! GEQ 0 SET _network=NET-151-156-197-0
IF /I !_A! EQU 151 IF /I !_B! EQU 156 IF /I !_C! EQU 197 IF /I !_D! GEQ 64 SET _network=NET-151-156-197-64

REM Z?
REM IF /I !_A! EQU 145 IF /I !_B! EQU 10 IF /I !_C! EQU 10 IF /I !_D! GEQ 64 SET _network=Z4V-Int-Serv
REM IF /I !_A! EQU 151 IF /I !_B! EQU 156 IF /I !_C! EQU 115 IF /I !_D! GEQ 0 SET _network=Z4V-Int-Serv
REM IF /I !_A! EQU 151 IF /I !_B! EQU 156 IF /I !_C! EQU 115 IF /I !_D! GEQ 64 SET _network=Z4V-Int-Serv
REM IF /I !_A! EQU 144 IF /I !_B! EQU 27 IF /I !_C! EQU 235 IF /I !_D! GEQ 192 SET _network=Z4V-Int-Serv

REM Ej i ipplan
REM 145.10.10.64	64	255.255.255.192/26	net_zCDISp CDIS central network no tag			


ECHO Network=!_network!
ECHO !_computer!	!_A!.!_B!.!_C!.!_D!>>"Files\!_network!.log"

ECHO.
SET _header=!_header!,Network
SET _result=!_result! !_network!
SET _separator=***** End checking net on !_computer! ************************************************
ECHO !_separator:~0,70!
ECHO.
)
)


REM Check Antivirus
IF !_check_antivirus_ver!==yes (
SET /A _colspan+=1
SET _separator=***** Checking Antivirus ver on !_computer! *******************************
ECHO !_separator:~0,70!
SET _antivirus_ver=NA
SET _antivirus_ver_current=12.1.2015.2015.105
ECHO.
IF NOT EXIST "%~dp0Files\antivirus_FILES_exe" MD "%~dp0Files\antivirus_FILES_exe"
IF NOT EXIST "%~dp0Files\sep_reg_FILES" MD "%~dp0Files\sep_reg_FILES"


IF !_check_antivirus_date!==yes (
SET /A _colspan+=1
SET _antivirus_date=NA
IF EXIST Files\sep_reg_FILES\!_computer!_sep_reg.txt FOR /F %%A IN ("Files\sep_reg_FILES\!_computer!_sep_reg.txt") DO SET _filetime=%%~tA
SET _filetime=!_filetime:~0,-6!
REM ECHO "!_filetime!"
REM ECHO "%date%"
IF "%date%" NEQ "!_filetime!" DEL /Q "Files\sep_reg_FILES\!_computer!_sep_reg.txt"



IF "%Computername%"=="!_computer!" IF NOT EXIST Files\sep_reg_FILES\!_computer!_sep_reg.txt "..\Script_software\restart_sep\sep_reg.bat">Files\sep_reg_FILES\!_computer!_sep_reg.txt
IF NOT EXIST Files\sep_reg_FILES\!_computer!_sep_reg.txt (
ECHO Copying file for antivirus date
XCOPY "..\Script_software\restart_sep\*" "\\!_computer!\c$\temp\restart_sep" /S /I /D /Y
IF EXIST "\\!_computer!\c$\temp\restart_sep\sep_reg.bat" (IF EXIST !_psexec! !_psexec! \\!_computer! c:\temp\restart_sep\sep_reg.bat>Files\sep_reg_FILES\!_computer!_sep_reg.txt)
)
FOR /F %%A IN ("Files\sep_reg_FILES\!_computer!_sep_reg.txt") DO IF %%~zA EQU 0 DEL /Q "Files\sep_reg_FILES\!_computer!_sep_reg.txt"
IF EXIST "Files\sep_reg_FILES\!_computer!_sep_reg.txt" FOR /F "tokens=* delims=" %%A IN ('FIND /I "LatestVirusDefsDate" "Files\sep_reg_FILES\!_computer!_sep_reg.txt"') DO (SET _antivirus_date=%%A)
IF EXIST "Files\sep_reg_FILES\!_computer!_sep_reg.txt" SET _antivirus_date=!_antivirus_date:    LatestVirusDefsDate    REG_SZ    =!
ECHO Antivirus date !_antivirus_date!
ECHO !_computer!>>Files\Antivirus_!_antivirus_date!.log
)

SET _Restart_antivirus_ver=no
IF !_Restart_antivirus_ver!==yes (
IF NOT !_antivirus_date! EQU NA IF NOT !_antivirus_date! EQU 2014-03-02 (
ECHO Copying file for restart
XCOPY "..\Script_software\restart_sep\*" "\\!_computer!\c$\temp\restart_sep" /S /I /D /Y
IF EXIST "\\!_computer!\c$\temp\restart_sep\restart_sep.bat" (IF EXIST !_psexec! !_psexec! \\!_computer! c:\temp\restart_sep\restart_sep.bat)
)
)


ECHO Copying file for version check.
IF EXIST "\\!_computer!\c$\Program Files (x86)\Symantec\Symantec Endpoint Protection\Rtvscan.exe" COPY "\\!_computer!\c$\Program Files (x86)\Symantec\Symantec Endpoint Protection\Rtvscan.exe" "%~dp0Files\antivirus_FILES_exe\!_computer!.exe">NUL
IF EXIST "\\!_computer!\c$\Program Files\Symantec\Symantec Endpoint Protection\Rtvscan.exe" COPY "\\!_computer!\c$\Program Files\Symantec\Symantec Endpoint Protection\Rtvscan.exe" "%~dp0Files\antivirus_FILES_exe\!_computer!.exe">NUL
IF EXIST "\\!_computer!\c$\Program Files\Symantec AntiVirus\Rtvscan.exe" COPY "\\!_computer!\c$\Program Files\Symantec AntiVirus\Rtvscan.exe" "%~dp0Files\antivirus_FILES_exe\!_computer!.exe">NUL
IF EXIST "\\!_computer!\c$\Program Files (x86)\Symantec\Symantec Endpoint Protection\12.1.1000.157.105\Bin64\Smc.exe" COPY "\\!_computer!\c$\Program Files (x86)\Symantec\Symantec Endpoint Protection\12.1.1000.157.105\Bin64\Smc.exe" "%~dp0Files\antivirus_FILES_exe\!_computer!.exe">NUL
IF EXIST "\\!_computer!\c$\Program Files (x86)\Symantec\Symantec Endpoint Protection\12.1.2015.2015.105\Bin64\Smc.exe" COPY "\\!_computer!\c$\Program Files (x86)\Symantec\Symantec Endpoint Protection\12.1.2015.2015.105\Bin64\Smc.exe" "%~dp0Files\antivirus_FILES_exe\!_computer!.exe">NUL
IF EXIST "\\!_computer!\c$\Program Files\Symantec\Symantec Endpoint Protection\12.1.2015.2015.105\Bin\Smc.exe" COPY "\\!_computer!\c$\Program Files\Symantec\Symantec Endpoint Protection\12.1.2015.2015.105\Bin\Smc.exe" "%~dp0Files\antivirus_FILES_exe\!_computer!.exe">NUL
IF EXIST "\\!_computer!\c$\Program Files\Symantec AntiVirus\12.1.2015.2015.105\Bin\Smc.exe" COPY "\\!_computer!\c$\Program Files\Symantec AntiVirus\12.1.2015.2015.105\Bin\Smc.exe" "%~dp0Files\antivirus_FILES_exe\!_computer!.exe">NUL
IF EXIST "\\!_computer!\c$\Program Files (x86)\Symantec AntiVirus\12.1.2015.2015.105\Bin\Smc.exe" COPY "\\!_computer!\c$\Program Files (x86)\Symantec AntiVirus\12.1.2015.2015.105\Bin\Smc.exe" "%~dp0Files\antivirus_FILES_exe\!_computer!.exe">NUL
IF EXIST "\\!_computer!\c$\Program Files (x86)\Symantec AntiVirus\12.1.2015.2015.105\Bin64\Smc.exe" COPY "\\!_computer!\c$\Program Files (x86)\Symantec AntiVirus\12.1.2015.2015.105\Bin64\Smc.exe" "%~dp0Files\antivirus_FILES_exe\!_computer!.exe">NUL
IF EXIST "\\!_computer!\c$\Program Files (x86)\Symantec\Symantec Endpoint Protection\12.1.3001.165.105\Bin64\Smc.exe" COPY "\\!_computer!\c$\Program Files (x86)\Symantec\Symantec Endpoint Protection\12.1.3001.165.105\Bin64\Smc.exe" "%~dp0Files\antivirus_FILES_exe\!_computer!.exe">NUL

IF NOT EXIST "%~dp0Files\antivirus_FILES_exe\!_computer!.exe" (ECHO !_computer!>>"%~dp0Files\antivirus_not_found.log") ELSE (
FOR /F %%A IN ("Files\antivirus_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 2440632 SET _antivirus_ver=11.0.4202.48
FOR /F %%A IN ("Files\antivirus_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 2440120 SET _antivirus_ver=11.0.4010.14
FOR /F %%A IN ("Files\antivirus_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 1832072 SET _antivirus_ver=11.0.6100.463
FOR /F %%A IN ("Files\antivirus_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 1885488 SET _antivirus_ver=11.0.6100.480
FOR /F %%A IN ("Files\antivirus_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 2594816 SET _antivirus_ver=12.1.1000.157
FOR /F %%A IN ("Files\antivirus_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 1785792 SET _antivirus_ver=12.1.2015.2015.105
FOR /F %%A IN ("Files\antivirus_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 2294112 SET _antivirus_ver=12.1.2015.2015.105
FOR /F %%A IN ("Files\antivirus_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 2825104 SET _antivirus_ver=12.1.3001.165.105
FOR /F %%A IN ("Files\antivirus_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 2316184 SET _antivirus_ver=12.1.3001.165.105

ECHO Antivirus version is !_antivirus_ver!
ECHO !_computer!>>Files\!_antivirus_ver!.log
)
IF "!_upgrade_antivirus!" == "yes" (
ECHO.
IF EXIST cred.txt (
::schtask user ; Values username
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "cred_username" "cred.txt"') DO (SET _cred_username=%%A)
::schtask password ; Values password
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "cred_password" "cred.txt"') DO (SET _cred_password=%%A)
)ELSE (ECHO Cred not found asking
SET /p _cred_username=Domain/user ? 
SET /p _cred_password=Password ? 
)


IF "!_antivirus_ver!" NEQ "!_antivirus_ver_current!" ECHO Copying files needed for installation.
IF "!_antivirus_ver!" NEQ "!_antivirus_ver_current!" XCOPY "..\Script_software\sep_!_Type!\*" "\\!_computer!\c$\temp\sep_!_Type!" /S /I /D /Y
IF "!_antivirus_ver!" NEQ "!_antivirus_ver_current!" ECHO Setting up schtasks
IF "!_antivirus_ver!" NEQ "!_antivirus_ver_current!" IF EXIST "\\!_computer!\c$\temp\sep_!_Type!\*.*" "SCHTASKS /Create /S !_computer! /RU !_cred_username! /RP !_cred_password! /TN Run_once_sep /TR "c:\temp\sep_!_Type!\setup.exe" /SC ONCE /ST 00:05 /RL HIGHEST /F>>Files\SCHTASKS.log
IF "!_antivirus_ver!" NEQ "!_antivirus_ver_current!" ECHO Running schtasks
IF "!_antivirus_ver!" NEQ "!_antivirus_ver_current!" IF EXIST "\\!_computer!\c$\temp\sep_!_Type!\*.*" SCHTASKS /run /S !_computer! /TN Run_once_sep

REM IF "!_antivirus_ver!" == "NA" ECHO Setting up schtasks
REM IF "!_antivirus_ver!" == "NA" SCHTASKS /Create /S !_computer! /RU !_cred_username! /RP !_cred_password! /TN Run_once /TR "c:\temp\sep_!_Type!\silent.bat" /SC ONCE /ST 00:05 /RL HIGHEST /F>>Files\SCHTASKS.log
REM IF "!_antivirus_ver!" == "NA" ECHO Running schtasks
REM IF "!_antivirus_ver!" == "NA" SCHTASKS /run /S !_computer! /TN Run_once
)
IF "!_antivirus_ver!" EQU "!_antivirus_ver_current!" ECHO !_computer!>>Files\SEP_current.log
IF "!_antivirus_ver!" NEQ "!_antivirus_ver_current!" ECHO !_computer!>>Files\SEP_NOT_current.log
IF EXIST "%~dp0Files\antivirus_FILES_exe\!_computer!.exe" DEL /Q "%~dp0Files\antivirus_FILES_exe\!_computer!.exe"
IF EXIST "\\!_computer!\c$\temp\restart_sep\*.*" RD /S /Q "\\!_computer!\c$\temp\restart_sep"& ECHO Cleaning up...
ECHO.
SET _header=!_header!,Antivirus_ver
SET _result=!_result! !_antivirus_ver!
SET _separator=***** End checking Antivirus ver on !_computer! *******************************
ECHO !_separator:~0,70!
ECHO.
)


REM Check Legato
IF !_check_legato_ver!==yes (
SET /A _colspan+=1
SET _separator=***** Checking legato ver on !_computer! *******************************
ECHO !_separator:~0,70!
SET _legato_ver=NA
SET _legato_ver_current=7.6.5.3_Build_1195
ECHO.
IF NOT EXIST "%~dp0Files\legato_FILES_exe" MD "%~dp0Files\legato_FILES_exe"
IF EXIST "\\!_computer!\c$\Program Files (x86)\Legato\nsr\bin\winworkr.exe" COPY "\\!_computer!\c$\Program Files (x86)\Legato\nsr\bin\winworkr.exe" "%~dp0Files\legato_FILES_exe\!_computer!.exe"
IF EXIST "\\!_computer!\c$\Program Files\Legato\nsr\bin\winworkr.exe" COPY "\\!_computer!\c$\Program Files\Legato\nsr\bin\winworkr.exe" "%~dp0Files\legato_FILES_exe\!_computer!.exe"

IF NOT EXIST "%~dp0Files\legato_FILES_exe\!_computer!.exe" (ECHO !_computer!>>"%~dp0Files\legato_not_found.log") ELSE (
FOR /F %%A IN ("Files\legato_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 722944 SET _legato_ver=7.6.5.3_Build_1195
FOR /F %%A IN ("Files\legato_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 565248 SET _legato_ver=7.6.5.3_Build_1195
FOR /F %%A IN ("Files\legato_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 686080 SET _legato_ver=7.6.2.7_Build_697
FOR /F %%A IN ("Files\legato_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 544768 SET _legato_ver=7.6.2.7_Build_697
FOR /F %%A IN ("Files\legato_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 685568 SET _legato_ver=7.6.2.1_Build_638
FOR /F %%A IN ("Files\legato_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 646144 SET _legato_ver=7.6.1.3_Build_446
FOR /F %%A IN ("Files\legato_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 512000 SET _legato_ver=7.6.1.3_Build_446
FOR /F %%A IN ("Files\legato_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 615424 SET _legato_ver=7.5.3.5_Build_573 
FOR /F %%A IN ("Files\legato_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 491520 SET _legato_ver=7.5.3.5_Build_573
FOR /F %%A IN ("Files\legato_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 434176 SET _legato_ver=7.4.4.0_Build_634
FOR /F %%A IN ("Files\legato_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 409600 SET _legato_ver=7.3.3.0_Build_510
FOR /F %%A IN ("Files\legato_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 380986 SET _legato_ver=7.2.2.0_Build_422


REM FOR /F %%A IN ("Files\legato_FILES_exe\!_computer!.exe") DO IF "!_legato_ver!" == "NA" ECHO Filesize %%~zA&ECHO !_computer!>>"Files\legato_na.txt"
IF "!_legato_ver!" == "NA" PAUSE
ECHO Legato_ver=!_legato_ver!

IF "!_legato_ver!" EQU "!_legato_ver_current!" ECHO !_computer!>>Files\Legato_current.log
IF "!_legato_ver!" NEQ "!_legato_ver_current!" ECHO !_computer!>>Files\Legato_NOT_current.log
)

IF "!_upgrade_legato!" == "yes" (
IF EXIST cred.txt (
::schtask user ; Values username
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "cred_username" "cred.txt"') DO (SET _cred_username=%%A)
::schtask password ; Values password
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "cred_password" "cred.txt"') DO (SET _cred_password=%%A)
)ELSE (ECHO Cred not found asking
SET /p _cred_username=Domain/user ? 
SET /p _cred_password=Password ? 
)

IF "!_legato_ver!" NEQ "!_legato_ver_current!" ECHO Not current copying files "..\Script_software\legato_!_Type!\*"
IF "!_legato_ver!" NEQ "!_legato_ver_current!" XCOPY "..\Script_software\legato_!_Type!\*.*" "\\!_computer!\c$\temp\legato_!_Type!" /S /I /D
IF "!_legato_ver!" == "NA" IF EXIST "\\!_computer!\c$\temp\legato_!_Type!\*.*" ECHO Setting up schtasks
IF "!_legato_ver!" == "NA" IF EXIST "\\!_computer!\c$\temp\legato_!_Type!\*.*" SCHTASKS /Create /S !_computer! /RU !_cred_username! /RP !_cred_password! /TN Run_once_legato /TR "c:\temp\legato_!_Type!\silent.bat" /SC ONCE /ST 12:50 /SD 2014/01/28 /RL HIGHEST /F>>Files\SCHTASKS.log
REM IF "!_legato_ver!" == "NA" ECHO Running schtasks
REM IF "!_legato_ver!" == "NA" IF EXIST "\\!_computer!\c$\temp\legato_!_Type!\*.*" SCHTASKS /run /S !_computer! /TN Run_once_legato

IF "!_legato_ver!" NEQ "!_legato_ver_current!" IF EXIST "\\!_computer!\c$\temp\legato_!_Type!\*.*" ECHO Setting up schtasks
IF "!_legato_ver!" NEQ "!_legato_ver_current!" IF EXIST "\\!_computer!\c$\temp\legato_!_Type!\*.*" SCHTASKS /Create /S !_computer! /RU !_cred_username! /RP !_cred_password! /TN Run_once_legato /TR "c:\temp\legato_!_Type!\silent.bat" /SC ONCE /ST 12:50 /SD 2014/01/28 /RL HIGHEST /F>>Files\SCHTASKS.log
IF "!_legato_ver!" NEQ "!_legato_ver_current!" IF EXIST "\\!_computer!\c$\temp\legato_!_Type!\*.*" ECHO Running schtasks
REM IF "!_legato_ver!" NEQ "!_legato_ver_current!" IF EXIST "\\!_computer!\c$\temp\legato_!_Type!\*.*" SCHTASKS /run /S !_computer! /TN Run_once_legato
)

REM IF EXIST "\\!_computer!\c$\Program Files (x86)\*.*" IF EXIST NOT"\\!_computer!\c$\Program Files (x86)\Legato\*.*" SET _legato_ver=Not_found
REM IF EXIST "\\!_computer!\c$\Program Files\*.*" IF EXIST NOT "\\!_computer!\c$\Program Files\Legato\*.*" SET _legato_ver=Not_found
REM IF "!_legato_ver!" == "NA" XCOPY fix_nsr.bat "\\!_computer!\c$\TEMP\fix_nsr.bat" /Y
IF EXIST "%~dp0Files\legato_FILES_exe\!_computer!.exe" DEL /Q "%~dp0Files\legato_FILES_exe\!_computer!.exe"

ECHO.
SET _header=!_header!,Legato_ver
SET _result=!_result! !_legato_ver!
SET _separator=***** End checking legato ver on !_computer! *******************************
ECHO !_separator:~0,70!
ECHO.
)



REM Check loggedon
IF !_check_loggedon!==yes (
SET /A _colspan+=1
SET _separator=***** Logged on !_computer! *******************************
ECHO !_separator:~0,70!
ECHO.

IF NOT EXIST "%~dp0Files\psloggedon" MD "%~dp0Files\psloggedon"
"!_psloggedon!" \\!_computer!>"%~dp0Files\psloggedon\!_computer!_loggedon.txt"

ECHO.
REM SET _header=!_header!,Loggedon
REM SET _result=!_result! !_bbwin_ver!
SET _separator=***** End logged on !_computer! *******************************
ECHO !_separator:~0,70!
ECHO.
)


REM Check Scom
IF !_check_scom_ver!==yes (
SET /A _colspan+=1
SET _separator=***** Checking scom ver on !_computer! *******************************
ECHO !_separator:~0,70!
SET _scom_ver=NA
SET _scom_ver_current=7.1.10184.0
ECHO.

IF NOT EXIST "%~dp0Files\scom_FILES_exe" MD "%~dp0Files\scom_FILES_exe"

IF EXIST "\\!_computer!\c$\Program Files (x86)\System Center Operations Manager 2007\HealthService.exe" COPY "\\!_computer!\c$\Program Files (x86)\System Center Operations Manager 2007\HealthService.exe" "%~dp0Files\scom_FILES_exe\!_computer!.exe"
IF EXIST "\\!_computer!\c$\Program Files\System Center Operations Manager 2007\HealthService.exe" COPY "\\!_computer!\c$\Program Files\System Center Operations Manager 2007\HealthService.exe" "%~dp0Files\scom_FILES_exe\!_computer!.exe"
IF EXIST "\\!_computer!\c$\Program Files (x86)\Microsoft Monitoring Agent\Agent\HealthService.exe" COPY "\\!_computer!\c$\Program Files (x86)\Microsoft Monitoring Agent\Agent\HealthService.exe" "%~dp0Files\scom_FILES_exe\!_computer!.exe"
IF EXIST "\\!_computer!\c$\Program Files\Microsoft Monitoring Agent\Agent\HealthService.exe" COPY "\\!_computer!\c$\Program Files\Microsoft Monitoring Agent\Agent\HealthService.exe" "%~dp0Files\scom_FILES_exe\!_computer!.exe"

IF NOT EXIST "%~dp0Files\scom_FILES_exe\!_computer!.exe" (ECHO !_computer!>>"%~dp0Files\scom_not_found.log") ELSE (
FOR /F %%A IN ("Files\scom_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 30592 SET _scom_ver=6.1.7221.0
FOR /F %%A IN ("Files\scom_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 27008  SET _scom_ver=6.1.7221.0
FOR /F %%A IN ("Files\scom_FILES_exe\!_computer!.exe") DO IF %%~zA EQU 25272  SET _scom_ver=7.1.10184.0
ECHO scom_ver=!_scom_ver!
ECHO !_computer!>>"%~dp0Files\scom_ok.log"
)
IF EXIST "%~dp0Files\scom_FILES_exe\!_computer!.exe" DEL /Q "%~dp0Files\scom_FILES_exe\!_computer!.exe"

IF "!_upgrade_scom!" == "yes" (
IF EXIST cred.txt (
::schtask user ; Values username
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "cred_username" "cred.txt"') DO (SET _cred_username=%%A)
::schtask password ; Values password
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "cred_password" "cred.txt"') DO (SET _cred_password=%%A)
)ELSE (ECHO Cred not found asking
SET /p _cred_username=Domain/user ? 
SET /p _cred_password=Password ? 
)

IF "!_scom_ver!" NEQ "!_scom_ver_current!" XCOPY "..\Script_software\scom_!_Type!\*" "\\!_computer!\c$\temp\scom_!_Type!" /S /I /D /Y
IF "!_scom_ver!" == "NA" SCHTASKS /Create /S !_computer! /RU !_cred_username! /RP !_cred_password! /TN Run_install_scom /TR "c:\temp\scom_!_Type!\silent.bat" /SC ONCE /ST 00:05 /RL HIGHEST /F>>Files\SCHTASKS.log
IF "!_scom_ver!" == "NA" SCHTASKS /run /S !_computer! /TN Run_install_scom
)
REM uninstall SCOM 
IF EXIST cred.txt (
::schtask user ; Values username
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "cred_username" "cred.txt"') DO (SET _cred_username=%%A)
::schtask password ; Values password
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "cred_password" "cred.txt"') DO (SET _cred_password=%%A)
)ELSE (ECHO Cred not found asking
SET /p _cred_username=Domain/user ? 
SET /p _cred_password=Password ? 
)

IF "!_scom_ver!" EQU "!_scom_ver_current!" IF EXIST "\\!_computer!\c$\temp\scom_!_Type!" ECHO Deleting scom installation files
IF "!_scom_ver!" EQU "!_scom_ver_current!" IF EXIST "\\!_computer!\c$\temp\scom_!_Type!" RD /S /Q "\\!_computer!\c$\temp\scom_!_Type!"
REM IF "!_scom_ver!" EQU "!_scom_ver_current!" ECHO Uninstalling SCOM2007R2
REM IF "!_scom_ver!" EQU "!_scom_ver_current!" XCOPY "..\Script_software\uninstall_scom_2007_r2.bat" "\\!_computer!\c$\temp" /S /I /D /Y
REM IF "!_scom_ver!" EQU "!_scom_ver_current!" ECHO Creating schtask on !_computer!
REM IF "!_scom_ver!" EQU "!_scom_ver_current!" SCHTASKS /Create /S !_computer! /RU !_cred_username! /RP !_cred_password! /TN Run_uninstall_scom /TR "c:\temp\uninstall_scom_2007_r2.bat" /SC ONCE /ST 13:30 /SD 2014/02/18 /RL HIGHEST /F>>Files\SCHTASKS.log
REM IF "!_scom_ver!" EQU "!_scom_ver_current!" ECHO Running schtask on !_computer!
REM IF "!_scom_ver!" EQU "!_scom_ver_current!" SCHTASKS /run /S !_computer! /TN Run_uninstall_scom


ECHO.
SET _header=!_header!,scom_ver
SET _result=!_result! !_scom_ver!
SET _separator=***** End checking scom ver on !_computer! *******************************
ECHO !_separator:~0,70!
ECHO.
)



REM Check ipconfig
IF !_run_ipconfig!==yes (
	SET /A _colspan+=1
	SET _separator=***** Running ipconfig on !_computer! *******************************
	ECHO !_separator:~0,70!
	ECHO.
	IF NOT EXIST "%~dp0Files\ipconfig_FILES" MD "%~dp0Files\ipconfig_FILES"
	IF NOT EXIST "%~dp0Files\ipconfig_FILES\!_computer!_ipconfig.txt" (
		!_psexec! \\!_computer! ipconfig /all>Files\ipconfig_FILES\!_computer!_ipconfig.txt
		) ELSE (ECHO Ipconfig file exist)
		ECHO.
		SET _separator=***** End running ipconfig on !_computer! *******************************
		ECHO !_separator:~0,70!
		ECHO.
	)



REM Check Profiles
IF !_check_profiles!==yes (
SET /A _colspan+=1
SET _separator=***** Checking profiles on !_computer! c$ *******************************
ECHO !_separator:~0,70!
SET _profiles=NA
ECHO.
IF NOT EXIST "%~dp0Files\Profiles" MD "%~dp0Files\Profiles"
IF EXIST "\\!_computer!.!_dnssuffix!\c$\users\*.*" DIR /B "\\!_computer!.!_dnssuffix!\c$\users\*.*"|FIND /I /V "Administrator"|FIND /I /V "Public">Files\Profiles\!_computer!_profiles.txt
IF EXIST "\\!_computer!.!_dnssuffix!\c$\Documents and Settings\*.*" DIR /B "\\!_computer!.!_dnssuffix!\c$\Documents and Settings\*.*"|FIND /I /V "Administrator"|FIND /I /V "Public">Files\Profiles\!_computer!_profiles.txt
ECHO Profiles Done
SET _profiles=Done
ECHO.
SET _header=!_header!,Profiles
SET _result=!_result! !_profiles!
SET _separator=***** End checking profiles on !_computer! c$ *******************************
ECHO !_separator:~0,70!
ECHO.
)


REM Check Access
IF !_check_access!==yes (
SET /A _colspan+=1
SET _separator=***** Checking access to !_computer! c$ ***************************************
ECHO !_separator:~0,70!
SET _access=NA
ECHO.
IF EXIST "\\!_computer!.!_dnssuffix!\c$\*.*" (ECHO Access to !_computer!&SET _access=yes) ELSE (ECHO No Access to !_computer!&SET _access=no)
IF !_access! == no ECHO NO ACCESS to !_computer!\C$ !DATE! !TIME!>>NO_ACCESS.txt
ECHO.
SET _header=!_header!,Access
SET _result=!_result! !_access!
SET _separator=***** End checking access to !_computer! c$ *******************************
ECHO !_separator:~0,70!
ECHO.
)




REM ilo Check
IF !_check_ilo!==yes (
SET /A _colspan+=1
SET _iloip=NA

IF "!_Manufacturer!" == "HP" (
SET _separator=***** Getting Ilo cfg on !_computer! *******************************
ECHO !_separator:~0,70!
ECHO.
IF NOT EXIST "%~dp0Files\Ilo_FILES" MD "%~dp0Files\Ilo_FILES"
ECHO Manufacturer = HP
IF EXIST "c:\Program Files\HP\hponcfg\hponcfg.exe" ECHO Hponcfg found Ok to get config

IF NOT EXIST "%~dp0Files\Ilo_FILES\!_computer!_Ilo.xml" (
IF EXIST !_psexec! !_psexec! \\!_computer! "c:\Program Files\HP\hponcfg\hponcfg.exe" /w c:\temp\ilo.xml
COPY "\\!_computer!\c$\temp\ilo.xml" "%~dp0Files\Ilo_FILES\!_computer!_ilo.xml"
DEL /Q \\!_computer!\c$\temp\ilo.xml
) ELSE (
ECHO Ilo cfg file exist
)
FOR /F "tokens=4 delims=/ " %%A IN ('FIND /I "<IP_ADDRESS" "Files\Ilo_FILES\!_computer!_ilo.xml"') DO (SET _iloip=%%A)
SET _iloip=!_iloip:"=!
ECHO iloip = !_iloip!
)

ECHO.
SET _header=!_header!,iloip
SET _result=!_result! !_iloip!
SET _separator=***** End getting Ilo cfg on !_computer! *******************************
ECHO !_separator:~0,70!
ECHO.
)




REM Ending is up
)

REM TODO
REM services
REM sc \\snz4mdt7851 query BBWin|FIND /I "state"
REM BBWin
REM SepMasterService
REM SmcService
REM TermService


SET _separator=***** Creating output *********************************************************
ECHO !_separator:~0,70!
ECHO.
SET lampyellow=images\lamp-on.png
SET lampgrey=images\lamp-off.png
SET _lamp_ok=images\green_ok.png
SET _lamp_nok=images\red_no.png



ECHO !_header!
ECHO !_result!
ECHO !_result!>>"Files\Result.log"
ECHO.


REM Create Top
SET _topname=Files\top.html
ECHO ^<html^> >%_topname%
ECHO   ^<head^> >>%_topname%
ECHO	^<title^>%title% Verify Servers^</title^> >>%_topname%
REM ECHO	^<meta http-equiv="refresh" content="30"^> >>%_topname%
ECHO	^<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"^>^<style type="text/css"^> >>%_topname%
ECHO body { >>%_topname%
ECHO 	background-color: #4682b4; >>%_topname%
ECHO } >>%_topname%
ECHO ^</style^>^</head^> >>%_topname%
ECHO   ^<body background="#95bbf8"^> >>%_topname%
ECHO     ^<table border="1" bgcolor="#95bbf8"^> >>%_topname%
ECHO        ^<tr^> >>%_topname%
ECHO         ^<td colspan="!_colspan!"^>^<div align="center"^>^<a href="Files\online.log"^>Online ^</a^>Computers %title% Filetime=%filetime% ^<a href="Files\offline.log"^> Offline^</a^>^</div^>^</td^> >>%_topname%
ECHO       ^</tr^> >>%_topname%
ECHO        ^<tr^> >>%_topname%
ECHO         ^<td colspan="!_colspan!"^>Start %date% %time%^</td^> >>%_topname%
ECHO       ^</tr^> >>%_topname%
ECHO        ^<tr^> >>%_topname%
ECHO         ^<td colspan="!_colspan!"^>LEGEND: ^<img src="!lampyellow!" border="0"^>=ONLINE ^<img src="!lampgrey!" border="0"^>=OFFLINE^</td^> >>%_topname%
ECHO       ^</tr^> >>%_topname%
ECHO       ^<tr^> >>%_topname%
REM 1
ECHO        ^<td width="20"^> Online ^</td^> >>%_topname%
REM 2
ECHO        ^<td width="150"^> Computername ^</td^> >>%_topname%
REM 3
IF !_check_systeminfo! == yes ECHO        ^<td width="400"^> OSName ^</td^> >>%_topname%
REM 4
IF !_check_systeminfo! == yes ECHO        ^<td width="250"^> OSVersion ^</td^> >>%_topname%
REM 5
IF !_check_systeminfo! == yes ECHO        ^<td width="100"^> Manufacturer ^</td^> >>%_topname%
REM 6
IF !_check_systeminfo! == yes ECHO        ^<td width="180"^> Model ^</td^> >>%_topname%
REM 7
IF !_check_systeminfo! == yes ECHO        ^<td width="50"^> Type ^</td^> >>%_topname%
REM 8
IF !_check_systeminfo! == yes ECHO        ^<td width="130"^> PageFileLocation ^</td^> >>%_topname%
REM 9
IF !_check_antivirus_ver! == yes ECHO        ^<td width="200"^> Sep ^</td^> >>%_topname%
REM 10
IF !_check_bbwin_ver! == yes ECHO        ^<td width="200"^> BBwin ^</td^> >>%_topname%
REM 11
IF !_check_legato_ver! == yes ECHO        ^<td width="200"^> Legato^</td^> >>%_topname%
REM 12
IF !_check_scom_ver! == yes ECHO        ^<td width="200"^> Scom ^</td^> >>%_topname%
REM 13
IF !_check_access! == yes ECHO        ^<td width="200"^> Access ^</td^> >>%_topname%
REM 14
IF !_check_loggedon! == yes ECHO        ^<td width="200"^> Loggedon ^</td^> >>%_topname%
REM 15
IF !_check_profiles! == yes ECHO        ^<td width="200"^> Profiles ^</td^> >>%_topname%
REM 16
IF !_run_ipconfig! == yes ECHO        ^<td width="200"^> Ipconfig ^</td^> >>%_topname%
REM 17
IF !_check_net! == yes ECHO        ^<td width="200"^> IPadress ^</td^> >>%_topname%
REM 18
IF !_check_net! == yes ECHO        ^<td width="200"^> Network ^</td^> >>%_topname%
REM 19
IF !_check_ilo! == yes ECHO        ^<td width="200"^> IloIP ^</td^> >>%_topname%
REM 20
IF !_check_antivirus_date! == yes ECHO        ^<td width="200"^> Sep date ^</td^> >>%_topname%
ECHO       ^</tr^> >>%_topname%


REM Create Table
SET _table=Files\table.html
 ECHO       ^<tr^> >>%_table%
 REM 1
 IF !_mode! == up ECHO         ^<td width="20"^>^<a href="files\%%i_dir.txt"^>^<img src="!lampyellow!" alt="!modell!" border="0"^>^</a^>^</td^> >>%_table%
 IF !_mode! == down ECHO         ^<td width="20"^>^<a href="files\%%i_dir.txt"^>^<img src="!lampgrey!" alt="!modell!" border="0"^>^</a^>^</td^> >>%_table%
 REM 2
 IF EXIST systeminfo\!_computer!.txt (ECHO         ^<td width="150"^>^<a href="systeminfo\!_computer!.txt"^> !_computer!^</a^>^</td^> >>%_table%) ELSE (ECHO       ^<td width="150"^> !_computer! ^</td^> >>%_table%)
 REM 3 
 IF !_check_systeminfo!==yes IF EXIST "Files\!_OSName!.log" (ECHO         ^<td width="400"^>^<a href="Files\!_OSName!.log"^> !_OSName!^</a^>^</td^> >>%_table%) ELSE (ECHO       ^<td width="400"^> !_OSName! ^</td^> >>%_table%)
 REM 4
 IF !_check_systeminfo!==yes ECHO         ^<td width="250"^> !_OSVersion! ^</td^> >>%_table%
 REM 5
 IF !_check_systeminfo!==yes IF EXIST "Files\!_Manufacturer!.log" (ECHO         ^<td width="100"^>^<a href="Files\!_Manufacturer!.log"^> !_Manufacturer!^</a^>^</td^> >>%_table%) ELSE (ECHO       ^<td width="100"^> !_Manufacturer! ^</td^> >>%_table%)
 REM 6
 IF !_check_systeminfo!==yes IF EXIST "Files\!_Model!.log" (ECHO         ^<td width="180"^>^<a href="Files\!_Model!.log"^> !_Model!^</a^>^</td^> >>%_table%) ELSE (ECHO       ^<td width="180"^> !_Model! ^</td^> >>%_table%)
 REM 7
 IF !_check_systeminfo!==yes IF EXIST "Files\!_Type!.log" (ECHO         ^<td width="50"^>^<a href="Files\!_Type!.log"^> !_Type!^</a^>^</td^> >>%_table%) ELSE (ECHO       ^<td width="50"^> !_Type! ^</td^> >>%_table%)
 REM 8
 IF !_check_systeminfo!==yes ECHO       ^<td width="130"^> !_PageFileLocation! ^</td^> >>%_table%
 REM 9
 IF !_check_antivirus_ver! == yes IF "!_antivirus_ver!"=="!_antivirus_ver_current!" (ECHO       ^<td width="200"^>^<img src="!_lamp_ok!" height="20" width="20" border="0"^>^</td^> >>%_table%) ELSE (ECHO       ^<td width="200"^>^<img src="!_lamp_nok!" height="20" width="20" border="0"^> !_antivirus_ver! ^</td^> >>%_table%)
 REM 10
 IF !_check_bbwin_ver! == yes IF "!_bbwin_ver!"=="!_bbwin_ver_current!" (ECHO       ^<td width="200"^>^<img src="!_lamp_ok!" height="20" width="20" border="0"^>^</td^> >>%_table%) ELSE (ECHO       ^<td width="200"^>^<img src="!_lamp_nok!" height="20" width="20" border="0"^> !_bbwin_ver! ^</td^> >>%_table%)
 REM 11
 IF !_check_legato_ver! == yes IF "!_legato_ver!"=="!_legato_ver_current!" (ECHO       ^<td width="200"^>^<img src="!_lamp_ok!" height="20" width="20" border="0"^>^</td^> >>%_table%) ELSE (ECHO       ^<td width="200"^>^<img src="!_lamp_nok!" height="20" width="20" border="0"^> !_legato_ver! ^</td^> >>%_table%)
 REM 12
 IF !_check_scom_ver! == yes IF "!_scom_ver!"=="!_scom_ver_current!" (ECHO       ^<td width="200"^>^<img src="!_lamp_ok!" height="20" width="20" border="0"^>^</td^> >>%_table%) ELSE (ECHO       ^<td width="200"^>^<img src="!_lamp_nok!" height="20" width="20" border="0"^> !_scom_ver! ^</td^> >>%_table%)
 REM 13
 IF !_check_access! == yes IF "!_access!"=="yes" (ECHO       ^<td width="200"^>^<img src="!_lamp_ok!" height="20" width="20" border="0"^>^</td^> >>%_table%) ELSE (ECHO       ^<td width="200"^>^<img src="!_lamp_nok!" height="20" width="20" border="0"^>^</td^> >>%_table%) 
 REM 14
 IF !_check_loggedon! == yes ECHO        ^<td width="200"^>^<a href="psloggedon\!_computer!_loggedon.txt"^> Loggedon^</a^>^</td^> >>%_table%
 REM 15
 IF !_check_profiles! == yes ECHO         ^<td width="200"^>^<a href="Profiles\!_computer!_profiles.txt"^> Profiles^</a^>^</td^> >>%_table%
 REM 16
 IF !_run_ipconfig! == yes IF EXIST Files\ipconfig_FILES\!_computer!_ipconfig.txt (ECHO         ^<td width="200"^>^<a href="Files\ipconfig_FILES\!_computer!_ipconfig.txt"^> Ipconfig^</a^>^</td^> >>%_table%) ELSE (ECHO       ^<td width="200"^> NA ^</td^> >>%_table%)
 REM 17
 IF !_check_net! == yes ECHO        ^<td width="200"^> !_A!.!_B!.!_C!.!_D! ^</td^> >>%_table%
 REM 18
 IF !_check_net! == yes IF EXIST "Files\!_network!.log" (ECHO         ^<td width="200"^>^<a href="Files\!_network!.log"^> !_network!^</a^>^</td^> >>%_table%) ELSE (ECHO       ^<td width="200"^> !_network! ^</td^> >>%_table%)
 REM 19
 IF !_check_ilo! == yes ECHO        ^<td width="200"^> !_iloip! ^</td^> >>%_table%
 REM 20
 IF !_check_antivirus_date! == yes ECHO        ^<td width="200"^> !_antivirus_date! ^</td^> >>%_table%
 ECHO       ^</tr^> >>%_table%
 )

REM Count HP/VM
SET _count_hp=0
SET _count_vm=0
IF EXIST "Files\HP.log" FOR /F "usebackq" %%i IN ("Files\HP.log") DO (SET /A _count_hp+=1)
IF EXIST "Files\VMware Virtual Platform.log" FOR /F "usebackq" %%i IN ("Files\VMware Virtual Platform.log") DO (SET /A _count_vm+=1)
REM ECHO HP=!_count_hp!
REM ECHO VM=!_count_vm!
SET /A _total_computers=!_count_hp!+!_count_vm!
REM ECHO !_total_computers!
IF !_check_systeminfo!==yes SET /A _precent=(!_count_vm!*100)/!_total_computers!
REM ECHO SET /A _precent=!_count_vm!/!_total_computers!
REM ECHO !_precent!%%
REM PAUSE

 
REM Create End
SET _endname=Files\end.html
ECHO        ^<tr^> >%_endname%
ECHO         ^<td colspan="!_colspan!"^>Stop %date% %time%^</td^> >>%_endname%
ECHO       ^</tr^> >>%_endname%
ECHO        ^<tr^>>>%_endname%
ECHO         ^<td colspan="!_colspan!"^>^<div align="center"^>Script created and maintained by ^<a href='mailto:dennis.knutsson@qbranch.se^&subject^=Verify_server_script'^>Dennis Knutsson^</a^> (DEKN) ^</div^>^</td^>>>%_endname%
ECHO       ^</tr^>>>%_endname%
IF !_check_systeminfo!==yes ECHO        ^<tr^>>>%_endname%
IF !_check_systeminfo!==yes ECHO         ^<td colspan="!_colspan!"^>^<div align="center"^>HP=!_count_hp! VM=!_count_vm! Precent=!_precent!%%^</div^>^</td^>>>%_endname%
IF !_check_systeminfo!==yes ECHO       ^</tr^>>>%_endname%
ECHO        ^<tr^>>>%_endname%
ECHO         ^<td colspan="!_colspan!"^>^<div align="center"^>Todo? Please mail me suggestions ^</div^>^</td^>>>%_endname%
ECHO       ^</tr^>>>%_endname%
ECHO      ^</table^>>>%_endname%
ECHO ^</body^>>>%_endname%
ECHO ^</html^>>>%_endname%

REM COPY "top.html" +"table.html" +"end.html" "index.html" >NUL
COPY "Files\top.html" +"Files\table.html" +"Files\end.html" "index.html" >NUL

SET _separator=***** End script *************************************************************
ECHO !_separator:~0,70!
ENDLOCAL
:EOF
IF EXIST pause.txt PAUSE

REM todo
REM Dameware uninstall C:\WINDOWS\SYSTEM32\DWRCS.EXE 
