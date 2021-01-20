#!/bin/bash
repository="camerondurham/ch"

function get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |   # Get latest release from GitHub api
  grep '"tag_name":' |                                                # Get tag line
  sed -E 's/.*"([^"]+)".*/\1/'                                        # Pluck JSON value
}

function get_release_package() {
  download_url=$1
  download_path=$2
  filename=$3
  cd "$download_path" || exit 1
  if ! curl -LO "$download_url"; then
    echo Download failed...
    exit 1
  fi

  if ! unzip -o "$filename"; then
    echo Unzip failed...
    exit 1
  fi
}

function get_release_url() {
  local repo=$1
  local version=$2
  local filename=$3
  echo "https://github.com/$repo/releases/download/$version/$filename"
}

function add_if_not_present() {
  local export_command=$1
  local file=$2
  if ! grep "$export_command" "$file" &> /dev/null; then
    echo "Adding path to ch to $file"
    echo "$export_command" >> "$file"
  fi
}

function add_to_path() {
  local location=$1
  if [ ! -d "$location" ]; then
    echo No such directory: "$location"
    exit 1
  fi

  # add to current profile
  export PATH="$PATH:$location"
  local export_command="export PATH=\"\$PATH:$location\""

  if [ -e "$HOME/.zprofile" ] || [ "${SHELL##*/}" = "zsh" ]; then
    add_if_not_present "$export_command" "$HOME/.zprofile"
    add_if_not_present "$export_command" "$HOME/.zshrc"
  elif [ -e "$HOME/.bash_profile" ] || [ "${SHELL##*/}" = "bash" ]; then
    add_if_not_present "$export_command" "$HOME/.bash_profile"
    add_if_not_present "$export_command" "$HOME/.bashrc"
  else
    add_if_not_present "$export_command" "$HOME/.profile"
  fi
}

version=$(get_latest_release $repository)

zip_filename=
if [ "$(uname)" = "Linux" ]; then
  zip_filename="ch-linux-amd64.zip"
else
  zip_filename="ch-darwin-amd64.zip"
fi

release_url=$(get_release_url "$repository" "$version" "$zip_filename")
get_release_package "$release_url" "$HOME" "$zip_filename"

# remove downloaded zip file
rm -f "$HOME/$zip_filename"

# add directory to path if not already already present
if ! echo "$PATH" | grep ${zip_filename%.*} > /dev/null ; then
  add_to_path "$HOME/${zip_filename%.*}"
fi

echo "Done! Try using ch with: ch --help"