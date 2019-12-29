#!/usr/bin/env bash

manage="./manage.sh"

# go to docker folder
cd "$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" || return >/dev/null 2>&1 && pwd)" || return

# check for docker on path
echo "Looking for docker..."
command -v docker >/dev/null 2>&1 || {
  echo >&2 "Docker is not installed or available on path!";
  exit 1;
}

# create docker image
echo "Creating docker image..."
docker build -t csci104 -f ./Dockerfile . || exit $?

# get mount point
echo "Creating manager script..."
read -r -p "Select a directory to mount: " work

while [[ ! -d "${work}" ]]; do
  echo "Invalid directory!"
  read -r -p "Select a directory to mount: " work
done

# get absolute path of directory
work="$(cd "${work}" || return; pwd -P)"
echo "Mount point set, this can be changed later..."

# create manage scripts
echo "Creating manager script..."
rm ${manage} 2> /dev/null
{
  echo "#!/usr/bin/env bash";
  echo ""
  echo "# Change this to the directory you want to access in your container."
  echo "work=${work}"
  echo ""
  cat ./unix/manage.base.sh
} >> ${manage};
chmod +x ${manage}

echo "Done!"
