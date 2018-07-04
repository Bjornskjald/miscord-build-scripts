makeself_linux_x64 () {
  local DIR="tmp-ms-linux-x64"

  mkdir $DIR
  mv build/miscord-$VERSION-linux-x64 $DIR
  makeself $DIR miscord-$VERSION-linux-x64
  mv miscord-$VERSION-linux-x64.run build/
  rm -r $DIR
}

makeself_linux_x86 () {
  local DIR="tmp-ms-linux-x86"

  mkdir $DIR
  mv build/miscord-$VERSION-linux-x86 $DIR
  makeself $DIR miscord-$VERSION-linux-x86
  mv miscord-$VERSION-linux-x86.run build/
  rm -r $DIR
}

makeself_mac () {
  local DIR="tmp-ms-mac"

  mkdir $DIR
  cp build/miscord-$VERSION-macos $DIR
  makeself $DIR miscord-$VERSION-macos
  mv miscord-$VERSION-macos.run build/
  rm -r $DIR
}

makeself () {
  assets/makeself/makeself.sh --gzip $1 $2.run "Miscord" ./$2
}