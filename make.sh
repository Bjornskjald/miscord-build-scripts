#!/bin/bash

# Import all functions from other files
source scripts/functions.sh
source scripts/makeself.sh

VERSION=$(node -pe "require('./package.json').version")
echo "Building Miscord v$VERSION..."

mkdir -p build

echo "Downloading dependencies..."
download_dependencies

npm run build:linux -- -o build/miscord-linux-x64 &
# npm run build:linux32 -- -o build/miscord-$VERSION-linux-x86 &
npm run build:win -- -o build/miscord-win.exe &
# npm run build:win32 -- -o build/miscord-$VERSION-win-x86.exe &
npm run build:mac -- -o build/miscord-macos &
wait

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
