#!/bin/bash

if [ -f /calibre-library/metadata.db ]; then
  echo "Database already exists."
else
  echo "Copying blank database."
  cp /etc/firstrun/metadata.db /calibre-library
fi