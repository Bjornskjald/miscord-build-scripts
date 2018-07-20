makeself_linux () {
  local DIR="tmp-ms-linux"

  mkdir $DIR
  mv build/miscord-linux $DIR
  makeself $DIR miscord-linux
  mv miscord-linux.run build/
  rm -r $DIR
}

makeself_linux_x86 () {
  local DIR="tmp-ms-linux-x86"

  mkdir $DIR
  mv build/miscord-linux-x86 $DIR
  makeself $DIR miscord-linux-x86
  mv miscord-linux-x86.run build/
  rm -r $DIR
}

makeself_mac () {
  local DIR="tmp-ms-mac"

  mkdir $DIR
  cp build/miscord-macos $DIR
  makeself $DIR miscord-macos
  mv miscord-macos.run build/
  rm -r $DIR
}

makeself () {
  assets/makeself/makeself.sh --gzip $1 $2.run "Miscord" ./$2
}