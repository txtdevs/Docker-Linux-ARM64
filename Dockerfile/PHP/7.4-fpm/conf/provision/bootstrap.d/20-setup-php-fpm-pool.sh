#!/usr/bin/env bash

# Rename pool file file to dev.conf
if [[ ! -f "/opt/docker/etc/php/fpm/pool.d/dev.conf" ]]; then
    # Move php-fpm pool directory file to /opt/docker/etc/php/
    mv -- "$PHP_POOL_DIR"  /opt/docker/etc/php/fpm/pool.d

    mv -- "/opt/docker/etc/php/fpm/pool.d/${PHP_POOL_CONF}" /opt/docker/etc/php/fpm/pool.d/dev.conf
fi

# Remove php-fpm pool directory
rm -rf -- "$PHP_POOL_DIR"

# Symlink php-fpm pool file to original destination
ln -sf -- /opt/docker/etc/php/fpm/pool.d "$PHP_POOL_DIR"

# Configure php-fpm pool (dev.conf)
go-replace --mode=lineinfile --regex \
    -s '^[\s;]*catch_workers_output[\s]*='          -r 'catch_workers_output = yes' \
    -s '^[\s;]*access.format[\s]*='                 -r 'access.format = "[php-fpm:access] %R - %u %t \"%m %r%Q%q\" %s %f %{mili}d %{kilo}M %C%%"' \
    -s '^[\s;]*access.log[\s]*='                    -r 'access.log = /docker.stdout' \
    -s '^[\s;]*slowlog[\s]*='                       -r 'slowlog = /docker.stderr' \
    -s '^[\s;]*php_admin_value\[error_log\][\s]*='  -r 'php_admin_value[error_log] = /docker.stderr' \
    -s '^[\s;]*php_admin_value\[log_errors\][\s]*=' -r 'php_admin_value[log_errors] = on' \
    -s '^[\s;]*listen.allowed_clients[\s]*='        -r ";listen.allowed_clients" \
    -- /opt/docker/etc/php/fpm/pool.d/dev.conf

# Fix user setting
go-replace --mode=line --regex \
    -s '^[\s;]*user[\s]*='  -r "user = $DEVS_USER" \
    -s '^[\s;]*group[\s]*=' -r "group = $DEVS_GROUP" \
    --path=/opt/docker/etc/php/fpm/ \
    --path-pattern='*.conf'

if [[ "$PHP_CLEAR_ENV_AVAILABLE" -eq 1 ]]; then
    # Clear env setting available, disable clearing of environment variables
    go-replace --mode=lineinfile --regex \
        -s '^[\s;]*clear_env[\s]*='                        -r 'clear_env = no' \
        -- /opt/docker/etc/php/fpm/pool.d/dev.conf
    rm -f /opt/docker/bin/service.d/php-fpm.d/11-clear-env.sh
else
    # Append clear env workaround in php-fpm pool (old php-fpm versions)
    echo ';#CLEAR_ENV_WORKAROUND#' >> /opt/docker/etc/php/fpm/pool.d/dev.conf

fi
