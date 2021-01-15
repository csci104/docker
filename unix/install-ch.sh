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

function append_path_to_file() {
  local location=$1
  local target_file=$2
  echo "export PATH=\"\$PATH:$location\"" >> "$target_file"
}

function add_to_path() {
  local location=$1
  if [ ! -d "$location" ]; then
    echo No such directory: "$location"
    exit 1
  fi

  if [ -e "$HOME/.bashrc" ] || [ "$0" = "-bash" ]; then
    echo "Adding to $HOME/.bashrc"
    append_path_to_file "$location" "$HOME/.bashrc"
  elif [ -e "$HOME/.zshrc" ] || [ "$0" = "-zsh" ]; then
    echo "Adding to $HOME/.zshrc"
    append_path_to_file "$location" "$HOME/.zshrc"
  else
    echo -e "No $HOME/.bashrc or $HOME/.zshrc found...\nPlease add this line to your preferred shell profile:"
    echo "echo export PATH=\"\$PATH:$location\" >> $HOME/.zshrc"
    exit 1
  fi
  # add to current profile
  export PATH="$PATH:$location"
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

add_to_path "$HOME/${zip_filename%.*}"

echo "Done! Try using ch with: ch --help"