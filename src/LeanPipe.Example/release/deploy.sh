#!/usr/bin/env bash
set -e

readonly ACR_NAME="leancode"
export APP_NAME="leanpipe-example"
APP_VERSION=""

while getopts "v:" opt; do
  case $opt in
    v) APP_VERSION="$OPTARG";;
    *) echo "Invalid argument." >&2; exit 1 ;;
  esac
done

if [ -z "$APP_VERSION" ]; then
  echo "Please specify the version using the -v argument." >&2
  exit 1
fi

export IMAGE_NAME="$ACR_NAME.azurecr.io/$APP_NAME:$APP_VERSION"

# Build and push to ACR
az acr login -n "$ACR_NAME"
docker build -t "$IMAGE_NAME" -f ./Dockerfile ../../../
docker push "$IMAGE_NAME"

# Deploy to cluster
export CPU_REQUEST="100m"
export MEMORY_REQUEST="128Mi"
export CPU_LIMIT="100m"
export MEMORY_LIMIT="128Mi"

envsubst < "$APP_NAME.yaml.tpl" > "$APP_NAME.yaml"
kubectl apply -f "$APP_NAME.yaml"
rm "$APP_NAME.yaml"
