#!/usr/bin/env bash
#
# Author: Stefan Buck
# License: MIT
# https://gist.github.com/stefanbuck/ce788fee19ab6eb0b4447a85fc99f447

echo "Uploading asset $1..."

set -e
xargs=$(which gxargs || which xargs)

# Validate settings.
[ "$TRACE" ] && set -x

# Define variables.
GH_REPO="repos/Bjornskjald/miscord"
WGET_ARGS="--content-disposition --auth-no-challenge --no-cookie"
CURL_ARGS="-LJO#"

# Read asset tags.
response=$(curl -sH "$AUTH" "https://api.github.com/$GH_REPO/releases/latest")

# Get ID of the asset based on given filename.
eval $(echo "$response" | grep -m 1 "id.:" | grep -w id | tr : = | tr -cd '[[:alnum:]]=')
[ "$id" ] || { echo "Error: Failed to get release id for tag: $tag"; echo "$response" | awk 'length($0)<100' >&2; exit 1; }

FILENAME=$(echo $1 | sed s/-/-$VERSION-/)

# Construct url
GH_ASSET="https://uploads.github.com/$GH_REPO/releases/$id/assets?name=$(basename $FILENAME)"

curl "$GITHUB_OAUTH_BASIC" --data-binary @"$2" -H $AUTH -H "Content-Type: application/octet-stream" -o /dev/null $GH_ASSET
