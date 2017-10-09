#!/bin/bash

URL_PREFIX=${URL_PREFIX}
#if [ -n "$URL_PREFIX" ]; then
#  /opt/calibre/calibre-server --daemonize --log=/dev/stdout "/calibre-library"
#else
  /opt/calibre/calibre-server --log=/dev/stdout --url-prefix="$URL_PREFIX" "/calibre-library"
#fi