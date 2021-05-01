FROM  perl:5-slim
SHELL ["/bin/bash", "-c"]
RUN apt-get -y update && apt-get -y install apache2 vim git perltidy

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

RUN a2enmod cgi
RUN echo "ScriptSock /var/run/cgid.sock" >> /etc/apache2/httpd.conf
RUN sed -ri -e 's!/cgi-bin/ /usr/lib/cgi-bin/!/sower /workspaces/sower/!g' /etc/apache2/conf-enabled/serve-cgi-bin.conf \
        -ri -e 's!"/usr/lib/cgi-bin"!"/workspaces/sower"!' /etc/apache2/conf-enabled/serve-cgi-bin.conf
COPY ./doc /var/www/html/

EXPOSE 80