#!/bin/bash -e

if [ "$IS_PULL_REQUEST" != true ]; then
  sudo docker build -t trriplejay/simpleserver:$BRANCH.$SHIPPABLE_BUILD_NUMBER \
    --build-arg mytag=$BRANCH.$SHIPPABLE_BUILD_NUMBER .
  sudo docker push trriplejay/simpleserver:$BRANCH.$SHIPPABLE_BUILD_NUMBER
else
  echo "skipping because it's a PR"
fi