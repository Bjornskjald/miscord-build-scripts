#!/bin/bash

# --- functions ---
# https://stackoverflow.com/questions/25288194/
# pushd () {
#   command pushd "$@" &> /dev/null
# }

# popd () {
#   command popd "$@" &> /dev/null
# }

download_dependencies () {
  mkdir "scripts" "assets"

  get_script package-mac.sh
  get_script snap.sh
  get_script gh-upload.sh
  get_script makeself.sh

  get_asset Miscord.app.zip
  get_asset snap.zip
  get_asset makeself.zip

  wget --quiet "https://github.com/github/hub/releases/download/v2.4.0/hub-linux-amd64-2.4.0.tgz"
  tar -xzf hub-linux-amd64-2.4.0.tgz
  mv hub-linux-amd64-2.4.0/bin/hub scripts/hub
  rm -r hub-linux-amd64-2.4.0.tgz hub-linux-amd64-2.4.0
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

assets=()
for f in "$asset_dir"/*; do [ -f "$f" ] && assets+=(-a "$f"); done
MESSAGE="Release generated automatically with [`miscord-build-scripts`](https://github.com/Bjornskjald/miscord-build-scripts/) via [`hub`](https://github.com/github/hub/)"
scripts/hub release create "${assets[@]}" -m "$VERSION\n$MESSAGE" "$VERSION"

source scripts/snap.sh

echo "Finished."
