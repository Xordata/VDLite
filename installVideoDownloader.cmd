@echo off
%~d0&cd %~p0
set "RELEASE=20251221L"
:: https://github.com/Xordata/VDLite
set "APPNAME=VideoDownloader"
set "SETFILE=%~d0%~p0%APPNAME%Settings.cmd"
title Video DownLoader // (c) f@xor.world 2025 // %RELEASE%
set "NAME=%%(title)s.%%(ext)s"
set "DOWNLOADLIMIT=2.9M"
set "DLA=ffmpeg-master-latest-win64-gpl-shared"&set "DLB=deno-x86_64-pc-windows-msvc"&set "DLC=nodpi_v2.0.1_win64"
set "DELAYCLOSE=10"
set DEBUG=0
set "LNG="
for /f "tokens=2 delims==" %%a in ('wmic os get locale /value') do set "LCID=%%a"
if exist "%SETFILE%" (CALL %SETFILE%&SET "LOADEDSET=%_colors%%QUALITY%%EXTFORMAT%%QUIET%%LNG%") else (set _colors=0&set QUALITY=1)
if "%LNG%" equ "" (if "%LCID%"=="0419" (set "LNG=1") else (set "LNG=0")) 
call :SETCOLORSCHEME
color %_consbase%&cls
call :i18n 99
if "%EXTFORMAT%"=="" (set "EXTFORMAT=0") 
if "%QUIET%"=="" (set "QUIET=1")
if %QUALITY% gtr 5 (set "QUALITY=4")
if %QUALITY% lss 1 (set "QUALITY=1") 
if "%LCID%"=="0419" (set PROXY=127.0.0.1:8881)
FOR /F "tokens=*" %%V IN ('pwsh -Command "Write-Output $PSVersionTable.PSVersion.Major"') DO SET PS_VER=%%V
if "%PS_VER%"=="" (FOR /F "tokens=*" %%V IN ('powershell -Command "Write-Output $PSVersionTable.PSVersion.Major"') DO SET PS_VER=%%V)
if not "%~n0.cmd" == "install%APPNAME%.cmd" (goto :RUN)
call :HISTORY
MODE CON COLS=132 LINES=25
color %_consbase%&cls
call :i18n 98
if "%PS_VER%"=="7" (goto :NOPSUPDATE)
call :i18n 97
choice /C "CNYá­‘" /N /T 60 /D C /M "Press [C] or [N] to continue (no update performed) or press [Y] to install. Autoanswer is [N]"
if "%ERRORLEVEL%"=="3" (winget install Microsoft.PowerShell --source winget)

:NOPSUPDATE
if exist "%APPNAME%.ico" (goto :NOUNPACK) 
for /f "tokens=1-4 delims=:" %%H IN ('findstr /B /O /N ^"@@@===@@@^" %~f0') do (
	powershell -Command "$SF='%~f0'; $DF='%APPNAME%.ico'; $Offs=%%I+10; $Len=0; $FSIn=New-Object System.IO.FileStream($SF, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read); $FSOut=New-Object System.IO.FileStream($DF, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write); if ($Len -le 0) {$Len=$FSIn.Length-$Offs}; $FSIn.Seek($Offs, [System.IO.SeekOrigin]::Begin) | Out-Null; $Buffer=New-Object byte[] 4096; $Read=0; while (($Read=$FSIn.Read($Buffer, 0, [System.Math]::Min($Buffer.Length, $Len))) -gt 0) {$FSOut.Write($Buffer, 0, $Read); $Len-=$Read}; $FSIn.Dispose(); $FSOut.Dispose()" 
	powershell -Command "$P='%~f0'; $D='%~p0\%APPNAME%.dat'; $O=0; $S=%%I; $L=$S-$O; $b=Get-Content -Path $P -Encoding Byte -TotalCount ($S) | Select-Object -Skip $O; [System.IO.File]::WriteAllBytes($D,$b)"
)
for /f "tokens=1-4 delims=:" %%H IN ('findstr /B /O /N ^"@DOWNLOAD@^" %~p0\%APPNAME%.dat') do (
	powershell -Command "$SF='%~p0\%APPNAME%.dat'; $DF='%APPNAME%.ps1'; $Offs=%%I+10; $Len=0; $FSIn=New-Object System.IO.FileStream($SF, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read); $FSOut=New-Object System.IO.FileStream($DF, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write); if ($Len -le 0) {$Len=$FSIn.Length-$Offs}; $FSIn.Seek($Offs, [System.IO.SeekOrigin]::Begin) | Out-Null; $Buffer=New-Object byte[] 4096; $Read=0; while (($Read=$FSIn.Read($Buffer, 0, [System.Math]::Min($Buffer.Length, $Len))) -gt 0) {$FSOut.Write($Buffer, 0, $Read); $Len-=$Read}; $FSIn.Dispose(); $FSOut.Dispose()" 
	powershell -Command "$P='%~p0\%APPNAME%.dat'; $D='%~p0\%APPNAME%.cmd'; $O=0; $S=%%I; $L=$S-$O; $b=Get-Content -Path $P -Encoding Byte -TotalCount ($S) | Select-Object -Skip $O; [System.IO.File]::WriteAllBytes($D,$b)"
)

:NOUNPACK
set "QUALITY=3"&set "EXTFORMAT=0"&set "QUIET=1"&call :SETSCHEME e
del %~p0\%APPNAME%.dat >nul 2>nul
%~p0\%APPNAME%.cmd&exit

:RUN
if exist "install%APPNAME%.cmd" (
	powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut([Environment]::GetFolderPath(\"Desktop\") + \"\%APPNAME%.lnk\"); $s.TargetPath = \"%~f0\"; $s.IconLocation = \"%~d0%~p0%APPNAME%.ico\"; $s.Save()
	del install%APPNAME%.cmd >nul 2>nul
)
if not exist "yt-dlp.exe" (call :CHECKPROXY & call :UPDATE nope)
set "d1= "&set "d2= "&set "d3= "&set "d4= "
call :GETYVERSION

:MENU
if "%DEBUG%"=="1" (set "d1=%QUALITY%"&set "d2=%_colors%"&set "d3=%QUIET%"&set "d4=%EXTFORMAT%")
if "%LNG%"=="1" (set "_g=(%_hks%rus%_hke%)/eng") else (set "_g=rus/(%_hks%eng%_hke%)")
MODE CON COLS=52 LINES=21&color %_consbase%&cls
echo.
echo %_hlm%      Any Audio ^& Video downloader %_hks%%RELEASE%        
echo.
call :i18n 1
choice /C "XUAVQHCLMGç£ä¬©àá«ì¯—ƒ”Œ‰‘‹œ" /N /M "" >nul 2>nul
set _err=%ERRORLEVEL%
if %_err% gtr 10 (set /A "_err-=10")
if %_err% gtr 10 (set /A "_err-=10")
if %_err%==2 (cls&call :UPDATE)
if %_err%==3 (goto :AUDIO)
if %_err%==4 (goto :VIDEO)
if %_err%==5 (set /A "QUALITY+=1"&if %QUALITY% gtr 3 (set "QUALITY=1"))
if %_err%==6 (call :HISTORY)
if %_err%==7 (call :SETSCHEME)
if %_err%==8 (if "%QUIET%"=="1" (set "QUIET=0") else (set "QUIET=1"))
if %_err%==9 (if "%EXTFORMAT%"=="1" (set "EXTFORMAT=0") else (set "EXTFORMAT=1"))
if %_err%==10 (set /A "LNG+=1"&if %LNG% gtr 0 (set "LNG=0"))
if not %_err%==1 (goto :MENU)
if not "%_colors%%QUALITY%%EXTFORMAT%%QUIET%%LNG%"=="%LOADEDSET%" (echo set ^"_colors=%_colors%^" ^& set ^"QUALITY=%QUALITY%^" ^& set ^"EXTFORMAT=%EXTFORMAT%^" ^& set ^"QUIET=%QUIET%^" ^& set ^"LNG=%LNG%^">%SETFILE%)
MODE CON COLS=132 LINES=9000&title&color&cls
goto :EOF

:SETSCHEME
if "%1"=="e" (set "_colors=0") else (set /A "_colors+=1")
if "%_colors%" == "3" set "_colors=0"
if "%1"=="e" exit /b 0
goto :SETCOLORSCHEME

:AUDIO
set "MODE=-t mp3"&set TXT=audio&set QUANAME=
goto :DOWNLOAD

:VIDEO
SET TXT=video&goto :QUALITY%QUALITY%

:QUALITY1
set "MODE="&set QUANAME= in %_hks%best quality%_hke%&goto :DOWNLOAD
:QUALITY2
set MODE=-f ^"bv*^[height^<=720^]+ba^/b^[height^<=720^] / wv*+ba/w^"&set "QUANAME=/%_hks%720p%_hke%"&goto :DOWNLOAD
:QUALITY3
set MODE=-f ^"bv*^[height^<=1080^]+ba^/b^[height^<=1080^] / wv*+ba/w^"&set "QUANAME=/%_hks%1080p%_hke%"&goto :DOWNLOAD
:QUALITY4
set MODE=-f ^"bv*^[height^<=360^]+ba^/b^[height^<=360^] / wv*+ba/w^"&set "QUANAME=/%_hks%360p%_hke%"&goto :DOWNLOAD

:DOWNLOAD
MODE CON COLS=128 LINES=20&color %_consbase%&cls
call :i18n 2
set /p URL=%_ce%%_pc%]
if "%URL%"=="" (goto :MENU)
if "%_colors%"=="2" (echo.) else (echo %_hlm%)
call :ExtractDomain DOMAIN "%URL%"
if "%TXT%"=="audio" (set OUTDIR=%USERPROFILE%\Music\%DOMAIN%) else (set OUTDIR=%USERPROFILE%\Videos\%DOMAIN%)
call :i18n 3
if not exist "%OUTDIR%" (mkdir "%OUTDIR%")
call :CHECKPROXY
if "%_colors%"=="2" (echo.) else (echo %_ce%%_pc%%_co%)
set "ADD="
if "%QUIET%"=="1" (set "ADD=%ADD%-q ") else (set  "ADD=%ADD%--no-quiet ")
if "%EXTFORMAT%"=="1" (set "ADD=%ADD%-S ext:mp4:m4a --recode mp4 --merge-output-format mp4 ")
if not "%PROXY%"=="" (set "ADD=%ADD% --proxy %PROXY% ")
yt-dlp --no-config-locations --js-runtimes deno:deno --ffmpeg-location ffmpeg-master-latest-win64-gpl-shared\bin -4 --no-playlist --limit-rate "%DOWNLOADLIMIT%" --hls-use-mpegts --windows-filenames --no-warnings --no-colors --no-overwrites --no-write-comments --no-cache-dir --no-check-certificates --prefer-free-formats --write-subs --embed-thumbnail --embed-metadata --embed-chapters --no-update --no-config -P "%OUTDIR%" -o "%NAME%" %MODE% %ADD% --progress --no-write-info-json --print title --print duration_string --no-simulate -- "%URL%"
set "URL="
call :DELAY
goto DOWNLOAD

:ExtractDomain
SET "TempURL=%~2"
SET "TempURL=%TempURL:https://=%"
SET "TempURL=%TempURL:http://=%"
SET "TempURL=%TempURL:www.=%"
FOR /F "tokens=1 delims=/" %%A IN ("%TempURL%") DO (SET "%1=%%A")
exit /b 0

:UPDATE
color %_consbase%
if not exist "ffmpeg-master-latest-win64-gpl-shared\bin\ffmpeg.exe" (
	call :i18n 4
	call :ARIA https://github.com/BtbN/FFmpeg-Builds/releases/download/latest %DLA%.zip %TEMP%
	call :UNZIP . %DLA%.zip
	del %TEMP%\%DLA%.zip >nul 2>nul
)
if not exist "deno" (mkdir deno >nul)
if not exist "deno\deno.exe" (
	call :i18n 5
	call :ARIA https://github.com/denoland/deno/releases/latest/download %DLB%.zip %TEMP%
	call :UNZIP deno %DLB%.zip
	del %TEMP%\%DLB%.zip >nul 2>nul
)
call :i18n 6
if exist "yt-dlp.exe" (del yt-dlp.exe >nul)
call :ARIA https://github.com/yt-dlp/yt-dlp/releases/latest/download yt-dlp.exe .
call :GETYVERSION
if "%1"=="nope" exit /b

:DELAY
call :i18n 7
call :i18n 8
choice /C "CX‘—áç" /N /T %DELAYCLOSE% /D C /M "" >nul 2>nul&exit /b 0

:GETYVERSION
FOR /F "tokens=*" %%V IN ('yt-dlp --version') DO SET _y=%%V
exit /b 0

:ARIA
if "%PS_VER%"=="5" (powershell.exe -Command "Invoke-WebRequest -Uri \"%1/%2\" -OutFile \"%3\\%2\"") else (pwsh.exe -ExecutionPolicy Bypass -File %APPNAME%.ps1 "%1" "%2" "%3")
exit /b 0

:UNZIP
powershell.exe -Command "Expand-Archive -Path \"%TEMP%\%2\" -DestinationPath \"%1\" -Force"&exit /b 0

:CHECKPROXY
if "%PROXY%"=="" (exit /b)
set PROXYPRESENT=0&set PORT_NUM=0&for /F "tokens=2 delims=:" %%P in ("%PROXY%") do (set PORT_NUM=%%P)
FOR /F "tokens=*" %%G IN ('netstat -ano ^| findstr ":%PORT_NUM%" ^| findstr "LISTENING"') do set PROXYPRESENT=1
if not "%PROXYPRESENT%"=="1" (call :NODPI)
exit /b 0

:NODPI
if "%PROXY%"=="" (exit /b)
if not exist "nodpi.exe" (
	call :i18n 9
	call :ARIA https://github.com/GVCoder09/NoDPI/releases/download/v2.0.1/ %DLC%.zip %TEMP%
	call :UNZIP . %DLC%.zip
	del %TEMP%\%DLC%.zip >nul 2>nul
)
start /min /d . nodpi.exe --port %PORT_NUM%
exit /b 0

:SETCOLORSCHEME
set ESC=
set "_co=%ESC%[?25l"&set "_ce=%ESC%[?25h"&if "%_colors%" == "" (set "_colors=0")
if "%_colors%" == "1" (
	set "_consbase=0F"&set "_head=%ESC%[30;107m"&set "_hks=%ESC%[31m"&set "_filler=%ESC%[47;40m"
	set "_pbg=%ESC%[37;47m"&set "_pbc=%ESC%[37m"&set "_hke=%ESC%[30m"
	set "_hr=%ESC%[30;100m"&set "_hl=%ESC%[37;100m"&set "_hlm=%ESC%[37;100m"
	set "_pc=%ESC%[97;40m"&set "_fd=%ESC%[31m"&set "_oc=%ESC%[30;41m"
)
if "%_colors%" == "2" (
	set "_consbase=02"&set "_head="&set "_hks="&set "_filler="
	set "_pbg=%ESC%[40;32m"&set "_pbc="&set "_hke="
	set "_hr="&set "_hl="&set "_hlm="
	set "_pc="&set "_fd="&set "_oc=%ESC%[42;30m"
)
if "%_colors%" == "0" (
	set "_consbase=1F"&set "_head=%ESC%[30;107m"&set "_hks=%ESC%[31m"&set "_filler=%ESC%[97;44m"&set "_pbg=%ESC%[41;104m"&set "_pbc=%ESC%[37m"&set "_hke=%ESC%[97m"
	set "_hr=%ESC%[97;104m"&set "_hl=%ESC%[31;107m"&set "_hlm=%ESC%[30;107m"&set "_pc=%ESC%[97;44m"&set "_fd=%ESC%[32m"&set "_oc=%ESC%[47;101m"
)
exit /b

:HISTORY
echo %_filler%&MODE CON COLS=81 LINES=28&set InBlock=0&set LineNum=0
for /F "usebackq delims=" %%i IN ("%~f0") do (if not %InBlock% == 2 (call :PRINT "%%i")) 
call :i18n 10&pause>nul&exit /b 0

:PRINT
set /A "LineNum+=1"
if %LineNum% leq 284 (exit /b 0)
if %1=="@DOWNLOAD@" (set "InBlock=2")
if "%InBlock%"=="1" call :PRINT2 %1 
if %1=="@CHANGELOG@" (set "InBlock=1")
exit /b 0

:PRINT2
set "char=%~1"
set "char=%char:~0,1%"
if "%~1" == "." (echo.) else (if "%char%" == "=" (echo %_pbg%%_hke%  %~1%ESC%[K%_pbc%) else (echo %_filler%  %~1))
exit /b

:i18n
if "%LNG%"=="1" GOTO n0419
if not %1 equ 1 (goto i18ns1)
if "%QUALITY%" == "1" (set "_z=(%_hks%max%_hke%)/1080/720/360")
if "%QUALITY%" == "2" (set "_z=max/(%_hks%1080%_hke%)/720/360")
if "%QUALITY%" == "3" (set "_z=max/1080/(%_hks%720%_hke%)/360")
if "%QUALITY%" == "4" (set "_z=max/1080/720/(%_hks%360%_hke%)")
if "%_colors%" == "0" (set "_c=(%_hks%color%_hke%)/bwr/crt")
if "%_colors%" == "1" (set "_c=color/(%_hks%bwr%_hke%)/crt")
if "%_colors%" == "2" (set "_c=color/bwr/(crt)")
if "%QUIET%" == "0" (set "_q=enabled ") else (set "_q=disabled")
if "%EXTFORMAT%"=="1" (set "_f=best/(%_hks%mp4%_hke%)") else (set "_f=(%_hks%best%_hke%)/mp4")
echo %_filler%   %_hlm%   [ ACTION ]                                 
echo %_filler%   %_hr%  [%_hks%V%_hke%] - Download video                        
echo %_filler%   %_hr%  [%_hks%A%_hke%] - Download audio                        
echo.
echo %_filler%   %_hlm%   [ Options ]                                
echo %_filler%   %_hr%  [%_hks%Q%_hke%] - Prefer quality %_z%  %d1%  
echo %_filler%   %_hr%  [%_hks%C%_hke%] - Cnange %_c% scheme      %d2%  
echo %_filler%   %_hr%  [%_hks%L%_hke%] - Display progess is %_hks%%_q%%_hke%        %d3%  
echo %_filler%   %_hr%  [%_hks%M%_hke%] - Try to download as %_f%      %d4%  
echo %_filler%   %_hr%  [%_hks%G%_hke%] - language %_g%                  %d5%  
echo.
echo %_filler%   %_hlm%   [ Others ]                                 
echo %_filler%   %_hr%  [%_hks%U%_hke%] - Update engine             %_hks%%_y%%_hke%  
echo %_filler%   %_hr%  [%_hks%H%_hke%] - History ^& changelog                   
echo %_filler%   %_hr%  [%_hks%X%_hke%] - Exit                                  
echo.
echo %_hlm%%_co%              What you want %_hks%to do%_hlm% ?                 
exit /b 0
:i18ns1
if %1 equ 2 (echo %_pbg%%_hke% Paste %_hks%URL%_hke% here for download %_hks%%TXT%%_hke%%QUANAME% or press [%_hks%Enter%_hke%] to return in main menu%ESC%[K)
if %1 equ 3 (echo Download %TXT% to [%_fd%%OUTDIR%%_hlm%]%ESC%[K%_hr%)
if %1 equ 4 (echo Download %DLA%%ESC%[K)
if %1 equ 5 (echo Download %DLB%%ESC%[K)
if %1 equ 6 (echo %_hl% Download or update YT-DLP%ESC%[K%_filler%)
if %1 equ 7 (echo %_oc% Download completed%ESC%[K)
if %1 equ 8 (echo %_pbg%%_hke% Press [C] to continue%ESC%[K)
if %1 equ 9 (echo Download %DLC%%ESC%[K)
if %1 equ 10 (echo %_pbg%%_hke% Hit [C] to continue%ESC%[K%_co%)
if %1 equ 97 (echo "Detected powershell v5 installed. Do you want update to powershell v7? (this optional, but recomended)")
if %1 equ 98 (echo Please wait while setup is processing ....)
if %1 equ 99 (echo %_hlm%%_hks%Initializing%_hke%%_hlm%, please be patient ....%ESC%[K%_filler%%_co%) 
exit /b
:n0419
if not %1 equ 1 (goto i18ns1r)
if "%QUALITY%" == "1" (set "_z=(%_hks%¨áå®¤­®¥%_hke%)/1080/720/360")
if "%QUALITY%" == "2" (set "_z=¨áå®¤­®¥/(%_hks%1080%_hke%)/720/360")
if "%QUALITY%" == "3" (set "_z=¨áå®¤­®¥/1080/(%_hks%720%_hke%)/360")
if "%QUALITY%" == "4" (set "_z=¨áå®¤­®¥/1080/720/(%_hks%360%_hke%)")
if "%_colors%" == "0" (set "_c=(%_hks%æ¢¥â%_hke%)/ç¡ª/¬®­¨â®à")
if "%_colors%" == "1" (set "_c=æ¢¥â/(%_hks%ç¡ª%_hke%)/¬®­¨â®à")
if "%_colors%" == "2" (set "_c=æ¢¥â/ç¡ª/(¬®­¨â®à)")
if "%QUIET%" == "0" (set "_q=¤  ") else (set "_q=­¥â")
if "%EXTFORMAT%"=="1" (set "_f=¨áå®¤­®¥/(%_hks%mp4%_hke%)") else (set "_f=(%_hks%¨áå®¤­®¥%_hke%)/mp4")
echo %_filler%   %_hlm%   [ „…‰‘’‚ˆŸ ]                               
echo %_filler%   %_hr%  [%_hks%V%_hke%] - ‘ª ç âì ¢¨¤¥®                         
echo %_filler%   %_hr%  [%_hks%A%_hke%] - ‘ª ç âì  ã¤¨®                         
echo.
echo %_filler%   %_hlm%   [  áâà®©ª¨ ]                              
echo %_filler%   %_hr%  [%_hks%Q%_hke%] - Š ç¥áâ¢® %_z%   %d1%  
echo %_filler%   %_hr%  [%_hks%C%_hke%] - –¢¥â®¢ ï áå¥¬  %_c%  %d2%  
echo %_filler%   %_hr%  [%_hks%L%_hke%] - ®ª § âì ¯à®£à¥áá %_hks%%_q%%_hke%              %d3%  
echo %_filler%   %_hr%  [%_hks%M%_hke%] - ëâ âìáï áª ç âì %_f%    %d4%  
echo %_filler%   %_hr%  [%_hks%G%_hke%] - language %_g%                  %d5%  
echo.
echo %_filler%   %_hlm%   [ Others ]                                 
echo %_filler%   %_hr%  [%_hks%U%_hke%] - Ž¡­®¢¨âì ª®¬¯®­¥­âë       %_hks%%_y%%_hke%  
echo %_filler%   %_hr%  [%_hks%H%_hke%] - ˆáâ®à¨ï à §¢¨â¨ï ( ­£«.)              
echo %_filler%   %_hr%  [%_hks%X%_hke%] - ‚ëå®¤                                 
echo.
echo %_hlm%%_co%         ‚ë¡¥à¨â¥ â®, çâ® %_hks%¡ã¤¥¬ ¤¥« âì%_hlm% ?            
exit /b 0
:i18ns1r
if %1 equ 2 (echo %_pbg%%_hke% ‚áâ ¢ìâ¥ %_hks%URL%_hke% §¤¥áì ¤«ï § £àã§ª¨ %_hks%%TXT%%_hke%%QUANAME% ¨«¨ ­ ¦¬¨â¥ [%_hks%Enter%_hke%] ¤«ï ¢ëå®¤  ¢ ¬¥­î%ESC%[K)
if %1 equ 3 (echo ‘®åà ­ï¥¬ %TXT% ¢ ¯ ¯ªã [%_fd%%OUTDIR%%_hlm%]%ESC%[K%_hr%)
if %1 equ 4 (echo ‘ª ç¨¢ ¥âáï %DLA%%ESC%[K)
if %1 equ 5 (echo ‘ª ç¨¢ ¥âáï %DLB%%ESC%[K)
if %1 equ 6 (echo %_hl% ‘ª ç¨¢ ¥âáï ¨«¨ ®¡­®¢«ï¥âáï YT-DLP%ESC%[K%_filler%)
if %1 equ 7 (echo %_oc% ‡ £àã§ª  § ¢¥àè¥­ %ESC%[K)
if %1 equ 8 (echo %_pbg%%_hke%  ¦¬¨â¥ [C] ¤«ï ¯à®¤®«¦¥­¨ï%ESC%[K)
if %1 equ 9 (echo ‘ª ç¨¢ ¥âáï %DLC%%ESC%[K)
if %1 equ 10 (echo %_pbg%%_hke%  ¦¬¨â¥ [C] ¤«ï ¢®§¢à â %ESC%[K%_co%)
if %1 equ 97 (echo "Ž¡­ àã¦¥­ powershell v5. •®â¨â¥ ®¡­®¢¨âì ¤® v7? (¯® ¦¥« ­¨î, ­® à¥ª®¬¥­¤ã¥âáï)")
if %1 equ 98 (echo ®¦ «ã©áâ  ¯®¤®¦¤¨â¥, ¯®ª  ¯à®£à ¬¬  ¢ë¯®«­ï¥â ãáâ ­®¢ªã ....)
if %1 equ 99 (echo %_hlm%%_hks%ˆ­¨æ¨ «¨§ æ¨ï%_hke%%_hlm%, ®¦¨¤ ©â¥ ....%ESC%[K%_filler%%_co%)
exit /b

@CHANGELOG@
====================================================================== AUTHOR
This script was written by f@xor.world in Dec. 2025 for myself and my friends
.
===================================================================== LICENSE
This software is safe, almost WINDOWS allow it. No adware, spyware or other 
*ware are included. BTW use witout any hopes and guaranties.
.
===================================================================== HISTORY
2025-12-23-L Add i18n support english and russian - depend on os locale.
2025.12.23-K Bugfix, optimization and tune and ready for public release
2025.12.21-J Extend download and list of available options
2025.12.17-I Store settings in command file, instread of registry
2025.12.14-H PowerShell 7.0 optional installation
2025.12.14-G Added History of application
             Make TUI more user-friendly for ibm-pc/xt generation
2025.12.13-F Add support for video download quality settings
             Store in Videos/Music folder with full domain name
2025.12.10-E Integrate for NoDPI
             Integrate sound for finishing for download processes
2025.12.10-D Fix installation errors
             Tune the yt-dlp
             Add icon file and create lnk in desktop while installation
2025.12.09-C Migrate from [ARIA] and [7z] to [powershell]
2025.12.09-B Make self-installing script 
2025.12.08-A First release based on [7z] and [aria2c].
.
@DOWNLOAD@
param (
    [string]$UrlPrefix,
    [string]$FileName,
    [string]$FilePath
)

if ([string]::IsNullOrEmpty($UrlPrefix) -or [string]::IsNullOrEmpty($FileName)) {
    Write-Error "Usage: . exclusion.\DownloadWithProgress.ps1 UrlPrefix FileName FilePath"
    exit 1
}

$uri = $UrlPrefix + '/' + $FileName
$outFile = Join-Path -Path $FilePath -ChildPath $FileName
$esc = [char]27

function Update-BottomLineProgress {
    param (
        [string]$StatusString
    )
    $bottomRow = $Host.UI.RawUI.WindowSize.Height - 1
    $cols = $Host.UI.RawUI.WindowSize.Width
    $spaces = " " * ($cols - $StatusString.Length - 1)
    Write-Host -NoNewline "$esc[s$esc[$($bottomRow);0H$esc[K$StatusString$spaces$esc[u"
}

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $client = New-Object System.Net.Http.HttpClient
    $resp = $client.GetAsync($uri, [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead).Result
    $null = $resp.EnsureSuccessStatusCode()
    $total = $resp.Content.Headers.ContentLength
    $stream = $resp.Content.ReadAsStreamAsync().Result
    $fileStream = New-Object System.IO.FileStream($outFile, [System.IO.FileMode]::Create)
    $buffer = New-Object byte[] 65536
    $read = 0
    while (($count = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {
        $fileStream.Write($buffer, 0, $count)
        $read += $count
        $percent = ($read / $total) * 100
	$readMB = $read / 1MB
	$totalMB = $total / 1MB
	$percentInt = [int]$percent
	$status = "Loaded: $($readMB.ToString('0.00')) MB / $($totalMB.ToString('0.00')) MB ($($percentInt.ToString())%)"
	Update-BottomLineProgress -StatusString $status
    }
} catch {
    Write-Error "An error occurred during download: $_.Exception.Message"
} finally {
    if ($fileStream) { $fileStream.Close() }
    if ($stream) { $stream.Close() }
    if ($client) { $client.Dispose() }
}
@@@===@@@`    @@     (B     (   @   €           @                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            


  +++   			      ('' MMM CCC                                                                                                                                 CCC DDD @@@   /.. 433 333 333 333 333 333 333 333 333 333 Œ‹‹                                                 


 


    ''' /.. 433 333 333 333 333 333 333 333 333 333 333 555 322 @@@ DDD CCC         CCC  !                                                               C

x  r  l  e`]\ZUMD;1&				ÿÿÿ                                                                  """     CCC >==     ÿÿÿ                                                 I


çB>,ÿRI/ÿ/)ý÷	ïé   á   Ú  ÐÂ³§š‹{   k   _   U   K   A   9   2   ,   *   '   #                                                         dee 444000R%%%~!!!Ž   “   “   “ !!“!!!“!!!“!!!“!!!“!!!“!!!“!!!“"##‘¶þ¤[ÿûÊwÿå³fÿÍ¢^ÿ­ŒSÿ‡oCÿ`Q1ÿ>5!ü"ö	êÚ   Ë   ¾  ´¯¬¨!!!§!!!¤   ¢  žœ  š  ™—  –   “   “  “““““““““’!!!‹$$$}%%%P    ;;; nnn ggg{{{ˆ}}}í|||ö~~~÷€€€ø‚‚‚øƒƒƒø„„„ø…††ø†‡†ø‡‡‡ø‡ˆˆøˆˆˆøˆˆˆøˆ‰‰øŠŠŠøABBûÿÇ¡`ÿø·bÿï­Xÿò°\ÿõ´_ÿø¹dÿöºgÿí¶fÿÛ«bÿ¿˜Xÿœ~Jÿua:ÿQD)ü3,ù%#÷)(&÷:;;öOQR÷def÷ttu÷~÷„„„÷„……÷„„„÷‚ƒƒ÷÷€€€øø~~~ø}}}ø|||ø{{{øyyyøxxxøxxxøwwwøvvvøuuuøttt÷ttt÷tttâsttN PPP €€€ ~„„„ÒˆˆˆÿŒŒŒÿÿ’’’ÿ“”“ÿ•••ÿ–—–ÿ˜˜˜ÿ˜™™ÿ™™™ÿ™š™ÿ™ššÿšššÿš››ÿ—˜˜ÿ667ÿ1, ÿÞ®cÿí«Wÿå¤Pÿæ¥Qÿæ¤Qÿæ¥Qÿè¦Rÿê¨Tÿí«Vÿò±]ÿø»lÿùÂwÿóÂxÿå¹tÿÏ«wÿ¯’_ÿ‹tIÿhW6ÿJA,ÿ:5*ÿ751ÿ?@?ÿPQRÿdefÿvwxÿƒ„„ÿŒŒŒÿÿÿŽÿÿŒŒŒÿ‹‹‹ÿ‹‹‹ÿ‹‹‹ÿŠŠŠÿ‰‰‰ÿ‡‡‡ÿ………ÿƒƒƒÿ€€€ÿ¡¡¡ qqq ‚‚‚ ŠŠŠÓŽŽÿ‘’‘ÿ”””ÿ———ÿ™ššÿœœœÿžÿžŸŸÿŸ  ÿŸ  ÿ ¡¡ÿ ¡¡ÿ ¡¡ÿ¡¢¢ÿ–——ÿ$%&ÿLB-ÿç°aÿä¢OÿàŸLÿàŸLÿàŸLÿàŸMÿàŸMÿàŸLÿã¦Xÿç¯hÿæ«aÿæ©\ÿèª[ÿí°aÿô½wÿô¸jÿøÀuÿøÂvÿî¸hÿÜ­cÿÁ™Yÿž€Kÿze=ÿYL1ÿC<,ÿ97/ÿ==;ÿLMMÿdddÿŠŠŠÿ–––ÿ”••ÿ“””ÿ“““ÿ’“’ÿ‘’‘ÿÿŽŽŽÿ‹Œ‹ÿŠŠŠÿ†††ÿƒƒƒ˜    ttt ‚‚‚ ‚ŽÏ“““ÿ–––ÿ™ššÿžžÿ   ÿ¡¢¢ÿ¢££ÿ£¤¤ÿ¤¦¦ÿ¦§§ÿ§¨¨ÿ§¨¨ÿ§¨¨ÿ©ªªÿŽÿÿkX8ÿä§VÿØ—FÿÖ–EÿÖ–Eÿ×–EÿØ—FÿØ˜FÿÞ¢Wÿâ©cÿÝ¡Tÿà¥Zÿá§]ÿá¥Zÿä«cÿéµrÿæª_ÿæ¨Zÿé­aÿî³iÿî­Yÿó±\ÿ÷·bÿù»fÿõ»iÿè´fÿÑ¥_ÿ²UÿŽ|Lÿ>:)ÿwwxÿŸ  ÿœÿ›œœÿ›œœÿšššÿ˜™˜ÿ–—–ÿ”•”ÿ‘’’ÿÿ‹‹‹ÿ‡‡‡˜    ttt €€ €€€Ì–——ÿ›œœÿŸ  ÿ¡¢¢ÿ¤¥¥ÿ¦§§ÿ¨©©ÿ©««ÿ«¬¬ÿ¬­­ÿ­®®ÿ­®®ÿ®¯¯ÿ°±±ÿ€€ÿÿ‡h<ÿØ˜GÿËŒ<ÿÊ‹<ÿË‹<ÿË‹<ÿÌŒ<ÿÒ”HÿÚ¢\ÿÕ™OÿÚ YÿÕ—KÿÓ“CÿÔ“BÿÜ Vÿß¤ZÿÛ›Kÿá¦[ÿâ§[ÿã¨]ÿæ«`ÿã¢Oÿå¤Pÿè¦Rÿë©Uÿî¬Xÿó±]ÿûºeÿüÏ{ÿf^Cÿ‰Š‹ÿ¤¥¥ÿ¢££ÿ¡¢¢ÿ¡¢¢ÿ ¡ ÿŸŸŸÿœÿ™ššÿ———ÿ”””ÿÿŠŠŠ˜    ttt €€ €€“““Ìš››ÿŸ  ÿ¢££ÿ¦§§ÿ©ªªÿ«¬¬ÿ­®®ÿ®¯¯ÿ°±±ÿ±²²ÿ²³³ÿ²³³ÿ²³³ÿ¶··ÿjkkÿÿ¤}JÿÐ“HÿÃ†:ÿÁƒ6ÿÀ‚4ÿÀ3ÿÁƒ5ÿÐ™TÿÌ‘IÿÐ˜SÿÈŠ=ÿÇ‡8ÿÉŠ<ÿÍŽ@ÿ×žWÿÔ—KÿÑ@ÿÔ”CÿÛ UÿÞ¢Vÿá¨`ÿà¡RÿßžLÿâ¡Nÿä£Oÿæ¥Qÿè¦Rÿò°\ÿç¸kÿWQBÿŸ ÿª««ÿ¨ªªÿ§¨¨ÿ¦§§ÿ¤¥¥ÿ£¤¤ÿ¡¢¢ÿŸŸŸÿœœÿ˜˜˜ÿ“”“ÿ˜    ttt ƒƒƒ ƒƒƒ–——Ìžžžÿ¢££ÿ¦§§ÿ©««ÿ­¯¯ÿ°±±ÿ±²²ÿ²³³ÿ´µµÿµ¶¶ÿ¶··ÿ·¸¸ÿ·¸¸ÿ¸¹¹ÿRRSÿ% ÿµˆLÿÎ–RÿÌ•RÿÌ–RÿÊ’NÿÆŒEÿÆFÿÎ˜UÿÈKÿÂ‡=ÿ¼~0ÿ¾1ÿÂ„8ÿÝ­qÿé½‡ÿÞ«lÿÍDÿÊŠ;ÿÎŽ?ÿØTÿØRÿÝ£YÿÙ˜GÿÜœJÿàŸLÿâ¡Nÿå¤Pÿó²]ÿÍ¤_ÿVUNÿ¬­®ÿ®¯¯ÿ­®®ÿ¬­­ÿ«¬¬ÿ©ªªÿ§¨¨ÿ¥¦¦ÿ¢££ÿ ¡¡ÿ›œœÿ–——ÿ˜    ttt  ™™™Ê ¡¡ÿ¤¥¥ÿ©ªªÿ­®®ÿ°±±ÿ²³³ÿµ¶¶ÿ¶··ÿ¸¹¹ÿ¹ººÿº»»ÿ»¼¼ÿ¼½½ÿ¶··ÿ9:;ÿ:/ÿ¹‚:ÿ¼~0ÿ»}0ÿ½5ÿÁ…<ÿÄ‹DÿÐœ\ÿÕ¢eÿÖ£eÿË“OÿÆŒEÿÂ‡=ÿ¾6ÿÌ•QÿÝ®sÿÒ]ÿÉIÿÀ3ÿÂ„5ÿËFÿÑ–Lÿ×žWÿÑ‘BÿÕ”DÿÚ™HÿÞKÿâ¡Nÿõ³^ÿ¬‹Rÿeecÿµ¶¶ÿ²³³ÿ±²²ÿ°±±ÿ¯°°ÿ­®®ÿ«­­ÿ©ªªÿ¥§§ÿ¢££ÿŸŸŸÿ™ššÿ‘‘‘˜    ttt  €€€›››Æ¢££ÿ§¨¨ÿ¬­­ÿ°±±ÿ³´´ÿ¶··ÿ¸¹¹ÿ¹ººÿ»¼¼ÿ¾¿¿ÿ¾¿¿ÿ¾¿¿ÿÀÁÁÿ®®®ÿ&'(ÿVC%ÿÁ…9ÿº|.ÿ¹{-ÿ¸z-ÿ¸z,ÿ·x*ÿÃ‹DÿÅGÿÈJÿ¾ƒ9ÿÃ‰BÿÈJÿÊ“OÿÐ›[ÿà²yÿÈJÿÃˆ@ÿ¿ƒ8ÿ½2ÿÂ…;ÿÉIÿÎ–QÿÈ‰;ÿËŒ<ÿÒ‘Aÿ×—FÿÞKÿò³_ÿ‡pEÿ|}~ÿ¹ººÿµ¶¶ÿ´µµÿ³´´ÿ²³³ÿ±²²ÿ®¯¯ÿ¬­­ÿ¨©©ÿ¤¥¥ÿ¡¡¡ÿœœÿ“”“˜    ttt €€€ œÅ¤¥¥ÿ©««ÿ®¯¯ÿ²³³ÿ¶··ÿ¹ººÿº»»ÿ½¾¾ÿ¿ÀÀÿÁÂÂÿÁÂÂÿÁÃÂÿÄÅÅÿžŸŸÿÿsV-ÿÁƒ5ÿ·y,ÿ¶x+ÿµw*ÿ´w*ÿ³u(ÿ¿†@ÿÁ‰DÿÂ‰Cÿ³v)ÿ´v)ÿµw*ÿ·y-ÿÂˆAÿÚ©nÿÒŸ`ÿÅHÿÊ“PÿË”QÿÎ˜WÿÐ›ZÿÐšXÿÄˆ=ÿÃ…8ÿÇˆ9ÿÎ=ÿØ—Eÿç­\ÿgY<ÿ•–˜ÿ¼½½ÿ¸¹¹ÿ·¸¸ÿ¶··ÿµ¶¶ÿ³´´ÿ±²²ÿ®¯¯ÿ«¬¬ÿ§¨¨ÿ¢££ÿžžÿ”••™    www  žžÇ¥¦¦ÿ«¬¬ÿ°±±ÿ´µµÿ¸¹¹ÿ»¼¼ÿ½¾¾ÿ¿ÀÀÿÁÃÂÿÂÄÃÿÃÄÄÿÄÅÅÿÇÈÈÿ‡ˆ‡ÿÿŽg1ÿ¼~/ÿ²t(ÿ°r&ÿ®q%ÿ­o$ÿ«n"ÿ´y3ÿ¼…Bÿ¼ƒ?ÿ°t*ÿ®p$ÿ±s(ÿÂ‹GÿÆMÿÚªpÿÐ^ÿ³u'ÿ¶x+ÿ¸{/ÿÆHÿË•RÿÒŸ`ÿÌ•QÿÍ—SÿÎ—TÿÏ–Qÿ×›PÿÖ¢[ÿVN=ÿª¬­ÿ½¾¾ÿ»¼¼ÿº»»ÿ¹ººÿ·¸¸ÿµ¶¶ÿ³´´ÿ°±±ÿ­®®ÿ©««ÿ¤¥¥ÿŸ  ÿ–—–›   {zz ……… ………žžÌ§¨¨ÿ¬­­ÿ±²²ÿµ¶¶ÿ¹ººÿ½¾¾ÿÀÁÁÿÁÂÂÿÂÄÃÿÄÅÅÿÅÇÆÿÆÈÇÿÊËËÿklmÿ ÿ¡q1ÿ´v(ÿªm"ÿ§jÿ¤gÿ¡eÿ dÿ¢gÿ·‚@ÿ®v1ÿ±y4ÿ¤gÿ¦iÿ¼†Cÿá·ƒÿàµÿº<ÿ®p$ÿ¯r%ÿ³w+ÿÀˆBÿÀ‡@ÿÁˆ@ÿ¸z-ÿ¼2ÿÀ„:ÿÆŒEÿÕœUÿÀ•\ÿWTLÿ¹»»ÿ¾¿¿ÿ½¾¾ÿ¼½½ÿ»¼¼ÿº»»ÿ·¸¸ÿµ¶¶ÿ²³³ÿ¯°°ÿ«¬¬ÿ¦§§ÿ ¡¡ÿ—˜˜ .,,  ŽŽŽŸ  Ñ¨©©ÿ®¯¯ÿ²³³ÿ·¸¸ÿ»¼¼ÿ¿ÀÀÿÁÂÂÿÃÄÄÿÄÅÅÿÆÇÇÿÈÉÉÿÉÊÊÿÉÊÊÿOPQÿ/&ÿ©v1ÿ­p$ÿ¤gÿžbÿš^ÿ—\ÿ–[ÿ•Yÿ§o,ÿ¬u1ÿ©r.ÿ¨o)ÿœaÿ eÿ¾ŠKÿ¨n'ÿ¢fÿ¤gÿ©m$ÿ¸€;ÿ·}5ÿÃ‹Fÿ¶z.ÿ¶x+ÿ¸z-ÿº{-ÿ»|.ÿÈ‰9ÿ–o9ÿcc`ÿÂÃÃÿÀÁÁÿ¿ÀÀÿ½¾¾ÿ¼½½ÿ»¼¼ÿº»»ÿ¶··ÿ´µµÿ°±±ÿ­®®ÿ¨©©ÿ¢££ÿ˜˜˜¥LKK~~~ ’’’  ¡¡Ó©ªªÿ¯°°ÿ´µµÿ¹ººÿ½¾¾ÿÀÁÁÿÃÄÄÿÅÆÆÿÇÈÈÿÈÉÉÿÊËËÿÌÍÍÿ¾¿¿ÿ345ÿ/&ÿwS#ÿ†Xÿ‘[ÿ•[ÿ•Yÿ“Xÿ’VÿUÿ‘Wÿ©s1ÿ¢j'ÿ£k'ÿ¦o+ÿ¥m)ÿ³~>ÿš_ÿžcÿ¦l&ÿ­v3ÿªr,ÿ·€<ÿ³x1ÿ®p$ÿ³v)ÿ¶y,ÿ¹{-ÿº|/ÿÅˆ:ÿuY/ÿ{}}ÿÆÈÇÿÂÃÃÿÁÂÂÿ¿ÀÀÿ¾¿¿ÿ¼½½ÿ»¼¼ÿ¸¹¹ÿµ¶¶ÿ²³³ÿ®¯¯ÿ©ªªÿ¤¥¥ÿ™™™©YXX}}} ••• “““¢¢¢Öª««ÿ°±±ÿµ¶¶ÿº»»ÿ¾¿¿ÿÂÃÃÿÅÆÆÿÇÈÈÿÉËËÿËÌÌÿÌÍÍÿÐÑÑÿŽŽÿÿÿÿ/+&ÿ1'ÿ8'ÿJ0ÿ^;ÿmBÿ{Iÿ…NÿVÿ¦p.ÿ¥m*ÿ›bÿ¬v5ÿ´@ÿ¡i%ÿ£k(ÿ g#ÿ¡i$ÿ®w4ÿ¦n)ÿ dÿ§j ÿ®p%ÿ³u)ÿ¶x+ÿº|.ÿÁ‡:ÿ]J+ÿ–˜™ÿÇÉÈÿÃÅÄÿÃÄÄÿÂÃÃÿÀÁÁÿ¾¿¿ÿ¼½½ÿ¹ººÿ¶··ÿ³´´ÿ¯°°ÿª¬¬ÿ¥¦¦ÿšššª[ZZ~~~ ””” “““¢££Ø«¬¬ÿ±²²ÿ·¸¸ÿ¼½½ÿÀÁÁÿÃÄÄÿÆÇÇÿÉËËÿËÍÍÿÍÎÎÿÎÏÏÿÐÒÒÿlmmÿÿÿ///ÿwxxÿopqÿ>?@ÿÿÿ#!ÿ.'ÿ2%ÿ>)ÿS5ÿsO"ÿŒb-ÿ©{Bÿ«x9ÿe"ÿ¢k'ÿ§o-ÿ¤m+ÿ˜^ÿ”Yÿ™]ÿŸcÿ§jÿ­o$ÿ±t'ÿ·y,ÿ·~5ÿQE2ÿ¯°±ÿÈÉÉÿÅÇÆÿÄÆÅÿÃÅÄÿÁÃÂÿ¿ÀÀÿ½¾¾ÿº»»ÿ¸¹¹ÿ´µµÿ¯°°ÿ«¬¬ÿ¦§§ÿœœœ®nnn‚ƒƒ ‘‘ ¢££Û¬­­ÿ²³³ÿ¸¹¹ÿ½¾¾ÿÀÂÁÿÄÅÅÿÈÊÊÿËÌÌÿÍÎÎÿÍÏÏÿÏÐÐÿÊÌÌÿ```ÿlllÿÿÿ˜˜˜ÿÒÒÒÿ§¨§ÿ//.ÿÿEEEÿ|}}ÿklmÿ345ÿÿÿ+'"ÿ>7+ÿG9'ÿU>!ÿeFÿqGÿzIÿ†OÿUÿ–Zÿœ_ÿ¡eÿ§jÿ¬n#ÿ³u(ÿ n,ÿRLBÿÀÁÂÿÉÊÊÿÇÈÈÿÆÇÇÿÅÆÆÿÂÄÃÿÁÂÂÿ¾¿¿ÿ¼½½ÿº»»ÿ¶··ÿ±²²ÿ¬­­ÿ§¨¨ÿžž±tttƒƒƒ ˜˜˜ –——£¤¤Þ¬­­ÿ³´´ÿ¹ººÿ¾¿¿ÿÃÄÄÿÆÇÇÿÊËËÿÌÍÍÿÍÏÏÿÏÑÑÿÑÒÒÿ¿ÀÀÿUVUÿ§¨¨ÿRRRÿ677ÿuuuÿêêéÿñññÿhhhÿÿ+++ÿ¸¹¸ÿÑÒÑÿ–––ÿ)))ÿ"""ÿbbbÿƒ„…ÿgiiÿ&'(ÿÿÿ+%ÿ0$ÿ=)ÿQ4ÿiBÿ~Oÿ\ÿ gÿ«p%ÿ„Z"ÿb`\ÿÉËËÿÉËËÿÉÊÊÿÈÉÉÿÆÇÇÿÄÅÅÿÃÄÄÿÀÂÁÿ½¾¾ÿ»¼¼ÿ·¸¸ÿ³´´ÿ®¯¯ÿ¨©©ÿŸ  ¶€€ŠŠŠ –—— ”••#£¤¤â­®®ÿ³´´ÿº»»ÿ¿ÀÀÿÄÅÅÿÇÈÈÿËÌÌÿÍÏÏÿÏÐÐÿÐÑÑÿÒÔÔÿ»¼¼ÿ899ÿŽŽÿ•–•ÿµµµÿ¹ººÿ¿¿¿ÿÊËËÿžŸžÿÿÿŠŠŠÿ÷÷öÿèèçÿPPPÿÿRRRÿÓÔÓÿÔÔÔÿzzzÿ!!!ÿ...ÿ|}~ÿ{|}ÿQRSÿÿÿ"ÿ*"ÿ4%ÿL4ÿG4ÿ~~ÿÎÐÐÿËÌÌÿÊÌÌÿÉÊÊÿÈÉÉÿÅÇÆÿÃÅÄÿÂÃÃÿ¿ÀÀÿ¼½½ÿ¹ººÿµ¶¶ÿ°±±ÿª««ÿŸ  ½{{{	‚‚ “““ ‘‘%¤¥¥ã­®®ÿ´µµÿ»¼¼ÿÀÂÁÿÅÇÆÿÉÊÊÿÌÍÍÿÎÐÐÿÑÒÒÿÑÒÒÿÕÖÖÿ‹ŒŒÿÿSTSÿª««ÿÑÒÒÿäåäÿÛÜÜÿ›œœÿ‹ŒŒÿ332ÿÿ888ÿÀÁÁÿÚÛÛÿ„„„ÿÿ###ÿºººÿûûúÿÏÏÏÿ766ÿ"""ÿŠŠŠÿÜÝÝÿÂÃÂÿJJJÿÿFFFÿ€‚‚ÿjklÿ789ÿÿœÿÐÑÑÿÍÎÎÿÌÍÍÿÊÌÌÿÊËËÿÈÉÉÿÆÇÇÿÄÅÅÿÁÂÂÿ½¾¾ÿ»¼¼ÿ·¸¸ÿ±²²ÿ«¬¬ÿ ¡¡Àyyy||| –—— ’““'¥¦¦æ®¯¯ÿ´µµÿ»¼¼ÿÀÂÁÿÇÈÈÿÊËËÿÍÎÎÿÐÑÑÿÑÓÓÿÓÕÕÿËÌÌÿcccÿ222ÿ"""ÿabaÿ›››ÿ²³³ÿÐÑÑÿ^^^ÿ455ÿDDDÿ<<<ÿ333ÿhiiÿÿŒŒÿ&&%ÿÿ___ÿÒÓÓÿ×ØØÿaaaÿÿPPPÿæçæÿùùùÿ˜˜˜ÿ###ÿ666ÿº»»ÿØÙÙÿžžÿ444ÿ¬­­ÿÑÒÒÿÎÐÐÿÍÎÎÿÌÎÎÿËÌÌÿÉËËÿÈÊÊÿÆÇÇÿÃÄÄÿ¿ÀÀÿ¼½½ÿ¸¹¹ÿ³´´ÿ­®®ÿ£¤¤Ä ——— ”””+¦§§é¯°°ÿ¶··ÿ¼½½ÿÂÃÃÿÇÈÈÿËÌÌÿÎÐÐÿÐÒÒÿÓÔÔÿ×ØØÿª¬¬ÿ]^^ÿaaaÿ   ÿ'''ÿºººÿÃÃÃÿ~~~ÿÿÿRRRÿmmmÿ€€ÿŽÿ‰ŠŠÿxxxÿTUUÿ888ÿ:::ÿƒ„ƒÿ¢££ÿ€ÿÿ!!!ÿ™™™ÿÜÝÝÿÁÂÂÿ877ÿ ÿŽŽŽÿøøøÿééèÿuuuÿ¾¿¿ÿÒÓÓÿÐÒÒÿÎÐÐÿÍÎÎÿÌÎÎÿËÌÌÿÊÌÌÿÈÉÉÿÅÆÆÿÁÃÂÿ¾¿¿ÿº»»ÿµ¶¶ÿ¯°°ÿ¥¦¦Çƒƒƒ‚ƒƒ •–– ’’’2¥§§í¯°°ÿ¶··ÿ½¾¾ÿÃÄÄÿÈÉÉÿËÌÌÿÎÐÐÿÒÓÓÿÔÖÖÿ×ÙÙÿz{{ÿCCCÿQQQÿÿÿ««ªÿö÷öÿ±²±ÿ


ÿÿhhhÿ———ÿqrrÿ999ÿfggÿŸ  ÿ¿ÀÀÿÅÇÇÿµ¶¶ÿ›œœÿ†‡‡ÿtttÿOOOÿ777ÿYYYÿžžÿ®¯®ÿ\\\ÿÿAAAÿÄÅÅÿÝÞÞÿª««ÿÌÍÍÿÓÔÔÿÒÓÓÿÑÒÒÿÏÐÐÿÎÏÏÿÌÎÎÿËÌÌÿÊËËÿÇÈÈÿÃÅÄÿÀÁÁÿ¼½½ÿ·¸¸ÿ±²²ÿ¥¦¦Ë€€€ œ ˜˜˜;§¨¨ò¯°°ÿ·¸¸ÿ¾¿¿ÿÄÅÅÿÉÊÊÿÌÍÍÿÏÑÑÿÓÕÕÿÔÖÖÿÕ××ÿžŸŸÿ___ÿBBBÿÿÿUUUÿ¯°°ÿ°±±ÿÿ   ÿnnnÿéêéÿÈÉÈÿ+++ÿ   ÿ111ÿtutÿ………ÿª««ÿÎÐÐÿÜÝÝÿ×ÙÙÿÍÏÏÿ¾¿¿ÿ©«ªÿ–——ÿ‰ŠŠÿqqqÿKKKÿ<<<ÿ€€ÿ­®®ÿ©ªªÿÓÔÔÿÔÖÖÿÓÔÔÿÒÔÔÿÑÒÒÿÏÐÐÿÎÏÏÿÌÎÎÿËÍÍÿÉÊÊÿÅÆÆÿÁÃÂÿ½¾¾ÿ¸¹¹ÿ´µµÿ¨©©Ñ‰‰‰ˆ‰‰     ›››B¨©©õ°±±ÿ¸¹¹ÿÀÁÁÿÆÇÇÿÊËËÿÍÎÎÿÑÒÒÿÔÕÕÿÕ××ÿÖØØÿÚÛÛÿÕÖÖÿ»¼¼ÿ”””ÿcccÿLMLÿijiÿ„„„ÿ///ÿ   ÿ@@@ÿèéèÿ÷÷öÿaaaÿ   ÿ---ÿ±²²ÿ¡¢¡ÿOOOÿ777ÿtuuÿ«­­ÿÎÏÏÿÜÞÞÿÝßßÿÛÝÝÿ×ÙÙÿÑÒÒÿÇÉÉÿ¶··ÿ¥¦¦ÿ­¯®ÿÆÈÈÿÖØØÿÕ××ÿÕÖÖÿÓÔÔÿÒÓÓÿÑÒÒÿÏÑÑÿÎÏÏÿÌÍÍÿÊËÌÿÇÈÈÿÃÄÄÿ¿ÀÀÿº»»ÿ¶··ÿª««Ö‹ŒŒŒŒŒ ¤¤¤ žŸŸH©ªª÷±²²ÿ¹ººÿÁÂÂÿÆÇÇÿÊÌÌÿÎÏÏÿÒÓÓÿÔÖÖÿÕ××ÿØÙÙÿÙÛÛÿÜÝÝÿÞßßÿßààÿ×ØØÿ¾¿¾ÿ“”“ÿnnnÿAAAÿÿÿ©ª©ÿÜÝÜÿ†‡†ÿ   ÿÿÇÇÆÿìíìÿŒŒŒÿÿÿbccÿqqqÿ‡ˆ‡ÿ²³³ÿÓÔÔÿÝÞÞÿÛÝÝÿÚÜÜÿÚÜÜÿÚÜÜÿÚÛÛÿØÚÚÿÖØØÿÖØØÿÖØØÿÕ××ÿÓÕÕÿÒÔÔÿÒÓÓÿÐÑÑÿÎÏÏÿÌÍÍÿÉÊÊÿÅÆÆÿÁÂÂÿ¼½½ÿ¸¹¹ÿ­®®Û‘’’’““ ¦§§ žžP©ªªú²³³ÿº»»ÿÁÂÂÿÇÈÈÿËÌÌÿÏÐÐÿÓÔÔÿÕ××ÿÖØØÿÙÚÚÿÚÜÜÿÜÝÝÿÝÞÞÿÝÞÞÿßààÿßààÿßààÿÕÖÖÿ»¼¼ÿ’’’ÿabaÿeeeÿ‰ŠŠÿÿÿÿ›œ›ÿûûûÿËËÊÿÿÿ‰‰‰ÿµ¶¶ÿwxxÿ"""ÿFGGÿ…††ÿ¶··ÿÓÔÔÿÜÞÞÿÛÝÝÿÚÛÛÿØÚÚÿ×ÙÙÿ×ÙÙÿ×ÙÙÿÖØØÿÕÖÖÿÔÖÖÿÓÔÔÿÑÒÒÿÏÐÐÿÍÎÎÿËÌÌÿÇÈÈÿÄÅÅÿ¾¿¿ÿº»»ÿ¯°°à—˜˜ ˜™™ ª«« žžUª««ü³´´ÿ»¼¼ÿÂÃÃÿÈÉÉÿËÍÍÿÐÑÑÿÔÕÕÿÕ××ÿØÙÙÿÛÜÜÿÛÜÜÿÜÝÝÿÝÞÞÿÞßßÿÞààÿÞßßÿÞßßÿßààÿàááÿßààÿÕÖÖÿ·¸·ÿŽŽŽÿjjjÿ444ÿÿXXXÿÊËËÿÏÏÏÿ222ÿ   ÿvvvÿñññÿÍÍÍÿ)))ÿ   ÿ>>>ÿnnnÿnnnÿŽÿ½¾¾ÿ×ØØÿÚÛÛÿÚÛÛÿÙÛÛÿØÚÚÿ×ÙÙÿÖØØÿÕ××ÿÓÕÕÿÒÓÓÿÐÑÑÿÏÐÐÿÌÎÎÿÉÊÊÿÅÆÆÿÀÁÁÿ»¼¼ÿ²³³å›œœ%žž ª«« œ\«­­ý´µµÿ¼½½ÿÃÄÄÿÈÊÊÿÌÎÎÿÐÒÒÿÔÕÕÿÖØØÿÙÛÛÿÜÝÝÿÜÝÝÿÝÞÞÿÝÞÞÿÞßßÿßààÿÞßßÿßààÿßààÿßààÿßààÿàááÿàááÿßààÿÒÓÓÿ·¸·ÿŠ‹ŠÿdedÿrsrÿÿAAAÿ   ÿDDCÿèéèÿööõÿ\\\ÿ   ÿCDDÿÁÁÁÿ¥¦¦ÿ999ÿÿŒÿÝÞÞÿÛÜÜÿÚÜÜÿÙÚÚÿÙÚÚÿØÙÙÿÕ××ÿÕ××ÿÔÖÖÿÒÓÓÿÐÑÑÿÎÏÏÿÊÌÌÿÇÈÈÿÂÃÃÿ½¾¾ÿµ¶¶é+    «¬¬ œd¬­­þµ¶¶ÿ½¾¾ÿÄÅÅÿÉÊÊÿÎÏÏÿÑÓÓÿÔÖÖÿ×ÙÙÿÚÛÛÿÜÝÝÿÜÝÝÿÝÞÞÿÞßßÿßààÿßààÿÞßßÿßààÿßààÿßààÿßààÿßààÿßààÿßààÿàááÿáââÿßààÿÑÒÒÿ±±±ÿŒŒŒÿ```ÿ---ÿ)))ÿ£¤¤ÿÕÖÖÿ€€€ÿ   ÿ'''ÿÛÛÚÿíîíÿwwwÿÿˆ‰‰ÿßààÿÜÝÝÿÛÜÜÿÛÜÜÿÛÜÜÿÙÚÚÿ×ÙÙÿÖØØÿÕÖÖÿÓÕÕÿÑÓÓÿÏÐÐÿÌÎÎÿÈÊÊÿÄÅÅÿ¿ÀÀÿ¶··ìžž1¡¡¡ ®¯¯  ¡¡k®¯¯ÿ¶··ÿ¾¿¿ÿÄÅÅÿÊËËÿÎÏÏÿÒÓÓÿÕ××ÿØÚÚÿÛÜÜÿÜÝÝÿÝÞÞÿÞßßÿÞßßÿßààÿßààÿßààÿßààÿßààÿàááÿàááÿßààÿàááÿàááÿàááÿßààÿàááÿáââÿáââÿÞßßÿÑÒÒÿ·¸¸ÿŽŽŽÿzzzÿ†††ÿrrrÿ


ÿ


ÿ°±°ÿûûúÿ³³³ÿ)))ÿ¾¿¿ÿßààÿÜÝÝÿÜÝÝÿÛÜÜÿÜÝÝÿÛÜÜÿØÚÚÿ×ÙÙÿÖ××ÿÔÖÖÿÓÔÔÿÑÒÒÿÎÏÏÿÊËËÿÆÇÇÿÁÂÂÿ¸¹¹ï   6£££ ´µµ £¤¤s¯°°ÿ¸¹¹ÿ¿ÀÀÿÅÆÆÿÊÌÌÿÏÐÐÿÓÔÔÿÖ××ÿÙÚÚÿÛÜÜÿÝÞÞÿÞßßÿÞßßÿßààÿàááÿßààÿßààÿßààÿàááÿàââÿàááÿàááÿàááÿàááÿßááÿàááÿßááÿàááÿßááÿàááÿáââÿáââÿÞßßÿÑÒÒÿ¹º¹ÿšššÿlmmÿ;<<ÿqrqÿÄÅÅÿº»ºÿnonÿÙÚÚÿÞßßÿÝÞÞÿÞßßÿÜÝÝÿÜÝÝÿÜÝÝÿÚÛÛÿØÚÚÿ×ØØÿÕÖÖÿÓÕÕÿÒÓÓÿÏÐÐÿÌÍÍÿÇÈÈÿÃÄÄÿº»»ñ ¡¡:¤¥¥ ¾¿¿ ¦§§|±²²ÿº»»ÿÁÂÂÿÇÈÈÿÌÍÍÿÐÑÑÿÔÕÕÿ×ØØÿÚÛÛÿÜÝÝÿÝÞÞÿÞßßÿßààÿßààÿàááÿàááÿàááÿàââÿàááÿáââÿáââÿáââÿàááÿàááÿàááÿàââÿàááÿáââÿàââÿàááÿàááÿßààÿßááÿàââÿáââÿÞßßÿ×ØØÿÄÅÅÿ¥¦¦ÿ”••ÿÿ«««ÿàááÿÞßßÿÝßßÿÞßßÿÞßßÿÝÞÞÿÜÝÝÿÛÜÜÿÙÛÛÿØÚÚÿÖØØÿÔÕÕÿÒÔÔÿÑÒÒÿÍÏÏÿÉÊÊÿÅÆÆÿ½¾¾ó§¨¨=«¬¬ ÌÎÎ «««ƒ³´´ÿ»¼¼ÿÂÄÃÿÈÉÉÿÍÎÎÿÑÒÒÿÔÖÖÿØÙÙÿÛÜÜÿÜÝÝÿÝÞÞÿÞßßÿßààÿßààÿáââÿáââÿàââÿáââÿáââÿàááÿáââÿáââÿàááÿáââÿáââÿáââÿàááÿáââÿáââÿáââÿáââÿáââÿàááÿàááÿàááÿàááÿàááÿàááÿÞßßÿØÙÙÿÐÑÑÿÚÛÛÿßààÿßààÿßààÿÞààÿÞßßÿÞßßÿÝÞÞÿÜÝÝÿÚÜÜÿÙÛÛÿÖØØÿÕ××ÿÓÔÔÿÑÓÓÿÎÐÐÿËÌÌÿÆÈÈÿ¿ÀÀö©ªªC¯°° ÉÊÊ «««€µ¶¶ÿ½¾¾ÿÄÅÅÿÉÊÊÿÎÏÏÿÒÓÓÿÕ××ÿØÙÙÿÛÜÜÿÜÝÝÿÝÞÞÿÞßßÿÞßßÿßààÿáââÿáââÿàááÿàááÿáââÿáââÿáââÿáââÿàááÿáââÿáââÿáââÿáââÿáââÿáââÿáââÿáââÿáââÿàááÿàááÿàááÿàááÿàááÿßááÿàááÿàááÿàááÿßààÿßààÿßààÿßààÿÞßßÿÞßßÿÞßßÿÝÞÞÿÜÝÝÿÛÜÜÿÚÛÛÿ×ÙÙÿÕ××ÿÔÖÖÿÒÔÔÿÐÑÑÿÌÍÍÿÈÊÊÿÁÂÂø®¯®Jµ¶µ ¨¨¨ L²³³õÀÁÁÿÆÇÇÿËÌÌÿÏÑÑÿÓÔÔÿ×ØØÿÙÛÛÿÛÝÝÿÝÞÞÿÞßßÿßààÿàááÿàááÿáââÿáââÿáââÿáââÿáããÿáââÿáâãÿâããÿâããÿáââÿáââÿáââÿáââÿáââÿáââÿâããÿâããÿáââÿáââÿáââÿáââÿáââÿàááÿáââÿáââÿàááÿßààÿßààÿßààÿßààÿßààÿßààÿÞßßÿÞßßÿÞßßÿÝÞÞÿÛÝÝÿÛÜÜÿØÚÚÿ×ÙÙÿÕ××ÿÒÔÔÿÐÑÑÿÍÏÏÿÊÌÌÿÄÅÅú°±±N·¸¸ ‚‚ sssžž°±±ñÀÁÁÿÉÊÊÿÌÍÍÿÏÐÐÿÒÔÔÿÔÖÖÿÖ××ÿØÙÙÿÙÚÚÿÚÛÛÿÛÛÛÿÛÜÛÿÜÝÝÿÜÝÝÿÜÝÝÿÜÝÝÿÜÝÝÿÜÝÝÿÜÝÝÿÜÝÝÿÜÝÝÿÛÝÜÿÛÜÜÿÜÝÜÿÜÝÜÿÛÜÜÿÛÜÜÿÛÜÜÿÜÝÝÿÛÜÜÿÛÜÜÿÛÜÜÿÛÜÜÿÝÞÝÿáââÿáââÿàááÿáââÿáââÿàááÿàááÿßààÿßààÿßààÿÞßßÿßààÿÞßßÿÝÞÞÿÜÝÝÿÛÜÜÿÙÛÛÿ×ÙÙÿÕ××ÿÔÕÕÿÑÓÓÿÎÐÐÿÌÍÍÿÃÄÄõ¦§§A¬­­ …†† €€€ ttt```ghhÿpqqÿqrrÿrsrÿsssÿsttÿtttÿtutÿuuuÿuvuÿuvuÿuvuÿuvvÿuvvÿuuuÿtuuÿuuuÿtuuÿtuuÿtuuÿtutÿtuuÿtuuÿtuuÿtuuÿtutÿtutÿtttÿtttÿsttÿrssÿrsrÿrssÿ{||ÿ£££ÿ×ØØÿáââÿàááÿàááÿáââÿàááÿàááÿßààÿßààÿßààÿÞßßÿÞßßÿÝÞÞÿÝÞÞÿÛÝÝÿÚÛÛÿØÙÙÿÕ××ÿÕÖÖÿÒÔÔÿÏÑÑÿÍÎÎÿ¸¹¹ØŒ‘‘‘ jii KJJ  LLL—HHHÿFGFÿEEEÿDEDÿDDDÿCDCÿCDCÿCCCÿBCBÿBBBÿBBBÿBBBÿBBBÿBBBÿBBBÿABAÿ@AAÿ?@@ÿ???ÿ???ÿ???ÿ?@?ÿ@AAÿBBBÿBBBÿBBBÿAAAÿAAAÿ@A@ÿ@@@ÿ@@@ÿ@@@ÿ?@?ÿ>??ÿEEEÿ›››ÿãääÿâããÿáââÿáââÿâããÿáââÿáââÿáââÿáââÿàááÿßààÿÞßßÿÞßßÿÜÝÝÿÛÝÝÿÙÛÛÿØÚÚÿÖØØÿÕÖÖÿÑÒÒÿ¾¿¿÷™ššq    mmm     ^^^ XTVaaa```ÿ^^^ÿ]^]ÿ]]]ÿ]]\ÿ\\\ÿ[\[ÿ[[[ÿZZZÿZZZÿZZZÿZZZÿZZZÿZZZÿYYYÿXYXÿXXXÿWWWÿVWVÿVVVÿVVVÿWWWÿWXWÿXYXÿYYYÿXYXÿXXXÿWXWÿWXWÿWXWÿWWWÿWWWÿUUUÿRRRÿJKJÿbbbÿ¿ÀÀÿÕÖÕÿÓÔÔÿÓÔÔÿÓÔÓÿÓÔÓÿÒÓÓÿÒÓÒÿÑÒÒÿÐÑÑÿÏÐÐÿÏÐÏÿÎÏÏÿÌÍÍÿËÌÌÿÊËËÿÈÉÉÿÆÇÇÿ»½½ÿ¦§¦ù’““{baazzz zzz     jjj \]]rrr¥sssÿrsrÿrrrÿrrqÿqqqÿpppÿpppÿppoÿoooÿoooÿoooÿoonÿoonÿoonÿoonÿnnnÿmnmÿmnmÿmmlÿlmlÿlllÿmmlÿmmmÿmnmÿnnnÿmnmÿmnmÿmnmÿnnnÿnnnÿnnnÿnnnÿmmlÿiiiÿcdcÿ\]\ÿjkjÿuvuÿrssÿqqqÿpppÿpppÿoppÿpppÿpppÿoppÿopoÿoooÿnooÿnnnÿmnnÿmnmÿnnnÿpppÿoooÿoooðttt6www  CCC     lnn cff®ÿÿÿ€€€ÿ€€€ÿ€€€ÿÿÿ~~~ÿ~~~ÿ~~~ÿ~~~ÿ~~~ÿ}}}ÿ~~~ÿ}}}ÿ}}}ÿ}}}ÿ}}}ÿ}}}ÿ|||ÿ|||ÿ|||ÿ}}}ÿ}}}ÿ}}}ÿ}}}ÿ~~~ÿ~~~ÿÿÿÿ~~~ÿ}}}ÿyyyÿtutÿnnnÿiihÿeeeÿccbÿaaaÿaaaÿbbaÿbcbÿcdcÿcdcÿdddÿdddÿdddÿdddÿdddÿdddÿfgfÿklkÿtttÿzzzêttt-stt CCC         z{{ yzzˆ‰‰µŠŠŠÿ‹‹‹ÿ‹‹‹ÿ‹‹‹ÿŠŠŠÿŠŠŠÿ‰‰Šÿ‰‰‰ÿ‰‰‰ÿ‰‰‰ÿ‰‰‰ÿˆˆˆÿˆˆˆÿˆˆˆÿˆˆˆÿˆˆˆÿˆˆˆÿˆˆˆÿ‡‡‡ÿ‡‡‡ÿ‡‡‡ÿ‡‡‡ÿ‡‡‡ÿ‡‡‡ÿ‡‡‡ÿˆˆˆÿˆˆˆÿ‰‰‰ÿŠŠŠÿ‹‹‹ÿ‹‹‹ÿŒŒŒÿŒŒŒÿ‹‹‹ÿŠŠŠÿ‰‰‰ÿ‡‡‡ÿ………ÿƒƒƒÿÿ€€€ÿ€€€ÿ€€€ÿÿÿÿÿÿÿÿÿÿ‚‚‚ÿ………ÿÿghg¹655@@@             ‡‡‡ ‰‰‰Ž¼ÿÿ‘ÿ‘ÿ‘‘ÿ‘‘ÿ‘ÿÿÿÿÿÿÿÿÿÿÿÿÿÿŽÿŽŽÿŽŽŽÿŽŽŽÿ‰‰‰ÿzzzõqqqæopoâtutâzzzâ~~~â‚‚‚â†‡‡ã‹‹‹ãã“““ã•••ã–——ã———ã———ã———ã———ã–——ã–——ã———ã–——ã–––ã”•”ã‘‘‘ãŽŽŽã‰‰‰ãƒ„ƒã{{{âppp×]]\¤CCC0[\[                 }}} €€€Ã’‘ÿ‘’‘ÿ’“’ÿ“““ÿ”””ÿ“”“ÿ“”“ÿ”””ÿ”””ÿ”””ÿ”””ÿ”””ÿ”””ÿ”••ÿ”•”ÿ”•”ÿ”•”ÿ”””ÿ”””ÿ“”“ÿ“““ÿ“““ÿ’“’ÿüppo¡GGGC>??&888 9:9 === CCC LLL YYY!bbb!kkj!rrr!yyy!}||!!!!!!!!!~~~!{{{!uuu!nnn!ffe!\\\!MMM 888   SSS ÿÿÿ 666             ggg XXX‚‚‚º‘‘ÿ‘’’ÿ’“’ÿ“”“ÿ”””ÿ”””ÿ”””ÿ”””ÿ•••ÿ•••ÿ–––ÿ–––ÿ–––ÿ–––ÿ–––ÿ–––ÿ–––ÿ•••ÿ•••ÿ•••ÿ”””ÿ”””ÿ•••ÿŽÕfff[[[ DDD >?? @A@ CCC HHH PPP [\[ ddd klk rrr xxx {{{ }}} }}} }}} }}} }}} }}} }}} }}} ||| zzz ttt nnm fff ^^^ QQQ @?? ,++ GGG                  ('' ÆÇÇ VUUevvví…††ÿ‰ŠŠþŽŽþ‘’’þ”••þ———þ™™™þš›šþ›œœþœþþþžžþžžžþžžžþžžžþžžžþþ›››þ˜˜˜þ”””ÿÿ}~}™FFFggg                                                                                                                                          766 *)) BBA9Z[Zbddddpppdxxxd€€€dˆˆˆdd‘‘‘d–––d˜˜˜d™™™d™™™d™™™dšššdšššdšššdšššd™™™d”””dŒŒŒd„„„evuu\XWWlll °±±                                                                                                                                             CCC 100 ('' GGG fgf sss ~~ ˆˆˆ  ——— žžž ¢££ ¥¦¥ §§§ ¨©© ¨¨¨ ¨©© ªªª ªªª ª«« ªªª ¨©© £¤£ š›› ‘  \[[ iii TTT                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÀ ?ÿÿÿÀ                                                                                                                                                                                                                                                                                                                                                      €       €       €      €      €      €      €      €  ÿÿÿÿ€  ÿÿÿÿ€  ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ