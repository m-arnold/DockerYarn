#!/bin/bash

touch yarn.lock

DOCKERNAME="cjengineering/yarn-builder"

# Init empty cache file
if [ ! -f .yarn-cache.tgz ]; then
  echo "Init empty .yarn-cache.tgz"
  tar cvzf .yarn-cache.tgz --files-from /dev/null
fi

docker build . -t $DOCKERNAME

docker run --rm --entrypoint cat $DOCKERNAME:latest /tmp/yarn.lock > /tmp/yarn.lock
if ! diff -q yarn.lock /tmp/yarn.lock > /dev/null  2>&1; then
  echo "Saving Yarn cache"
  docker run --rm --entrypoint tar $DOCKERNAME:latest czf - /root/.yarn-cache/ > .yarn-cache.tgz
  echo "Saving yarn.lock"
  cp /tmp/yarn.lock yarn.lock
fi
