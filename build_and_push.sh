#!/usr/bin/env sh
set -e

ACR_NAME="leancode"
APP_VERSION=""

while getopts "v:" opt; do
  case $opt in
    v) APP_VERSION="$OPTARG";;
    *) echo "Invalid argument"; exit 1;;
  esac
done

if [ -z "$APP_VERSION" ]; then
  echo "Please specify the version using the -v argument."
  exit 1
fi

IMAGE_NAME="$ACR_NAME.azurecr.io/leanpipe-example:$APP_VERSION"

# Push to ACR
az acr login -n "$ACR_NAME"
docker build . -t "$IMAGE_NAME"
docker push "$IMAGE_NAME"

# Deploy to cluster
export APP_VERSION=$APP_VERSION
NAMESPACE="leanpipe-example"

if kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
  echo "Namespace $NAMESPACE already exists."
else
  kubectl create namespace "$NAMESPACE"
fi

envsubst < leanpipe-example.yaml.tpl > leanpipe-example.yaml
kubectl apply -f leanpipe-example.yaml

rm leanpipe-example.yaml
