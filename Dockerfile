FROM alpine:3.10

# Setup apache and php
RUN apk --update \
    add apache2 \
    curl \
    php7-apache2 \
    php7-bcmath \
    php7-bz2 \
    php7-calendar \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-gd \
    php7-iconv \
    php7-json \
    php7-mbstring \
    php7-mcrypt \
    php7-mysqlnd \
    php7-openssl \
    php7-pdo_mysql \
    php7-pdo_pgsql \
    php7-pdo_sqlite \
    php7-phar \
    php7-xml \
    php7-xmlrpc \
    php7-zlib \
    php7-session && \
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
    sed -i 's/memory_limit = .*/memory_limit = 128M/' /etc/php7/php.ini && \
    sed -i 's/post_max_size = .*/post_max_size = 128M/' /etc/php7/php.ini && \
    sed -i 's/upload_max_filesize = .*/upload_max_filesize = 128M/' /etc/php7/php.ini && \
    sed -i "s/^;date.timezone =$/date.timezone = \"Europe\/Prague\"/" /etc/php7/php.ini && \
    # logging to stdout
    ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log && \
    # adminer download
    curl -L -o /var/www/html/index.php https://github.com/vrana/adminer/releases/download/v4.7.2/adminer-4.7.2.php

EXPOSE 80

ENTRYPOINT ["httpd","-D","FOREGROUND"]
