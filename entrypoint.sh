#!/bin/bash

sudo /usr/bin/dockerd &

while ! pgrep dockerd; do
  sleep 1
done

exec /home/runner/run.sh "$@"
