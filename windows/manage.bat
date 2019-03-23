set container="%0\..\.container"

if "%1" == "run" (
  if exist %container% (
    @echo a container seems to be running, use the kill command
    exit /b
  )
  @echo running container...
  docker run -v %work%:/work/ -dt --security-opt seccomp:unconfined --cap-add SYS_PTRACE csci104 >> %container%
)

REM batch is fucking garbage
if not "%1" == "shell" (
  if not "%1" == "kill" (
    @echo invalid command!
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
)
