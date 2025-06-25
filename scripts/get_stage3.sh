#!/bin/bash

set -euo pipefail

URL_PREFIX="https://gentoo.osuosl.org/releases/arm64/autobuilds"
LATEST_STAGE3_ARM64="https://gentoo.osuosl.org/releases/arm64/autobuilds/latest-stage3-arm64-openrc.txt"

if [[ ! -d /sources ]]; then
  mkdir /sources
fi

if [[ $(pwd) != "/sources" ]]; then
  cd /sources
fi

wget "$LATEST_STAGE3_ARM64" -O latest_stage3_arm64

LATEST_STAGE3_ARM64_TARBALL="$URL_PREFIX/$(grep -o '[0-9TZ]\+/stage3-arm64-openrc-[0-9TZ]\+\.tar\.xz' latest_stage3_arm64)"

wget "$LATEST_STAGE3_ARM64_TARBALL" -O stage3-arm64-latest.tar.xz

tar -xJpf stage3-arm64-latest.tar.xz -C /usr/aarch64-unknown-linux-gnu --exclude=dev --skip-old-files
