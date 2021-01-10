@echo off

set manage=".\manage.bat"
echo "%manage%"

REM Go to docker folder
pushd %0\..

REM Check for docker on path
@echo Looking for docker...
where docker 1>nul 2>nul
if errorlevel 1 (
  echo Docker is not installed or available on path!
  exit 1
)

REM Pull docker image
echo Pulling docker image...
docker pull usccsci104/docker:latest

REM Get mount point
echo Creating manager script...
set /p work="Select a directory to mount: "

:invalid
if not exist %work% (
  echo Invalid directory!
  set /p work="Select a directory to mount: "
  goto invalid
)

REM Remove trailing backslash
IF %work:~-1%==\ SET work=%work:~0,-1%

REM Directory should be relative to caller
popd

REM Get absolute path of directory
call :absolute "%work%"
set work="%return%"
echo Mount point set, this can be changed later by editing manage.bat...

REM Go to docker folder
pushd %0\..\..

REM Create manage script
echo Creating manager script...
del "%manage%"
>"%manage%" (
  echo @echo off
  echo(
  echo REM Change this to the directory you want to access in your container
  echo set work=%work%
  echo(
  type .\windows\manage.base.bat
)

REM
echo Done!
exit /B

REM convert path to absolute
:absolute
set return=%~dpfn1
exit /B
