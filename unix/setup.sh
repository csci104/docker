#!/usr/bin/env bash

manage="./manage.sh"

# Go to docker folder
cd "$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" || return >/dev/null 2>&1 && pwd)" || return

# Check for docker on path
echo "Looking for docker..."
command -v docker >/dev/null 2>&1 || {
  echo "Docker is not installed or available on path!"
  exit 1
}

echo "Looking for ch..."
command -v ch >/dev/null 2>&1 || {
    echo "Installing ch..."
    . ./unix/install-ch.sh
}

# # Pull docker image
# echo "Pulling docker image..."
# docker pull usccsci104/docker:latest || exit $?

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

# Create manage scripts
echo "Creating csci104 environment..."
ch create csci104 --image usccsci104/docker:latest --shell /bin/bash --volume "$work:/work" --security-opt seccomp:unconfined --cap-add SYS_PTRACE --replace
# rm ${manage} 2> /dev/null
# {
#   echo "#!/usr/bin/env bash";
#   echo ""
#   echo "# Change this to the directory you want to access in your container."
#   echo "work=${work}"
#   echo ""
#   cat ./unix/manage.base.sh
# } >> ${manage};
# chmod +x ${manage}

echo "Done!"
