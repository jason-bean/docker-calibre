#!/bin/bash

if [ -f /calibre-library/metadata.db ]; then
  echo "Database already exists."
else
  echo "Copying new empty database."
  cp /etc/firstrun/metadata.db /calibre-library
  chown nobody:users -R /calibre-library
  chmod 755 -R /calibre-library
fi
