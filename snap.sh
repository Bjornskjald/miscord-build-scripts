#!/bin/bash

SNAP_CONFIG=$HOME/.config/snapcraft/
mkdir -p $SNAP_CONFIG

mkdir -p build/snap-x64/{snap,prime/bin}
# mkdir -p build/snap-x86/{snap,prime/bin}

cp build/miscord-linux-x64.run build/snap-x64/prime/bin/miscord
cp assets/snap/icon.png build/snap-x64/
cp assets/snap/snapcraft.cfg $SNAP_CONFIG/
set s/%macaroon%/$SNAP_MACAROON/ assets/snap/snapcraft.cfg | sed s/%unbound_discharge%/$SNAP_UNBOUND_DISCHARGE/ | sed s/%email%/$SNAP_EMAIL/ > $SNAP_CONFIG/snapcraft.cfg

sed s/%version-here%/$VERSION/ assets/snap/snapcraft.yaml | sed 's/%arch-here%/amd64/' > build/snap-x64/snapcraft.yaml
pushd build/snap-x64
docker run --rm -v $PWD:$PWD -w $PWD snapcore/snapcraft snapcraft
docker run --rm -v $PWD:$PWD -v $SNAP_CONFIG:$SNAP_CONFIG -w $PWD snapcore/snapcraft snapcraft login --with $SNAP_CONFIG/snapcraft.cfg
docker run --rm -v $PWD:$PWD -v $SNAP_CONFIG:$SNAP_CONFIG -w $PWD snapcore/snapcraft snapcraft push miscord_"$VERSION"_amd64.snap --release=stable
popd

# cp build/miscord-linux-x86.run build/snap-x86/prime/bin/miscord
# cp assets/snap/icon.png build/snap-x86/
# sed s/%version-here%/$1/ assets/snap/snapcraft.yaml | sed 's/%arch-here%/i386/' > build/snap-x86/snapcraft.yaml
# pushd build/snap-x86
# docker run --rm -v $PWD:$PWD -w $PWD snapcore/snapcraft snapcraft
# docker run --rm -v $PWD:$PWD -v $SNAP_CONFIG:$SNAP_CONFIG -w $PWD snapcore/snapcraft snapcraft push miscord_$1_amd64.snap --release=stable
# popd
