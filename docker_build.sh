#!/opt/homebrew/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

IMAGE_NAME="crossdev:local"
CONTAINER_NAME="crossdev"
DATE=$(date '+%Y%m%d')

function help() {
  echo "help	: show this message"
  echo "test	: build & run"
  echo "deploy: build & deploy"
}

function build() {
  docker build \
    -t "$IMAGE_NAME" "$SCRIPT_DIR"

  if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    docker rm -f "$CONTAINER_NAME" >/dev/null
  fi
}

function test() {
  docker run \
    -it \
    --privileged \
    --name "$CONTAINER_NAME" \
    "$IMAGE_NAME"
}

function deploy() {
  docker tag "$IMAGE_NAME" "joepasss/$CONTAINER_NAME:$DATE"
  docker push "joepasss/$CONTAINER_NAME:$DATE"

  docker tag "$IMAGE_NAME" "joepasss/$CONTAINER_NAME:latest"
  docker push "joepasss/$CONTAINER_NAME:latest"
}

case $1 in
  help)
    help
    ;;

  test)
    build
    test
    ;;

  deploy)
    build
    deploy
    ;;

  *)
    help
    ;;

esac
