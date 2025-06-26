#!/bin/bash

set -euo pipefail

IS_PROD="${IS_PROD:-false}"
MAKECONF_PATH="${1:-/etc/portage/make.conf}"

if [[ "$IS_PROD" == "true" ]]; then
  MAKEJOBS="1"
else
  MAKEJOBS="$(nproc)"
fi

sed -i "/^MAKEOPTS=/d" "$MAKECONF_PATH"
echo "MAKEOPTS=\"-j$MAKEJOBS\"" >>"$MAKECONF_PATH"
