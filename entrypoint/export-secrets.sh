#!/bin/sh

# Export the values in the files pointed by variables starting with $PREFIX
# Based on wordpress' docker-entrypoint.sh
# https://github.com/docker-library/wordpress/blob/master/php7.3/fpm-alpine/docker-entrypoint.sh

PREFIX="${1:-SECRET_}"
# Using 'set | grep ^SECRET_' because '${!SECRET_@}' is not POSIX
for NAME in $(set | grep ^"$PREFIX" | awk -F= '{ print $1 }'); do
  # Variable name without the prefix
  VAR=${NAME#"$PREFIX"}
  # Indirect expansion in POSIX: https://unix.stackexchange.com/a/111627
  eval res="\$$VAR"
  # Get from file only if the variable isn't already set
  if [ -z "${res:+unsetornull}" ]; then
    eval res="\$$NAME"
    # Check if the file exists before exporting
    if [ -f "$res" ]; then
      export "$VAR"=$(cat "$res")
    fi
  fi
done
