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
set FITXERNOMALUMNE=%CAMI%%COGNOM:~0,2%%NOM:~0,2%

set FITXERNOMALUMNE_ZIP=%FITXERNOMALUMNE%%DATAEXECUCIO%.zip

echo.
set nomFitxer=%FITXERNOMALUMNE%%DATAEXECUCIO%.log

:: Recopilació de dades
echo Processant dades...
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
echo Compressió de dades...
7z a -tzip %FITXERNOMALUMNE_ZIP% %CAMI%*.* -x!*.zip >nul

echo.
echo Enviant dades a l'FTP...
:: Executa WinSCP amb el fitxer ini per pujar el fitxer ZIP
"C:\Program Files (x86)\WinSCP\WinSCP.com" ^
  /log="%RUTA%\WinSCP.log" /ini="C:\ruta\a\joanpardosmx2.ini" ^
  /command ^
    "open" ^
    "put %FITXERNOMALUMNE_ZIP%" ^
    "exit"

set WINSCP_RESULT=%ERRORLEVEL%

if %WINSCP_RESULT% equ 0 (
  echo Fitxer %FITXERNOMALUMNE_ZIP% enviat correctament!>%RUTA%\resultat.log
) else (
  echo Hi ha hagut un error al enviar el fitxer %FITXERNOMALUMNE_ZIP%!>%RUTA%\resultat.log
)

echo ------------------------------- >> %nomFitxer%
type %RUTA%\resultat.log

echo.
echo Proces finalitzat, si us plau, pitja una tecla per acabar!
pause >nul

color
exit
