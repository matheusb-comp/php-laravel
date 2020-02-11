# Docker PHP image for Laravel

Docker image based on [php:7.3-fpm-alpine](https://hub.docker.com/_/php/), with [Supervisor](http://supervisord.org/), and all the
dependencies needed to run a [Laravel](https://laravel.com/) application using
a [PostgreSQL](https://www.postgresql.org/) database.

The image also installs `tzdata`, and the [Redis](https://github.com/phpredis/phpredis) PHP extension.

## Resources

The `docker` folder has examples of `stack` configuration files for Docker swarm using this image.

The folder also includes scripts to download [Let's Encrypt](https://letsencrypt.org/) SSL/TLS certificates using the Certbot [docker image](https://hub.docker.com/r/certbot/certbot/), and the [NGINX](https://www.nginx.com/) configuration to serve HTTPS requests.

---

- TODO: Explain step-by-step how to obtain, link and renew certificates
- TODO: Explain how to use the scripts to start the stack and exec into containers
