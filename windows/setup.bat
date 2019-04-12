@echo off
pushd %0\..

REM check for docker on path
echo looking for docker...
where docker 1>nul 2>nul
if not %errorlevel% == 0 (
  echo docker is not installed or available on path!
  exit
)

REM create docker image
echo creating docker image...
docker build -t csci104 -f ..\Dockerfile ..

REM get mount point
echo creating manager script...
set /p work="select a directory to mount: "

:invalid
if not exist %work% (
  echo invalid directory!
  set /p work="select a directory to mount: "
  goto invalid
)

REM directory should be relative to caller
popd

REM get absolute path of directory
call :absolute "%work%"
set work="%return%"
echo mount set, this can be changed later...

REM go to docker folder
pushd %0\..\..

REM create manage script
echo creating manager script...
del .\manage.bat
echo @echo off >> .\manage.bat
echo( >> .\manage.bat
echo REM change this to the directory you want to access in your container >> .\manage.bat
echo set work=%work% >> .\manage.bat
echo( >> .\manage.bat
type .\windows\manage.base.bat >> .\manage.bat

REM
echo done!

exit /B

REM convert path to absolute
:absolute
set return=%~dpfn1
exit /B
