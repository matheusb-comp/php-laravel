#!/bin/sh

# Get HOST and PORT from DATABASE_URL (remove '[' and ']' if IPv6)
HOST_PORT=$(echo $DATABASE_URL | \
  sed 's/.*@\[\?\([^]]\+\)\]\?:\(.\+\)\/.*/\1 \2/')
HOST=$(echo $HOST_PORT | awk '{ print $1; }')
PORT=$(echo $HOST_PORT | awk '{ print $2; }')

# Abort if there is no host or port to check the database
if ([ -z "$HOST" ] && [ -z "$DB_HOST" ]) || \
  ([ -z "$PORT" ] && [ -z "$DB_PORT" ]); then
  echo "## ERROR: No host or port for testing the database connection" >&2
  exit 1
fi

# Checks the connection with netcat -z
# Based on: https://github.com/vishnubob/wait-for-it
until nc -z -v -w 30 ${HOST:-"$DB_HOST"} ${PORT:-"$DB_PORT"}; do
  echo "## Could not connect to the database. Waiting 5 seconds..."
  sleep 5
done
