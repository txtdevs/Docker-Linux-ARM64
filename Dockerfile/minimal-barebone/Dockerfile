FROM alpine:latest

ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETDIR="/"
ARG GOREPLACE_VERSION="22.10.0"
ARG GOSU_VERSION="1.14"

COPY barebone/ "$TARGETDIR"

RUN apk add --no-cache \
        ca-certificates \
        openssl \
        curl \
        bash \
        sed \
        wget \
        zip \
        unzip \
        bzip2 \
        p7zip \
        drill \
        ldns \
        openssh-client \
        rsync \
        git \
        gnupg \
    ## Install go-replace
    && wget -O "/usr/local/bin/go-replace" "https://github.com/webdevops/go-replace/releases/download/$GOREPLACE_VERSION/go-replace.linux.$TARGETARCH" \
    && chmod +x "/usr/local/bin/go-replace" \
    && "/usr/local/bin/go-replace" --version \
	# Install gosu
	&& wget -O "/sbin/gosu" "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$TARGETARCH" \
    && chmod +x "/sbin/gosu" \
	&& find /var/lib/apk/ -mindepth 1 -delete
