#!/bin/bash

cp -r assets/Miscord.app build/

pushd $BUILD_DIR

sed s/%version-here%/$VERSION/g Miscord.app/Contents/Info.plist > Miscord.app/Contents/Info.plist
mv miscord-macos Miscord.app/Contents/Resources/script

zip -r miscord-$1-macos.zip Miscord.app
rm -r Miscord.app

popd