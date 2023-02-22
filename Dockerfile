FROM alpine AS builder
WORKDIR /var/www/html/
RUN apk add --update git && \
    mkdir tmp && \
    cd tmp && \
    git clone https://github.com/vrana/adminer.git && \
    cd adminer && \
    git fetch --all --tags && \
    git checkout tags/v4.8.1 && \
    sed -i 's/git:/https:/g' .gitmodules && \
    git submodule update --init --recursive && \
    cd ../.. && \
    mv tmp/adminer/* . && \
    rm -rf tmp

FROM alpine

# Setup apache and php
RUN apk update && apk upgrade --available && \
    apk add apache2 \
    curl \
    php81-apache2 \
    php81-bcmath \
    php81-bz2 \
    php81-calendar \
    php81-ctype \
    php81-curl \
    php81-dom \
    php81-gd \
    php81-iconv \
    php81-mbstring \
    php81-mysqlnd \
    php81-openssl \
    php81-pdo_mysql \
    php81-pdo_pgsql \
    php81-pdo_sqlite \
    php81-phar \
    php81-xml \
    php81-session && \
    rm -f /var/cache/apk/* && \
    mkdir -p /opt/utils && \
    mkdir -p /var/www/html && \
    # apache settings
    sed -i 's/#ServerAdmin\ you@example.com/ServerAdmin\ you@example.com/' /etc/apache2/httpd.conf && \
    sed -i 's/#ServerName\ www.example.com:80/ServerName\ www.example.com:80/' /etc/apache2/httpd.conf && \
    sed -i 's#^DocumentRoot ".*#DocumentRoot "/var/www/html"#g' /etc/apache2/httpd.conf && \
    sed -i 's#Directory "/var/www/localhost/htdocs"#Directory "/var/www/html"#g' /etc/apache2/httpd.conf && \
    sed -i 's#AllowOverride None#AllowOverride All#' /etc/apache2/httpd.conf && \
    sed -i 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/' /etc/apache2/httpd.conf && \
    sed -i 's/#LoadModule\ deflate_module/LoadModule\ deflate_module/' /etc/apache2/httpd.conf && \
    sed -i 's/#LoadModule\ expires_module/LoadModule\ expires_module/' /etc/apache2/httpd.conf && \
    sed -i 's#KeepAliveTimeout 5#KeepAliveTimeout 100#' /etc/apache2/conf.d/default.conf && \
    sed -i 's/memory_limit = .*/memory_limit = 128M/' /etc/php81/php.ini && \
    sed -i 's/post_max_size = .*/post_max_size = 128M/' /etc/php81/php.ini && \
    sed -i 's/upload_max_filesize = .*/upload_max_filesize = 128M/' /etc/php81/php.ini && \
    sed -i 's/memory_limit = 128M/memory_limit = 1024M/' /etc/php81/php.ini && \
    sed -i "s/^;date.timezone =$/date.timezone = \"Europe\/Prague\"/" /etc/php81/php.ini && \
    # logging to stdout
    ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

COPY --from=builder /var/www/html/ /var/www/html/
COPY index.php /var/www/html/index.php

EXPOSE 80

ENTRYPOINT ["httpd","-D","FOREGROUND"]
