container="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)/.container"

if [[ $1 = "run" ]]; then
  if [[ -f ${container} ]]; then
    echo "a container seems to be running, use the kill command"
  else
    echo "running container..."
    docker run -v "${work}":/work -d -t --security-opt seccomp:unconfined --cap-add SYS_PTRACE csci104 1> ${container}
    if [[ $? -eq 0 ]]; then
      rm ${container}
    fi
  fi
elif [[ $1 = "shell" ]]; then
  if [[ -f ${container} ]]; then
    id=$(<${container})
    docker exec -it ${id} bash
  else
    echo "a container doesn't seem to be running..."
  fi
elif [[ $1 = "kill" ]]; then
  if [[ -f ${container} ]]; then
    id=$(<${container})
    docker kill ${id}
    rm ${container}
  else
    echo "a container doesn't seem to be running..."
  fi
else
  echo this command manages the virtual linux container!
  echo   run - start up the container in the background
  echo   shell - open a shell in your running container
  echo   kill - kill the container in the background
fi
