download_dependencies () {
  get_script package-mac.sh
  get_script snap.sh
  get_script gh-upload.sh
  get_script makeself.sh

  get_asset Miscord.app.zip
  get_asset snap.zip
  get_asset makeself.zip
}

get_script () {
  wget "https://raw.githubusercontent.com/Bjornskjald/miscord-build-scripts/master/$1" -O "scripts/$1"
  chmod +x "scripts/$1"
}
get_asset () {
  wget "https://github.com/Bjornskjald/miscord-build-scripts/releases/download/assets/$1" -O "assets/$1"
  unzip "assets/$1"
}

create_release () {
  AUTH="Authorization: token $GITHUB_API_TOKEN"
  local URL="https://api.github.com/repos/Bjornskjald/miscord/releases"
  local DATA='{"tag_name":"v'$VERSION'","target_commitish": "master","name": "'$VERSION'","body": "Release created automatically from Travis build.","draft": false,"prerelease": false}'
  curl -v -i -X POST -H "Content-Type:application/json" -H $AUTH $URL -d 
}