set container="%0\..\.container"
set done=0

if "%1" == "run" (
  call :docker_run
  set done=1
)

if "%1" == "shell" (
  call :get_container
  if %errorlevel% NEQ 0 (
    exit /b %errorlevel%
  )
  call :docker_shell
  set done=1
)

if "%1" == "kill" (
  call :get_container
  if %errorlevel% NEQ 0 (
    exit /b %errorlevel%
  )
  call :docker_kill
  set done=1
)

if %done% == 0 (
  @echo this command manages the virtual linux container!
  @echo   run - start up the container in the background
  @echo   shell - open a shell in your running container
  @echo   kill - kill the container in the background
  exit /b 0
)

exit /b 0

:get_container
if not exist %container% (
  @echo a container doesn't seem to be running...
  exit /b 1
)
set /p id=< %container%
exit /b 0

:docker_run_command
docker run -v %work%:/work -d -t --security-opt seccomp:unconfined --cap-add SYS_PTRACE csci104 >> %container%
exit /b 0

:docker_run
if exist %container% (
  @echo a container seems to be running, use the kill command
  exit /b
)
@echo running container...
docker run -v %work%:/work -d -t --security-opt seccomp:unconfined --cap-add SYS_PTRACE csci104 >> %container%
exit /b 0

:docker_shell
docker exec -it %id% bash
exit /b

:docker_kill
docker kill %id%
del %container%
exit /b
