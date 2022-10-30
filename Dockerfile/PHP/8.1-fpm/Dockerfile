#Multi-platform images for PHP 8.1
FROM --platform=$BUILDPLATFORM txtdevs/barebone:minimal AS barebone
RUN mkdir -p \
        /barebone/sbin \
        /barebone/usr/local/bin \
		&& cp -r /usr/local/bin/ /barebone/usr/local/ \
		&& cp /sbin/gosu /barebone/sbin/gosu

FROM --platform=$BUILDPLATFORM php:8.1-fpm-bullseye

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETARCH

LABEL maintainer="contact@txtdevs.com" \
      vendor=TxtDevs
LABEL com.txtdevs.docker-php="PHP 8.1 for $BUILDPLATFORM"
LABEL version="1.0" description="PHP 8.1 docker from TxtDevs"

ENV TERM="xterm" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8"
ENV DOCKER_CONF_HOME=/opt/docker/ \
    LOG_STDOUT="" \
    LOG_STDERR=""
ENV DEVS_USER=dev \
    DEVS_GROUP=dev \
    DEVS_PATH=/app \
    DEVS_UID=1000 \
    DEVS_GID=1000
ENV PHP_SENDMAIL_PATH="/usr/sbin/sendmail -t -i"
ENV COMPOSER_VERSION="2"

# barebone copy (from staged image)
COPY --from=barebone /barebone /


COPY conf/ /opt/docker/

RUN set -x \
    # Init bootstrap
    && apt-update \
    && /usr/local/bin/generate-dockerimage-info \
    # Enable non-free
    && sed -ri "s/(deb.*\/debian $(docker-image-info dist-codename) main)/\1 contrib non-free /" -- "/etc/apt/sources.list" \
    && apt-update \
    # System update
    && /usr/local/bin/apt-upgrade \
    # Base stuff
    && apt-install \
    	apt-transport-https \
        ca-certificates \
        locales \
        gnupg

RUN set -x \
    # Install packages
    && chmod +x /opt/docker/bin/* \
    && apt-install \
        supervisor \
        wget \
        curl \
        vim \
        net-tools \
        tzdata \
		git \
    && chmod +s /sbin/gosu \
    && docker-run-bootstrap \
    && docker-image-cleanup

RUN set -x \
    # Install services
    && apt-install \
        # Install common tools
        zip \
        unzip \
        bzip2 \
        moreutils \
        dnsutils \
        openssh-client \
        rsync \
        patch \
    && /usr/local/bin/generate-locales \
    && docker-run-bootstrap \
    && docker-image-cleanup

RUN set -x \
    # Install php environment
    &&  apt-install \
        # Install tools
        imagemagick \
        jpegoptim \
        libjpeg-turbo-progs \
        pngcrush \
        optipng \
        apngopt \
        pngnq \
        pngquant \
        # Libraries
        libxslt1.1 \
        zlib1g \
        libpq5 \
        libpng16-16 \
        libmcrypt4 \
        libzip4 \
		libcgicc-dev \
		libcgicc3 \
		zlib1g-dev \
        # Dev and headers
        libjpeg62-turbo-dev \
        libwebp-dev \
        libfreetype6-dev \
        libbz2-dev \
        libicu-dev \
        libldb-dev \
        libmcrypt-dev \
        libxml2-dev \
        libxslt1-dev \
        libmemcached-dev \
        libpng-dev \
        libpq-dev \
        libzip-dev \
        libc-client-dev \
        libc-client2007e-dev \
        libkrb5-dev \
        libmagick++-dev \
    # Install extensions
    && PKG_CONFIG_PATH=/usr/local docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-jpeg --with-freetype --with-webp \
    && git clone --branch master --depth 1 https://github.com/Imagick/imagick.git /usr/src/php/ext/imagick \
    && PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
	&& cd /usr/src/php/ext/ \
	&& pecl bundle igbinary \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        bz2 \
        calendar \
        exif \
        intl \
        gettext \
        mysqli \
        imap \
        pcntl \
        pdo_mysql \
        soap \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \
        shmop \
        xsl \
        zip \
        gd \
        gettext \
        opcache \
		igbinary \
	&& mkdir -p /usr/src/php/ext/ \
	&& cd /usr/src/php/ext/ \
	&& pecl bundle redis \
	&& pecl bundle msgpack \
	&& docker-php-ext-configure redis --enable-redis-igbinary --enable-redis-lzf \
	&& docker-php-ext-install redis msgpack\
	&& cd - \
	# Uninstall dev and header packages
    && apt-get purge -y -f --force-yes \
        libc-client-dev \
        libkrb5-dev \
        libbz2-dev \
        libicu-dev \
        libldb-dev \
        libmcrypt-dev \
        libxml2-dev \
        libxslt1-dev \
        zlib1g-dev \
        libpng-dev \
        libwebp-dev \
        libpq-dev \
        libzip-dev \
        libmagick++-dev \
	&& apt-get autoremove -y \
    && rm -f /usr/local/etc/php-fpm.d/zz-docker.conf \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer2 \
    && ln -sf /usr/local/bin/composer2 /usr/local/bin/composer \
    # Enable php services
    && docker-service enable syslog \
    && docker-service enable cron \
    && docker-run-bootstrap \
    && docker-image-cleanup

WORKDIR /
EXPOSE 9000
ENTRYPOINT ["/entrypoint"]
CMD ["supervisord"]
