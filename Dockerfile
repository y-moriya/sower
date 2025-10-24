FROM  perl:5-slim
SHELL ["/bin/bash", "-c"]
# Install locales and required packages, then generate ja_JP.SJIS locale
RUN apt-get -y update && apt-get -y install --no-install-recommends \
                locales \
                apache2 \
                curl \
                vim \
                git \
                perltidy \
                lftp \
        && grep -q '^ja_JP.SJIS' /etc/locale.gen || echo 'ja_JP.SJIS SJIS' >> /etc/locale.gen \
        && locale-gen ja_JP.SJIS \
        && rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

# Set Shift_JIS locale as default inside the image
ENV LANG=ja_JP.SJIS
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.SJIS

RUN a2enmod cgi
RUN echo "ScriptSock /var/run/cgid.sock" >> /etc/apache2/httpd.conf
RUN sed -ri -e 's!/cgi-bin/ /usr/lib/cgi-bin/!/sower /workspaces/sower/!g' /etc/apache2/conf-enabled/serve-cgi-bin.conf \
        -ri -e 's!"/usr/lib/cgi-bin"!"/workspaces/sower"!' /etc/apache2/conf-enabled/serve-cgi-bin.conf
EXPOSE 80
