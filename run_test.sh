#!/usr/bin/env bash
set -e
# test running ansible locally.
docker-compose build test
docker-compose run test playbook.yml

docker-compose run test remote.yml -i inventory