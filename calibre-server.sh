URL_PREFIX=${URL_PREFIX}
if [ -n "$URL_PREFIX" ]; then
  /opt/calibre/calibre-server --daemonize "/calibre-library"
else
  /opt/calibre/calibre-server --daemonize --url-prefix="$URL_PREFIX" "/calibre-library"
fi