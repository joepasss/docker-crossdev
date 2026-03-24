#!/opt/homebrew/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

IMAGE_NAME="joepasss_bin:local"
CONTAINER_NAME="joepasss_bin"

docker build \
  -t "$IMAGE_NAME" "$SCRIPT_DIR"

if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  docker rm -f "$CONTAINER_NAME" >/dev/null
fi

docker run \
  -it \
  --name "$CONTAINER_NAME" \
  "$IMAGE_NAME"
