#!/usr/bin/env bash

manage="./manage.sh"

# go to docker folder
cd "$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" || return >/dev/null 2>&1 && pwd)" || return

# check for docker on path
echo "looking for docker..."
command -v docker >/dev/null 2>&1 || {
  echo >&2 "docker is not installed or available on path!";
  exit 1;
}

# create docker image
echo "creating docker image..."
docker build -t csci104 -f ./Dockerfile . || exit $?

# get mount point
echo "creating manager script..."
read -r -p "select a directory to mount: " work

while [[ ! -d "${work}" ]]; do
  echo "invalid directory!"
  read -r -p "select a directory to mount: " work
done

# get absolute path of directory
work="$(cd "${work}" || return; pwd -P)"
echo "mount set, this can be changed later..."

# create manage scripts
echo "creating manager script..."
rm ${manage} 2> /dev/null
{
  echo "#!/usr/bin/env bash";
  echo ""
  echo "# change this to the directory you want to access in your container"
  echo "work=${work}"
  echo ""
  cat ./unix/manage.base.sh
} >> ${manage};
chmod +x ${manage}

echo "done!"
