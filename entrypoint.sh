#!/usr/bin/env bash
if [[ "${ANSIBLE_CONFIG}" == "true" ]]
then
  ansible-galaxy install -r requirements.yml
fi
exec "$@"
