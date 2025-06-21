#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

IMAGE_NAME="crossdev:local"
CONTAINER_NAME="crossdev"

docker build \
  --build-arg IS_PROD=false \
  -t "$IMAGE_NAME" "$SCRIPT_DIR"

if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  docker rm -f "$CONTAINER_NAME" >/dev/null
fi

docker run \
  -it \
  --name "$CONTAINER_NAME" \
  "$IMAGE_NAME"
