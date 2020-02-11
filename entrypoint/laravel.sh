#!/bin/sh

# Directory with the Laravel source code
APP_ROOT=${APP_ROOT:-"/var/www/html"}

# Configure the crontab to run the Laravel scheduler every minute
# From: https://stackoverflow.com/a/9625233
(
  crontab -l 2>/dev/null;
  echo "* * * * * cd ${APP_ROOT} && php artisan schedule:run >> /dev/null 2>&1"
) | crontab -

# Set the Linux ACL to give www-data write permissions
if [ -d "${APP_ROOT}/storage" ] && [ -d "${APP_ROOT}/bootstrap/cache" ]; then
  # Cannot be set in the Dockerfile: https://stackoverflow.com/q/47337594
  setfacl -Rm d:u:www-data:rwX,u:www-data:rwX \
    "${APP_ROOT}/storage" "${APP_ROOT}/bootstrap/cache"
fi
