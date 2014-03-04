@ECHO OFF
IF EXIST *.html DEL /Q *.html
IF EXIST FILES\*.html DEL /Q FILES\*.html
IF EXIST *.log DEL /Q *.log
IF EXIST FILES\*.log DEL /Q FILES\*.log
SETLOCAL ENABLEDELAYEDEXPANSION
IF "%Computername%"=="SNJMP2A4449" SET _list=computersz2.txt
IF "%Computername%"=="SNJMP2B4452" SET _list=computersz2.txt
IF "%Computername%"=="SNJMP3A4450" SET _list=computersz3.txt
IF "%Computername%"=="SNJMP3B4453" SET _list=computersz3.txt
IF "%Computername%"=="SNJMP4A4453" SET _list=computersz4.txt
IF "%Computername%"=="SNJMP4B4454" SET _list=computersz4.txt

SET _batchtoloop=Verify_server.bat
SET _counttotal=0

FOR /F %%i IN (%_list%) DO (SET /A _counttotal+=1)
ECHO In list !_counttotal!
SET _countleft=!_counttotal!
TITLE %TIME:~0,-3% - !TIME:~0,-3! Progress left !_countleft!/!_counttotal!

IF NOT EXIST %_list% (ECHO %_batchtoloop% Not Found&PAUSE&EXIT)
IF NOT EXIST %_batchtoloop% (ECHO %_batchtoloop% Not Found&PAUSE&EXIT)
FOR /F %%i IN (%_list%) DO (
TITLE %TIME:~0,-3% - !TIME:~0,-3! Progress left !_countleft!/!_counttotal! Doing %%i
ECHO %%i Start !TIME!>>Files\Timed_result.log
CALL "%_batchtoloop%" %%i
SET /A _countleft-=1
ECHO %%i Stop !TIME!>>Files\Timed_result.log
)
ENDLOCAL
PAUSE
