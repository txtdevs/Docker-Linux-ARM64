ARG PHP_VER=7.4-fpm
ARG PHP_REGISTRY=txtdevs/php

FROM --platform=$BUILDPLATFORM ${PHP_REGISTRY}:${PHP_VER}

ENV WEB_DOCUMENT_ROOT=/app \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.test \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET=""
ENV WEB_PHP_SOCKET=127.0.0.1:9000
ENV SERVICE_NGINX_CLIENT_MAX_BODY_SIZE="100m"

COPY conf/ /opt/docker/

RUN set -x \
    # Install nginx
    && printf "deb http://nginx.org/packages/debian/ $(docker-image-info dist-codename)  nginx\n deb-src http://nginx.org/packages/debian/ $(docker-image-info dist-codename) nginx" \
    >> /etc/apt/sources.list \
    && curl -L https://nginx.org/keys/nginx_signing.key | apt-key add - \
    && apt-install \
    nginx \
    && docker-run-bootstrap \
    && docker-image-cleanup

WORKDIR /app

EXPOSE 80 443

ARG BUILD_DATE
ARG IMAGE_PATCH_VER=0

LABEL \
    org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.application="Nginx & PHP 7.4" \
    org.label-schema.docker.cmd="docker run -d -p 80:80 -p 443:443 -v /var/run/docker.sock:/var/run/docker.sock --mount source=nginx-php-txtdevs,destination=/app" \
    org.label-schema.description="Nginx & PHP 7.4 - Docker ARMv8" \
    org.label-schema.name="txtdevs/nginx-php" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="txtdevs.com" \
    org.label-schema.vendor="Txt Devs" \
    org.label-schema.version="txtdevs/nginx-php:${PHP_VER}"
