#!/bin/bash

sudo /usr/bin/dockerd &
exec /home/runner/run.sh "$@"
