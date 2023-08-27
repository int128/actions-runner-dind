#!/bin/bash
sudo /usr/local/bin/dind /usr/local/bin/dockerd &
exec "$@"
