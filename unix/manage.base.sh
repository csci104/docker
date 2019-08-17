container="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)/.container"

function read_container() {
  if [[ -f ${container} ]]; then
    id=$(<${container})
  else
    echo "a container doesn't seem to be running..."
    exit
  fi
}

function docker_run_command() {
  docker run -v "${work}":/work -d -t --security-opt seccomp:unconfined --cap-add SYS_PTRACE csci104 1> ${container}
}

function docker_run() {
  if [[ -f ${container} ]]; then
    echo "a container seems to be running, use the kill command"
  else
    docker_run_command
    if [[ $? -ne 0 ]]; then
      rm ${container}
    fi
    echo "container is running!"
  fi
}

function docker_shell() {
  read_container
  docker exec -it ${id} bash
}

function docker_kill() {
  read_container
  docker kill ${id}
  rm ${container}
}

if [[ $1 = "run" ]]; then
  docker_run
elif [[ $1 = "shell" ]]; then
  docker_shell
elif [[ $1 = "kill" ]]; then
  docker_kill
else
  echo this command manages the virtual linux container
  echo   run - start up the container in the background
  echo   shell - open a shell in your running container
  echo   kill - kill the container in the background
fi
