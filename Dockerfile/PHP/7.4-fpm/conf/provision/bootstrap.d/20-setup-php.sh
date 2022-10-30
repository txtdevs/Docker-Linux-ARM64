#!/usr/bin/env bash

case "$IMAGE_FAMILY" in
    Debian|Ubuntu)
        # Register txtdevs ini
        ln -sf "/opt/docker/etc/php/php.txtdevs.ini" "${PHP_ETC_DIR}/conf.d/98-base.ini"

        # Register custom php ini
        ln -sf "/opt/docker/etc/php/php.ini" "${PHP_ETC_DIR}/conf.d/99-docker-custom.ini"
        ;;
esac
