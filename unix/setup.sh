#!/usr/bin/env bash

# Go to docker folder
cd "$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" || return >/dev/null 2>&1 && pwd)" || return

# Check for docker on path
echo "Looking for docker..."
command -v docker >/dev/null 2>&1 || {
  echo "Docker is not installed or available on path!"
  echo "Please make sure you have Docker installed before running this script"
  exit 1
}

echo "Looking for ch..."
command -v ch >/dev/null 2>&1 || {
    echo "Installing ch..."
    . ./unix/install-ch.sh
}

# Get mount point
echo "Preparing csci104 environment..."
read -r -p "Select a directory to mount: " work

while [[ ! -d "${work}" ]]; do
  echo "Invalid directory!"
  read -r -p "Select a directory to mount: " work
done

# Get absolute path of directory
work="$(cd "${work}" || return; pwd -P)"
echo "Mount point set, this can be changed later by editing $HOME/.ch.yaml..."

# Create csci104 environment with ch CLI
echo "Creating csci104 environment..."
ch create csci104 --image usccsci104/docker:latest --shell /bin/bash --volume "$work:/work" --security-opt seccomp:unconfined --cap-add SYS_PTRACE --replace

echo "Done!"

echo -e "\nRemember to run this command to add ch to your path:\n  source ~/.profile"