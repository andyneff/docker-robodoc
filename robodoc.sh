#!/usr/bin/env sh

set -eu

#Robodoc entry point
if ! getent group ${DOCKER_GID} &> /dev/null; then
  addgroup -g ${DOCKER_GID} user
fi

if getent passwd ${DOCKER_UID} &> /dev/null; then
  adduser -g ${DOCKER_GID} -u ${DOCKER_UID} user
fi

chown ${DOCKER_UID}:${DOCKER_GID} /doc

exec gosu ${DOCKER_UID}:${DOCKER_GID} robodoc --src /src --doc /doc ${@+"${@}"}