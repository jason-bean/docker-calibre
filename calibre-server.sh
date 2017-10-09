#!/bin/bash

URL_PREFIX=${URL_PREFIX}
/opt/calibre/calibre-server --log=/dev/stdout --url-prefix="$URL_PREFIX" "/calibre-library"