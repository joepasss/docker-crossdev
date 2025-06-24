#!/bin/bash

set -euo pipefail

IS_PROD="${IS_PROD:-false}"
MAKECONF_PATH="${1:-/etc/portage/make.conf}"

if [[ "$IS_PROD" == "true" ]]; then
  MAKEJOBS="1"
else
  MAKEJOBS="$(nproc)"
fi

{
  echo "MAKEOPTS=\"-j$MAKEJOBS\""

  echo 'USE="minimal seccomp -su -doc -nls -man -perl -pam -acl -xattr -dbus -udev -systemd -readline -gpm -bash-completion -examples -test -alsa -pipewire -pulseaudio -jack -X -wayland -vnc -opengl -vulkan -cuda -bluetooth -apparmor -hardened -selinux -filecaps -jemalloc -lzo -snappy -sasl -smartcard -oss -idn -lua -gui -openmp -lzma -jpeg -test-rust -go"'

  echo 'FEATURES="-test -sandbox -ipc-sandbox -network-sandbox -pid-sandbox nodoc noinfo noman"'
  echo 'INSTALL_MASK="/usr/share/man /usr/share/doc /usr/share/info /usr/share/gtk-doc /usr/share/locale /usr/lib/locale"'

  echo 'INPUT_DEVICES=""'
  echo 'VIDEO_CARDS=""'
  echo 'ACCEPT_LICENSE="*"'
} >>"$MAKECONF_PATH"
