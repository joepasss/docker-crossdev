#!/bin/bash

set -euo pipefail

if [[ ! -d /sources ]]; then
  mkdir /sources
fi

if [[ $(pwd) != "/sources" ]]; then
  cd /sources
fi

wget https://www.kernel.org/pub/software/scm/git/git-2.50.0.tar.xz
tar -xvf ./git-2.50.0.tar.xz

pushd ./git-2.50.0 || exit

if [[ -d ./build ]]; then
  rm -rf ./build
fi

mkdir build
cd build || exit

meson setup --cross-file /sources/cross.txt .. \
  --prefix=/usr/aarch64-unknown-linux-gnu/usr \
  --buildtype=release \
  -D tests=false

ninja
ninja install

popd || exit

### Write package.provided

if [[ ! -d /usr/aarch64-unknown-linux-gnu/etc/portage/profile ]]; then
  mkdir -pv /usr/aarch64-unknown-linux-gnu/etc/portage/profile
fi

if [[ ! -f /usr/aarch64-unknown-linux-gnu/etc/portage/profile/package.provided ]]; then
  touch /usr/aarch64-unknown-linux-gnu/etc/portage/profile/package.provided
fi

echo "dev-vcs/git-2.50.0" >>/usr/aarch64-unknown-linux-gnu/etc/portage/profile/package.provided

### masking

if [[ ! -d /usr/aarch64-unknown-linux-gnu/etc/portage/package.mask ]]; then
  mkdir -pv /usr/aarch64-unknown-linux-gnu/etc/portage/package.mask
fi

if [[ ! -f /usr/aarch64-unknown-linux-gnu/etc/portage/package.mask/git ]]; then
  touch /usr/aarch64-unknown-linux-gnu/etc/portage/package.mask/git
fi

echo ">=dev-vcs/git-2.50.0" >>/usr/aarch64-unknown-linux-gnu/etc/portage/package.mask/git
