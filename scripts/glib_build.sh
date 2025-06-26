#!/bin/bash

set -euo pipefail

if [[ ! -d /sources ]]; then
  mkdir /sources
fi

if [[ $(pwd) != "/sources" ]]; then
  cd /sources
fi

wget https://download.gnome.org/sources/glib/2.84/glib-2.84.3.tar.xz
tar -xvf ./glib-2.84.3.tar.xz

pushd ./glib-2.84.3 || exit

if [[ -d ./build ]]; then
  rm -rf ./build
fi

mkdir build
cd build || exit

meson setup --cross-file /sources/cross-glib.txt .. \
  --prefix=/usr/aarch64-unknown-linux-gnu/usr \
  --buildtype=release \
  --libdir=lib64 \
  -D introspection=disabled \
  -D glib_debug=disabled \
  -D man-pages=disabled \
  -D sysprof=disabled

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

{
  echo "dev-libs/glib-2.84.3"
  echo "dev-libs/gobject-introspection-1.84.0"
} >>/usr/aarch64-unknown-linux-gnu/etc/portage/profile/package.provided

### masking

if [[ ! -d /usr/aarch64-unknown-linux-gnu/etc/portage/package.mask ]]; then
  mkdir -pv /usr/aarch64-unknown-linux-gnu/etc/portage/package.mask
fi

if [[ ! -f /usr/aarch64-unknown-linux-gnu/etc/portage/package.mask/glib ]]; then
  touch /usr/aarch64-unknown-linux-gnu/etc/portage/package.mask/glib
fi

if [[ ! -f /usr/aarch64-unknown-linux-gnu/etc/portage/package.mask/gobject-introspection ]]; then
  touch /usr/aarch64-unknown-linux-gnu/etc/portage/package.mask/gobject-introspection
fi

echo ">=dev-libs/glib-2.0" >>/usr/aarch64-unknown-linux-gnu/etc/portage/package.mask/glib
echo ">=dev-libs/gobject-introspection-1.84.0" >>/usr/aarch64-unknown-linux-gnu/etc/portage/package.mask/gobject-introspection
