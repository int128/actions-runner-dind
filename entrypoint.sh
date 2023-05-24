#!/bin/bash
sudo /usr/bin/dockerd &

for i in {1..60}; do
  if docker version --format '{{.Server.Version}}'; then
    break
  fi
  sleep 1
done
