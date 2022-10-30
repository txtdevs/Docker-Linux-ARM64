ARG PHP_VER=7.4-fpm
ARG PHP_REGISTRY=txtdevs/php

FROM --platform=$BUILDPLATFORM ${PHP_REGISTRY}:${PHP_VER}

ARG TARGETPLATFORM
ARG TARGETARCH

ENV WEB_DOCUMENT_ROOT=/app \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.test \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET=""
ENV WEB_PHP_SOCKET=127.0.0.1:9000

COPY conf/ /opt/docker/

RUN set -x \
    # Install apache
    && apt-install \
        apache2 \
		git \
    && sed -ri ' \
        s!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g; \
        s!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g; \
        ' /etc/apache2/apache2.conf \
    && rm -f /etc/apache2/sites-enabled/* \
    && a2enmod actions proxy proxy_fcgi ssl rewrite headers expires \
    && docker-run-bootstrap \
    && docker-image-cleanup

WORKDIR /app

EXPOSE 80 443

ARG BUILD_DATE
ARG IMAGE_PATCH_VER=0

LABEL \
    org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.application="Apache & PHP 7.4" \
    org.label-schema.docker.cmd="docker run -d -p 80:80 -p 443:443 -v /var/run/docker.sock:/var/run/docker.sock --mount source=apache-php-txtdevs,destination=/app" \
    org.label-schema.description="Apache & PHP 7.4 - Docker ARMv8" \
    org.label-schema.name="txtdevs/apache-php" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="txtdevs.com" \
    org.label-schema.vendor="Txt Devs" \
    org.label-schema.version="txtdevs/apache-php:${PHP_VER}"
