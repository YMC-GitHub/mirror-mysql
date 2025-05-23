#!/bin/sh
set -e

apk add --no-cache \
  mariadb \
  mariadb-client \
  tzdata \
  shadow \
  && rm -rf /var/cache/apk/*