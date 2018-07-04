#!/bin/bash

cp -r assets/Miscord.app build/

pushd build

sed s/%version-here%/$VERSION/g Miscord.app/Contents/Info.plist > Miscord.app/Contents/Info.plist
mv miscord-macos Miscord.app/Contents/Resources/script

zip -r miscord-macos.zip Miscord.app
rm -r Miscord.app

popd