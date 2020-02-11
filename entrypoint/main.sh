#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Move to the entrypoint directory
cd $(dirname "$0")

# Export the default gateway IP
export DEFAULT_GATEWAY=$(ip route | awk '/default/ { print $3 }')

# Try exporting the Docker secrets for variables starting with 'SECRET_'
. ./export-secrets.sh "SECRET_"

# If 'artisan' is present, setup the Laravel specific configurations
APP_ROOT=${APP_ROOT:-"/var/www/html"}
if [ -e "${APP_ROOT}/artisan" ]; then
  . ./laravel.sh
fi

# Wait until the database is accessible if requested
if [ "$DATABASE_WAIT" = "true" ]; then
  # Set the gateway ip as a fallback database host
  if [ -z "$DATABASE_URL" ]; then
    export DB_HOST="${DB_HOST:-$DEFAULT_GATEWAY}"
  fi

  # Must be exported: $DATABASE_URL or ($DB_HOST and $DB_PORT)
  . ./wait-database.sh
fi

# Go back to where the script was called
cd - > /dev/null 2>&1

# Continue with the execution of the commands received
exec "$@"
