@echo off

title Control SXA
color 17

cls

set CAMI=%~dp0%Logs\
set DIA=%date:~0,2%
set MES=%date:~3,2%
set ANY=%date:~6,4%

SETLOCAL
For /f "tokens=1-3 delims=1234567890 " %%a in ("%time%") Do set "delims=%%a%%b%%c"

For /f "tokens=1-4 delims=%delims%" %%G in ("%time%") Do (
    Set _HH=%%G
    Set _MM=%%H
    Set _SS=%%I
    Set _MS=%%J
  )

:: Strip any leading spaces
  Set _HH=%_HH: =%

  :: Ensure the hours have a leading zero
  if 1%_HH% LSS 20 Set _HH=0%_HH%

set DATAEXECUCIO=%ANY%%MES%%DIA%_%_HH%%_MM%%_SS%
echo Entrada de dades
echo ================
set /p NOM=Entra nomes el teu nom: 
set /p COGNOM=Entra nomes el teu cognom: 

set NOMALUMNE=%COGNOM:~0,2%%NOM:~0,2%
REM set FITXERNOMALUMNE_ENV=%CAMI%%COGNOM:~0,2%%NOM:~0,2%.env
rem set FITXERNOMALUMNE_ZIP=%CAMI%%COGNOM:~0,2%%NOM:~0,2%.zip
set FITXERNOMALUMNE=%CAMI%%COGNOM:~0,2%%NOM:~0,2%

set FITXERNOMALUMNE_ZIP=%FITXERNOMALUMNE%%DATAEXECUCIO%.zip

echo.
set nomFitxer=%FITXERNOMALUMNE%%DATAEXECUCIO%.log

REM call mostra.cmd Logs/%DATAEXECUCIO%_escriptori.png

REM %windir%\explorer.exe shell:::{3080F90D-D7AD-11D9-BD98-0000947B0257}

REM call captura.exe %FITXERNOMALUMNE%%DATAEXECUCIO%.png >nul


echo.
echo Processant dades...
echo.

echo ------------------------------- >> %nomFitxer%
echo Executat %0  >> %nomFitxer%
echo el %DIA%-%MES%-%ANY%  >> %nomFitxer%
echo a les %_HH%:%_MM%:%_SS%  >> %nomFitxer%

echo NOM SERVER= %COMPUTERNAME% >> %nomFitxer%

echo LOGONSERVER = %LOGONSERVER% >> %nomFitxer%
echo USERDOMAIN = %USERDOMAIN% >> %nomFitxer%

ipconfig /all  >> %nomFitxer%

echo -----    SET    --------------- >> %nomFitxer%
set  >> %nomFitxer%
echo ------------------------------- >> %nomFitxer%

echo.
echo Copiant dades...
echo.

REM copy %CAMI%*.* %FITXERNOMALUMNE_ENV% 2>&1>> %nomFitxer%
REM copy %FITXERNOMALUMNE_ENV% %RUTA%\logs\%DATAEXECUCIO%_%NOMALUMNE%.env >nul



7z a -tzip %FITXERNOMALUMNE_ZIP% %CAMI%*.* -x!*.zip >nul


echo ------------------------------- >> %nomFitxer%

REM call %RUTA%\pujarAmbWinscp.cmd %FITXERNOMALUMNE_ENV% >nul

call %RUTA%\pujarAmbWinscp.cmd %FITXERNOMALUMNE_ZIP% >nul


type %RUTA%\resultat.log

%windir%\explorer.exe shell:::{3080F90D-D7AD-11D9-BD98-0000947B0257}

echo.
echo.
echo Proces finalitzat, si us plau, pitja una tecla per acabar!
echo.
echo.
pause >nul

color

exit

exit