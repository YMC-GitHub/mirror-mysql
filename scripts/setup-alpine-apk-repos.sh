#!/bin/sh
set -e

if [ "$NETWORK" = "cn" ]; then
    sed -i "s|dl-cdn.alpinelinux.org|${APK_REPO_CN}|g" /etc/apk/repositories
else
    sed -i "s|dl-cdn.alpinelinux.org|${APK_REPO_GLOBAL}|g" /etc/apk/repositories
fi