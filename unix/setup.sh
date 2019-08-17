#!/usr/bin/env bash

# go to docker folder
pushd "$(cd "$(dirname $(dirname "${BASH_SOURCE[0]}"))" >/dev/null 2>&1 && pwd)"

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
read -p "select a directory to mount: " work

while [[ ! -d "$work" ]]; do
  echo "invalid directory!"
  read -p "select a directory to mount: " work
done

# get absolute path of directory
work="$(cd "$(dirname "$work")"; pwd -P)"
echo "mount set, this can be changed later..."

# create manage scripts
echo "creating manager script..."
rm ./manage
echo "#!/usr/bin/env bash" >> ./manage
echo "" >> ./manage
echo "# change this to the directory you want to access in your container" >> ./manage
echo "work=${work}" >> ./manage
cat unix/manage.base.sh >> ./manage

echo "done!"
