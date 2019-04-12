set container="%0\..\.container"

if "%1" == "run" (
  if exist %container% (
    @echo a container seems to be running, use the kill command
    exit /b
  )
  @echo running container...
  docker run -v %work:"=%:/work -d -t --security-opt seccomp:unconfined --cap-add SYS_PTRACE csci104 >> %container%
  exit /b
)

REM batch is fucking garbage
if not "%1" == "shell" (
  if not "%1" == "kill" (
    @echo this command manages the virtual linux container!
    @echo   run - start up the container in the background
    @echo   shell - open a shell in your running container
    @echo   kill - kill the container in the background
    exit /1
  )
)

if not exist %container% (
  @echo a container doesn't seem to be running...
  exit /b
)

set /p id=< %container%

if "%1" == "shell" (
  docker exec -it %id% bash
  exit /b
)

if "%1" == "kill" (
  docker kill %id%
  del %container%
  exit /b
)
