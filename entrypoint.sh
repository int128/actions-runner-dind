#!/bin/bash

wait_for_docker () {
  for i in {1..60}; do
    if docker version --format '{{.Server.Version}}'; then
      return
    fi
    sleep 1
  done
  exit 1
}

sudo /usr/bin/dockerd &
wait_for_docker
