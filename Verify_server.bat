@ECHO OFF
REM ======================================================================
REM
REM NAME: Verify_server.bat 
REM
REM AUTHOR  : Dennis Knutsson Webland AB 
REM AUTHOR  : dennis@webland.se
REM AUTHOR  : 0701-801966
REM Created : 2016-09-09
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
::refresh html 30sec ; Values yes/no


SET SCRIPTDIR=%~dp0
SET _NEEDS_attentionfile="%~dp0Files\NEEDS_attention.log"
SET _colspan=3
SET _ok=^<img alt="green_ok.png" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAB3RJTUUH3gsFCCM1Quf0JgAAAAd0RVh0QXV0aG9yAKmuzEgAAAAMdEVYdERlc2NyaXB0aW9uABMJISMAAAAKdEVYdENvcHlyaWdodACsD8w6AAAADnRFWHRDcmVhdGlvbiB0aW1lADX3DwkAAAAJdEVYdFNvZnR3YXJlAF1w/zoAAAALdEVYdERpc2NsYWltZXIAt8C0jwAAAAh0RVh0V2FybmluZwDAG+aHAAAAB3RFWHRTb3VyY2UA9f+D6wAAAAh0RVh0Q29tbWVudAD2zJa/AAAABnRFWHRUaXRsZQCo7tInAAADX0lEQVQ4ja2UbUxTVxjH/+fetrcvdlJsFRRdBa2iQozTGHTDZBbTkIi6Ls4XIiSLyjITychk0SVTMGr2YZGNqWyJ0oEgoG6gwRgcKqCWoXOIYKTIi0IRqLRie8vtyz1+wkQCvu6fnC/Pec7vw/Oc/59QSvF/inmfx27ezXa7urUvFSml73S67J0yU96nR+N+W/w4LXfbqpH6O8Gsd2+oY/bryypsZ2iXq5OuLU4cSvk1eROlFORtZ3jTZtWlX0ktzVyZvWKOZgGhFBACwzhQl+2TOuRfS0Ya+4f65PtqMvbETV1xMXnR1rqxYMf+ypl1nhz/M8O4e75GriF93h5QCgzw/XjwrEnWeKEtkQGAv61VIetLjEUa3Qd7iuw/V6b8smbdaFjuxYMfVTBHLm2M+XIBw4I4BDsGBDuanbdwoCEDLXfagn4bmkn17aqw9GtbSpKWrIuPUE+HSHyofnzWq+2bmfHT2qI8BacQf284lFDlKSg2zvh8kpQoQEVAFIEeTxcuPDiFtgaXf7ASOd8m7tpL9DuV+dxSMWXZtHhEhRjAsgSEDeLu0HW/whF6UOgh7VjUl7swNH4CAfsC1u1uR0NvFTqtPq+nUrXP8kPR4aTVSQLRfoHT09fALCgArSoU+omRmKIKByeRwu63iZQE6IfKaJYQBkExAKfgQA/fAX7IBVst/8xRIk8vO1z+R0JCQgAA2Ah55CM351w5VY+QYZkXTmpHr9iKJ7QDkPiIXCphvBiEM/gQ3f4W9PvbIR/mcL/aPeA6pd5SllteajQaxZFZE0opohcbFvo/sVnmmVQxfIhAIA1AxXHQycIRKtVBxaoggmI4yMM7GMCViuYOyVVD6r+Xm2pGL48BgHs3W//7mE823z/vqQ3jdVTDqaGVTcE0Tg+9woAo5TwYlLGY5NbT2rMtd6TVc81jwV4AASA/r6BtqWfzhn9O9p6b/DQCM7go6LhwRMj1mKWMheBgaLGlvE7XuNx8q6bx9rg/f7StNm7aMHF2MvIz6+PEUkcmve45Rk+2fifG7mDOfbVje9jrbDlmsbCwQDH7M/bH763xvpymzcH5qeREWlqa+k18Pu6FxWKRRRql30Sbuays7CzlmwbHK8Ohvr6ecTqdMJlM4rhNo/TWafM6vVdij6XnVktAcMXlTS8AAAAASUVORK5CYII="/^>
SET _nok=^<img alt="red_nok.png" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAB3RJTUUH3gsFCCMS5+1BTQAAAAd0RVh0QXV0aG9yAKmuzEgAAAAMdEVYdERlc2NyaXB0aW9uABMJISMAAAAKdEVYdENvcHlyaWdodACsD8w6AAAADnRFWHRDcmVhdGlvbiB0aW1lADX3DwkAAAAJdEVYdFNvZnR3YXJlAF1w/zoAAAALdEVYdERpc2NsYWltZXIAt8C0jwAAAAh0RVh0V2FybmluZwDAG+aHAAAAB3RFWHRTb3VyY2UA9f+D6wAAAAh0RVh0Q29tbWVudAD2zJa/AAAABnRFWHRUaXRsZQCo7tInAAAElUlEQVQ4jYXVe2iVdRjA8e/vvO8577ntco7uOHFuzqnp2TAT0mmCKckUJTAiJbOSkC74RyRUJlEoIaIlkeK9ZkUmjWFewMsGjkyd4ho6N2+pR3cR9Wx6zs7Z2bv3fZ/+0A0Rqwce+D0/Hj48PH/8fogICtRUt3tCy4wZJ78fPfobL7hFhP/KkTC86cUX//i5rGxbBEL99w8xw3iuZeHCBru62ja3b8+sLSj4PKRU9r9h4zRtVO2sWfud6mqnd+fOzK8TJmwfqlSeiEABDDtTXn5C9uwRqaoSqaoSc926zKaSkvV+MJ7ERkHhidmza2XXroF+Z9MmZ0te3gZAuSyIXGtuzjdra+H+fUgmcQ8aZLyzZMn760pKvgorlc2jKNX1UT/NnPnD5Llzp+M4kEwid+6QOHBAtXV1jQcMvQ/kz0SCyO7dTBNBHz8eACM72790wYJl6crKtF+pNUNh8LbJkzeUV1TMBKC7GyyLdE0N+48c4aptW4DSTLB8EO01zVJpaXEVaBp6OAymiebx6JNGjpw66vbt4g/LypZNmjVrunK5FL29kErRtXcv1XV1NDpOog62xqFeE8h0wFUDipRlFROLacP9frSsLOjrw6XrWmlhYVlkxIhhSimFaSLd3fQcP86+kydpcpzEUdh8EXY4IkldRBylVFMtfOwGcff0zPYeOqQ/n0ziiUYBcGmahmmCaYJtk6yvp6axkYuOk6yBzedgvYjcA9ABHqEtR+EzCxLBTOa1QH29PiEYhMGDQamHKYJ97Rqnzp/nim2n98H6C7CtHwNw9R9ERHrhQg182a5pp4YWFwt+P/T1gWUNpCsSoaioqO+MUnvOwyZb5DaPhf5EoSrc7sJPJk6M5hQWDkyFZYGmgVIoj4cx0ai+VmTK9VhsCBB/3BiY0KOUtsjjmb8lJ2d7TiYTUnfvKhIJJJ0m3dqK2dGBxOPQ2opqb1clbvfYyvz8ypd8vmmaUqrfUSKCRyl9qWG8sSY39+tsvz+M3w9eL3i9PLBtzrW04DUMoqWlBHT94Rp6eyGToaO7+8YH7e3v7UuljtoijsqCwHKv993lublfBAKBLBUIKIJBJBDggQjNDQ1ys7MzaSjlLsjP940rLyegaahMBlIpJJ2WrmTyzoq2to9+fPCgSnvL7X59VU7O2mAgkK2CQUUwCOEwCcPgytmzxO7di38LGy/DlTGp1Ni+dNqTM3YsHr//4U5dLuWD4Atu97Sz6XSjrjvOs6bLlR3w+SAYRPLy6NQ0btTVSXM8HlsFK6/B74DRLnLp01hsBYcP5xXPmaNyIxFUPI6IYHV2RtymGXUlbdu60tUlCdvGDoe57/Vy89gxpykev7oaVl6HfSKSEpHOv2DXGlj9d0dHW+zgQUloGnYoRGd3N5du3XJ6LMsiCq/+Aq2NgYC0zZsnTeGwbISGAniZpzxfgH8MvFkJl88NGeLcmj9fTvt8sgUuDocZKMiKwtu/GcaN5ilTzO/gdA5MfRr2ODoEKnYo1dRUXt63U6mLRfAK4OtvCD6j1OJFodDWQTAd0P7vCwD0fJizOBTa8Qjzigj/AE2Kg5C8IVqUAAAAAElFTkSuQmCC"/^>

SET _on=^<img alt="on.png" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAgCAYAAAASYli2AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAFnwAABZ8BpH/JqwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAVISURBVEiJlZVbiF1XGcd/a1/mnJMZk0nS0GmkTMmAWuqtQeqLKOqD0AcpKAXBPpQBU1FKKX1oBS9vtj5YxFpibX0QvBGoRLQZNLHEENPUTmzLmJkkk+HM9cycy5w5c/Z17bXX58PeYyfTGYMbPvZmw/+3/t/3rW8tJSLsfJRSAN74OLVvnuCjdx7iE66wv9Nk+toM7351nGXA7KZFRG4JwJue5iGTfHlFspe01X/NJJuyot+xNjqtbfdHaV7/VPPGGb4G+O/TbwOpiQnuTYPPTEp21ki+ImJWRMyySLYoks2L6DmR9LpIOiO2+XKavvWRyYsv8uHtxrZgvHyS0Tz43IaYGRGzKGKWyve8SDYnom+IpNMi8bsi8RWR8LLI+mlrzh9tPDvO0S2oEhGUUgNx48D56uFzn8a5Q4ELKEBAcpAMxIDVIGXkGmwKUd0mbz32xscf4wvXlyV1lFJq6W0er9S+cT/OAVWAnDLUVqELoGQFJE/ARmBDGDjkVIaOfvLic3xHKaUcwD8ydPBRNfBApVA7gAf47O5Ug00gj8AEYDZRw/fsG67xMOB7gO/Zu0YhBQGUA6qEiQKy0mEOtnRo4wKYh4XbZA7Pcvfn72Ofc/p5xpTcLUharI4q3KkaKLdYBFumrCEvU95yGNchXkWE7IcPc9w5UuUQtqawQN4ohNgSYt9L1ZYwG5fOAtAdWP01pICBikPFefZXTNFbcJAM8j6YVbCbZUQgSdmEshF5BCaEeB6ar0LQAQ1K4//0L1zx/niJwIRLa34W34MfAZ2iVk6tSPe/DdiErAVJA8Kr0P83hK3CXQJ5RvuXFwg8wETrrYsHotYoQ1WFOKA0GLdMMwDTBd0G3YJ0rQitIdGggRgbRfwDSB3A/GtGXpD6+QSzAaYDWRtMq/xeh6wHpg9ZACaCNIYkgSSFoqzBG7P8GDBeOSlX+r/957nBkeMPqg/c4UCl2I+5KVLO+u9BdQBJBEkMSY5EmCjib196gbdFBKc8dPTEZf00N15P0O2iVrpVONXtwqXegHQT4j5EAYRhsXVj4nPTPFP0uRgJSpfXuvdN/274yNgjHB72sQpsXsysiUD3Ie5BuAnRJsQaSQfSXiSnHnolm906ZLYcIiLmlbP59+zNN2Oi0qEuHaYdiNYh7EK0AUEftIO4H0xfupB9f8vdLUCAp35PY3Wx8ZzML8YMPwgj34bDX4Hax0pYr+hjdQw59MWkvbr2/NNnWNl+ct8CFBH79V/wIit1S+8SuENQGYPKh6ByLwzeD/uPQ20M6dTN+G+in4iI3c7w2PG8fp0gCcPJ2tLfP8uRR4pmNC/D0llIXdAOmH1kvWj2T9cId+qdnT+AvNm2f5D5hYTNOmQW+usQWogyCFPY6OYbvfS14ii6DVBE5M9TvBbHoyZd7edpVLPN5X1mdnHEzCyPmKvNETMb3Jm9ueK9Krtce2qPa/Tg5OTVG6OjRw/7vker1aXd3iAIYhzHYWGh0Tp58mcPXLp0pr5T+74abk/d81xEhChKWV/vEYYxvu+htXb3Eu0JDENNFCX4vovWGhCq1QEcB1xX7Vb72zkUL89zfN/D910qFZ88NyjlIiKSJMmuqj1Xcl0ltVqVgQGfoaFBBgcHAQ/XddHamr10ezm0YRjnrqswxrCx0WNlZY0oiqlUBkiSxDcmz/8fYDQ3V/9Bs7n+5NCQPxpFod9orBLHeR4EdqHZbP98aurC2m7CXbcNgFJKHTt2bP+JE888YUz+rTTVXqezeWpi4tR3b958p71z5G4L3Ab2qtXqXbVa7WC3250B9P/S/Ac/8Zdq7nvP1AAAAABJRU5ErkJggg=="/^>
SET _off=^<img alt="off.png" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAgCAYAAAASYli2AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAFnwAABZ8BpH/JqwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAUqSURBVEiJlVVbaBVHGP7+mdlzS0xMrCHaxnhBaUmpVYsWJA8WabT6YrGKhQYKBtFCW/ogsfRGH6Sl0Kci9M2HUoX0BqJEqGKRWgIxNTZWLRqLl9yTk8uePXv2zMzfhz17cqIntR0Ydpfd75vvn+/7Z4mZ8fAgIgBQK1Y8l1y1av2zqdSCtUqpKq39666bvnr+/MkHAHQ5rCpDplpa2nZu3dp8bMOGZ56or19EtbVV0lpgYmJKDw6O8fbtO6b6+q69Q0TfMXN+Dj5ahYiouXnP01u2bPlm796WtQ0NdZJIAAjfR2KYGcyM/v77wYULl/uuXu19/fjxL25GPCoqcePGHctaWl7+ra3t1epEIgaAADCYQ5LSe2Zg+fKlsd27a9YpJS8MDr62gYgGmLlYcmzduhdPtrburIrHHRAB4TaioHCWzFouKk0m47R9++a6IMh39PRcfAlAThAR7dt3+O1t25rXVVQkCSAQCRBRcQJUJAuvFtaGz9XVC0Rj45PPt7d/9j5RuEnO0qX1b65e/VScCBCCClNAiIiwdHChbAvAgtlizZqGVG1t7R4AjgLgLF68qDHc05BMSgEiAeYQEHGG6lAoP5xEDCklEolYQ1PT2pTatattVV3dQg5LsAVSASkFtJ7NWbjgrLrIHGMsAEZVVUW+tfXAelFVVV2bSiVICILn+Yjsn41JKVnpNVQ8Pe1BKYVEIoZUKhUXXV0/93meLwBAa4NsNocg0NBawxhbMMAWDYnczucNZmY8EAFKSTDDOX36+x5148YVN5v1h42xy621CIJ88SMimuOs1hbG6MKCpmCeBBHgOHKss/OUqwBoz/N+DYJ8o9Yx0lqDKFQLANHehmpNcYEoAUpJ5HKBtdZcApATAPTw8P2vRkbGfa0N8nldnFobGGMKZvGcFCgloZSE4yhkMln3+vU/vgSgFTODiHqamn46t2TJ4leEEAIgSMmFYM8aFMZHFDpJQEpCLhdoY/T5Q4f2X2FmiEIqgmvXfm9Pp6d9rQ20nqsu6mUighCAEAJKiUK5+Wx3d9cRALp4OBRU3ty0afPJmprqN4QgJ+wQUVQWNhUVSAWklNDa5PJ5v+Pgwf23orhFCsHM+ty50x9ls3521gSL0kM0ak0pw+ADnDtx4tuPI3VAyXkYAkicOnWufdmyhg/q6xclE4k4IqNyuQBSCjiOQizmAIA/MDD0eVPTmk85bOzZtJfOF17YtLC39y/3zp0H7Loeu67H6fQMDw9P8NjYJE9OzrDrejwxMTXT0rKt5mF8seRodHd3uczmchDoYuuFXWOK5Yf7y7fOnu3MPIx/hBCAcd3pH5USvjG2eJw5jixmTwhhPC9zBkD+sYTMzBcv/nLGcZRmtsZaY13X1UNDQ/ru3Xu6v/+Ovnfvfr6n5/IPXOa3V04hjhw5PDo6ms5pbaW1EPk8q0zGqNHRjBoby6pLl/6cOXr02Hg57CO/0dLSw1OE4Xk5TExMIZPJwnEUgiCQ84HmJcxkAnieD8eRCIIAACORiEEIQEoqW9ljFLIyxsBxFBxHIh53YIwGkQQzs+/7ZVHzriQlcTKZQCzmoLKyAhUVFQAUpJQIAqvnw82n0GYyWSMlQWuNyckpDAwMw/OyiMdj8H3f0dqY/0Po9ff//cnIyMR7lZVOo+dlnMHBIWSzxriuvTsyMvZ1X9/F4XJAKhOl8AURrVy5surAgSPvam3eyuUCNT4+3dHZ2fHh7du9Y3P6978QlhCrRCKxJJlM1qTT6RsAgn/D/APx0kZURiaTdwAAAABJRU5ErkJggg=="/^>

SET _topname=Files\top.html
SET _legend=Files\legend.html
SET _table=Files\table.html
SET _endname=Files\end.html

IF NOT EXIST start.log (
ECHO.>start.log
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "starttime" "start.log"') DO IF %%A==0 (ECHO starttime^=%DATE% %TIME%>>start.log)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "starttime" "start.log"') DO (SET _starttime=%%A)
ECHO !_starttime!
) ELSE (
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "starttime" "start.log"') DO (SET _starttime=%%A)
ECHO !_starttime!
)

REM Prereq
IF NOT EXIST ..\SysinternalsSuite\*.* ECHO ..\SysinternalsSuite\*.* not found &PAUSE& GOTO EOF
IF EXIST ..\SysinternalsSuite\psexec.exe (SET _psexec="..\SysinternalsSuite\psexec.exe")ELSE (ECHO ..\SysinternalsSuite\psexec.exe not found &PAUSE& GOTO EOF)
IF EXIST ..\SysinternalsSuite\psloggedon.exe (SET _psloggedon="..\SysinternalsSuite\psloggedon.exe")ELSE (ECHO ..\SysinternalsSuite\psloggedon.exe not found &PAUSE& GOTO EOF)
IF EXIST ..\SysinternalsSuite\pskill.exe (SET _pskill="..\SysinternalsSuite\pskill.exe")ELSE (ECHO ..\SysinternalsSuite\pskill.exe not found &PAUSE& GOTO EOF)
IF NOT EXIST Files\*.* MD Files
IF NOT EXIST "!_NEEDS_attentionfile!" ECHO.>!_NEEDS_attentionfile!

REM Change to settings file
REM SET _dnssuffix=plastal.net
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "dnssuffix" "settings.cfg"') DO IF %%A==0 (ECHO dnssuffix^=change.me>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "dnssuffix" "settings.cfg"') DO (SET _dnssuffix=%%A)

CLS
IF X%1 NEQ X SET _computer=%1
IF X%1 EQU X SET /p _computer=Computer ? 

SET _header=Computername
SET _result=!_computer!


SET _separator=***** Count ***********************************************************
REM ECHO !_separator:~0,70!
ECHO        ^<tr bgcolor="6495ED"^> >!_legend!
REM Check for odd/even
IF NOT EXIST "%~dp0Files\file.txt" (ECHO        ^<tr bgcolor="ffffff"^> >>!_table!) ELSE (ECHO        ^<tr bgcolor="dddddd"^> >>!_table!)
IF NOT EXIST "%~dp0Files\file.txt" (ECHO.>"%~dp0Files\file.txt") ELSE (DEL /Q "%~dp0Files\file.txt")
REM ECHO        ^<tr^> >>!_table!
ECHO         ^<td width="50"^>^<div align="center"^>Count^</div^>^</td^> >>!_legend!
ECHO         ^<td width="50"^>^<div align="center"^>^<a href="Files\systeminfo\!_computer!.txt"^>!_countnr!/!_counttotal!^</a^>^</div^>^</td^> >>!_table!
SET _separator=***** Count ************************************************************
REM ECHO !_separator:~0,70!
ECHO.

SET _separator=***** Pinging !_computer! ************************************************************
ECHO !_separator:~0,70!
SET _mode=NA
ECHO. 
FOR /F "tokens=1 delims= " %%A IN ('PING -n 1 !_computer!.!_dnssuffix!^|FIND /I "Reply from"^|FIND /C /I "time"') DO IF %%A==1 (SET _mode=up&ECHO !_computer! is Up) ELSE (SET _mode=down&ECHO !_computer! is Down)
REM PING -n 1 !_computer!.!_dnssuffix!
ECHO. 
IF !_mode!==down ECHO !_computer!>>Files\offline.log
IF !_mode!==up ECHO !_computer!>>Files\online.log
SET _header=!_header!,Mode
SET _result=!_result! !_mode!
ECHO         ^<td width="50"^>^<div align="center"^>Ping^</div^>^</td^> >>!_legend!
IF !_mode!==up (ECHO         ^<td width="50"^>^<div align="center"^>!_on!^</div^>^</td^> >>!_table!) ELSE (ECHO         ^<td width="50"^>^<div align="center"^>!_off!^</div^>^</td^> >>!_table!) 
SET _separator=***** End pinging !_computer! ************************************************************
ECHO !_separator:~0,70!
ECHO.

SET _separator=***** Computername ***********************************************************
ECHO !_separator:~0,70!
ECHO         ^<td width="150"^> Computername ^</td^> >>!_legend!
IF EXIST "Files\systeminfo\!_computer!.txt" (ECHO         ^<td width="150"^>^<a href="Files\systeminfo\!_computer!.txt"^> !_computer!^</a^>^</td^> >>!_table!) ELSE (ECHO         ^<td width="150"^> !_computer! ^</td^> >>!_table!)
ECHO !_computer!
SET _separator=***** End ************************************************************
ECHO !_separator:~0,70!
ECHO.

:: check_desc ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_desc" "settings.cfg"') DO IF %%A==0 (ECHO check_desc^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_desc" "settings.cfg"') DO (SET _check_desc=%%A)
IF !_check_desc!==yes (
SET _separator=***** Desc ***********************************************************
ECHO !_separator:~0,70!
SET /A _colspan+=1
SET _desc=NA
FOR /F "tokens=1 delims=" %%A IN ('dsquery computer -name !_computer! -uc^| dsget computer -desc -uc^|FIND /I /V "dsget succeeded"^|FIND /I /V "desc"') DO (SET _desc=%%A)
ECHO !_computer! !_desc!>>"Files\AD_desc.log"
ECHO         ^<td width="250"^> Description ^</td^> >>!_legend!
ECHO         ^<td width="250"^> !_desc! ^</td^> >>!_table!
ECHO !_desc!
SET _separator=***** End ************************************************************
ECHO !_separator:~0,70!
ECHO.
)


::show_systeminfo ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "show_systeminfo" "settings.cfg"') DO IF %%A==0 (ECHO show_systeminfo^=yes>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "show_systeminfo" "settings.cfg"') DO (SET _show_systeminfo=%%A)
::show_systeminfo ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "show_pagefile" "settings.cfg"') DO IF %%A==0 (ECHO show_pagefile^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "show_pagefile" "settings.cfg"') DO (SET _show_pagefile=%%A)
::check_systeminfo ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_systeminfo" "settings.cfg"') DO IF %%A==0 (ECHO check_systeminfo^=yes>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_systeminfo" "settings.cfg"') DO (SET _check_systeminfo=%%A)
::update_systeminfo ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "update_systeminfo" "settings.cfg"') DO IF %%A==0 (ECHO update_systeminfo^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "update_systeminfo" "settings.cfg"') DO (SET _update_systeminfo=%%A)

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

SET _systeminfo_filedate=NA
IF EXIST Files\systeminfo\!_computer!.txt (
FOR /F %%A IN ("Files\systeminfo\!_computer!.txt") DO SET _systeminfo_filedate=%%~tA
SET _systeminfo_filedate=!_systeminfo_filedate:~0,-6!)

IF "!_update_systeminfo!" EQU "yes" (
	IF "!_systeminfo_filedate!" NEQ "%DATE%" IF EXIST "%~dp0Files\systeminfo\!_computer!.txt" DEL /Q "%~dp0Files\systeminfo\!_computer!.txt"
	ECHO Systeminfo not up to date *Removing* "!_systeminfo_filedate!" NEQ "%DATE%")

IF "%Computername%"=="!_computer!" IF NOT EXIST Files\systeminfo\!_computer!.txt systeminfo>Files\systeminfo\%Computername%.txt
REM IF EXIST "Files\systeminfo\!_computer!.txt" DEL /Q "Files\systeminfo\!_computer!.txt"

IF !_mode!==up (
IF NOT EXIST "Files\systeminfo\!_computer!.txt" (
	ECHO Systeminfo not exist *Creating*
	!_psexec! \\!_computer! systeminfo>"%~dp0Files\systeminfo\!_computer!.txt")
	)
FOR /F %%A IN ("Files\systeminfo\!_computer!.txt") DO IF %%~zA==0 (ECHO !_computer!>>Files\Missing_systeminfo.log&DEL /Q Files\systeminfo\!_computer!.txt)
IF EXIST Files\systeminfo\!_computer!.txt (
REM ENG
FOR /F "tokens=2 delims=:" %%A IN ('FIND /C /I "OS Name" "Files\systeminfo\!_computer!.txt"') DO IF %%A EQU 1 (
ECHO ENG
FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "OS Name" "Files\systeminfo\!_computer!.txt"') DO (SET _OSName=%%A)
FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "OS Version" "Files\systeminfo\!_computer!.txt"^|FIND /I /V "BIOS"') DO (SET _OSVersion=%%A)
FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "Manufacturer" "Files\systeminfo\!_computer!.txt"') DO (SET _Manufacturer=%%A)
FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "System Model" "Files\systeminfo\!_computer!.txt"') DO (SET _Model=%%A)
FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "Type" "Files\systeminfo\!_computer!.txt"') DO (SET _Type=%%A)
FOR /F "tokens=4 delims= " %%A IN ('FIND /I "Page File Location" "Files\systeminfo\!_computer!.txt"') DO (SET _PageFileLocation=%%A)
SET _OSName=!_OSName:~19!
SET _OSVersion=!_OSVersion:~16!
SET _Manufacturer=!_Manufacturer:~7!
SET _Model=!_Model:~14!
SET _Type=!_Type:~15,3!
)

REM SWE
FOR /F "tokens=2 delims=:" %%A IN ('FIND /C /I "Operativsystemnamn" "Files\systeminfo\!_computer!.txt"') DO IF %%A EQU 1 (
ECHO SWE
FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "Operativsystemnamn" "Files\systeminfo\!_computer!.txt"') DO (SET _OSName=%%A)
FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "Operativsystemsversion" "Files\systeminfo\!_computer!.txt"^|FIND /I /V "BIOS"') DO (SET _OSVersion=%%A)
FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "Systemtillverkare" "Files\systeminfo\!_computer!.txt"') DO (SET _Manufacturer=%%A)
FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "Systemmodell" "Files\systeminfo\!_computer!.txt"') DO (SET _Model=%%A)
FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "Systemtyp" "Files\systeminfo\!_computer!.txt"') DO (SET _Type=%%A)
FOR /F "tokens=4 delims= " %%A IN ('FIND /I "xlingsfiler" "Files\systeminfo\!_computer!.txt"') DO (SET _PageFileLocation=%%A)
SET _OSName=!_OSName:~15!
SET _OSVersion=!_OSVersion:~11!
SET _Manufacturer=!_Manufacturer:~16!
SET _Model=!_Model:~21!
SET _Type=!_Type:~24,3!
)
IF NOT EXIST "Files\systeminfo\!_computer!.txt" ECHO Systeminfo not found&PAUSE

IF "!_show_systeminfo!" EQU "yes" (
ECHO OSName=			!_OSName!
ECHO OSVersion=		!_OSVersion!
ECHO Manufacturer=		!_Manufacturer!
ECHO Model=			!_Model!
ECHO Type=			!_Type!
)

REM ECHO PageFileLocation=!_PageFileLocation!
ECHO !_computer!>>"Files\!_Type!.log"
ECHO !_computer!>>"Files\!_Manufacturer!.log"
ECHO !_computer!>>"Files\!_OSName!.log"
ECHO !_computer!>>"Files\!_Model!.log"
)

IF !_show_systeminfo!==yes ECHO        ^<td width="400"^> OSName ^</td^> >>!_legend!
IF !_show_systeminfo!==yes ECHO        ^<td width="250"^> OSVersion ^</td^> >>!_legend!
IF !_show_systeminfo!==yes ECHO        ^<td width="200"^> Manufacturer ^</td^> >>!_legend!
IF !_show_systeminfo!==yes ECHO        ^<td width="250"^> Model ^</td^> >>!_legend!
IF !_show_systeminfo!==yes ECHO        ^<td width="50"^> Type ^</td^> >>!_legend!
IF !_show_systeminfo!==yes IF !_show_pagefile!==yes ECHO        ^<td width="130"^> PageFileLocation ^</td^> >>!_legend!
IF !_show_systeminfo!==yes IF EXIST "Files\!_OSName!.log" (ECHO         ^<td width="400"^>^<a href="Files\!_OSName!.log"^> !_OSName!^</a^>^</td^> >>!_table!) ELSE (ECHO         ^<td width="400"^> !_OSName! ^</td^> >>!_table!)
IF !_show_systeminfo!==yes ECHO         ^<td width="250"^> !_OSVersion! ^</td^> >>!_table!
IF !_show_systeminfo!==yes IF EXIST "Files\!_Manufacturer!.log" (ECHO         ^<td width="200"^>^<a href="Files\!_Manufacturer!.log"^> !_Manufacturer!^</a^>^</td^> >>!_table!) ELSE (ECHO         ^<td width="200"^> !_Manufacturer! ^</td^> >>!_table!)
IF !_show_systeminfo!==yes IF EXIST "Files\!_Model!.log" (ECHO         ^<td width="250"^>^<a href="Files\!_Model!.log"^> !_Model!^</a^>^</td^> >>!_table!) ELSE (ECHO         ^<td width="250"^> !_Model! ^</td^> >>!_table!)
IF !_show_systeminfo!==yes IF EXIST "Files\!_Type!.log" (ECHO         ^<td width="50"^>^<a href="Files\!_Type!.log"^> !_Type!^</a^>^</td^> >>!_table!) ELSE (ECHO         ^<td width="50"^> !_Type! ^</td^> >>!_table!)
IF !_show_systeminfo!==yes IF !_show_pagefile!==yes ECHO         ^<td width="130"^> !_PageFileLocation! ^</td^> >>!_table!



ECHO.
SET _separator=***** End checking systeminfo ver on !_computer! *******************************
ECHO !_separator:~0,70!
ECHO.
)




:: check_ados ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_ados" "settings.cfg"') DO IF %%A==0 (ECHO check_ados^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_ados" "settings.cfg"') DO (SET _check_ados=%%A)
IF !_check_ados!==yes (
SET _separator=***** AD OS ***********************************************************
ECHO !_separator:~0,70!
SET /A _colspan+=1
SET _ados=NA
FOR /F "tokens=1 delims=" %%A IN ('dsquery * -filter "(&(objectClass=Computer)(objectCategory=Computer)(sAMAccountName=!_computer!$))" -attr operatingSystem^|FIND /I /V "operatingSystem"') DO (SET _ados=%%A)
REM ECHO ADos=!_ados!
ECHO !_computer!>>"Files\!_ados!.log"
ECHO         ^<td width="250"^> AD_os ^</td^> >>!_legend!
ECHO         ^<td width="250"^> !_ados! ^</td^> >>!_table!
ECHO !_ados!
SET _separator=***** End ************************************************************
ECHO !_separator:~0,70!
ECHO.
)

::run_ipconfig ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "run_ipconfig" "settings.cfg"') DO IF %%A==0 (ECHO run_ipconfig^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "run_ipconfig" "settings.cfg"') DO (SET _run_ipconfig=%%A)
IF !_run_ipconfig!==yes (
	SET /A _colspan+=1
	SET _separator=***** Running ipconfig on !_computer! *******************************
	ECHO !_separator:~0,70!
	ECHO         ^<td width="100"^>^<div align="center"^>Ipconfig^</div^>^</td^> >>!_legend!
	IF !_mode!==up (
		IF NOT EXIST "%~dp0Files\ipconfig_FILES" MD "%~dp0Files\ipconfig_FILES"
		IF NOT EXIST "%~dp0Files\ipconfig_FILES\!_computer!_ipconfig.txt" (
			!_psexec! \\!_computer! ipconfig /all>Files\ipconfig_FILES\!_computer!_ipconfig.txt
			) ELSE (ECHO Ipconfig file exist)

		REM FOR /F %%A IN ("Files\ipconfig_FILES\!_computer!_ipconfig.txt") DO IF "%%~zA" EQU "0" PAUSE
		FOR /F %%A IN ("Files\ipconfig_FILES\!_computer!_ipconfig.txt") DO IF "%%~zA" EQU "0" DEL /Q "%~dp0Files\ipconfig_FILES\!_computer!_ipconfig.txt"
			
		IF EXIST Files\ipconfig_FILES\!_computer!_ipconfig.txt (ECHO         ^<td width="100"^>^<a href="Files\ipconfig_FILES\!_computer!_ipconfig.txt"^>^<div align="center"^>Ipconfig^</div^>^</a^>^</td^> >>%_table%)
		IF NOT EXIST Files\ipconfig_FILES\!_computer!_ipconfig.txt (ECHO         ^<td width="100"^>^<div align="center"^> NA ^</div^>^</td^> >>%_table%)
	)
	IF !_mode!==down ECHO         ^<td width="200"^>^<div align="center"^> NA ^</div^>^</td^> >>%_table%
	SET _separator=***** End running ipconfig on !_computer! *******************************
	ECHO !_separator:~0,70!
)




::verify_clock ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "verify_clock" "settings.cfg"') DO IF %%A==0 (ECHO verify_clock^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "verify_clock" "settings.cfg"') DO (SET _verify_clock=%%A)
IF !_verify_clock!==yes (
SET /A _colspan+=1
SET _separator=***** Verify Clock on !_computer! *******************************
ECHO !_separator:~0,70!
SET _clocksource=NA
IF !_mode!==up (
IF NOT EXIST "%~dp0Files\clock_FILES" MD "%~dp0Files\clock_FILES"
IF NOT EXIST "%~dp0Files\clock_FILES\!_computer!_clock.txt" (
	!_psexec! \\!_computer! w32tm /query /status|FIND /I "Source:" >Files\clock_FILES\!_computer!_clock.txt
	) ELSE (ECHO clock file exist)
ECHO        ^<td width="200"^> Clock ^</td^> >>!_legend!

FOR /F "tokens=2 delims=:" %%A IN ('FIND /I "source" "Files\clock_FILES\!_computer!_clock.txt"') DO (SET _clocksource=%%A)
ECHO !_clocksource!
IF EXIST Files\clock_FILES\!_computer!_clock.txt (ECHO         ^<td width="200"^>!_clocksource!^</td^> >>%_table%) ELSE (ECHO         ^<td width="200"^>^<div align="center"^> NA ^</div^>^</td^> >>%_table%)
)
IF !_mode!==down ECHO        ^<td width="200"^> Clock ^</td^> >>!_legend!
IF !_mode!==down ECHO        ^<td width="200"^>^<div align="center"^> NA ^</div^>^</td^> >>%_table%
FOR /F %%A IN ("Files\clock_FILES\!_computer!_clock.txt") DO IF %%~zA EQU 0 DEL /Q "Files\clock_FILES\!_computer!_clock.txt"
SET _separator=***** End running ipconfig on !_computer! *******************************
ECHO !_separator:~0,70!
)




:: check_symantec ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_symantec" "settings.cfg"') DO IF %%A==0 (ECHO check_symantec^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_symantec" "settings.cfg"') DO (SET check_symantec=%%A)
IF !check_symantec!==yes (
SET _separator=***** Symantec Not Exist ***********************************************************
ECHO !_separator:~0,70!
SET /A _colspan+=1
SET _symantec_result=OK
IF !_mode!==up (
IF EXIST "\\!_computer!\c$\Program Files (x86)\Symantec\*.*" SET _symantec_result=NOK
IF EXIST "\\!_computer!\c$\Program Files\Symantec\*.*" SET _symantec_result=NOK
)
ECHO !_computer!>>"Files\!_symantec_result!.log"

REM ECHO "!_NEEDS_attentionfile!"
IF "!_symantec_result!"=="NOK" ECHO !_computer!>>"!_NEEDS_attentionfile!"
REM FOR /F "tokens=* delims=" %%A IN ('FIND /I /C "!_computer!" !_NEEDS_attentionfile!') DO (IF %%A==0 ECHO "A=0")
IF "!_symantec_result!"=="NOK" FOR /F "tokens=* delims=" %%A IN ('FIND /I /C "!_computer!" "!_NEEDS_attentionfile!"') DO (IF %%A==0 (ECHO !_computer!>>"!_NEEDS_attentionfile!"))
ECHO         ^<td width="100"^> Symantec cleaned ^</td^> >>!_legend!
IF !_mode!==up IF "!_symantec_result!"=="OK" (ECHO         ^<td width="100"^>^<div align="center"^>!_ok!^</div^>^</td^> >>%_table%) ELSE (ECHO         ^<td width="100"^>^<div align="center"^>!_nok!^</div^>^</td^> >>%_table%) 
IF !_mode!==down ECHO         ^<td width="100"^>^<div align="center"^>NA^</div^>^</td^> >>%_table%
ECHO !_symantec_result!
SET _separator=***** End ************************************************************
ECHO !_separator:~0,70!
ECHO.
)

:: check_hp ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_hp" "settings.cfg"') DO IF %%A==0 (ECHO check_hp^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_hp" "settings.cfg"') DO (SET check_hp=%%A)
IF !check_hp!==yes (
SET _separator=***** OP5 ***********************************************************
ECHO !_separator:~0,70!
SET /A _colspan+=1
SET _hp_result=OK
IF !_mode!==up (
REM IF EXIST "\\!_computer!\c$\Program Files (x86)\OP5\*.*" SET _hp_result=NOK
IF EXIST "\\!_computer!\c$\Program Files\hp\*.*" SET _hp_result=NOK
IF EXIST "\\!_computer!\c$\hp\*.*" SET _hp_result=NOK
)
ECHO !_computer!>>"Files\!_hp_result!.log"
ECHO         ^<td width="100"^> HP cleaned ^</td^> >>!_legend!
IF !_mode!==up IF "!_hp_result!"=="OK" (ECHO         ^<td width="100"^>^<div align="center"^>!_ok!^</div^>^</td^> >>%_table%) ELSE (ECHO         ^<td width="100"^>^<div align="center"^>!_nok!^</div^>^</td^> >>%_table%) 
IF !_mode!==down ECHO         ^<td width="100"^>^<div align="center"^> NA ^</div^>^</td^> >>%_table%
ECHO !_hp_result!
SET _separator=***** End ************************************************************
ECHO !_separator:~0,70!
ECHO.
)

:: check_op5 ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_op5" "settings.cfg"') DO IF %%A==0 (ECHO check_op5^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_op5" "settings.cfg"') DO (SET check_op5=%%A)
IF !check_op5!==yes (
	SET _separator=***** OP5 ***********************************************************
	ECHO !_separator:~0,70!
	SET /A _colspan+=1
	SET _op5_result=NA
	SET _result=NA
	ECHO         ^<td width="100"^> OP5 cleaned ^</td^> >>!_legend!

	IF !_mode!==up (
		IF EXIST "\\!_computer!\c$\*.*" (
		SET _op5_result=OK
		IF EXIST "\\!_computer!\c$\Program Files (x86)\OP5\*.*" SET _op5_result=NOK
		IF EXIST "\\!_computer!\c$\Program Files\OP5\*.*" SET _op5_result=NOK
		)
	)
	ECHO !_computer!>>"Files\!_op5_result!.log"
	IF "!_op5_result!"=="OK" (SET _result=!_ok!)
	IF "!_op5_result!"=="NOK" (SET _result=!_nok!)
	IF !_mode!==down (SET _result=NA)
	ECHO         ^<td width="100"^>^<div align="center"^>!_result!^</div^>^</td^> >>%_table%
	ECHO !_op5_result!
	SET _separator=***** End ************************************************************
	ECHO !_separator:~0,70!
	ECHO.
)

:: check_vnc ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_vnc" "settings.cfg"') DO IF %%A==0 (ECHO check_vnc^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_vnc" "settings.cfg"') DO (SET check_vnc=%%A)
IF !check_vnc!==yes (
	SET _separator=***** VNC ***********************************************************
	ECHO !_separator:~0,70!
	SET /A _colspan+=1
	SET _vnc_result=NA
	SET _result=NA
	ECHO         ^<td width="100"^> VNC cleaned ^</td^> >>!_legend!
	IF !_mode!==up (
		IF EXIST "\\!_computer!\c$\*.*" (
		SET _vnc_result=OK
		IF EXIST "\\!_computer!\c$\Program Files (x86)\RealVNC\*.*" SET _vnc_result=NOK
		IF EXIST "\\!_computer!\c$\Program Files\RealVNC\*.*" SET _vnc_result=NOK
		)
	)
	ECHO !_computer!>>"Files\!_vnc_result!.log"
	IF "!_vnc_result!"=="OK" (SET _result=!_ok!)
	IF "!_vnc_result!"=="NOK" (SET _result=!_nok!)
	IF !_mode!==down (SET _result=NA)
	ECHO         ^<td width="100"^>^<div align="center"^>!_result!^</div^>^</td^> >>%_table%
	ECHO !_vnc_result!
	SET _separator=***** End ************************************************************
	ECHO !_separator:~0,70!
	ECHO.
)


::SNMP Informant

:: check_dameware ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_dameware" "settings.cfg"') DO IF %%A==0 (ECHO check_dameware^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_dameware" "settings.cfg"') DO (SET check_dameware=%%A)
IF !check_dameware!==yes (
SET _separator=***** Dameware ***********************************************************
ECHO !_separator:~0,70!
SET /A _colspan+=1
SET _dameware_result=OK
IF !_mode!==up (IF EXIST "\\!_computer!\c$\Windows\SYSTEM32\DWRCS.EXE" SET _dameware_result=NOK)
ECHO !_computer!>>"Files\!_dameware_result!.log"
REM IF "!_dameware_result!"=="NOK" ECHO !_computer!>>"!_NEEDS_attentionfile!"
IF "!_dameware_result!"=="NOK" FOR /F "tokens=* delims=" %%A IN ('FIND /I /C "!_computer!" !_NEEDS_attentionfile!') DO IF %%A==0 (ECHO !_computer!>>!_NEEDS_attentionfile!)
ECHO         ^<td width="100"^> Dameware cleaned ^</td^> >>!_legend!
IF !_mode!==up IF "!_dameware_result!"=="OK" (ECHO         ^<td width="100"^>^<div align="center"^>!_ok!^</div^>^</td^> >>%_table%) ELSE (ECHO         ^<td width="100"^>^<div align="center"^>!_nok!^</div^>^</td^> >>%_table%) 
IF !_mode!==down ECHO         ^<td width="100"^>^<div align="center"^> NA ^</div^>^</td^> >>%_table%
ECHO !_dameware_result!
SET _separator=***** End ************************************************************
ECHO !_separator:~0,70!
ECHO.
)


:: check_NSClient ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_NSClient" "settings.cfg"') DO IF %%A==0 (ECHO check_NSClient^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_NSClient" "settings.cfg"') DO (SET check_NSClient=%%A)
IF !check_NSClient!==yes (
SET _separator=***** NSclient ***********************************************************
ECHO !_separator:~0,70!
SET /A _colspan+=1
SET _NSClient_result=OK
IF !_mode!==up (
IF EXIST "\\!_computer!\c$\Program Files (x86)\NSClient++\*.*" SET _NSClient_result=NOK
IF EXIST "\\!_computer!\c$\Program Files\NSClient++\*.*" SET _NSClient_result=NOK
)
ECHO !_computer!>>"Files\!_NSClient_result!.log"
REM IF "!_NSClient_result!"=="NOK" ECHO !_computer!>>"!_NEEDS_attentionfile!"
IF "!_NSClient_result!"=="NOK" FOR /F "tokens=* delims=" %%A IN ('FIND /I /C "!_computer!" !_NEEDS_attentionfile!') DO IF %%A==0 (ECHO !_computer!>>"!_NEEDS_attentionfile!")
ECHO         ^<td width="100"^> NSClient cleaned ^</td^> >>!_legend!
IF !_mode!==up IF "!_NSClient_result!"=="OK" (ECHO         ^<td width="100"^>^<div align="center"^>!_ok!^</div^>^</td^> >>%_table%) ELSE (ECHO         ^<td width="100"^>^<div align="center"^>!_nok!^</div^>^</td^> >>%_table%) 
IF !_mode!==down ECHO         ^<td width="100"^>^<div align="center"^> NA ^</div^>^</td^> >>%_table%
ECHO !_NSClient_result!
SET _separator=***** End ************************************************************
ECHO !_separator:~0,70!
ECHO.
)


:: check_check_mk ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_check_mk" "settings.cfg"') DO IF %%A==0 (ECHO check_check_mk^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_check_mk" "settings.cfg"') DO (SET check_check_mk=%%A)
IF !check_check_mk!==yes (
SET _separator=***** Check_mk ***********************************************************
ECHO !_separator:~0,70!
SET /A _colspan+=1
SET _check_mk_result=NOK
IF !_mode!==up (
IF EXIST "\\!_computer!\c$\Program Files (x86)\check_mk\*.*" SET _check_mk_result=OK
IF EXIST "\\!_computer!\c$\Program Files\check_mk\*.*" SET _check_mk_result=OK
)
ECHO !_computer!>>"Files\!_check_mk_result!.log"
REM IF "!_check_mk_result!"=="NOK" ECHO !_computer!>>"!_NEEDS_attentionfile!"
IF "!_check_mk_result!"=="NOK" FOR /F "tokens=* delims=" %%A IN ('FIND /I /C "!_computer!" !_NEEDS_attentionfile!') DO IF %%A==0 (ECHO !_computer!>>"!_NEEDS_attentionfile!")
ECHO         ^<td width="100"^> check_mk Exist ^</td^> >>!_legend!
IF !_mode!==up IF "!_check_mk_result!"=="OK" (ECHO         ^<td width="100"^>^<div align="center"^>!_ok!^</div^>^</td^> >>%_table%) ELSE (ECHO         ^<td width="100"^>^<div align="center"^>!_nok!^</div^>^</td^> >>%_table%) 
IF !_mode!==down ECHO         ^<td width="100"^>^<div align="center"^> NA ^</div^>^</td^> >>%_table%
ECHO !_check_mk_result!
SET _separator=***** End ************************************************************
ECHO !_separator:~0,70!
ECHO.
)

:: check_Webroot ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_Webroot" "settings.cfg"') DO IF %%A==0 (ECHO check_Webroot^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_Webroot" "settings.cfg"') DO (SET check_Webroot=%%A)
IF !check_Webroot!==yes (
SET _separator=***** Webroot ***********************************************************
ECHO !_separator:~0,70!
SET /A _colspan+=1
SET _Webroot_result=NOK
IF !_mode!==up (
IF EXIST "\\!_computer!\c$\Program Files (x86)\Webroot\*.*" SET _Webroot_result=OK
IF EXIST "\\!_computer!\c$\Program Files\Webroot\*.*" SET _Webroot_result=OK
)
ECHO !_computer!>>"Files\!_Webroot_result!.log"
IF "!_Webroot_result!"=="NOK" ECHO !_computer!>>"!_NEEDS_attentionfile!"
REM IF "!_Webroot_result!"=="NOK" FOR /F "tokens=* delims=" %%A IN ('FIND /I /C "!_computer!" !_NEEDS_attentionfile!') DO IF %%A==0 (ECHO !_computer!>>"!_NEEDS_attentionfile!)
ECHO         ^<td width="100"^> Webroot Exist ^</td^> >>!_legend!
IF !_mode!==up IF "!_Webroot_result!"=="OK" (ECHO         ^<td width="100"^>^<div align="center"^>!_ok!^</div^>^</td^> >>%_table%) ELSE (ECHO         ^<td width="100"^>^<div align="center"^>!_nok!^</div^>^</td^> >>%_table%) 
IF !_mode!==down ECHO         ^<td width="100"^>^<div align="center"^> NA ^</div^>^</td^> >>%_table%
ECHO !_Webroot_result!
SET _separator=***** End ************************************************************
ECHO !_separator:~0,70!
ECHO.
)





:: check_dn ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_dn" "settings.cfg"') DO IF %%A==0 (ECHO check_dn^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_dn" "settings.cfg"') DO (SET _check_dn=%%A)
IF !_check_dn!==yes (
SET _separator=***** Dn ***********************************************************
ECHO !_separator:~0,70!
SET /A _colspan+=1
SET _dn=NA
FOR /F "tokens=1 delims=" %%A IN ('dsquery computer -name !_computer! ^| dsget computer -dn ^|FIND /I /V "dsget succeeded"^|FIND /I /V "distinguishedName"') DO (SET _dn=%%A)
ECHO         ^<td width="800"^> Dn ^</td^> >>!_legend!
ECHO         ^<td width="800"^> !_dn! ^</td^> >>!_table!
ECHO Dn=!_dn!
SET _separator=***** End ************************************************************
ECHO !_separator:~0,70!
ECHO.
)

::check_profiles ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_profiles" "settings.cfg"') DO IF %%A==0 (ECHO check_profiles^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_profiles" "settings.cfg"') DO (SET _check_profiles=%%A)
IF !_check_profiles!==yes ( 
SET _separator=***** Checking profiles on !_computer! c$ *******************************
ECHO !_separator:~0,70!
SET /A _colspan+=1
SET _profiles=NA
ECHO.
IF NOT EXIST "%~dp0Files\Profiles" MD "%~dp0Files\Profiles"
IF !_mode!==up (IF EXIST "\\!_computer!.!_dnssuffix!\c$\users\*.*" DIR /B "\\!_computer!.!_dnssuffix!\c$\users\*.*"|FIND /I /V "Administrator"|FIND /I /V "Public"|FIND /I /V "da_">Files\Profiles\!_computer!_profiles.txt
IF EXIST "\\!_computer!.!_dnssuffix!\c$\Documents and Settings\*.*" DIR /B "\\!_computer!.!_dnssuffix!\c$\Documents and Settings\*.*"|FIND /I /V "Administrator"|FIND /I /V "Public"|FIND /I /V "da_">Files\Profiles\!_computer!_profiles.txt
)
ECHO Profiles Done
SET _profiles=Done
ECHO.
ECHO         ^<td width="100"^> Profiles ^</td^> >>!_legend!
IF EXIST Files\Profiles\!_computer!_profiles.txt (ECHO         ^<td width="100"^>^<a href="files\Profiles\!_computer!_profiles.txt"^> Profiles^</a^>^</td^> >>%_table%) ELSE (ECHO         ^<td width="100"^>^<div align="center"^> NA ^</div^>^</td^> >>%_table%)
SET _header=!_header!,Profiles
SET _result=!_result! !_profiles!
SET _separator=***** End  *********************************************************
ECHO !_separator:~0,70!
ECHO.
)


::check_access ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_access" "settings.cfg"') DO IF %%A==0 (ECHO check_access^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_access" "settings.cfg"') DO (SET _check_access=%%A)
IF !_check_access! == yes (
SET _separator=***** Checking Access **************************************************
ECHO !_separator:~0,70!
SET /A _colspan+=1
SET _access=NA
ECHO.
ECHO        ^<td width="200"^> Access ^</td^> >>!_legend!
IF !_mode!==up (IF EXIST "\\!_computer!.!_dnssuffix!\c$\*.*" (ECHO Access to !_computer!&SET _access=yes) ELSE (ECHO No Access to !_computer!&SET _access=no)
IF "!_access!" == "no" ECHO NO ACCESS to !_computer!\C$ !DATE! !TIME!>>Files\NO_ACCESS.log
IF "!_access!"=="yes" (ECHO         ^<td width="100"^>^<div align="center"^>!_ok!^</div^>^</td^> >>%_table%) ELSE (ECHO         ^<td width="100"^>^<div align="center"^>!_nok!^</div^>^</td^> >>%_table%) 
)
IF !_mode!==down ECHO         ^<td width="100"^>^<div align="center"^> NA ^</div^>^</td^> >>%_table%
SET _header=!_header!,Profiles
SET _result=!_result! !_profiles!
SET _separator=***** End  *********************************************************
ECHO !_separator:~0,70!
ECHO.
)

:: check_net ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "check_net" "settings.cfg"') DO IF %%A==0 (ECHO check_net^=no>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "check_net" "settings.cfg"') DO (SET _check_net=%%A)
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
FOR /F "tokens=2 delims=[]" %%j in ('PING -n 1 !_computer!^|FINDSTR "Pinging"') do SET _string=%%j
FOR /F "tokens=1,2,3,4 delims=." %%j in ("!_string!") do SET _A=%%j& SET _B=%%k& SET _C=%%l& SET _D=%%m
ECHO Got ip=!_A!.!_B!.!_C!.!_D!

REM Arendal
IF /I !_A! EQU 192 IF /I !_B! EQU 168 IF /I !_C! EQU 224 IF /I !_D! GEQ 0 SET _network=PAGO_224
IF /I !_A! EQU 192 IF /I !_B! EQU 168 IF /I !_C! EQU 226 IF /I !_D! GEQ 0 SET _network=PAGO_226
IF /I !_A! EQU 10 IF /I !_B! EQU 46 IF /I !_C! EQU 46 IF /I !_D! GEQ 0 SET _network=PAGO_46

REM Gent
IF /I !_A! EQU 192 IF /I !_B! EQU 168 IF /I !_C! EQU 230 IF /I !_D! GEQ 0 SET _network=PAGE_230
IF /I !_A! EQU 192 IF /I !_B! EQU 168 IF /I !_C! EQU 231 IF /I !_D! GEQ 0 SET _network=PAGE_231

REM Simrishamn
IF /I !_A! EQU 192 IF /I !_B! EQU 168 IF /I !_C! EQU 218 IF /I !_D! GEQ 0 SET _network=PASI_218

REM Raufoss
IF /I !_A! EQU 192 IF /I !_B! EQU 168 IF /I !_C! EQU 225 IF /I !_D! GEQ 0 SET _network=PARA_225

REM Offline
IF /I !_A! EQU NA IF /I !_B! EQU NA IF /I !_C! EQU NA IF /I !_D! GEQ NA SET _network=NA

IF /I !_A! EQU 192 IF /I !_B! EQU 168 IF /I !_C! EQU 115 IF /I !_D! GEQ 0 SET _network=Hässleholm PC
IF /I !_A! EQU 172 IF /I !_B! EQU 23 IF /I !_C! EQU 1 IF /I !_D! GEQ 0 SET _network=Marieholm PC
IF /I !_A! EQU 172 IF /I !_B! EQU 24 IF /I !_C! EQU 1 IF /I !_D! GEQ 0 SET _network=Almedal PC
IF /I !_A! EQU 172 IF /I !_B! EQU 24 IF /I !_C! EQU 49 IF /I !_D! GEQ 0 SET _network=Webland Hosting PC
IF /I !_A! EQU 172 IF /I !_B! EQU 24 IF /I !_C! EQU 231 IF /I !_D! GEQ 0 SET _network=VPN PC
IF /I !_A! EQU 172 IF /I !_B! EQU 24 IF /I !_C! EQU 232 IF /I !_D! GEQ 0 SET _network=WIFI-guest PC
IF /I !_A! EQU 10 IF /I !_B! EQU 230 IF /I !_C! EQU 100 IF /I !_D! GEQ 0 SET _network=Otterhällan Tele
IF /I !_A! EQU 10 IF /I !_B! EQU 230 IF /I !_C! EQU 103 IF /I !_D! GEQ 0 SET _network=Landskrona Tele
IF /I !_A! EQU 10 IF /I !_B! EQU 230 IF /I !_C! EQU 105 IF /I !_D! GEQ 0 SET _network=Malmö Tele
IF /I !_A! EQU 10 IF /I !_B! EQU 230 IF /I !_C! EQU 106 IF /I !_D! GEQ 0 SET _network=Stockholm Tele
IF /I !_A! EQU 10 IF /I !_B! EQU 230 IF /I !_C! EQU 107 IF /I !_D! GEQ 0 SET _network=Marieholm Tele
IF /I !_A! EQU 10 IF /I !_B! EQU 230 IF /I !_C! EQU 108 IF /I !_D! GEQ 0 SET _network=Högsbo BC Tele
IF /I !_A! EQU 10 IF /I !_B! EQU 230 IF /I !_C! EQU 109 IF /I !_D! GEQ 0 SET _network=Almedal Tele

ECHO Network=!_network!
ECHO !_computer!	!_A!.!_B!.!_C!.!_D!>>"Files\!_network!.log"
IF !_check_net! == yes ECHO        ^<td width="200"^> IPadress ^</td^> >>%_legend%
IF !_check_net! == yes ECHO        ^<td width="200"^> Network ^</td^> >>%_legend%
IF !_check_net! == yes ECHO        ^<td width="200"^> !_A!.!_B!.!_C!.!_D! ^</td^> >>%_table%
IF !_check_net! == yes IF EXIST "Files\!_network!.log" (ECHO         ^<td width="200"^>^<a href="Files\!_network!.log"^> !_network!^</a^>^</td^> >>%_table%) ELSE (ECHO         ^<td width="200"^> !_network! ^</td^> >>%_table%)
ECHO.
SET _header=!_header!,Network
SET _result=!_result! !_network!
SET _separator=***** End checking net on !_computer! ************************************************
ECHO !_separator:~0,70!
ECHO.
)
)

:output
SET _separator=***** Creating output *********************************************************
ECHO !_separator:~0,70!

::refresh html 30sec ; Values yes/no
FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "refresh30sec" "settings.cfg"') DO IF %%A==0 (ECHO refresh30sec^=yes>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "refresh30sec" "settings.cfg"') DO (SET _refresh30sec=%%A)
REM ECHO "!_countnr!"=="!_counttotal!"
IF "!_countnr!"=="!_counttotal!" SET _refresh30sec=no

FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "title" "settings.cfg"') DO IF %%A==0 (ECHO title^=Verify Servers>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "title" "settings.cfg"') DO (SET _title=%%A)

REM Create Top

ECHO ^<html^> >!_topname!
ECHO   ^<head^> >>!_topname!
ECHO	^<title^>!_title! Verify Servers^</title^> >>!_topname!
IF !_refresh30sec! == yes ECHO	^<meta http-equiv="refresh" content="5"^> >>!_topname!
ECHO	^<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"^>^<style type="text/css"^> >>!_topname!
ECHO body { >>!_topname!
ECHO 	background-color: #ffffff; >>!_topname!
ECHO } >>!_topname!
ECHO h1 {>>!_topname!
ECHO     color: #00FF00;>>!_topname!
ECHO     text-shadow: 1px 1px #000000;>>!_topname!
ECHO }>>!_topname!
ECHO h2 {>>!_topname!
ECHO     color: #FF0000;>>!_topname!
ECHO     text-shadow: 1px 1px #000000;>>!_topname!
ECHO }>>!_topname!
ECHO p1 {>>!_topname!
ECHO     color: #00FF00;>>!_topname!
ECHO     font-weight: bold;>>!_topname!
ECHO     font-size:20px;>>!_topname!
ECHO }>>!_topname!
ECHO p2 {>>!_topname!
ECHO     color: #FF0000;>>!_topname!
ECHO     font-weight: bold;>>!_topname!
ECHO     font-size:20px;>>!_topname!
ECHO }>>!_topname!

ECHO TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}>>!_topname!
ECHO TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}>>!_topname!
ECHO TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}>>!_topname!
ECHO .odd  { background-color:#ffffff; }>>!_topname!
ECHO .even { background-color:#dddddd; }>>!_topname!

ECHO ^</style^>^</head^> >>!_topname!
ECHO   ^<body background="#ffffff"^> >>!_topname!
ECHO     ^<table border="1" cellspacing="0"^> >>!_topname!
ECHO        ^<tr bgcolor="#ffffff"^> >>!_topname!
IF NOT EXIST "Files\offline.log" ECHO         ^<td colspan="!_colspan!"^>^<div align="center"^>^<a href="Files\online.log"^>Online ^</a^>Computers %title% %_zon%^</div^>^</td^> >>!_topname!
IF EXIST "Files\offline.log" ECHO         ^<td colspan="!_colspan!"^>^<div align="center"^>^<a href="Files\online.log"^>Online ^</a^>Computers %title% Filetime=%filetime% ^<a href="Files\offline.log"^> Offline^</a^>^</div^>^</td^> >>!_topname!
ECHO        ^</tr^> >>!_topname!
ECHO        ^<tr bgcolor="#ffffff"^> >>!_topname!
ECHO         ^<td colspan="!_colspan!"^>Start !_starttime!^</td^> >>!_topname!
ECHO        ^</tr^> >>!_topname!
ECHO        ^</tr^>>>!_legend! 
ECHO        ^</tr^> >>!_table!
)

SET _count_online=0
SET _count_offline=0
IF EXIST "Files\online.log" FOR /F "usebackq" %%i IN ("Files\online.log") DO (SET /A _count_online+=1)
IF EXIST "Files\offline.log" FOR /F "usebackq" %%i IN ("Files\offline.log") DO (SET /A _count_offline+=1)

REM Create End
ECHO        ^<tr bgcolor="#ffffff"^> >!_endname!
ECHO         ^<td colspan="!_colspan!"^>Stop %date% %time%^</td^> >>!_endname!
ECHO        ^</tr^> >>!_endname!
ECHO        ^<tr bgcolor="#ffffff"^>>>!_endname!
ECHO         ^<td colspan="!_colspan!"^>^<div align="center"^>Script created and maintained by ^<a href='mailto:dennis.knutsson@plastal.com^&subject^=Verify_server_script'^>Dennis Knutsson^</a^> (DKN) ^</div^>^</td^>>>!_endname!
ECHO        ^</tr^>>>!_endname!
ECHO        ^<tr bgcolor="#ffffff"^>>>!_endname!
ECHO         ^<td colspan="!_colspan!"^>^<div align="center"^>Online=!_count_online! Offline=!_count_offline! ^</div^>^</td^>>>!_endname!
ECHO        ^</tr^>>>!_endname!
ECHO        ^<tr bgcolor="#ffffff"^>>>!_endname!
ECHO         ^<td colspan="!_colspan!"^>^<div align="center"^>Todo? Please mail me suggestions ^</div^>^</td^>>>!_endname!
ECHO        ^</tr^>>>!_endname!
ECHO      ^</table^>>>!_endname!
ECHO ^</body^>>>!_endname!
ECHO ^</html^>>>!_endname!



FOR /F "tokens=3 delims=: " %%A IN ('FIND /I /C "outputfilename" "settings.cfg"') DO IF %%A==0 (ECHO outputfilename^=index.html>>settings.cfg)
FOR /F "tokens=2 delims=^=" %%A IN ('FIND /I "outputfilename" "settings.cfg"') DO (SET _outputfilename=%%A)
COPY "Files\top.html" +"Files\legend.html" +"Files\table.html" +"Files\end.html" "!_outputfilename!" >NUL

SET _separator=***** End script *************************************************************
ECHO !_separator:~0,70!

)
ENDLOCAL
:End
IF EXIST pause.txt PAUSE
