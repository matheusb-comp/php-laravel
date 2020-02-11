#!/bin/sh

# Directory with the Laravel source code
APP_DIR=${APP_DIR:-"/var/www/html"}

# Configure the crontab to run the Laravel scheduler every minute
# From: https://stackoverflow.com/a/9625233
(
  crontab -l 2>/dev/null;
  echo "* * * * * cd ${APP_DIR} && php artisan schedule:run >> /dev/null 2>&1"
) | crontab -

# Set the Linux ACL to give www-data write permissions
if [ -d "${APP_DIR}/storage" ] && [ -d "${APP_DIR}/bootstrap/cache" ]; then
  # Cannot be set in the Dockerfile: https://stackoverflow.com/q/47337594
  setfacl -Rm d:u:www-data:rwX,u:www-data:rwX \
    "${APP_DIR}/storage" "${APP_DIR}/bootstrap/cache"
fi
