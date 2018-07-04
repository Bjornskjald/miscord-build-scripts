#!/bin/bash

# --- functions ---
# https://stackoverflow.com/questions/25288194/
pushd () {
  command pushd "$@" > /dev/null
}

popd () {
  command popd "$@" > /dev/null
}

download_dependencies () {
  mkdir "scripts" "assets"

  get_script package-mac.sh
  get_script snap.sh
  get_script gh-upload.sh
  get_script makeself.sh

  get_asset Miscord.app.zip
  get_asset snap.zip
  get_asset makeself.zip
}

get_script () {
  wget --quiet "https://raw.githubusercontent.com/Bjornskjald/miscord-build-scripts/master/$1" -O "scripts/$1"
  chmod +x "scripts/$1"
}

get_asset () {
  wget --quiet "https://github.com/Bjornskjald/miscord-build-scripts/releases/download/assets/$1" -O "assets/$1"
  pushd "assets"
  unzip -qq "$1"
  popd
}

create_release () {
  AUTH="Authorization: token $GITHUB_API_TOKEN"
  local URL="https://api.github.com/repos/Bjornskjald/miscord/releases"
  local DATA='{"tag_name":"v'$VERSION'","target_commitish": "master","name": "'$VERSION'","body": "Release created automatically from Travis build.","draft": false,"prerelease": false}'
  curl -v -i -X POST -H "Content-Type:application/json" -H $AUTH $URL -d $DATA
}

# --- functions end ---

VERSION=$(node -pe "require('./package.json').version")
echo "Building Miscord v$VERSION..."

mkdir -p build

echo "Downloading dependencies..."
download_dependencies

npm install

npm run build:linux -- -o build/miscord-linux-x64 &
# npm run build:linux32 -- -o build/miscord-$VERSION-linux-x86 &
npm run build:win -- -o build/miscord-win.exe &
# npm run build:win32 -- -o build/miscord-$VERSION-win-x86.exe &
npm run build:mac -- -o build/miscord-macos &
wait

source scripts/makeself.sh

makeself_linux_x64 &
# makeself_linux_x86 &
makeself_mac &
wait


source scripts/package-mac.sh

create_release

for file in build/miscord-*; do
  scripts/gh-upload.sh $file
done

source scripts/snap.sh

echo "Finished."
